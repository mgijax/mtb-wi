<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Advanced Search Results">
	<jsp:attribute name="head">
		<link rel="stylesheet" type="text/css" href="./live/www/css/results.css"/>
		<script type="text/javascript" src="./live/www/js/results.js"></script>
	</jsp:attribute>
	<jsp:body>	
	<table class="agro-source-1 result-table">
		<caption>
			<div class="result-summary">		
				<h4>Search Summary</h4>
				<p>You searched for&hellip;</p>
				<jax:dl dt="Strain Name" dd="${strainNameComparison} '${strainName}'" test="${not empty strainName}"/>
				<jax:dl dt="Strain Type" dds="${strainTypes}"/>
				<jax:dl dt="Genetic Name" dd="${geneticName}"/>
				<jax:dl dt="Organ/Tissue of Origin" dts="Organs/Tissues of Origin" dd="${organOfOriginName}" dds="${organTissueOrigins}"/>
				<jax:dl dt="Tumor Classifications" dds="${tumorClassifications}"/>
				<jax:dl dt="Tumor Name" dd="${tumorName}"/>
				<jax:dl dt="Treatment Type" dd="${agentType}"/>
				<jax:dl dt="Treatment" dd="${agent}"/>
				<jax:dl dt="Restrict search to metastatic tumors only." test="${not empty metastasisLimit}"/>
				<jax:dl dt="Organ/Tissue Affected" dts="Organs/Tissues Affected" dds="${organsAffected}"/>
				<jax:dl dt="Restrict search to entries with associated pathology images." test="${not empty mustHaveImages}"/>
				<jax:dl dt="Genetic Change" dd="${geneticChange}"/>
				<jax:dl dt="Cytogenetic Change" dd="${cytogeneticChange}"/>
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
		<thead>
			<tr>
				<th colspan="3"></th>
				<th colspan="4">Tumor Frequency Range</th>
				<th colspan="2"></th>
			</tr>
			<tr>
				<th>Tumor Name<em>&nbsp;</em></th>
				<th class="category">Treatment Type <em>Agents</em></th>
				<th class="category">Strain Name <em>Strain Types</em></th>				
				<th class="fr" data-unit="percent" data-legend="fr" data-aggregate="prob-or">F</th>
				<th class="fr" data-unit="percent" data-legend="fr" data-aggregate="prob-or">M</th>
				<th class="fr" data-unit="percent" data-legend="fr" data-aggregate="prob-or">Mixed</th>
				<th class="fr" data-unit="percent" data-legend="fr" data-aggregate="prob-or">Un.</th>
				<th>Additional Information</th>
				<th>Tumor Details</th>				
			</tr>
		</thead>
		<tbody>
			<c:forEach var="tumor" items="${tumors}" varStatus="status">
			<tr>
				<td>
					<c:out value="${tumor.tumorName}" escapeXml="false"/>
					<c:if test="${tumor.tumorOrganName != tumor.organAffectedName}">
						<em>observed in <c:out value="${tumor.organAffectedName}" escapeXml="false"/></em>
					</c:if>
				</td>
				<td>
					<c:if test="${tumor.treatmentType != 'None (spontaneous)'}">
						<c:out value="${tumor.treatmentType}" escapeXml="false"/>
						<c:if test="${not empty tumor.agentsCollection}">
							<c:forEach var="agent" items="${tumor.agentsCollection}" varStatus="status">
								<em><c:out value="${agent}" escapeXml="false"/></em>
							</c:forEach>
						</c:if>
					</c:if>
				</td>
				<td><a href="strainDetails.do?key=${tumor.strainKey}"><c:out value="${tumor.strainName}" escapeXml="false"/></a>
					<c:if test="${not empty tumor.strainTypesCollection}">
						<c:forEach var="strainType" items="${tumor.strainTypesCollection}" varStatus="status">
							<em>${strainType}</em>
						</c:forEach>
					</c:if>
				</td>				
				<fmt:formatNumber var="femaleClass" value="${tumor.maxFreqFemale + (100 - tumor.maxFreqFemale) % 10}" maxFractionDigits="0" />
				<fmt:formatNumber var="maleClass" value="${tumor.maxFreqMale + (100 - tumor.maxFreqMale) % 10}" maxFractionDigits="0" />
				<fmt:formatNumber var="mixedClass" value="${tumor.maxFreqMixed + (100 - tumor.maxFreqMixed) % 10}" maxFractionDigits="0" />
				<fmt:formatNumber var="unknownClass" value="${tumor.maxFreqUnknown + (100 - tumor.maxFreqUnknown) % 10}" maxFractionDigits="0" />				
				<td class="fr r-${femaleClass}" data-val="${tumor.maxFreqFemale}">
					<c:out value="${tumor.freqFemaleString}" escapeXml="false" default=""/>
				</td>
				<td class="fr r-${maleClass}" data-val="${tumor.maxFreqMale}">
					<c:out value="${tumor.freqMaleString}" escapeXml="false" default=""/>
				</td>
				<td class="fr r-${mixedClass}" data-val="${tumor.maxFreqMixed}">
					<c:out value="${tumor.freqMixedString}" escapeXml="false" default=""/>
				</td>
				<td class="fr r-${unknownClass}" data-val="${tumor.maxFreqUnknown}">
					<c:out value="${tumor.freqUnknownString}" escapeXml="false" default=""/>
				</td>
				<td>
					<c:if test="${not empty tumor.metastasizesToDisplay}">
						<c:forEach var="organ" items="${tumor.metastasizesToDisplay}" varStatus="status">
							<c:if test="${!fn:startsWith(organ, '<i>not</i>')}">
								<p class="does-metastasize">${organ}</p>
							</c:if>
						</c:forEach>
						<c:forEach var="organ" items="${tumor.metastasizesToDisplay}" varStatus="status">
							<c:if test="${fn:startsWith(organ, '<i>not</i>')}">
								<p class="does-not-metastasize">${organ}</p>
							</c:if>
						</c:forEach>						
					</c:if>
					<c:if test="${tumor.images==true}">
						<div><img src="${applicationScope.urlImageDir}/pic.gif" alt="X">${tumor.imageCount} pathology image<c:if test="${tumor.imageCount != 1}">s</c:if></div>
					</c:if>
				</td>
				<td>

					<a href="tumorSummary.do?strainKey=${tumor.strainKey}&amp;organOfOriginKey=${tumor.organOfOriginKey}&amp;tumorFrequencyKeys=${tumor.allTFKeysAsParams}">View details<strong>${tumor.numberTFRecords} record<c:if test="${tumor.numberTFRecords != 1}">s</c:if></strong></a>
				</td>
			</tr>
			</c:forEach>
		</tbody>
		</c:when>
		<c:otherwise>
		<!-- No results found. //-->
		</c:otherwise>
		</c:choose>
		<!-- ////  End Results  //// -->
	</table>
	</jsp:body>
</jax:mmhcpage>
