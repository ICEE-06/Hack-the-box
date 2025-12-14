
## Reconnaissance
### Nmap
Le scan avec **nmap** nous revèle 2 ports ouverts:

![[Machine/HackNet/files/nmap.png]]

### Web enumeration

![[hacknet.htb.png]]

La prochaine étape est d'énumérer les répertoires cachés en utilisant **gobuster**

```
gobuster dir -u http://hacknet.htb -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -t 50
```

![[gobuster.png]]
