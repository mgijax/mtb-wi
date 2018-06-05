<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<c:catch var="exception">
<jax:mmhcpage title="Tumor Search Results" help="tumorresults">
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
					<c:if test="${(not empty tumor.agentsCollection) && (fn:length(tumor.agentsCollection) > 0)}">
					<!-- \n -->
					<c:forEach var="agentInfo" items="${tumor.agentsCollection}" varStatus="status">
					<c:if test="${(not empty agentInfo) && (fn:length(agentInfo) > 0)}">
					<em>
						<c:out value="${agentInfo}" escapeXml="false"/>
					</em>
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
					<div><a data-tip="Images aviable from Pathology Reports link on Summary Page"><img src="${applicationScope.urlImageDir}/pic.gif" alt="X"></a></div>
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

