<?php

	include('./connection_bdd.php');
	$params = json_decode(file_get_contents('php://input'),true);

	$dbh->beginTransaction();

	$requete = $dbh->prepare("INSERT INTO personne(Nom,Prenom,NbHaFaire,CAapMax,CAavMax,Contrat,Type,Matricule) VALUES(:Nom,:Prenom,:NbHaFaire,:CAapMax,:CAavMax,:Contrat,:Type,:Matricule) ");

	$requete->bindParam(':Nom', $Nom);
	$requete->bindParam(':Prenom', $Prenom);
	$requete->bindParam(':NbHaFaire', $NbHaFaire);
	$requete->bindParam(':CAapMax', $CAapMax);
	$requete->bindParam(':CAavMax', $CAavMax);
	$requete->bindParam(':Contrat', $Contrat);
	$requete->bindParam(':Matricule', $Matricule);
	$requete->bindParam(':Type', $Type);

	

	$Nom=utf8_decode($params['Nom']);
	$Prenom=utf8_decode($params['Prenom']);
	$NbHaFaire=$params['NbHaFaire'];
	$CAapMax=$params['CAapMax'];
	$CAavMax=$params['CAavMax'];
	$Contrat=$params['Contrat'];
	$Matricule=$params['Matricule'];
	$Type=$params['Type'];

	$requete->execute();
	$dbh->commit();
	
?>