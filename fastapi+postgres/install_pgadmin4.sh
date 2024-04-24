#!/bin/bash

sudo curl https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo apt-key add
echo "deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" | sudo tee /etc/apt/sources.list.d/pgadmin4.list

# Mettre à jour les références : Mettez à jour la liste des paquets disponibles avec la commande :
sudo apt update

# Installer pgAdmin : Une fois le référentiel ajouté et mis à jour, vous pouvez installer pgAdmin en utilisant la commande suivante :
sudo apt install pgadmin4

# Configurer pgAdmin : Après l'installation, vous devrez configurer pgAdmin. Pour ce faire, exécutez la commande suivante :
sudo /usr/pgadmin4/bin/setup-web.sh

# Assurez-vous d'avoir PostgreSQL installé sur votre système pour pouvoir vous connecter à une base de données PostgreSQL via pgAdmin. Si ce n'est pas déjà le cas, vous pouvez l'installer à l'aide de la commande :
sudo apt install postgresql

# Accéder à pgAdmin : Une fois la configuration terminée, vous pouvez accéder à pgAdmin en ouvrant un navigateur Web et en accédant à l'URL suivante :
# http://localhost/pgadmin4



#  Si probelem de connection on pgadmin suivre cette demarche

# sudo -i -u postgres

# createdb quiz
# psql

# \password  # or  \password postgres

