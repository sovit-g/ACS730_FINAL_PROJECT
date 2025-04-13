#!/bin/bash

# Update system
yum update -y

# Install Apache (httpd)
yum install -y httpd

# Start and enable Apache
systemctl start httpd
systemctl enable httpd

# Install PostgreSQL client (so webserver can connect to DB)
dnf install -y postgresql15

# Get public IP of the instance
PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)

# Web content generation
cat <<EOF > /var/www/html/index.html
<h1>Webserver created as part of ACS730 Final Group Project</h1>
<p><strong>Group Members:</strong> Sovit, Lokesh, Rahul, and Pujan</p>
<p><strong>Environment:</strong> ${env}</p>
<p><strong>Public IP:</strong> $PUBLIC_IP</p>
<p><strong>Hostname:</strong> $(hostname -f)</p>
EOF
