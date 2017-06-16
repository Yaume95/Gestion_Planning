<?php

	$user='root';
	$pw='';
	$bdd='gestion_planning';
	
	$dbh= new PDO('mysql:host=127.0.0.1;dbname=' . $bdd, $user, $pw);

	$params = json_decode(file_get_contents('php://input'),true);

	$dbh->beginTransaction();

	$requete = $dbh->prepare("UPDATE personne set Nom=:Nom , NbHaFaire=:NbHaFaire, CAapMax=:CAapMax, CAavMax=:CAavMax where IDP=:IDP");

	$requete->bindParam(':IDP', $IDP);
	$requete->bindParam(':Nom', $Nom);
	$requete->bindParam(':NbHaFaire', $NbHaFaire);
	$requete->bindParam(':CAapMax', $CAapMax);
	$requete->bindParam(':CAavMax', $CAavMax);
	


	$IDP=$params['IDP'];
	$Nom=$params['Nom'];
	$NbHaFaire=$params['NbHaFaire'];
	$CAapMax=$params['CAapMax'];
	$CAavMax=$params['CAavMax'];

	$requete->execute();
	$dbh->commit();
	
?>