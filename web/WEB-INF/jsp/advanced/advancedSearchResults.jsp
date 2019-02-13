<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Advanced Search Results" help="tumorresults">
	<table class="agro-source">
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
				<th colspan="4"></th>
				<th colspan="4">Tumor Frequency Range</th>
				<th colspan="3"></th>
			</tr>
			<tr>
				<th>Tumor Name</th>
				<th class="category">Organ Affected</th>
				<th class="category">Treatment Type <em>Agents</em></th>
				<th class="category">Strain Name <em>Strain Types</em></th>				
				<th data-unit="percent" data-legend="fr" data-aggregate="prob-or">F</th>
				<th data-unit="percent" data-legend="fr" data-aggregate="prob-or">M</th>
				<th data-unit="percent" data-legend="fr" data-aggregate="prob-or">Mixed</th>
				<th data-unit="percent" data-legend="fr" data-aggregate="prob-or">Un.</th>
				<th>Additional Information</th>
				<th>Tumor Details</th>				
			</tr>
		</thead>
		<tbody>
			<c:forEach var="tumor" items="${tumors}" varStatus="status">
			<tr>
				<td><c:out value="${tumor.tumorName}" escapeXml="false"/><br>[key: <c:out value="${tumor.organOfOriginKey}" escapeXml="false"/>, name: <c:out value="${tumor.tumorOrganName}" escapeXml="false"/>]</td>
				<td><c:out value="${tumor.organAffectedName}" escapeXml="false"/></td>
				<td>
					<c:out value="${tumor.treatmentType}" escapeXml="false"/>
					<c:if test="${not empty tumor.agentsCollection}">
					<!-- \n -->
					<em>
						<c:forEach var="agent" items="${tumor.agentsCollection}" varStatus="status">
						<c:out value="${agent}" escapeXml="false"/>
						<c:if test="${status.last != true}">
						<!-- \n -->
						</c:if>
						</c:forEach>
					</em> 
					</c:if>
				</td>
				<td><a href="strainDetails.do?key=${tumor.strainKey}"><c:out value="${tumor.strainName}" escapeXml="false"/></a>
					<c:if test="${not empty tumor.strainTypesCollection}">
					<!-- \n -->
					<em>
						<c:forEach var="strainType" items="${tumor.strainTypesCollection}" varStatus="status">
						${strainType}
						<c:if test="${status.last != true}">
						<!-- \n -->
						</c:if>
						</c:forEach>
					</em>
					</c:if>
				</td>
				<td class="small-center">
					<c:out value="${tumor.freqFemaleString}" escapeXml="false" default="&nbsp;"/> 
					<c:forEach var="freq" items="${tumor.freqFemale}">
						<p>${freq}</p>
					</c:forEach>
				</td>
				
				
				
				
				<td class="small-center"><c:out value="${tumor.freqMaleString}" escapeXml="false" default="&nbsp;"/></td>
				<td class="small-center"><c:out value="${tumor.freqMixedString}" escapeXml="false" default="&nbsp;"/></td>
				<td class="small-center">
					<c:out value="${tumor.freqUnknownString}" escapeXml="false" default="&nbsp;"/>
					<c:forEach var="freq" items="${tumor.freqUnknown}">
						<p>${freq}</p>
					</c:forEach>
				</td>
				<td>
					<c:choose>
					<c:when test="${not empty tumor.metastasizesToDisplay}">
					
					<c:forEach var="organ" items="${tumor.metastasizesToDisplay}" varStatus="status">
					Metastasizes To ${organ}
					<c:if test="${status.last != true}">
					<!-- \n -->
					</c:if>
					</c:forEach>
					
					</c:when>
					<c:otherwise>
					</c:otherwise>
					</c:choose>
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
		</tbody>
		</c:when>
		<c:otherwise>
		<!-- No results found. //-->
		</c:otherwise>
		</c:choose>
		<!-- ////  End Results  //// -->
	</table>
	<script type="text/javascript">
		mods.push('jquery-ui.min.js', '/_res/lib/agro', './live/www/js/results.js');
	</script>
</jax:mmhcpage>
