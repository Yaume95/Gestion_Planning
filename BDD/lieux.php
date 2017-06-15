<?php
	header("Access-Control-Allow-Origin: *");
	header("Content-Type: application/json; charset=UTF-8");

	$user='root';
	$pw='';
	$bdd='gestion_planning';
	
	$dbh= new PDO('mysql:host=127.0.0.1;dbname=' . $bdd, $user, $pw);

	$requete = $dbh->prepare("SELECT NomLieu,IDL FROM site");
	$requete->execute();


	$outp = "";
	while($rs = $requete->fetch(PDO::FETCH_ASSOC)) 
	{
		
    	if ($outp != "")
    	{
	    		$outp .= ",";
	    }
	        	
    	$outp .= '{"Lieu" : "'  . utf8_encode($rs["NomLieu"]).'", "IDL" : "'.$rs['IDL'].'"}';


	}
	$outp='{"lieux":['.$outp.']}';

	echo $outp;


?>