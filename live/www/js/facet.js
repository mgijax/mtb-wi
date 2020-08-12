
const baseUrl = (typeof contextPath !== 'undefined') ? contextPath : 'http://tumor.informatics.jax.org/mtbwi',

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
			name: 'metsTo',
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
					label: 'Max is 0',
					queryKey: 'freqMax',
					queryValue: '[0 TO 0]'
				},
				{
					label: 'Max &le;&nbsp;50%',
					queryKey: 'freqMax',
					queryValue: '[0 TO 50]'
				},
				{
					label: 'Min &ge;&nbsp;50%',
					queryKey: 'freqMin',
					queryValue: '[50 TO 100]'
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
				},
				{
					label: 'Frequency &ge; 80% &amp; Colony Size &ge; 20',
					queryKey: 'minFC',
					queryValue: '1'					
				},
				{
					label: 'Is Mutant',
					queryKey: 'mutant',
					queryValue: 'true'
				},
				{
					label: 'Is Not Mutant',
					queryKey: 'mutant',
					queryValue: 'false'
				}
			]
		},
		{
			name: 'humanTissue',
			title: 'Human Tissue',
			isExpanded: false
		}	
	],

	solrQuery = {
		wt: 'json',
		indent: 'on',
		facet: 'true',
		'facet.sort': 'count', 		// count, index
		'facet.mincount': 1,
		'facet.limit': -1,
		sort: 'freqMax desc', 		// organOrigin asc
		q: '*:*'
	},
	
	savedUiKey = 'mmhc-facets',
		
	indices = configs.reduce((a, o, i) => { 
		
		a[o.name] = i;
		if (o.fields) {
			o.fields.forEach(f => {
				a[f] = i;
			});			
		}
		if (o.terms) {
			o.hasPredefinedTerms = true;
			o.terms.forEach(t => {
				if (t.queryKey) {
					a[t.queryKey] = i;
				}
			});
		}
		return a; 
		
	}, {}),
	
	displayFields = ['freqAll', 'freqM', 'freqF', 'freqX', 'freqU', 'referenceID', 'strainKey', 'tumorFrequencyKey', 'metsTo'],
	
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
	$facetUi,
	$facets,	
	$rows,
	
	recentExpanded = [],
	recentForcedCollapse = [],
	hasAllCollapsed = false,
	
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
		let pageParams = '&' + $.param(pageQuery),
			facetQueryParams = false,
			facetQuery;
		
		if (useHash) {
			facetQueryParams = window.location.hash.substr(1);
			
			if (facetQueryParams) {
				
				configs.forEach(c => {
					c.initSelectedTerms = [];
				});
						
				facetQuery = facetQueryParams.replace(/%25/g, '%').split('&').map(p => decodeURIComponent(p).split('=')[1].split(':'));
				console.log('facetQuery from hash: %o', facetQuery);
				facetQuery.forEach(q => {
					
					let config = getConfig(q[0]);
					
					if (config && q[1]) {
						
						let queryValue = q[1].replace(/\+/g, ' ').replace(/"/g, ''),
							selectedTerm;
							
						if (config.terms) {
							
							// selectedTerm = config.terms.find(t => t.queryValue == queryValue);
							selectedTerm = config.terms.find(t => t.queryKey == q[0]);
							
							
							
						} else {
							
							selectedTerm = {
								'label': config.format ? config.format(queryValue) : queryValue
							};

							if (config.fields) {
								selectedTerm.queryKey = q[0];
							}
							
							if (config.format) {
								selectedTerm.queryValue = queryValue;
								selectedTerm.label = config.format(selectedTerm.label);
							}
						
						}									
						config.initSelectedTerms.push(selectedTerm);
						// console.log('%s: config.initSelectedTerms: %o', config.name, config.initSelectedTerms);
					}
				});
			}
		} else {
			facetQuery = [];
			$.each(facets, function(k, f) {			
				if (f.query && f.query.length > 0) {
					facetQuery.push(f.query);
				}
			});
			console.log('facetQuery from ui: %o', facetQuery);
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


	getOrderedConfigs = function(responseFields) {
		
		let savedFacetsRaw = localStorage.getItem(savedUiKey),
			orderedConfigs = [];
			
		configs.forEach(c => {
			if (!c.hasPredefinedTerms) {
				c.terms = [];
			}
		});
			
		$.each(responseFields, function(fieldName, termsRaw) {
			
			let config = getConfig(fieldName);
				
			if (config && !config.hasPredefinedTerms) {
				
				let terms = [];

				for (let i = 0; i < termsRaw.length; i += 2) {					
					terms.push({
						'label': termsRaw[i],
						'resultCount': termsRaw[i + 1]
					});
				}
				
				if (config.fields) {
					terms.forEach(t => {
						t.queryKey = fieldName;
					});
				}
				
				if (config.format) {
					terms.forEach(t => {
						t.queryValue = t.label;
						t.label = config.format(t.label);
					});
				}
				
				config.terms = config.terms.concat(terms);
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
	
	updateFacetUiState = function() {
		
		let savedFacets = [],
			$fi = $facets.children();
		
		resizeFacetUi(false);

		// console.log('recentExpanded: %o', recentExpanded);		
		// console.log('updateFacetUiState: wh: %i, h: %i, f: %s', wh, uh, fn);

		$fi.each(function() {
			let $f = $(this);
			savedFacets.push($f.data('facet-name') + ':' + ($f.hasClass('show-detail') ? '1' : '0'));
		});
		
		localStorage.setItem(savedUiKey, savedFacets.join('|'));
		
	},
	
	resizeFacetUi = function(shouldFill) {
		
		let wh = $(window).height(),
			uh = $facets.outerHeight() + $('#facet-controls').outerHeight() + 124,
			i = 0;
			
		console.log('resizeFacetUi: recentForcedCollapse: %o', recentForcedCollapse);
		console.log('resizeFacetUi: recentExpanded: %o', recentExpanded);

		if (shouldFill && !hasAllCollapsed) {
			// Expand the most recent force-collapsed facets, while there is room
			while (uh < wh && recentForcedCollapse.length > 0) {
				let n = recentForcedCollapse.pop();
				facets[n].unForceCollapse();	
				uh = $facets.outerHeight() + $('#facet-controls').outerHeight() + 124;
			}
		}	

		// Force the least recently expanded facets to collapse
		while (uh > wh && i < recentExpanded.length) {
			facets[recentExpanded[i]].forceCollapse();
			uh = $facets.outerHeight() + $('#facet-controls').outerHeight() + 124;
			i += 1;
		}				
	},

	updateWithResponse = function(o) {

		
		let orderedConfigs = getOrderedConfigs(o.facet_counts.facet_fields);

		orderedConfigs.forEach(updateFacet); 
		console.log('recentExpanded: %o', recentExpanded);

		if ($facets.sortable('instance') === undefined) {
			$facets.sortable();
			$facets.on('sortupdate', updateFacetUiState);
		} else {
			$facets.sortable('refresh');
		}

		$table.removeClass('has-organ-affected');
		$rows.empty();
		
		totalRows = o.response.numFound;
		
		$.each(o.response.docs, addRow);
		updatePageSummary();

	},
	
	kebab = function(s) {
		// https://gist.github.com/thevangelist/8ff91bac947018c9f3bfaad6487fa149
		return s.replace(/[^A-Za-z0-9\s\/,]/g, '').replace(/([a-z])([A-Z])/g, '$1-$2').replace(/[\s\/,]+/g, '-').toLowerCase();
	},
	
	getTermKey = function(l, k) {
		return kebab(l) + (k ? ('-' + kebab(k)) : '');
	},
	
	updateFacet = function(config, index) {
		
		if (!(config.name in facets)) {
			facets[config.name] = facet(config);
			if (config.isExpanded) {
				recentExpanded.unshift(config.name);
			}
		}
		
		facets[config.name].update(config.terms);
		
	},

	
	updatePageSummary = function() {
		$first.html(pageQuery.start + 1);
		if (totalRows) {
			$('#result-count').show();
			$('#no-results').hide();
			$last.html(Math.min(totalRows, pageQuery.start + pageQuery.rows));
			$total.html(totalRows);
		} else {
			$('#result-count').hide();
			$('#no-results').show();
			$last.empty();
			$total.empty();
		}		
	},
	
	doQuery = function(useHash) {
		// updatePageSummary();
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
		$clearSearch, $searchWrap, clearSearch,
		updateQueryAndListeners,
		updateSelectedTerms, appendTerms,
		termsBottom = 0,
		termIndex = 0;

	$ui.attr('id', kebab(o.name));
	$ui.data('facet-name', o.name);
	
	clearSearch = function() {};
	
	$head.append($plus).append($title).append($sort);
	if (o.hasSearch !== false) {
		$clearSearch = $('<i class="fa fa-times-circle"></i>');
		$searchWrap = $('<div class="search-wrap"></div>');
		$searchWrap.append($search).append($clearSearch);
		$detail.append($searchWrap);
		clearSearch = function() {
			$search.val('');
			$searchWrap.removeClass('show-clear');
			$lis.removeClass('hide-term');
		};		
		$clearSearch.on('click', clearSearch);
	}
	$detail.append($selected).append($terms);
	$ui.append($head).append($detail);
	
	$ui.toggleClass('show-detail', o.isExpanded === true);
	
	o.unForceCollapse = function() {
		o.isExpanded = true;
		$ui.addClass('show-detail');
	}
	
	o.forceCollapse = function() {		
		o.isExpanded = false;
		$ui.removeClass('show-detail');
		recentForcedCollapse.push(o.name);
		console.log('recentForcedCollapse: %o', recentForcedCollapse);
	}
	
	$plus.on('click', function() {
		o.isExpanded = !o.isExpanded;
		$ui.toggleClass('show-detail', o.isExpanded);
		let removeIndex = recentExpanded.indexOf(o.name);
		if (removeIndex !== -1) {
			recentExpanded.splice(removeIndex, 1);
		}		
		if (o.isExpanded) {
			recentExpanded.push(o.name);
			if (recentExpanded.length > $facets.children().length) {
				recentExpanded.shift();
			}
		}
		updateFacetUiState();
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
		
		let chunkSize = isAll ? (o.terms.length - termIndex + 1) : termChunkSize,
			chunk = document.createDocumentFragment();
		
		o.terms.slice(termIndex, termIndex + chunkSize).forEach(t => {
			let termKey = getTermKey(t.label, t.queryKey),
				$selectedLi = $selected.find('[data-term-key="' + termKey + '"]'),
				termLi;
			
			termLi = document.createElement('li');
			if ($selectedLi.length > 0) {
				termLi.className = 'term-selected';
			}
			termLi.setAttribute('data-term-key', termKey);
			if (t.queryKey) {
				termLi.setAttribute('data-query-key', t.queryKey);
			}
			if (t.queryValue) {
				termLi.setAttribute('data-query-value', t.queryValue);
			}
			termLi.innerHTML = '<span>' + t.label + '</span>' + (t.resultCount ? ('&nbsp;&#x22ef;&nbsp;' + t.resultCount) : '');
			chunk.appendChild(termLi);						
		});
		
		$terms.append(chunk);
		
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
		$ui.removeClass('has-selected');
		queryTerms = [];
		o.query = '';
		clearSearch();
	};
	
	$search.on('keyup', function() {
		appendTerms(true);
		let v = kebab($(this).val());
		$searchWrap.toggleClass('show-clear', v.length > 0);
		$lis.each(function() {		
			let $li = $(this);			
			$li.toggleClass('hide-term', $li.data('term-key').indexOf(v) === -1);		
		});
		
	});
	
	updateQueryAndListeners = function() {
		queryTerms = [];
		$selectedLis = $selected.children();
		
		$selectedLis.each(function() {
			let $li = $(this);
			queryTerms.push(encodeURIComponent(
				($li.data('query-key') || o.name) + ':' + 
				($li.data('query-value') || ('"' + $li.find('span').html() + '"'))));
		});
		o.query = $.param({ 'fq': queryTerms }, true).replace('%2B', '');
		
		//console.log('queryTerms: %o', queryTerms);
		//console.log('query: ' + o.query);

		$selectedLis.on('click', function() {
			
			let $selectedLi = $(this),
				termKey = $selectedLi.data('term-key'),
				$term = $terms.find('[data-term-key="' + termKey + '"]');
				
			$term.removeClass('term-selected');
			updateSelectedTerms();
			
		});
	};
	
	updateSelectedTerms = function() {
		$selected.empty();
		
		let $s = $lis.filter('.term-selected');
		$ui.toggleClass('has-selected', $s.length > 0);
		$s.each(function() {
			let $li = $(this).clone(),
				$span = $li.find('span');
			$li.empty().append($span);
			$selected.append($li);
		});
	
		updateQueryAndListeners();
		
		pageQuery.start = 0;
		totalRows = 0;

		doQuery();
	};
	
	$terms.on('click', function(e) {
		$(e.target).closest('li').toggleClass('term-selected');
		updateSelectedTerms();
	});
	
	if (o.initSelectedTerms && o.initSelectedTerms.length > 0) {
		console.log('%s: initSelectedTerms: %o', o.name, o.initSelectedTerms);
		o.initSelectedTerms.forEach(t => {
			let termKey = getTermKey(t.label, t.queryKey),
				$selectedTermLi = $(
					'<li class="term-selected" data-term-key="' + termKey + '"' + 
					(t.queryKey ? (' data-query-key="' + t.queryKey + '"') : '') +
					(t.queryValue ? (' data-query-value="' + t.queryValue + '"') : '') +
					'><span>' + t.label + '</span></li>');
			$selected.append($selectedTermLi);			
		});
		$ui.addClass('has-selected');	
		updateQueryAndListeners();
	}		

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

freq = function(r) {
	let f = r.freqMax;

	if (f >= 80) {
		fc = 'fr-80';
	} else if (f >= 50) {
		fc = 'fr-50';
	} else if (f >= 20) {
		fc = 'fr-20';
	} else if (f >= 10) {
		fc = 'fr-10';
	} else if (f >= 1) {
		fc = 'fr-01';
	} else {
		fc = 'fr-0';
	}

	return '<p class="fr ' + fc + '">' + r.freqAll + '</p>';
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
		console.log('ref: %o', r);
		h += '<p>' + r.referenceID.length + '&nbsp;Reference' + (r.referenceID.length == 1 ? '' : 's');
		h += ': ' + r.referenceID.map((a, i) => '<a href="' + baseUrl +
			'/referenceDetails.do?accId=' + a + '" target="_blank">' + r.citation[i] + '</a>').join('&nbsp;&nbsp;&sdot;&nbsp;&nbsp;') + '</p>';		
	}
	
	if (r.metsTo) {
		h += '<p>Sites of Metastasis: ' + r.metsTo.join(', ') + '</p>';			
	}
	
	if (r.pathologyImages) {
/*
		h += '<p><a href="' + baseUrl +
			'/pathologyImageSearchResults.do?tfKeys=' + fk +'" target="_blank">' +
			r.pathologyImages + ' Pathology Image' + (r.pathologyImages == 1 ? '' : 's') + '</a></p>';
*/
		h += '<p>' + r.pathologyImages + ' Pathology Image' + (r.pathologyImages == 1 ? '' : 's') + '</p>';
	}

	if (r.cytoImages) {		
/*
		h += '<p><a href="' + baseUrl +
			'/tumorFrequencyDetails.do?page=cytogenetics&key=' + r.cytoImages +'" target="_blank">' +
			r.cytoCount + ' Cytogenetic Image' + (r.cytoCount == 1 ? '' : 's') + '</a></p>';	
*/
		h += '<p>' + r.cytoCount + ' Cytogenetic Image' + (r.cytoCount == 1 ? '' : 's') + '</p>';		
	}
	

	if (r.geneExpression) {
		h += '<p>Gene Expression Data</p>';
	}


	return h;	
};

addRow = function(i, r) {
	
	let $r = $('<tr>'),
		mu = modelUrl(r),
		$name = cell(r, r => {
			return r.organOrigin + ' ' + r.tumorClassification;
		}),
		$organ = cell(r.organAffected, a => {
			if (a !== r.organOrigin) {
				$table.addClass('has-organ-affected');
				return a;
			}
			return '';
		}),
		$agent = cell(r.agent, a => a.join(', ')),
		$strain = cell(r, r => '<a href="strainDetails.do?key=' + r.strainKey + '" target="_blank">' + r.strain + '</a>' + r.strainType.map(t => '<em>' + t + '</em>').join('')),
		$freqA = cell(r, freq),
		$info = cell(r, info),
		$details = cell(r, r => '<a href="' + mu + '" target="_blank"><i class="mo"></i></a>');

		$r.append($name).append($organ).append($agent).append($strain)
			.append($freqA)
			.append($info).append($details);

	$rows.append($r);

};

$(function() {
	
	let $w = $(window),
		$body = $('body'),
		$bodyHeader = $('body > header'),
		headerHeight = 102,
		$collapseAll = $('#collapse-all');
	
	$w.on('scroll', function () {
		$body.toggleClass('scrolled', $w.scrollTop() > headerHeight);
	});
	
	$w.on('resize', function() {
		headerHeight = $bodyHeader.height();
		resizeFacetUi(true);	
	});	
	
	$facetUi = $('#facet-ui');	
	$facets = $('#facets');
	$table = $('#facet-results');
	$rows = $('#facet-results tbody');
	$first = $('#result-first');
	$last = $('#result-last');
	$total = $('#result-total');
	
	$collapseAll.on('click', function() {
		hasAllCollapsed = !hasAllCollapsed;
		
		if (!hasAllCollapsed) {
			resizeFacetUi(true);
			$collapseAll.html('<i class="fa fa-minus"></i>Collapse All');
		} else {
			// console.log('recentForcedCollapse: %o', recentForcedCollapse);
			recentExpanded.forEach(n => {
				facets[n].forceCollapse();
			});
			$collapseAll.html('<i class="fa fa-plus"></i>Expand');
		}
		
		
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
