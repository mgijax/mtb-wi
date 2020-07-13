<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Strain Search Results">
	<jsp:attribute name="head">
		<link rel="stylesheet" type="text/css" href="./live/www/css/results.css"/>
		<script type="text/javascript" src="./live/www/js/results.js"></script>
	</jsp:attribute>
	<jsp:body>
	<table>
		<caption>
			<div class="result-summary">
				<h4>Search Summary</h4>
				<jax:dl dt="Strain Name" dd="${strainComparison} '${strainName}'"/>
				<jax:dl dt="Strain Type" dds="${strainTypes}"/>
				<c:if test="${not empty geneticName}">
				<dl>
					<dt>Gene or Allele <em>(Symbol/Name/Synonym)</em></dt>
					<dd>Contains '${geneticName}'</dd>
				</dl>
				</c:if>
				<%-- <jax:dl dt="Strain Notes" dd="contains '${strainNotes}'"> --%>
				<jax:dl dt="Other Database Links" dd="${sites}"/>
				<c:if test="${not empty jaxMiceStockNumber}">
				<dl>
					<dt>JAX<sup>&reg;</sup>Mice Stock No.:</dt>
					<dd>${jaxMiceStockNumber}</dd>
				</dl>
				</c:if>
				<jax:dl dt="Accession ID" dd="${accId}"/>
				<jax:dl dt="Sort By" dd="${sortBy}"/>
				<jax:dl dt="Display Limit" dd="${maxItems}"/>
			</div>
			<div class="result-count">
				<c:choose>
				<c:when test="${numberOfResults != totalResults}">
				${numberOfResults} of ${totalResults} matching items displayed.
				</c:when>
				<c:otherwise>
				<c:out value="${numberOfResults}" default="0"/> matching items displayed.
				</c:otherwise>
				</c:choose>
			</div>
		</caption>
		<c:choose>
		<c:when test="${not empty strains}">
		<thead>
			<tr>
				<th>Strain Name</th>
				<th>Strain Type</th>
				<th>Strain Notes</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="strain" items="${strains}" varStatus="status">
			<tr>
				<td><a href="strainDetails.do?page=collapsed&amp;key=${strain.key}"><c:out value="${strain.name}" escapeXml="false"/></a></td>
				<td>
					<c:forEach var="strainType" items="${strain.types}" varStatus="status">
					${strainType}
					<c:if test="${status.last != true}">
					&amp;
					</c:if>
					</c:forEach>
				</td>
				<td><c:out value="${strain.description}" default="&nbsp;" escapeXml="false"/></td>
			</tr>
			</c:forEach>
		</tbody>
		</c:when>
		<c:otherwise>
		<!-- No results found.	//-->
		</c:otherwise>
		</c:choose>
	</table>
	</jsp:body>
</jax:mmhcpage>
