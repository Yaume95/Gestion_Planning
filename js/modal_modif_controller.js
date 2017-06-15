var nom, totalH, maxCA, maxCAav;

app.controller('modifCtrl', ['$scope', '$http', function($scope,$http)
{
  
    $scope.envoyer_modifs=function()
    {
      console.log($('#NomSubmit').text());
    }
    $scope.modif_total=function (string)
    {
    	x =  string.substring(string.indexOf("/") + 1); 
    }
  
}]);
