# Use the Ruby 3.1.4 base image
FROM ruby:3.1.4

# Update package lists and install dependencies (node.js and PostgreSQL client)
RUN apt-get update \
  && apt-get install -y nodejs postgresql-client

# Create a directory for your Rails application
RUN mkdir /myapp
WORKDIR /myapp

# Copy Gemfile and Gemfile.lock and run bundle install to install Ruby gems
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle update railties
RUN bundle install

# Copy the rest of your application files into the container
COPY . /myapp

# Add an entrypoint script to be executed every time the container starts
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

# Create a directory for storing temporary process IDs

# Specify the entry point for the container
ENTRYPOINT ["entrypoint.sh"]

# Expose port 3000 (the port that your Rails app likely listens on)
EXPOSE 3000

# Start the main process when the container is run
CMD ["rails", "server", "-b", "0.0.0.0"]