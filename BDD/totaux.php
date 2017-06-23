<?php
	header("Access-Control-Allow-Origin: *");
	header("Content-Type: application/json; charset=UTF-8");
	include('./connection_bdd.php');

	$requete = $dbh->prepare("call config_";	$requete->execute();


	$outp = "";
	while($rs = $requete->fetch(PDO::FETCH_ASSOC)) 
	{
		
    	if ($outp != "")
    	{
	    		$outp .= ",";
	    }
	        	
    	$outp .= '{"Personne" : "'  . utf8_encode($rs["Nom"]).'" }';


	}
	$outp='{"employes":['.$outp.']}';

	echo $outp;
?>