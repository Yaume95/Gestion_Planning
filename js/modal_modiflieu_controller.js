var idl,nom;
app.controller('modifLieuCtrl', ['$scope', '$http', function($scope,$http)
{

    $scope.envoyer_modifs_lieu=function()
    {
    	if ($('#NomSubmitLieu').val() != "")
        {
            nom=$('#NomSubmitLieu').val();
            nom= nom.charAt(0).toUpperCase() +nom.substring(1);
            
        }
        else
        {
            nom=$scope.LieuModif['Lieu'];
        }

    
        cat=$('#CatSubmitLieu option:selected').val();
    	idl= $scope.LieuModif['IDL'];

        $http({ 
            method : 'POST',
            url : './BDD/modif_lieu.php',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            data :  {

                        IDL: idl,
                        Nom: nom,                        
                        Categorie: cat                        
                    } 
        })
        .then(function successCallback(response)
        {
            $('#ModificationLieu').modal('hide');
            $('#NomSubmitLieu').val("");
        	$('#CatSubmitLieu').val("");
            $scope.formLieu.$setPristine();
        	$scope.refresh();
        });

    }
  
}]);
