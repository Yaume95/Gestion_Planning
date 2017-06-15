app.controller('modalCtrl', ['$scope', '$http','$location','$route', function($scope,$http,$location,$route){

    $scope.affect= function($event,int)
    {
        

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
            });
        }

        $('#AjoutEtat').modal('hide');
        $scope.refresh();
        
    }
  
}]);
