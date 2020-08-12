FROM ruby:2.7.0 as base
ENV ROOT_PATH /usr/src
WORKDIR $ROOT_PATH
COPY Gemfile* $ROOT_PATH/
COPY . $ROOT_PATH
RUN bundle install -j 10
