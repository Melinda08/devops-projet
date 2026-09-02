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
scripts/verifier_application.sh    (test du port 8080 avec curl)
- Ajout d'une permission d'execution sur le fichier : chmod +x scripts/verifier_application.sh
- Ajout d'un (test de systemd) dans le script : systemctl is-active --quiet devops-app

### Conteneurisation avec Docker
- Création d'un Dockerfile afin de construire une image Docker de l'application.
- Construction de l'image avec : docker build -t devops-app .
- Création et lancement d'un conteneur avec : docker run -d --name devops-app-container -p 8081:8080 devops-app
- Vérification du conteneur avec : docker ps
- Test de l'application avec : curl http://localhost:8081
--> Réponse obtenue : Bonjour depuis mon application DevOps !

### Persistance des données avec Docker Volumes
- Création d'un volume Docker : docker volume create devops-data
- Montage du volume dans un conteneur avec : -v devops-data:/data
- Test de persistance des données après suppression du conteneur.
--> Le fichier test.txt reste disponible après la suppression du conteneur.

### Gestion avec Docker Compose
- Création du fichier docker-compose.yml afin de centraliser la configuration du conteneur.
- Configuration du port 8081:8080 et du volume devops-data.
- Vérification de la configuration avec : docker compose config
- Démarrage de l'application avec : docker compose up -d
- Vérification avec : docker compose ps
- Test HTTP avec : curl http://localhost:8081
--> Réponse obtenue : Bonjour depuis mon application DevOps !

###### Mise en place de la CI avec GitHub Actions
- Création du workflow : .github/workflows/ci.yml (pour automatiser les vérifications du projet).
--> La pipeline est déclenchée automatiquement lors d'un git push sur la branche main.
--> Utilisation d'une machine virtuelle Ubuntu fournie par GitHub Actions.
--> Récupération du code source avec actions/checkout.
--> Construction automatique de l'image Docker avec : docker build -t devops-app .
--> Démarrage automatique d'un conteneur Docker pour tester l'application.
--> Vérification de l'état du conteneur avec : docker ps -a
--> Attente du démarrage de l'application avant les tests avec : sleep 3 (Je n'avais pas ajouté cette étape avant, mais j'ai eu une erreur lors du test sur GitHub, car l'application se lancait trop tard alors que le conteneur était déjà en train de tourner donc il n'a pas considéré l'application)
--> Test HTTP avec : curl http://localhost:8081
--> Vérification automatique du contenu de la réponse retournée par l'application.

--> La pipeline CI permet ainsi de vérifier automatiquement que l'application Dockerisée fonctionne correctement après chaque modification envoyée sur GitHub.
--> Execution de la pipeline : réussie.

### Mise en place d'une VM Ubuntu Server
---> Afin de se rapprocher d'un environnement d'administration système réel, une machine virtuelle Ubuntu Server a été mise en place avec VirtualBox.
--> Cette VM sert notamment à héberger le runner utilisé par GitHub Actions.

Installation d'Ubuntu Server.
Installation et vérification de Git.
Installation de curl.
Installation et configuration de Docker.
Installation de Docker Compose.

- Vérification de Docker : docker --version
- Vérification de Docker Compose : docker compose version

# Mise en place d'un Self-Hosted Runner
--> Un runner GitHub Actions a été installé directement sur la VM Ubuntu Server.
Répertoire utilisé : ~/actions-runner
--> Le runner permet à GitHub Actions d'exécuter les différentes étapes de la pipeline directement sur la VM personnelle plutôt que sur une machine virtuelle fournie par GitHub.

- Configuration du runner avec le dépôt GitHub : https://github.com/Melinda08/devops-projet
- Lancement du runner : ./run.sh
--> Le runner se connecte à GitHub et reste en attente des jobs.
- Exécution de la CI sur le Self-Hosted Runner
Le workflow GitHub Actions a été configuré avec : runs-on: self-hosted
--> La pipeline exécute donc désormais les commandes directement sur la VM Ubuntu.

