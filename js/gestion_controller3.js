app.controller('gestion_controller3', ['$scope','$http','$window','$location','$rootScope', function($scope, $http,$location,$window,$rootScope)
{

    

	$scope.initGestion3=function()
	{

        $http.get("./BDD/lieux.php")
        .then(function (response)
        {
            $scope.Lieux =response.data.lieux
        });

        $http.get("./BDD/horaires.php")
        .then(function (response)
        {
            $scope.Horaires =response.data.horaires
        });

        $http.get("./BDD/employes.php")
        .then(function (response)
        {
            $scope.Employes =response.data.employes
        });

    };


    $scope.Mois = 
    [
        {mois : "Janvier", num : 1},
        {mois : "Février", num : 2},
        {mois : "Mars", num : 3},
        {mois : "Avril", num : 4},
        {mois : "Mai", num : 5},
        {mois : "Juin", num : 6},
        {mois : "Juillet", num : 7},
        {mois : "Aout", num : 8},
        {mois : "Septembre", num : 9},
        {mois : "Octobre", num :10},
        {mois : "Novembre", num : 11},
        {mois : "Décembre", num : 12}
    ];

    $scope.total_mensuel= function(idp,mois)
    {
        z=0.0;

        angular.forEach($scope.Horaires, function(horaire,key)
        {
            console.log(horaire.IDP,horaire.Mois)
            if(horaire.IDP==idp && horaire.Mois==mois)
            {
                z+=Number(horaire.NbHeures);
            }
        });

        return z;
    }


}])