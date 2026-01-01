namespace :db do
  namespace :analyze do
    desc "Show tables with high sequential scan rates (potential missing indexes)"
    task tables: :environment do
      results = ActiveRecord::Base.connection.execute(<<~SQL)
        SELECT
          schemaname,
          relname as tablename,
          seq_scan,
          seq_tup_read,
          idx_scan,
          n_live_tup,
          CASE
            WHEN seq_scan = 0 THEN 0
            ELSE ROUND(seq_tup_read::numeric / seq_scan, 2)
          END as avg_seq_tuples_per_scan,
          CASE
            WHEN (seq_scan + idx_scan) = 0 THEN 0
            ELSE ROUND(100.0 * seq_scan / (seq_scan + idx_scan), 2)
          END as seq_scan_pct
        FROM pg_stat_user_tables
        WHERE seq_scan > 0
          OR idx_scan > 0
        ORDER BY seq_tup_read DESC
        LIMIT 20;
      SQL

      puts "\n" + "=" * 100
      puts "TABLES WITH SEQUENTIAL SCANS (Potential Missing Indexes)"
      puts "=" * 100
      puts "High seq_scan or avg_seq_tuples_per_scan indicates missing indexes"
      puts "-" * 100

      format = "%-20s %12s %15s %12s %12s %20s %12s"
      puts format % ["Table", "Seq Scans", "Seq Tuples Read", "Index Scans", "Live Rows", "Avg Tuples/Seq Scan", "Seq Scan %"]
      puts "-" * 100

      results.each do |row|
        puts format % [
          row["tablename"],
          row["seq_scan"],
          row["seq_tup_read"],
          row["idx_scan"],
          row["n_live_tup"],
          row["avg_seq_tuples_per_scan"],
          "#{row['seq_scan_pct']}%"
        ]
      end
      puts "=" * 100 + "\n"
    end

    desc "Show index usage statistics (find unused or rarely used indexes)"
    task indexes: :environment do
      results = ActiveRecord::Base.connection.execute(<<~SQL)
        SELECT
          schemaname,
          relname as tablename,
          indexrelname as indexname,
          idx_scan,
          idx_tup_read,
          idx_tup_fetch,
          pg_size_pretty(pg_relation_size(indexrelid)) as index_size
        FROM pg_stat_user_indexes
        ORDER BY idx_scan ASC, pg_relation_size(indexrelid) DESC
        LIMIT 30;
      SQL

      puts "\n" + "=" * 100
      puts "INDEX USAGE STATISTICS (Unused or Rarely Used Indexes)"
      puts "=" * 100
      puts "Low idx_scan indicates the index is rarely used and might be redundant"
      puts "-" * 100

      format = "%-20s %-40s %12s %15s %15s %12s"
      puts format % ["Table", "Index", "Scans", "Tuples Read", "Tuples Fetched", "Size"]
      puts "-" * 100

      results.each do |row|
        puts format % [
          row["tablename"],
          row["indexname"],
          row["idx_scan"],
          row["idx_tup_read"],
          row["idx_tup_fetch"],
          row["index_size"]
        ]
      end
      puts "=" * 100 + "\n"
    end

    desc "Show cache hit ratio (should be > 99%)"
    task cache: :environment do
      results = ActiveRecord::Base.connection.execute(<<~SQL)
        SELECT
          sum(heap_blks_read) as heap_read,
          sum(heap_blks_hit) as heap_hit,
          CASE
            WHEN sum(heap_blks_hit) + sum(heap_blks_read) = 0 THEN 0
            ELSE ROUND(100.0 * sum(heap_blks_hit) / (sum(heap_blks_hit) + sum(heap_blks_read)), 2)
          END as cache_hit_ratio
        FROM pg_statio_user_tables;
      SQL

      puts "\n" + "=" * 80
      puts "DATABASE CACHE HIT RATIO"
      puts "=" * 80

      row = results.first
      cache_ratio = row["cache_hit_ratio"].to_f

      puts "Heap Blocks Read (disk):  #{row['heap_read']}"
      puts "Heap Blocks Hit (cache):  #{row['heap_hit']}"
      puts "Cache Hit Ratio:          #{cache_ratio}%"
      puts ""

      if cache_ratio > 99
        puts "✓ Excellent cache performance!"
      elsif cache_ratio > 95
        puts "⚠ Good, but could be better. Consider increasing shared_buffers."
      else
        puts "✗ Poor cache performance. Increase shared_buffers or investigate query patterns."
      end
      puts "=" * 80 + "\n"
    end

    desc "Suggest composite indexes based on foreign key combinations"
    task suggest_composite: :environment do
      puts "\n" + "=" * 100
      puts "POTENTIAL COMPOSITE INDEX SUGGESTIONS"
      puts "=" * 100
      puts "Based on foreign key relationships in your schema"
      puts "-" * 100

      # Get all foreign keys
      tables = ActiveRecord::Base.connection.tables - ["schema_migrations", "ar_internal_metadata"]

      tables.each do |table|
        begin
          columns = ActiveRecord::Base.connection.columns(table)
          fk_columns = columns.select { |c| c.name.end_with?("_id") }.map(&:name)

          if fk_columns.size >= 2
            puts "\n#{table}:"
            puts "  Consider composite indexes for common query combinations:"
            fk_columns.combination(2).each do |col1, col2|
              puts "    add_index :#{table}, [:#{col1}, :#{col2}]"
            end
          end
        rescue => e
          # Skip tables that can't be introspected
        end
      end
      puts "\n" + "=" * 100 + "\n"
    end

    desc "Run all database analysis tasks"
    task all: :environment do
      Rake::Task["db:analyze:cache"].invoke
      Rake::Task["db:analyze:tables"].invoke
      Rake::Task["db:analyze:indexes"].invoke
      Rake::Task["db:analyze:suggest_composite"].invoke

      puts "\n" + "=" * 100
      puts "NEXT STEPS"
      puts "=" * 100
      puts "1. For specific slow queries, use: rails db:analyze:explain[\"YOUR QUERY HERE\"]"
      puts "2. Monitor production with: rails db:analyze:all"
      puts "3. Reset statistics with: rails db:analyze:reset (useful after adding indexes)"
      puts "=" * 100 + "\n"
    end

    desc "Explain a specific query"
    task :explain, [:query] => :environment do |t, args|
      if args[:query].blank?
        puts "\nUsage: rails db:analyze:explain[\"SELECT * FROM transactions WHERE user_id = 1\"]"
        puts "\nExample queries to analyze:"
        puts "  rails db:analyze:explain[\"SELECT * FROM transactions WHERE user_id = 1 AND date > '2024-01-01'\"]"
        puts "  rails db:analyze:explain[\"SELECT * FROM transactions JOIN accounts ON accounts.id = transactions.account_id\"]"
        exit
      end

      puts "\n" + "=" * 100
      puts "QUERY EXECUTION PLAN"
      puts "=" * 100
      puts "Query: #{args[:query]}"
      puts "-" * 100

      results = ActiveRecord::Base.connection.execute("EXPLAIN ANALYZE #{args[:query]}")
      results.each do |row|
        puts row.values.first
      end

      puts "\n" + "-" * 100
      puts "Look for:"
      puts "  • 'Seq Scan' = Missing index (BAD for large tables)"
      puts "  • 'Index Scan' or 'Index Only Scan' = Good!"
      puts "  • 'Bitmap Heap Scan' = Okay, but might benefit from better index"
      puts "  • High 'cost' or 'actual time' values = Slow query"
      puts "=" * 100 + "\n"
    end

    desc "Reset statistics (useful after adding indexes to get fresh data)"
    task reset: :environment do
      ActiveRecord::Base.connection.execute("SELECT pg_stat_reset();")
      puts "✓ Database statistics have been reset."
      puts "  Run your application for a while, then use 'rails db:analyze:all' to see fresh statistics."
    end
  end
end
