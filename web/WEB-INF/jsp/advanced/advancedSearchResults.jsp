<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Advanced Search Results" help="tumorresults">
	<table>
		<caption>
			<div class="search-summary">		
				<h4>Search Summary</h4>
				<!-- \n -->
				<c:if test="${not empty strainName}">
				<h5 class="label">Strain Name:</h5> ${strainNameComparison} "${strainName}"
				<!-- \n -->
				</c:if>
				<c:if test="${not empty strainTypes}">
				<c:choose>
				<c:when test="${strainTypesSize>'1'}">
				<h5 class="label">Strain Types:</h5>
				</c:when>
				<c:otherwise>
				<h5 class="label">Strain Type:</h5>
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
				<h5 class="label">Genetic Name</h5> ${geneticName}
				<!-- \n -->
				</c:if>
				<c:if test="${not empty organTissueOrigins}">
				<c:choose>
				<c:when test="${fn:length(organTissueOrigins)>1}">
				<h5 class="label">Organs/Tissues of Origin:</h5> 
				</c:when>
				<c:otherwise>
				<h5 class="label">Organ/Tissue of Origin:</h5> 
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
				<h5 class="label">Organ/Tissue of Origin:</h5> Contains "${organOfOriginName}"
				<!-- \n -->
				</c:if>
				<c:if test="${not empty tumorClassifications}">
				<c:choose>
				<c:when test="${fn:length(tumorClassifications)>1}">
				<h5 class="label">Tumor Classifications:</h5>
				</c:when>
				<c:otherwise>
				<h5 class="label">Tumor Classification:</h5> 
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
				<h5 class="label">Tumor Name:</h5> Contains "${tumorName}"
				<!-- \n -->
				</c:if>
				<c:if test="${not empty agentType}">
				<h5 class="label">Treatment Type:</h5> ${agentType}
				<!-- \n -->
				</c:if>
				<c:if test="${not empty agent}">
				<h5 class="label">Treatment:</h5>	Contains "${agent}"
				<!-- \n -->
				</c:if>
				<c:if test="${not empty metastasisLimit}">
				<h5 class="label">Restrict search to metastatic tumors only.</h5>
				<!-- \n -->
				</c:if>
				<c:if test="${not empty organsAffected}">
				<c:choose>
				<c:when test="${fn:length(organsAffected)>1}">
				<h5 class="label">Organs/Tissues Affected:</h5>
				</c:when>
				<c:otherwise>
				<h5 class="label">Organ/Tissue Affected:</h5>
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
				<h5 class="label">Restrict search to entries with associated pathology images.</h5>
				<!-- \n -->
				</c:if>
				<c:if test="${not empty geneticChange}">
				<h5 class="label">Genetic Change:</h5> ${geneticChange}
				<!-- \n -->
				</c:if>
				<c:if test="${not empty cytogeneticChange}">
				<h5 class="label">Cytogenetic Change:</h5> ${cytogeneticChange}
				<!-- \n -->
				</c:if>
				<c:if test="${not empty accId}">
				<h5 class="label">Accession Id:</h5> ${accId}
				<!-- \n -->
				</c:if>
				<h5 class="label">Sort By:</h5> ${sortBy}
				<!-- \n -->
				<h5 class="label">Display Limit:</h5> ${maxItems}
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
			</div>
		</caption>
		<!-- ////  Start Results  //// -->
		<c:choose>
		<c:when test="${not empty tumors}">
		<thead>
			<tr>
				<th rowspan="2">Tumor Name</th>
				<th rowspan="2">Organ Affected</th>
				<th rowspan="2">Treatment Type <em>Agents</em></th>
				<th rowspan="2">Strain Name <em>Strain Types</em></th>
				<th>Tumor Frequency Range</th>
				<th rowspan="2">Metastasizes To</th>
				<th rowspan="2">Images</th>
				<th rowspan="2">Tumor Summary</th>
			</tr>
			<tr>
				<th>F</th>
				<th>M</th>
				<th>Mixed</th>
				<th>Un.</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="tumor" items="${tumors}" varStatus="status">
			<tr>
				<td><c:out value="${tumor.tumorName}" escapeXml="false"/></td>
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
				<td class="small-center"><c:out value="${tumor.freqFemaleString}" escapeXml="false" default="&nbsp;"/></td>
				<td class="small-center"><c:out value="${tumor.freqMaleString}" escapeXml="false" default="&nbsp;"/></td>
				<td class="small-center"><c:out value="${tumor.freqMixedString}" escapeXml="false" default="&nbsp;"/></td>
				<td class="small-center"><c:out value="${tumor.freqUnknownString}" escapeXml="false" default="&nbsp;"/></td>
				<td>
					<c:choose>
					<c:when test="${not empty tumor.metastasizesToDisplay}">
					
					<c:forEach var="organ" items="${tumor.metastasizesToDisplay}" varStatus="status">
					${organ}
					<c:if test="${status.last != true}">
					<!-- \n -->
					</c:if>
					</c:forEach>
					
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
		</tbody>
		</c:when>
		<c:otherwise>
		<!-- No results found. //-->
		</c:otherwise>
		</c:choose>
		<!-- ////  End Results  //// -->
	</table>
</jax:mmhcpage>

