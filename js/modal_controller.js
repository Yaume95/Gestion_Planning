app.controller('modalCtrl', ['$scope', '$http','$location','$route', function($scope,$http,$location,$route){

    $scope.affect= function($event,int)
    {
        $('[data-idl='+idl+'][data-date='+date+'][data-idp='+idp+']').removeClass().addClass('heure ng-binding ng-scope');
        $scope.refresh();
        if(int==0)
        {
            $http({ 
                  method : 'POST',
                  url : './BDD/ajout_etat.php',
                  headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                  data :  {
                              IDP: idp,
                              IDL:idl,
                              Date_jour:date,
                              Etat: 'Maladie'
                          } 
            })
            .then(function successCallback(response) 
            {
                $scope.refresh();
            });
        }
        else if (int==1)
        {
            $http({ 
                  method : 'POST',
                  url : './BDD/ajout_etat.php',
                  headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                  data :  {
                              IDP: idp,
                              IDL:idl,
                              Date_jour:date,
                              Etat: 'Repos'
                          } 
            })
            .then(function successCallback(response) 
            {
                $scope.refresh();
            });
        }
        else if (int==2)
        {
            $http({ 
                  method : 'POST',
                  url : './BDD/ajout_etat.php',
                  headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                  data :  {
                              IDP: idp,
                              IDL:idl,
                              Date_jour:date,
                              Etat: 'Demi Repos'
                          } 
            })
            .then(function successCallback(response) 
            {
                $scope.refresh();
            });
        }
        else if (int==3)
        {
            $http({ 
                  method : 'POST',
                  url : './BDD/ajout_etat.php',
                  headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                  data :  {
                              IDP: idp,
                              IDL:idl,
                              Date_jour:date,
                              Etat: 'CA'
                          } 
            })
            .then(function successCallback(response) 
            {
                $scope.refresh();
            });
        }
        else if (int==4)
        {
            $http({ 
                  method : 'POST',
                  url : './BDD/ajout_etat.php',
                  headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                  data :  {
                              IDP: idp,
                              IDL:idl,
                              Date_jour:date,
                              Etat: 'Demi CA'
                          } 
            })
            .then(function successCallback(response) 
            {
                $scope.refresh();
            });
        }
        else if (int==5)
        {
            $http({ 
                  method : 'POST',
                  url : './BDD/ajout_etat.php',
                  headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                  data :  {
                              IDP: idp,
                              IDL:idl,
                              Date_jour:date,
                              Etat: 'CA avant Avril'
                          } 
            })
            .then(function successCallback(response) 
            {
                $scope.refresh();
            });
        }
        else if (int==6)
        {
            $http({ 
                  method : 'POST',
                  url : './BDD/ajout_etat.php',
                  headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                  data :  {
                              IDP: idp,
                              IDL:idl,
                              Date_jour:date,
                              Etat: 'Demi CA avant Avril'
                          } 
            })
            .then(function successCallback(response) 
            {
                $scope.refresh();
            });
        }

        $scope.refresh();
        $('#AjoutEtat').modal('hide');
        $scope.refresh();
        
    }
  
}]);
