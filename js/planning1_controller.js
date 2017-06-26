app.controller('planning1_controller', ['$scope','$http', '$route','$window','$location','$rootScope' ,function($scope, $http,$route,$window,$location,$rootScope) {

    $scope.place=0;
    heure_checked=false;
    compteur=0;

    $scope.initFirst=function()
    {
       $http.get("./BDD/employes.php")
      .then(function (response) 
      {
          $scope.Employes = response.data.employes;
          if($rootScope.redirect==true)
          {
            $rootScope.redirect==false;
            $scope.SelectionPersonne = $rootScope.planningRedirect;
            
          }
          else
          {
            $scope.SelectionPersonne = $scope.Employes[0].IDP;
          }
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

    $scope.Quelleplace = function(idp)
    {
        angular.forEach($scope.Employes, function(value,key)
        {
            if(value.IDP==idp)
            {
              return key;
            }
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
        } 
    }

    $scope.unableTab=function($event)
    {
      if($event.which==9)
      {
        $event.preventDefault();
      }
    }


    $scope.focusin=function($event)
    {
        if($event.which==1)
        {
            enter_pressed=false;  
            $event.preventDefault();
            contentCell=$event.target.innerText;
        }

    }


    $scope.focusout=function($event)
    {   
        initialCellContent = contentCell;
        if(contentCell!=$event.target.innerText && !enter_pressed)
        {
          event.target.innerText=initialCellContent;
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
            $event.preventDefault();
            enter_pressed=true;
            if(!isNaN(content) )
            {
              
              if(contentCell!="" && content==""  || (contentCell=="" && content=="" && $('[data-idl='+idl+'][data-date='+date+']').is('.Repos,.Maladie,.CA,.CAavantJanvier,.DemiCAavantJanvier,.DemiRepos,.DemiCA')))
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
                      console.log("supression");
                      $scope.refresh();
                      $event.target.blur();
                  });
                  $scope.refresh();
              }
              else if (contentCell=="" && content!="" && Number(content)>0 && !$('[data-idl='+idl+'][data-date='+date+']').is('.CA,.CAavantJanvier,.DemiCAavantJanvier,.DemiCA'))
              {

                 
                  $event.target.blur();
                  
                  console.log("ajout");
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
                  }).then(function successCallback(response) {
                      $event.target.blur();
                      $scope.refresh()
                    });
                  

              }
              else if (contentCell!="" && content!=""  && content!=contentCell && !isNaN(content) && Number(content)>0 || contentCell!="" && content!="" && (contentCell=="" && content!="" && $('[data-idl='+idl+'][data-date='+date+']').is('.Repos,.Maladie,.CA,.CAavantJanvier,.DemiCAavantJanvier,.DemiRepos,.DemiCA')))
              {
                  console.log("modif");              


                  if(content!="" && $('[data-idl='+idl+'][data-date='+date+']').is('.Repos'))
                  {
                      etat='Repos';
                  }
                  else if(content!="" && $('[data-idl='+idl+'][data-date='+date+']').is('.DemiRepos'))
                  {
                      etat= 'Demi Repos';
                  }
                  else if(content!="" && $('[data-idl='+idl+'][data-date='+date+']').is('.Maladie'))
                  {
                      etat='Maladie';
                  }
                  else etat='Travail';
  

          
                  $event.target.blur();
                  $http({ 
                        method : 'POST',
                        url : './BDD/modif_horaires.php',
                        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                        data :  {
                                    IDP: idp,
                                    IDL: idl,
                                    Date_jour:date,
                                    NbHeures:nbheures,
                                    Etat:etat
                                } 
                  })
                  .then(function successCallback(response) {
                      $event.target.blur();
                      $scope.refresh()
                  });
              }
              else if( content!="" && Number(content)<=0)
              {
                  alert("Veuillez entrer un nombre d'heures correct");
              }
              else if (content==contentCell && $scope.compress($('#'+date+idl+idp+3).text())!=1) 
              {
                $http({ 
                        method : 'POST',
                        url : './BDD/validation.php',
                        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                        data :  {
                                    IDP: idp,
                                    IDL: idl,
                                    Date_jour:date,
                                } 
                  })
                .then(function successCallback(response) {
                      $event.target.blur();
                      $scope.refresh()
                  });
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
        var valeurs = document.querySelectorAll('.Repos');
        var valeurs2 = document.querySelectorAll('.DemiRepos');
        z=0.0;

        angular.forEach(valeurs,function(value,key)
        {
            z+=1
        });


        angular.forEach(valeurs2,function(value,key)
        {
            z+=0.5
        });

        return z;
    }
    
    $scope.maladie_mensuel= function(Nom)
    {
        var z =0.0;
        var valeurs = $('.Maladie');

        z+=valeurs.length;

        return z;
    }

    $scope.caav_mensuel= function(Nom)
    {
        var z =0.0;
        var valeurs = $('.CAavantJanvier');

        z+=valeurs.length;

        valeurs=$('.DemiCAavantJanvier');
        z+=0.5*valeurs.length;

        return z;
    }
    $scope.ca_mensuel= function(Nom)
    {
        var z =0.0;
        var valeurs = $('.CA');

        z+=valeurs.length;

        valeurs=$('.DemiCA');
        z+=0.5*valeurs.length;

        return z;
    }


    $scope.cellule  = function(Date,Lieu,Nom)
    {

        var x=$scope.compress($('#'+Date+Lieu+Nom+'1').text().valueOf())  ;
        var y=$('#'+Date+Lieu+Nom+'2').text().valueOf() ;
       
        if($('.'+Date).is('.Sam, .Dim'))
        {
           if($('.'+Date).is('.Sam')) return 'SAM';
           else return 'DIM';
        }
        else if ( x=='Travail' || x =='Maladie' || x=='Repos' ||x=='DemiRepos')
        {
            return y;
        }

        
    };


    $scope.testclasses  = function(Date,Lieu,Nom)
    {

        var x=$scope.compress($('#'+Date+Lieu+Nom+'1').text().valueOf());
        var y=$scope.compress($('#'+Date+Lieu+Nom+'3').text().valueOf());

        if(x!='')
        {
          if(y==1)  return x; 
          else return x+' unchecked';
        }
        
    };

    $scope.compress = function(string)
    {
      return string.replace(/\s+/g, '');
    }

}]);

app.directive('noRightClick', function() {
    return {
        link: function($scope, $element) 
        {
          $element.bind("contextmenu",function(e)
          {
              e.preventDefault();
              e.target.blur();
              idp = e.target.attributes['data-idp'].value;
              idl = e.target.attributes['data-idl'].value;
              date= e.target.attributes['data-date'].value;
              if(e.target.innerText!="SAM" && e.target.innerText!="DIM") $('#AjoutEtat').modal();
          });

        }
            
    };
});
