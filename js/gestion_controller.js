app.controller('gestion_controller', ['$scope','$http','$window','$location','$rootScope', function($scope, $http,$location,$window,$rootScope)
{

    $scope.PersonneModif=[];

	$scope.initGestion=function()
	{

        $http.get("./BDD/employes.php")
        .then(function (response)
        {
        	$scope.Employes = response.data.employes;
        });

        $http.get("./BDD/lieux.php")
        .then(function (response)
        {
            $scope.Lieux =response.data.lieux
        });

        $scope.Recherche="";
	}

    $scope.refresh=function()
    {
       $http.get("./BDD/employes.php")
      .then(function (response) 
      {
          $scope.Employes = response.data.employes;
      }); 
   }

    $scope.validSuppression=function(idp)
    {
        if(confirm("Êtes-vous sur de vouloir supprimer cette personne de la base de données ?"))
        {
            $http({ 
                method : 'POST',
                url : './BDD/suppression_personne.php',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                data :  {
                            IDP: idp                            
                        } 
            })
            $scope.refresh();
        }
        $scope.refresh();
    }

    $scope.include=function(string,Liste)
    {
        x=false;
        angular.forEach(Liste, function(value,key)
        {
            if(value.Personne.toLowerCase().includes(string.toLowerCase()) )
            {
                x = true;
            }
        });

        return x;
    }

    $scope.modification=function(object)
    {

        $('#Modification').modal('show');

        $scope.PersonneModif['IDP']=object.IDP;
        $scope.PersonneModif['Personne']=object.Personne;
        $scope.PersonneModif['Total']=substr(object.Total,"/");
        $scope.PersonneModif['CA']=substr(object.CA,"/");
        $scope.PersonneModif['CAav']=substr(object.CAav,"/");

        $scope.refresh();

    }

    $scope.ajouter=function()
    {
        $('#Ajout').modal('show');
    }

    $scope.redirectPlanning=function(object)
    {
        $rootScope.redirect=true;
        $rootScope.planningRedirect=object.IDP;
        location.hash="#!/Planning_Personnel";
    }
	
}]);

function substr(s,separator)
{
    return s.substring(s.indexOf(separator) + 1);
}