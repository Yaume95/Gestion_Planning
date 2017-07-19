app.controller('gestion_controller5', ['$scope' ,'$http','$window','$location', function($scope, $http,$location,$window)
{
    $http.get("./BDD/annees.php")
    .then(function (response)
    {
        $scope.Annees = response.data.annees;
    });
    

    $scope.confirmer = function()
    {
      max=0;
      angular.forEach($scope.Annees, function(value,key)
      {
        if(value.Annee>max) max = value.Annee;
      });

      console.log(Number(max)+1)

      $http({ 
              method : 'POST',
              url : './BDD/newcalendar.php',
              headers: {'Content-Type': 'application/x-www-form-urlencoded'},
              data :  {
                          Annee : Number(max)+1         
                      } 
      })
      .then(function (response) 
      {
            location.hash="#!/Gestion_Personnel";
      });
    }


    $scope.annuler = function()
    {
        location.hash="#!/Gestion_Personnel";
    }



}])