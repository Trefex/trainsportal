# Train Portal

A Ruby on Rails application for managing a model train collection. Features full-text search (Solr), image uploads (ActiveStorage + vips), pagination, Bootstrap 3 UI, and FontAwesome icons.

## Stack

| Component | Version |
|-----------|---------|
| Ruby | 3.4.9 |
| Rails | 8.1.3 |
| Database | SQLite3 |
| Search | Solr 6 (via sunspot_rails 2.7) |
| Images | ActiveStorage + vips |
| Auth | Devise |
| Java | temurin-21 (required for Solr) |

## Prerequisites

- [mise](https://mise.jdx.dev/) — manages Ruby and Java versions automatically via `.mise.toml`
- [vips](https://www.libvips.org/) — system library for image processing

```bash
# Install mise
curl https://mise.run | sh

# Install vips (macOS)
brew install vips

# Install vips (Debian/Ubuntu)
apt-get install libvips-tools
```

## Installation

```bash
git clone https://github.com/Trefex/trainsportal.git
cd trainsportal
mise install          # installs Ruby 3.4.9 + Java temurin-21
bundle install
rails db:setup
```

## Running the application

### Development

Start Solr first, then the Rails server:

```bash
# Start Solr in the background
bundle exec rake sunspot:solr:start

# Start Rails
bin/rails server
```

### Production

```bash
export SECRET_KEY_BASE=$(bundle exec rails secret)
RAILS_ENV=production bundle exec rails db:setup
RAILS_ENV=production bundle exec rails assets:precompile
RAILS_ENV=production bundle exec rails server -p 3000
```

## Solr

The Solr configset for sunspot is in `solr/configsets/sunspot/`. Solr 6 is bundled with the `sunspot_solr` gem.

```bash
# Start (background)
bundle exec rake sunspot:solr:start

# Stop
bundle exec rake sunspot:solr:stop

# Re-index all records
bundle exec rake sunspot:reindex

# Production re-index
bundle exec rake sunspot:reindex RAILS_ENV=production

# Admin UI
open http://localhost:8983/solr/
```

## Images

Images are stored via ActiveStorage on the local disk (`storage/` in development/production, `tmp/storage` in test). vips handles image variants (thumb, medium, original).

```bash
# Remove an item's image (via the app UI or console)
item = Item.find(1)
item.trainimage.purge
```

## Testing

18 system tests covering authentication, items CRUD, image upload/delete, and search.

```bash
# Install Chrome (required for system tests)
brew install --cask google-chrome   # macOS

# Run unit tests
bundle exec rails test

# Run system tests (headless Chrome + Capybara)
bundle exec rails test:system

# Run all tests
bundle exec rails test && bundle exec rails test:system
```

## Security

```bash
# Check gem CVEs
gem install bundler-audit
bundle-audit update && bundle-audit check

# Static analysis
gem install brakeman
brakeman -q
```

## Deployment (Capistrano)

```bash
cap production deploy
```

Ensure the shared SQLite DB exists on the server before first deploy:

```bash
mkdir -p /path/to/app/shared/db
touch /path/to/app/shared/db/production.sqlite3
```

## Custom CSS notes

- Date pickers: wrap input in `<div id="datepicker">` with `data-provide="datepicker"` on the input
- Required fields: add `required` class to the container and `control-label` class to the label
- Date formatting: `.to_formatted_s(:ddmmyyyy_trains)` → `'6-Jun-2015'`

## License

Released under the GPL license. See the LICENSE file for details.



