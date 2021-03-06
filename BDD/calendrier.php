<?php
	header("Access-Control-Allow-Origin: *");
	header("Content-Type: application/json; charset=UTF-8");

	include('./connection_bdd.php');
	$params = json_decode(file_get_contents('php://input'),true);

	$requete = $dbh->prepare("SELECT * FROM calendrier where month(Date_jour)=:Mois and Annee=:Annee");

	$requete->bindParam(':Mois', $Mois);
	$requete->bindParam(':Annee', $Annee);
	$Annee=$params['Annee'];
	$Mois=$params['Mois'];


	$requete->execute();


	$outp = "";

	switch ($Mois) {
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

	while($rs = $requete->fetch(PDO::FETCH_ASSOC)) 
	{
		
    	if ($outp != "")
    	{
	    		$outp .= ",";
	    }
	    
	    switch ($rs["Num_jour"]) {
	    	case 1:
	    		$i='Lun';
	    		break;
	    	case 2:
	    		$i ='Mar';
	    		break;
	    	case 3:
	    		$i = 'Mer';
	    		break;
	    	case 4:
	    		$i= 'Jeu';
	    		break;
	    	case 5:
	    		$i = 'Ven';
	    		break;
	    	case 6:
	    		$i ='Sam';
	    		break;
	    	case 7:
	    		$i= 'Dim';
	    		break;
	    	
	    	
	    	
	    }
    	
    	$outp .= '{"Date_jour" : "'  . $rs["Date_jour"].'", "Jour" : "'.$i.'", "Mois" : "'.$j.'", "Ferie" : "'.$rs['Ferie'].'", "Annee" : "'.$rs['Annee'].'" }';

	}
	$outp='{"calendrier":['.$outp.']}';

	echo $outp;
?>