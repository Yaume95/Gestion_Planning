<?php
	header("Access-Control-Allow-Origin: *");
	header("Content-Type: application/json; charset=UTF-8");

	include('./connection_bdd.php');
	$requete = $dbh->prepare("SELECT * FROM categories");
	$requete->execute();


	$outp = "";
	while($rs = $requete->fetch(PDO::FETCH_ASSOC)) 
	{
		
    	if ($outp != "")
    	{
	    		$outp .= ",";
	    }
	        	
    	$outp .= '{"Categorie" : "'  . $rs["NumCat"].'", "Nom_Cat" : "'.utf8_encode($rs['NomCat']).'"}';


	}
	$outp='{"categories":['.$outp.']}';

	echo $outp;
?>