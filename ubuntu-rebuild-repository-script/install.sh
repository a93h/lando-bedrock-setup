# Tested on Ubuntu 20.04
#
# Should work on most debian/ubuntu based linux machine.
# For MacOS, Windows & other Linux Distros please customize to fit.
# Try manually following the instructions if needed.

# project directory change if you like
project_dir="lando_and_bedrock"

# unix/linux Commands
git_src=$(pwd)
mkdir -p ~/${project_dir}
cd ~/${project_dir}

project_dir=~/lando_and_bedrock/bedrock/

# previous project backup
if [ -d ${project_dir} ]
then
    my_ts=$(date +%s)
    mkdir -p ~/lando_and_bedrock/backups/${my_ts}
    mv ${project_dir} ~/lando_and_bedrock/backups/${my_ts}
fi

# create wordpress/bedrock project
composer create-project roots/bedrock

# return to git repository
cd ${git_src}

# copy .lando.yml to the project directory
cp .lando.yml ${project_dir}

# change into project directory.
cd ${project_dir}

# change environment files to match and use default settings.
# note these values should note be changed 
sed -i "s/DB_NAME=.*/DB_NAME=wordpress/g" .env
sed -i "s/DB_USER=.*/DB_USER=wordpress/g" .env
sed -i "s/DB_PASSWORD=.*/DB_PASSWORD=wordpress/g" .env
sed -i "s/# DB_HOST=.*/DB_HOST=database/g" .env
sed -i "s/DB_HOST=.*/DB_HOST=database/g"
sed -i "s/WP_ENV=.*/WP_ENV=development/g" .env
sed -i "s/WP_HOME=.*/WP_HOME=http:\/\/bedrock.test/g" .env
sed -i "s/WP_SITEURL=.*/WP_SITEURL=\${WP_HOME}\/wp/g" .env

# get salts
temp="";
get_salt() {
    temp="$(cat /dev/urandom | tr -dc 'A-Za-z0-9' | head -c${1:-64})"
}

get_salt && sed -i "s/AUTH_KEY=.*/AUTH_KEY='${temp}'/g" .env
get_salt && sed -i "s/SECURE_AUTH_KEY=.*/SECURE_AUTH_KEY='${temp}'/g" .env
get_salt && sed -i "s/LOGGED_IN_KEY=.*/LOGGED_IN_KEY='${temp}'/g" .env
get_salt && sed -i "s/NONCE_KEY=.*/NONCE_KEY='${temp}'/g" .env
get_salt && sed -i "s/AUTH_SALT=.*/AUTH_SALT='${temp}'/g" .env
get_salt && sed -i "s/SECURE_AUTH_SALT=.*/SECURE_AUTH_SALT='${temp}'/g" .env
get_salt && sed -i "s/LOGGED_IN_SALT=.*/LOGGED_IN_SALT='${temp}'/g" .env
get_salt && sed -i "s/NONCE_SALT=.*/NONCE_SALT='${temp}'/g" .env

if grep -Pq "127.0.0.1\tbedrock.test" /etc/hosts; then
    echo "hosts file complete"
else
    echo -e "127.0.0.1\tbedrock.test" | sudo tee -a /etc/hosts
fi

# begin docker containers
lando start -vvv

# run composer commands in root project directory
lando composer install
lando composer update

# change into thenes directory
# note the following can be used also # cd web/wp/wp-content/themes
cd web/app/themes
git clone https://github.com/roots/sage
cd sage
lando composer install
lando composer update

# edit 'sage.test' in sage folder to be 'bedrock.test' for webpack.mix.js file
sed -i "s/'sage.test'/'bedrock.test'/g" webpack.mix.js

# run yarn commands for monitoring file changes and recompiling
lando yarn
lando yarn start

cd ${git_src}