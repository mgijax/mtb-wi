<%@ page language="java" pageEncoding="UTF-8" session="false"%>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>

<jax:mmhcpage title="Faceted Search" help="#">
	<jsp:attribute name="head">
	<style type="text/css">

.facet{
	margin-left: 5px;
		white-space: nowrap;
			color: blue;
				text-decoration: underline;
					cursor: pointer;}

.facetBox{
	width: 300px;}

.facetList{
	height: 150px; 
		width: 300px; 
			overflow:auto; 
				border: 1px solid black;
					margin: 0px;
						padding: 0px;}

.facetLabel{
	font-weight: bold;
		float:left;}

.moreFacets{
	float: right;
		color: blue;
			text-decoration: underline;
				cursor: pointer;}

.fakeLink{
	color: blue;
		text-decoration: underline;
			cursor: pointer;}

.removeFilter{
	color: red;
		text-decoration: underline;
			cursor: pointer;}

.clear{
	clear:both;}

.type{
	font-size: 0.8em;
		font-style: italic;}

th{
	font-size: 12px;
		font-family: Arial,Helvetica;
			vertical-align: middle;
				color: #000001;
					background-color: #D0E0F0;
						font-weight: bold;
							text-align: center; }

table{
	border:0;
		padding:0;
			border-collapse:collapse}

td{
	border:0;
		padding:1px;
			font-family: Verdana,Arial,Helvetica;
				font-size: 12px; }

td.cell{
	border:1px solid black;
		padding:1px;
			font-family: Verdana,Arial,Helvetica;
				font-size: 12px;
					text-align: center;}

td.cellNW{
	border:1px solid black;
		padding:1px;
			font-family: Verdana,Arial,Helvetica;
				font-size: 12px; 
					white-space: nowrap; }

td.freq{
	text-align:center;
		border:1px solid black;
			padding:0;
				font-family: Verdana,Arial,Helvetica;
					font-size: 12px; }

td.high{
	padding: 0px;
		color: white;
			background-image: url(${applicationScope.urlImageDir}/high.png);}

td.veryhigh{
	padding: 0px;
		color: white;
			background-image: url(${applicationScope.urlImageDir}/veryhigh.png);}

td.moderate{
	padding: 0px;
		background-image: url(${applicationScope.urlImageDir}/moderate.png);}

td.low{
	padding: 0px;
		background-image: url(${applicationScope.urlImageDir}/low.png);}

td.verylow{
	padding: 0px;
		background-image: url(${applicationScope.urlImageDir}/verylow.png);}

td.observed{
	padding: 0px;
		background-image: url(${applicationScope.urlImageDir}/observed.png);}

.high{
	width: 100%;
		padding: 0px;
			color: white;
				background-image: url(${applicationScope.urlImageDir}/high.png);}

.veryhigh{
	width: 100%;
		padding: 0px;
			color: white;
				background-image: url(${applicationScope.urlImageDir}/veryhigh.png);}

.moderate{
	width: 100%;
		padding: 0px;
			background-image: url(${applicationScope.urlImageDir}/moderate.png);}

.low{
	width: 100%;
		padding: 0px;
			background-image: url(${applicationScope.urlImageDir}/low.png);}

.verylow{
	width: 100%;
		padding: 0px;
			background-image: url(${applicationScope.urlImageDir}/verylow.png);}

.observed{
	width: 100%;
		padding: 0px;
			background-image: url(${applicationScope.urlImageDir}/observed.png);}

img{
	vertical-align: middle; }
	</style>
	<script type="text/javascript">
		(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
			(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
				m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m
					)
						})(window,document,'script','//www.google-analytics.com/analytics.js','ga');

ga('create', '${applicationScope.googleID}', 'auto');
	ga('send', 'pageview');
	</script>
	<script type="text/javascript" src="${applicationScope.urlBase}/js/overlib.js"></script>
	<script type="text/javascript" src="${applicationScope.urlJavaScript}"></script>
	<script type="text/javascript">

var	rsp;
						var	f_field=['organParent','agentType','tcParent','strainType','metsTo','strainMarker','humanTissue'];
						var	f_field_display=['Organ of Origin','Agent Type','Tumor Classification','Strain Type','Mets. To','Germline Mutant Alleles','Human Tissue Model'];
						var	sortCols = ['organOrigin','organAffected','strain','freqNum'];
						var	filters =[];
						var	displayFilters=[];
						var	url = "/mtbwi/solrQuery.do";
						var	resLimit = 25; // normally 25
						var	facetLimit = 25;
						var	fs = 0;
						var	facetSortParam = ["count","index"];
						var	facetSortDisp = ["term","count"];
						var	start = 0;
						var	sort = "organOrigin";	// formerly tcParent
						var	ad = 0;
						var	ascdesc=["asc","desc"];
						// false means don't require images
						var	cytoImages = false;
						var	pathologyImages = false;
						var	untreated = false;
						var	metastatic = false;
						var	geneExpression = false;
						var	asCSV = false;
						var	minFC = false;
						var	mutants="";
						// runs in mtb
						var	mtbURL = "";

