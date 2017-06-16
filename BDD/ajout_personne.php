<?php

	$user='root';
	$pw='';
	$bdd='gestion_planning';
	
	$dbh= new PDO('mysql:host=127.0.0.1;dbname=' . $bdd, $user, $pw);

	$params = json_decode(file_get_contents('php://input'),true);

	$dbh->beginTransaction();

	$requete = $dbh->prepare("INSERT INTO personne(Nom,NbHaFaire,CAapMax,CAavMax) VALUES(:Nom,:NbHaFaire,:CAapMax,:CAavMax) ");

	$requete->bindParam(':Nom', $Nom);
	$requete->bindParam(':NbHaFaire', $NbHaFaire);
	$requete->bindParam(':CAapMax', $CAapMax);
	$requete->bindParam(':CAavMax', $CAavMax);
	

	$Nom=$params['Nom'];
	$NbHaFaire=$params['NbHaFaire'];
	$CAapMax=$params['CAapMax'];
	$CAavMax=$params['CAavMax'];

	$requete->execute();
	$dbh->commit();
	
?>