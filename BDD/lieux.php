<?php
	header("Access-Control-Allow-Origin: *");
	header("Content-Type: application/json; charset=UTF-8");

	include('./connection_bdd.php');
	$requete = $dbh->prepare("SELECT * FROM site order by nomlieu");
	$requete->execute();


	$outp = "";
	while($rs = $requete->fetch(PDO::FETCH_ASSOC)) 
	{
		
    	if ($outp != "")
    	{
	    		$outp .= ",";
	    }
	        	
    	$outp .= '{"Lieu" : "'  . utf8_encode($rs["NomLieu"]).'", "IDL" : "'.$rs['IDL'].'", "Categorie" :"'.$rs['Categorie'].'"}';


	}
	$outp='{"lieux":['.$outp.']}';

	echo $outp;
?>