//this is awesome
	var legend = '&lt;table border=&quot;0&quot;&gt;&lt;tr&gt;&lt;td&gt;&lt;img src=&quot;${applicationScope.urlImageDir}/veryhigh.png&quot; alt=&quot;VH&quot;&gt;&lt;/td&gt;&lt;td&gt;Very High (&gt;80%)&lt;/td&gt;&lt;/tr&gt;'+
		'&lt;tr&gt;&lt;td&gt;&lt;img src=&quot;${applicationScope.urlImageDir}/high.png&quot; alt=&quot;HI&quot;&gt;&lt;/td&gt;&lt;td&gt;High (&gt;50%)&lt;/td&gt;&lt;/tr&gt;'+
			'&lt;tr&gt;&lt;td&gt;&lt;img src=&quot;${applicationScope.urlImageDir}/moderate.png&quot; alt=&quot;MO&quot;&gt;&lt;/td&gt;&lt;td&gt;Moderate (&gt;20%)&lt;/td&gt;&lt;/tr&gt;'+
				'&lt;tr&gt;&lt;td&gt;&lt;img src=&quot;${applicationScope.urlImageDir}/low.png&quot; alt=&quot;LO&quot;&gt;&lt;/td&gt;&lt;td&gt;Low (&gt;10%)&lt;/td&gt;&lt;/tr&gt;'+
					'&lt;tr&gt;&lt;td&gt;&lt;img src=&quot;${applicationScope.urlImageDir}/verylow.png&quot; alt=&quot;VL&quot;&gt;&lt;/td&gt;&lt;td&gt;Very Low (&gt;0.10%)&lt;/td&gt;&lt;/tr&gt;'+
						'&lt;tr&gt;&lt;td&gt;&lt;img src=&quot;${applicationScope.urlImageDir}/observed.png&quot; alt=&quot;OB&quot;&gt;&lt;/td&gt;&lt;td&gt;Observed (&gt;0%)&lt;/td&gt;&lt;/tr&gt;'+
							'&lt;tr&gt;&lt;td bgcolor=&quot;#ffffff&quot; width=&quot;20&quot;&gt;&nbsp;&lt;/td&gt;&lt;td &quot;&gt;Zero&lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;';

// derived from http://www.degraeve.com/reference/simple-ajax-example.php

function onLoad(){	

if(window.location.search){

updatePage(document.location.search.substring(1));

// this should only get called when the page loads w/ a query string
	// or on popstate
		queryToUI(document.location.search.substring(1))
			}else{
				updatePage();
					}

}

window.onpopstate = function(event) {	
	try{
		if(event.state.faceted){
			 window.location.reload(); 
				}else{
					window.history.back();	// maybe we don't need this just let the browser work?
								}
								}catch(err){
									window.history.back();
								}

};

// after a change to a checkbox start from the first result
	function updatePageFromZero(){
		start = 0;
			updatePage();
				}

function updatePage(qStr){
	doXMLReq(qStr)
		// really don't want this to happen after moreFacets()
			window.scrollTo(0,0);
				}

function updatePageNoScroll(qStr){
	doXMLReq(qStr)
		}

function doXMLReq(qStr) {

var xmlHttpReq = false;
	var self = this;
		if (window.XMLHttpRequest) { // Mozilla/Safari
			self.xmlHttpReq = new XMLHttpRequest(); 
				}
					else if (window.ActiveXObject) { // IE
						self.xmlHttpReq = new ActiveXObject("Microsoft.XMLHTTP");
							}
								self.xmlHttpReq.open('POST', url , true);
								self.xmlHttpReq.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
								self.xmlHttpReq.onreadystatechange = function() {
									if (self.xmlHttpReq.readyState == 4) {
										parseResponse(self.xmlHttpReq.responseText);
										}
								}

// from UI action
	if(typeof qStr == "undefined" || qStr == null ){

qStr = getQueryString();
	try{
		window.history.pushState({faceted:1},"","?"+qStr);
			}catch(error){
				// no html 5
					}

}

self.xmlHttpReq.send(getStandardArgs().join('&')+'&'+qStr);

}

