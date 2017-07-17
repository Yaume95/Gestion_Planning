<?php
	header("Access-Control-Allow-Origin: *");
	header("Content-Type: application/json; charset=UTF-8");

	include('./connection_bdd.php');

	

	$params = json_decode(file_get_contents('php://input'),true);

	$requete = $dbh->prepare("SELECT horaires.IDL, count(DISTINCT IDP) as Presences, Month(Date_jour) as Mois, Date_jour FROM `horaires` join site on site.IDL=horaires.IDL WHERE Etat='Travail' and Type=:Type group by horaires.idl,Mois,date_jour");


	$requete->bindParam(':Type', $Type);
	$Type=$params['Type'];	
	$requete->execute();

	$requete2=$dbh->prepare("SELECT Nom FROM `horaires`join personne on horaires.IDP=personne.IDP WHERE Etat='Travail' And Date_jour=:Date_jour and IDL=:IDL group by Nom");


	$outp = "";
	while($rs = $requete->fetch(PDO::FETCH_ASSOC)) 
	{
    	if ($outp != "")
    	{
	    		$outp .= ",";
	    }

		$requete2->bindParam(':IDL', $IDL);
		$requete2->bindParam(':Date_jour', $Date_jour);
		
		$IDL=$rs['IDL'];
		$Date_jour=$rs['Date_jour'];

		$noms="";

		$requete2->execute();

		while($rs2 = $requete2->fetch(PDO::FETCH_ASSOC))
		{
			if($noms!="") $noms.='\n';
			 $noms.=$rs2['Nom'];
		}




    	$outp .= '{"IDL" : "'  . $rs["IDL"].'", "Mois" : "'.$rs['Mois'].'", "Date" : "'.$rs['Date_jour'].'", "Nombre" : "'.$rs['Presences'].'", "Noms" : "'.$noms.'"}';
		


	}
	$outp='{"presences":['.$outp.']}';

	echo $outp;
?>