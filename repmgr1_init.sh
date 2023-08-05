#!/bin/bash

repmgr -f /etc/postgresql/repmgr.conf primary register
repmgr -f /etc/postgresql/repmgr.conf cluster show