
Machine IP :
10.129.218.223

---
###SQL (Structured Querry Langage):



langage de programmation conçu pour gérer les bases de données relationnelles. Il permet de manipuler et interroger des données stockées dans des tables organisées sous forme de lignes et de colonnes.

#### injection SQL : 
--
L'injection SQL se produit lorsqu'un attaquant parvient à insérer ou manipuler des instructions SQL malveillantes dans une requête.L'attaquant exploite souvent l'injection SQL en insérant du code SQL malveillant dans un champ de saisie vulnérable.

l'injection SQL (SQLi) est classée dans le **OWASP Top 10 de 2021** sous la catégorie **A03:2021 - Injection**.

---

#### résultat nmap:


![[Pasted image 20250215083329.png]]

###### port 80/tcp :
Le port 80/tcp est le port standard utilisé pour le protocole HTTP (HyperText Transfer Protocol), qui est utilisé pour la communication entre les serveurs web et les clients (comme les navigateurs web)
###### Apache HTTPD 2.4.38: 
souvent utilisée pour fournir des services web sur des machines Linux
###### 443/tcp : 
port utilisé pour les communications sécurisées sur Internet, où le protocole HTTP est chiffré avec SSL/TLS afin de garantir la sécurité et la confidentialité des données échangées entre le client (comme un navigateur web) et le serveur (HTTPS).

---

#### Erreur 404: 
signifie que le serveur n'a pas pu trouver la ressource demandée. Ce code est couramment affiché lorsque l'URL demandée n'existe pas sur le serveur, ou si le fichier ou la page demandée a été déplacé ou supprimé.

---
#### Gobuster:
pour spécifier qu'on cherche à découvrir des **directory** avec ***gobuster***  on utilise le *switch* **-dir**
###### exemple : 

```
gobuster dir -u http://example.com -w /path/to/wordlist.txt
```
###### ![[Pasted image 20250215110351.png]]






	
