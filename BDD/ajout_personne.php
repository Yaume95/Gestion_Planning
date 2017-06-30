<?php

	include('./connection_bdd.php');
	$params = json_decode(file_get_contents('php://input'),true);

	$dbh->beginTransaction();

	$requete = $dbh->prepare("INSERT INTO personne(Nom,Prenom,NbHaFaire,CAapMax,CAavMax,Vaccataire,Matricule) VALUES(:Nom,:Prenom,:NbHaFaire,:CAapMax,:CAavMax,:Vaccataire,:Matricule) ");

	$requete->bindParam(':Nom', $Nom);
	$requete->bindParam(':Prenom', $Prenom);
	$requete->bindParam(':NbHaFaire', $NbHaFaire);
	$requete->bindParam(':CAapMax', $CAapMax);
	$requete->bindParam(':CAavMax', $CAavMax);
	$requete->bindParam(':Vaccataire', $Vaccataire);
	$requete->bindParam(':Matricule', $Matricule);
	

	$Nom=utf8_decode($params['Nom']);
	$Prenom=utf8_decode($params['Prenom']);
	$NbHaFaire=$params['NbHaFaire'];
	$CAapMax=$params['CAapMax'];
	$CAavMax=$params['CAavMax'];
	$Vaccataire=$params['Vaccataire'];
	$Matricule=$params['Matricule'];

	$requete->execute();
	$dbh->commit();
	
?>