### Déploiement automatisé d'une application avec Docker & CI/CD

## Objectif
Ce projet personnel a pour objectif de mettre en pratique des compétences
en administration Linux et DevOps à travers la mise en place progressive
d'un environnement permettant de conteneuriser et de déployer une application
de manière automatisée.

# Technologies prévues
- Linux
- Bash
- Git / GitHub
- Docker
- Docker Compose
- GitHub Actions

------------------------------------------------------------------------------------------------

### Initialisation du projet
- Création de l'espace de travail
Projet créé dans le répertoire /home/melinda/projets/devops-projet

### Mise en place du dépôt Git
Le répertoire du projet a été initialisé comme dépôt Git avec : git init
Branche principale "main" utilisée pour suivre l'évolution du projet.

### Mise en place de l'application
- Création d'une petite application web Python
L'application écoute sur le port 8080.
- Lancement de l'application : python3 app.py
- Test de l'application avec : curl http://localhost:8080
--> Réponse obtenue : Bonjour depuis mon projet DevOps !
#Configuration de l'application
- Création du fichier app/app.conf avec variables de configuration :
APP_NAME=devops-app
APP_ENV=development
APP_PORT=8080
--> Ces variables permettent notamment de définir le nom de l'application, son environnement et le port utilisé.
#Vérification de l'application
(Plusieurs commandes Linux ont été utilisées afin de vérifier le fonctionnement de l'application.)
- Vérification du processus : ps aux | grep app.py
--> Permet de vérifier si le processus Python de l'application est en cours d'exécution.
- Vérification du port : ss -lntp | grep 8080
--> Permet de vérifier qu'un processus écoute sur le port 8080.
- Test HTTP : curl http://localhost:8080
--> Permet de vérifier que l'application répond correctement aux requêtes HTTP.

### Gestion avec systemd
- Configuration de l'application comme un service systemd.
--> Afin que le lancement de l'application ne se lance plus seulement manuellement
Fichier de configuration : /etc/systemd/system/devops-app.service
- Rechargement de la configuration : sudo systemctl daemon-reload
--> Permet à systemd de prendre en compte les nouveaux fichiers ou les modifications de configuration.
#Démarrage du service
L'application peut maintenant être démarrée avec : sudo systemctl start devops-app
#Vérification du service
L'état du service peut être vérifié avec : sudo systemctl status devops-app
--> Si c'est ok cela affiche : Active: active (running)
#Redémarrage automatique EN CAS DE CRASH SOUDAIN
(Le service utilise la configuration : Restart=on-failure)
--> Permet à systemd de redémarrer automatiquement l'application lorsqu'elle s'arrête de manière anormale.
- Test 0en arrêtant volontairement le processus Python avec : kill -9 <PID>
--> OK, le service a été relancé automatiquement.

### Gestion des logs
- Logs du service consultés : sudo journalctl -u devops-app
- Suivi des nouveaux logs en temps réel : sudo journalctl -u devops-app -f
--> Un test curl a éyé fait au même moment : OK

### Démarrage automatique à chaque reboot de terminal
- Configuration pour démarrer automatiquement avec le système : sudo systemctl enable devops-app
- Vérification de configuration : sudo systemctl status devops-app
--> OK si : Loaded: loaded (...; enabled; ...) Active: active (running)

### Gestion du projet avec Git
Les différentes étapes du projet sont enregistrées dans Git avec des commits :
- EXEMMPLE D'UN COMMIT : git add app/app.py             git commit -m "Ajout de l'application Python"
- Consultation historique des commits : git log --oneline

---------------------------------------------------------
Prochaines étapes :
- Conteneuriser l'application avec Docker
- Créer un fichier Dockerfile
- Utiliser Docker Compose
- Automatiser le déploiement
- Mettre en place une pipeline CI/CD avec GitHub Actions
- Améliorer la supervision et la gestion de l'application
----------------------------------------------------------

### Script de vérification
- Création script bash d'automatisation, de vérification de disponibilité de l'application :
scripts/verifier_application.sh
- Ajout d'une permission d'execution sur le fichier : chmod +x scripts/verifier_application.sh
