<?php

	include('./connection_bdd.php');
	$params = json_decode(file_get_contents('php://input'),true);

	$dbh->beginTransaction();

	$requete = $dbh->prepare("DELETE from site where IDL=:IDL");

	$requete->bindParam(':IDL', $IDL);

	$IDL=$params['IDL'];

	$requete->execute();
	$dbh->commit();
	
?>