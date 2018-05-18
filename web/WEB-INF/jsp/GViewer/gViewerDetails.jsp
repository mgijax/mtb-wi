<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib uri="http://tumor.informatics.jax.org/mtbwi/MTBWebUtils" prefix="wu" %>
<!doctype html>
<html>
	<head>
		<c:import url="../../../meta.jsp">
			<c:param name="pageTitle" value="GViewer Details"/>
		</c:import>
		<style type="text/css">
			.no-icon {
				display : none;
				background-image:'' !important;
			}
		</style>
		<link rel="stylesheet" type="text/css" href="${applicationScope.urlBase}/extjs/resources/css/ext-all.css" />
		<script type="text/javascript" src="${applicationScope.urlBase}/extjs/adapter/ext/ext-base.js"></script>
		<script type="text/javascript" src="${applicationScope.urlBase}/extjs/ext-all.js"></script>
		<script type="text/javascript" src="${applicationScope.urlBase}/GViewer/javascript/Karyotype-canvas.js"></script>
		<script type="text/javascript" src="${applicationScope.urlBase}/GViewer/javascript/PagingStore.js"></script>
		<script type="text/javascript" src="${applicationScope.urlBase}/GViewer/javascript/FeatureGrid.js"></script>
	</head>
	
<body>
		<c:import url="../../../body.jsp" />

	
	<script type="text/javascript">
		
		var loadViewerWinAttempts =0;
		var treePanel,qtlStore, karyoPanel, featureGrid, viewerWin, sourceFeature;
		var UCSCBandLink='http://genome.ucsc.edu/cgi-bin/hgTracks?org=Mouse&position=';
	 
		Ext.onReady(function(){
			
			qtlStore = new Ext.ux.data.PagingXmlStore({
				autoDestroy: true,
				url:'toConfigureProxy',
				record: 'feature', 
				autoLoad: false,
				autoSave:false,
				fields: [
					'chromosome',
					'start',
					'end',
					'type',
					'color',
					'description',
					'link',
					'mgiid',
					'name',
					'group',
					'track'
				]	
			});	
			
				FeatureRecord = Ext.data.Record.create([
				{name:'chromosome'},
				{name:'start'},
				{name:'end'},
				{name:'type'},
				{name:'color'},
				{name:'description'},
				{name:'link'},
				{name:'mgiid'},
				{name:'name'},
				{name:'group'},
				{name:'track'}
			]);
			
			 sourceFeature = new FeatureRecord({
						chromosome:${QTLForm.chrom},
						start:${QTLForm.qtlStart},
						end:${QTLForm.qtlEnd},
						type:'user created',
						color:'blue',
						description:'${QTLForm.label}',
						link:'',
						mgiid:'',
						name:'${QTLForm.qtlName}',
						group:'',
						track:'L1'
					});
					
		 
				
			karyoPanel = new org.jax.mgi.kmap.KaryoPanel({
				id:'kp',
				bandingFile:'viewer.do?method=getBands&chromosome=${QTLForm.chrom}',
				maxKaryoSize:150,
				bandLink:UCSCBandLink,
				localLink:'',
				chromosomeWidth:11,
				featureGap:2,
				fCanvasHeight:250,
				fCanvasWidth:20,
				renderTo:'viewer',
				bandMaskDiv:'viewer',
				boxMaxHeight:300,
				maxBoxWidth:600,
				minWidth:300
			});
			
			karyoPanel.on({'afterBuild':setKPanelWidth, scope:this});
			
			karyoPanel.setFeatureStore(qtlStore);
			karyoPanel.doLayout();
			karyoPanel.loadBands();
			karyoPanel.getTopToolbar().hide();
			karyoPanel.getBottomToolbar().hide();
	
			featureGrid = new org.jax.mgi.kmap.FeatureGrid({
				editable:false,
				hideTopToolbar:true,
				kPanel:karyoPanel,
				localLink:'',
				viewConfig:{autoFill:true, forceFit:true, markDirty:false},
				tbar: new Ext.Toolbar({}),
				bbar: new Ext.PagingToolbar({			
					displayInfo: true,
					pageSize:5,
					prependButtons: true
				}),
				renderTo:'grid',
				fixedWidth:true,
				width:900
			});

			treePanel = new Ext.tree.TreePanel({
				renderTo:'featureTypeSelection',
				height: 100,
				width: 450,
				useArrows:true,
				autoScroll:false,
				autoHeight:true,
				animate:false,
				enableDD:false,
				containerScroll: true,
				rootVisible: false,
				frame: false,
				root: {
					nodeType: 'async',
					text:'root',
					id:'0',
					checked:false,
					iconCls:'no-icon'
				},
				
				// auto create TreeLoader
				dataUrl:'gViewerDetails.do?featureTypes=json',
				
				listeners: {
					'checkchange': function(node, checked){
						var i=0, children = node.childNodes;
						for(i; i < children.length; i++){
							children[i].getUI().toggleCheck(checked);
						}
						var mcvs ='',selNodes = treePanel.getChecked();;
						Ext.each(selNodes, function(node){
							if(mcvs.length > 0){
								mcvs += ',';
							}
							mcvs +=node.id;
						});
						document.forms[1].featureTypes.value = mcvs;
					}
				}
			});

			function setKPanelWidth(){
				karyoPanel.setWidth(300);
				qtlStore.add(sourceFeature);
			}
			
			hideFeatureOptions();
			
			
		});

		function buildURL(){
			// get the data from the form
			var ch = '${QTLForm.chrom}';
			var start = document.forms[1].searchStart.value;
			var end = document.forms[1].searchEnd.value;
			var pheno = document.forms[1].phenotype.value;
			var ontologyKeys = ""
			for(var i = 0; i < document.forms[1].ontology_key.length; i++){
				if(document.forms[1].ontology_key[i].checked){
					ontologyKeys = ontologyKeys + ('&ontology_key='+document.forms[1].ontology_key[i].value);
				}
			}
			var sort ="nomen";
			
					
			var goOp = document.forms[1].go_op.value;
			var goTerm = document.forms[1].go_term.value;
			var display = document.forms[1].display.value;
			var mcvs = document.forms[1].featureTypes.value;
		 
	
			var name = document.forms[1].gsmname_term.value;
			var nameOp = document.forms[1].gsmname_op.value;
			mcvs = mcvs.replace(/,/g,"&mcv=");
			var url = 'viewer.do?method=getMGIFeatures&chromosome='+ch+'&start='+start+'&end='+end+'&gsmname_term='+name+'&gsmname_op='+nameOp+
				'&phenotype='+pheno+'&go_op='+goOp+'&go_term='+goTerm+ontologyKeys+"&mcv="+mcvs+"&display="+display+"&sort="+sort;
		 
		 
			return url;
		}
			
		function loadMGI(){
			
		 var url = buildURL();
		 if(document.forms[1].display.value == "tab"){
				 window.location = url;
				 return false;
		 }
			
			qtlStore.removeAll();
			
			
			qtlStore.proxy.setUrl(buildURL());
			qtlStore.add(sourceFeature);
			qtlStore.load({add:true, callback:setBatchIds});
			
		
			return false;	
		}
	 
		function setBatchIds(){
			document.batch.ids.value = qtlStore.collect('mgiid').join(' ');
			if(document.batch.ids.value.length > 2){
				showFeatureOptions();
			}
		}
	 
		function viewerSubmit(){
			if(!viewerWin || viewerWin.closed){
				viewerWin = window.opener;
				if(!viewerWin || viewerWin.closed){
					viewerWin = window.open("viewer.do");
				}
			}
			loadViewerWinAttempts = 0;
			loadViewerWin();
		}
			
		// can't access qtlStore untill the new window has loaded
		// try upto 10 times at 3 second intervals
		function loadViewerWin(){
			loadViewerWinAttempts++;
			var url = buildURL();
			url = url + "&linkTo=details";
			try{ 
				viewerWin.qtlStore.proxy.setUrl(url);
				viewerWin.qtlStore.load({add:true});
				viewerWin.alert("Loading MGD results.");
			}catch(e){
				if(loadViewerWinAttempts < 10){
					setTimeout("loadViewerWin()",3000);
				}else{
					alert("Unable to load QTL viewer");
				}
			} 
		}
	 
		function showFeatureOptions(){
			document.getElementById("batch-div").style.display="block";
			document.getElementById("viewerSubmitDiv").style.display="block";
		}
		
		function hideFeatureOptions(){
			document.getElementById("batch-div").style.display="none";
			document.getElementById("viewerSubmitDiv").style.display="none";
		}
	
		function batchSwap() {
			changeVisibility("summary");
			changeVisibility("params");
		}

		function changeVisibility(id) {

			var myID = document.getElementById(id);

			if (myID.style.display == "block"){
				myID.style.display = "none";
			} else {
				myID.style.display = "block";
			}
		}

		function clearFeatures(){
			qtlStore.removeAll(); 
			karyoPanel.setWidth(300);
			hideFeatureOptions();
		}
		
		
		var aboutGSMWindow = null;
		function aboutGMS(){
						if(aboutGSMWindow == null){
								aboutGSMWindow = new Ext.Window({
										title:'Gene Marker Symbol Name Search',
										layout:'fit',
										width:320,
										height:200,
										closeAction:'hide',
										plain: true,
										html:"Nomenclature searches will search current gene symbols
<!-- \n -->
"+
												"as well as synonyms of both mouse and human genes.
<!-- \n -->
"+
												"This may result in search results that appear to be incorrect.
<!-- \n -->

<!-- \n -->
"+
												"For example, a search for genes that begin with &quot;Apc&quot; on
<!-- \n -->
"+
												"mouse chromosome 18 in the Mom3 QTL region will return
<!-- \n -->
Proc and Cdc23 in addition to Apc and Apcdd1.
<!-- \n -->
"+
												"This is because the human synonym for Proc is APC and the
<!-- \n -->
human synonym for Cdc23 is APC8.</strong>"
							
								});
						}
						aboutGSMWindow.show(); 
				};
		
		
		
	</script>
	<body class="alt">
