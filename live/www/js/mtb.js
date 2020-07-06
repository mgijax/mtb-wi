$(function() {
	
	// Tooltips
	
	$('[data-tip]').each(function(i) {
		var $e = $(this),
			tip = $e.data('tip'),
			tipId = 'tip-' + i;

		$e.removeAttr('data-tip').addClass('tip');

		if ($e.is('a')) {
			$e.attr('href', '#' + tipId);
		}

		$e.wrapInner('<div aria-describedby="' + tipId + '"></div>');
		$e.append('<div role="tooltip" id="' + tipId + '">' + tip + '</div>');		
		
		$e.on('click', function() {
			$(this).toggleClass('show-tip');
		});		
	});
	
	$('#submit-search').on('click', function() {
		var st = encodeURIComponent($('#search-term').val());
		window.location = 'facetedSearch.do#fq=quickSearch%3A%22' + st + '%22';
	});
	
});
