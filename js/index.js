var app = angular.module('Planning', ['ngRoute']);


app.config(function($routeProvider) {
    $routeProvider
    .when("/", {
        templateUrl : "Templates/Planning1.html",
        controller : "planning1_controller"
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
    });
});

app.controller("navCtrl", ['$scope',function($scope)
{
}]);

function raccourci(string)
{
    string= string.replace(/[\n]/gi, "" );
    string = string.replace(/ /g,"");
    return string;

}