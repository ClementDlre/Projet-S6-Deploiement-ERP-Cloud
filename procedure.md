---
title: Utilisation des divers scripts
author: Clement DELERUE et Jean CARON
---

## Préambule)
- Si le terminal affiche :
```bash
[yes/no/fingerprint]
```
Il faudra rentrer la lettre `yes` afin d'accepter la copie de la clé ssh.

- Si le terminal affiche :
```bash
Enter passphrase for key '/home/vagrant/.ssh/id_rsa':
```
Il faudra rentrer votre passphrase

## 1) Lancement

Tout d'abord, placer vous dans le fichier `odoo-delerue-caron-r6.b.06` : 
- Lancer le script :
```bash
./0-lancement.sh
``` 

Suite à cela, déplacez-vous dans le dossier `/vagrant/scripts`.
```bash
cd /vagrant/scripts
```

Il faut générer une paire de `clé ssh`.
```bash
ssh-keygen
```

- Le terminal va afficher :
```bash
Enter file in which to save the key (/home/vagrant/.ssh/id_rsa):
```
Appuyez sur `Entrer`

- Le terminal va afficher :
```bash
Enter passphrase (empty for no passphrase):
```
Rentrer une passphrase
Attention, retenez la bien vous en aurez besoin plus tard

Maintenant, il faut se connecter à son compte `azure`.
```bash
az login
```
Suivez les instructions dans le terminal pour vous connecter


### 1) Utilisation du script `1-creation-insfrastructure.sh`

Ce script sert à créer les machines virtuelles nécéssaires à l'architecture finale via terraform et azure.
Il sert également à installer postgresql sur la machine psql et docker sur la machine odoo.

```bash
./1-creation-insfrastructure.sh
```

## 2) Utilisation du script `2-creation-client.sh`

Ce script sert à créer un client il se lance de la manière suivante :

```bash
./2-creation-client.sh
```

Il faut ensuite renseigner le `nom de la base de donnée`, le `nom` du client ainsi que le `mot de passe`.

## 3) Connexion à odoo

Après la création du client, une url s'affiche dans votre terminal comme si dessous
```bash
http://adresseIp:port
```
Copiez l'url et entrez l'a dans un navigateur

## 4) Utilisation du script `3-suppression-infrastructure.sh` 

Ce script permets de supprimer toute l'infrastructure présente sur azure.
```bash
./3-suppression-infrastructure.sh
```
Après avoir supprimer l'insfrastructure, vous pouvez quitter la vm:
- soit  en tapant:
```bash
exit
```
- soit en faisant:
ctrl + d

## 5) Utilisation du script `1-arret.sh` 

Ce script permets de supprimer la machine vagrant.
```bash
cd ../ | ./1-arret.sh
```