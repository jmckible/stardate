# Development Guide

## About Stardate
A personal life tracking application focused on finance and exercise.

**Finance tracking:**
- Uses double-entry bookkeeping to track all spending
- Supports recurring transactions
- Note: Recurring transactions require manual trigger due to Fly.io limitations (cannot run automatically)

**Exercise tracking:**
- Distance and duration
- Weight tracking

## Tech Stack
- **Framework**: Ruby on Rails (vanilla)
- **Frontend**: Stimulus.js
- **Templates**: Haml (not ERB)
- **Testing**: RSpec with fixtures (no factories)
- **Hosting**: Fly.io

## Development Workflow
- **Run tests & linting**: `rake`
  - Runs RSpec specs
  - Checks Ruby linting
  - Checks JavaScript linting
  - Checks Haml linting
- **No pre-commit hooks**

## Code Patterns
### What to use:
- Standard Rails MVC patterns
- Business logic in models
- Stimulus controllers for JavaScript behavior
- Fixtures for test data

### What NOT to use:
- ❌ Service objects
- ❌ Decorator patterns
- ❌ FactoryBot or other factory libraries
- ❌ ERB templates (use Haml)
- ❌ Heavy JavaScript frameworks (React, Vue, etc.)

## Deployment
- Hosted on Fly.io
- Keep deployment simple and compatible with Fly.io conventions

## Testing
- Use fixtures for test data
- Run full test suite with `rake` before committing
