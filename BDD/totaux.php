<?php
	header("Access-Control-Allow-Origin: *");
	header("Content-Type: application/json; charset=UTF-8");

	include('./connection_bdd.php');
	$params = json_decode(file_get_contents('php://input'),true);


	$requete = $dbh->prepare("SELECT Nom,Prenom,sum(nbheures) as Heures,month(date_jour) as Mois,categorie FROM personne join horaires on personne.IDP=horaires.IDP join site on horaires.IDL=site.IDL join categories on site.Categorie=categories.NumCat where nbheures>0 and year(horaires.Date_jour)=:Annee group by nom,prenom,mois,categorie order by Nom,categorie");


	$requete->bindParam(':Annee', $Annee);
	$Annee=$params['Annee'];



	$requete->execute();


	$outp = "";
	while($rs = $requete->fetch(PDO::FETCH_ASSOC)) 
	{
		$moisact=$rs["Mois"];
    	if ($outp != "")
    	{
	    		$outp .= ",";
	    }
	    switch ($moisact) {
	    	case "1":
	    		$j="Janvier";
	    		break;
	    	case "2":
	    		$j="Février";
	    		break;
	    	case "3":
	    		$j="Mars";
	    		break;
	    	case "4":
	    		$j="Avril";
	    		break;
			case "5":
	    		$j="Mai";
	    		break;
	    	case "6":
	    		$j="Juin";
	    		break;
	    	case "7":
	    		$j="Juillet";
	    		break;
	    	case "8":
	    		$j="Aout";
	    		break;
	    	case "9":
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
    	
    	$outp .= '{"Nom" : "'  . $rs["Nom"].'", "Prenom" : "'.$rs['Prenom'].'", "Mois" : "'.$j.'", "Total" : "'.$rs['Heures'].'", "Categorie" : "'.$rs['categorie'].'" }';

	}
	$outp='{"totaux":['.$outp.']}';

	echo $outp;
	
?>