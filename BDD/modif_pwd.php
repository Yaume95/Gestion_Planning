<?php

	include('./connection_bdd.php');
	$params = json_decode(file_get_contents('php://input'),true);

	$dbh->beginTransaction();

	$requete = $dbh->prepare("UPDATE Admin set Mdp=:Mdp");

	$requete->bindParam(':Mdp', $Mdp);
	

	$Mdp=$params['Mdp'];
	$requete->execute();

	$outp = "";
	$rs = $requete->fetch(PDO::FETCH_ASSOC) ;
    $outp=$rs['Mdp'];


	echo $outp;

	
?>