FROM ruby:2.7.0 as base
ENV ROOT_PATH /usr/src
WORKDIR $ROOT_PATH
COPY Gemfile* $ROOT_PATH/
COPY . $ROOT_PATH
ENTRYPOINT ["infra/entrypoint.sh"]

FROM node:alpine3.11 as assets
WORKDIR /usr/src
COPY ./app/assets/package*.json ./
RUN npm install

FROM base as test
COPY --from=assets /usr/src/node_modules/purecss/build/pure-min.css ./app/public/
RUN bundle install -j 10
CMD bundle exec puma -p $PORT

FROM base as production
COPY --from=assets /usr/src/node_modules/purecss/build/pure-min.css ./app/public/
RUN rm -r spec
RUN bundle install -j 10 --without=test
CMD bundle exec puma -p $PORT
