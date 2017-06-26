rem commande pour creer la tache : schtasks /create /sc monthly /mo lastday /m * /tn ExtractionBDD /tr C:\wamp64\www\Gestion_Planning\Creation_taches\Extraction_mensuelle.bat

C:\wamp64\bin\php\php7.0.10\php.exe -f C:\wamp64\www\Gestion_Planning\BDD\cron.php


 schtasks /create /sc monthly /mo premier /tn MAJCalendrierBDD /tr C:\wamp64\www\Gestion_Planning\Creation_taches\Extraction_mensuelle.bat