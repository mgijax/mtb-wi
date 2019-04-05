$(function() {				
	var $metastases = $('[data-parent]'),
		$rows = $('[data-key]'),
		$thead = $rows.closest('table').find('thead').clone();
	
	$thead.find('th:first-child').html('Metastasis');
	$thead.find('th:last-child').remove();
	
	if (typeof(root) === 'undefined') {
		root = '';
	}
	
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
					console.log('%s (%s):', k, page);
					console.log(h);
					$d.html(h);
					$d.find('caption').on('click', function() {
						$(this).parent().toggleClass('expanded');
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
			$table = $('<table class="metastases"></table>');
			$table.append($thead.clone());
			$table.append($tbody);
			$td.append($table);
		}
			
		$m.removeAttr('data-parent');
		$m.find('td:last-child').remove();
		
		$tbody.append($m);

	});	

});