// make an attempt to break this up so all the static stuff doesn't goin the url
	function getStandardArgs() {
		var params = [
			'wt=json'
				, 'indent=on'
					, 'facet=true'
						, 'facet.field=organParent'
							, 'facet.field=organOrigin'
								, 'facet.field=agentType'
									, 'facet.field=tcParent'
										, 'facet.field=tumorClassification'
										, 'facet.field=strainType'
										, 'facet.field=metsTo'
										, 'facet.field=tumorMarker'
										, 'facet.field=strainMarker'
										, 'facet.field=humanTissue'
										, 'facet.limit='+facetLimit
										, 'facet.sort='+facetSortParam[fs]
										, 'facet.mincount=1'
										, 'sort='+sort+'%20'+ascdesc[ad]
										, 'q=*:*'
										, 'rows='+resLimit

// can do this fq=freqNum:[60 TO 100]
	// and this fq=minFC:[1 TO 1]
		// and this fq=freqF:[* TO *]&fq=freqM:[* TO *]
			];

return params;
	}

function getQueryString() {

try{
	start = parseInt(start);
		if(isNaN(start)	|| start < 0){
												start = 0;
										}

}catch(err){
	start = 0;
		}
			var query="start="+start;

for(var i=0;i<filters.length;i++){
	query +="&fq="+myEscape(filters[i]);
		}
			if(cytoImages){
				query += "&fq=cytoImages:[* TO *]";
					}
						if(pathologyImages){
							query += "&fq=pathologyImages:[* TO *]";
								}
								if(untreated){
									query += "&fq=-agent:[* TO *]";
								}
								if(metastatic){
									query += "&fq=metastatic:true";
								}
								if(geneExpression){
									query += "&fq=geneExpression:true";
								}
								if(minFC){
									query += "&fq=minFC:[1 TO 1]";
								}
								query += mutants;

return query;

}

function queryToUI(queryStr){

// for symmetry
	queryStr = '&'+queryStr;

if(queryStr.indexOf("geneExpression") != -1){
	geneExpression = document.getElementById("gene-expression").checked = true;
		}else{
			geneExpression = document.getElementById("gene-expression").checked = false;
				}

if(queryStr.indexOf("pathologyImages") != -1){
	document.getElementById("pathology-images").checked = true;
		}else{
			document.getElementById("pathology-images").checked = false;
				}

if(queryStr.indexOf("cytoImages") != -1){
	cytoImages = document.getElementById("cyto-images").checked = true;
		}else{
			cytoImages = document.getElementById("cyto-images").checked = false;	
				}

if(queryStr.indexOf("-agent") != -1){
	untreated = document.getElementById("untreated").checked = true;
		}else{
			untreated = document.getElementById("untreated").checked = false;	
				}

if(queryStr.indexOf("metastatic") != -1){
	metastatic = document.getElementById("metastatic").checked = true;
		}else{
			metastatic = document.getElementById("metastatic").checked = false;
				}

if(queryStr.indexOf("minFC") != -1){
	minFC = document.getElementById("minFC").checked = true;
		}else{
			minFC = document.getElementById("minFC").checked = false;
				}

if(queryStr.indexOf("mutant") != -1){
	if(queryStr.indexOf("mutant:true") != -1){
		mutantCheck("m",false);
			mutants = "&fq=mutant:true";
				}else{
					mutantCheck("n",false);
						mutants = "&fq=mutant:false";
							}
								}else{
									mutantCheck("a",false);
										mutants = "";
								}

try{
	startStr = queryStr.substring(queryStr.indexOf("start=")+6);
		// something a little more clever is needed here
			var end = startStr.search(/\D/)
				if(end == -1){
					end = startStr.length;
						}

startStr = startStr.substring(0, end)

start = parseInt(startStr);
	if(isNaN(start)){
		start = 0;
			}
				}catch(err){
					start = 0;
						}

// sort for links from human model grid
	if(queryStr.substring("sort=hm") != -1){
		// sort on frequency desc
			ad = 1;
				sort = sortCols[3];
					}

//now deal with the filterlist
	// need special code for organOrigin <--> TumorClassification / organParent <--> tcParent

var f_field_temp = f_field.concat(["organOrigin","tumorClassification"]);
	var f_field_display_temp = f_field_display.concat(["Organ of Origin", "Tumor Classification"]);

filters = [];
	displayFilters = [];
		queryStr = queryStr.substring(queryStr.indexOf("&fq="));
			queryStr = queryStr.replace(new RegExp('%3A','g'),'=');
				queryStr = queryStr.replace(new RegExp('%22','g'),'');
					queryStr = queryStr.replace(new RegExp('\\+','g'),' ');
						queryStr = queryStr.replace(new RegExp('%28','g'),'(');
							queryStr = queryStr.replace(new RegExp('%29','g'),')');
								fqs = queryStr.split("&fq=");

for(i=0; i< fqs.length; i++){

fq = fqs[i];
	fq= fq.split("=");
		for(j=0; j<f_field_temp.length; j++){
			if(f_field_temp[j] == fq[0]){
				if(j == 0){
					f_field[0]="organOrigin";
						}
							if(j == 2){
								f_field[2]="tumorClassification";
									}
										filters.push(fq[0]+"="+fq[1].replace('"',''));
											displayFilters.push(f_field_display_temp[j]+"="+fq[1].replace('"',''));
												}
										}
								}	 
						}

