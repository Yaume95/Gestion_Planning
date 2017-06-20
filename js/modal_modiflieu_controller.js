var idl,nom;
app.controller('modifLieuCtrl', ['$scope', '$http', function($scope,$http)
{
  
    $scope.envoyer_modifs_lieu=function()
    {
    	if ($('#NomSubmitLieu').val() != "")
    	{
    		nom=$('#NomSubmitLieu').val();
    	}
    	else
    	{
    		nom=$scope.LieuModif['Personne'];
    	}


    	idl= $scope.LieuModif['IDL'];

        $http({ 
            method : 'POST',
            url : './BDD/modif_lieu.php',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            data :  {

                        IDL: idl,
                        Nom: nom                        
                    } 
        })
        .then(function successCallback(response)
        {
            $('#ModificationLieu').modal('hide');
        	$('#NomSubmitLieu').val("");
            $scope.formLieu.$setPristine();
        	$scope.refresh();
        });

    }
  
}]);
