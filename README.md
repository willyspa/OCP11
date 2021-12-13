# RG01

Lorsque le champ « Status » passe du statut « Draft » à « Active », un traitement trigger se déclenche pour appeler une classe apex qui vérifie que l’order en
question possède des produits. Si l’order ne possède pas de produits, la modification est bloquée et un message d’erreur invitant l’utilisateur à saisir des
produits avant d’activer l’order est affiché.

# RG02

Lorsqu’un order est supprimé, un trigger est  déclenché à la suppression  pour appeler une classe apex  qui vérifie qu’il n’y a aucun autre order rattaché au compte. S’il y a aucun autre order rattaché à ce compte, la case Active__c sera décochée si elle a été cochée.

# RG03

Création d’une classe batch apex qui se déclenche le  premier lundi de chaque mois  qui récupère les comptes  n’ayant pas d’order associés  ni des tâches de rappel et  crée des tâches et les  rattachent à ce compte.

Détails de la tâche à créer :
- Sujet : « Call »
- Statut : « Nouvelle »
- Priorité : « Normale »
- Rappel automatique dans 5 jours