function myEscape(filter){
	var parts = filter.split("=");
		var vals =parts[1].split(" ");

if(vals.length > 1){
	parts[1] = '"'+vals.join("+")+'"';
		}
			return escape(parts[0]+":"+parts[1]);
				}

function facetSearch(f,i){
	var type = f_field[f];
		var fDisplay = f_field_display[f];
			var val = rsp.facet_counts.facet_fields[type][--i];
				if(filters.indexOf(type+"="+val) == -1){
					filters.push(type+"="+val);
						displayFilters.push(fDisplay+'='+val);

start = 0;
	if(f==0){
		f_field[0]="organOrigin";
			}
				if(f==2){
					f_field[2]="tumorClassification";

}
	updatePage();
		}
			}

function showFilters(){
	document.getElementById("filters").innerHTML="";
		for(var i=0; i< displayFilters.length; i++){
			document.getElementById("filters").innerHTML += 
				"<span>"+displayFilters[i]+"&nbsp;&nbsp;<span class='remove-filter' onclick='removeFilter("+i+")'>&nbsp;x&nbsp;</span></span>
<!-- \n -->
";
	}
		}

function facetSort(){
	fs =(fs+1)%2;
		updatePage();
			}

function showFacetCount(){
	var showWhat = "show all facets";
		if(facetLimit == -1){
			document.getElementById("facet-count").innerHTML =
				"Displaying <strong>all</strong> facets. <span class='fake-link' onClick='moreFacets();'>Reset to top 25</span>.
<!-- \n -->
";
	showWhat = "show top 25 facets";
		}else{
			document.getElementById("facet-count").innerHTML =
				 "Displaying top <strong>25</strong> facets. <span class='fake-link' onClick='moreFacets();'>Show All</span>.
<!-- \n -->
";

}
	document.getElementById("facet-count").innerHTML += 
		"<span	onclick='facetSort();'>Facets sorted by <strong>"+facetSortDisp[(fs+1)%2]+"</strong>. (Sort by <span class='fake-link'><strong>"+facetSortDisp[fs]+"</strong></span>)</span>.";

try{
	var moreF = document.getElementsByClassName("more-facets");
		for(var i = 0; i < moreF.length; i++){
			moreF[i].innerHTML = showWhat;
				}
					}catch(err){
						// older IE
							var moreF = document.querySelectorAll('.moreFacets');
								for(var i = 0; i < moreF.length; i++){
									moreF[i].innerHTML = showWhat;
										}
								}
						}

function removeFilter(i){
	if(filters[i].indexOf("tcParent") != -1){
		f_field[2] = "tcParent";
			}
				if(filters[i].indexOf("organParent") != -1){
					f_field[0] = "organParent";
						}
							filters.splice(i,1);
								displayFilters.splice(i,1);
								start = 0;

updatePage();
	}

// this function does all the work of parsing the solr response and updating the page.
	function parseResponse(str){
		showFilters();
			showFacetCount();
				//				document.getElementById("raw").innerHTML = str;
								rsp = eval("("+str+")"); // use eval to parse Solr's JSON response
								//var html= "
<!-- \n -->
numFound=" + rsp.response.numFound;
	for(var f = 0; f < f_field.length; f++){
		var html = "";
			for(var i = 0; i < rsp.facet_counts.facet_fields[f_field[f]].length; i++){
				var type = rsp.facet_counts.facet_fields[f_field[f]][i++];
					var val = rsp.facet_counts.facet_fields[f_field[f]][i]; 
						if(val != 0){
							html += "<span class='facet' onClick='facetSearch("+f+","+i+")'>"+type+"&nbsp;("+val+")</span>
<!-- \n -->
";
	}
		} 
			//hack?
				if(f==0){
					document.getElementById("organ-parent").innerHTML=html;
						}else if(f==2){
							document.getElementById("tc-parent").innerHTML=html;
								}else{
									document.getElementById(f_field[f]).innerHTML=html;
										}
								} 
								if(asCSV){
									showCSVResults();
								}else{
									showResults();
								}

}

