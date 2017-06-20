<?php

	$user='root';
	$pw='';
	$bdd='gestion_planning';
	
	$dbh= new PDO('mysql:host=127.0.0.1;dbname=' . $bdd, $user, $pw);

	$params = json_decode(file_get_contents('php://input'),true);

	$dbh->beginTransaction();

	$requete = $dbh->prepare("UPDATE site set NomLieu=:Nom where IDL=:IDL");

	$requete->bindParam(':IDL', $IDL);
	$requete->bindParam(':Nom', $Nom);

	


	$IDL=$params['IDL'];
	$Nom=$params['Nom'];


	$requete->execute();
	$dbh->commit();
	
?>