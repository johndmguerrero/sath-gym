# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Sath Gym is a Rails 8.0.3 application using:
- **Ruby**: 3.4.4
- **Database**: PostgreSQL with Solid adapters (solid_cache, solid_queue, solid_cable)
- **Frontend**: Hotwire (Turbo + Stimulus) + Importmap for JavaScript
- **Styling**: CSS Zero + Tailwind CSS 4.3
- **Asset Pipeline**: Propshaft
- **Deployment**: Kamal with Docker support

## Development Commands

### Initial Setup
```bash
bin/setup
# Installs dependencies, prepares database, and starts the dev server
```

### Running the Application
```bash
bin/dev
# Starts both the Rails server (port 3000) and Tailwind CSS watcher via Foreman
```

Or run processes individually:
```bash
bin/rails server          # Web server only
bin/rails tailwindcss:watch  # Tailwind watcher only
```

### Database
```bash
bin/rails db:prepare      # Create, migrate, and seed database
bin/rails db:migrate      # Run pending migrations
bin/rails db:rollback     # Rollback last migration
bin/rails db:reset        # Drop, create, migrate, and seed
```

### Testing
```bash
bin/rails test                           # Run all tests
bin/rails test test/models/user_test.rb  # Run specific test file
bin/rails test:system                    # Run system tests (Capybara + Selenium)
```

### Code Quality
```bash
bin/rubocop                              # Run linter
bin/rubocop -a                           # Auto-fix violations
bin/brakeman                             # Security vulnerability scan
```

### Asset Management
```bash
bin/importmap pin <package>              # Add JavaScript package via importmap
bin/rails assets:precompile              # Precompile assets (production)
```

## Architecture

### CSS Organization
This project uses **CSS Zero** as the base styling framework with **Tailwind CSS** for utilities. The CSS architecture follows a component-based approach:

- `app/assets/stylesheets/application.css` - Manifest file (no preprocessing with Propshaft)
- CSS Zero provides: `reset.css`, `variables.css`, `utilities.css` (loaded in specific order in layout)
- Component-specific CSS files: `alert.css`, `button.css`, `flash.css`, `input.css`, `sidebar_menu.css`, `layouts.css`, `icons.css`
- Tailwind watcher runs automatically via `bin/dev` to generate utility classes

**Important**: CSS is loaded in this order in `app/views/layouts/application.html.erb`:
1. CSS Zero reset
2. CSS Zero variables
3. Application styles (`:app` - all component CSS files)
4. CSS Zero utilities (highest precedence)

### JavaScript Architecture
- **Importmap** manages dependencies (no npm/webpack/bundler)
- **Turbo** handles SPA-like navigation and real-time updates
- **Stimulus** controllers for JavaScript behavior (located in `app/javascript/controllers/`)
- Add new JS packages: `bin/importmap pin <package-name>`

### Database Configuration
Uses Rails 8 Solid adapters for modern database-backed infrastructure:
- **Solid Cache**: Database-backed cache (replaces Redis/Memcached)
- **Solid Queue**: Database-backed job queue (replaces Sidekiq/Resque)
- **Solid Cable**: Database-backed Action Cable (WebSocket connections)

Schema files: `db/cache_schema.rb`, `db/queue_schema.rb`, `db/cable_schema.rb`

### Layout Structure
The application uses a sidebar layout pattern defined in `app/views/layouts/application.html.erb`:
- Main layout: `.header-layout` wrapper with `.sidebar-layout` container
- Sidebar: `<aside id="sidebar">` with `_sidebar_menu` partial
- Main content: `<main id="main">` with optional `_mobile_menu` partial
- SVG icons stored in `app/assets/images/` (e.g., `menu.svg`, `search.svg`, etc.)

### Deployment
- **Kamal** configuration in `.kamal/` directory
- **Docker**: `Dockerfile` and `.dockerignore` configured for containerized deployment
- **Thruster**: HTTP asset caching/compression for Puma

## Code Style
- Follows **Rubocop Rails Omakase** style guide
- Configuration in `.rubocop.yml`
- Run `bin/rubocop` before committing changes

## Module Name
The Rails application module is `SathGym` (defined in `config/application.rb`)
