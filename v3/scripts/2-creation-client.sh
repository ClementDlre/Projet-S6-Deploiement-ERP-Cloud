#!/bin/bash
cd ../ansible

echo "Nom de la base de donnée:" && read dbname
echo "Nom de l'utilisateur:" && read username
echo "Mot de passe:" && read -s password

db_id=$(echo "$dbname" | cksum | cut -f1 -d' ')
db_id=$((db_id % 500))
port=$((8069 + $db_id))
port_str=$(echo "$port" | tr -d '\n')

cp ./fichierOdoo/odoo-tpl.conf ./fichierTemporaire/odoo.conf
sed -i -e "s/DBNAME/$dbname/g" ./fichierTemporaire/odoo.conf
sed -i -e "s/USERNAME/$username/g" ./fichierTemporaire/odoo.conf
sed -i -e "s/PWORD/$password/g" ./fichierTemporaire/odoo.conf


cp ./fichierOdoo/docker-compose-tpl.yml ./fichierTemporaire/docker-compose.yml
sed -i -e "s/DBNAME/$dbname/g" ./fichierTemporaire/docker-compose.yml
sed -i -e "s/USERNAME/$username/g" ./fichierTemporaire/docker-compose.yml
sed -i -e "s/PWORD/$password/g" ./fichierTemporaire/docker-compose.yml
sed -i -e "s/PORT/$port_str/g" ./fichierTemporaire/docker-compose.yml



cp ./fichierPostgres/variables-postgresql-tpl.yml ./variables-postgresql.yml
sed -i -e "s/DBNAME/$dbname/g" ./variables-postgresql.yml
sed -i -e "s/USERNAME/$username/g" ./variables-postgresql.yml
sed -i -e "s/PWORD/$password/g" ./variables-postgresql.yml


cp ./fichierNginx/location ./fichierTemporaire/$dbname
sed -i -e "s/DBNAME/$dbname/g" ./fichierTemporaire/$dbname
sed -i -e "s/PORT/$port_str/g" ./fichierTemporaire/$dbname


ansible-playbook -i infra.ini 3-create-database-postgresql.yml
ansible-playbook -i infra.ini 4-create-instance-odoo.yml
ansible-playbook -i infra.ini 5-nginx_deploy.yml

rm ./variables-postgresql.yml
rm ./fichierTemporaire/odoo.conf
rm ./fichierTemporaire/docker-compose.yml

sleep10

echo "LA CREATION DU CLIENT EST TERMINE"
echo "VOUS POUVEZ ACCEDER A SON INSTANCE VIA:"


IPPUBLIQUE=$(cat ../ansible/fichierTemporaire/ip|cut -d '"' -f 2)

echo "http://$IPPUBLIQUE:$port_str"

rm -f ./fichierTemporaire/$dbname

