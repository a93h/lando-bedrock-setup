# Tested on Ubuntu 20.04
#
# Should work on most debian/ubuntu based linux machine.
# For MacOS, Windows & other Linux Distros please customize to fit.
# Try manually following the instructions if needed.
#
# system requirements
# PHP >= 7.1 https://www.php.net/manual/en/install.php
# Composer https://getcomposer.org/doc/00-intro.md
# Docker https://docs.docker.com/engine/install/
# Lando https://docs.lando.dev/basics/installation.html
# bedrock https://roots.io/bedrock/
# text-editor (optional) visual studio code https://code.visualstudio.com/
# lando + bedrock https://roots.io/guides/dockerize-local-bedrock-and-sage-development-with-lando/

# php install
if ! command -v php &> /dev/null
then
    sudo apt install php -y
    sudo apt install php-xmlwriter -y
fi

# composer
if ! command -v composer &> /dev/null
then
    wget https://getcomposer.org/download/latest-stable/composer.phar
    sudo mv composer.phar /usr/local/bin/composer
    sudo chmod a+x  /usr/local/bin/composer 
    sudo chown root:root  /usr/local/bin/composer
fi

# docker
if ! command -v docker &> /dev/null
then
    sudo apt install curl -y
    curl -fsSL 		https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
fi


# lando
if ! command -v lando &> /dev/null
then
    sudo apt install gdebi -y
    wget https://files.devwithlando.io/lando-stable.deb
    sudo gdebi lando-stable.deb
fi

# visual studio code
if ! command -v code &> /dev/null
then
    sudo snap install code --classic
fi