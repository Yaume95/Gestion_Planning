<?php
	header("Access-Control-Allow-Origin: *");
	header("Content-Type: application/json; charset=UTF-8");

	include('./connection_bdd.php');
	$requete = $dbh->prepare("SELECT * FROM personne order by nom");
	$requete->execute();


	$outp = "";
	while($rs = $requete->fetch(PDO::FETCH_ASSOC)) 
	{
		
    	if ($outp != "")
    	{
	    		$outp .= ",";
	    }
	        	
    	$outp .= '{"Personne" : "'  . utf8_encode($rs["Nom"]).'", "IDP" : "'.$rs['IDP'].'", "Total" : "'.$rs["NbHFaites"].'/'.$rs['NbHaFaire'].'", "RTT" : "'.$rs['RTTpris'].'", "Maladie" : "'.$rs['NbJMal'].'","CAav" :"'.$rs["CAavPris"].'/'.$rs['CAavMax'].'", "CA" : "'.$rs["CAapPris"].'/'.$rs['CAapMax'].'"}';


	}
	$outp='{"employes":['.$outp.']}';

	echo $outp;
?>