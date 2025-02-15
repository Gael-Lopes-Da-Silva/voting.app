Dans un terminal, ce placer à la racine du projet (voting.app) et exécutez le script "deploy.bash" qui est dans "run" avec "bash run/deploy.bash".
Cette commande va générer un script reset.bash dans "run" qui permet de supprimer les conteneurs et toutes les données dans les volumes de Redis et Postgre

Une fois la commande fini alors 
- allez sur http://localhost:8080 pour faire un vote. (si on veut tester deux voteur différent alors utilisez deux navigateur différents)
- allez sur http://localhost:8888 pour voir le résultat. (ça se met à jour directement après un vote)