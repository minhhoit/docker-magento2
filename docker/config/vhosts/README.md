Using [`mkcert`](https://github.com/FiloSottile/mkcert) to generage valid SSL certificate for localhost:
```bash
╭─ ubuntu ~/Projects/magento-ee  ‹master*› 
╰─ $ mkcert -install
Using the local CA at "/home/ubuntu/.local/share/mkcert"

╭─ ubuntu ~/Projects/magento-ee  ‹master*› 
╰─ $ mkcert magento2.dev
Using the local CA at "/home/ubuntu/.local/share/mkcert" 

Created a new certificate valid for the following names
 - "magento2.dev"

The certificate is at "./magento2.dev.pem" and the key at "./magento2.dev-key.pem" ✅
```
Generated files: `magento2.dev-key.pem` và `magento2.dev.pem` are ready for using in Apache or Nginx.
