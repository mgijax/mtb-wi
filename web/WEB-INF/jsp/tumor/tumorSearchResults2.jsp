<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib uri="http://tumor.informatics.jax.org/mtbwi/MTBWebUtils" prefix="wu" %>
<!doctype html>
<!-- Combo-handled YUI CSS files: -->
<link rel="stylesheet" type="text/css" href="http://yui.yahooapis.com/combo?2.7.0/build/reset-fonts-grids/reset-fonts-grids.css&2.7.0/build/base/base-min.css&2.7.0/build/assets/skins/sam/skin.css">
<!-- Combo-handled YUI JS files: -->
<script type="text/javascript" src="http://yui.yahooapis.com/combo?2.7.0/build/yahoo-dom-event/yahoo-dom-event.js&2.7.0/build/element/element-min.js&2.7.0/build/paginator/paginator-min.js&2.7.0/build/datasource/datasource-min.js&2.7.0/build/dragdrop/dragdrop-min.js&2.7.0/build/datatable/datatable-min.js&2.7.0/build/resize/resize-min.js"></script>

<html>
	<head>
<c:set var="pageTitle" scope="request" value="Tumor Search Results"/>
		<c:import url="../../../meta.jsp"/>
	</head>
	
<body>
		<c:import url="../../../body.jsp" />

	
	<div class="wrap">
<nav><c:import url="../../../toolBar.jsp" /></nav>
<section class="main">


<header>
	<h1>${pageTitle}</h1>
	<a class="help" href="userHelp.jsp#tumorresults"></a>
</header>


<table class="results">

<!-- ////  Start Search Summary  //// -->

<tr class="summary">
									<td colspan="11" align="left">
										<span class="label">Search Summary</span>
<!-- \n -->

										
										<c:if test="${not empty anatomicalSystemOriginName}">
											<span class="label">Anatomical System of Origin:</span> ${anatomicalSystemOriginName}
<!-- \n -->

										</c:if>
										
										<c:if test="${not empty organTissueOrigins}">
											<c:choose>
												<c:when test="${fn:length(organTissueOrigins)>1}">
													<span class="label">Organs/Tissues of Origin:</span>
												</c:when>
												<c:otherwise>
													<span class="label">Organ/Tissue of Origin:</span>
												</c:otherwise>
											</c:choose>
											
											<c:forEach var="organ" items="${organTissueOrigins}" varStatus="status">
												<c:choose>
													<c:when test="${status.last != true}">
														${organ},
													</c:when>
													<c:otherwise>
														${organ}
													</c:otherwise>
												</c:choose>
											</c:forEach>
											
<!-- \n -->

										</c:if>
										
										<c:if test="${not empty organOriginName}">
											<span class="label">Organ/Tissue of Origin:</span> ${organOriginName}
<!-- \n -->

										</c:if>
											
										<c:if test="${not empty organOfOriginName}">
											<span class="label">Organ/Tissue of Origin:</span> Contains "${organOfOriginName}"
<!-- \n -->

										</c:if>
											
										<c:if test="${not empty tumorClassifications}">
											<c:choose>
												<c:when test="${fn:length(tumorClassifications)>1}">
													<span class="label">Tumor Classifications:</span>
												</c:when>
												<c:otherwise>
													<span class="label">Tumor Classification:</span>
												</c:otherwise>
											</c:choose>
											
											<c:forEach var="classification" items="${tumorClassifications}" varStatus="status">
												<c:choose>
													<c:when test="${status.last != true}">
														${classification},
													</c:when>
													<c:otherwise>
														${classification}
													</c:otherwise>
												</c:choose>
											</c:forEach>
											
<!-- \n -->

										</c:if>
										
										<c:if test="${not empty tumorName}">
											<span class="label">Tumor Name:</span> Contains "${tumorName}"
<!-- \n -->

										</c:if>
										
										<c:if test="${not empty agentType}">
											<span class="label">Treatment Type:</span> ${agentType}
<!-- \n -->

										</c:if>
										
										<c:if test="${not empty agent}">
											<span class="label">Treatment:</span>	Contains "${agent}"
