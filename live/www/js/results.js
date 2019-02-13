$(function() {				
	var o = {
		legends: {
			'fr': function(value) {
				var v = value.trim().toLowerCase(),
					m, n0, n;
				
				if (!v) { return ''; }
				m = v.match(/((\d{1,2})\s*-\s*|&(lt|gt)e?;)?(\d{1,3})/);

				if (m) {
					n = parseInt(m[4], 10);
					if (m[2]) {
						n0 = parseInt(m[2], 10);
						n = (n0 + n) / 2;
					} else if (m[3] == 'lt') {
						n /= 2;
					} else if (m[3]) {
						n = (n + 100) / 2;
					}
					if (n <= 20) { return 'l0'; }
					if (n <= 40) { return 'l1'; }
					if (n <= 60) { return 'l2'; }
					if (n <= 80) { return 'l3'; }
					if (n <= 100) { return 'l4'; }
				}
				
				if (v.indexOf('very high') !== -1) { return 'l4'; }
				if (v.indexOf('high') !== -1) { return 'l3'; }
				if (v.indexOf('very low') !== -1) { return 'l0'; }
				if (v.indexOf('low') !== -1) { return 'l1'; }
				
				return 'l-' + v.replace(/[^a-z\-]/g, '-');
			}
		}
	};				
	$('.agro-source').agro(o);
});