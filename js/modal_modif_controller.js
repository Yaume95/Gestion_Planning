var nom, totalH, maxCA, maxCAav;

app.controller('modifCtrl', ['$scope', '$http', function($scope,$http)
{
  
    $scope.envoyer_modifs=function()
    {
      console.log($('#NomSubmit').val(),$('#HSubmit').val(),$('#CASubmit').val(),$('#CAavSubmit').val());
    }
  
}]);
