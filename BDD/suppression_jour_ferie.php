<?php

	include('./connection_bdd.php');

	$params = json_decode(file_get_contents('php://input'),true);
	//var_dump($params);
	$dbh->beginTransaction();

	$requete = $dbh->prepare("Update calendrier set ferie=0 where Date_jour=:Date_jour");

	$requete->bindParam(':Date_jour', $Date_jour);

	$Date_jour=$params['Date_jour'];

	$requete->execute();
	$dbh->commit();
	
?>