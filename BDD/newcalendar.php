<?php

	$user='root';
	$pw='';
	$bdd='gestion_planning';
	
	$dbh= new PDO('mysql:host=127.0.0.1;dbname=' . $bdd, $user, $pw);	

	$params = json_decode(file_get_contents('php://input'),true);
	$Annee=$params['Annee'];


	$num_day = date('L',strtotime(date($Annee+'-01-01')));
	if ($num_day==0) $num_day=7;
	

	$dbh->beginTransaction();

	$requete = $dbh->prepare("call AjoutDatesCalendrier(:NumDay,:Annee)");

	$requete->bindParam(':NumDay', $NumDay);
	$requete->bindParam(':Annee', $Annee);

	$Annee=$params['Annee'];
	$NumDay=$num_day;

	$requete->execute();

	$dbh->commit();
?>