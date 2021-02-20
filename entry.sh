#!/bin/bash
nohup /usr/bin/supervisord -c /etc/supervisord.conf &
/traefik
