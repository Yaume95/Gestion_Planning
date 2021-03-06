app.controller('planning1_controller', ['$scope','$http', '$route','$window','$location','$rootScope' ,function($scope, $http,$route,$window,$location,$rootScope) {

    heure_checked=false;
    compteur=0;
    pattern = /^((SAM)*(DIM)*(Férié)*)*$/;

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

    $scope.SelectionMois = $scope.Mois[new Date().getMonth()];
    $scope.initFirst=function(type)
    {
      $scope.Ferie=false;
      $http({ 
              method : 'POST',
              url : './BDD/employes.php',
              headers: {'Content-Type': 'application/x-www-form-urlencoded'},
              data :  {
                          Type: type
                          
                      } 
      })
      .then(function (response) 
      {
          $scope.Employes = response.data.employes;
          if($rootScope.redirect==true)
          {
            $rootScope.redirect=false;
            $scope.SelectionPersonne = $rootScope.planningRedirect;
            console.log($rootScope.place);

          }
          else
          {
            $rootScope.place=0;
            $scope.SelectionPersonne = $scope.Employes[0].IDP;
          }

      });

      $http({ 
              method : 'POST',
              url : './BDD/horaires.php',
              headers: {'Content-Type': 'application/x-www-form-urlencoded'},
              data :  {
                          Type: type
                          
                      } 
      })
      .then(function (response) 
      {
          $scope.Horaires = response.data['horaires'];
      });

      
        
      $http({ 
              method : 'POST',
              url : './BDD/calendrier.php',
              headers: {'Content-Type': 'application/x-www-form-urlencoded'},
              data :  {
                          Mois:  $scope.SelectionMois.num,
                          Annee: new Date().getYear()+1900
                      } 
      })
      .then(function (response) 
      {
          $scope.Calendrier = response.data['calendrier'];
      });


      $http({ 
              method : 'POST',
              url : './BDD/lieux.php',
              headers: {'Content-Type': 'application/x-www-form-urlencoded'},
              data :  {
                          Type: type
                          
                      } 
      })
      .then(function (response)
      {
        $scope.Lieux =  response.data.lieux
      });

      $http.get("./BDD/annees.php")
      .then(function (response)
      {
          $scope.Annees = response.data.annees;
          angular.forEach($scope.Annees, function(value,key)
          {

              if(value.Annee==(new Date().getYear()+1900))
              {
                $scope.SelectionAnnee=value;
                console.log(value.Annee)
              } 

          });
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

    $scope.refresh=function(type)
    {
       $http({ 
              method : 'POST',
              url : './BDD/employes.php',
              headers: {'Content-Type': 'application/x-www-form-urlencoded'},
              data :  {
                          Type: type
                          
                      } 
      })
      .then(function (response) 
      {
          $scope.Employes = response.data.employes;
      });
      $http({ 
              method : 'POST',
              url : './BDD/horaires.php',
              headers: {'Content-Type': 'application/x-www-form-urlencoded'},
              data :  {
                          Type: type
                          
                      } 
      })
      .then(function (response) 
      {
          $scope.Horaires = response.data['horaires'];
      });
    }

    $scope.refreshCalendrier=function()
    {
        $http({ 
                method : 'POST',
                url : './BDD/calendrier.php',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                data :  {
                            Mois: $scope.SelectionMois.num,
                            Annee: $scope.SelectionAnnee.Annee
                        } 
        })
        .then(function (response)
        {
          $scope.Calendrier = response.data.calendrier;
        });
    }

    $scope.refreshAnnees=function()
    {
        $http.get("./BDD/annees.php")
        .then(function (response)
        {
            $scope.Annees = response.data.annees;
        });
    }

    $scope.moisact=function()
    {
       d= new Date();
       return $scope.Mois[d.getMonth()];
    }


    $scope.reset=function()
    {
      $('.heure').removeClass().addClass(' heure ');
      $rootScope.place= $('[value='+$scope.SelectionPersonne+']').attr('id');
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
        if($event.which==1 && compteur==0 && !($event.target.innerText=="SAM" || $event.target.innerText=="DIM" || $event.target.innerText=="Férié"))
        {
            enter_pressed=false;  
            $event.preventDefault();
            contentCell=$event.target.innerText;
            compteur+=1;
            
        }

    }


    $scope.focusout=function($event)
    {   
        initialCellContent = contentCell;

        if(contentCell!=$event.target.innerText && !enter_pressed && compteur)
        {
           event.target.innerText=initialCellContent;
        }
        compteur=0;
        
    }

    $scope.valide_entrer = function($event)
    {
        var content = $event.target.innerText;       
        idp = $event.target.attributes['data-idp'].value;
        idl = $event.target.attributes['data-idl'].value;
        date= $event.target.attributes['data-date'].value;
        type= $event.target.attributes['data-type'].value;

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
                      $scope.refresh(type);
                      $event.target.blur();
                  });
                  $scope.refresh(type);
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
                      $scope.refresh(type)
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
                      $scope.refresh(type)
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
                      $scope.refresh(type)
                  });
              }
              else
              {
                  $scope.refresh();
                  console.log('autres');
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
        else if ($event.which==32)
        {
            $event.preventDefault();
        }

        
    }
    
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

    $scope.total_mensuel = function(idp)
    {
        
        var z =0.0;
        valeurs=document.querySelectorAll('[data-idp="'+idp+'"]');



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


    $scope.cellule  = function(Date,Lieu,Nom,Ferie)
    {
        x = 0.0;
       
        if($('.'+Date).is('.Sam, .Dim'))
        {
           if($('.'+Date).is('.Sam'))
           {
              $('[data-idl='+Lieu+'][data-date='+Date+']').css('border-left','2px solid darkgrey');
              return 'SAM';
           } 
           else if($('.'+Date).is('.Dim'))
           {
              $('[data-idl='+Lieu+'][data-date='+Date+']').css('border-right','2px solid darkgrey');
              return 'DIM';
           } 
        }
        else if(Ferie==1)
        {
          return 'Férié';
        }
        else 
        {
            angular.forEach($scope.Horaires, function(value,key)
            {
                if(value.Date_jour==Date && value.IDL==Lieu && value.IDP==Nom)
                {
                  x = value.NbHeures;
                }
            
            });
            if(x>0) return x;
        }

        
    };


    $scope.InOrOut=function(idl,idp)
    {
        valeurs=$('[data-idl='+idl+'][data-idl='+idl+']').text();
        if(pattern.test(valeurs)) return 'Exclus';

    };

    $scope.testclasses  = function(Date,Lieu,Nom)
    {

        x='';

        angular.forEach($scope.Horaires,function(value,key)
        {
            if(value.Date_jour==Date && value.IDL==Lieu && value.IDP==Nom)
            {
              x=$scope.compress(value.Etat);
              y=value.Checked;
            }
        });

        if(x!='')
        {
          if(y==1)  return x+' checked'; 
          else return x+' unchecked';
        }
        
    };

    $scope.compress = function(string)
    {
      return string.replace(/\s+/g, '');
    };

}]);

app.directive('noRightClick', function() {
    return {
        link: function($scope, $element) 
        {
          $element.bind("contextmenu",function(e)
          {
              contentCell=e.target.innerHTML;
              e.preventDefault();
              e.target.blur();
              idp = e.target.attributes['data-idp'].value;
              idl = e.target.attributes['data-idl'].value;
              date= e.target.attributes['data-date'].value;
              type= e.target.attributes['data-type'].value;
              if(e.target.innerText!="SAM" && e.target.innerText!="DIM" && e.target.innerText!="Férié") $('#AjoutEtat').modal();
              else if(e.target.innerText=="Férié") $('#SuppressionFerie').modal();
          });

        }
            
    };
});
