#!/bin/bash

# wget http://wordpress.org/latest.zip -o wordpress.zip
wget http://wordpress.org/latest.zip

# unzip wordpress.zip
unzip latest.zip
rm latest.zip

# copy file to wordpress
cp Procfile ./wordpress
cp composer.json ./wordpress
cp wp-config.php ./wordpress

# remove dangling files
rm ./wordpress/wp-config-sample.php

