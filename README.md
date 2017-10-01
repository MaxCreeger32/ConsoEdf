#ConsoEdf 
## monitoring de la consommation EDF avec RaspBerryPi qui alimente ElasticSearch

Utilisation du [fameux schéma avec un optocoupleur.](http://lhuet.github.io/blog/2014/01/montage-teleinfo.html)  

 - /python : contient le code python d'interrogation du compteur EDF 
 - /elasticSearch : des exemple de requetes ElasticSeach
 - /dart : partie exploitation des données
 - /dart/ConsoService : micro serveur HTTP qui requete Elastic Search et qui expose un service Rest pour le client. 
 - /dart/ConsoClient : Client leger qui affiche les données