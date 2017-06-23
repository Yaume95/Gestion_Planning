<?php

	include('./connection_bdd.php');
	$params = json_decode(file_get_contents('php://input'),true);

	$dbh->beginTransaction();

	$requete = $dbh->prepare("UPDATE site set NomLieu=:Nom where IDL=:IDL");

	$requete->bindParam(':IDL', $IDL);
	$requete->bindParam(':Nom', $Nom);

	


	$IDL=$params['IDL'];
	$Nom=utf8_decode($params['Nom']);


	$requete->execute();
	$dbh->commit();
	
?>