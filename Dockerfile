FROM ruby:2.7.3 as base
ENV ROOT_PATH /usr/src
ENV PUBLIC_PATH /assets
WORKDIR $ROOT_PATH
COPY Gemfile* $ROOT_PATH/
COPY . $ROOT_PATH
ENTRYPOINT ["infra/entrypoint.sh"]

FROM base as deploy
RUN bundle install -j 10 --quiet --without=development test production --quiet
ENTRYPOINT []
CMD bundle exec rake -f infra/Rakefile provisioner:up[infra/production.json]

FROM node:15.11.0-alpine3.12 as assets
ENV PUBLIC_PATH /assets
RUN apk add --no-cache --virtual .primer curl
WORKDIR /usr/src/app
RUN npm install -g npm@7.6.1
COPY ./app/assets ./
RUN npm install --silent
RUN npm run build
RUN apk del .primer

FROM base as test
COPY --from=assets /usr/src/app/dist ./app/public${PUBLIC_PATH}/
RUN bundle install -j 10 --quiet
CMD bundle exec puma -p $PORT

FROM base as production
COPY --from=assets /usr/src/app/dist ./app/public${PUBLIC_PATH}
RUN rm -r spec
RUN bundle install -j 10 --without=development test deploy --quiet
CMD bundle exec puma -p $PORT
