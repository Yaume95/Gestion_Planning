<?php
	header("Access-Control-Allow-Origin: *");
	header("Content-Type: application/json; charset=UTF-8");

	include('./connection_bdd.php');

	$requete = $dbh->prepare("SELECT DISTINCT Annee FROM calendrier ORDER BY Annee DESC");


	

	$requete->execute();

	$moisact='';	
	$outp = "";

	

	while($rs = $requete->fetch(PDO::FETCH_ASSOC)) 
	{
		if ($outp != "")
    	{
	    		$outp .= ",\n";
	    }
		
    	$outp .= '{"Annee" : "'  . $rs["Annee"].'"}';

	}
	$outp='{"annees":['.$outp.']}';

	echo $outp;
?>