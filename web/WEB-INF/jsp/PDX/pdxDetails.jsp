<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="PDX Model Details" subtitle="${mouse.modelID}">
	<jsp:attribute name="head">
	<link rel="stylesheet" type="text/css" href="./live/www/css/results.css"/>
	<script type="text/javascript" src="https://cdn.datatables.net/1.13.1/js/jquery.dataTables.min.js"></script>	
		<link rel="stylesheet" type="text/css" href="${applicationScope.urlBase}/extjs/resources/css/ext-all.css" />

		<style type="text/css">
			/* this color is totaly arbitrary -- sota salmony */
			.x-grid3-row.false-positive .x-grid3-cell{ 
				background-color:  #ffe2e2 !important; 
				color: #900; 
			} 
			.x-panel-body{
				border:0 none;
				background-color: #F0F0F0;
			}
			
			.x-panel-body-noheader{
				border:0 none;
			}
			
			p{
				margin-bottom: 2px;
			}


			a.ckb:link{
			color:red;
			}
			a.ckb:visited{
			color:red;
			}
			

		</style>


		<script type="text/javascript" src="${applicationScope.urlBase}/extjs/adapter/ext/ext-base.js"></script>
		<script type="text/javascript" src="${applicationScope.urlBase}/extjs/ext-all.js"></script>
		<script type="text/javascript" src="${applicationScope.urlBase}/extjs/columnHeader.js"></script>
		 <script src="https://code.jquery.com/jquery-3.6.3.min.js"
			  integrity="sha256-pvPw+upLPUjgMXY0G+8O0xUf+/Im1MZjXxxgOcBQBXU="
			  crossorigin="anonymous"></script>

		<script type="text/javascript" src="https://www.google.com/jsapi"></script>

		<script type="text/javascript">

		try{
			google.load("visualization", "1", {packages: ["corechart"]});
		}catch(error){
   		//no google api in China
		}
			Ext.ns('org.jax.mgi.mtb');

			var expressionData, expressionBarChart, cnvData, cnvBarChart;

			var expGeneSortDir = false;
			var expRankSortDir = true;

			var cnvGeneSortDir = false;
			var cnvRankSortDir = true;

			var cnvLog = true;
			
			var civicLinks = {};
			var civicGenes = {};

			var expressionOptions = {
				fontSize: 10,
				title: 'Gene Expression by Percentile Rank Z Score',
				titleTextStyle: {fontSize: 14},
				vAxis: {title: 'Gene', titleTextStyle: {color: 'red'}},
				hAxis: {format: '##.##'},
				chartArea: {top: 5, height: "95%"}

			};

			var cnvOptionsLog = {
				fontSize: 10,
				// 	legend: {position: 'none'},
				vAxis: {title: 'Gene', titleTextStyle: {color: 'red'}},
				hAxis: {logScale: true, baseline: 0},
				chartArea: {top: 5, height: "95%"}

			};

			var cnvOptionsLinear = {
				fontSize: 10,
				// 		legend: {position: 'none'},
				vAxis: {title: 'Gene', titleTextStyle: {color: 'red'}},
				hAxis: {logScale: false, baseline: 0},
				chartArea: {top: 5, height: "95%"}

			};

			var currentCnvOptions = cnvOptionsLinear;


			function expSortGene() {
				expGeneSortDir = !expGeneSortDir;
				expressionData.sort({column: 0, desc: expGeneSortDir});
				expressionBarChart.draw(expressionData, expressionOptions);
			}

			function expSortRank() {
				expRankSortDir = !expRankSortDir;
				expressionData.sort({column: 1, desc: expRankSortDir});
				expressionBarChart.draw(expressionData, expressionOptions);
			}

			function cnvSortGene() {
				cnvGeneSortDir = !cnvGeneSortDir;
				cnvData.sort({column: 0, desc: cnvGeneSortDir});
				cnvBarChart.draw(cnvData, currentCnvOptions);
			}

			function cnvSortRank() {
				cnvRankSortDir = !cnvRankSortDir;
				cnvData.sort({column: 1, desc: cnvRankSortDir});
				cnvBarChart.draw(cnvData, currentCnvOptions);
			}



			function logUnLog() {
				if (cnvLog) {
					currentCnvOptions = cnvOptionsLog;
				} else {
					currentCnvOptions = cnvOptionsLinear;
				}
				cnvBarChart.draw(cnvData, currentCnvOptions);
				cnvLog = !cnvLog;
			}


			function doExpressionBarChart() {

			try{
					expressionData = google.visualization.arrayToDataTable([${geneExpressionData}]);

					if (expressionData.getNumberOfRows() > 0) {
						expressionData.sort(0);
						expressionBarChart = new google.visualization.BarChart(document.getElementById('geneExpressionChart'));
						expressionBarChart.draw(expressionData, expressionOptions);
					}
				}catch(err){
					//no google api in China
				}
			}

			function doCnvBarChart() {
			try{
					cnvData = google.visualization.arrayToDataTable([${geneCNVData}]);

					if (cnvData.getNumberOfRows() > 0) {
						cnvData.sort(0);
						cnvBarChart = new google.visualization.BarChart(document.getElementById('geneCNVChart'));
						cnvBarChart.draw(cnvData, cnvOptionsLinear);
					}
				}catch(err){
                                    console.log(err)
					//no google api in China
				}
			}

			
			Ext.onReady(function () {

				dataProxy = new Ext.data.HttpProxy({
					url: '/mtbwi/pdxVariationData.do?modelID=${modelID}${ctpOnly}',
					timeout: 7000000
				})

				var fields = [
					{name: 'model_id'},
					{name: 'sample_name'},
					{name: 'gene_symbol'},
					{name: 'platform'},
					{name: 'chromosome'},
					{name: 'seq_position'},
					{name: 'ref_allele'},
					{name: 'alt_allele'},
					{name: 'consequence'},
					{name: 'amino_acid_change'},
					{name: 'rs_variants'},
					{name: 'read_depth'},
					{name: 'allele_frequency'},
					{name: 'transcript_id'},
					{name: 'filtered_rationale'},
					{name: 'filter'},
					{name: 'passage_num'},
					{name: 'entrez_gene_id'},
					{name: 'ckb_molpro_link'},
					{name: 'ckb_molpro_name'},
					{name: 'ckb_potential_treat_link'},
					{name: 'ckb_potential_treat_approach'},
					{name: 'ckb_protein_effect'},
					{name: 'ckb_nclinical_resist'},
					{name: 'ckb_nclinical_sens'},
					{name: 'ckb_npreclinical_resist'},	
					{name: 'ckb_npreclinical_sens'},
					{name: 'count_human_reads'},
					{name: 'pct_human_reads'}
					

				];



				// create the Data Store
   			var store = new Ext.data.ArrayStore({
					root: 'variation',
					totalProperty: 'total',
					//	idIndex: 0,
					remoteSort: true,
					autoLoad: false,
					// these need to match the webservice field names for sorting to work
					fields: fields,
					proxy: dataProxy
					
				});
				
				var ckb = [{header: '', colspan: 2, align: 'center'},
						{header: '<a href="https://ckbhome.jax.org" onclick="openCKB()">JAX Clinical Knowledgebase (CKB)</a> annotations<br><img src="${applicationScope.urlImageDir}/CKBPrivate.png" width="10px" height="10px" border=0 alt="Details available to CKB Boost users with active subscriptions only."> Details available to CKB Boost users with active subscriptions only.', colspan: 6, align: 'center'},
						{header: '', colspan: 16, align: 'center'}]
				
 				var group = new Ext.ux.grid.ColumnHeaderGroup({
					rows: [ckb]
				});

				store.setDefaultSort('gene_symbol', 'ASC');

				var grid = new Ext.grid.GridPanel({
					store: store,
					columns: [
						{
							header: 'Sample',
							width: 110,
							sortable: true,
							dataIndex: 'sample_name'
						},
						{
							header: 'Gene',
							width: 100,
							sortable: true,
							dataIndex: 'gene_symbol',
   						
						},
						
						{
							header: 'Variant',
							width: 120,
							sortable: true,
							dataIndex: 'ckb_molpro_name',
							renderer: ckbMolProRenderer
						},
						{
							header: 'Variant effect',
							width: 100,
							sortable: true,
							dataIndex: 'consequence'
						},
  									
						{
							header: 'CKB<br>protein<br>effect',
							width: 80,
							sortable: true,
							dataIndex: 'ckb_protein_effect'
						},
									
						{
							header: '# Annotations<br>predicting<br><b>sensitivity<b>',
							width: 140,
							sortable: true,
							dataIndex: 'ckb_nclinical_sens',
							renderer: ckbSensitivityRenderer
						},
   			
						{
							header: '# Annotations<br>predicting<br><b>resistance</b>',
							width: 140,
							sortable: true,
							dataIndex: 'ckb_nclinical_resist',
							renderer: ckbResistanceRenderer
						}, 
  			
						{
							header: 'Potential<br>treatment<br>approaches',
							width: 110,
							sortable: true,
							dataIndex: 'ckb_potential_treat_approach',
							renderer: ckbPotTreatRenderer
						}, 
						
						{
							header: 'Platform',
							width: 90,
							sortable: true,
							dataIndex: 'platform'
						},
						{
							header: 'Chromosome',
							width: 80,
							sortable: true,
							dataIndex: 'chromosome'
						},
						{
							header: 'Seq Position',
							width: 90,
							sortable: true,
							dataIndex: 'seq_position'
						},
						{
							header: 'Ref Allele',
							width: 75,
							sortable: true,
							dataIndex: 'ref_allele'

						},
						{
							header: 'Alt Allele',
							width: 75,
							sortable: true,
							dataIndex: 'alt_allele'

						},
						
						{
							header: 'Amino Acid Change',
							width: 120,
							sortable: true,
							dataIndex: 'amino_acid_change',
							renderer: civicLinkRenderer
						},
						{
							header: 'RS Variants',
							width: 90,
							sortable: true,
							dataIndex: 'rs_variants'
						},
						{
							header: 'Read Depth',
							width: 80,
							sortable: true,
							dataIndex: 'read_depth'
						},
						{
							header: 'Allele Frequency',
							width: 110,
							sortable: true,
							dataIndex: 'allele_frequency'
						},
						{
							header: 'Transcript ID',
							width: 110,
							sortable: true,
							dataIndex: 'transcript_id'
						},
						{
							header: 'Filtered Rationale',
							width: 110,
							sortable: true,
							dataIndex: 'filtered_rationale'

						},
						{
							header: 'Filter',
							width: 60,
							sortable: true,
							dataIndex: 'filter'

						},
						{
							header: 'Passage Num',
							width: 60,
							sortable: true,
							dataIndex: 'passage_num'
						},
						{
							header: 'Gene ID',
							width: 70,
							sortable: true,
							dataIndex: 'entrez_gene_id'
						},
						{
							header: 'Count Human Reads',
							width: 80,
							sortable: true,
							dataIndex: 'count_human_reads'
						},
						{
							header: 'PCT Human Reads',
							width: 80,
							sortable: true,
							dataIndex: 'pct_human_reads'
						}

					],
					stripeRows: true,
					height: 670,
					width: 1000,
					id: 'pdxGrid'
					, viewConfig:{markDirty:false}
					, bbar: new Ext.PagingToolbar({
						pageSize: 25,
						store: store,
						displayInfo: true,
						displayMsg: 'Displaying results {0} - {1} of {2}'
					}),
					plugins:group



				});
				
				// not used
 				function ckbGeneRenderer(value, p, record){
					if(record.get("ckb_gene_id").length>0){
						return String.format('<a href="{0}" target="_blank">{1}</a>',record.get("ckb_gene_id"),record.get("gene_symbol"));
					}else{
						if(record.get("gene_symbol")){
							return record.get("gene_symbol");
						}else{
							return "";
						}
					}
   				
				}
				
 				function ckbMolProRenderer(value, p, record){
 					val = record.get("ckb_molpro_name");
 					
 					if(record.get("ckb_molpro_name").length>0 && record.get("ckb_molpro_link").length>0){
						val =  String.format('<a href="{0}" target="_blank">{1}</a>',record.get("ckb_molpro_link"), record.get("ckb_molpro_name"));
						
						if(record.get("ckb_molpro_link").indexOf("ckbhome") != -1){
							val =  String.format('<a href="{0}" class="ckb" title="red links require CKB registration" target="_blank">{1}</a><img src="${applicationScope.urlImageDir}/CKBPrivate.png" width="10px" height="10px" border=0 alt="Details available to registerd CKB users only">',record.get("ckb_molpro_link"), record.get("ckb_molpro_name"));
						}
					}
						
					return val;
					
				}
				
				function ckbPotTreatRenderer(value, p, record){
 					val = record.get("ckb_potential_treat_approach");
 					
 					if(record.get("ckb_potential_treat_approach").trim().length>0 && record.get("ckb_molpro_link").length>0){
						val =  String.format('<a href="{0}" target="_blank">{1}</a>',record.get("ckb_molpro_link")+"?tabType=TREATMENT_APPROACH_EVIDENCE", record.get("ckb_potential_treat_approach"));
						
						if(record.get("ckb_molpro_link").indexOf("ckbhome") != -1){
							val =  String.format('<a href="{0}" class="ckb" title="red links require CKB registration" target="_blank">{1}</a><img src="${applicationScope.urlImageDir}/CKBPrivate.png" width="10px" height="10px" border=0 alt="Details available to registerd CKB users only">',record.get("ckb_molpro_link"), record.get("ckb_potential_treat_approach"));
						}
					}
						
					return val;
					
				}
				
				function ckbResistanceRenderer(value, p, record){
					val = "";
					if(record.get("ckb_nclinical_resist").trim().length>0 || record.get("ckb_npreclinical_resist").trim().length>0){
						val = "0 clinical/";
						if(record.get("ckb_nclinical_resist").trim().length>0){
							val = record.get("ckb_nclinical_resist")+" clinical /"
						}			
						if(record.get("ckb_npreclinical_resist").trim().length>0){
							val = val+record.get("ckb_npreclinical_resist")+" preclinical";
						}else{
							val = val+"0 preclinical";
						}
					}
					return val;
				}
				
				
				function ckbSensitivityRenderer(value, p, record){
					val = "";
					if(record.get("ckb_nclinical_sens").trim().length>0 || record.get("ckb_npreclinical_sens").trim().length>0){
						val = "0 clinical/";
						if(record.get("ckb_nclinical_sens").trim().length>0){
							val = record.get("ckb_nclinical_sens")+" clinical /"
						}			
						if(record.get("ckb_npreclinical_sens").trim().length>0){
							val = val+record.get("ckb_npreclinical_sens")+" preclinical";
						}else{
							val = val+"0 preclinical";
						}
					}
					return val;
				}
				
				
				function civicLinkRenderer(value, p, record, row, col, store){
					
					// key to civicLinks should be gene+variant since variant isn't unique
   				
					if(civicGenes.hasOwnProperty(record.get("gene_symbol"))){
						record.set("entrez_gene_id",civicGenes[record.get("gene_symbol")]);
					}
   				
					if(value.indexOf("https") != -1) return value;
   				
					if(value){
						if(civicLinks.hasOwnProperty(record.get("gene_symbol")+"-"+value)) return civicLinks[record.get("gene_symbol")+"-"+value];
					
						
 						$.ajax({
   								dataType: "json",
   								url: "https://civicdb.org/api/genes/" + record.get("gene_symbol") +"?identifier_type=entrez_symbol",
   								success: function (result,status,xhr) {
   									var linkKey = record.get("gene_symbol")+"-"+value;
   									record.set("entrez_gene_id",result.entrez_id)
   									civicGenes[record.get("gene_symbol")] = result.entrez_id;
   									if (result.variants.length > 0) {
										var gene_id = result.id;
											for(i = 0; i < result.variants.length; i++){
   											
												if(value == result.variants[i].name){
 													var variant_id = result.variants[i].id;
 													civic_url = "https://civicdb.org/events/genes/" + gene_id + "/summary/variants/" + variant_id + "/summary#variant";
 													
 													civicLinks[linkKey] = String.format('<a href="{0}" target="_blank">{1}</a>',civic_url,value);

 													
 													record.set('amino_acid_change',civicLinks[linkKey]);
 													console.log("created link "+civic_url + " for "+linkKey);
 													return;
 												}
 											}
									}
									if (!(civicLinks.hasOwnProperty(linkKey))){
											civicLinks[linkKey] = value;
									}
   								},
   								error: function (result,status,xhr) {
   									
   									civicLinks[record.get("gene_symbol")+"-"+value] = value
   								},
   								
  								
   						});
						
   					
  				return value;  	
				}
 				
 				
				}

				Ext.EventManager.onWindowResize(function (w, h) {
					panel.doLayout();
				});

				// there must be a better way...
				var colNames = [];
				colNames.push( 'sample_name');
				colNames.push( 'gene_symbol');
				colNames.push( 'ckb_molpro_name');
				colNames.push( 'consequence');
				colNames.push( 'ckb_protein_effect');
				colNames.push( 'ckb_nclinical_sens');
				colNames.push( 'ckb_nclinical_resist');
				colNames.push('ckb_potential_treat_approach');
				colNames.push( 'platform');
				colNames.push( 'chromosome');
				colNames.push( 'seq_position');
				colNames.push( 'ref_allele');
				colNames.push( 'alt_allele');
				colNames.push( 'amino_acid_change');
				colNames.push( 'rs_variants');
				colNames.push( 'read_depth');
				colNames.push( 'allele_frequency');
				colNames.push( 'transcript_id');
				colNames.push( 'filtered_rationale');
				colNames.push( 'filter');
				colNames.push( 'passage_num');
				colNames.push( 'entrez_gene_id');
				colNames.push( 'count_human_reads');
				colNames.push( 'pct_human_reads');
 	


				// focus on sort column otherwise focus always jumps to first column
				grid.on("sortChange", function (grid, sortInfo) {
					if ('gene_symbol' != sortInfo.field) {
						(function () {
							grid.getView().focusCell(1, colNames.indexOf(sortInfo.field));
						}).defer(75);
					}
				})
				// keep track of the index of columns when they move
				grid.on("columnmove", function (oldInd, newInd) {
					col = colNames[oldInd];
					colNames.splice(oldInd, 1);
					colNames.splice(newInd, 0, col);

				})

				panel = new Ext.Panel({
					applyTo: 'variantSummary',
					collapsible: true,
					collapsed: true,
					collapseFirst: true,
					title: 'Click to expand/collapse',
					layout: {
						type: 'fit',
						align: 'stretch',
						pack: 'start'
					},
					titleCollapse: true,
					hideCollapseTool: true,
					items: [grid]
				});

				panel.render();

				panel.doLayout();
				
  			//  grid.getView().renderHeaders();

				checkVariants = function () {
					if (store.getTotalCount() == 0) {
						document.getElementById("noVariantSummary").style.display = "block";
						document.getElementById("variantData").style.display = "none";
						document.getElementById("variantSummary").style.display = "none";
					}
				}

				store.on("load", checkVariants);
				store.load({params: {start: 0, limit: 25}});

				if (document.getElementById("geneExpressionDiv") != null) {

					panel2 = new Ext.Panel({
						applyTo: 'geneExpressionDiv',
						collapsible: true,
						collapsed: true,
						collapseFirst: false,
						title: 'Click to expand/collapse',
						forceLayout: true,
						layout: {
							type: 'fit',
							align: 'stretch',
							pack: 'start'
						},
						titleCollapse: true,
						hideCollapseTool: true,
						items: [{html: '<p><b style="float: inline-start;">Sort by:</b><input type="button" value="Gene" onclick="expSortGene()">' +
										'&nbsp;<input type="button" value="Rank" onclick="expSortRank()"></p>' +
										'<br><div id="geneExpressionChart" style="height:${expChartSize}px"></div>'}]
					});

					panel2.on('expand', doExpressionBarChart);
					panel2.render();
					panel2.doLayout();
				}

				if (document.getElementById("geneCNV") != null) {

					panel3 = new Ext.Panel({
						applyTo: 'geneCNV',
						collapsible: true,
						collapsed: true,
						collapseFirst: false,
						title: 'Click to expand/collapse',
						forceLayout: true,
						layout: {
							type: 'fit',
							align: 'stretch',
							pack: 'start'
						},
						titleCollapse: true,
						hideCollapseTool: true,
						items: [{html: '<p style="text-align:left;"><b style="float: inline-start;">Sort by:</b><input type="button" value="Gene" onclick="cnvSortGene()">' 
                                                                +'&nbsp;<input type="button" value="Rank" onclick="cnvSortRank()"></p>' 
                                                                +'<p style="text-align:center;">Bars are colored by sample, CNV values a calculated as log2(cn raw/sample ploidy).</p>' 
								+' <div id="geneCNVChart" style="height:${cnvChartSize}px" ></div>'}]

					});

					panel3.on('expand', doCnvBarChart);
					panel3.render();
					panel3.doLayout();
				}
				
				if(document.getElementById("references") != null){
				
					panel4 = new Ext.Panel({
   						applyTo: 'references',
   						collapsible: true,
   						collapsed: ${collapseReferences},
   						collapseFirst: false,
   						title: 'Click to expand/collapse',
   						forceLayout: true,
   						border:false,
   						bodyBorder:false,
   						header:${collapseReferences},
  						
   						layout: {
   							type: 'fit',
   							align: 'stretch',
   							pack: 'start'
   						},
   						titleCollapse: true,
   						hideCollapseTool: true,
   						items: [{html:'<c:forEach var="link" items="${referenceLinks}" varStatus="status">
											<p>${link.description}&nbsp;<a href="${link.url}" target="_blank">${link.linkText}</a>\
 											<c:if test="${not empty sessionScope.pdxEditor}">
  												<a href="pdxEditContent.do?contentType=link&contentKey=${link.contentKey}&modelID=${modelID}" class="linkedButton">\
  												<input type="button" value="Edit"/>\
  												</a>\
 											</c:if>
 											</p>\
										</c:forEach>'
   								}]

   					});

   					panel4.render();
   					panel4.doLayout();
				}
				
  		
			
 			if(document.getElementById("cnvPlots") != null){
				panel5 = new Ext.Panel({
						applyTo: 'cnvPlots',
						collapsible: true,
						collapsed: true,
						collapseFirst: false,
						title: 'Click to expand/collapse',
						forceLayout: true,
						layout: {
							type: 'fit',
							align: 'stretch',
							pack: 'start'
						},
						titleCollapse: true,
						hideCollapseTool: true,
   						items: [{html:'<c:forEach var="imageData" items="${cnvPlots}" varStatus="status">
                                                                        <div style="text-align:center">\
                                                                        ${imageData.get(0)}<br>\
                                                                        <img src="${applicationScope.pdxFileURL}../cnvPlots/tumor_only/${imageData.get(1)}" height="450" width="975"/></div><br>\
                                                                </c:forEach>'
   								}]

   					});

   					panel5.render();
   					panel5.doLayout();
				}
                                
                                
                                
                                
                                if (document.getElementById("dataLinks") != null) {

					linksPanel = new Ext.Panel({
						applyTo: 'dataLinks',
						collapsible: true,
						collapsed: true,
						collapseFirst: false,
						title: 'Click to expand/collapse',
						forceLayout: true,
						layout: {
							type: 'fit',
							align: 'stretch',
							pack: 'start'
						},
						titleCollapse: true,
						hideCollapseTool: true,
						items: [{html: '<b>Fantastic explanatory text here</b><br>'<c:if test="${not empty mouse.variationLinks}">
                                                                    +'<b>Variation Links:</b><br>'
                                                                </c:if>
                                                                <c:forEach var="link" items="${mouse.variationLinks}" >
                                                                     +'<p>&nbsp;&nbsp;&nbsp;Sample:${link.sample} from passage:${link.passage}&nbsp;Platform:${link.platform}&nbsp;<a target="_blank" href="${link.derivedLink}">Derived Data</a>&nbsp;'
                                                                         <c:forEach var="raw" items="${link.rawLinks}" varStatus="status">
                                                                         +'<a target="_blank" href="${raw}">Raw data ${status.index+1}</a>&nbsp;'
                                                                         </c:forEach>
                                                                     +'</p>'
                                                                </c:forEach>
                                                                <c:if test="${not empty mouse.expressionLinks}">
                                                                    +'<br><b>Expression Links:</b><br>'
                                                                </c:if>
                                                                <c:forEach var="link" items="${mouse.expressionLinks}" >
                                                                     +'<p>&nbsp;&nbsp;&nbsp;Sample:${link.sample} from passage:${link.passage}&nbsp;Platform:${link.platform}&nbsp;<a target="_blank" href="${link.derivedLink}">Derived Data</a>&nbsp;'
                                                                         <c:forEach var="raw" items="${link.rawLinks}" varStatus="status">
                                                                         +'<a target="_blank" href="${raw}">Raw data ${status.index+1}</a>&nbsp;'
                                                                         </c:forEach>
                                                                         +'</p>'
                                                                </c:forEach>
                                                                <c:if test="${not empty mouse.cnvLinks}">
                                                                 +'<br><b>CNV Links:</b><br>'
                                                                </c:if>
                                                                <c:forEach var="link" items="${mouse.cnvLinks}" >
                                                                     +'<p>&nbsp;&nbsp;&nbsp;Sample:${link.sample} from passage:${link.passage}&nbsp;Platform:${link.platform}&nbsp;<a target="_blank" href="${link.derivedLink}">Derived Data</a>&nbsp;'
                                                                         <c:forEach var="raw" items="${link.rawLinks}" varStatus="status">
                                                                         +'<a target="_blank" href="${raw}">Raw data ${status.index+1}</a>&nbsp;'
                                                                         </c:forEach>
                                                                         +'</p>'
                                                                </c:forEach>
                                                         }]

					});

					
					linksPanel.render();
					linksPanel.doLayout();
				}
				
				
			});
			
			function openCKB(){
				window.open("https://ckbhome.jax.org","ckb");
			}
			
   		
                        
				
				

		</script>
	</jsp:attribute>
	<jsp:body>
             <form name="AddPDXContentForm" style="font-size:1em;" method="GET" action="pdxAddContent.do">
                 <input type="hidden" value="${modelID}" name="modelID"/>
                    <div class="container">
                   
		
			<c:if test="${empty unavailable}">
				<p style="text-align:right;"><a href="pdxRequest.do?mice=${mouse.modelID}">Request information on the availability of this model.</a></p>
			</c:if>
			<c:if test="${not empty unavailable}">
				<p style="font-size:20px;text-align:right;">This PDX model is not available. (No inventory)</p>
			</c:if>			
			<c:if test="${fn:contains(mouse.institution,'Dana-Farber')}">
                           
				<c:if test="${not empty proxeID}">
					<p style="font-size: 14px;">This model is being distributed by The Jackson Laboratory on behalf of the Lymphoma Xenograft core at Dana-Farber Cancer Institute (DFCI).
					<br>Additional information can be found by registering at DFCI's PRoXe (<a href="https://www.proxe.org/" target="_blank">https://www.proxe.org/</a>) web site.
                                        <br>PRoXe model id: ${proxeID}
                                        </p>
				</c:if>					
				<p style="font-size: 14px;">The use of this material by a company is subject to the terms of the attached <a target="_blank" href="${applicationScope.urlBase}/html/DFCICompany.pdf">notice</a>.
				<br>The use of this material by an academic institution is subject to the terms of the attached <a target="_blank" href="${applicationScope.urlBase}/html/DFCIAcademic.pdf">notice</a>.
                                </p>
                           
			</c:if> 
                       <section id="summary">
                       
			<table>
				<tbody>			
                                    <tr>
                                        <td colspan="2">
                                            <h2>PDX Model Summary </h2>
                                        </td>
                                    </tr>
					<tr>
						<td width="15%"><h4>Model Details</h4></td>
						<td>
                                                        <c:if test="${not empty mouse.previousID}">
							<jax:dl showNoData="true"  dt="Model ID (Previous ID)" dd="${mouse.modelID} (${mouse.previousID})"/>
                                                        </c:if>
                                                        <c:if test="${empty mouse.previousID}">
							<jax:dl showNoData="true"  dt="Model ID" dd="${mouse.modelID}"/>
                                                        </c:if>
                                                        <jax:dl showNoData="true"  dt="Initial Diagnosis" dd="${mouse.initialDiagnosis}" />
							<jax:dl showNoData="true"  dt="Final Diagnosis" dd="${mouse.clinicalDiagnosis}" />
                                                        <c:if test="${empty mouse.stage && empty mouse.grade}">
                                                            <jax:dl showNoData="true"  dt="Stage/Grade" dd="" />
                                                        </c:if>
							<c:if test="${not empty mouse.stage || not empty mouse.grade}">
                                                            <jax:dl showNoData="true"  dt="Stage/Grade" dd="${mouse.stage} / ${mouse.grade}" />
                                                        </c:if>
							<jax:dl showNoData="true"  dt="Model Status" dd="${mouse.modelStatus}" test="${applicationScope.publicDeployment == false}" />
							<jax:dl showNoData="true"  dt="Primary Site" dd="${mouse.primarySite}" />
							<jax:dl showNoData="true"  dt="Sample Site" dd="${mouse.tissue}" />
							<jax:dl showNoData="true"  dt="Tumor Type" dd="${mouse.tumorType}" />   				
							
						</td>
					</tr>
                                        
                                         <c:if test="${not empty relatedModels}">
                                             <tr>
                                                 <td><h4>Related Models</h4></td>
						<td>
                                                    ${relatedModels}
                                                    
                                                </td>
                                             </tr>
                                         </c:if>
					
					<c:if test="${not empty sessionScope.pdxEditor || not empty referenceLinks}" > 
					<tr>
						<td><h4>Publications citing this model</h4></td>
						<td>
                                                     <c:forEach var="link" items="${referenceLinks}" varStatus="status">
                                                        ${link.description}&nbsp;<a href="${link.url}" target="_blank">${link.linkText}</a>
                                                        <c:if test="${not empty sessionScope.pdxEditor}">
                                                                <a href="pdxEditContent.do?contentType=link&contentKey=${link.contentKey}&modelID=${modelID}" class="linkedButton">
                                                                        <input type="button" value="Edit"/>
                                                                </a>
                                                        </c:if>
                                                        <br>
                                                    </c:forEach> 
                                                   
                                                    <c:if test="${not empty sessionScope.pdxEditor}">
                                                            <input type="submit" name="reference" value="add">
                                                    </c:if>
						</td>
					</tr>
					</c:if>
					
					<tr>
						<td><h4>Patient</h4></td>
						<td>			
							<jax:dl showNoData="true"  dt="Sex" dd="${mouse.sex}"/>
							<jax:dl showNoData="true"  dt="Age (at time of tissue collection)" dd="${mouse.age}"/>
                                                        <c:if test="${empty mouse.race && empty mouse.ethnicity}">
                                                            <jax:dl showNoData="true"  dt="Race/Ethnicity" dd="" />
                                                        </c:if>
                                                        <c:if test="${not empty mouse.race || not empty mouse.ethnicity}">
                                                            <jax:dl showNoData="true"  dt="Race/Ethnicity" dd="${mouse.race} / ${mouse.ethnicity}" />
                                                        </c:if>
							
                                                        <jax:dl showNoData="true"  dt="Treatment Na&iuml;ve?" dd="${mouse.treatmentNaive}" />
                                                        
                                                        <c:if test="${empty mouse.currentSmoker &&  empty mouse.formerSmoker}">
                                                            <jax:dl showNoData="true"  dt="Current Smoker/Former Smoker" dd="" />
                                                        </c:if>
                                                        <c:if test="${not empty mouse.currentSmoker ||  not empty mouse.formerSmoker}">
                                                            <jax:dl showNoData="true"  dt="Current Smoker/Former Smoker" dd="${mouse.currentSmoker} / ${mouse.formerSmoker}" />
                                                        </c:if>
						</td>
					</tr>			
					
					<tr>
						<td><h4>Engraftment</h4></td>
						<td>			
							<jax:dl showNoData="true"  dt="Host Strain" dd="${mouse.strain}" />
                                                        <jax:dl showNoData="true"  dt="Sample Type" dd="${mouse.sampleType}" />
							<jax:dl showNoData="true"  dt="Engraftment Site" dd="${mouse.location}" />
							
						</td>
					</tr>   	
                        </table>
                                                        
                       </section>
                     </div>
                       <section id="detail">
                        <table>
                                        <tr>
                                        <td colspan="2">
                                            <h2>Molecular Data (Engrafted Tumor)<a class="help" href="${pageContext.request.contextPath}/userHelp.jsp#pdxdetails"></a> </h2>
                                        </td>
                                    </tr>				
				
                                    <tr><td width="15%">
                                            <h4>Variants</h4>
                                        </td>
                                        <td>
                                        <c:if test="${not empty mouse.variationLinks}">
                                            Data Links:<br>
                                        </c:if>
                                        <c:forEach var="link" items="${mouse.variationLinks}" >
                                             <p>Sample:${link.sample} from passage:${link.passage}&nbsp;Platform:${link.platform}&nbsp;<a target="_blank" href="${link.derivedLink}">Derived Data</a>&nbsp;
                                                 <c:forEach var="raw" items="${link.rawLinks}" varStatus="status">
                                                 <a target="_blank" href="${raw}">Raw data ${status.index+1}</a>&nbsp;
                                                 </c:forEach>
                                             </p></br>
                                        </c:forEach>
                                            <p id="noVariantSummary" style="display: none"><i>no variation plots</i></p>
                                            </div>
                                            <div id="variantSummary"></div>
                                            <input id="variantData" type="button" value="Download variants data in CSV format" onClick="window.location = 'pdxDetails.do?csvSummary=true&modelID=${modelID}'">			
                                        </td>
                                    </tr>
                                    <td>
                                        <h4>Gene Expression</h4>
                                    </td>
                                    <td>
                                        <c:if test="${not empty mouse.expressionLinks}">
                                            Data Links:<br>
                                        </c:if>
                                        <c:forEach var="link" items="${mouse.expressionLinks}" >
                                             <p>Sample:${link.sample} from passage:${link.passage}&nbsp;Platform:${link.platform}&nbsp;<a target="_blank" href="${link.derivedLink}">Derived Data</a>&nbsp;
                                                 <c:forEach var="raw" items="${link.rawLinks}" varStatus="status">
                                                 <a target="_blank" href="${raw}">Raw data ${status.index+1}</a>&nbsp;
                                                 </c:forEach>
                                                 </p></br>
                                        </c:forEach>

                                        <c:if test="${empty geneExpressionData}">
                                                <p><i>no expression plots</i></p>
                                        </c:if>
                                        <c:if test="${not empty geneExpressionData}">
                                                <p>Platforms: ${platforms}</p>
                                                <c:if test="${fn:contains(platforms,'RNA_Seq')}">
                                                        <p>Hatched bars indicate genes with expression levels determined to be mildly affected by alignment calculations. <a href="userHelp.jsp#pdxalternateloci">Details</a>.</p>
                                                </c:if>
                                                <c:if test="${fn:contains(mouse.institution,'Dana-Farber') or fn:contains(mouse.institution,'Baylor')}">
                                                        <p><b>Please Note:</b> Expression data for this model is calculated as Log2(TPM+1)</p>
                                                </c:if>
                                        </c:if>								

                                <c:if test="${not empty geneExpressionData}">
                                        <div id="geneExpressionDiv"></div>
                                </c:if>
                                </td></tr>
                                 <tr><td>
                                    <h4>Gene CNV</h4>
                                     </td>
                                    <td>
                                     <c:if test="${not empty mouse.cnvLinks}">
                                            Data Links:<br>
                                       </c:if>
                                        <c:forEach var="link" items="${mouse.cnvLinks}" >
                                             <p>Sample:${link.sample} from passage:${link.passage}&nbsp;Platform:${link.platform}&nbsp;<a target="_blank" href="${link.derivedLink}">Derived Data</a>&nbsp;
                                                 <c:forEach var="raw" items="${link.rawLinks}" varStatus="status">
                                                 <a target="_blank" href="${raw}">Raw data ${status.index+1}</a>&nbsp;
                                                 </c:forEach>
                                                 </p></br>
                                        </c:forEach>
                                                 
                                        <c:if test="${empty geneCNVData}">
                                                <p><i>no CNV data</i></p>
                                        </c:if>
                                        </div>
                                        <c:if test="${not empty geneCNVData}">
                                                <div id="geneCNV"></div>
                                        </c:if>	
                                </td>
                            </tr>
                            
                            <!----
                            <tr><td>
		
                                    
                                    
                                     <h4>Data Links</h4>
                                     </td>
                                    <td>
                                    
                                                 
                                        <c:if test="${empty dataLinks}">
                                                <p><i>no data links</i></p>
                                        </c:if>
                                        </div>
                                        <c:if test="${not empty dataLinks}">
                                                <div id="dataLinks"></div>
                                        </c:if>	
                                </td>
                            </tr>
                            
                            -->
                            <tr><td>
		
                                    
                                    
                                    
                                    
                                    
                                  
                                    
                <h4>CNV Plots</h4></td>
                <td>
				<c:if test="${empty cnvPlots}">
                                    <p><i>no CNV plots</i></p>
				</c:if>				
			</div>
			<c:if test="${not empty cnvPlots}">
				<div id="cnvPlots"></div>
			</c:if>
                </td></tr>
            
                
                <tr>
                    <td><h4>Tumor Mutation Burden</h4></td>
                        <td>
                            <c:if test="${empty tmb}">
                                <i>no data</i>
                            </c:if>
                            <c:if test="${not empty tmb}">
                            <section id="tmb">
                                <jax:dl showNoData="true"  dt="" dts="" dds="${tmb}" />

                                <jax:dl showNoData="true"  dt="TMB Range" dd="${minTMB}-${maxTMB} (across all JAX PDX models; TMB &gt; 22 is considered high)"/>

                                </section>
                            </c:if>
                        </td>
                </tr>
                

                <tr>
                        <td><h4>Microsatellite Instability</h4></td>
                        <td>		
                            <c:if test="${empty msiData}">
                                <i>no data</i>
                            </c:if>
                            <c:if test="${not empty msiData}">
                                <jax:dl showNoData="true"  dt="" dts="" dds="${msiData}" />
                             </c:if>
                        </td>
                </tr>
                
                <tr>
                    <td><h4>Gene Fusion</h4></td>
                    <td>
                         <c:if test="${empty mouse.fusionGenes}">
                                <i>no data</i>
                        </c:if>
                        <c:if test="${not empty mouse.fusionGenes}">
                            <jax:dl showNoData="true"  dt="Fusion Genes" dd="${mouse.fusionGenes}" />
                        </c:if>
                    </td>
                </tr>
             </table>
                    <hr>
                    <table>
            
                    <tr>
                        <td colspan="2">
                            <h2>Model Characterization</h2>
                        </td>
                       
                    </tr>
                   
                    
                    <tr>
                        <td td width="15%">
                            <h4>Histology</h4>
                        </td>
                    <td>
                        <c:if test="${empty histology}">
                             <i>no data</i>
                        </c:if>
             				
                        
                        <c:if test="${not empty histology  ||  not empty sessionScope.pdxEditor || not empty histologySummary}">


                            <c:if test="${not empty sessionScope.pdxEditor}" >
                                
                                     <c:if test="${empty tumorMarkers}" > 
                                            <input type="submit" name="tumorMarkers" value="Add tumor markers"><br>
                                    </c:if>

                                    <c:if test="${empty histologySummary}">
                                            <input type="submit" name="histologySummary" value="Add summary"><br>
                                    </c:if>

                                    <c:if test="${empty pathologist}">
                                            <input type="submit" name="pathologist" value="Add pathologist"><br>
                                    </c:if>

                                    <br>
                                    <input type="submit" name="histology" value="Add histology">
                            </c:if>
                                    
                                 
                            <c:if test="${not empty tumorMarkers}">
                                <b>Tumor Markers:</b><br>
                                <c:forEach var="comment" items="${tumorMarkers}" varStatus="status">

                                    ${comment.comment}
                                    <c:if test="${not empty sessionScope.pdxEditor}">
                                            <a href="pdxEditContent.do?contentType=comment&contentKey=${comment.contentKey}&modelID=${modelID}" class="linkedButton">
                                                    <input type="button" value="Edit"/></a>
                                    </c:if>
                                    <br>

                                </c:forEach>

                            </c:if>
                                   
                               
                    
                           

                            <c:if test="${not empty histologySummary}">
                                <b>Summary:</b><br>${histologySummary.comment}<br>

                                    <c:if test="${not empty sessionScope.pdxEditor}">
                                            <a href="pdxEditContent.do?contentType=comment&contentKey=${histologySummary.contentKey}&modelID=${modelID}" class="linkedButton">  
                                                    <input type="button" value="Edit"/>
                                            </a><br>
                                    </c:if>
                                           

                            </c:if>

                            <c:if test="${not empty pathologist}">
                                <b>Pathologist:</b><br>${pathologist.comment}<br>
                                    <c:if test="${not empty sessionScope.pdxEditor}">
                                            <a href="pdxEditContent.do?contentType=comment&contentKey=${pathologist.contentKey}&modelID=${modelID}" class="linkedButton"> 
                                                    <input type="button" value="Edit"/>
                                            </a><br>
                                    </c:if>

                            </c:if>	

                            <table>

                                <c:forEach var="graphic" items="${histology}" varStatus="status">

                                        <c:choose>
                                                <c:when test="${status.index%2==0}">
                                                        <tr>
                                                        </c:when>
                                                </c:choose>


                                                <td style=" padding:5px; border:none; vertical-align:top; width:250px">
                                                        <a target="_blank" href="pdxDetailsTabs.do?tab=graphicDetails&contentKey=${graphic.contentKey}&modelID=${modelID}">
                                                                <img height="250" width="250" src="${applicationScope.pdxFileURL}${graphic.fileName}">
                                                        </a>
                                                        <c:if test="${not empty sessionScope.pdxEditor}">
                                                                <a href="pdxEditContent.do?contentType=graphic&contentKey=${graphic.contentKey}&modelID=${modelID}" class="linkedButton"> 
                                                                        <input type="button" value="Edit"/></a>
                                                                </c:if>
                                                        <br>${graphic.description}
                                                </td>
                                                <c:choose>
                                                        <c:when test="${status.index%2==1 || status.last}">
                                                        </tr>
                                                </c:when>
                                        </c:choose>
                                </c:forEach>
                            </table>
   			
                        </c:if>

                 	
                    </td>
                    </tr>
                    <tr>
                        <td>
                            <h4>Dosing Studies</h4>
                        </td>			
                        <td>	

                             <c:if test="${mouse.socGraph == 0}">
                                          <i>no data</i>
                             </c:if>

                                <c:if test="${mouse.socGraph > 0}">
                                    <table>
                                    <c:forEach var="socGraph" begin="1" end="${mouse.socGraph}" >
                                        <tr>

                                            <td style="border:0px none">
                                                <c:choose>
                                                    <c:when test="${mouse.socGraph == 1}">
                                                            <iframe width="100%" height="1300px" src='${applicationScope.socURL}${mouse.modelID}.html' style="border:0px none">
                                                            </iframe>
                                                    </c:when>
                                                    <c:otherwise>  
                                                            <iframe width="100%" height="1300px" src='${applicationScope.socURL}${mouse.modelID}_${socGraph}.html' style="border:0px none">
                                                            </iframe>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </table>
                                </c:if>
                                        

                        </td>
                        </tr>

                        <tr>
                            <td><h4>Circos Plots</h4></td>
                            <td>
                                
                                <c:if test="${ empty additionalGraphic}">
                                     <i>no data</i>
                                </c:if>
                               <c:if test="${not empty additionalGraphic  ||  not empty sessionScope.pdxEditor}">

                                    <c:if test="${not empty sessionScope.pdxEditor}" > 
                                            <input type="submit" name="additionalGraphic" value="add">
                                            <br>
                                    </c:if>
                                                       
                                    <table>
                                        <c:forEach var="graphic" items="${additionalGraphic}" varStatus="status">
                                                <c:choose>
                                                        <c:when test="${status.index%2==0}">
                                                                <tr>
                                                                </c:when>
                                                        </c:choose>
                                                        <td style=" padding:5px;  border:none; vertical-align:top; width:250px">
                                                                <a target="_blank" href="pdxDetailsTabs.do?tab=graphicDetails&contentKey=${graphic.contentKey}&modelID=${modelID}">
                                                                        <img height="250" width="250" src="${applicationScope.pdxFileURL}${graphic.fileName}">
                                                                </a>
                                                                <c:if test="${not empty sessionScope.pdxEditor}">
                                                                        <a href="pdxEditContent.do?contentType=graphic&contentKey=${graphic.contentKey}&modelID=${modelID}" class="linkedButton">
                                                                                <input type="button" value="Edit"/>
                                                                        </a>
                                                                </c:if>
                                                                <br>${graphic.description}
                                                        </td>
                                                        <c:choose>
                                                                <c:when test="${status.index%2==1  || status.last}">
                                                                </tr>
                                                        </c:when>
                                                </c:choose>
                                        </c:forEach>

                                    </table>
                                   
                                </c:if>
                            </td>
                        </tr>   
                        
        </table>
                        </section>
            
                </form>
	</jsp:body>
</jax:mmhcpage>
