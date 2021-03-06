var app = angular.module('Planning', ['ngRoute', 'ngCookies']);



app.config(function($routeProvider) {
    $routeProvider
    .when("/", {
        templateUrl : "Templates/Identification.html",
        controller : "identification_controller"
    })
    .when("/Planning_ASEM", {
        templateUrl : "Templates/Planning1.1.html",
        controller : "planning1_controller"
    })
    .when("/Planning_Agents", {
        templateUrl : "Templates/Planning1.2.html",
        controller : "planning1_controller"
    })
    .when("/Planning_Animation", {
        templateUrl : "Templates/Planning1.3.html",
        controller : "planning1_controller"
    })
    .when("/Planning_Lieux_ASEM", {
        templateUrl : "Templates/Planning2.1.html",
        controller : "planning2_controller"
    })
    .when("/Planning_Lieux_Agents", {
        templateUrl : "Templates/Planning2.2.html",
        controller : "planning2_controller"
    })
    .when("/Planning_Lieux_Animation", {
        templateUrl : "Templates/Planning2.3.html",
        controller : "planning2_controller"
    })
    .when("/Gestion_Personnel", {
        templateUrl : "Templates/Gestion1.html",
        controller : "gestion_controller"
    })
    .when("/Gestion_Lieux", {
        templateUrl : "Templates/Gestion2.html",
        controller : "gestion_controller2"
    })
    .when("/Gestion_Calendrier", {
        templateUrl : "Templates/Gestion5.html",
        controller : "gestion_controller5"
    })
    .when("/Recap_mois", {
        templateUrl : "Templates/Gestion3.html",
        controller : "gestion_controller3"
    })
    .when("/Admin_password", {
        templateUrl : "Templates/Gestion4.html",
        controller : "gestion_controller4"
    });
});


app.run(function($rootScope,$location,$cookies)
{
    $rootScope.$on( "$routeChangeStart", function(event, next, current) 
    {
        if ( $cookies.get('AdminLogged') == null ||  $cookies.get('AdminLogged') == undefined) 
        {
        // no logged user, we should be going to #login
            if ( next.templateUrl != "/" ) 
            {
                // not going to #login, we should redirect now
                $location.path( "/" );
            }
        }
        else if(next.originalPath=="/")
        {
            $location.path( "/Gestion_Personnel" );
        }

                
    });
});4

