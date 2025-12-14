On va donc commencer par un **nmap** classique. Grâce à ce nmap nous avons découvert deux ports ouverts!

```
22/tcp ssh
500/udp isakmap
```

Le **port 500/UDP**, appelé **ISAKMP** (_Internet Security Association and Key Management Protocol_), est utilisé principalement pour la **mise en place des VPN IPsec**. On va donc exploiter ce port! Nous allons d'abord commencer par obtenir toutes les infos à propos de ce service:

```
nmap -sU -p 500 --script ike-version 10.10.11.87
```

![[nmap_ike.png]]
Grâce à ça, on connait maintenant la version de **ike** qui est le `v1.0`. Maintenant on va identifier le fournisseur VPN et sa conf ave la commande `ike-scan`

```
ike-scan -M -A 10.10.11.87
```

![[ike_scan.png]]
Là, on a un username : `ike` et on sait aussi qu'il y a un hash. Allons extraire ce hash:

```
sudo ike-scan -M -A 10.10.11.87 --pskcrack=ike_hash.txt
```

Voici le hash obtenu:

![[ike_hash.png]]

Maintenant, on va le cracker avec **psk-crack**:

```
psk-crack -d /usr/share/wordlists/rockyou.txt ike_hash.txt
```

![[psk_crack.png]]

On a un **key** qui est probablement un mdp donc on va faire un ssh:

![[ssh_ike.png]]

En tentant d'élever le privilège, j'ai essayer la commande `sud -l` mais l'utilisateur n'a pas le droit d'exécuter des commandes avec **sudo**

![[not_sudo.png]]

On va maintenant essayer de savoir la version de **sudo**

![[sudo_version.png]]

Il se trouve que la versioon **1.9.17** de sudo est vulnérable. On peut utiliser la **CVE-2025-32463** pour élever notre privilège. Vous pouvez trouver l'exploit ici:

https://www.exploit-db.com/exploits/52352

Après avoir corectement exécuter tout l'exploit, vous devez obtenir un shell **root**

![[root_flag.png]]



