FROM php:7.3-fpm

LABEL maintainer="hoangminh.it4u@gmail.com"

RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libicu-dev \
    libxml2-dev \
    libxslt-dev \
    libzip-dev \
    git vim unzip cron \
    --no-install-recommends \
    && rm -r /var/lib/apt/lists/*

RUN docker-php-ext-configure gd --with-jpeg-dir=/usr/lib \
    --with-freetype-dir=/usr/include/freetype2 \
    && docker-php-ext-install -j$(nproc) gd

RUN docker-php-ext-configure intl \
    && docker-php-ext-install -j$(nproc) intl

RUN docker-php-ext-install -j$(nproc) opcache bcmath pdo_mysql soap xsl zip sockets

# Install nvm, node, grunt
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash \
    && . ~/.bashrc \
    && nvm install 12 \
    && npm i -g grunt-cli

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

# Set magento file permissions
RUN useradd -m -s /bin/bash magento \
    && usermod -a -G www-data magento

RUN cp "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

ADD ./docker/config/php-fpm/m2.ini $PHP_INI_DIR/conf.d/
# Crontab for user magento
ADD ./docker/config/php-fpm/magento.cron /var/spool/cron/crontabs/magento
RUN chmod 600 /var/spool/cron/crontabs/magento && chgrp crontab /var/spool/cron/crontabs/magento
# Custom entrypoint to start cron service
ADD ./docker/config/php-fpm/m2-entrypoint.sh /usr/local/bin/

# Add some alias
ADD ./docker/config/php-fpm/.bash_aliases /usr/local/share/.bash_aliases
# Improve shell prompt: [+] root @ /var/www/html/magento
RUN printf '\nfunction nonzero_return() { RETVAL=$? ; [ $RETVAL -ne 0 ] && echo "[exit code: $RETVAL]" ; }\n \
    PS1="\n\[\e[37m\][+]\[\e[m\]\[\e[m\] \[\e[32m\]\u\[\e[m\] \[\e[34m\]@\[\e[m\] \[\e[36m\]\w \[\e[31m\]\`nonzero_return\`\[\e[m\]\n\\\$ > "\n \
    . /usr/local/share/.bash_aliases\n' | tee --append /etc/bash.bashrc /home/magento/.bashrc

ENTRYPOINT [ "/usr/local/bin/m2-entrypoint.sh" ]

CMD ["php-fpm"]

EXPOSE 9000