function colSort(col){
	nd();	 // hides frequency legend (see overlib.js)
								if(sort == sortCols[col]){
									ad = (ad+1)%2;
								}
								sort = sortCols[col];
								updatePage();
						}

function getSortImage(col){
	if(sort == sortCols[col]){
		if(ad == 1){
			return "${applicationScope.urlImageDir}/sortableDown.gif";
				}else{
					return "${applicationScope.urlImageDir}/sortableUp.gif";
						}
							}else{
								return "${applicationScope.urlImageDir}/sortable.gif";
								}
						}

function showResults(){
	var resCount = rsp.response.numFound;
		var pagination = "<div style='text-align: center;'>";
			if(resCount <= resLimit){
				pagination += "Displaying all "+resCount+" results
<!-- \n -->
";
	}else{
		if(start > 0){
			pagination += "<span class='fake-link' onClick='lessResults()'><--&nbsp;</span>";
				}
					to = start + resLimit;
						if(to > resCount){
							to = resCount;
								}
									pagination += "Displaying "+(start+1)+" to " +to+" of "+resCount+" results &nbsp;";
										if(start + resLimit < resCount){
											pagination += "<span class='fake-link' onClick='moreResults("+resCount+")'>--></span></br>";
										}
								}

pagination += "</div>";
	var html = pagination;
		html += "
<!-- \n -->
<table style='border-collapse: collapse;' border='1'>";
	html += "<tr><th colspan=4>Tumor Model</th><th colspan=3>Model Details</th></tr>";
		html += "<tr><th onclick='colSort(0)'>Tumor Name <img src='"+getSortImage(0)+"'></th>";
			html += "<th width='120' onclick='colSort(1)'>Organ Affected <img src='"+getSortImage(1)+"'></th>";
				html += "<th >Treatment Type
<!-- \n -->
<span class='type'>Agents</span></th>";
	html += "<th onclick='colSort(2)'>Strain Name <img src='"+getSortImage(2)+"'>
<!-- \n -->
<span class='type'>Strain Types</span></th>";
	html += "<th onclick='colSort(3)' onmouseover='return overlib(`"+legend+"`, CAPTION, `Frequency Color Legend`);' onmouseout='return nd();'> Reported Frequency (sex) <img src='"+getSortImage(3)+"'>"
		html += "</th><th>Metastasizes
<!-- \n -->
To</th>";
	html += "<th>Additional Info.</th></tr>";

for(var i=0; i < rsp.response.docs.length; i++){
	var doc = rsp.response.docs[i];

var tfKeys="";

for(var j=0; j < doc.tumorFrequencyKey.length; j++){
	if(j>0){
		tfKeys += ",";
			}
				tfKeys += doc.tumorFrequencyKey[j];
					}

html += "<tr>";
	html += "<td class='cell'>"+doc.organOrigin+" "+doc.tumorClassification+"</td>";
		html += "<td class='cell'>"+doc.organAffected+"</td>";
			if(doc.hasOwnProperty("agentType")){
				html += "<td class='cell'>";
					for(var j=0; j < doc.agentType.length; j++){
						html += doc.agentType[j]+"
<!-- \n -->
";
	}
		if(doc.hasOwnProperty("agent")){
			for(var j=0; j < doc.agent.length; j++){
				html +="<span class='type'>"+ doc.agent[j]+"</span>
<!-- \n -->
";
	}
		}
			html +="</td>";
				}else{
					html += "<td class='cell'></td>"; 
						}
							html += "<td class='cell'>"+doc.strain+"
<!-- \n -->
";
	for(var j=0; j < doc.strainType.length; j++){
		html += "<span class='type'>"+doc.strainType[j]+"</span>
<!-- \n -->
";
	}

html += "</td>";
	html += freqsToString(doc);
		if(doc.hasOwnProperty("metsTo")){
			html += "<td class='cell'>";
				for(var j=0; j < doc.metsTo.length; j++){
					html += doc.metsTo[j]+"
<!-- \n -->
";
	}
		html += "</td>";
			}else{
				html += "<td class='cell'></td>";
					}
						html += "<td class='cell-n-w'>"

if(doc.hasOwnProperty("reference")){
	if(doc.reference.length == 1){
		html += doc.reference.length+' Reference
<!-- \n -->
'
	}else{
		html += doc.reference.length+' References
<!-- \n -->
'
	}
		for(var j=0; j < doc.reference.length; j++){
			html +="&nbsp;&nbsp;&nbsp;<a href='/mtbwi/referenceDetails.do?accId="+ doc.reference[j]+"' target='_blank'>";
				html += doc.reference[j]+"</a>
<!-- \n -->
";
	}
		}

if(doc.hasOwnProperty("pathologyImages")){

html +="&nbsp;<a href='/mtbwi/pathologyImageSearchResults.do?tfKeys="+tfKeys+"' target='_blank'>";
	if(doc.pathologyImages == 1){
		html += doc.pathologyImages+" Pathology Image</a>
<!-- \n -->
";	 
												}else{
													html += doc.pathologyImages+" Pathology Images</a>
<!-- \n -->
";
	}
		}

if(doc.hasOwnProperty("cytoImages")){
	html +="&nbsp;<a href='/mtbwi/tumorFrequencyDetails.do?page=cytogenetics&key="+doc.cytoImages+"' target='_blank'>";
		if(doc.cytoCount== 1){
			html += "1 Cytogenetic Image</a>
<!-- \n -->
";
	}else{
		html += doc.cytoCount+" Cytogenetic Images</a>
<!-- \n -->
";
	}
		}
			if(doc.geneExpression){

html +="&nbsp;<a href='/mtbwi/geneExpressionSearchResults.do?tfKeys="+tfKeys+"' target='_blank'>";
	html += "Gene Expression Data</a>
<!-- \n -->
";

}

html += "
<!-- \n -->
<a href='/mtbwi/tumorSummary.do?tumorFrequencyKeys="+tfKeys+"' target='_blank'>";
	html += "Model Summary</a>
<!-- \n -->
";
	html += "</td></tr>";

}
	html += "</table>
<!-- \n -->
"+pagination;
	document.getElementById("results").innerHTML=html;

}

