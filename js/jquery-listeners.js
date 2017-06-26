var active = "#!/Planning_Personne";

$(document).ready(function() {

    $('#body').show();

    $('#AjoutEtat').draggable({
      handle: ".modal-header"
  	});

  	$('.Dim .Sam').on("contextmenu", function(e)
  	{
  		e.preventDefault();
  	});

});
