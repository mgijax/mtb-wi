
const baseUrl = (typeof contextPath !== 'undefined') ? contextPath : 'http://bhmtbdb01:8080/mtbwi2',

	solrUrl = baseUrl + '/solrQuery.do',

	configs = [
		{
			name: 'primarySite',
			title: 'Primary Site',
			fields: ['organOriginParent', 'organOrigin'],
			isExpanded: true
		},
		{
			name: 'tumorType',
			title: 'Tumor Type',
			fields: ['tcParent', 'tumorClassification'],
			isExpanded: true
		},
		{
			name: 'organAffected',
			title: 'Site of Metastasis'
		},
		{
			name: 'agentType',
			title: 'Tumor Inducing Agent Type'
		},
		{
			name: 'agent',
			title: 'Tumor Inducing Agent'
		},
		{
			name: 'strainMarker',
			title: 'Genes &amp; Alleles',
			isExpanded: true
		},
		{
			name: 'strain',
			title: 'Strain',
			fields: ['strain', 'strainNames'],
			isExpanded: true
		},
		{
			name: 'strainType',
			title: 'Strain Type',
			isExpanded: true
		},
		{
			name: 'frequency',
			title: 'Tumor Frequency',
			terms: [
				{
					label: '0',
					queryKey: 'freqMax',
					queryValue: '0'
				},
				{
					label: '&le;&nbsp;50%',
					queryKey: 'freqMin',
					queryValue: '[0 TO 50]'
				},
				{
					label: '&gt;&nbsp;50%',
					queryKey: 'freqMin',
					queryValue: '{50 TO 100]'
				}
			]
		},
		{
			name: 'colonyMax',
			title: 'Study Size',
			format: l => { let n = parseInt(l, 10); return n == 0 ? ('' + n) : ('&le;&nbsp;' + n); }
		},
		{
			name: 'reference',
			title: 'Reference',
			fields: ['authors', 'journal']
		},
		{
			name: 'info',
			title: 'Additional Information',
			hasSearch: false,
			terms: [
				{
					label: 'Has Pathology Image(s)',
					queryKey: 'pathologyImages',
					queryValue: '[* TO *]'
				},
				{
					label: 'Has Cytogenetic Image(s)',
					queryKey: 'cytoImages',
					queryValue: '[* TO *]'
				},
				{
					label: 'Has Gene Expression Data Link(s)',
					queryKey: 'geneExpression',
					queryValue: 'true'
				}
			]
		}	
	],

	solrQuery = {
		wt: 'json',
		indent: 'on',
		facet: 'true',
		'facet.sort': 'index', // count, index
		'facet.mincount': 1,
		'facet.limit': -1,
		sort: 'freqMin desc', // organOrigin asc
		q: '*:*'
	},
	
	savedUiKey = 'mmhc-facets',
		
	indices = configs.reduce((a, o, i) => { a[o.name] = i; return a; }, {}),
	
	composites = configs.reduce((a, o) => {
		if (o.fields) {
			o.fields.forEach(f => {
				a[f] = o.name;
			});
		}
		return a; 
	}, {}),
	
	displayFields = ['freqM', 'freqF', 'freqX', 'freqU', 'referenceID', 'strainKey', 'tumorFrequencyKey', 'metsTo'],
	
	solrFields = configs.reduce((a, o) => {
		if (o.terms) {
			let queryKeys = o.terms.filter(t => ('queryKey' in t)).map(t => t.queryKey);
			if (queryKeys) {
				return a.concat(queryKeys);
			}
		}
		return a.concat(o.fields || o.name);
	}, displayFields),

	solrParams = $.param(solrQuery) + '&' + solrFields.map(f => 'facet.field=' + f).join('&'),
	
	termChunkSize = 15;
	
