#!/bin/bash
RDS_ENDPOINT=${rds_endpoint}
sudo apt update
sudo apt install -y docker.io

git clone https://github.com/SathwikReddyM/terrafom.git

cd terrafom
echo "endpoint = '$RDS_ENDPOINT'" > details.py
sudo docker build -t myflask .



sudo apt-get update
sudo apt-get install -y nginx

# Start and enable Nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# Edit the default Nginx configuration file
# Append the upstream block to the configuration file
echo "upstream flaskhelloworld {" >> /etc/nginx/sites-available/default
echo "    server 127.0.0.1:5000;" >> /etc/nginx/sites-available/default
echo "}" >> /etc/nginx/sites-available/default

# Append the location directive to the configuration file
echo "location / {" >> /etc/nginx/sites-available/default
echo "    proxy_pass http://flaskhelloworld;" >> /etc/nginx/sites-available/default
echo "}" >> /etc/nginx/sites-available/default
sudo docker run -d -p 5000:5000 --name myflask_container myflask
# Restart Nginx
sudo systemctl restart nginx

sudo docker exec myflask_container python main.py
