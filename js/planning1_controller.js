app.controller('planning1_controller', ['$scope','$http', '$route','$window','$location' ,function($scope, $http,$route,$window,$location) {

    $scope.initFirst=function()
    {
       $http.get("./BDD/employes.php")
      .then(function (response) 
      {
          $scope.Employes = response.data.employes;
          $scope.SelectionPersonne = $scope.Employes[0].IDP;
          $scope.place=0;

      });

      $http.get("./BDD/horaires.php")
      .then(function (response) 
      {
          $scope.Horaires = response.data.horaires
      });
      
        
      $http.get("./BDD/calendrier.php")
      .then(function (response) 
      {
          $scope.Calendrier = response.data['calendrier'];
      });

        $http.get("./BDD/lieux.php")
      .then(function (response)
      {
        $scope.Lieux =response.data.lieux
      });
    }

    $scope.refresh=function()
    {
       $http.get("./BDD/employes.php")
      .then(function (response) 
      {
          $scope.Employes = response.data.employes;
      });

      $http.get("./BDD/horaires.php")
      .then(function (response) 
      {
          $scope.Horaires = response.data.horaires
      }); 
   }

   $scope.reset=function()
   {
      $('.heure').removeClass().addClass(' heure ');
      $scope.place= $('[value='+$scope.SelectionPersonne+']').attr('id');
   }
 
 

    $scope.clickdroit=function($event)
    {
        if($event.which==3)
        {
            $event.preventDefault();
            idp = $event.target.attributes['data-idp'].value;
            idl = $event.target.attributes['data-idl'].value;
            date= $event.target.attributes['data-date'].value;
            $('#AjoutEtat').modal();
        } 
    }

    $scope.focusin=function($event)
    {

        if($event.which==1)
        {
            
            $event.preventDefault();
            contentCell=$event.target.innerText;
            $event.target.innerText="";
        }
    }

    $scope.unableTab=function($event)
    {
      if($event.which==9)
      {
        $event.preventDefault();
      }
    }

    $scope.focusout=function($event)
    {
        
        if(contentCell!="" && event.target.innerText=="")
        {
          $event.target.innerText=contentCell  ;
        }
    }

    $scope.valide_entrer = function($event)
    {
        var content = $event.target.innerText;
        
        idp = $event.target.attributes['data-idp'].value;
        idl = $event.target.attributes['data-idl'].value;
        date= $event.target.attributes['data-date'].value;
        nbheures= Number(content);


        if ($event.keyCode == 13)
        {
            if(!isNaN(content) )
            {
              
              if(contentCell!="" && content=="" )
              {
                  contentCell="";
                  $event.target.blur();

                  $http({ 
                        method : 'POST',
                        url : './BDD/suppression_horaires.php',
                        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                        data :  {
                                    IDP: idp,
                                    IDL:idl,
                                    Date_jour:date
                                    
                                } 
                  }).then(function successCallback(response) {
                      $event.target.blur();
                      x= $('[data-idp='+idp+'] + [data-idl='+idl+'] + [data-date='+date+']');
                      console.log(x);
                      x.removeClass().addClass('heure');
                  }, function errorCallback(response)
                  {
                      
                  });
                  $scope.refresh();
                  $("[data-idl="+idl+"] + [data-idp="+idp+"] + [data-date='"+date+"']").css({"backgroundColor":"white"});
                  //alert('suppression heures');
              }
              else if (contentCell=="" && content!="" && Number(content)>0)
              {

                 
                  $event.target.blur();
                  

                  $http({ 
                        method : 'POST',
                        url : './BDD/ajout_horaires.php',
                        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                        data :  {
                                    IDP: idp,
                                    IDL:idl,
                                    Date_jour:date,
                                    NbHeures:nbheures
                                } 
                  });
                  $scope.refresh();
                  

              }
              else if (contentCell!="" && content!="" && !isNaN(content))
              {

                  $event.target.blur();
                  $http({ 
                        method : 'POST',
                        url : './BDD/modif_horaires.php',
                        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                        data :  {
                                    IDP: idp,
                                    IDL: idl,
                                    Date_jour:date,
                                    NbHeures:nbheures
                                } 
                  });
                  $scope.refresh();
              }
              else if( content!="" && Number(content)<=0)
              {
                  alert("Veuillez entrer un nombre d'heures correct");
              }
              else
              {
                $event.target.blur();
              }
            }
            else if(content!="")
            {
              $event.target.blur();
              $event.target.innerText=contentCell;
              alert("Veuillez entrer un nombre d'heures valides");

            }
            else
            {
              $event.target.blur();
            }
        }

        
    }


    $scope.Mois = [
        {mois : "Janvier", num : 1},
        {mois : "Février", num : 2},
        {mois : "Mars", num : 3},
        {mois : "Avril", num : 4},
        {mois : "Mai", num : 5},
        {mois : "Juin", num : 6},
        {mois : "Juillet", num : 7},
        {mois : "Aout", num : 8},
        {mois : "Septembre", num : 9},
        {mois : "Octobre", num :10},
        {mois : "Novembre", num : 11},
        {mois : "Décembre", num : 12}
      ];


    $scope.Place = function(int)
    {

          $http.get("./BDD/employes.php")
          .then(function (response) 
          {
            
            angular.forEach(response.data.employes, function(object, key)
            {

                if(int==Number(object.IDP) )
                {
                    $scope.place=key;
                }
            });


          });

          return $scope.place


    }


    $scope.total_mensuel = function()
    {
        
        var z =0.0;
        var valeurs = document.querySelectorAll('.heure');



        angular.forEach(valeurs,function(value,key)
        {
          if(value.innerText!="" && !isNaN(value.innerText))
            { 
                z+=Number(value.innerText);
            }
        });

        return z;
    };

    
    $scope.total = function(Lieu)
    {
        
        var z =0.0;
        var valeurs = document.querySelectorAll('[data-idl="'+Lieu+'"');



        angular.forEach(valeurs,function(value,key)
        {
          if(value.innerText!="" && !isNaN(value.innerText))
            { 
                z+=Number(value.innerText);
            }
        });

        return z;
    };

    $scope.rtt_mensuel= function()
    { 
        var z =0.0;
        var valeurs = document.querySelectorAll('.heure');

        angular.forEach(valeurs,function(value,key)
        {
            if(value.innerText=="Repos")
            { 
              z+=1;
            }
            else if(value.innerText=="Demi Repos")
            {
              z+=0.5
            }
        });

        return z;
    }
    
    $scope.maladie_mensuel= function(Nom)
    {
        var z =0.0;
        var valeurs = document.querySelectorAll('.heure');

        angular.forEach(valeurs,function(value,key)
        {
            if(value.innerText=="Maladie")
            { 
              z+=1;
            }
        });

        return z;
    }

    $scope.caav_mensuel= function(Nom)
    {
        var z =0.0;
        var valeurs = document.querySelectorAll('.heure');

        angular.forEach(valeurs,function(value,key)
        {
            if(value.innerText=="CAavantAvril")
            { 
              z+=1;
            }
            else if(value.innerText=="DemiCAavantAvril")
            {
              z+=0.5
            }
        });

        return z;
    }
    $scope.ca_mensuel= function(Nom)
    {
        var z =0.0;
        var valeurs = document.querySelectorAll('.heure');

        angular.forEach(valeurs,function(value,key)
        {
            if(value.innerText=="CA")
            { 
              z+=1;
            }
            else if(value.innerText=="DemiCA")
            {
              z+=0.5
            }
        });

        return z;
    }


    $scope.cellule  = function(Date,Lieu,Nom)
    {

        var x=$scope.compress($('#'+Date+Lieu+Nom).text().valueOf())  ;
        if(isNaN(x))
        {
            $("[data-idl="+Lieu+"] + [data-date='"+Date+"']").addClass(x);
            return x;
        }
        else
        {
          x= $scope.compress(x);
          return x;
        }
        
    };


    $scope.compress = function(string)
    {
      return string.replace(/\s+/g, '');
    }

}]);