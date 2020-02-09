FROM ruby:2.7.0 as base

ENV ROOT_PATH /usr/src

WORKDIR $ROOT_PATH

COPY Gemfile* $ROOT_PATH/

FROM base as development

RUN bundle install

CMD bundle exec puma -p $PORT

FROM base as test

COPY . $ROOT_PATH/

RUN bundle install

CMD bundle exec rake test:all
