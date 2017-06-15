<?php

	$user='root';
	$pw='';
	$bdd='gestion_planning';
	
	$dbh= new PDO('mysql:host=127.0.0.1;dbname=' . $bdd, $user, $pw);

	$params = json_decode(file_get_contents('php://input'),true);

	$dbh->beginTransaction();

	$requete = $dbh->prepare("DELETE from personne where IDP=:IDP");

	$requete->bindParam(':IDP', $IDP);

	$IDP=$params['IDP'];

	$requete->execute();
	$dbh->commit();
	
?>