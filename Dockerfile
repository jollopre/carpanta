FROM ruby:2.7.0 as base

ARG ROOT_PATH

WORKDIR $ROOT_PATH

COPY Gemfile* $ROOT_PATH/

FROM base as development

RUN bundle install

CMD bundle exec puma -p $PORT
