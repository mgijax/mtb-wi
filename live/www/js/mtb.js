$(function() {

	var $searchType = $('#search-type'),
		$searchTerm = $('#search-term'),
		updateSearchPh = function() {
			var $o = $searchType.find(':selected');		
			$searchTerm.attr('placeholder', $o.data('ph'));
		};
	
	updateSearchPh();
	$('#search-type').on('change', updateSearchPh);

});