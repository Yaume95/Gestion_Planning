<?php
	header("Access-Control-Allow-Origin: *");
	header("Content-Type: application/json; charset=UTF-8");

	include('./connection_bdd.php');
	$requete = $dbh->prepare("SELECT * FROM personne order by nom");
	$requete->execute();


	$outp = "";
	$x="";
	$y="";
	while($rs = $requete->fetch(PDO::FETCH_ASSOC)) 
	{
		
    	if ($outp != "")
    	{
	    		$outp .= ",";
	    }


	    if($rs["CAavPris"]==$rs["CAavMax"]&& $rs["CAavPris"]==0)
	    {
	    	$x="0";
	    }
	    else
	    {
	    	$x = $rs["CAavPris"].'/'.$rs['CAavMax'];
	    }

	    if($rs["CAapPris"]==$rs["CAapMax"] && $rs["CAapPris"]==0)
	    {
	    	$y="0";
	    }
	    else
	    {
	    	$y = $rs["CAapPris"].'/'.$rs['CAapMax'];
	    }

    	$outp .= '{"Personne" : "'  . utf8_encode($rs["Nom"]).'", "IDP" : "'.$rs['IDP'].'", "Total" : "'.$rs["NbHFaites"].'/'.$rs['NbHaFaire'].'", "RTT" : "'.$rs['RTTpris'].'", "Maladie" : "'.$rs['NbJMal'].'","CAav" :"'.$x.'", "CA" : "'.$y.'"}';


	}
	$outp='{"employes":['.$outp.']}';

	echo $outp;
?>