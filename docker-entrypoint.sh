#!/bin/bash

cat << EOT > ./config/puma.rb
#!/usr/bin/env puma

environment ENV['RAILS_ENV']
daemonize false
pidfile "#{Dir.pwd}/tmp/pids/puma.pid"
state_path "#{Dir.pwd}/tmp/pids/puma.state"
bind 'tcp://0.0.0.0:7272'
EOT

export SECRET_KEY_BASE=$(bundle exec rake secret) && \
bundle exec rake db:create db:migrate && \
bundle exec puma -C ./config/puma.rb