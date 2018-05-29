<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Strain Tumor Overview (Expanded View)" help="straindetail">
	<jsp:attribute name="subnav">
	<a href="strainDetails.do?page=collapsed&amp;key=${strain.strainKey}">Strain Tumor Overview Collapsed View</a>
	</jsp:attribute>
	<table id="strain-info">
		<caption>
			<h2>Strain</h2>
			<h3><c:out value="${strain.name}" escapeXml="false"/></h3>
		</caption>
		<tbody>
			<c:choose>
			<c:when test="${not empty strain.synonyms}">
			<tr>
				<td><h4>Strain Synonyms</h4></td>
				<td>
					<c:forEach var="synonym" items="${strain.synonyms}" varStatus="status">
					<c:out value="${synonym.name}" escapeXml="false"/>
					<c:if test="${status.last != true}">
					&nbsp;&#8226;&nbsp;
					</c:if>
					</c:forEach>
				</td>
			</tr>
			</c:when>
			<c:otherwise>
			<!-- There are no synonyms associated with this strain. -->
			</c:otherwise>
			</c:choose>
			<c:if test="${not empty strain.description}">
			<tr>
				<td><h4>Strain Note: </h4></td>
				<td>${strain.description}</td>
			</tr>
			</c:if>
		</tbody>
	</table>
	<!-- ////  Start Strain Tumors  //// -->
	<c:choose>
	<c:when test="${not empty strain.tumors}">
	<table id="strain-tumors">
		<caption>
			<h2>Tumors</h2>
			<c:set var="statsBean" value="${strain.tumorStats}"/>
			${statsBean.label} unique tumor sub-types displayed. 
			<!-- representing ${statsBean.value} tumor detail records. -->
			<em>A tumor sub-type is a set of tumors that share the same tumor name, organ affected, treatment agent, and metastatic status/localization.</em>
		</caption>
		<thead>
			<tr>
				<th>Tumor Name</th>
				<th>Organ(s) Affected</th>
				<th>Treatment Type <em>Agents</em></th>
				<th>Metastasizes To</th>
				<th>References</th>
				<th>Number of Tumor Sub-type Records</th>
				<th>Frequency Range</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="tumor" items="${strain.tumors}" varStatus="status">
			<tr>
				<td><c:out value="${tumor.tumorName}" escapeXml="false"/></td>
				<td><c:out value="${tumor.organAffectedName}" escapeXml="false"/></td>
				<td>
					<c:out value="${tumor.treatmentType}" escapeXml="false"/>
					<c:if test="${not empty tumor.agents}">
					<em>
							<c:forEach var="agent" items="${tumor.agents}" varStatus="status">
							<c:out value="${agent}" escapeXml="false"/>
							<c:if test="${status.last != true}">
							<!-- \n -->
							</c:if>
							</c:forEach>
					</em> 
					</c:if>
				</td>
				<td>
					<c:choose>
					<c:when test="${not empty tumor.metastasizesToDisplay}">
					<c:forEach var="organ" items="${tumor.metastasizesToDisplay}" varStatus="status">
					${organ}
					<c:if test="${status.last != true}">
					</c:if>
					</c:forEach>
					</c:when>
					<c:otherwise>
					</c:otherwise>
					</c:choose>
				</td>
				<td>
					<c:choose>
					<c:when test="${not empty tumor.sortedRefAccIds}">
					<c:forEach var="ref" items="${tumor.sortedRefAccIds}" varStatus="status">
					<a href="referenceDetails.do?accId=${ref}">${ref}</a>
					<c:if test="${status.last != true}">
					</c:if>
					</c:forEach>
					</c:when>
					<c:otherwise>
					</c:otherwise>
					</c:choose>
				</td>
				<td>
					<a href="tumorSummary.do?strainKey=${tumor.strainKey}&amp;organOfOriginKey=${tumor.organOfOriginKey}&amp;tumorFrequencyKeys=${tumor.allTFKeysAsParams}">${tumor.numberTFRecords}</a>
				</td>
				<td><c:out value="${tumor.freqAllString}" escapeXml="false"/></td>
			</tr>
			</c:forEach>
		</tbody>
	</table>
	</c:when>
	<c:otherwise>
	<!-- There is no tumor information associated with this strain. -->
	</c:otherwise>
	</c:choose>
	<c:choose>
	<c:when test="${not empty strain.links || not empty strain.linksGeneral}">
	<h2>Other Database Links</h2>
	<c:choose>
	<c:when test="${not empty strain.links}">
	<table id="strain-links">
		<caption>
			<h3>Additional information about these mice:</h3>
		</caption>
		<tbody>
			<c:forEach var="link" items="${strain.links}" varStatus="status">
			<tr>
				<%--
				<td><a href="${link.siteUrl}" target="${link.siteName}"><c:out value="${link.siteName}" escapeXml="false"/></a></td>
				--%>
				<td><c:out value="${link.siteName}" escapeXml="false"/></td>
				<td><a href="${link.accessionUrl}" target="${link.siteName}"><c:out value="${link.accessionUrl}" escapeXml="false"/></a></td>
			</tr>
			</c:forEach>
		</tbody>
	</table>
	
	</c:when>
	<c:otherwise>
	<!-- There are is no additional information associated with this strain. (strain.links) -->
	</c:otherwise>
	</c:choose>
	
	<c:choose>
	<c:when test="${not empty strain.linksGeneral}">
	<table id="strain-links-general">
		<caption>
			<h3>Information about mice carrying the same mutant allele(s):</h3>
		</caption>
		<tbody>
			<c:forEach var="linkGeneral" items="${strain.linksGeneral}" varStatus="status">
			<tr>
				<td><a href="${linkGeneral.siteUrl}" target="${linkGeneral.siteName}"><c:out value="${linkGeneral.siteName}" escapeXml="false"/></a></td>
				<td><a href="${linkGeneral.accessionUrl}" target="${linkGeneral.siteName}"><c:out value="${linkGeneral.accessionUrl}" escapeXml="false"/></a></td>
			</tr>
			</c:forEach>
		</tbody>
	</table>
	</c:when>
	<c:otherwise>
	<!-- There are no other database links associated with this strain. (strain.linksGeneral) //-->
	</c:otherwise>
	</c:choose>
	</c:when>
	<c:otherwise>
	<!-- There are no other database links associated with this strain. -->
	</c:otherwise>
	</c:choose>
</jax:mmhcpage>

