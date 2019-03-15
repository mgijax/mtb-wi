$(function() {				
	var $metastases = $('[data-parent]'),
		$rows = $('[data-key]');
	
	root = root || '';

	
	$rows.each(function() {
		
		var $r = $(this),
			$i = $r.find('td.info'),
			k = $r.data('key'),
			$details = $r.find('[data-detail]'),
			$expressions = $r.find('[data-expression]');
			
		$details.each(function() {
			var $d = $(this),
				page = $d.data('detail');
				
			$.ajax({
				url: root + 'tumorFrequencyDetails.do?key=' + k + '&page=' + page,
				dataType: 'html',
				success: function(h) {
					var $tds = $(h).find('td:first-child');
					$tds.each(function() {
						$d.append('<p>' + $(this).html() + '</p>');
					});
				}
			})
		});
	});
	
	$metastases.each(function() {
		
		var $m = $(this),
			p = $m.data('parent'),
			$p = $('[data-key="' + p + '"]'),
			$td = $p.find('td.info'),
			$tbody = $td.find('tbody'),
			$table;
			
		if ($tbody.length == 0) {
			$tbody = $('<tbody></tbody>');
			$table = $('<table></table>');
			$table.append($tbody);
			$td.append($table);
		}
			
		$m.removeAttr('data-parent');
		
		$tbody.append($m);

	});	
	
	
	
});



