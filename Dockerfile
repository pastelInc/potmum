FROM ruby:2.3.1

WORKDIR /usr/src/app
RUN ( curl -sL https://deb.nodesource.com/setup_6.x | bash - ) && \
    apt-get install -y libpq-dev nodejs
ADD . ./
RUN bundle install --path vendor/bundle
RUN ln -s /data/attachment_files ./public/attachment_files
RUN RAILS_ENV="production" \
    bundle exec rake assets:precompile assets:environment
RUN mkdir -p ./tmp/pids && \
    touch ./tmp/pids/puma.pid && \
    touch ./tmp/pids/puma.state
ENV RAILS_ENV="production"
EXPOSE 7272
ENTRYPOINT [ "/bin/bash", "./docker-entrypoint.sh" ]