<!-- \n -->

										</c:if>
										
										<c:if test="${not empty metastasisLimit}">
											<span class="label">Restrict search to metastatic tumors only.</span>
<!-- \n -->

										</c:if>
										
										<c:if test="${not empty organsAffected}">
											<c:choose>
												<c:when test="${fn:length(organsAffected)>1}">
													<span class="label">Organs/Tissues Affected:</span>
												</c:when>
												<c:otherwise>
													<span class="label">Organ/Tissue Affected:</span>
												</c:otherwise>
											</c:choose>
											
											<c:forEach var="organ" items="${organsAffected}" varStatus="status">
												<c:choose>
													<c:when test="${status.last != true}">
														${organ},
													</c:when>
													<c:otherwise>
														${organ}
													</c:otherwise>
												</c:choose>
											</c:forEach>
											
<!-- \n -->

										</c:if>
										
										<c:if test="${not empty organAffectedName}">
											<span class="label">Organ/Tissue Affected:</span> ${organAffectedName}
<!-- \n -->

										</c:if>
										
										
										<c:if test="${not empty mustHaveImages}">
											<span class="label">Restrict search to entries with associated pathology images.</span>
<!-- \n -->

										</c:if>
										
										<c:if test="${not empty geneticChange}">
											<span class="label">Genetic Change:</span> ${geneticChange}
<!-- \n -->

										</c:if>
										
										<c:if test="${not empty cytogeneticChange}">
											<span class="label">Cytogenetic Change:</span> ${cytogeneticChange}
<!-- \n -->

										</c:if>
										
										<c:if test="${not empty colonySize}">
											<span class="label">Colony Size:</span> ${colonySize}
<!-- \n -->

										</c:if>
										
										<c:if test="${not empty frequency}">
											<span class="label">Frequency:</span> ${frequency}
<!-- \n -->

										</c:if>
										
										<c:if test="${not empty strainName}">
											<span class="label">Strain:</span> ${strainName}
<!-- \n -->

										</c:if>
										
										<c:if test="${not empty strainFamilyName}">
											<span class="label">Strain Family:</span> ${strainFamilyName}
<!-- \n -->

										</c:if>
										
										<c:if test="${not empty strainTypes}">
											<c:choose>
												<c:when test="${strainTypesSize>'1'}">
													<span class="label">Strain Types:</span>
												</c:when>
												<c:otherwise>
													<span class="label">Strain Type:</span>
												</c:otherwise>
											</c:choose>
											
											<c:forEach var="strainType" items="${strainTypes}" varStatus="status">
												<c:choose>
													<c:when test="${status.last != true}">
														${strainType},
													</c:when>
													<c:otherwise>
														${strainType}
													</c:otherwise>
												</c:choose>
											</c:forEach>
											
<!-- \n -->

										</c:if>
										
										<c:if test="${not empty accId}">
											<span class="label">Accession Id:</span> ${accId}
<!-- \n -->

										</c:if>
										
										<span class="label">Sort By:</span> ${sortBy}
<!-- \n -->

										<span class="label">Display Limit:</span> ${maxItems}
									</td>
								</tr>
								<tr class="summary">
									<td colspan="11">

<!-- ////  Start Display Limit  //// -->

