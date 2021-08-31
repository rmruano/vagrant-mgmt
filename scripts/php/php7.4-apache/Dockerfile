FROM php:7.4-apache
SHELL ["/bin/bash", "-c"]

# Info regarding this image: https://github.com/docker-library/docs/tree/master/php

RUN apt-get update && apt-get install unzip

# Install composer
RUN cd /tmp && \
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php && \
    mv composer.phar /usr/local/bin/composer

ARG extensions=""
# ARG cachebust=""
ARG cert_crt_text=""
ARG cert_key_text=""
ARG server_name="mgmt"

# Activate HTTPS
RUN mkdir /certificates
RUN echo "$cert_crt_text" > /certificates/cert.crt
RUN echo "$cert_key_text" > /certificates/cert.key
RUN ln -s /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-enabled/default-ssl.conf && \
    ln -s /etc/apache2/mods-available/socache_shmcb.load /etc/apache2/mods-enabled/socache_shmcb.load && ln -s /etc/apache2/mods-available/socache_shmcb.conf /etc/apache2/mods-enabled/socache_shmcb.conf && \
    ln -s /etc/apache2/mods-available/ssl.conf /etc/apache2/mods-enabled/ssl.conf && ln -s /etc/apache2/mods-available/ssl.load /etc/apache2/mods-enabled/ssl.load

RUN sed -ri -e 's!/etc/ssl/certs/ssl-cert-snakeoil.pem!/certificates/cert.crt!g' /etc/apache2/sites-available/*.conf && \
    sed -ri -e 's!/etc/ssl/private/ssl-cert-snakeoil.key!/certificates/cert.key!g' /etc/apache2/sites-available/*.conf && \
    sed -ri -e "s!</VirtualHost>!ServerName $server_name\n</VirtualHost>!g" /etc/apache2/sites-available/*.conf

# ADD USER
RUN groupadd -g 1000 vagrant && useradd -g 1000 -u 1000 vagrant && usermod -g 1000 -G vagrant,root vagrant
#USER vagrant

# To run a the image for testing installations: docker run -it -d -p 8080:80 --name my-apache-php-app -v "$PWD":/var/www/html php:7.2-apache
# To connect: docker exec -it my-apache-php-app /bin/bash

RUN if [ -z "$extensions" ] ; then echo extensions argument not provided ; else echo Extensions that will be installed: "$extensions"; fi


# xdebug
RUN if [[ "$extensions" == *"xdebug"* ]]; then echo "Installing xdebug..." && pecl install xdebug-2.8.1 && docker-php-ext-enable xdebug; fi

# redis
RUN if [[ "$extensions" == *"redis"* ]]; then echo "Installing redis..." && pecl install redis-5.1.1 && docker-php-ext-enable redis; fi

# memcached
RUN if [[ "$extensions" == *"memcached"* ]]; then echo "Installing memcached..." && apt-get update && apt-get install -y libmemcached-dev zlib1g-dev && pecl install memcached-3.1.5 && docker-php-ext-enable memcached; fi

# gd
RUN if [[ "$extensions" == *"gd"* ]]; then echo "Installing gd..." && apt-get update && apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev && docker-php-ext-configure gd --with-png-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-freetype-dir=/usr/include/ && docker-php-ext-install -j$(nproc) gd; fi