function showCSVResults(){
	var html ="Tumor Type, Organ Affected , Agent<:Treatment>, Strain:Type, Frequencies, Mets. To, References, Pathology Images, Cyto Images, Gene Expression , Summary";
		html +="
<!-- \n -->
";

for(var i=0; i < rsp.response.docs.length; i++){
	var doc = rsp.response.docs[i];
		var tfKeys="";
			for(var j=0; j < doc.tumorFrequencyKey.length; j++){
				if(j>0){
					tfKeys += ",";
						}
							tfKeys += doc.tumorFrequencyKey[j];
								}

html += "'"+doc.organOrigin+" "+doc.tumorClassification+"',";
	html += "'"+doc.organAffected+"',";
		if(doc.hasOwnProperty("agentType")){
			html += "'";
				for(var j=0; j < doc.agentType.length; j++){
					html += doc.agentType[j]+"";
						}
							if(doc.hasOwnProperty("agent")){
								html += ":"
									for(var j=0; j < doc.agent.length; j++){
										if(j>0){
											html += ",";
												}
													html += doc.agent[j];
														}
												}
												html +="',";
										}else{
											html += "'',"; 
										}
										html += "'"+doc.strain+":";
										for(var j=0; j < doc.strainType.length; j++){
											if(j>0){
												html += ",";
													}
												html += doc.strainType[j];
										}
										html += "',";
										html += freqsToCSVString(doc);

if(doc.hasOwnProperty("metsTo")){
	html += "'";
		for(var j=0; j < doc.metsTo.length; j++){
			if(j>0){
				html += ",";
					}
						html += doc.metsTo[j];
							}
								html += "'";
									}else{
										html += "''";
										}
										html += ",'"

if(doc.hasOwnProperty("reference")){	 
												for(var j=0; j < doc.reference.length; j++){
													if(j>0){
														html += ", ";
															}
														html +=doc.reference[j];
												}
										}
										html +="',";
										if(doc.hasOwnProperty("pathologyImages")){
											html +="'http://tumor.informatics.jax.org/mtbwi/pathologyImageSearchResults.do?tfKeys="+tfKeys+"',";
										}else{
											html +="'',"
										}
										if(doc.hasOwnProperty("cytoImages")){
											html +="'http://tumor.informatics.jax.org/mtbwi/tumorFrequencyDetails.do?page=cytogenetics&key="+doc.cytoImages+"',";	 
										}else{
											html +="'',"
										}

if(doc.geneExpression){
	html +="'http://tumor.informatics.jax.org/mtbwi/geneExpressionSearchResults.do?tfKeys="+tfKeys+"',";
		}else{
			html +="'',"
				}
					html += "'http://tumor.informatics.jax.org/mtbwi/tumorSummary.do?tumorFrequencyKeys="+tfKeys+"'";
						html +="
<!-- \n -->
";
	html = html.replace(new RegExp("'",'g'),'"');
		}

document.getElementById("results").innerHTML=html;

}

