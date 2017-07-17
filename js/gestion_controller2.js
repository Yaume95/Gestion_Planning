app.controller('gestion_controller2', ['$scope','$http','$window','$location','$rootScope', function($scope, $http,$location,$window,$rootScope)
{

    $scope.Types= ['ASEM','Agent','Animation'];
    $scope.SelectionTypeModif=$scope.Types[0];    

	$scope.initGestion2=function()
	{

        $http.get("./BDD/lieux.php")
        .then(function (response)
        {
            $scope.Lieux = response.data.lieux;
        });

        $http.get("./BDD/categories.php")
        .then(function (response)
        {
            $scope.Categories =response.data.categories;
            $scope.SuppressionCat=$scope.Categories[0].Nom_Cat;
        });

        $http({ 
              method : 'POST',
              url : './BDD/lieux.php',
              headers: {'Content-Type': 'application/x-www-form-urlencoded'},
              data :  {
                          Type: 'ASEM'                         
                      } 
        })
        .then(function (response)
        {
            $scope.Lieux =  response.data.lieux
        });

        $scope.AjoutDemande=false;
        $scope.AjoutDemandeCat=false;
        $scope.SupprDemandeCat=false;
	}

    $scope.demandeAjout= function()
    {
        $scope.AjoutDemande=true;
    }

    $scope.demandeAjoutCat= function()
    {
        $scope.AjoutDemandeCat=true;
    }

    $scope.demandeSupprCat= function()
    {
        $scope.SupprDemandeCat=true;
    }

    $scope.annulerDemande= function()
    {
        $scope.AjoutDemande=false;
    }

    $scope.annulerDemandeCat= function()
    {
        $scope.AjoutDemandeCat=false;
    }

    $scope.annulerDemandeSupprCat= function()
    {
        $scope.SupprDemandeCat=false;
    }

    $scope.confirmerDemande= function(nom,cat,type)
    {
        nom= nom.charAt(0).toUpperCase() +nom.substring(1);
        console.log(nom,cat);
        $http({ 
            method : 'POST',
            url : './BDD/ajout_lieu.php',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            data :  {
                        Nom: nom,
                        Categorie: cat,
                        Type: type                           
                    } 
        })
        .then(function successCallback(response) {

            $scope.resetLieux($scope.SelectionTypeModif);
        });
        $scope.AjoutDemande=false;
    
        $scope.resetLieux($scope.SelectionTypeModif);
    }

    $scope.confirmerDemandeCat= function(nom)
    {
        nom= nom.charAt(0).toUpperCase() +nom.substring(1);

        $http({ 
            method : 'POST',
            url : './BDD/ajout_categorie.php',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            data :  {
                        NomCat: nom                         
                    } 
        })
        .then(function successCallback(response) {

            $scope.refresh();
        });
        $scope.AjoutDemandeCat=false;
    
        $scope.refresh();
    }

    $scope.confirmerDemandeSupprCat= function(nom)
    {
        console.log(nom);

        $http({ 
            method : 'POST',
            url : './BDD/suppression_categorie.php',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            data :  {
                        NomCat: nom                         
                    } 
        })
        .then(function successCallback(response) {

            $scope.refresh();
        });
        $scope.SupprDemandeCat=false;
    
        $scope.refresh();
    }

    $scope.refresh=function()
    {

        $http.get("./BDD/categories.php")
        .then(function (response)
        {
            $scope.Categories =response.data.categories;
        });
   }

   $scope.resetLieux=function(type)
   {
        $http({ 
              method : 'POST',
              url : './BDD/lieux.php',
              headers: {'Content-Type': 'application/x-www-form-urlencoded'},
              data :  {
                          Type: type                         
                      } 
        })
        .then(function (response)
        {
            $scope.Lieux =  response.data.lieux
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
                $scope.resetLieux($scope.SelectionTypeModif);
            });
            $scope.resetLieux($scope.SelectionTypeModif);
        }
        $scope.resetLieux($scope.SelectionTypeModif);
    }


    $scope.modificationLieu=function(object)
    {
        $('#ModificationLieu').modal('show')



        $scope.LieuModif=[];

        $scope.LieuModif['Lieu']=object.Lieu;
        $scope.LieuModif['IDL']=object.IDL;
        $scope.LieuModif['Categorie']=object.Categorie;
        $scope.SelectionModifCat=$scope.LieuModif['Categorie']
        $scope.LieuModif['Type']=$scope.SelectionTypeModif;

        $scope.resetLieux($scope.SelectionTypeModif);
    }

    $scope.CorrespondanceNom=function(num_cat)
    {
        s="";
        angular.forEach($scope.Categories,function(value,key)
        {

            if(value['Categorie']==num_cat)
            {
                s=value['Nom_Cat'];
            }
        });
        return s;
    }

	
}]);