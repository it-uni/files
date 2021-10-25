#!/bin/sh

openssl req -x509 -nodes -newkey rsa:2048 -days 365 -keyout /home/ssl/my_key.key -out /home/ssl/my_cert.crt

