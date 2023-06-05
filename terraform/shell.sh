#!/bin/bash

sudo apt update
sudo apt install -y docker.io

git clone https://github.com/SathwikReddyM/terrafom.git

cd terrafom

sudo docker build -t myflask .
sudo docker run -d -p 5000:5000 --name myflask_container myflask


sudo apt-get update
sudo apt-get install -y nginx

# Start and enable Nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# Edit the default Nginx configuration file
sudo nano -ES /etc/nginx/sites-available/default <<EOF
upstream flaskhelloworld {
    server 127.0.0.1:8000;
}

location / {
    proxy_pass http://flaskhelloworld;
}
EOF

# Restart Nginx
sudo systemctl restart nginx

sudo docker exec myflask_container python main.py
