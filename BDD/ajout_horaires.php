<?php

	include('./connection_bdd.php');
	$params = json_decode(file_get_contents('php://input'),true);
	//var_dump($params);
	$dbh->beginTransaction();

	$requete = $dbh->prepare("INSERT INTO horaires (IDP,IDL,Date_jour,NbHeures,Etat) VALUES(:IDP,:IDL,:Date_jour,:NbHeures,'Travail');");

	$requete->bindParam(':IDP', $IDP);
	$requete->bindParam(':IDL', $IDL);
	$requete->bindParam(':Date_jour', $Date_jour);
	$requete->bindParam(':NbHeures', $NbHeures);


	$IDP=$params['IDP'];
	$IDL=$params['IDL'];
	$NbHeures=$params['NbHeures'];
	$Date_jour=$params['Date_jour'];

	$requete->execute();
	$dbh->commit();
	
?>