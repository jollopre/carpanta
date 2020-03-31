FROM ruby:2.7.0 as base
ENV ROOT_PATH /usr/src
WORKDIR $ROOT_PATH
COPY Gemfile* $ROOT_PATH/
COPY . $ROOT_PATH
ENTRYPOINT ["infra/entrypoint.sh"]

FROM base as test
RUN bundle install -j 10
CMD bundle exec puma -p $PORT

FROM base as production
RUN rm -r spec
RUN bundle install -j 10 --without=test
CMD bundle exec puma -p $PORT
