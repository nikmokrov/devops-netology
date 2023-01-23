#!/usr/bin/bash
docker run -dit --name ubuntu pycontribs/ubuntu:latest
docker run -dit --name centos7 pycontribs/centos:7
docker run -dit --name fedora pycontribs/fedora:latest
ansible-playbook -i inventory/prod.yml site.yml
docker rm -f ubuntu
docker rm -f centos7
docker rm -f fedora
