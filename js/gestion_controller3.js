app.controller('gestion_controller3', ['$scope','$http','$window','$location','$rootScope', function($scope, $http,$location,$window,$rootScope)
{

    

	$scope.initGestion3=function()
	{

        $http.get("./BDD/totaux.php")
        .then(function (response)
        {
            $scope.Totaux =response.data.totaux
        });

        $http.get("./BDD/categories.php")
        .then(function (response)
        {
            $scope.Categories =response.data.categories;
            $scope.SelectedCat=$scope.Categories[0];

        });

        $http.get("./BDD/horaires.php")
        .then(function (response)
        {
            $scope.Horaires =response.data.horaires
        });

    };

    $scope.moisact=function()
    {
       d= new Date();
       return $scope.Mois[d.getMonth()];
    }


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