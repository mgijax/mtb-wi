<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<c:catch var="exception">
<jax:mmhcpage title="Tumor Search Results" help="tumorresults">
	<table>
		<caption>
			<div class="search-summary">
				<h4>Search Summary</h4>
				<c:if test="${not empty anatomicalSystemOriginName}">
				<dl>
					<dt>Anatomical System of Origin</dt>
					<dd>${anatomicalSystemOriginName}</dd>
				</dl>
				</c:if>
				<c:if test="${not empty organTissueOrigins}">
				<c:choose>
				<dl>
					<c:when test="${fn:length(organTissueOrigins)>1}">
					<dt>Organs/Tissues of Origin</dt>
					</c:when>
					<c:otherwise>
					<dt>Organ/Tissue of Origin</dt>
					</c:otherwise>
					</c:choose>
					<c:forEach var="organ" items="${organTissueOrigins}" varStatus="status">
					<dd>${organ}</dd>
					</c:forEach>
				</dl>
				</c:if>
				<c:if test="${not empty organOriginName}">
				<dl>
					<dt>Organ/Tissue of Origin:</dt>
					<dd>${organOriginName}</dd>
				</dl>
				</c:if>
				<c:if test="${not empty organOfOriginName}">
				<dl>
					<dt>Organ/Tissue of Origin</dt>
					<dd>Contains "${organOfOriginName}"</dd>
				</dl>
				</c:if>
				<c:if test="${not empty tumorClassifications}">
				<dl>
					<c:choose>
					<c:when test="${fn:length(tumorClassifications)>1}">
					<dt>Tumor Classifications</dt>
					</c:when>
					<c:otherwise>
					<dt>Tumor Classification</dt>
					</c:otherwise>
					</c:choose>
					<c:forEach var="classification" items="${tumorClassifications}" varStatus="status">
					<dd>${classification}</dd>
					</c:forEach>
				</dl>
				</c:if>
				<c:if test="${not empty tumorName}">
				<dl><dt>Tumor Name</dt>
					<dd>Contains "${tumorName}"</dd>
				</dl>
				</c:if>
				<c:if test="${not empty agentType}">
				<dl>
					<dt>Treatment Type</dt>
					<dd>${agentType}</dd>
				</dl>
				</c:if>
				<c:if test="${not empty agent}">
				<dl>
					<dt>Treatment</dt>
					<dd>Contains "${agent}"</dd>
				</dl>
				</c:if>
				<c:if test="${not empty metastasisLimit}">
				<dl>
					<dt>Restrict search to metastatic tumors only.</dt>
				</dl>
				</c:if>
				<c:if test="${not empty organsAffected}">
				<dl>
					<c:choose>
					<c:when test="${fn:length(organsAffected)>1}">
					<dt>Organs/Tissues Affected</dt>
					</c:when>
					<c:otherwise>
					<dt>Organ/Tissue Affected</dt>
					</c:otherwise>
					</c:choose>
					<c:forEach var="organ" items="${organsAffected}" varStatus="status">
					<dd>${organ}</dd>
					</c:forEach>
				</dl>
				</c:if>
				<c:if test="${not empty organAffectedName}">
				<dl>
					<dt>Organ/Tissue Affected</dt>
					<dd>${organAffectedName}</dd>
				</dl>
				</c:if>
				<c:if test="${not empty mustHaveImages}">
				<dl>
					<dt>Restrict search to entries with associated pathology images.</dt>
				</dl>
				</c:if>
				<c:if test="${not empty geneticChange}">
				<dl>
					<dt>Genetic Change</dt>
					<dd>${geneticChange}</dd>
				</dl>
				</c:if>
				<c:if test="${not empty cytogeneticChange}">
				<dl>
					<dt>Cytogenetic Change</dt>
					<dd>${cytogeneticChange}</dd>
				</dl>
				</c:if>
				<c:if test="${not empty colonySize}">
				<dl>
					<dt>Colony Size</dt>
					<dd>${colonySize}</dd>
				</dl>
				</c:if>
				<c:if test="${not empty frequency}">
				<dl>
					<dt>Frequency</dt>
					<dd>${frequency}</dd>
				</dl>
				</c:if>
				<c:if test="${not empty strainName}">
				<dl>
					<dt>Strain</dt>
					<dd>${strainName}</dd>
				</dl>
				</c:if>
				<c:if test="${not empty strainFamilyName}">
				<dl>
					<dt>Strain Family:</dt>
					<dd>${strainFamilyName}</dd>
				</dl>
				</c:if>
				<c:if test="${not empty strainTypes}">
				<dl>
					<c:choose>
					<c:when test="${strainTypesSize>'1'}">
					<dt>Strain Types</dt>
					</c:when>
					<c:otherwise>
					<dt>Strain Type</dt>
					</c:otherwise>
					</c:choose>
					<c:forEach var="strainType" items="${strainTypes}" varStatus="status">
					<dd>${strainType}</dd>							
					</c:forEach>
				</dl>
				</c:if>
				<c:if test="${not empty accId}">
				<dl>
					<dt>Accession Id</dt>
					<dd>${accId}</dd>
				</dl>
				</c:if>
				<dl>
					<dt>Sort By</dt>
					<dd>${sortBy}</dd>
				</dl>
				<dl>
					<dt>Display Limit</dt>
					<dd>${maxItems}</dd>
				</dl>
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

