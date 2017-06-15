<?php

	$user='root';
	$pw='';
	$bdd='gestion_planning';
	
	$dbh= new PDO('mysql:host=127.0.0.1;dbname=' . $bdd, $user, $pw);

	$params = json_decode(file_get_contents('php://input'),true);
	//var_dump($params);
	$dbh->beginTransaction();

	$requete = $dbh->prepare("UPDATE horaires set NbHeures=:NbHeures , Etat='Travail' where IDP=:IDP and IDL=:IDL and Date_jour=:Date_jour");

	$requete->bindParam(':IDP', $IDP);
	$requete->bindParam(':IDL', $IDL);
	$requete->bindParam(':NbHeures', $NbHeures);
	$requete->bindParam(':Date_jour', $Date_jour);
	


	$IDP=$params['IDP'];
	$IDL=$params['IDL'];
	$NbHeures=$params['NbHeures'];
	$Date_jour=$params['Date_jour'];

	$requete->execute();
	$dbh->commit();
	
?>