<div class="wrap">
<nav><c:import url="../../../toolBar.jsp" /></nav>
<section class="main">

<header>
	<h1>Cancer &nbsp; QTL &nbsp; Selection &nbsp; Details</h1>
	<a class="help" href="userHelp.jsp#GViewerDetails"></a>
</header>

<table class="results">

<!-- ////  Start Detail Section  //// -->

<tr class="stripe-1">
									<td colspan="2">
										<table width="560">	
											<c:choose>
												<c:when test="${not empty QTLForm.mgiId}">
													<tr class="stripe-2">
														<td class="cat-2">
															QTL
														</td> 
														<td>
															<a href="http://www.informatics.jax.org/javawi2/servlet/WIFetch?page=markerDetail&id=${QTLForm.mgiId}">${QTLForm.label}</a> &nbsp; (links to MGI detail)
														</td>
													</tr>
													<tr class="stripe-1">
														<td class="cat-1">
															Name
														</td>
														<td>
															${QTLForm.qtlName}
														</td>
													</tr>								
												</c:when>
											</c:choose>
											<tr class="stripe-2">
												<td class="cat-2">Location</td>
												<td><a href="nojavascript.jsp" onClick="popPathWin('http://jbrowse.informatics.jax.org/?data=data%2Fmouse&loc=chr${QTLForm.chrom}:${QTLForm.qtlStart}..${QTLForm.qtlEnd}&tracks=DNA%2CMGI_Genome_Features%2CNCBI%2CENSEMBL%2CHAVANA_VEGA%2CMGI_QTL');return false;">${QTLForm.chrom}:${QTLForm.qtlStart}..${QTLForm.qtlEnd}</a> &nbsp; (links to MGI Genome Browser) 
