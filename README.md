# Usage
Clone or download:
```bash
git clone https://github.com/minhhoit/docker-magento2.git
```

Prepare you HTTPS and custom domain => See: [./vhosts/README.md](./vhosts/README.md)

=> Example: https://magento2.dev

Update or copy file env for docker:
```bash
cp docker/env.example.php ~/Project/magento2/app/etc/env.php
```

Up and running:
```bash
cd ~/Project/magento2
docker-compose up -d
```

Prepare your magento installation:
```bash
# Enter `php` container
docker-compose exec m2-app bash

cd /var/www/html/magento2

# Setup file permissions, except folder `dev/docker`
find var generated vendor pub/static pub/media app/etc -type f -exec chmod g+w {} + \
    && find var generated vendor pub/static pub/media app/etc -type d -exec chmod g+ws {} + \
    && chown -R :www-data $(ls -Idocker)

# Run this to install db if it is new installation,
# or you can import your SQL in adminer: http://localhost:8088
php bin/magento setup:install \
    --db-host=mysql \
    --db-name=magento_db \
    --db-user=magento \
    --db-password=root \
    --backend-frontname=backend \
    --admin-firstname=Super \
    --admin-lastname=Admin \
    --admin-email=admin@example.com \
    --admin-user=admin \
    --admin-password=admin@123

# Update config
# Config to use varnish
php bin/magento config:set system/full_page_cache/caching_application 2
php bin/magento config:set system/full_page_cache/varnish/backend_host nginx
php bin/magento config:set system/full_page_cache/varnish/backend_port 80
# Base url and https
php bin/magento config:set web/unsecure/base_url http://magento2.dev/
php bin/magento config:set web/secure/base_url https://magento2.dev/
php bin/magento config:set web/secure/use_in_frontend 1
php bin/magento config:set web/secure/use_in_adminhtml 1
php bin/magento config:set web/seo/use_rewrites 1
# Locale, timezone, currency
php bin/magento config:set general/locale/code en_US
php bin/magento config:set general/locale/timezone Asia/Ho_Chi_Minh
php bin/magento config:set currency/options/base VND
# Flush cache
php bin/magento config:set cache:flush
```