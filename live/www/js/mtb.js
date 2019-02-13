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
	
});