* Architecture actuelle *
        Git push
           ↓
         GitHub
           ↓
     GitHub Actions
           ↓
    Self-Hosted Runner
           ↓
     VM Ubuntu Server
           ↓
        Docker
           ↓
  Tests de l'application

### Gestion des permissions Docker
-> Lors de la première exécution de la CI sur le self-hosted runner, une erreur de permission a été rencontrée lors de l'accès à Docker : permission denied while trying to connect to the Docker API
Le problème provenait des permissions de l'utilisateur exécutant le runner.
- L'utilisateur a été ajouté au groupe Docker : sudo usermod -aG docker $USER
- Puis le nouveau groupe a été pris en compte avec : newgrp docker
- Vérification : docker ps
--> Docker est désormais utilisable sans sudo par l'utilisateur exécutant le runner.

### Validation de la CI
Après correction des permissions Docker, une nouvelle exécution de la pipeline a été effectuée.
--> Job test completed with result: Succeeded
La CI fonctionne donc actuellement sur la VM Ubuntu via le Self-Hosted Runner.

#### Fiabilisation de la CI
(Lors des premières exécutions de la pipeline sur le Self-Hosted Runner, un conflit a été rencontré lorsqu'un ancien conteneur de test existait déjà sur la VM.) : Conflict. The container name "/devops-app-test" is already in use
- Etape de nettoyage automatique ajoutée avant le lancement du conteneur : docker rm -f devops-app-test || true
--> Si un ancien conteneur existe, il est supprimé avant la création du nouveau.
--> Si aucun conteneur n'existe, la pipeline continue malgré l'erreur grâce à || true.

##### Validation finale de la CI
(La CI est désormais fonctionnelle et peut être exécutée après chaque git push sur la branche main.)
----> Le git push déclenche la pipeline, qui vérifie automatiquement que l'application peut être construite, démarrée et testée correctement sur la VM Ubuntu via le Self-Hosted Runner.

### Publication de l'image Docker sur GitHub Container Registry (GHCR)

- Ajout de la publication automatique de l'image Docker sur GitHub Container Registry (GHCR).
- Authentification à GHCR avec le `GITHUB_TOKEN` fourni par GitHub Actions.
- Tag de l'image : `ghcr.io/melinda08/devops-projet:latest`
- Publication automatique de l'image avec :
  `docker push ghcr.io/melinda08/devops-projet:latest`

--> L'image Docker est désormais stockée dans GitHub Container Registry et peut être récupérée depuis la VM Ubuntu.

### Déploiement automatique en production

- Ajout d'une étape de récupération de la nouvelle image depuis GHCR :
  `docker pull ghcr.io/melinda08/devops-projet:latest`
- Suppression automatique de l'ancien conteneur de production :
  `docker rm -f devops-prod || true`
- Déploiement automatique de la nouvelle version :
  `docker run -d --name devops-prod -p 8082:8080 ghcr.io/melinda08/devops-projet:latest`
- Vérification de l'état du conteneur avec : `docker ps`
- Test HTTP de la production avec : `curl http://localhost:8082`
- Vérification automatique de la réponse de l'application.

--> Le déploiement est maintenant entièrement automatisé après un `git push` sur la branche `main`.

### Validation finale du CI/CD

Le pipeline réalise désormais automatiquement les étapes suivantes :

`Git push`
↓
`GitHub`
↓
`GitHub Actions`
↓
`Self-Hosted Runner`
↓
`Build de l'image Docker`
↓
`Tests de l'application`
↓
`Publication sur GHCR`
↓
`Récupération de l'image`
↓
`Déploiement sur la VM Ubuntu`
↓
`Test de l'application en production`

--> La pipeline CI/CD a été exécutée avec succès.

--> L'application est automatiquement construite, testée, publiée et déployée sur la VM Ubuntu Server après chaque modification envoyée sur GitHub.