<!-- \n -->
 <em>Build 38</em> </td>
											</tr>
											<c:choose>
												<c:when test ="${not empty QTLForm.primeRefId}">
													<tr class="stripe-1">
														<td class="cat-1">Primary Reference</td>
														<td><a href="http://www.informatics.jax.org/reference/${QTLForm.primeRef}">${QTLForm.primeRef}</a></td>
													</tr>
												</c:when>
											</c:choose>
											<tr class="stripe-2">
												<td class="cat-2">Strain tumor overview</td>
												<td>
													<c:choose>
														<c:when test="${not empty strains}">
															<c:forEach var="strain" items="${strains}" varStatus="count">
																<c:choose>
																	<c:when test="${not empty strain.value}">
																		<a href='strainDetails.do?page=collapsed&key=${strain.value}'>${strain.label}</a>
																	</c:when>
																	<c:otherwise>
																		${strain.label}&nbsp;
																	</c:otherwise>
																</c:choose>
															</c:forEach>
														</c:when>
														<c:otherwise>
															No associated strains
														</c:otherwise>
													</c:choose>
												</td>
											</tr>
										</table>
									</td>
								</tr>
								<tr class="stripe-1">
									<td>
										<table width="280">
											<tr><td id="viewer"></td></tr>
										</table>
									</td>
									<td>
										<table width="280">
											<html:form action="gViewerDetails" method="GET" onsubmit="return loadMGI()">
												<tr>
													<td colspan="6">
														<strong>Search for features within the selected coordinates.</strong>
														
