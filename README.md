# Container_cave
Here are my various container images(Podman/Docker and feel  free to use and modify according to your needs.

# Basic Tradional LAMP stack installation:


To install a LAMP stack on RHEL 9 and enable PHP 8.2 using the `dnf` package manager, follow these steps:

### Step 1: Update the System
First, ensure your system is up-to-date:
```bash
sudo dnf update -y
```

### Step 2: Install Apache
Install the Apache HTTP server:
```bash
sudo dnf install httpd -y
```
Start and enable Apache to start on boot:
```bash
sudo systemctl start httpd
sudo systemctl enable httpd
```

### Step 3: Enable PHP 8.2 Module
Enable the PHP 8.2 module using `dnf`:
```bash
sudo dnf module enable php:8.2 -y
```

### Step 4: Install PHP 8.2
Install PHP 8.2 and some common PHP modules:
```bash
sudo dnf install php php-mysqlnd php-fpm php-opcache php-gd php-xml php-mbstring php-json php-intl -y
```
Start and enable PHP-FPM service:
```bash
sudo systemctl start php-fpm
sudo systemctl enable php-fpm
```

### Step 5: Install MariaDB
Install MariaDB server and client:
```bash
sudo dnf install mariadb-server mariadb -y
```
Start and enable MariaDB to start on boot:
```bash
sudo systemctl start mariadb
sudo systemctl enable mariadb
```

### Step 6: Secure MariaDB Installation
Run the security script to set the root password, remove anonymous users, disallow root login remotely, remove test database, and reload privilege tables:
```bash
sudo mysql_secure_installation
```
Follow the prompts to secure your MariaDB installation.

### Step 7: Test PHP Processing
Create a PHP info file to test PHP processing with Apache:
```bash
sudo echo "<?php phpinfo(); ?>" > /var/www/html/info.php
```
Set the correct permissions:
```bash
sudo chown apache:apache /var/www/html/info.php
```
Open a web browser and go to `http://your_server_ip/info.php`. You should see the PHP info page displaying PHP 8.2 configuration details.

### Step 8: Configure Firewall
If you have a firewall enabled, allow HTTP and HTTPS traffic:
```bash
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload
```

### Step 9: Restart Apache
Restart Apache to ensure all configurations are loaded:
```bash
sudo systemctl restart httpd
```

You now have a LAMP stack installed on your RHEL 9 system with PHP 8.2 enabled.
