app.controller('ajoutCtrl', ['$scope', '$http', function($scope,$http)
{
  $scope.ajouter_personne=function()
    {
        nom=$('#NomSubmit2').val();
        nom= nom.charAt(0).toUpperCase() +nom.substring(1);
        totalH=$('#HSubmit2').val();      
        maxCA=$('#CASubmit2').val();    
        maxCAav=$('#CAavSubmit2').val();        
        $http({ 
        method : 'POST',
        url : './BDD/ajout_personne.php',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        data :  {

                    Nom: nom,
                    NbHaFaire: totalH,
                    CAapMax: maxCA,
                    CAavMax: maxCAav
                    
                } 
        })
        .then(function successCallback(response)
        {
            $('#Ajout').modal('hide');
            $('#NomSubmit2').val("");      
            $('#HSubmit2').val("");      
            $('#CASubmit2').val("");    
            $('#CAavSubmit2').val(""); 
            $scope.refresh();
            $scope.data.myform.AjoutHsetPristine();

        });
    }
  
}]);


app.directive('myIsNumber', function() {
    return {
        require: 'ngModel',
        link: function(scope, element, attr, mCtrl) {
            function myValidation(value) {
                if (!isNaN(value)) {
                    mCtrl.$setValidity('number', true);
                } else {
                    mCtrl.$setValidity('number', false);
                }
                return value;
            }
            mCtrl.$parsers.push(myValidation);
        }
    };
});

app.directive('myTextOnly', function() {
    return {
        require: 'ngModel',
        link: function(scope, element, attr, mCtrl) {
            function myValidation(value) {
                if (/^[a-zA-Z- ]*$/.test(value) == true) {
                    mCtrl.$setValidity('textOnly', true);
                } else {
                    mCtrl.$setValidity('textOnly', false);
                }
                return value;
            }
            mCtrl.$parsers.push(myValidation);
        }
    };
});