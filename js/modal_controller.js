app.controller('modalCtrl', ['$scope', '$http','$location','$route', function($scope,$http,$location,$route){

    $scope.affect= function($event,int)
    {
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
                $('#AjoutEtat').modal('hide');
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
                $('#AjoutEtat').modal('hide');
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
                $('#AjoutEtat').modal('hide');
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
                $('#AjoutEtat').modal('hide');
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
                $('#AjoutEtat').modal('hide');
                $scope.refresh();
            });
        }
        else if (int==5)
        {
            if($scope.SelectionMois.num>4)
            {
              alert('Vous ne pouvez pas ajouter des CA avant Avril APRÈS Avril...');
            }
            else
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
                  $('#AjoutEtat').modal('hide');
              });
            }
        }
        else if (int==6)
        {
            if($scope.SelectionMois.num>4)
            {
              alert('Vous ne pouvez pas ajouter des CA avant Avril APRÈS Avril...');
            }
            else
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
                  $('#AjoutEtat').modal('hide');
              });
            }
        }

        $scope.refresh();
        $scope.refresh();
        
    }
  
}]);
