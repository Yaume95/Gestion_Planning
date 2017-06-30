app.controller('gestion_controller2', ['$scope','$http','$window','$location','$rootScope', function($scope, $http,$location,$window,$rootScope)
{

    

	$scope.initGestion2=function()
	{

        $http.get("./BDD/lieux.php")
        .then(function (response)
        {
            $scope.Lieux =response.data.lieux
        });

        $http.get("./BDD/categories.php")
        .then(function (response)
        {
            $scope.Categories =response.data.categories;
        });

        $scope.AjoutDemande=false;
        $scope.AjoutDemandeCat=false;
	}

    $scope.demandeAjout= function()
    {
        $scope.AjoutDemande=true;
    }

    $scope.demandeAjoutCat= function()
    {
        $scope.AjoutDemandeCat=true;
    }

    $scope.annulerDemande= function()
    {
        $scope.AjoutDemande=false;
    }

    $scope.annulerDemandeCat= function()
    {
        $scope.AjoutDemandeCat=false;
    }

    $scope.confirmerDemande= function(nom,cat)
    {
        nom= nom.charAt(0).toUpperCase() +nom.substring(1);
        console.log(nom,cat);
        $http({ 
            method : 'POST',
            url : './BDD/ajout_lieu.php',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            data :  {
                        Nom: nom,
                        Categorie: cat                           
                    } 
        })
        .then(function successCallback(response) {

            $scope.refresh();
        });
        $scope.AjoutDemande=false;
    
        $scope.refresh();
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

    $scope.refresh=function()
    {
        $http.get("./BDD/lieux.php")
        .then(function (response) 
        {
            $scope.Lieux= response.data.lieux;
        });

        $http.get("./BDD/categories.php")
        .then(function (response)
        {
            $scope.Categories =response.data.categories;
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



        $scope.LieuModif=[];

        $scope.LieuModif['Lieu']=object.Lieu;
        $scope.LieuModif['IDL']=object.IDL;
        $scope.LieuModif['Categorie']=object.Categorie;

        $scope.SelectionModifCat=$scope.LieuModif['Categorie'];


        $scope.refresh()
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