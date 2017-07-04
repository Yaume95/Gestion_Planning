app.controller('enteteController', ['$scope', '$cookies', function($scope,$cookies)
{

    $scope.logged = function()
    {
        return $cookies.get('AdminLogged');
    }
  
}]);
