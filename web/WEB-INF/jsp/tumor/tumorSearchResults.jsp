<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib uri="http://tumor.informatics.jax.org/mtbwi/MTBWebUtils" prefix="wu" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<c:catch var="exception">
<jax:mmhcpage title="Tumor Search Results" help="tumorresults">
	<table>
		<!-- ////  Start Search Summary  //// -->
		<caption>
			<div class="search-summary">
				<h4>Search Summary</h4>
				<c:if test="${not empty anatomicalSystemOriginName}">
				<span class="label">Anatomical System of Origin:</span> ${anatomicalSystemOriginName}
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
				
				</c:if>
				<c:if test="${not empty organOriginName}">
				<span class="label">Organ/Tissue of Origin:</span> ${organOriginName}
				</c:if>
				<c:if test="${not empty organOfOriginName}">
				<span class="label">Organ/Tissue of Origin:</span> Contains "${organOfOriginName}"
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
			</div>
			<div class="display-counts">
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
			</div>
		</caption>
		<!-- ////  End Search Summary  //// -->
		<!-- ////  Start Results  //// -->
		<c:choose>
		<c:when test="${not empty tumors}">
		<c:set var="lbl" value="1"/>
		<tr class="results">
			<td class="results-header" rowspan="2">Tumor Name</td>
			<td class="results-header" rowspan="2">Organ Affected</td>
			<td class="results-header" rowspan="2">Treatment Type
				<!-- \n -->
				<span size="-2"><em>Agents</em></span></td>
			<td class="results-header" rowspan="2">Strain Name
				<!-- \n -->
				<span size="-2"><em>Strain Types</em></span></td>
			<td class="results-header" colspan="4">Tumor Frequency Range</td>
			<td class="results-header-small" rowspan="2">Metastasizes
				<!-- \n -->
			To</td>
			<td class="results-header-small" rowspan="2">Images</td>
			<td class="results-header" rowspan="2">Tumor
				<!-- \n -->
			Summary</td>
		</tr>
		<tr class="results">
			<td width="40" class="results-header-small">F</td>
			<td width="40" class="results-header-small">M</td>
			<td width="40" class="results-header-small">Mixed</td>
			<td width="40" class="results-header-small">Un.</td>
		</tr>
		<c:forEach var="tumor" items="${tumors}" varStatus="status">
		<tr>
			<td width="250"><c:out value="${tumor.tumorName}" escapeXml="false"/></td>
			<td><c:out value="${tumor.organAffectedName}" escapeXml="false"/></td>
			<td width="200">
				<c:out value="${tumor.treatmentType}" escapeXml="false"/>
				<c:if test="${(not empty tumor.agentsCollection) && (fn:length(tumor.agentsCollection) > 0)}">
				<!-- \n -->
				<c:forEach var="agentInfo" items="${tumor.agentsCollection}" varStatus="status">
				<c:if test="${(not empty agentInfo) && (fn:length(agentInfo) > 0)}">
				<span size="-2"><em>
						<c:out value="${agentInfo}" escapeXml="false"/>
				</em></span>
				<c:if test="${status.last != true}">
				<!-- \n -->
				</c:if>
				</c:if>
				</c:forEach>
				</c:if>
			</td>
			<td><a href="strainDetails.do?key=${tumor.strainKey}"><c:out value="${tumor.strainName}" escapeXml="false"/></a>
				<c:if test="${not empty tumor.strainTypesCollection}">
				<!-- \n -->
				<span size="-2"><em>
						<c:forEach var="strainType" items="${tumor.strainTypesCollection}" varStatus="status">
						${strainType}
						<c:if test="${status.last != true}">
						<!-- \n -->
						</c:if>
						</c:forEach>
				</em></span>
				</c:if>
			</td>
			<td width="40" class="small-center"><c:out value="${tumor.freqFemaleString}" escapeXml="false" default="&nbsp;"/></td>
			<td width="40" class="small-center"><c:out value="${tumor.freqMaleString}" escapeXml="false" default="&nbsp;"/></td>
			<td width="40" class="small-center"><c:out value="${tumor.freqMixedString}" escapeXml="false" default="&nbsp;"/></td>
			<td width="40" class="small-center"><c:out value="${tumor.freqUnknownString}" escapeXml="false" default="&nbsp;"/></td>
			<td>
				<c:choose>
				<c:when test="${not empty tumor.metastasizesToDisplay}">
				<span size="-2">
					<c:forEach var="organ" items="${tumor.metastasizesToDisplay}" varStatus="status">
					${organ}
					<c:if test="${status.last != true}">
					<!-- \n -->
					</c:if>
					</c:forEach>
				</span>
				</c:when>
				<c:otherwise>
				</c:otherwise>
				</c:choose>
			</td>
			<td>
				<c:choose>
				<c:when test="${tumor.images==true}">
				<div><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('Images aviable from Pathology Reports link on Summary Page');" onmouseout="return nd();"><img src="${applicationScope.urlImageDir}/pic.gif" alt="X"></a></div>
				</c:when>
				<c:otherwise>
				</c:otherwise>
				</c:choose>
			</td>
			<td>
				<a href="tumorSummary.do?strainKey=${tumor.strainKey}&amp;organOfOriginKey=${tumor.organOfOriginKey}&amp;tumorFrequencyKeys=${tumor.allTFKeysAsParams}">Summary</a>
			</td>
		</tr>
		</c:forEach>
		</c:when>
		<c:otherwise>
		<!-- No results found. //-->
		</c:otherwise>
		</c:choose>
		<!-- ////  End Results  //// -->
	</table>
</jax:mmhcpage>
</c:catch>
<c:if test="${not empty exception}">
<pre>
	<!--
	<c:out value="${exception}"/>
	An error occurred <c:out value="${exception.message}"/>
	<!-- \n -->
	Stacktrace: 
	<!-- \n -->
	<%
	Throwable t = (Throwable)pageContext.getAttribute("exception");
	t.printStackTrace(new java.io.PrintWriter(out));
	%>
	-->
</pre>
</c:if>


