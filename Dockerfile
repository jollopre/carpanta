FROM ruby:2.7.0 as base
ENV ROOT_PATH /usr/src
WORKDIR $ROOT_PATH
COPY Gemfile* $ROOT_PATH/
COPY . $ROOT_PATH
ENTRYPOINT ["infra/entrypoint.sh"]

FROM base as deploy
RUN bundle install -j 10 --quiet --without=development test production --quiet
ENTRYPOINT []
CMD bundle exec rake -f infra/Rakefile provisioner:up[infra/production.json]

FROM node:15.2.0-alpine3.11 as assets
WORKDIR /usr/src
COPY ./app/assets ./
RUN npm install
RUN npm run bundle

FROM base as test
COPY --from=assets /usr/src/dist ./app/public/
RUN bundle install -j 10 --quiet
CMD bundle exec puma -p $PORT

FROM base as production
COPY --from=assets /usr/src/dist ./app/public/
RUN rm -r spec
RUN bundle install -j 10 --without=development test deploy --quiet
CMD bundle exec puma -p $PORT