let facet,
	addRow,
	cell,
	freq,
	modelUrl,
	$facets,	
	$rows,
	
	totalRows = 0,
	
	pageQuery = {
		start: 0,
		rows: 25
	},
	
	facets = {},
	
	getConfig = function(n) {
		return (n in indices) ? configs[indices[n]] : false;
	},

	getQueryParams = function(useHash) {
		let facetQuery = [],
			pageParams = '&' + $.param(pageQuery)
			facetQueryParams = false;
		
		if (useHash) {
			facetQueryParams = window.location.hash.substr(1);
		} else {
			$.each(facets, function(k, f) {			
				if (f.query && f.query.length > 0) {
					facetQuery.push(f.query);
				}
			});
			facetQueryParams = facetQuery.join('&');
		}
		if (facetQueryParams) {
			window.location.hash = '#' + facetQueryParams;
			return solrParams + pageParams + '&' + facetQueryParams;
		} else {
			window.location.hash = '';
			return solrParams + pageParams;
		}

	},
	
	sw = function(n) {
		
		let startTime = (new Date()).getTime();
		
		return {
			
			stop: function() {
				
				let elapsedTime = ((new Date()).getTime() - startTime) / 1000;
				console.log(n + ': ' + elapsedTime + 's');
				
			}
			
		};
		
	},

	getOrderedConfigs = function(responseFields) {
		
		let savedFacetsRaw = localStorage.getItem(savedUiKey),
			hasTerms = {},
			orderedConfigs = [];
			
		// console.log(savedFacetsRaw);
			
		$.each(responseFields, function(fieldName, termsRaw) {
			
			let isComposite = (fieldName in composites),
				facetName = isComposite ? composites[fieldName] : fieldName,
				config = getConfig(facetName);
				
			if (config) {
				
				//let _sw = sw('config ' + facetName);
				
				let queryKey = isComposite ? fieldName : null,				
					terms = [];
		
				for (let i = 0; i < termsRaw.length; i += 2) {					
					terms.push({
						'label': termsRaw[i],
						'resultCount': termsRaw[i + 1],
						'queryKey' : queryKey
					});
				}
				
				if (config.format) {
					terms.forEach(t => {
						t.queryValue = t.label;
						t.label = config.format(t.label);
					});
				}
				
				if (!(facetName in hasTerms)) {
					hasTerms[facetName] = true;
					config.terms = [];
				}
	
				config.terms = config.terms.concat(terms);
				
				//_sw.stop();
			}			

		});
			
		if (savedFacetsRaw) {
			
			let savedFacets = savedFacetsRaw.split('|');
			
			$.each(savedFacets, function(i, f) {
				
				let info = f.split(':'),
					config = getConfig(info[0]);

				if (config) {
					config.isRemaining = false;
					config.isExpanded = (info[1] == '1');		
					orderedConfigs.push(config);
				}

			});
		}	
		
		orderedConfigs = orderedConfigs.concat(configs.filter(config => config.isRemaining !== false));

		return orderedConfigs;

	},
	
	saveFieldOrder = function() {
		
		let savedFacets = [];
		
		$facets.children().each(function() {
			let $f = $(this);
			savedFacets.push($f.data('facet-name') + ':' + ($f.hasClass('show-detail') ? '1' : '0'));
		});
		
		localStorage.setItem(savedUiKey, savedFacets.join('|'));
		
	},

	updateWithResponse = function(o) {

		
		let orderedConfigs = getOrderedConfigs(o.facet_counts.facet_fields);

		orderedConfigs.forEach(updateFacet);

		if ($facets.sortable('instance') === undefined) {
			$facets.sortable();
			$facets.on('sortupdate', saveFieldOrder);
		} else {
			$facets.sortable('refresh');
		}

		$table.removeClass('has-organ-affected');
		$rows.empty();
		
		totalRows = o.response.numFound;
		updatePageSummary();
		$.each(o.response.docs, addRow);


	},
	
	kebab = function(s) {
		// https://gist.github.com/thevangelist/8ff91bac947018c9f3bfaad6487fa149
		return s.replace(/[^A-Za-z0-9\s\/,]/g, '').replace(/([a-z])([A-Z])/g, '$1-$2').replace(/[\s\/,]+/g, '-').toLowerCase();
	},
	
	updateFacet = function(config, index) {
		
		if (!(config.name in facets)) {
			let _sw = sw('create facet ' + config.name);
			facets[config.name] = facet(config);
			_sw.stop();
		}
		
		facets[config.name].update(config.terms);
		
	},
	
	updatePageSummary = function() {
		$first.html(pageQuery.start + 1);
		if (totalRows) {
			$last.html(Math.min(totalRows, pageQuery.start + pageQuery.rows));
			$total.html(totalRows);
		} else {
			$last.empty();
			$total.empty();
		}		
	},
	
	doQuery = function(useHash) {
		updatePageSummary();
		$.ajax({
			type: 'POST',
			url: solrUrl,
			data: getQueryParams(useHash),
			dataType: 'json',
			success: updateWithResponse
		});
	};
	
	
