<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Cancer QTL Selection Details">
	<jsp:attribute name="head">
	<style type="text/css">
		.no-icon {
			display : none;
			background-image:'' !important;
		}
	</style>
	<link rel="stylesheet" type="text/css" href="${applicationScope.urlBase}/extjs/resources/css/ext-all.css" />
	<script type="text/javascript" src="${applicationScope.urlBase}/extjs/adapter/ext/ext-base.js"></script>
	<script type="text/javascript" src="${applicationScope.urlBase}/extjs/ext-all.js"></script>
	<script type="text/javascript">
		var treePanel;
		var fTypeMap =	[];
		fTypeMap['all feature types'] =6238159;
		fTypeMap['gene'] = 6238160;
		fTypeMap['protein coding gene'] = 6238161;
		fTypeMap['non-coding RNA gene'] = 6238162;
		fTypeMap['rRNA gene'] = 6238163;
		fTypeMap['tRNA gene'] = 6238164;
		fTypeMap['snRNA gene'] = 6238165;
		fTypeMap['snoRNA gene'] = 6238166;
		fTypeMap['miRNA gene'] = 6238167;
		fTypeMap['scRNA gene'] = 6238168;
		fTypeMap['lincRNA gene'] = 6238169;
		fTypeMap['SRP RNA gene'] = 6238180;
		fTypeMap['RNase P RNA gene'] = 6238181;
		fTypeMap['RNase MRP RNA gene'] = 6238182;
		fTypeMap['telomerase RNA gene'] = 6238183;
		fTypeMap['unclassified non-coding RNA gene'] = 6238186;
		fTypeMap['heritable phenotypic marker'] = 6238170;
		fTypeMap['gene segment'] = 6238171;
		fTypeMap['unclassified gene'] = 6238184;
		fTypeMap['other feature type'] = 6238185;
		fTypeMap['pseudogene'] = 6238172;
		fTypeMap['QTL'] = 6238173;
		fTypeMap['transgene'] = 6238174;
		fTypeMap['complex/cluster/region'] = 6238175;
		fTypeMap['cytogenetic marker'] = 6238176;
		fTypeMap['BAC/YAC end'] = 6238177;
		fTypeMap['other genome feature'] = 6238178;
		fTypeMap['DNA segment'] = 6238179;
		Ext.onReady(function(){
			treePanel = new Ext.tree.TreePanel({
				renderTo:'feature-type-selection',
				height: 100,
				width: 450,
				useArrows:true,
				autoScroll:false,
				autoHeight:true,
				animate:true,
				enableDD:false,
				containerScroll: true,
				rootVisible: true,
				frame: false,
				root: {
					nodeType: 'async',
					text:'all feature types',
					checked:false,
					iconCls:'no-icon'
				},
				// auto create TreeLoader
				dataUrl:'${applicationScope.urlBase}/GViewer/data/featureTypes.json',
				listeners: {
					'checkchange': function(node, checked){
						var i=0, children = node.childNodes;
						for(i; i < children.length; i++){
							children[i].getUI().toggleCheck(checked);
						}
					}
				}
			});
			treePanel.expandAll();
			//	treePanel.collapseAll();
		});
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
		function viewerSubmit(){
			// get the data from the form
			var ch = ${QTLForm.chrom};
			var start = document.forms[1].searchStart.value;
			var end = document.forms[1].searchEnd.value;
			var pheno = document.forms[1].phenotype.value;
			var ontologyKeys = ""
			for(var i = 0; i < document.forms[1].ontology_key.length; i++){
				if(document.forms[1].ontology_key[i].checked){
					ontologyKeys = ontologyKeys + ('&ontology_key='+document.forms[1].ontology_key[i].value);
				}
			}
			var goOp = document.forms[1].go_op.value
			var goTerm = document.forms[1].go_term.value
			var mcvs = '', selNodes = treePanel.getChecked();
			Ext.each(selNodes, function(node){
				if(mcvs.length > 0){
					mcvs += '&';
				}
				mcvs +="mcv="+fTypeMap[node.text];
			});
			window.opener.qtlStore.proxy.setUrl('viewer.do?chromosome='+ch+'&start='+start+'&end='+end
			+'&phenotype='+pheno+'&go_op='+goOp+'&go_term='+goTerm+''+ontologyKeys+"&"+mcvs);
			window.opener.qtlStore.load({add:true});
			window.opener.alert("Loading MGD results.");
		}
	</script>
	</jsp:attribute>
	<jsp:body>
	<table>
		<!-- ////  Start Detail Section  //// -->
		<tr>
			<td colspan="2">
				<table>
					<c:choose>
					<c:when test="${not empty QTLForm.label}">
					<tr>
						<td>
							<h4>QTL</h4>
						</td> 
						<td>
							<a href="http://www.informatics.jax.org/javawi2/servlet/WIFetch?page=markerDetail&id=${QTLForm.mgiId}">${QTLForm.label}</a> (links to MGI detail)
						</td>
					</tr>
					<tr>
						<td>
							<h4>Name</h4>
						</td>
						<td>
							${QTLForm.qtlName}
						</td>
					</tr>								
					</c:when>
					</c:choose>
					<tr>
						<td><h4>Location</h4></td>
						<td>
							<a href="nojavascript.jsp" onClick="popPathWin('http://genome.ucsc.edu/cgi-bin/hgTracks?org=Mouse&position=Chr${QTLForm.chrom}:${QTLForm.qtlStart}-${QTLForm.qtlEnd}');return false;" >${QTLForm.chrom}:${QTLForm.qtlStart}..${QTLForm.qtlEnd}</a> &nbsp; (links to UCSC genome browser) 
							<em>Build 37</em>
						</td>
					</tr>
					<tr>
						<td><h4>Primary Reference</h4></td>
						<td><a href="http://www.informatics.jax.org/searches/reference.cgi?${QTLForm.primeRefId}">${QTLForm.primeRef}</a></td>
					</tr>
					<tr>
						<td><h4>Strain tumor overview</h4></td>
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
		<tr>
			<td colspan="2">
				<table>
					<html:form action="gViewerDetails" method="GET" >
					<tr>
						<td colspan="6">
							<strong>Search for genes within the selected coordinates.</strong>
							<!-- \n -->
							Refine search with the following critera.
							<!-- \n -->
						</td>
					</tr>
					<tr>
						<td><h4>Chromosome</h4></td>
						<td>${QTLForm.chrom}</td>
						<td><h4>Start (bp)</h4></td>
						<td><input type="text" name="searchStart" value="${QTLForm.searchStart}"></td>
						<td><h4>End (bp)</h4></td>
						<td><input type="text" name="searchEnd" value="${QTLForm.searchEnd}"></td>
					</tr>
					<tr>
						<td class ="cat-1">
							Feature Type
						</td>
						<td colspan ="5" id="feature-type-selection"></td>
					</tr>
					<tr>
						<td>
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
						<td>
							Gene Ontology(GO) Classification
						</td>
						<td colspan="5">
							<html:select property="go_op">
							<html:option value="begins">begins</html:option>
							<html:option value="%3D">=</html:option>
							<html:option value="ends">ends</html:option>
							<html:option value="contains">contains</html:option>
							<html:option value="like">like</html:option>
							</html:select>
							<html:text property="go_term" size="40"/>&nbsp;in
							<!-- \n -->
							<html:multibox property="ontology_key" value="Molecular+Function"/>Molecular Function
							<!-- \n -->
							<html:multibox property="ontology_key" value="Biological+Process"/>Biological Process
							<!-- \n -->
							<html:multibox property="ontology_key" value="Cellular+Component"/>Cellular Component
							<!-- \n -->
							<!-- \n -->
							Browse <a href="nojavascript.jsp" onClick="popPathWin('http://www.informatics.jax.org/userdocs/marker_help.shtml#gene_ontology');return false;">Gene Ontology</a>
						</td>
					</tr>
					<tr>
						<td>
							Display Results as
						</td>
						<td colspan="3"> 
							<select size="1" name="display">
								<option value="web">HTML</option>
								<option value="tab">Tab Delimited</option>
							</select>
						</td>
						<td>
							Sort by
						</td>
						<td>
							<html:radio property="sortBy" value="nomen">Nomenclature</html:radio>
							<!-- \n -->
							<html:radio property="sortBy" value="coord">Coordinates</html:radio>
							<!-- \n -->
							<html:radio property="sortBy" value="cm">cM Position</html:radio>
						</td>
					</tr>
					<tr>
						<td>
							<input type="submit" value="Search"/>
							<html:hidden property="chrom"/>
							<html:hidden property="types"/>
							<html:hidden property="label"/>
							<html:hidden property="primeRef"/>
							<html:hidden property="primeRefId"/>
							<html:hidden property="mgiId"/>
							<html:hidden property="qtlName"/>
							<html:hidden property="qtlStart"/>
							<html:hidden property="qtlEnd"/>
							<html:hidden property="featureTypes"/>
						</td>
						<td colspan="5">
							<input type="reset" value="Reset" />
						</td>
					</tr> 
					</html:form>
					<c:choose>
					<c:when test="${not empty features}">
					<tr>
						<td colspan="6"><input type='button' value="Send results to QTL viewer" onclick="viewerSubmit()"></td>
					</tr>
					<tr>
						<td colspan="6">
							<form method="post" action="http://www.informatics.jax.org/javawi2/servlet/WIFetch">
								<input type="hidden" name="page" value="batchSummary"/>
								<input type="hidden" name="IDType" value="MGIMarker" />
								<input type="hidden" name="IDSet" value="${ids}"/>
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
														<tr>
															<td><h4><span class='label'>Gene Attributes:</span></h4></td>
															<td	colspan='4'>
																<table>
																	<tr>
																		<td><input type='checkbox' name='returnSet' value='Nomenclature' checked="checked" />Nomenclature</td>
																		<td><input type='checkbox' name='returnSet' value='Location' checked="checked"/>Genome&nbsp;Location</td>
																	</tr>
																	<tr>
																		<td><input type='checkbox' name='returnSet' value='Ensembl' />Ensembl&nbsp;ID</td>
																		<td><input type='checkbox' name='returnSet' value='EntrezGene' />Entrez&nbsp;Gene&nbsp;ID</td>
																		<td><input type='checkbox' name='returnSet' value='VEGA' />VEGA&nbsp;ID</td>
																	</tr>
																</table>
															</td>
														</tr>
														<tr>
															<td><h4>Additional Information</h4></td>
															<td colsan='4'>
																<table>
																	<tr>
																		<td ><input type='radio' name='returnRad' value='GO' />Gene&nbsp;Ontology&nbsp;(GO)</td>
																		<td colspan="2"><input type='radio' name='returnRad' value='MP' />Mammalian&nbsp;Phenotype&nbsp;(MP)</td>
																	</tr>
																	<tr >
																		<td><input type='radio' name='returnRad' value='omim' />Human Disease (OMIM)</td>
																		<td><input type='radio' name='returnRad' value='MGIAllele' />Alleles</td>
																		<td><input type='radio' name='returnRad' value='RefSNP'/>RefSNP&nbsp;ID</td>
																	</tr>
																	<tr> 
																		<td><input type='radio' name='returnRad' value='UniProt'/>UniProt&nbsp;ID</td>
																		<td><input type='radio' name='returnRad' value='GenBankRefSeq' />GenBank/RefSeq&nbsp;ID</td>
																		<td><input type='radio' name='returnRad' value='None' checked="checked" />None</td>
																	</tr>
																</table>
															</td>
														</tr>
														<tr>
															<td><h4>Format</h4></td>
															<td	colspan='4'>
																<table>
																	<tr>
																		<td>
																			<input name='printFormat' value='toolbar' checked='checked' type='radio'/>Web&nbsp;&nbsp;
																			<span class='example'>(10,000 row max.)</span></td>
																		<td>
																			<input name='printFormat' value='dataDisplay' type='radio'/>Tab-delimited Text&nbsp;&nbsp;
																			<span class='example'>(200,000 row max.)</span></td>
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
						</td>
					</tr>
					<tr> 
						<td colspan="6">
							<table>
								<tr>
									<th>Gene</th>
									<th>Name</th>
									<th>Chromosome:Start..End</th>
									<th>MGI ID</th>
								</tr>
								<c:forEach var="feature" items="${features}" varStatus="count">
								
								<tr>
									<td>${feature.label}</td>
									<td>${feature.name}</td>
									<td>${feature.chromosome}:${feature.start}..${feature.end}</td>
									<td><a href="http://www.informatics.jax.org/javawi2/servlet/WIFetch?page=markerDetail&id=${feature.mgiId}">${feature.mgiId}</a></td>
								</tr>
								</c:forEach>
							</table>
						</td>
						<tr>
						</tr>										
						</c:when>
						<c:when test="${not empty noResults}">
						<td colspan="6">
							<table>
								<tr>
									<th>0 Matching Genes</th>
								</tr>
							</table>
						</td>
						</c:when>
						</c:choose>
					</tr>
				</table>
			</td> 
		</tr>
	</table>
	</jsp:body>
</jax:mmhcpage>
