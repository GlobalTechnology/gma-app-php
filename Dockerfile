FROM 056154071827.dkr.ecr.us-east-1.amazonaws.com/base-image-php-version-arg:7.3
MAINTAINER cru.org <wmd@cru.org>

# Nginx is pointed at /var/www/app as document root
# App is installed at /home/app/webapp

# Copy source
COPY . /home/app/webapp

# Install PHP dependencies
RUN composer install --no-dev

# Install Node dependencies, Bower dependencies and build with gulp
RUN set -x \
	&& cd app \
	&& npm install -g n \
	&& n 6.17.1 \
	&& npm install \
	&& npx bower --allow-root install \
	&& npx gulp build \
	&& cd ..

# Copy post-deploy scripts
RUN mkdir -p /home/app/bin
COPY docker/post-deploy.sh /home/app/bin/
COPY docker/supervisord-post-deploy.conf /etc/supervisor/conf.d/
