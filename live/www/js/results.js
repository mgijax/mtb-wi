$(function() {				
	var $metastases = $('[data-parent]'),
		$rows = $('[data-key]'),
		$table = $rows.closest('table'),
		$thead = $table.find('thead').clone(),
		$tbody = $table.find('tbody'),
		groups = {},
		getFreqClass = function(d) {
			
			if (/very high/i.test(d)) {
				return 'r-100';
			} else if (/high/i.test(d)) {
				return 'r-70';
			} else if (/very low/i.test(d)) {
				return 'r-10';
			} else if (/low/i.test(d)) {
				return 'r-30';
			} else if (/observed/i.test(d)) {
				return 'l-observed';
			} else {
				n = Math.ceil(parseFloat(d) / 10) * 10;
				return 'r-' + n;
			}

		};
	
	$thead.find('th:first-child').html('Metastasis');
	$thead.find('th:last-child').remove();
	$thead.find('a').remove();
	
	if (typeof(root) === 'undefined') {
		root = '';
	}
	
	$rows.each(function() {
		
		var $r = $(this),
			$i = $r.find('td.info'),
			$f = $r.find('.fr'),
			k = $r.data('key'),
			freq = $r.data('freq'),
			$details = $r.find('[data-detail]');
		
		$f.addClass(getFreqClass(freq));
			
		$details.each(function() {
			var $d = $(this),
				page = $d.data('detail'),
				detailUrl = $d.data('expression') ? 'geneExpressionSearchResults.do?tfKey=' : 'tumorFrequencyDetails.do?key=';
				
			$.ajax({
				url: root + detailUrl + k + '&page=' + page,
				dataType: 'html',
				success: function(h) {
					console.log('%s (%s):', k, page);
					console.log(h);
					$d.html(h);
					if ($d.hasClass('is-collapsible')) {
						$d.find('caption').on('click', function() {
							$(this).parent().toggleClass('expanded');
						});
					}
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
			$ul = $p.find('td.info > ul'),
			$table, $li, $caption;
			
		if ($tbody.length == 0) {
			$tbody = $('<tbody></tbody>');
			$table = $('<table class="metastases"></table>');
			$li = $('<li class="is-collapsible"></li>');
			$caption = $('<caption>Metastasis</caption>');
			$caption.on('click', function() {
				$(this).parent().toggleClass('expanded');
			});
			$table.append($caption);
			$table.append($thead.clone());
			$table.append($tbody);
			$li.append($table);
			$ul.append($li);
		}
			
		$m.removeAttr('data-parent');
		$m.find('td:last-child').remove();
		
		$tbody.append($m);

	});	
	
	$('#expand-all').on('click', function() {
		$('[data-detail] > table').addClass('expanded');
	});
	
	$('#collapse-all').on('click', function() {
		$('[data-detail] > table').removeClass('expanded');
	});	

});



