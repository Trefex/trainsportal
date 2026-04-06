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



# Train portal

This portal is a Ruby on Rails application using Bootstrap 3, Google Open Fonts and FontAwesome.
It is fully RESTful.

## Pre-requisites

This app was tested and developed on Ruby 2.2.1p85, rake 10.4.2, Rails 4.2.1 and rvm 1.26.11.

## Installation

Clone repository and do a

```bash
bundle install
```

## Running the application

```bash
passenger start
```

## Starting solr

In production, use a standalone solr server (check how to configure it).

For development, use the gem sunspot_solr

```
bundle exec rake sunspot:solr:run
```

to start it in the foreground.

```
bundle exec rake sunspot:solr:start
```

to start it in the background.

The admin portal can be found at: `http://localhost:8982/solr/#/`

## Managing commands

Re-index solr indexes

```
bundle exec rake sunspot:reindex
```

Re-generate thumbnails

```
rake paperclip:refresh:missing_styles && rake paperclip:refresh CLASS=Item
```

Recompile assets

```
rake assets:precompile
```

Migrate database

```
rake db:migrate
```

* Capistrano

```
cap install
```

  * Create db file to be shared amongst releases

  ```bash
  cd /home/localadmin/webapps/trains/shared/db/
  touch production.sqlite3
  ```

  * Deploy application with `cap [stage] deploy`

  ```bash
  cap production deploy
  ```

# Custom CSS for the application

* To make an input a date picker, embed it in a div with `id="datepicker"` and give the input
element the `data-provide="datepicker"` attribute.  

* To make a field required, add the `required` class to the container and the `control-label` class to the label itself

* <%= `.to_formatted_s(:ddmmyyyy_trains)` will make the date string be formatted as `'6-Jun-2015'` for example 

# Production

Install Phusion Passenger with Apache using the following guide:

https://www.phusionpassenger.com/documentation/Users%20guide%20Apache.html#installation

* Compile the Apache module

```
passenger-install-apache2-module
```

* Configure vhost

```apache
<VirtualHost *:80>
    ServerName trains.trefex.com

    DocumentRoot /home/localadmin/webapps/trainsportal/public
    RailsEnv production
    SetEnv SECRET_KEY_BASE secret_key
    <Directory /home/localadmin/webapps/trainsportal/public>
        Allow from all
        Options -MultiViews
        # Uncomment this if you're on Apache >= 2.4:
        #Require all granted
    </Directory>
</VirtualHost>
```

* Install solr

```
curl -O http://ftp.wayne.edu/apache/lucene/solr/5.1.0/solr-5.1.0.tgz
tar xzf solr-5.1.0.tgz solr-5.1.0/bin/install_solr_service.sh --strip-components=2
ls
sudo bash ./install_solr_service.sh solr-5.1.0.tgz
```

* Configure solr

  * Created core `default/conf` folder in `/var/solr/data` to hold core configuration
  * Added sunspot custom schema.xml to `default/conf` and used `solrconfig.xml` from examples section as sunspot one was too old.
  * Created a new core through web portal with settings: default, default, default/data, solrconfig.xml, schema.xml
  * Changed in schema.xml to remove deprecated datatypes as seen here https://groups.google.com/forum/?fromgroups#!topic/ruby-sunspot/hL4-0NqNnqA

* Re-index solr indexes

  ```
  bundle exec rake sunspot:reindex RAILS_ENV="production"
  ```

* Re-generate thumbnails

  ```
  rake paperclip:refresh:missing_styles && rake paperclip:refresh CLASS=Item RAILS_ENV="production"
  ```

*  Recompile assets

  ```
  rake assets:precompile RAILS_ENV="production"
  ```

  Migrate database

  ```
  rake db:setup RAILS_ENV="production"
  ```

* Needed to install ImageMagick on the server, due to the following error:

```
[paperclip] An error was received while processing: #<Paperclip::Errors::CommandNotFoundError: Could not run the `identify` command. Please install ImageMagick.>
```

On Debian, simply do

```
apt-get install imagemagick
```

## License

This code is release under GPL license. Please see the licnese file attached to this repository.
