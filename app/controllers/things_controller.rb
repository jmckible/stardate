class ThingsController < ApplicationController

  def index
    @things = Current.user.things_during((Time.zone.now.to_date - 4)..Time.zone.now.to_date)
    @month  = (Time.zone.today - 30)..Time.zone.today

    # Preload data for spending graph to avoid N+1 queries
    month_start = @month.first - 1.month
    transactions = Current.household.transactions
                          .includes(:debit, :credit)
                          .where(transactions: { date: month_start..@month.last })
                          .where(exceptional: false)
                          .to_a

    # Calculate cumulative expenses for each day
    @expense_data = @month.map do |date|
      transactions
        .select { |t| t.date.between?(@month.first, date) && t.debit&.ledger == 'expense' }
        .sum(&:amount)
    end

    # Calculate cumulative income for each day
    @income_data = @month.map do |date|
      transactions
        .select { |t| t.date.between?(@month.first, date) && t.credit&.ledger == 'income' }
        .sum(&:amount)
    end

    # Preload workouts for workout graph
    workouts = Current.user.workouts.during(@month).to_a
    @workout_data = @month.map do |date|
      workouts.select { |w| w.date == date }.sum(&:minutes)
    end

    # Preload weights for health graph
    weights = Current.user.weights.during(@month).to_a
    @weight_data = @month.map do |date|
      weight = weights.find { |w| w.date == date }
      weight ? weight.weight.to_f : nil
    end

    # Check if we have health data
    @has_health_data = workouts.any? || weights.any?

    # Preload dashboard accounts with their balances computed in SQL
    @dashboard_accounts = Current.household.accounts.dashboard.with_balances.to_a
    @budget_categories = @dashboard_accounts.map { |a| a.name.gsub(' Deferral', '') }
    @budget_balances = @dashboard_accounts.map do |account|
      amount = account.balance
      { y: amount, color: (amount.negative? ? '#FF00CC' : '#00CCFF') }
    end
  end

  def new
    render layout: false
  end

  def create
    @thing = Grammar.parse params[:thing], Current.user
    @thing.user = Current.user
    @thing.save!
    redirect_to root_url
  end

end
