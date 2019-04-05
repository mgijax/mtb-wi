<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Tumor Summary" help="tumorsummary">
	<jsp:attribute name="head">
		<link rel="stylesheet" type="text/css" href="./live/www/css/results.css"/>
		<script type="text/javascript" src="./live/www/js/results.js"></script>
	</jsp:attribute>
	<jsp:body>
	<!-- ////  Top Left (Tumor)  //// -->
	<table id="tumor-info">
		<tr>
			<td><h4>Tumor Name</h4></td>
			<td>
				<h5><c:out value="${tumor.organOfOrigin}" escapeXml="false"/></h5>
				<h5><c:out value="${tumor.tumorClassification}" escapeXml="false"/></h5>
			</td>
		</tr>
		<tr>
			<td><h4>Treatment Type</h4></td>
			<td><c:out value="${tumor.treatmentType}" escapeXml="false"/></td>
		</tr>
		<c:choose>
		<c:when test="${not empty tumor.tumorSynonyms}">
		<tr>
			<c:choose>
			<c:when test="${fn:length(tumor.tumorSynonyms)>1}">
			<td><h4>Tumor Synonyms</h4></td>
			</c:when>
			<c:otherwise>
			<td><h4>Tumor Synonym</h4></td>
			</c:otherwise>
			</c:choose>
			<td>
				<c:forEach var="synonym" items="${tumor.tumorSynonyms}" varStatus="status">
				${synonym.key}
				<c:if test="${status.last != true}">
				&nbsp;&#8226;&nbsp;
				</c:if>
				</c:forEach>
			</td>
		</tr>
		</c:when>
		<c:otherwise>
		<!--There are no synonyms associated with this tumor. //-->
		</c:otherwise>
		</c:choose>
	</table>
	<!-- ////  Top Right (Strain)  //// -->
	<table id="tumor-strain-info">
		<tr>
			<td><h4>Strain</h4></td>
			<td>
				<h5><a href="strainDetails.do?key=${tumor.strainKey}"><c:out value="${tumor.strainName}" escapeXml="false"/></a></h5>
				<c:if test="${not empty tumor.strainTypes}">
				<c:choose>
				<c:when test="${fn:length(tumor.strainTypes)>1}">
				<h5>Strain Types:</h5>
				</c:when>
				<c:otherwise>
				<h5>Strain Type:</h5>
				</c:otherwise>
				</c:choose>
				<ul>
					<c:forEach var="type" items="${tumor.strainTypes}" varStatus="status">
					<li>
						${type.type}
						<c:if test="${status.last != true}">
						&amp;
						</c:if>
					</li>
					</c:forEach>
				</ul>
				</c:if>
				<c:if test="${not empty tumor.strainNote}">
				<h5>General Note:</h5>
				<p>${tumor.strainNote}</p>
				</c:if>
			</td>
		</tr>
		<c:choose>
		<c:when test="${not empty tumor.strainSynonyms}">		
		<tr>
			<td>
				<c:choose>
				<c:when test="${fn:length(tumor.strainSynonyms)>1}">
				<h4>Strain Synonyms</h4>
				</c:when>
				<c:otherwise>
				<h4>Strain Synonym</h4>
				</c:otherwise>
				</c:choose>
			</td>
			<td>
				<c:forEach var="synonym" items="${tumor.strainSynonyms}" varStatus="status">
				<span class="syn"><c:out value="${synonym.name}" escapeXml="false"/></span>
				<c:if test="${status.last != true}">
				&nbsp;&#8226;&nbsp;
				</c:if>
				</c:forEach>
			</td>
		</tr>
		</c:when>
		<c:otherwise>
		<!--There are no synonyms associated with this strain. //-->
		</c:otherwise>
		</c:choose>
	</table>
	<!-- ////  Frequency Records  //// -->
	<c:choose>
	<c:when test="${not empty tumor.frequencyRecs}">
	<table id="tumor-frequency">
		<thead>
			<tr>
				<th class="organ">Organ Affected</th>
				<th>Frequency</th>
				<th>Age Of Detection</th>
				<th>Additional Information</th>
				<th>Reference</th>
			</tr>
		</thead>
		<tbody>
			<c:set var="previousParent" value="-100"/>
			<c:forEach var="rec" items="${tumor.frequencyRecs}" varStatus="status">
				<c:if test="${(status.index == 1) && not empty byExample}">
					<tr><td colspan="11"><h5>Additional tumor frequency records with the same strain, classification and treatment type</h5></td></tr>
				</c:if>
				<c:set var="currentParent" value="${rec.sortOrder}"/>
				<c:set var="parentAttr" value="data-parent=\"${rec.parentFrequencyKey}\""/>
				<c:set var="keyAttr" value="data-key=\"${rec.tumorFrequencyKey}\""/>
			<tr ${keyAttr} ${rec.tumorFrequencyKey != rec.parentFrequencyKey ? parentAttr : '' }>

				<td class="organ">
					<c:out value="${rec.organAffected}" escapeXml="false" default="&nbsp;"/>
				</td>


				<td>
					<c:out value="${rec.frequencyString}" escapeXml="false" default="&nbsp;"/>
					<c:if test="${rec.numMiceAffected>=0&&rec.colonySize>=0}">
					(${rec.numMiceAffected} of ${rec.colonySize} mice)
					</c:if>
				</td>
				
				<td>
					<c:out value="${rec.ageDetection}" escapeXml="false" default="&nbsp;"/>
				</td>
				
				<td class="info">
					<h4 class="repro">${rec.reproductiveStatus}</h4>
					<ul>

					<%-- Check to see if we have pathology information about the tumor --%>
					
					<c:choose>
						<c:when test="${rec.numImages > 0}">
							<li data-detail="pathology"><h5>Pathology Reports <img src=\"${applicationScope.urlImageDir}/pic.gif\"></h5></li>
						</c:when>
						<c:when test="${rec.numImages <= 0 && rec.numPathEntries > 0}">
							<li data-detail="pathology"><h5>Pathology Reports</h5></li>
						</c:when>
					</c:choose>
					
					<%-- Check to see if we have genetic information about the tumor --%>

					<c:if test="${rec.numGenetics > 0}">
						<c:choose>
							<c:when test="${rec.numAssayImages > 0}">
								<li data-detail="genetics"><h5>Genetics <img src=\"${applicationScope.urlImageDir}/pic.gif\"></h5></li>
							</c:when>
							<c:otherwise>
								<li data-detail="genetics"><h5>Genetics</h5></li>
							</c:otherwise>
						</c:choose>
					</c:if>

					<%-- Check to see if we have additional notes about the tumor --%>

					<c:if test="${rec.numNotes>0}">
						<li data-detail="notes"><h5>Additional Notes</h5></li>
					</c:if>


					<c:if test="${not empty rec.note}">
						<li data-detail="tnotes"><h5>Treatment Notes</h5></li>
					</c:if>

					<c:if test="${rec.numSamples > 0}">
						<li data-expression="arrays"><h5>Expression Data</h5></li>
					</c:if>

					</ul>
				</td>
				
				<!--
					${rec.reproductiveStatus}
					${rec.infectionStatus}
					${rec.ageOnset}
				-->
				<td>
					<c:if test="${not empty rec.reference}">
						<a href="referenceDetails.do?accId=${rec.reference}">${rec.reference}</a>
					</c:if>
				</td>
			</tr>
			<c:set var="previousParent" value="${rec.sortOrder}"/>
			</c:forEach>
		</tbody>
	</table>
	</c:when>
	<c:otherwise>
	<!-- There are no tumor frequency records associated with this tumor. -->
	</c:otherwise>
	</c:choose>
	<script type="text/javascript">
		// mods.push('./live/www/js/results.js');
	</script>
	</jsp:body>
</jax:mmhcpage>