<c:choose>
											<c:when test="${numberOfResults != totalResults}">
												<c:choose>
													<c:when test="${numberOfResults==1}">
														<c:choose>
															<c:when test="${tumorFrequencyRecords==1}">
																${numberOfResults} unique tumor instance representing ${tumorFrequencyRecords} tumor frequency record returned.
															</c:when>
															<c:otherwise>
																${numberOfResults} unique tumor instances (of ${totalResults} total) representing ${tumorFrequencyRecords} tumor frequency records returned.
															</c:otherwise>
														</c:choose>
													</c:when>
													<c:otherwise>
														<c:choose>
															<c:when test="${tumorFrequencyRecords==1}">
																${numberOfResults} unique tumor instances (of ${totalResults} total) representing ${tumorFrequencyRecords} tumor frequency record returned.
															</c:when>
															<c:otherwise>
																${numberOfResults} unique tumor instances (of ${totalResults} total) representing ${tumorFrequencyRecords} tumor frequency records returned.
															</c:otherwise>
														</c:choose>
													</c:otherwise>
												</c:choose>
											</c:when>
											<c:otherwise>
												<c:choose>
													<c:when test="${numberOfResults==1}">
														<c:choose>
															<c:when test="${tumorFrequencyRecords==1}">
																${numberOfResults} unique tumor instance representing ${tumorFrequencyRecords} tumor frequency record returned.
															</c:when>
															<c:otherwise>
																${numberOfResults} unique tumor instances representing ${tumorFrequencyRecords} tumor frequency records returned.
															</c:otherwise>
														</c:choose>
													</c:when>
													<c:otherwise>
														<c:choose>
															<c:when test="${tumorFrequencyRecords==1}">
																${numberOfResults} unique tumor instances representing ${tumorFrequencyRecords} tumor frequency record returned.
															</c:when>
															<c:otherwise>
																${numberOfResults} unique tumor instances representing ${tumorFrequencyRecords} tumor frequency records returned.
															</c:otherwise>
														</c:choose>
													</c:otherwise>
												</c:choose>
											</c:otherwise>
										</c:choose>

<!-- ////  End Display Limit  //// -->

</td>
								</tr>

<!-- ////  End Search Summary  //// -->

<!-- ////  Start Results  //// -->

