<?php

	include('./connection_bdd.php');
	

	$params = json_decode(file_get_contents('php://input'),true);

	$dbh->beginTransaction();

	$requete = $dbh->prepare("DELETE from personne where IDP=:IDP");

	$requete->bindParam(':IDP', $IDP);

	$IDP=$params['IDP'];

	$requete->execute();
	$dbh->commit();
	
?>