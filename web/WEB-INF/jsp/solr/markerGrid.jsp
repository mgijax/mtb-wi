<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<!doctype html>
<html>
<head>
	<c:set var="pageTitle" scope="request" value="Marker Grid"/>

				<link rel="stylesheet" type="text/css" href="${applicationScope.urlBase}/extjs/resources/css/ext-all_noGlobals.css" /> 

				<link href="${applicationScope.urlStyleSheet}" rel="stylesheet" type="text/css"/>
				<script type="text/javascript" src="${applicationScope.urlBase}/extjs/adapter/ext/ext-base.js"></script>
				<script type="text/javascript" src="${applicationScope.urlBase}/extjs/ext-all.js"></script>
				<script type="text/javascript" src="${applicationScope.urlBase}/js/mtb.js?version=2"></script>
				<script type="text/javascript" src="${applicationScope.urlBase}/js/overlib.js"></script>
				<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
			
				<style type="text/css">

						div.cbox{
								font-size:90%;
								text-align:left;
						}

						table.mg{
								border-collapse:collapse;
								border-spacing:0;
								padding:0px;
						}

						td.mg{
								text-align: center;
								padding:0px;
						}			

						td.strain{
								text-align: left;
								font-size:80%;
						}

						td.oCbox{
								padding-top:0px;
								padding-left:0px;
								padding-bottom: 5px;
						}

						td.organ{
								text-align: center;
								vertical-align: bottom;
								height: ${oHeight};
								padding-bottom: 10px;
								padding-left: 0px;
								padding-right: 0px;
								font-size: 75%;
							 
						}

						.vertical{
								text-align: center;
								vertical-align: middle;
								width: 25px;
								margin: 0px;
								padding: 0px;
								white-space: nowrap;
								-webkit-transform: rotate(-90deg);
								-moz-transform: rotate(-90deg);	
								transform: rotate(-90deg);
						}

						.center{
								text-align:center;
						}

						.left{
								text-align:left;
						}
						
						 .right{
								text-align:right;
						}

						td.sort{
								padding: 0px;
								width: 16px;
								background-image: url(${applicationScope.urlImageDir}/sortable_wht.gif);
						}
						
						td.sorted{
								padding: 0px;
								width: 16px;
								background-image: url(${applicationScope.urlImageDir}/sortableDown_wht.gif);
						}

						td.high{
								padding: 0px;

								background-image: url(${applicationScope.urlImageDir}/high.png);
						}

						td.veryhigh{
								padding: 0px;

								background-image: url(${applicationScope.urlImageDir}/veryhigh.png);
						}

						td.moderate{
								padding: 0px;
								background-image: url(${applicationScope.urlImageDir}/moderate.png);
						}

						td.low{
								padding: 0px;
								background-image: url(${applicationScope.urlImageDir}/low.png);
						}

						td.verylow{
								padding: 0px;
								background-image: url(${applicationScope.urlImageDir}/verylow.png);
						}

						td.observed{
								padding: 0px;
								background-image: url(${applicationScope.urlImageDir}/observed.png);
						}

						a.noline:link{ 
								text-decoration: none;
						} 

				</style>

				<script	language="javascript">

						function organSort(o) {
								document.getElementById("sort-organ").value = o;
								document.gridForm.submit();

						}

						var rsp;

						Ext.onReady(function () {

								var url = '/mtbwi/solrQuery.do';
								var markerURL = 'wt=json&indent=on&facet=true&facet.field=strainMarker&facet.sort=name&fq=singleMutant:true&fq=metastatic:false&q=humanTissue:*&facet.mincount=1&rows=1&start=0&facet.limit=-1';

								doXMLReq();
								
								
								// might be sorting on a column off the screen, focus on it
								if(document.getElementById("sorted")){
										document.getElementById("sorted").scrollIntoView();
								}

								function doXMLReq() {

										var xmlHttpReq = false;
										var self = this;
										if (window.XMLHttpRequest) { // Mozilla/Safari
												self.xmlHttpReq = new XMLHttpRequest();
										} else if (window.ActiveXObject) { // IE
												self.xmlHttpReq = new ActiveXObject("Microsoft.XMLHTTP");
										}
										self.xmlHttpReq.open('POST', url, true);
										self.xmlHttpReq.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
										self.xmlHttpReq.onreadystatechange = function () {
												if (self.xmlHttpReq.readyState == 4) {

														parseResponse(self.xmlHttpReq.responseText);
												}
										}

										self.xmlHttpReq.send(markerURL);

								}

								// it seems like we need an array of arrays for the store?
								function parseResponse(str) {

										var rsp = eval("(" + str + ")");
										var t = [];
										var markers = rsp.facet_counts.facet_fields.strainMarker;
										

										// lame. store expects [[value,label]] but [[value]] works
										for (i = 2; i < markers.length; i = i + 2) {
												t.push([markers[i]]);
											 
										}
										
								//		lower case mouse markers first but still alphabetical
										t.sort(function(a,b){
											 var nameA = a[0].toUpperCase(); // ignore case
											 
												var nameB = b[0].toUpperCase(); // ignore case
												
												
												if (nameA < nameB) {
													return -1;
												}
												if (nameA > nameB) {
													return 1;
												}
												
												 // b is lower case a is not
												if(nameA == a[0] && nameB != b[0]){
														return 1;
												}
												// a is lower case b is not
												if(nameA != a[0] && nameB == b[0]){
														return -1;
												}

												// names must be equal
												return 0;
											});
										
										theStore.loadData(t);

								}

								theStore = new Ext.data.ArrayStore({
										id: 'theStore',
										fields: [{name: 'symbol'}],
										autoLoad: false
								});

								var combo = new Ext.form.ComboBox({
										store: theStore,
										minChars: 1,
										valueField: 'symbol',
										displayField: 'symbol',
										typeAhead: true,
										mode: 'local',
										triggerAction: 'all',
										selectOnFocus: true,
										hiddenName: 'marker',
										//	width:200,
										listEmptyText: 'no matching gene',
										renderTo: 'markerSelect',
										ctCls: 'center',
										value: '${marker}'
								});
						})

				</script>
	<c:import url="../../../meta.jsp"/>
		</head>

<body>
	<c:import url="../../../body.jsp" />
<div class="wrap">
<nav><c:import url="../../../toolBar.jsp"/></nav>
<section class="main">

<header>
	<h1>${pageTitle}</h1>
	<a class="help" href="userHelp.jsp"></a>
</header>

				 <!--	 Some really great explanatory text goes here. 
						Use check boxes to limit organs in grid (check desired organs and click 'Generate Grid'). 
						Sort highest to lowest frequency for an organ by clicking the organ name. -->

						<form name="gridForm" action="/mtbwi/markerGrid.do" method="GET">
								<input type="hidden" id="sort-organ" name="sortOrgan" value="">
					
								<!-- old marker is the current marker but if the user selects a new marker
										 it will be the old marker when the form is submitted -->
								<input type="hidden"	name="oldMarker" value="${marker}">
								${table}

						</form>

</section>
</div>
</body>
</html>
