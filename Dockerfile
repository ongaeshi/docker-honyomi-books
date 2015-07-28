FROM ruby:2.2.2

# Groonga(http://groonga.org/docs/install/debian.html)
RUN echo "deb http://packages.groonga.org/debian/ jessie main" >> /etc/apt/sources.list.d/groonga.list \
  && echo "deb-src http://packages.groonga.org/debian/ jessie main" >> /etc/apt/sources.list.d/groonga.list \
  && apt-get update \
  && apt-get install -y --allow-unauthenticated groonga-keyring \
  && apt-get update \
  && apt-get install -y libgroonga-dev

# Poppler
RUN apt-get install -y poppler-utils fonts-ipaexfont-gothic

# Honyomi (bundle install)
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
RUN bundle install

COPY . /usr/src/app

RUN bundle exec honyomi init

# Run Honyomi
EXPOSE 9295

CMD bundle exec honyomi web --host=0.0.0.0 --no-browser