function getFeqStyle(freqStr){
	var strRet = "";
		freqStr = freqStr.replace("=","");
			var parts = freqStr.split(/-|~|>|</);
				if(parts.length > 1){
					freqStr = parts[1];
						}
							try{
								freqStr = freqStr.trim();
								}catch(e){
									// ie=<8
										freqStr = freqStr.replace(/ /g,'');
								}
								var freq = parseFloat(freqStr);

if(freqStr == "very high"){
	strRet = "veryhigh";
		}else if(freqStr == "high"){
			strRet = "high";
				}else if(freqStr == "moderate"){
					strRet = "moderate";
						}else if(freqStr == "low"){
							strRet = "low";
								}else if(freqStr == "very low"){
									strRet = "verylow";
								}else if(freqStr == "observed"){
									strRet = "observed";
								}else if(freq > 80.0){ 
									strRet = "veryhigh";
								}else if(freq > 50.0){
									strRet = "high";
								}else if(freq > 20.0){
									strRet = "moderate";
								}else if(freq > 10.0){
									strRet = "low";
								}else if(freq > 0.10){
									strRet = "verylow";
								}else if(freq > 0){
									strRet = "observed";
								}else{
									strRet = "";
								}
								return strRet
						}

function freqsToString(doc){
	var str ="<td class='freq'><table>";
		if(doc.hasOwnProperty("freqF")){
			str += "<tr><td><div class='"+getFeqStyle(doc.freqF)+"'>";
				str += doc.freqF
					str += "&nbsp;(Female)</div></td></tr>";
						}

if(doc.hasOwnProperty("freqM")){
	str += "<tr><td><div class='"+getFeqStyle(doc.freqM)+"'>";
		str += doc.freqM;
			str += "&nbsp;(Male)</div></td></tr>";
				}

if(doc.hasOwnProperty("freqX")){
	str += "<tr><td><div class='"+getFeqStyle(doc.freqX)+"'>";
		str += doc.freqX;
			str += "&nbsp;(Mixed)</div></td></tr>";
				}

if(doc.hasOwnProperty("freqU")){
	str += "<tr><td><div class='"+getFeqStyle(doc.freqU)+"'>";
		str += doc.freqU;
			str += "&nbsp;(Unknown)</div></td></tr>";
				}
					str += "</table></td>";

return str;
	}

function freqsToCSVString(doc){
	str = "'";
		if(doc.hasOwnProperty("freqF")){
			str += doc.freqF
				str += " (Female)";
					}

if(doc.hasOwnProperty("freqM")){

str += doc.freqM;
	str += "(Male)";
		}

if(doc.hasOwnProperty("freqX")){

str += doc.freqX;
	str += "(Mixed)";
		}

if(doc.hasOwnProperty("freqU")){

str += doc.freqU;
	str += " (Unknown)";
		}
			str += "',";

return str;
	}

function moreFacets(){
	if(facetLimit != 25){
		facetLimit = 25;
			}else{
				facetLimit = -1;
					try{
						 var moreF = document.getElementsByClassName("more-facets");
							for(var i = 0; i < moreF.length; i++){
								moreF[i].innerHTML = "Loading ...";
									}
										}catch(err){
											 // older IE
											 var moreF = document.querySelectorAll(".moreFacets");
												for(var i = 0; i < moreF.length; i++){
													moreF[i].innerHTML = "Loading ...";
												} 
										}
								}
								updatePageNoScroll();
						}

function moreResults(max){
	start += resLimit;
		if(start >= max - resLimit){
			//	start = max - resLimit;
								}
								updatePage();
						}

function lessResults(){
	start -= resLimit;
		if(start<0){
			start = 0;
				}
					updatePage();
						}

function pathologyImagesCB(){
	pathologyImages = document.getElementById("pathology-images").checked;
		updatePageFromZero();
			}
				function cytoImagesCB(){
					cytoImages = document.getElementById("cyto-images").checked;
						updatePageFromZero();
						}
						function untreatedCB(){
							untreated = document.getElementById("untreated").checked;
								updatePageFromZero();
						}
						function metastaticCB(){
							metastatic = document.getElementById("metastatic").checked;
								updatePageFromZero();
						}
						function geneExpressionCB(){
							geneExpression = document.getElementById("gene-expression").checked;
								updatePageFromZero();
						}
						function minFCCB(){
							minFC = document.getElementById("minFC").checked;
								updatePageFromZero();
						}
						function asCSVCB(){
							asCSV = document.getElementById("asCSV").checked;
								if(asCSV){
									resLimit = 1000;
								}else{
									resLimit = 25;
								}
								updatePageFromZero();
						}

