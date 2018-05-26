<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Advanced Search Results" help="tumorresults">
	<table class="results">
		<!-- ////  Start Search Summary  //// -->
		<caption><span class="label">Search Summary</span>
			<!-- \n -->
			<c:if test="${not empty strainName}">
			<span class="label">Strain Name:</span> ${strainNameComparison} "${strainName}"
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
			<c:if test="${not empty geneticName}">
			<span class="label">Genetic Name</span> ${geneticName}
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
			<c:if test="${not empty accId}">
			<span class="label">Accession Id:</span> ${accId}
			<!-- \n -->
			</c:if>
			<span class="label">Sort By:</span> ${sortBy}
			<!-- \n -->
			<span class="label">Display Limit:</span> ${maxItems}
		</caption>
		<caption><!-- ////  Start Display Limit  //// -->
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
		</caption>
		<!-- ////  End Search Summary  //// -->
		<!-- ////  Start Results  //// -->
		<c:choose>
		<c:when test="${not empty tumors}">
		<c:set var="lbl" value="1"/>
		<tr class="results">
			<td class="results-header" rowspan="2">Tumor Name</strong></td>
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
	<c:choose>
	<c:when test="${status.index%2==0}">
	<tr>
		</c:when>
		<c:otherwise>
		<tr>
			</c:otherwise>
			</c:choose>
			<td width="250"><c:out value="${tumor.tumorName}" escapeXml="false"/></td>
			<td><c:out value="${tumor.organAffectedName}" escapeXml="false"/></td>
			<td width="200">
				<c:out value="${tumor.treatmentType}" escapeXml="false"/>
				<c:if test="${not empty tumor.agentsCollection}">
				<!-- \n -->
				<span size="-2"><em>
						<c:forEach var="agent" items="${tumor.agentsCollection}" varStatus="status">
						<c:out value="${agent}" escapeXml="false"/>
						<c:if test="${status.last != true}">
						<!-- \n -->
						</c:if>
						</c:forEach>
				</em></span> 
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
				<div><img src="${applicationScope.urlImageDir}/pic.gif" alt="X"></div>
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

