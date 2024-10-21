# Versions

MySql Connector C++ 8.3
MySql Server 8.0
QT 6.6.2 (Vous aurez besoin de la version physique et non en ligne)

# Démonstration
Suivez les liens contenue dans le fichiers vidéos

# Installation

Visionnez la vidéo intitulée : installation, faites par ma camarade Vanessa
Elle vous expliquera comment importer une bibliothèque mysql pour que
votre QT puisse se connecter à votre localHost

Les ressources de la vidéo sont dans le dossier ressource et sont uniques 
à la version de QT

Si les fichiers ne sont pas les bons, reportez vous à cette page :
https://github.com/thecodemonkey86/qt_mysql_driver/releases

Ensuite importez le fichier gestionhotel.sql situé dans le dossier Base de donnée

Et enfin, modifiez le fichier singleconnection.h pour que les 
variables soient pareils que celles de votre base de donnée


# Le Projet

Une fois lancée, vous arriverez sur une page de connexion,
Il y a 3 interfaces différentes en fonction du type d'utilisateur
Admin, Employé et Client.

Attention pour se connecter avec un compte employé, il faut rentrer
son poste pour l'email puis son numéro d'employé pour le mot de passe