function mutantCheck(name,search){

all = document.getElementById("all-strains");
	mutant = document.getElementById("mutant-strains");
		nMutant =document.getElementById("nonMutantStrains");

if(name=="a"){
	all.checked = true;
		mutant.checked = false;
			nMutant.checked = false;
				}
					if(name=="m"){
						all.checked = false;
							mutant.checked = true;
								nMutant.checked = false;
								}
								if(name=="n"){
									all.checked = false;
										mutant.checked = false;
											nMutant.checked = true;
								}
								if(search){

mutants = "";

if(mutant.checked){
	mutants = "&fq=mutant:true"
		}
			if(nMutant.checked){
				mutants = "&fq=mutant:false"
					}

updatePageFromZero();
	}

}
	</script>

</jsp:attribute>

				<table>

<tr>
	<td>

<table>
	<tr>
		<td>
			<a href="index.do"><img src="${applicationScope.urlImageDir}/mtb_logo_side.png" alt="Mouse Tumor Biology Database (MTB)"></a>

<!-- \n -->

<a href="http://www.informatics.jax.org/mgihome/support/mgi_inbox.shtml">Feedback welcome</a>.
	</td>
		</tr>
			</table>

<!-- \n -->

<strong>Require in results:</strong>
<!-- \n -->

<input type="checkbox" id="pathology-images" onClick="pathologyImagesCB()">Pathology Images
<!-- \n -->

<input type="checkbox" id="cyto-images" onClick="cytoImagesCB()">Cytogenetic Images
<!-- \n -->

<input type="checkbox" id="untreated" onClick="untreatedCB()">Spontaneous
<!-- \n -->

<input type="checkbox" id="metastatic" onClick="metastaticCB()">Metastatic
<!-- \n -->

<input type="checkbox" id="gene-expression" onClick="geneExpressionCB()">Gene Expression Data
<!-- \n -->

<input type="checkbox" id="min-f-c" onClick="minFCCB()">Freq. >= 80% C. size >= 20
<!-- \n -->

<input type="checkbox" id="all-strains" onclick="mutantCheck('a',true)" checked >All Strains
<!-- \n -->

<input type="checkbox" id="mutant-strains" onclick="mutantCheck('m',true)">Mutant Strains</br>
	<input type="checkbox" id="non-mutant-strains" onclick="mutantCheck('n',true)">Non-Mutant Strains</br>
		<input type="checkbox" id="as-c-sV" onClick="asCSVCB()">Results as CSV
<!-- \n -->

<!-- \n -->

<strong>Active Filters:</strong>
	<div id="filters"></div>
<!-- \n -->

<div id="facet-count"></div>
	<div class="facet-box">
		<span class="facet-label">Organ of Origin</span>
			<div class="clear"></div>
				</div>
					<div class="facet-list" id="organ-parent"></div>
						<div onclick='moreFacets()' class="more-facets" ></div>

<!-- \n -->

<div class="facet-box">
	<span class="facet-label">Tumor Classification</span>
		<div class="clear"></div>
			</div>
				<div class="facet-list" id="tc-parent"></div>
					<div onclick='moreFacets()' class="more-facets" ></div>

<!-- \n -->

<div class="facet-box">
	<span class="facet-label">Agent Type</span>
		<div class="clear"></div>
			</div>
				<div class="facet-list" id="agent-type"></div>
					<div onclick='moreFacets()' class="more-facets" ></div>

<!-- \n -->

<div class="facet-box">
	<span class="facet-label">Strain Type</span>
		<div class="clear"></div>
			</div>
				<div class="facet-list" id="strain-type"></div>
					<div onclick='moreFacets()' class="more-facets" ></div>

<!-- \n -->

<div class="facet-box">
	<span class="facet-label">Metastasizes To</span>
		<div class="clear"></div>
			</div>
				<div class="facet-list" id="mets-to"></div>
					<div onclick='moreFacets()' class="more-facets" ></div>

<!-- \n -->

<div class="facet-box">
	<span class="facet-label">Germline Mutant Alleles</span>
		<div class="clear"></div>
			</div>
				<div class="facet-list" id="strain-marker"></div>
					<div onclick='moreFacets()' class="more-facets" ></div>

<!-- \n -->

<div class="facet-box">
	<span class="facet-label">Human Tissue Model</span>
		<div class="clear"></div>
			</div>
				<div class="facet-list" id="human-tissue"></div>
					<div onclick='moreFacets()' class="more-facets" ></div>

<!-- \n -->

</td>
	<td><div id="results"></div></td>
		</tr>
			</table>
				<div id ="raw">
				
</jax:mmhcpage>
