<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib uri="http://tumor.informatics.jax.org/mtbwi/MTBWebUtils" prefix="wu" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>

<jax:mmhcpage title="Tumor Summary" help="tumorsummary">

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
			<th>MTB ID</th>
			<th>Organ Affected</th>
			<th>Treatment Type <em>Agents</em></th>
			<th>Strain Sex</th>
			<th>Reproductive Status</th>
			<th>Infection Status</th>
			<th>Frequency</th>
			<th>Age Of Onset</th>
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
		<c:choose>
		<c:when test="${currentParent!=previousParent}">
		<c:set var="previousParent" value="${rec.sortOrder}"/>
		</c:when>
		<c:otherwise>
		</c:otherwise>
		</c:choose>
		<tr>
			<td class="${rec.tumorFrequencyKey != rec.parentFrequencyKey ? 'hilite' : ''}">
				MTB:${rec.tumorFrequencyKey}
				<c:if test="${rec.tumorFrequencyKey!=rec.parentFrequencyKey}">
				<em>(metastasis from MTB:${rec.parentFrequencyKey})</em>
				</c:if>
			</td>
			<td><c:out value="${rec.organAffected}" escapeXml="false" default="&nbsp;"/></td>
			<td>
				<c:out value="${tumor.treatmentType}" escapeXml="false"/>
				<c:if test="${not empty rec.sortedAgents}">
				<ul class="agents">
					<c:forEach var="agent" items="${rec.sortedAgents}" varStatus="status">
					<li>
						<c:out value="${agent}" escapeXml="false"/>
						<c:choose>
						<c:when test="${status.last != true}">
						<c:out value=", "/>
						</c:when>
						</c:choose>
					</li>
					</c:forEach>
				</ul>
				</c:if>
			</td>
			<td><c:out value="${rec.strainSex}" escapeXml="false" default="&nbsp;"/></td>
			<td><c:out value="${rec.reproductiveStatus}" escapeXml="false" default="&nbsp;"/></td>
			<td><c:out value="${rec.infectionStatus}" escapeXml="false" default="&nbsp;"/></td>
			<td>
				<c:out value="${rec.frequencyString}" escapeXml="false" default="&nbsp;"/>
				<c:if test="${rec.numMiceAffected>=0&&rec.colonySize>=0}">
				(${rec.numMiceAffected} of ${rec.colonySize} mice)
				</c:if>
			</td>
			<td><c:out value="${rec.ageOnset}" escapeXml="false" default="&nbsp;"/></td>
			<td><c:out value="${rec.ageDetection}" escapeXml="false" default="&nbsp;"/></td>
			<td>
				<c:set var="additionalInfoText" value=""/>
				<%-- Check to see if we have pathology information about the tumor --%>
				<c:choose>
				<c:when test="${rec.numImages>0&&rec.numPathEntries>0}">
				<c:set var="additionalInfoText" value="<a href=\"nojavascript.jsp\" onClick=\"popPathWin('tumorFrequencyDetails.do?key=${rec.tumorFrequencyKey}&amp;page=pathology', '${rec.tumorFrequencyKey}');return false;\">Pathology Reports</a> <img src=\"${applicationScope.urlImageDir}/pic.gif\" alt=\"X\" border=\"0\">"/>
				</c:when>
				<c:when test="${rec.numImages>0&&rec.numPathEntries<=0}">
				<c:set var="additionalInfoText" value="<a href=\"nojavascript.jsp\" onClick=\"popPathWin('tumorFrequencyDetails.do?key=${rec.tumorFrequencyKey}&amp;page=pathology', '${rec.tumorFrequencyKey}');return false;\">Pathology Reports</a> <img src=\"${applicationScope.urlImageDir}/pic.gif\" alt=\"X\" border=\"0\">"/>
				</c:when>
				<c:when test="${rec.numImages<=0&&rec.numPathEntries>0}">
				<c:set var="additionalInfoText" value="<a href=\"nojavascript.jsp\" onClick=\"popPathWin('tumorFrequencyDetails.do?key=${rec.tumorFrequencyKey}&amp;page=pathology', '${rec.tumorFrequencyKey}');return false;\">Pathology Reports</a> "/>
				</c:when>
				</c:choose>

				<%-- Check to see if we have genetic information about the tumor --%>
				<c:choose>
				<c:when test="${rec.numGenetics>0}">

				<c:choose>
				<c:when test="${not empty additionalInfoText}">
				<c:set var="additionalInfoText" value="${additionalInfoText}"/>
				</c:when>
			 	</c:choose>
				<c:choose>
				<c:when test="${rec.numAssayImages > 0}">
				<c:set var="additionalInfoText" value="${additionalInfoText}<a href=\"nojavascript.jsp\" onClick=\"popPathWin('tumorFrequencyDetails.do?key=${rec.tumorFrequencyKey}&amp;page=genetics', '${rec.tumorFrequencyKey}');return false;\">Genetics</a><img src=\"${applicationScope.urlImageDir}/pic.gif\" alt=\"X\" border=\"0\">"/>
				</c:when>
				<c:otherwise>
				<c:set var="additionalInfoText" value="${additionalInfoText}<a href=\"nojavascript.jsp\" onClick=\"popPathWin('tumorFrequencyDetails.do?key=${rec.tumorFrequencyKey}&amp;page=genetics', '${rec.tumorFrequencyKey}');return false;\">Genetics</a>"/>
				</c:otherwise>
				</c:choose>
				</c:when>
				<c:otherwise>
				<!-- No genetics information //-->
				</c:otherwise>
				</c:choose>

				<%-- Check to see if we have additional notes about the tumor --%>
				<c:set var="notesLinkName" value=""/>
				<c:choose>
				<c:when test="${rec.numNotes>0}">
				<c:choose>
				<c:when test="${not empty additionalInfoText}">
				<c:set var="additionalInfoText" value="${additionalInfoText}"/>
				</c:when>
				</c:choose>
				<c:choose>
				<c:when test="${true}">
				<c:set var="additionalInfoText" value="${additionalInfoText}<a href=\"nojavascript.jsp\" onClick=\"popPathWin('tumorFrequencyDetails.do?key=${rec.tumorFrequencyKey}&amp;page=notes', '${rec.tumorFrequencyKey}');return false;\">Additional Notes</a>" />
				</c:when>
				</c:choose>
				</c:when>
				<c:otherwise>
				<!-- No additional Notes //-->
				</c:otherwise>
				</c:choose>

				<c:choose>
				<c:when test="${not empty rec.note}">
				<c:choose>
				<c:when test="${not empty additionalInfoText}">
				<c:set var="additionalInfoText" value="${additionalInfoText}"/>
				</c:when>
				</c:choose>
				<c:choose>
				<c:when test="${true}">
				<c:set var="additionalInfoText" value="${additionalInfoText}<a href=\"nojavascript.jsp\" onClick=\"popPathWin('tumorFrequencyDetails.do?key=${rec.tumorFrequencyKey}&amp;page=tnotes', '${rec.tumorFrequencyKey}');return false;\">Treatment Note</a>" />
				</c:when>
				</c:choose>
				</c:when>
				</c:choose>

				<c:choose>
				<c:when test="${rec.numSamples > 0}">
				<c:choose>
				<c:when test="${not empty additionalInfoText}">
				<c:set var="additionalInfoText" value="${additionalInfoText}"/>
				</c:when>
				</c:choose>
				<c:choose>
				<c:when test="${true}">
				<c:set var="additionalInfoText" value="${additionalInfoText}<a href=\"nojavascript.jsp\" onClick=\"popPathWin('geneExpressionSearchResults.do?tfKey=${rec.tumorFrequencyKey}&amp;page=arrays', '${rec.tumorFrequencyKey}');return false;\">Expression Data</a>" />
				</c:when>
				</c:choose>
				</c:when>
				</c:choose>

				<c:choose>
				<c:when test="${not empty additionalInfoText}">
				${additionalInfoText}
				</c:when>
				<c:otherwise>
				</c:otherwise>
				</c:choose>
			</td>
			<td>
				<c:choose>
				<c:when test="${not empty rec.reference}">
				<a href="referenceDetails.do?accId=${rec.reference}">${rec.reference}</a>
				</c:when>
				<c:otherwise>
				</c:otherwise>
				</c:choose>
			</td>
		</tr>
		</c:forEach>
	</tbody>
</table>
</c:when>
<c:otherwise>
	<!-- There are no tumor frequency records associated with this tumor. -->
</c:otherwise>
</c:choose>

</jax:mmhcpage>