<!-- \n -->

														Refine search with the following criteria.
<!-- \n -->

													</td>
												</tr>
												<tr class="stripe-2">
													<td class="cat-2">Chromosome</td>
													<td>${QTLForm.chrom}</td>
													<td class="cat-2">Start (bp)</td>
													<td><input type="text" name="searchStart" value="${QTLForm.searchStart}"></td>
													<td class="cat-2">End (bp)</td>
													<td><input type="text" name="searchEnd" value="${QTLForm.searchEnd}"></td>
												</tr>
												<tr class="stripe-1">
													<td class ="cat-1">
														Feature Type
													</td>
													<td colspan ="5" id="feature-type-selection"></td>
												</tr>
												<tr class="stripe-2">
														<td class="cat-2">
																Gene/Marker
<!-- \n -->
Symbol/Name
														</td>
														<td colspan="5">
														 <html:select property="gsmname_op">
															<html:option value="begins">begins</html:option>
															<html:option value="%3D">=</html:option>
															<html:option value="ends">ends</html:option>
															<html:option value="contains">contains</html:option>
															<html:option value="like">like</html:option>
														</html:select>
														
														<html:text property="gsmname_term" size="40"/>
														&nbsp;&nbsp;&nbsp;
																<input type="button" value="Help" onclick="javascript:aboutGMS();">
														</td>
												</tr>
												<tr class="stripe-1">
													<td class="cat-1">
														Mouse phenotypes & mouse models of human disease
													</td>
													<td colspan="5">
														<em>Enter any combination of phenotype terms, disease terms, or IDs </em>
<!-- \n -->

														<html:textarea property="phenotype" rows="2" cols="50"/>
														
<!-- \n -->

														Browse <a href="nojavascript.jsp" onClick="popPathWin('http://www.informatics.jax.org/searches/MP_form.shtml');return false;">Mammalian Phenotype Ontology (MP)</a>
														
<!-- \n -->

														Browse <a href="nojavascript.jsp" onClick="popPathWin('http://www.informatics.jax.org/javawi2/servlet/WIFetch?page=omimVocab&subset=A');return false;">Human Disease Vocabulary (OMIM)</a>
													</td>
												</tr>
												<tr	class="stripe-2">
													<td class="cat-2">
														Gene Ontology(GO) Classification
													</td>
													<td colspan="5">
															
<!-- \n -->

														<html:select property="go_op">
															<html:option value="begins">begins</html:option>
															<html:option value="%3D">=</html:option>
															<html:option value="ends">ends</html:option>
															<html:option value="contains">contains</html:option>
															<html:option value="like">like</html:option>
														</html:select>
														
														<html:text property="go_term" size="40"/>&nbsp;in
<!-- \n -->

<!-- \n -->

														<html:multibox property="ontology_key" value="Molecular+Function"/>Molecular Function
<!-- \n -->

														<html:multibox property="ontology_key" value="Biological+Process"/>Biological Process
<!-- \n -->

														<html:multibox property="ontology_key" value="Cellular+Component"/>Cellular Component
