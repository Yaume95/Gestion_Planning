<?php
	header("Access-Control-Allow-Origin: *");
	header("Content-Type: application/json; charset=UTF-8");

	include('./connection_bdd.php');
	$requete = $dbh->prepare("SELECT personne.IDP, horaires.IDL, Date_jour,NbHeures,Etat from horaires join personne on personne.IDP=horaires.IDP join site on site.IDL = horaires.IDL ORDER BY horaires.IDP ASC, horaires.Date_jour ASC");
	$requete->execute();


	$outp = "";
	while($rs = $requete->fetch(PDO::FETCH_ASSOC)) 
	{
		$moisact=$rs["Date_jour"][5].$rs["Date_jour"][6];
    	if ($outp != "")
    	{
	    		$outp .= ",";
	    }
	    switch ($moisact) {
	    	case "01":
	    		$j="Janvier";
	    		break;
	    	case "02":
	    		$j="Février";
	    		break;
	    	case "03":
	    		$j="Mars";
	    		break;
	    	case "04":
	    		$j="Avril";
	    		break;
			case "05":
	    		$j="Mai";
	    		break;
	    	case "06":
	    		$j="Juin";
	    		break;
	    	case "07":
	    		$j="Juillet";
	    		break;
	    	case "08":
	    		$j="Aout";
	    		break;
	    	case "09":
	    		$j="Septembre";
	    		break;
	    	case "10":
	    		$j="Octobre";
	    		break;
	    	case "11":
	    		$j="Novembre";
	    		break;
	    	case "12":
	    		$j="Décembre";
	    		break;
	    }
    	$outp .= '{"IDL" : "'.$rs['IDL'].'", "IDP" : "'.$rs['IDP'].'", "Date_jour" : "'.$rs["Date_jour"].'", "Mois" : "'. $j.'", "NbHeures" : "'.$rs["NbHeures"].'", "Etat" : "'.$rs["Etat"].'"}';

	}
	$outp='{"horaires":['.$outp.']}';
	echo $outp;
?>