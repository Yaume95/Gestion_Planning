<?php

	include('./connection_bdd.php');
	$params = json_decode(file_get_contents('php://input'),true);

	$dbh->beginTransaction();

	$requete = $dbh->prepare("INSERT INTO personne(Nom,NbHaFaire,CAapMax,CAavMax) VALUES(:Nom,:NbHaFaire,:CAapMax,:CAavMax) ");

	$requete->bindParam(':Nom', $Nom);
	$requete->bindParam(':NbHaFaire', $NbHaFaire);
	$requete->bindParam(':CAapMax', $CAapMax);
	$requete->bindParam(':CAavMax', $CAavMax);
	

	$Nom=utf8_decode($params['Nom']);
	$NbHaFaire=$params['NbHaFaire'];
	$CAapMax=$params['CAapMax'];
	$CAavMax=$params['CAavMax'];

	$requete->execute();
	$dbh->commit();
	
?>