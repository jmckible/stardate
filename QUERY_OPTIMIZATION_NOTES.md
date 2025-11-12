# Query Optimization Analysis - 2025-11-12

## Executive Summary

Analysis revealed 98.83% sequential scan rate on transactions table (173M tuples read). Added composite indexes to reduce this to < 10%.

## Key Problems Identified

### 1. Query 5: Household.expense_accounts (7.3ms - WORST)
**Location**: `app/models/household.rb:14-20`

**Problem**: Full table scan on transactions (25,445 rows)
```ruby
has_many :expense_accounts, ->{
  select('accounts.*, COUNT(debit_id) AS transaction_count, SUM(amount) AS total')
  .where(accounts: { ledger: 'expense'})
  .group('accounts.id')
  .order(total: :desc)
}, through: :transactions, source: :debit
```

**Generated SQL**:
```sql
SELECT accounts.*, COUNT(debit_id) AS transaction_count, SUM(amount) AS total
FROM accounts INNER JOIN transactions ON accounts.id = transactions.debit_id
WHERE transactions.household_id = 1 AND accounts.ledger = 2
GROUP BY accounts.id ORDER BY total DESC
```

**Why it's slow**: No date filter, so can't use date index. Filters only by household_id.

**Solution**: Composite index `[:household_id, :debit_id]` - Expected improvement: 7.3ms → ~0.5ms

---

### 2. Query 3: Account#transactions (2.9ms)
**Location**: `app/models/account.rb:13-15`

**Problem**: OR clause prevents index usage
```ruby
def transactions
  household.transactions.where('debit_id = ? OR credit_id = ?', id, id)
end
```

**Why it's slow**: PostgreSQL can't use indexes efficiently with OR. Scans date index and filters 10,031 rows.

**Solutions**:
1. **Best**: Use UNION of two indexed queries:
```ruby
def transactions
  debit_txns = household.transactions.where(debit_id: id)
  credit_txns = household.transactions.where(credit_id: id)
  Transaction.from("(#{debit_txns.to_sql} UNION #{credit_txns.to_sql}) AS transactions")
end
```

2. **Alternative**: Add composite indexes `[:household_id, :debit_id]` and `[:household_id, :credit_id]` (already in migration)

Expected improvement: 2.9ms → ~0.3ms

---

### 3. Minor: Accounts Table Sequential Scans
**Problem**: Small table (114 rows), Postgres prefers seq scan

**Solution**: Add indexes on frequently joined columns:
- `accounts.ledger` (for expense/income queries)
- `accounts.household_id, ledger` (composite)

Impact: Minimal (already fast), but prevents future issues as table grows.

---

## Index Strategy

### Composite Indexes Added
1. `[:household_id, :date]` - Most critical, used in 80%+ of queries
2. `[:household_id, :debit_id]` - Improves account balance queries
3. `[:household_id, :credit_id]` - Improves account balance queries
4. `[:household_id, :exceptional, :date]` - Budget calculations
5. `[:household_id, :vendor_id, :date]` - Vendor-specific reports

### Why Composite Indexes?
PostgreSQL can use composite indexes when:
- Query filters on the leftmost column(s)
- Example: `[:household_id, :date]` works for:
  - `WHERE household_id = 1` ✅
  - `WHERE household_id = 1 AND date >= '2024-01-01'` ✅
  - `WHERE date >= '2024-01-01'` ❌ (can't use this index)

### Single-Column Indexes Kept
- `date` - For date-only queries
- `user_id`, `vendor_id`, `debit_id`, `credit_id`, `recurring_id` - Lookups
- `exceptional` - Boolean filtering

### Index Removed
- `household_id` (single) - Redundant with composite indexes

---

## Query Pattern Analysis

| Pattern | Frequency | Current Performance | After Indexes |
|---------|-----------|---------------------|---------------|
| `household.transactions.during(period)` | Very High | 0.68ms ✅ | 0.3ms (better) |
| `household.expense_accounts` | High | 7.3ms ❌ | ~0.5ms ✅ |
| `account.transactions` | High | 2.9ms ⚠️ | ~0.3ms ✅ |
| `transactions.expense_debit.sum` | High | 0.48ms ✅ | 0.2ms (better) |
| `transactions.from_vendor(v)` | Medium | Unknown | ~0.2ms ✅ |

---

## Code Changes Recommended (Optional)

### 1. Optimize Account#transactions (app/models/account.rb:13)
**Current**:
```ruby
def transactions
  household.transactions.where('debit_id = ? OR credit_id = ?', id, id)
end
```

**Optimized**:
```ruby
def transactions
  debit_txns = household.transactions.where(debit_id: id)
  credit_txns = household.transactions.where(credit_id: id)
  Transaction.from("(#{debit_txns.to_sql} UNION ALL #{credit_txns.to_sql}) AS transactions")
end
```

**Impact**: 2.9ms → 0.3ms (10x faster)

---

### 2. Add Date Filters to Aggregations (optional but recommended)
**Location**: `app/models/household.rb:14`

**Current**: Queries all transactions ever
**Consider**: Add date scope when appropriate:
```ruby
# In controllers/views, scope to relevant period:
@expense_accounts = household.expense_accounts.where(transactions: { date: 1.year.ago.. })
```

**Impact**: Reduces dataset size, improves performance

---

## Testing the Changes

### Before Running Migration
```bash
rails db:analyze:all
# Note the seq_scan numbers for transactions
```

### Run Migration
```bash
rails db:migrate
```

### Reset Stats and Test
```bash
rails db:analyze:reset
# Run your application normally for a few minutes
rails db:analyze:all
# Compare seq_scan numbers - should drop from 98.83% to < 10%
```

### Test Specific Queries
```bash
# Test Query 5
rails db:analyze:explain["SELECT accounts.*, COUNT(debit_id) AS transaction_count, SUM(amount) AS total FROM accounts INNER JOIN transactions ON accounts.id = transactions.debit_id WHERE transactions.household_id = 1 AND accounts.ledger = 2 GROUP BY accounts.id ORDER BY total DESC"]

# Should now show "Index Scan" instead of "Seq Scan"
```

---

## Expected Impact

- **Sequential scan rate**: 98.83% → < 10%
- **Avg query time**: ~2-3ms → ~0.3ms (6-10x improvement)
- **Worst query (expense_accounts)**: 7.3ms → ~0.5ms (14x improvement)
- **Page load times**: Reports/dashboard pages should be noticeably faster
- **Database load**: Reduced by 80%+ for transaction queries

---

## Monitoring

After deployment, monitor:
```bash
# Check index usage
rails db:analyze:indexes

# Look for unused indexes (idx_scan = 0)
# Consider removing if truly unused after 1-2 weeks
```

---

## Notes

- Development database has only 25,445 transactions
- Production will see even bigger improvements with more data
- Composite indexes slightly increase write time (negligible for this app)
- Total index size increase: ~2-3 MB (acceptable tradeoff)
