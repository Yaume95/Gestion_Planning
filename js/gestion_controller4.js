app.controller('gestion_controller4', ['$scope','$http','$window','$location','$rootScope', function($scope, $http,$location,$window,$rootScope)
{

    $scope.Next=false;
    $scope.Sent=true;

	$http({ 
          method : 'GET',
          url : './BDD/verif_pwd.php',
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    })
    .then(function successCallback(response) 
    {
        $scope.reponse=response.data;
    });


    $scope.testPsswd=function(pwd)
    {
        console.log('a');
        if(hex_sha1(pwd)==$scope.reponse)
        {
            $scope.Next=true;
        }
        else
        {
            $scope.Sent=false;
        }
    }

    $scope.sendPsswd=function(pwd)
    {
        $http(
        { 
            method : 'POS',
            url : './BDD/modif_pwd.php',
            data :  {
                        Mdp: hex_sha1(pwd)                            
                    } 
        })
        .then(function successCallback(response) 
        {
            $location.path("/Planning_Personnel");
        });
    }


}])