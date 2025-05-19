### IP Machine : 
---
```
10.129.95.232
```

### nmap:
---


![[Pasted image 20250215143010.png]]

**Port ouvert** : 3306/tcp, utilisant le *service mysql*

### SQL:
---
**MariaDB** : MariaDB est un **système de gestion de bases de données relationnelles (SGBDR)** issu d'un fork de MySQL.

**-u** : switch utlisé lors de l'utilisation du client la ligne de commande sql pour spécifier un **user** de connéxion

```
mysql -u <username> 
```


**root** : user à utilser lors d'une instance **mariaDb** pour ne pas donner de mdp

En SQL, pour spécifier qu'on veut tout les élement d'une table on utilise **etoile**.  Chaque requête doit être terminer par ';'.

```
mysql -h {IP de la cible} -u root
```
**-h** : pour se connecter à la base de données.
**-u**: pour un user non-existan

##### SHOW DATABASE;
Pour afficher les bases de données auquelles nous avons accées
![[Pasted image 20250215150128.png]]

##### USE {DATA_BASE_NAME};
Définir pour utiliser la base de données nommée


![[Pasted image 20250215150408.png]]

##### SHOW tables;
Pour afficher toutes les tables de la base de données

![[Pasted image 20250215150659.png]]


##### SELECT * FROM {table_name};
Pour afficher toutes les données dans la table sélectionnée.

![[Pasted image 20250215151000.png]]

