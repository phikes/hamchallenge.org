# Hamchallenge.org

<a href="https://hamchallenge.org">
<img alt="hamchallenge.org logo" src="https://github.com/phikes/hamchallenge.org/blob/main/app/assets/images/logo_small.png" />
</a>

**Welcome to the hamchallenge.org application repository.**

This repository contains the [Ruby on Rails](https://rubyonrails.org/)
application **written by DL9PK (@phikes) in 2025** that runs the **hamchallenge.org
website and the service that processes mastodon toots** for participation.

## Setup

This application uses [devcontainers](https://containers.dev/) and the **usage of
[devcontainer-cli](https://github.com/devcontainers/cli) is recommended**,
although you can also use the [VSCode
integration](https://code.visualstudio.com/docs/devcontainers/containers).

You also need **[Docker](https://www.docker.com/) and docker-compose installed.**
docker-compose comes bundled with [Docker
Desktop](https://www.docker.com/products/docker-desktop/).

* `devcontainer build --workspace-folder .`
* `devcontainer up --workspace-folder .`
* `devcontainer exec --workspace-folder . bin/dev`

**And the server and database are running! 🎉**

**Navigate to [localhost:3000](http://localhost:3000) to see hamchallenge.org in action.**

## Admin Interface

There is an admin interface at [localhost:3000/admin](http://localhost:3000) to
aid in the **creation and management of challenges and toots**. Find the development
credentials in the `.env` file.

## Processing Mastodon Toots

Run `devcontainer exec --workspace-folder . bin/rails
process_mastodon_notifications` to execute a rake task **which receives all
mastodon notifications for the hamchallenge bot and processes them into toots
for the challenges**. This only works if you set the right access token in the
[`.env`](https://github.com/phikes/hamchallenge.org/blob/main/config/app_config.yml)
    file.

The rake task calls the service at [`app/services/process_mastodon_notifications.rb`](https://github.com/phikes/hamchallenge.org/blob/main/app/services/process_mastodon_notifications.rb).

## Specs

The application **is and should in the future be thoroughly tested.**

When developing use `devcontainer exec --workspace-folder . bundle exec guard`
in order to **run a file watcher who watches for new dependencies** and **runs the
according tests** when you change files.

Some test goodies we use include
[factory_bot](https://github.com/thoughtbot/factory_bot) and
[shoulda-matchers](https://github.com/thoughtbot/shoulda-matchers).

## Deployment

The application currently runs out of the box on [heroku](https://heroku.com/)
using their postgresql database and scheduler for running the script which
processes the mastodon toots.

## Data model

The data model is **inherently simple**, there are **only challenges and toots**.
Users are **denormalized into the `username` field on toots** and arguably the
**most complex database query** lives at [`app/models/challenge.rb`](https://github.com/phikes/hamchallenge.org/blob/main/app/models/challenge.rb)
in the `with_status` scope. This one is written in [Arel](https://www.rubydoc.info/gems/arel) and lets the database
handle the *dirty work of checking what the status of a given username for some
challenges is*.

## Configuration

There is some **app configuration in [`config/app.yml`](https://github.com/phikes/hamchallenge.org/blob/main/config/app_config.yml)
which allows you to set the year of the challenge, the contributors and more.**

The app itself is **not bound to a year** and past challenges and toots **can keep on
living in the database**.
