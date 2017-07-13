<?php

	include('./connection_bdd.php');
	$params = json_decode(file_get_contents('php://input'),true);

	$dbh->beginTransaction();

	$requete = $dbh->prepare("UPDATE personne set Nom=:Nom ,Prenom=:Prenom, NbHaFaire=:NbHaFaire, CAapMax=:CAapMax, CAavMax=:CAavMax, Contrat=:Contrat, Matricule=:Matricule, Type=:Type where IDP=:IDP");

	$requete->bindParam(':IDP', $IDP);
	$requete->bindParam(':Nom', $Nom);
	$requete->bindParam(':Prenom', $Prenom);
	$requete->bindParam(':NbHaFaire', $NbHaFaire);
	$requete->bindParam(':CAapMax', $CAapMax);
	$requete->bindParam(':CAavMax', $CAavMax);
	$requete->bindParam(':Contrat', $Contrat);
	$requete->bindParam(':Matricule', $Matricule);
	$requete->bindParam(':Type', $Type);

	

	$IDP=$params['IDP'];
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