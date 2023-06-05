# Terraform -> AWS EC2 -> Docker -> Flask application

This project is Deploying a flask application using Docker Container in an AWS EC2 Instance with Terraform

The code for flask application will be available here - https://github.com/SathwikReddyM/terrafom

Clone this repository in your local machine by using this command - ```git clone https://github.com/SathwikReddyM/terraform```

Check in which location you saved it and open it in terminal

Now run these commands:
1) ```terraform init```
2) ```terraform plan```
3) ```terraform apply```

After successfully running these commands, open your aws console and copy the Public IPv4 address and paste it in a browser.
Add :5000 to url and press enter.
example: http://18.191.33.237:5000/

To delete the ec2 instance use this command - ```terraform destroy```

Thank you

