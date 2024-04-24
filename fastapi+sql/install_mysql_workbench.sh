#!/bin/bash

# Update the package index:
sudo apt update

# Install the MySQL server package:
    # During the installation, you'll be prompted to set a root password for MySQL. Choose a strong password and remember it.
sudo apt install mysql-server

# Once the installation is complete, you can start and enable the MySQL service:
sudo systemctl start mysql
sudo systemctl enable mysql

# Secure your MySQL installation by running:
    # Follow the prompts to set up additional security options.
sudo mysql_secure_installation

# Installing MySQL Workbench:
sudo apt update
sudo snap install mysql-workbench-community

#Once the installation is complete, you can launch MySQL Workbench from the applications menu or by running:
    # applications , click on mysql workbench




