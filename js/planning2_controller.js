app.controller('planning2_controller', ['$scope','$http','$window','$location' ,function($scope, $http,$window,$location)
{
	$scope.Mois = [
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


	$scope.initLieux=function()
	{
		$http.get("./BDD/presence_lieux.php")
       	.then(function (response) 
        {
        	$scope.Presences = response.data.presences;

        });

        $http.get("./BDD/calendrier.php")
        .then(function (response) 
        {
        	$scope.Calendrier = response.data['calendrier'];
        });

        $http.get("./BDD/lieux.php")
        .then(function (response)
        {
        	$scope.Lieux =response.data.lieux
        });
	}

	$scope.celluleLieu=function(date,idl)
	{
		var x= $('#'+date+idl).children('.nombre').text();
		return x;
	}

	$scope.clickdroit=function($event,date,idl)
	{

		if($event.which==3)
		{
			var x =$('#'+date+idl).children('.personnes').text();
            if (x!="") alert(x);
            $event.preventDefault();
		}
	}

}]);