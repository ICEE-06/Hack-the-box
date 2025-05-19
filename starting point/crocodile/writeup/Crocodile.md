### IP Machine:
---

```
10.129.18.201
```

### nmap:
---
![[Pasted image 20250215192031.png]]
**-sc**: permet d'activer les _scripts_ par défaut fournis par Nmap. Ces scripts font partie du Nmap Scripting Engine (NSE) et servent à effectuer des tâches de détection avancées, comme l'identification de versions de services, la détection de vulnérabilités courantes, ou encore l'exécution de tests spécifiques sur les hôtes scannés.

**vsftpd 3.0.3** : version d'un serveur FTP sécurisé, _Very Secure FTP Daemon_ (vsftpd), qui est connu pour sa légèreté et sa sécurité.

**pour se connecter à ftp:**

```
$ sudo ftp {IP de la cible}
```

![[Pasted image 20250215194220.png]]

### FTP
---
après s'être connécté à **ftp**:
-l'*username* qu'on doit utiliser est **anonymous**
-utiliser **dir** pour afficher les répertoires et **get** pour les manipuler.

![[Pasted image 20250215195531.png]]

### gobuster:
---
util en ligne de commande utilisé pour la **brute-force** de **répertoires**, **fichiers**, **sous-domaines**, et même des **objets Amazon S3**.

**dir** : énumeration des fichiers
**--url :** url de la cible
**--wordlist :** chemin vers la wordlist
**--x :** pour pouvoir specifier l'extension des fichiers à rechercher
**--timeout :** pour augmenter le temp de recherche

![[Pasted image 20250215201757.png]]

On doit maintenant acceder à **http://10.129.18.201/login.php** et entrez le infos de connexion: 
```
user : adimn
mot de passe : rKXM59ESxesUFHAd
```

![[Pasted image 20250215203143.png]]

voilààààààà😅!