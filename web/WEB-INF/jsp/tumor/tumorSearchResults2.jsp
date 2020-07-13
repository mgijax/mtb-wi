<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib uri="http://tumor.informatics.jax.org/mtbwi/MTBWebUtils" prefix="wu" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<%-- !todo --%>
<jax:mmhcpage title="Tumor Search Results">
	<jsp:attribute name="head">
		<link rel="stylesheet" type="text/css" href="./live/www/css/results.css"/>
		<script type="text/javascript" src="./live/www/js/results.js"></script>
		<!-- Combo-handled YUI CSS files: -->
		<link rel="stylesheet" type="text/css" href="http://yui.yahooapis.com/combo?2.7.0/build/reset-fonts-grids/reset-fonts-grids.css&2.7.0/build/base/base-min.css&2.7.0/build/assets/skins/sam/skin.css">
		<!-- Combo-handled YUI JS files: -->
		<script type="text/javascript" src="http://yui.yahooapis.com/combo?2.7.0/build/yahoo-dom-event/yahoo-dom-event.js&2.7.0/build/element/element-min.js&2.7.0/build/paginator/paginator-min.js&2.7.0/build/datasource/datasource-min.js&2.7.0/build/dragdrop/dragdrop-min.js&2.7.0/build/datatable/datatable-min.js&2.7.0/build/resize/resize-min.js"></script>
	</jsp:attribute>
	<jsp:body>
	<table>
		<caption>
			<div class="result-summary">
				<h4>Search Summary</h4>
				<jax:dl dt="Anatomical System of Origin" dd="${anatomicalSystemOriginName}"/>
				<jax:dl dt="Organ/Tissue of Origin" dts="Organs/Tissues of Origin" dds="${organTissueOrigins}" dd="${organOriginName}" />
				<jax:dl dt="Organ/Tissue of Origin" dd="Contains '${organOfOriginName}'"/>
				<jax:dl dt="Tumor Classification" dds="${tumorClassifications}"/>
				<jax:dl dt="Tumor Name" dd="Contains '${tumorName}'"/>
				<jax:dl dt="Treatment Type" dd="${agentType}"/>
				<jax:dl dt="Treatment" dd="${agent}"/>
				<jax:dl dt="Restrict search to metastatic tumors only" test="${not empty metastasisLimit}"/>
				<jax:dl dt="Organ/Tissue Affected" dts="Organs/Tissues Affected" dds="${organsAffected}" dd="${organAffectedName}" />
				<jax:dl dt="Restrict search to entries with associated pathology images" test="${not empty mustHaveImages}"/>
				<jax:dl dt="Genetic Change" dd="${geneticChange}"/>
				<jax:dl dt="Cytogenetic Change" dd="${cytogeneticChange}"/>
				<jax:dl dt="Colony Size" dd="${colonySize}"/>
				<jax:dl dt="Frequency" dd="${frequency}"/>
				<jax:dl dt="Strain" dd="${strainName}"/>
				<jax:dl dt="Strain Family" dd="${strainFamilyName}"/>
				<jax:dl dt="Strain Type" dds="${strainTypes}"/>
				<jax:dl dt="Accession Id" dd="${accId}"/>
				<jax:dl dt="Sort By" dd="${sortBy}"/>
				<jax:dl dt="Display Limit" dd="${maxItems}"/>
			</div>			
			<div class="result-count">
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
			</div>
		</caption>
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
		<caption><div class="yui-skin-sam" id="results-table">There should be stuff here</div></caption>
		</c:when>
		<c:otherwise>
		<!-- No results found. //-->
		</c:otherwise>
		</c:choose>
		<!-- ////  End Results  //// -->
	</table>
	</jsp:body>
</jax:mmhcpage>

