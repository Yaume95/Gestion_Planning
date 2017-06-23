<?php 
	$server="localhost";

	$user='root';
	$pw='';
	$bdd='gestion_planning';
	
	$fichier = date('d.m.Y').'-'.date('H').'h'.date('i').'.sql';
	system("C:\wamp64\bin\mysql\mysql5.7.14\bin\mysqldump --host={$server} --user={$user} --password={$pw} {$bdd} > C:/Users/stagiaire/Desktop/$fichier");
?>
