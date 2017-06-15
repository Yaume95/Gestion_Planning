app.controller('gestion_controller', ['$scope','$http',function($scope, $http)
{

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
	}

    $scope.refresh=function()
    {
       $http.get("./BDD/employes.php")
      .then(function (response) 
      {
          $scope.Employes = response.data.employes;
      }); 
   }

    $scope.AucunChoix=function(selected)
    {
        if(selected==null || selected==undefined)
        {
            return true;
        }
        return false
    }

    $scope.Liste=function(string)
    {
        var sortie = [];
        var x = $scope.Employes;
        recherche= string.toLowerCase();

        Liste = angular.forEach(x,function(object,key)
        {
            temp = object.Personne.toLowerCase();
            if(   temp.includes(recherche) )
            {
                console.log(temp,recherche,temp.includes(recherche) );
                sortie+=x[key];
            }
            console.log(sortie);
            return sortie;  
        });
    }


    $scope.includes=function(string1,string2)
    {
        if(string2==undefined || string2==null)
        {
            string2='';
        }
        return string1.toLowerCase().includes(string2.toLowerCase());
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

    $scope.modification=function(object)
    {

        $('#Modification').modal('show');
        $scope.PersonneModif= object;
/*
        str = object.Total;
        str= str.substring(str.indexOf("/") + 1); 
        $scope.PersonneModif.Total =str ;

        str = object.CA;
        str= str.substring(str.indexOf("/") + 1); 
        $scope.PersonneModif.CA =str ;

        str = object.CAav;
        str= str.substring(str.indexOf("/") + 1); 
        $scope.PersonneModif.CAav =str ;*/


    }

    $scope.cut=function(s)
    {
        var x =  s.substring(s.indexOf("/") + 1);
    }
	
}]);