facet = function(config) {
	
	let o = Object.assign({query: ''}, config),
		queryTerms = [],
		$ui = $('<div>'),
		$head = $('<div class="facet-head">'),
		$plus = $('<i class="fa">'),
		$title = $('<h3>' + o.title + '</h3>'),
		$sort = $('<i class="up-down">'),
		$detail = $('<div class="facet-detail">'),
		$selected = $('<ul class="selected-terms">'),
		$search = $('<input placeholder="Search" type="text">'),
		$terms = $('<ul class="terms">'),
		$lis = $terms.children(),
		updateSelectedTerms, getTermKey, appendTerms,
		termsBottom = 0,
		termIndex = 0;

	$ui.attr('id', kebab(o.name));
	$ui.data('facet-name', o.name);	
	
	$head.append($plus).append($title).append($sort);
	if (o.hasSearch !== false) {
		$detail.append($search)
	}
	$detail.append($selected).append($terms);
	$ui.append($head).append($detail);
	
	$ui.toggleClass('show-detail', o.isExpanded === true);
	
	$plus.on('click', function() {
		o.isExpanded = !o.isExpanded;
		$ui.toggleClass('show-detail');
		saveFieldOrder();
	});
	
	$terms.on('scroll', function() {
		
		let $e = $(this),
			scrollBottom = $e.scrollTop() + $terms.height();

		if (scrollBottom >= termsBottom) {
			appendTerms();
		}
		
	});
	
	$facets.append($ui);
	
	
	appendTerms = function(isAll) {
		
		let chunkSize = isAll ? (o.terms.length - termIndex + 1) : termChunkSize;
		
		o.terms.slice(termIndex, termIndex + chunkSize).forEach(t => {
			let termKey = getTermKey(t.label, t.queryKey),
				$selectedLi = $selected.find('[data-term-key="' + termKey + '"]'),
				selectedAttr = ($selectedLi.length > 0) ? ' class="term-selected"' : '',
				$termLi;
				
			$termLi = $(
				'<li' + selectedAttr + ' data-term-key="' + termKey + '"' + 
				(t.queryKey ? (' data-query-key="' + t.queryKey + '"') : '') +
				(t.queryValue ? (' data-query-value="' + t.queryValue + '"') : '') +
				'><span>' + t.label + '</span>' +
				(t.resultCount ? ('&nbsp;&#x22ef;&nbsp;' + t.resultCount) : '') +
				'</li>');
			
			$termLi.on('click', function() {
				$(this).toggleClass('term-selected');
				updateSelectedTerms();			
			});
				
			$terms.append($termLi);
		});
		
		termIndex += chunkSize;
		
		
		
		$lis = $terms.children();
		
		let $lastLi = $lis.last();
		
		termsBottom = ($lastLi.length > 0) ? ($lastLi.position().top + $lastLi.height()) : 0;
	};
	

	o.update = function(terms) {		
		o.terms = terms;		
		$ui.toggleClass('all-selected', o.terms.length <= $selected.children().length);		
		termIndex = 0;		
		$terms.empty();		
		appendTerms();
	};
	
	o.clear = function() {
		$selected.empty();
		$selected.removeClass('has-selected');
		o.query = '';
	};
	
	$search.on('focus keydown', function() {
		appendTerms(true);
	});
	
	$search.on('keyup', function() {
		
		let v = $(this).val().toLowerCase();
		
		$lis.each(function() {		
			let $li = $(this);			
			$li.toggleClass('hide-term', $li.html().toLowerCase().indexOf(v) === -1);		
		});
		
	});
	
	updateSelectedTerms = function() {
		$selected.empty();
		queryTerms = [];
		let $s = $lis.filter('.term-selected');
		$selected.toggleClass('has-selected', $s.length > 0);
		$s.each(function() {
			let $li = $(this).clone(),
				$span = $li.find('span');
			$li.empty().append($span);
			$selected.append($li);
		});
		$selectedLis = $selected.children();
		
		$selectedLis.each(function() {
			let $li = $(this);
			queryTerms.push(
				($li.data('query-key') || o.name) + ':' + 
				($li.data('query-value') || ('"' + $li.find('span').html() + '"')));
		});
		o.query = $.param({ 'fq': queryTerms }, true);

		$selectedLis.on('click', function() {
			
			let $selectedLi = $(this),
				termKey = $selectedLi.data('term-key'),
				$term = $terms.find('[data-term-key="' + termKey + '"]');
				
			$term.removeClass('term-selected');
			updateSelectedTerms();
			
		});
		
		pageQuery.start = 0;
		totalRows = 0;
		
		doQuery();
	};
	
	getTermKey = function(l, k) {
		return kebab(l) + (k ? ('-' + kebab(k)) : '');
	};
	
	return o;
	
};

cell = function(o, c) {	
	if (!o) {
		return $('<td>');
	} else if (!c) {
		return $('<td>' + o + '</td>');
	}	
	return $('<td>' + c(o) + '</td>');	
};

