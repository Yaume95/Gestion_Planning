app.controller('gestion_controller', ['$scope','$http','$window','$location','$rootScope', function($scope, $http,$location,$window,$rootScope)
{

    $scope.PersonneModif=[];

    $scope.Types= ['ASEM','Agent','Animation'];
    $scope.Contrats= ['Titulaire','Vaccataire','Remplaçant'];

    $scope.SelectionTypeAjout=$scope.Types[0];
    $scope.SelectionContratAjout=$scope.Contrats[0];

	$scope.initGestion=function()
	{

        $http.get("./BDD/employes2.php")
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
       $http.get("./BDD/employes2.php")
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
            .then(function successCallback(response) 
            {
                      $scope.refresh();
            });
        }
        $scope.refresh();
    }

    $scope.include=function(string,Liste)
    {
        x=false;
        angular.forEach(Liste, function(value,key)
        {
            if(value.Personne.toLowerCase().search(string.toLowerCase()) >-1 )
            {
                x = true;
            }
        });

        return x;
    }

    $scope.vaccataire= function(Personne)
    {
        if(Personne.Vaccataire==1)
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    $scope.titre=function(personne)
    {
        if(personne.Vaccataire==1)
        {
            return 'Vaccataire';
        }
        else
        {
            return 'Titulaire';
        }
    }
    $scope.modification=function(object)
    {

        $('#Modification').modal('show');

        $scope.PersonneModif['IDP']=object.IDP;
        $scope.PersonneModif['Personne']=object.Personne;
        $scope.PersonneModif['Prenom']=object.Prenom;
        $scope.PersonneModif['Type']=object.Type;
        $scope.PersonneModif['Total']=substr(object.Total,"/");
        $scope.PersonneModif['CA']=substr(object.CA,"/");
        $scope.PersonneModif['CAav']=substr(object.CAav,"/");
        $scope.PersonneModif['Contrat']=object.Contrat;
        $scope.PersonneModif['Matricule']=object.Matricule  ;

        $scope.SelectionTypeModif=object.Type;
        $scope.SelectionContratModif=object.Contrat;

        $scope.refresh();

    }


    $scope.ajouter=function()
    {
        $('#Ajout').modal('show');
    }

    $scope.redirectPlanning=function(object,place)
    {
        $rootScope.redirect=true;
        $rootScope.place= place;
        $rootScope.planningRedirect=object.IDP;
        location.hash="#!/Planning_Personnel";
    }
	
}]);

function substr(s,separator)
{
    return s.substring(s.indexOf(separator) + 1);
}