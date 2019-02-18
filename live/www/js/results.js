$(function() {				
	var o = {
		legends: {
			'fr': function(value) {	
							
				if (!value) { return ''; }
				
				var n = parseFloat(value);
				
				if (!Number.isNaN(n)) {					
					if (n <= 10) { return 'l0'; }
					if (n <= 20) { return 'l1'; }
					if (n <= 50) { return 'l2'; }
					if (n <= 80) { return 'l3'; }
					if (n <= 100) { return 'l4'; }
				}
				
				if (value.indexOf('very high') !== -1) { return 'l4'; }
				if (value.indexOf('high') !== -1) { return 'l3'; }
				if (value.indexOf('very low') !== -1) { return 'l0'; }
				if (value.indexOf('low') !== -1) { return 'l1'; }
				
				return 'l-' + value.replace(/[^a-z\-]/g, '-');
			}
		}
	};				
	$('.agro-source').agro(o);
});