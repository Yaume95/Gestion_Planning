<?php

	$user='root';
	$pw='';
	$bdd='gestion_planning';
	
	$dbh= new PDO('mysql:host=127.0.0.1;dbname=' . $bdd, $user, $pw);	

	$num_day = idate('w');

	$dbh->beginTransaction();

	$requete = $dbh->prepare("call AjoutDatesCalendrier(:NumDay)");

	$requete->bindParam(':NumDay', $NumDay);
	$NumDay=$num_day;

	$requete->execute();

	$dbh->commit();

?>