<?php

	include('./connection_bdd.php');
	$params = json_decode(file_get_contents('php://input'),true);
	//var_dump($params);
	$dbh->beginTransaction();

	$requete = $dbh->prepare("DELETE from horaires where IDP=:IDP and IDL=:IDL and Date_jour=:Date_jour");

	$requete->bindParam(':IDP', $IDP);
	$requete->bindParam(':IDL', $IDL);
	$requete->bindParam(':Date_jour', $Date_jour);
	


	$IDP=$params['IDP'];
	$IDL=$params['IDL'];
	$Date_jour=$params['Date_jour'];

	$requete->execute();
	$dbh->commit();
	
?>