<!-- \n -->

														
<!-- \n -->

														Browse <a href="nojavascript.jsp" onClick="popPathWin('http://www.informatics.jax.org/searches/GO_form.shtml');return false;">Gene Ontology</a>
													</td>
												</tr>
												<tr class="stripe-1">
													<td class="cat-1">
														Display Results as
													</td>
													<td colspan="3"> 
														<select size="1" name="display">
															<option value="web">Table</option>
															<option value="tab">Tab Delimited</option>
														</select>
													</td>
													
													<td align="right" colspan="2">
														<input type="submit" value="Search"/>
														<html:hidden property="featureTypes"/>
														<html:hidden property="chrom"/>
														<html:hidden property="types"/>
														<html:hidden property="label"/>
														<html:hidden property="primeRef"/>
														<html:hidden property="primeRefId"/>
														<html:hidden property="mgiId"/>
														<html:hidden property="qtlName"/>
														<html:hidden property="qtlStart"/>
														<html:hidden property="qtlEnd"/>
													</td>
												</tr> 
											</html:form>
										</table>
									</td>
								</tr>
								<tr class="stripe-1">
									<td colspan="2">
										<table width="560">
											<tr><td id="grid"></td></tr>
											<tr>
												<td colspan="6"><div id="viewer-submit-div"><input type='button' value="Send results to QTL viewer" onclick="viewerSubmit()"></div></td>
											</tr>
											<tr>
												<td colspan="6">
													<div id="batch-div">
													<form method="get" name="batch" action="http://www.informatics.jax.org/batch/summary" >
													 
														<input type="hidden" name="idType" value="auto" />
														<input type="hidden" name="ids" value="${ids}"/>
														<input type="submit" value="Submit results to MGI Batch Query"/> 
														<div id='params' style='display: none;'>
															<table>
																<tbody>
																	<tr>
																		<a href='#'	onclick='batchSwap()' class='example'>Hide batch query parameters</a>
																	</tr>
																	<tr>
																		<td>
																			<table>
																				<tr class="stripe-2">
																					<td class="cat-2"><span class='label'>Gene Attributes:</span></td>		
																					<td	colspan='4'>
																						<table>
																							<tr>
																								<td><input type='checkbox' name='attributes' value='Nomenclature' checked="checked" />Nomenclature</td>
																								<td><input type='checkbox' name='attributes' value='Location' checked="checked"/>Genome&nbsp;Location</td>
																							</tr>
																							<tr>
																								<td><input type='checkbox' name='attributes' value='Ensembl' />Ensembl&nbsp;ID</td>
																								<td><input type='checkbox' name='attributes' value='EntrezGene' />Entrez&nbsp;Gene&nbsp;ID</td>
																								<td><input type='checkbox' name='attributes' value='VEGA' />VEGA&nbsp;ID</td>
																							</tr>
																						</table>
																					</td>
																				</tr>
																				<tr class="stripe-1">
																				<td class="cat-1">Additional Information</td>
																				<td colsan='4'>
																					<table>
																						<tr>
																							<td ><input type='radio' name='association' value='GO' />Gene&nbsp;Ontology&nbsp;(GO)</td>
																							<td colspan="2"><input type='radio' name='association' value='MP' />Mammalian&nbsp;Phenotype&nbsp;(MP)</td>
																						</tr>
																						<tr >
																							<td><input type='radio' name='association' value='omim' />Human Disease (OMIM)</td>
																							<td><input type='radio' name='association' value='MGIAllele' />Alleles</td>
																							<td><input type='radio' name='association' value='RefSNP'/>RefSNP&nbsp;ID</td>
																						</tr>
																						<tr> 
																							<td><input type='radio' name='association' value='UniProt'/>UniProt&nbsp;ID</td>
																							<td><input type='radio' name='association' value='GenBankRefSeq' />GenBank/RefSeq&nbsp;ID</td>
																							<td><input type='radio' name='association' value='None' checked="checked" />None</td>
																						</tr>
																					</table>
																				</td>
																				
																				</tr>
																			</table>
																		</td>
																	</tr>
																</tbody>
															</table>
														</div>
														<div id="summary" style="display: block" >
															<a href='#' onclick='batchSwap()' class='example'>Modify batch query parameters</a>
														</div>
													</form>
												</div>
												</td>
											</tr>
										</table>
									</td> 
								</tr>
							</table>


</section>
</div>
</html>

</body>