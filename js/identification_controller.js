app.controller('identification_controller', ['$scope','$http','$window','$location','$rootScope','$cookies' ,function($scope, $http,$window,$location,$rootScope,$cookies)
{

	$scope.sendPsswd= function(pwd)
    {
        pwd=hex_sha1(pwd);

        $http({ 
              method : 'GET',
              url : './BDD/verif_pwd.php',
              headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        })
        .then(function successCallback(response) 
        {
            $scope.reponse=response.data;
            if(pwd==$scope.reponse)
            {
                d= new Date();
                d.setTime(d.getTime+ 8*60*60*1000);
                $cookies.put('AdminLogged',true,{expires:d});
                $rootScope.AdminLogged=true;
                $location.path('/Planning_Personnel');
            }
        });


        
    }

}]);

