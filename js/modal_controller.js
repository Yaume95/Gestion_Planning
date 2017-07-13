app.controller('modalCtrl', ['$scope', '$http','$location','$route', function($scope,$http,$location,$route){

    $scope.affect= function($event,int)
    {

        nbheures= $('[data-idl='+idl+'][data-date='+date+']').text()
        if (nbheures=="")
        {
          nbheures=0;
        }
        else
        {
          nbheures=Number(nbheures);
        }
        console.log(nbheures);
        $scope.refresh(type);
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
                              Etat: 'Maladie',
                              NbHeures: nbheures
                          } 
            })
            .then(function successCallback(response) 
            {
                $scope.refresh(type);
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
                              Etat: 'Repos',
                              NbHeures: nbheures
                          } 
            })
            .then(function successCallback(response) 
            {
                $scope.refresh(type);
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
                              Etat: 'Demi Repos',
                              NbHeures: nbheures
                          } 
            })
            .then(function successCallback(response) 
            {
                $scope.refresh(type);
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
                              Etat: 'CA',
                              NbHeures: nbheures
                          } 
            })
            .then(function successCallback(response) 
            {
                $scope.refresh(type);
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
                              Etat: 'Demi CA',
                              NbHeures: nbheures
                          } 
            })
            .then(function successCallback(response) 
            {
                $('#AjoutEtat').modal('hide');
                $scope.refresh(type);
            });
        }
        else if (int==5)
        {
            /*if($scope.SelectionMois.num>4)
            {
              alert('Vous ne pouvez pas ajouter des CA avant Janvier APRÈS Janvier...');
            }
            else*/
            {
            $http({ 
                  method : 'POST',
                  url : './BDD/ajout_etat.php',
                  headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                  data :  {
                              IDP: idp,
                              IDL:idl,
                              Date_jour:date,
                              Etat: 'CA avant Janvier',
                              NbHeures: nbheures
                          } 
              })
              .then(function successCallback(response) 
              {
                  $scope.refresh(type);
                  $('#AjoutEtat').modal('hide');
              });
            }
        }
        else if (int==6)
        {
            /*if($scope.SelectionMois.num>4)
            {
              alert('Vous ne pouvez pas ajouter des CA avant Janvier APRÈS Janvier...');
            }
            else*/
            {
              $http({ 
                    method : 'POST',
                    url : './BDD/ajout_etat.php',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    data :  {
                                IDP: idp,
                                IDL:idl,
                                Date_jour:date,
                                Etat: 'Demi CA avant Janvier',
                                NbHeures: nbheures
                            } 
              })
              .then(function successCallback(response) 
              {
                  $scope.refresh(type);
                  $('#AjoutEtat').modal('hide');
              });
            }
        }
        else if (int==7)
        {
            {
              $http({ 
                    method : 'POST',
                    url : './BDD/ajout_jour_ferie.php',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    data :  {
                                Date_jour:date
                            } 
              })
              .then(function successCallback(response) 
              {
                  $scope.refreshCal();
                  $('#AjoutEtat').modal('hide');
              });
            }
        }
        else if (int==8)
        {
            {
              $http({ 
                    method : 'POST',
                    url : './BDD/suppression_jour_ferie.php',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    data :  {
                                Date_jour:date
                            } 
              })
              .then(function successCallback(response) 
              {
                  $scope.refreshCal();

                  $('#SuppressionFerie').modal('hide');
              });
            }
        }

        $scope.refresh(type);
        $scope.refresh(type);
        
    }
  
}]);
