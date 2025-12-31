# AI Agent Development Guide

This document captures important context and workflows for AI agents working on this codebase.

## System Architecture

### Budget & Envelope System

This is a double-entry bookkeeping system using envelope-style budgeting.

**Key Concepts:**
- **Savings Accounts** = Budget envelopes (earmarked asset accounts)
- **Accruing Accounts** = Build up balance for large periodic expenses (Tax, Insurance, Travel, etc.)
- **Non-Accruing Accounts** = Reset to budget each period, variance tracked (e.g. Food, Gas, Administrivia)
- **Accrued Savings** = Special account that tracks cumulative budget performance

**Transaction Flow:**
1. Most purchases: Credit Card (liability) → Expense Account
2. Credit card payment: Checking Account → Credit Card
3. Bi-weekly funding (1st & 15th): Checking → Savings Accounts

**Variance Tracking (Every 2 Weeks):**
1. Accruing accounts: Add budget amount, balance accumulates
2. Non-accruing accounts: Check balance, transfer variance to/from Accrued Savings, reset to budget
3. Accrued Savings balance shows overall budget performance:
   - Positive = living below budget ✓
   - Negative = overspending
   - Zero = exactly on budget

### Budget Methodology

Budgets are based on actual 12-month spending patterns (non-exceptional transactions only).

**Exceptional Transactions:**
- Marked with `exceptional: true` flag
- Excluded from budget planning
- Examples: One-time large purchases, asset appreciation, irregular tax payments

## Development Workflow

### Code Changes

**DO NOT automatically:**
- Create git commits
- Deploy to production
- Push to remote

**Always ask first** before:
- Deploying to fly.io
- Making database changes in production
- Committing code

### Deployment Process

**Environment:**
- Production hosted on fly.io
- Deploy command: `fly deploy`
- SSH to production: `fly ssh console --command 'bin/rails runner "..."'`

**Production Database Changes:**
Use `fly ssh console` for Rails commands:
```bash
fly ssh console --command 'bin/rails runner "
  # Ruby code here
"'
```

### Testing Budget Changes

**Development Database:**
- Analysis should be done on dev database
- Dev database contains copy of production data
- Safe to experiment with

**Production Changes:**
- Only make changes after testing in dev
- Always create backup logs
- Document rollback procedures

## Key Files

### Budget System
- `lib/tasks/accounts.rake` - Bi-weekly funding with variance tracking
- `app/models/account.rb` - Account model with `fund` method
- `app/models/household.rb` - Household aggregations and calculations
- `app/models/transaction.rb` - Double-entry transactions

### Views
- `app/views/things/index.html.haml` - Home page with budget performance display

## Common Tasks

### Analyzing Spending
```ruby
household = Household.first # or find by specific criteria
start_date = 1.year.ago
end_date = Date.today

# Get spending by category (non-exceptional)
household.transactions
  .where("date >= ? AND date <= ?", start_date, end_date)
  .where(exceptional: false)
  .joins("LEFT JOIN accounts ON transactions.debit_id = accounts.id")
  .where(accounts: { ledger: "expense" })
  .group("accounts.name")
  .sum(:amount)
```

### Updating Budgets
```ruby
# Update single account
account = Account.find_by(name: 'Food Savings')
account.update!(budget: 2300)

# Create new savings account
household.accounts.create!(
  name: 'New Category Savings',
  ledger: :asset,
  earmark: true,
  accruing: true,     # or false for non-accruing
  dashboard: false,   # true to show on home page
  budget: 100
)
```

### Testing Rake Tasks
```bash
# Run funding task (normally runs on 1st and 15th)
bin/rails accounts:fund
```

## Linting

- Ruby files: `bin/rubocop <file>`
- HAML files: Rubocop errors are expected, ignore them

## Important Notes

### Asset Appreciation
- Marked-to-market accounting entries for asset value changes
- NOT considered income for budgeting purposes
- Always marked as exceptional transactions

### Expense Categories
- Various expense categories exist for different spending types
- Some categories are meant for specific purposes (clothing vs. childcare vs. education)
- Check existing category usage before creating new ones

### Tax Handling
- Property taxes typically paid semi-annually or quarterly
- Tax preparation expenses are annual
- Supplemental tax bills may occur during home purchases but are one-time

### Home-Related Spending Categories
- **Maintenance & Cleaning**: Regular upkeep, appliances, cleaning
- **Major Purchase**: Large improvement projects (funded separately)
- **Outdoor Projects**: Yard, garden, and outdoor improvements
- **Interior Decorating**: Indoor aesthetics and decor

## Historical Context

### Recent System Improvements (December 2025)

**Budget Realignment:**
- Analyzed historical spending patterns (excluding exceptional transactions)
- Updated budget amounts to align with actual spending
- Created new savings accounts for previously unbudgeted categories
- Implemented variance tracking via Accrued Savings account
- Balanced total budgets with regular income

**System Improvements:**
- Enhanced `accounts:fund` rake task with variance tracking
- Removed obsolete `biweekly_budget_balance` and `last_period_budget_balance` methods
- Added `accrued_savings_balance` method for clean budget performance metric
- Updated home page to display "Budget Performance" using Accrued Savings balance

## Questions to Ask

Before making budget changes:
1. Should this be based on actual spending or a target to achieve?
2. Is this expense exceptional (one-time) or recurring?
3. Should this category accrue or reset bi-weekly?
4. What time period should we analyze? (exclude house purchase period if relevant)

Before deploying:
1. Have changes been tested in development?
2. Do we have backup logs?
3. Is there a rollback plan?
4. Should this wait for a specific time (e.g., not during active use)?
