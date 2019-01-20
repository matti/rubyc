FROM ruby:2.6.0

RUN apt-get update && \
  apt-get install -y squashfs-tools build-essential bison curl openssl && \
  update-ca-certificates

# RUN curl -sL "https://github.com/kontena/ruby-packer/releases/download/2.6.0-0.6.0/rubyc-2.6.0-0.6.0-linux-amd64.gz" | gunzip > /usr/local/bin/rubyc && \
#   chmod +x /usr/local/bin/rubyc
RUN curl -sL "https://github.com/kontena/ruby-packer/releases/download/0.5.0%2Bextra5/rubyc-0.5.0+extra5-linux-amd64.gz" | gunzip > /usr/local/bin/rubyc && \
  chmod +x /usr/local/bin/rubyc

WORKDIR /app
RUN gem install sinatra
COPY app.rb .

WORKDIR /rubyc
COPY entrypoint.sh .

ENTRYPOINT [ "/rubyc/entrypoint.sh" ]
