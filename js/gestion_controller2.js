app.controller('gestion_controller2', ['$scope','$http','$window','$location','$rootScope', function($scope, $http,$location,$window,$rootScope)
{

    

	$scope.initGestion2=function()
	{

        $http.get("./BDD/lieux.php")
        .then(function (response)
        {
            $scope.Lieux =response.data.lieux
        });

        $scope.AjoutDemande=false;
	}

    $scope.demandeAjout= function()
    {
        $scope.AjoutDemande=true;
    }

    $scope.annulerDemande= function()
    {
        $scope.AjoutDemande=false;
    }

    $scope.confirmerDemande= function(nom)
    {
        nom= nom.charAt(0).toUpperCase() +nom.substring(1);
        $http({ 
            method : 'POST',
            url : './BDD/ajout_lieu.php',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            data :  {
                        Nom: nom                           
                    } 
        })
        .then(function successCallback(response) {
            console.log(nom);
            $scope.refresh();
        });
        $scope.AjoutDemande=false;
    
        $scope.refresh();
    }

    $scope.refresh=function()
    {
       $http.get("./BDD/lieux.php")
      .then(function (response) 
      {
          $scope.Lieux= response.data.lieux;
      }); 
   }

    $scope.validSuppression=function(idl)
    {
        if(confirm("Êtes-vous sur de vouloir supprimer ce lieu de la base de données ?"))
        {
            $http({ 
                method : 'POST',
                url : './BDD/suppression_lieu.php',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                data :  {
                            IDL: idl                            
                        } 
            })
            .then(function successCallback(response) 
            {
                $scope.refresh();
            });
            $scope.refresh();
        }
        $scope.refresh();
    }


    $scope.modificationLieu=function(object)
    {
        $('#ModificationLieu').modal('show')

        console.log(object);

        $scope.LieuModif=[];

        $scope.LieuModif['Lieu']=object.Lieu;
        $scope.LieuModif['IDL']=object.IDL;


        $scope.refresh()
    }

	
}]);