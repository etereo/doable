# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Doable is a Rails 8.0.2 todo management application with project organization. It uses Hotwire (Turbo + Stimulus) for interactive features, TailwindCSS for styling, and SQLite3 for data storage.

## Core Architecture

### Data Model
- **Project**: Container for todos. Has many todos (dependent: destroy). Validates name presence with custom message "Was forgotten?". Has an `active` boolean field.
- **Todo**: Belongs to a project. Has fields: name, description, completed (boolean), priority, project_id.

### Controllers
- **ProjectsController**: Standard CRUD operations. Uses Rails 8's new `params.expect` pattern for strong parameters.
- **TodosController**: Full REST resource with JSON response support. Uses before_action for DRY setup. Implements `params.expect` for strong parameters.

### Routes
- RESTful resources for both `/projects` and `/todos`
- Health check endpoint at `/up` for monitoring

### Frontend Stack
- **Hotwire**: Turbo for SPA-like navigation, Stimulus for JavaScript controllers
- **TailwindCSS 4.3**: Utility-first CSS framework
- **Importmap**: No Node.js required for JavaScript dependencies
- Basic Stimulus controller in [app/javascript/controllers/hello_controller.js](app/javascript/controllers/hello_controller.js)

## Development Commands

### Initial Setup
```bash
bin/setup
# Installs dependencies, prepares database, clears logs/tmp, and starts dev server
# Use --skip-server flag to skip starting the server
```

### Running the Application
```bash
bin/dev
# Runs both web server and TailwindCSS watcher (see Procfile.dev)
```

Or individually:
```bash
bin/rails server        # Web server only
bin/rails tailwindcss:watch  # CSS watcher only
```

### Database
```bash
bin/rails db:migrate         # Run pending migrations
bin/rails db:rollback        # Rollback last migration
bin/rails db:prepare         # Setup and migrate database (idempotent)
bin/rails db:reset          # Drop, create, migrate, and seed
```

### Testing
```bash
bin/rails test                    # Run all tests
bin/rails test test/models/project_test.rb  # Run specific test file
bin/rails test test/models/project_test.rb:10  # Run test at specific line
bin/rails test:system            # Run system tests (Capybara + Selenium)
```

### Code Quality
```bash
bin/rubocop                  # Run linter (Rails Omakase style)
bin/rubocop -a              # Auto-fix safe offenses
bin/brakeman                # Security vulnerability scanning
```

### Console & Jobs
```bash
bin/rails console           # Interactive Ruby console
bin/rails c                # Shorthand for console
bin/jobs                   # Solid Queue job management
```

## Rails 8 Specific Features

### Solid Stack
This app uses Rails 8's "Solid" adapters:
- **solid_cache**: Database-backed caching (configured in [config/cache.yml](config/cache.yml))
- **solid_queue**: Database-backed job processing (configured in [config/queue.yml](config/queue.yml))
- **solid_cable**: Database-backed Action Cable (configured in [config/cable.yml](config/cable.yml))

Production uses multiple SQLite databases (primary, cache, queue, cable) for different concerns as defined in [config/database.yml](config/database.yml).

### Modern Parameter Handling
Rails 8 uses `params.expect` instead of `params.require`:
```ruby
# Example from controllers
params.expect(project: [ :name ])
params.expect(todo: [ :name, :description, :completed, :priority, :project_id ])
```

## Deployment

### Kamal (Docker-based)
```bash
bin/kamal setup     # Initial server setup
bin/kamal deploy    # Deploy application
bin/kamal redeploy  # Rebuild and deploy
```

Configuration in [config/deploy.yml](config/deploy.yml). Uses Thruster for HTTP caching/compression.

## Important Files & Patterns

- **Recurring Jobs**: Configured in [config/recurring.yml](config/recurring.yml) for Solid Queue
- **Storage**: Active Storage configuration in [config/storage.yml](config/storage.yml)
- **Stimulus Controllers**: Located in [app/javascript/controllers/](app/javascript/controllers/)
- **Import Maps**: JavaScript dependencies managed in [config/importmap.rb](config/importmap.rb)

## Ruby Version
Ruby 3.4.2 (specified in [.ruby-version](.ruby-version))
