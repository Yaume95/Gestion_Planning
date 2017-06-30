<?php header('Content-Type: text/html; charset=utf-8');

	
	include('./connection_bdd.php');
	$params = json_decode(file_get_contents('php://input'),true);

	$dbh->beginTransaction();

	$requete = $dbh->prepare("INSERT INTO site(NomLieu,Categorie) VALUES(:Nom,:Categorie) ");

	$requete->bindParam(':Nom', $Nom);
	$requete->bindParam(':Categorie', $Categorie);
	

	$Categorie=utf8_decode($params['Categorie']);
	$Nom=utf8_decode($params['Nom']);

	$requete->execute();
	$dbh->commit();
	
?>