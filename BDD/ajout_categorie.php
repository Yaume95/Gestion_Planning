<?php header('Content-Type: text/html; charset=utf-8');

	
	include('./connection_bdd.php');
	$params = json_decode(file_get_contents('php://input'),true);

	$dbh->beginTransaction();

	$requete = $dbh->prepare("INSERT INTO Categories(NomCat) VALUES(:NomCat) ");

	$requete->bindParam(':NomCat', $NomCat);
	

	$NomCat=utf8_decode($params['NomCat']);

	$requete->execute();
	$dbh->commit();
	
?>