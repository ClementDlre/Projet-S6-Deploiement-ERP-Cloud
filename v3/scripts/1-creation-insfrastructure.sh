#!/bin/bash

cd ../terraform
terraform init
terraform apply -auto-approve
terraform apply -auto-approve
terraform output | grep "public" > ../ansible/fichierTemporaire/ip
IPPUBLIQUE=$(cat ../ansible/fichierTemporaire/ip|cut -d '"' -f 2)

cd ../ansible

cp ./fichierInfra/infra-tmp.ini ./infra.ini
sed -i -e "s/IPPUB/$IPPUBLIQUE/g" ./infra.ini

cp ./fichierInfra/sshconfig-tmp ./fichierTemporaire/sshconfig
sed -i -e "s/IPPUB/$IPPUBLIQUE/g" ./fichierTemporaire/sshconfig


cat ./fichierTemporaire/sshconfig > ~/.ssh/config

rm -f ./fichierTemporaire/sshconfig

ansible-playbook -i infra.ini 1-installation-postresql.yml
ansible-playbook -i infra.ini 2-installation-docker.yml

