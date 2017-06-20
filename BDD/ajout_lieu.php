<?php

	$user='root';
	$pw='';
	$bdd='gestion_planning';
	
	$dbh= new PDO('mysql:host=127.0.0.1;dbname=' . $bdd, $user, $pw);

	$params = json_decode(file_get_contents('php://input'),true);

	$dbh->beginTransaction();

	$requete = $dbh->prepare("INSERT INTO site(NomLieu) VALUES(:Nom) ");

	$requete->bindParam(':Nom', $Nom);
	

	$Nom=$params['Nom'];

	$requete->execute();
	$dbh->commit();
	
?>