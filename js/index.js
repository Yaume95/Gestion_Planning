var app = angular.module('Planning', ['ngRoute', 'ngCookies']);



app.config(function($routeProvider) {
    $routeProvider
    .when("/", {
        templateUrl : "Templates/identification.html",
        controller : "identification_controller"
    })
    .when("/Planning_Personnel", {
        templateUrl : "Templates/Planning1.html",
        controller : "planning1_controller"
    })
    .when("/Planning_Lieux", {
        templateUrl : "Templates/Planning2.html",
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
    .when("/Recap_mois", {
        templateUrl : "Templates/Gestion3.html",
        controller : "gestion_controller3"
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
    });
});