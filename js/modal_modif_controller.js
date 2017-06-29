var nom, totalH, maxCA, maxCAav,idp;

app.controller('modifCtrl', ['$scope', '$http', function($scope,$http)
{
  
    $scope.envoyer_modifs=function()
    {
    	if ($('#NomSubmit1').val() != "")
    	{
    		nom=$('#NomSubmit1').val();
            nom= nom.charAt(0).toUpperCase() +nom.substring(1);
    	}
    	else
    	{
    		nom=$scope.PersonneModif['Personne'];
    	}


    	if ($('#HSubmit1').val() != "")
    	{
    		totalH=$('#HSubmit1').val();
    	}
    	else
    	{
    		totalH=$scope.PersonneModif['Total'];
    	}


    	if ($('#CASubmit1').val() != "")
    	{
    		maxCA=$('#CASubmit1').val();
    	}
    	else
    	{
    		maxCA=$scope.PersonneModif['CA'];
    	}
    	

    	if ($('#CAavSubmit1').val() != "")
        {
            maxCAav=$('#CAavSubmit1').val();
        }
        else
        {
            maxCAav=$scope.PersonneModif['CAav'];
        }

        if ($('#MatSubmit1').val() != "")
        {
            Mat=$('#MatSubmit1').val();
        }
        else
        {
            Mat=$scope.PersonneModif['Matricule'];
        }


        vac= $('#VacSubmit1').is(':checked');

        console.log(vac);



    	idp= $scope.PersonneModif['IDP'];

        $http({ 
            method : 'POST',
            url : './BDD/modif_personne.php',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            data :  {

                        IDP: idp,
                        Nom: nom,
                        NbHaFaire: totalH,
                        CAapMax: maxCA,
                        CAavMax: maxCAav,
                        Matricule: Mat,
                        Vaccataire: vac
                        
                    } 
        })
        .then(function successCallback(response)
        {
        	$('#Modification').modal('hide');
        	$('#NomSubmit1').val("");
	    	$('#HSubmit1').val("");
	    	$('#CASubmit1').val("");
            $('#CAavSubmit1').val("");
	    	$('#MatSubmit1').val("");
            $scope.myform1.$setPristine();
        	$scope.refresh();


        });

    }
  
}]);
