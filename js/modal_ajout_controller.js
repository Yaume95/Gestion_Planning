app.controller('ajoutCtrl', ['$scope', '$http', function($scope,$http)
{
  $scope.ajouter_personne=function()
    {

        nom=$('#NomSubmit2').val();
        nom= nom.charAt(0).toUpperCase() +nom.substring(1);
        totalH=$('#HSubmit2').val();      
        maxCA=$('#CASubmit2').val();    
        maxCAav=$('#CAavSubmit2').val();    
        matricule=$('#MatSubmit2').val();
        vac= $('#VacSubmit2').is(':checked');

        $http({ 
        method : 'POST',
        url : './BDD/ajout_personne.php',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        data :  {

                    Nom: nom,
                    NbHaFaire: totalH,
                    CAapMax: maxCA,
                    CAavMax: maxCAav,
                    Vaccataire: vac,
                    Matricule: matricule
                    
                } 
        })
        .then(function successCallback(response)
        {


            $('#Ajout').modal('hide');
            $('#NomSubmit2').val(null);      
            $('#HSubmit2').val(null);      
            $('#CASubmit2').val(null);    
            $('#CAavSubmit2').val(null);
            $('#MatSubmit2').val(null);
            $scope.refresh();

        });
        $scope.myform.$setPristine();

    }

}]);


app.directive('myIsNumber', function() {
    return {
        require: 'ngModel',
        link: function(scope, element, attr, mCtrl) {
            function myValidation(value) {
                if (!isNaN(Number(value) && value.length>0)) {
                    mCtrl.$setValidity('number', true);
                } 
                else
                {
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
                if (/^[a-zA-ZáàâäãåçéèêëíìîïñóòôöõúùûüýÿæœÁÀÂÄÃÅÇÉÈÊËÍÌÎÏÑÓÒÔÖÕÚÙÛÜÝŸ]*([ '-][a-zA-ZáàâäãåçéèêëíìîïñóòôöõúùûüýÿæœÁÀÂÄÃÅÇÉÈÊËÍÌÎÏÑÓÒÔÖÕÚÙÛÜÝŸ]+)*$/.test(value) == true && value.length>=3) 
                {
                    mCtrl.$setValidity('textOnly', true);
                    mCtrl.$setValidity('textTooShort', false);

                } 
                else if (/^[a-zA-ZáàâäãåçéèêëíìîïñóòôöõúùûüýÿæœÁÀÂÄÃÅÇÉÈÊËÍÌÎÏÑÓÒÔÖÕÚÙÛÜÝŸ]*([ '-][a-zA-ZáàâäãåçéèêëíìîïñóòôöõúùûüýÿæœÁÀÂÄÃÅÇÉÈÊËÍÌÎÏÑÓÒÔÖÕÚÙÛÜÝŸ]+)*$/.test(value) == true &&  value.length<3)
                {
                    mCtrl.$setValidity('textOnly', true);
                    mCtrl.$setValidity('textTooShort', true);
                }
                else if (/^[a-zA-ZáàâäãåçéèêëíìîïñóòôöõúùûüýÿæœÁÀÂÄÃÅÇÉÈÊËÍÌÎÏÑÓÒÔÖÕÚÙÛÜÝŸ]*([ '-][a-zA-ZáàâäãåçéèêëíìîïñóòôöõúùûüýÿæœÁÀÂÄÃÅÇÉÈÊËÍÌÎÏÑÓÒÔÖÕÚÙÛÜÝŸ]+)*$/.test(value) == false && value.length>=3)
                {
                    mCtrl.$setValidity('textOnly', false);
                    mCtrl.$setValidity('textTooShort', false);
                }
                else if (/^[a-zA-ZáàâäãåçéèêëíìîïñóòôöõúùûüýÿæœÁÀÂÄÃÅÇÉÈÊËÍÌÎÏÑÓÒÔÖÕÚÙÛÜÝŸ]*([ '-][a-zA-ZáàâäãåçéèêëíìîïñóòôöõúùûüýÿæœÁÀÂÄÃÅÇÉÈÊËÍÌÎÏÑÓÒÔÖÕÚÙÛÜÝŸ]+)*$/.test(value) == false && value.length<3)
                {
                    mCtrl.$setValidity('textOnly', false);
                    mCtrl.$setValidity('textTooShort', true);
                }
                return value;
            }
            mCtrl.$parsers.push(myValidation);
        }
    };
});

app.directive('isEmpty', function() {
    return {
        require: 'ngModel',
        link: function(scope, element, attr, mCtrl) {
            function myValidation(value) {
                if (value == "") {
                    mCtrl.$setValidity('isEmpty', true);
                } else {
                    mCtrl.$setValidity('isEmpty', false);
                }
                return value;
            }
            mCtrl.$parsers.push(myValidation);
        }
    };
});