freq = function(fs) {
	let fc;
	
	if (fs.indexOf('observed') !== -1) {
		fc = 'fr-observed';
	} else if (fs == '0') {
		fc = 'fr-0';
	} else {
		
		let f = fs.split('-')[0].trim();
		
		if (f >= 80) {
			fc = 'fr-80';
		} else if (f >= 50) {
			fc = 'fr-50';
		} else if (f >= 20) {
			fc = 'fr-20';
		} else if (f >= 10) {
			fc = 'fr-10';
		} else {
			fc = 'fr-01';
		}	
		
	}

	return '<p class="fr ' + fc + '">' + fs + '</p>';
};

modelUrl = function(r) {
	return 'tumorSummary.do' +
		'?strainKey=' + r.strainKey +
		'&organOfOriginKey=' + r.organOriginKey + 
		'&tumorFrequencyKeys=' + r.tumorFrequencyKey.join(',');
};

info = function(r) {
	
	let h = '',
		fk = r.tumorFrequencyKey.join(',');
	
	if (r.referenceID) {
		h += '<p>' + r.referenceID.length + '&nbsp;Reference' + (r.referenceID.length == 1 ? '' : 's');
		h += ': ' + r.referenceID.map(a => '<a href="' + baseUrl +
			'/referenceDetails.do?accId=' + a + '" target="_blank">' + a + '</a>').join(', ') + '</p>';		
	}
	
	if (r.metsTo) {
		h += '<p>Sites of Metastasis: ' + r.metsTo.join(', ') + '</p>';			
	}
	
	if (r.pathologyImages) {
		h += '<p><a href="' + baseUrl +
			'/pathologyImageSearchResults.do?tfKeys=' + fk +'" target="_blank">' +
			r.pathologyImages + ' Pathology Image' + (r.pathologyImages == 1 ? '' : 's') + '</a></p>';
	}

	if (r.cytoImages) {		
		h += '<p><a href="' + baseUrl +
			'/tumorFrequencyDetails.do?page=cytogenetics&key=' + r.cytoImages +'" target="_blank">' +
			r.cytoCount + ' Cytogenetic Image' + (r.cytoCount == 1 ? '' : 's') + '</a></p>';		
	}
	
	if (r.geneExpression) {
		h += '<p><a href="' + baseUrl +
			'/geneExpressionSearchResults.do?tfKeys=' + fk +'" target="_blank">' +
			'Gene Expression Data</a></p>';
	}
	
	return h;	
};

addRow = function(i, r) {
	
	let $r = $('<tr>'),
		mu = modelUrl(r),
		$name = cell(r, r => {
			return '<a href="' + mu + '">' +
				r.organOrigin + '<br>' + r.tumorClassification +
				'</a>';
		}),
		$organ = cell(r.organAffected, a => {
			if (a !== r.organOrigin) {
				$table.addClass('has-organ-affected');
				return a;
			}
			return '';
		}),
		$agent = cell(r.agent, a => a.join(', ')),
		$strain = cell(r, r => r.strain + r.strainType.map(t => '<em>' + t + '</em>').join('')),
		$freqF = cell(r.freqF, freq),
		$freqM = cell(r.freqM, freq),
		$freqX = cell(r.freqX, freq),
		$freqU = cell(r.freqU, freq),
		$info = cell(r, info),
		$details = cell(r, r => '<a href="' + mu + '"><i class="mo"></i></a>');

		$r.append($name).append($organ).append($agent).append($strain)
			.append($freqF).append($freqM).append($freqX).append($freqU)
			.append($info).append($details);

	$rows.append($r);

};
	
	
	
	
	
	
$(function() {
	
	let $w = $(window),
		$body = $('body'),
		$facetUi = $('#facet-ui'),
		$bodyHeader = $('body > header'),
		headerHeight = 102;
	
    $w.on('scroll', function () {
        $body.toggleClass('scrolled', $w.scrollTop() > headerHeight);
    });
    
    $w.on('resize', function() {
	    headerHeight = $bodyHeader.height();	    
    });	
	
	$facets = $('#facets');
	$table = $('#facet-results');
	$rows = $('#facet-results tbody');
	$first = $('#result-first');
	$last = $('#result-last');
	$total = $('#result-total');
	
	$('#collapse-all').on('click', function() {		
		$('#facets').children().removeClass('show-detail');
	});
	
	$('#clear-all').on('click', function() {
		$.each(facets, (k, f) => {
			f.clear();
		});
		doQuery();
	});
	
	
	$('#result-prev').on('click', function() {		
		pageQuery.start = Math.max(0, pageQuery.start - pageQuery.rows);
		doQuery();		
	});
	
	$('#result-next').on('click', function() {		
		pageQuery.start = Math.min(totalRows, pageQuery.start + pageQuery.rows);
		doQuery();		
	});	
	
	doQuery(true);
	
});
	
	






