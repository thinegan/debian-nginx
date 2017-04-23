server {
    server_name  dev.timeclone.com;
    rewrite ^ https://$server_name$request_uri? permanent;
}


server {
    server_name dev.timeclone.com;
    listen 443;
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains";
    resolver 8.8.8.8 8.8.4.4 valid=300s;
    resolver_timeout 5s;
    ssl on;
    ssl_session_timeout 10m;
    ssl_protocols TLSv1.2;
    ssl_prefer_server_ciphers on;
    ssl_ciphers "ECDH+AESGCM:ECDH+AES256:ECDH+AES128:DH+3DES:RSA+3DES:!RC4:HIGH:!ADH:!AECDH:!MD5";
    ssl_certificate /etc/ssl/certs/timeclone.com.crt;
    ssl_certificate_key /etc/ssl/private/timeclone.com.key;
    ssl_session_cache shared:SSL:10m;
    
    root /home/www/public_html/dev.timeclone.com/;
    index index.php index.html index.htm;

    location / {
        try_files $uri $uri.html $uri/ =404;
        include proxy.conf;
    }

    # Static content
    location ~* .(jpg|jpeg|png|css|js|ico|gif|eot|ttf|woff|svg|otf|webm)$ {
        root /home/www/public_html/dev.timeclone.com/;
        access_log off;
        log_not_found off;
        expires 365d;
        add_header Cache-Control public;
        proxy_cache_valid any 1m;
        proxy_cache_valid 200 304 12h;
        proxy_cache_valid 302 301 12h;
        proxy_cache_key $host$uri#is_args$args;

        if ($request_filename ~* ^.*?.(eot)|(ttf)|(woff)|(svg)|(otf)|(webm)$){
                    add_header Access-Control-Allow-Origin *;
            }
    }

    location ~ \.php$ {
      try_files $uri =404;
      fastcgi_split_path_info ^(.+\.php)(/.+)$;
      fastcgi_pass php;
      fastcgi_index index.php;
      fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
      include fastcgi_params;
      fastcgi_read_timeout 300;
    }   

}

