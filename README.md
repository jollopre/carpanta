# Carpanta

[![Build Status](https://travis-ci.com/jollopre/carpanta.svg?branch=master)](https://travis-ci.com/jollopre/carpanta)

Carpanta is a web application that simplifies the handling of customers and their appointments in the context of hairdressing. Currently, there is support for:

  - Creating customers
  - Creating appointments on an specific date/time for a concrete offer
  - Listing customers
  - Displaying customers and their appointments (past, present and future ones).

### Tech

Carpanta main stack is Ruby, using [Sinatra](http://sinatrarb.com/) for interacting with consumers through the web. It also has some touches of JavaScript and CSS for improving the user experience.

### Installation

Carpanta requires [docker](https://www.docker.com/) and [docker-compose](https://docs.docker.com/compose/) to run.

Install the dependencies and start the server.

```sh
$ cd carpanta
$ make up
```

For production environments, please type:

```sh
$ cd carpanta
$ make start
```

Carpanta supports three environments for running the server (e.g. development, test and production). The environment variables, injected when the container runs, can be set differently at `infra/[environment].env`.

### Development

Want to contribute? Great!

Carpanta uses Ruby + Sinatra for the back-end development. We encourage TDD heavily, so open a tab using your favourite Terminal and run these commands:

```sh
$ make shell
$ bundle exec rspec
```

The front-end development uses vanilla JavaScript and [Parcel](https://parceljs.org/) to bundle every asset located under `app/assets`. Open a second tab and type the following:

```sh
$ make shell_assets
$ npm test
```

Please, make sure that any change made to this codebase is thoroughly tested using either [RSpec](https://rspec.info/) or [Jest](https://jestjs.io/) for back-end and front-end respectively before submitting any PR.

### Test

You can run the specs for front and back end code in one go by typing:

```sh
$ make test
```

### Production

Should you wish to run carpanta into [AWS Fargate](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/AWS_Fargate.html). Please type the following:

```sh
$ make deploy
```

The above mentioned command does 3 things:

1. Builds the image in production mode
2. Pushes the image into [DockerHub](https://hub.docker.com/)
3. Deploys the code into [AWS Fargate](https://aws.amazon.com/console/) according to the definition found at [production.json](infra/production.json)

Note, you will need to have an account in [DockerHub](https://hub.docker.com/) as well a AWS user with ECS permissions. Check the [Makefile](Makefile) for a better insight into the requirements needed.

### Todos

 - Introducing code style guide for back end front development
 - Control errors flow with Result monad instead of using Exceptions
 - Exploring other libraries for Domain objects validations
 - Including CVE detections in the CI
 - Refinements in deploy gem located under infra/deploy

License
----

MIT