<c:choose>
									<c:when test="${not empty tumors}">
										<script type="text/javascript" >
											YAHOO.util.Event.addListener(window, "load", function() { 
												buildTable = new function() { 
													var resultsDataSource = new YAHOO.util.LocalDataSource( [
															<c:forEach var="tumor" items="${tumors}" varStatus="status">
														{tumorname:"<c:out value="${tumor.tumorName}" escapeXml="false"/>",
															organ:"<c:out value="${tumor.organAffectedName}" escapeXml="false"/>",
															agent:["<c:out value="${tumor.treatmentType}" escapeXml="false"/>"
																	<c:if test="${(not empty tumor.agentsCollection) && (fn:length(tumor.agentsCollection) > 0)}">
																	<c:forEach var="agentInfo" items="${tumor.agentsCollection}" varStatus="status">
																	<c:if test="${(not empty agentInfo) && (fn:length(agentInfo) > 0)}">,"<c:out value="${agentInfo}" escapeXml="false"/>"
																	</c:if>
																	</c:forEach>
																	</c:if>],strain:["<c:out value="${tumor.strainKey}"/>"
																,"<c:out value="${tumor.strainName}" escapeXml="false"/>"<c:if test="${not empty tumor.strainTypesCollection}"><c:forEach var="strainType" items="${tumor.strainTypesCollection}" varStatus="status">,"${strainType}"
																	</c:forEach>
																	</c:if>],
															f:"<c:out value="${tumor.freqFemaleString}" escapeXml="false" default="&nbsp;"/>",
															m:"<c:out value="${tumor.freqMaleString}" escapeXml="false" default="&nbsp;"/>",
															mixed:"<c:out value="${tumor.freqMixedString}" escapeXml="false" default="&nbsp;"/>",
															unk:"<c:out value="${tumor.freqUnknownString}" escapeXml="false" default="&nbsp;"/>",
															mets:<c:choose>
																<c:when test="${not empty tumor.metastasizesToDisplay}">"<c:forEach var="organ" items="${tumor.metastasizesToDisplay}" varStatus="status">${organ}<c:if test="${status.last != true}">
<!-- \n -->
</c:if>
																</c:forEach>",
																</c:when>
																<c:otherwise>"",</c:otherwise>
																</c:choose>
																image:<c:choose><c:when test="${tumor.images==true}">"image",</c:when>
																<c:otherwise>"",</c:otherwise>
																</c:choose>
																summary:"tumorSummary.do?strainKey=${tumor.strainKey}&amp;organOfOriginKey=${tumor.organOfOriginKey}&amp;tumorFrequencyKeys=${tumor.allTFKeysAsParams}",},
																</c:forEach>
															]);
		
														resultsDataSource.responseType = YAHOO.util.DataSource.TYPE_JSARRAY; 
														resultsDataSource.responseSchema = {fields:["tumorname","organ","agent","strain","f","m","mixed","unk","mets","image","summary"]};
														var linkFormat = function(elCell, oRecord, oColumn, oData){
															var ref = oData;
															elCell.innerHTML = '<a href="'+ref+'">Summary</a>';
														}
														var strainFormat = function(elCell, oRecord, oColumn, oData){
															var data = oData;
															elCell.innerHTML = '<a href="strainDetails.do?key='+data[0]+'">'+data[1]+'</a>';
															for(i=2; i<data.length; i++){
																if(i==2){
																	elCell.innerHTML = elCell.innerHTML+"
<!-- \n -->
"+data[i];
																}else{
																	elCell.innerHTML = elCell.innerHTML+", "+data[i];
																}
															}
														}
														var columnDefs = [{key:"tumorname",label:"Tumor Name", width:200, sortable:true,resizeable:true},
															{key:"organ",label:"Organ", width:200, sortable:true,resizeable:true},
															{key:"agent",label:"Agent", width:200, sortable:true,resizeable:true},
															{key:"strain",label:"Strain", formatter:strainFormat, width:300, sortable:true,resizeable:true},
															{label:"Tumor Frequency Range", children:[{key:"f",label:"F", width:60},
																	{key:"m",label:"M", width:60, sortable:true},
																	{key:"mixed",label:"Mixed", width:60, sortable:true},
																	{key:"unk",label:"Unk.", width:60, sotrable:true}],resizeable:true},
															{key:"mets",label:"Metastasizes
<!-- \n -->
to",width:100,resizeable:true},
															{key:"image",label:"Images",width:60,resizeable:true},
															{key:"summary",label:"Summary", formatter:linkFormat, width:100,resizeable:true},
														];
										
														var columnDefs2 = [{key:"tumorname",label:"Tumor Name", width:200, sortable:true,resizeable:true},
															{key:"organ",label:"Organ", width:200, sortable:true,resizeable:true},
															{key:"agent",label:"Agent", width:200, sortable:true,resizeable:true},
														];
										
														var tableConfigs = {paginator : new YAHOO.widget.Paginator({rowsPerPage:35}) };

										
														var dataTable = new YAHOO.widget.DataTable("resultsTable",columnDefs,resultsDataSource,tableConfigs);
		
		
														YAHOO.widget.DataTable.prototype.getTdEl = function(cell) {

															var Dom = YAHOO.util.Dom,

															lang = YAHOO.lang,
															elCell,
															el = Dom.get(cell);

															// Validate HTML element
															if(el && (el.ownerDocument == document)) {

																// Validate TD element
																if(el.nodeName.toLowerCase() != "td") {

																	// Traverse up the DOM to find the corresponding TR element
																	elCell = Dom.getAncestorByTagName(el, "td");

																}
																else {

																	elCell = el;

																}

																// Make sure the TD is in this TBODY
																if(elCell && (elCell.parentNode.parentNode == this._elTbody)) {

																	// Now we can return the TD element
																	return elCell;

																}

															}
															else if(cell) {

																var oRecord, nColKeyIndex;

																if(lang.isString(cell.columnKey) && lang.isString(cell.recordId)) {

																	oRecord = this.getRecord(cell.recordId);
																	var oColumn = this.getColumn(cell.columnKey);
																	if(oColumn) {

																		nColKeyIndex = oColumn.getKeyIndex();

																	}

																}
																if(cell.record && cell.column && cell.column.getKeyIndex) {

																	oRecord = cell.record;
																	nColKeyIndex = cell.column.getKeyIndex();

																}
																var elRow = this.getTrEl(oRecord);
																if((nColKeyIndex !== null) && elRow && elRow.cells && elRow.cells.length > 0) {

																	return elRow.cells[nColKeyIndex] || null;

																}

															}

															return null;

														};
		
		
		
														return {
															oDS: resultsDataSource,
															oDT: dataTable
														}
													}();
												});
										</script>
										<tr class="summary"><td><div class="yui-skin-sam" id="results-table">There should be stuff here</div></td></tr>
									</c:when>
									<c:otherwise>
										<!-- No results found. //-->
									</c:otherwise>
								</c:choose>

<!-- ////  End Results  //// -->

</table>


</section>
</div>
</body>
</html>


