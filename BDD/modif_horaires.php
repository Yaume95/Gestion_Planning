<?php

	include('./connection_bdd.php');
	$params = json_decode(file_get_contents('php://input'),true);
	//var_dump($params);
	$dbh->beginTransaction();

	$requete = $dbh->prepare("UPDATE horaires set NbHeures=:NbHeures , Etat=:Etat where IDP=:IDP and IDL=:IDL and Date_jour=:Date_jour");

	$requete->bindParam(':IDP', $IDP);
	$requete->bindParam(':IDL', $IDL);
	$requete->bindParam(':NbHeures', $NbHeures);
	$requete->bindParam(':Date_jour', $Date_jour);
	$requete->bindParam(':Etat', $Etat);
	


	$IDP=$params['IDP'];
	$IDL=$params['IDL'];
	$NbHeures=$params['NbHeures'];
	$Date_jour=$params['Date_jour'];
	$Etat=$params['Etat'];

	$requete->execute();
	$dbh->commit();
	
?>