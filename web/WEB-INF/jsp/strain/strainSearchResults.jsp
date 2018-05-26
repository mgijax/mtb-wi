<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Strain Search Results" help="straindetail">
	<table class="results">
		<!-- ////  Start Search Summary  //// -->
		<caption><span class="label">Search Summary</span>
			<!-- \n -->
			<c:if test="${not empty strainName}">
			<span class="label">Strain Name:</span> ${strainComparison} "${strainName}"
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
			<span class="label">Gene or Allele</span> <em>(Symbol/Name/Synonym)</em>: Contains "${geneticName}"
			<!-- \n -->
			</c:if>
			<%--
			<c:if test="${not empty strainNotes}">
			<strong>Strain Notes:</strong> contains ${strainNotes}
			<!-- \n -->
			</c:if>
			--%>
			<c:if test="${not empty sites}">
			<span class="label">Other Database Links:</span> ${sites}
			<!-- \n -->
			</c:if>
			<c:if test="${not empty jaxMiceStockNumber}">
			<span class="label">JAX<sup>&reg;</sup>Mice Stock No.:</span> ${jaxMiceStockNumber}
			<!-- \n -->
			</c:if>
			<c:if test="${not empty accId}">
			<span class="label">Accession ID:</span> ${accId}
			<!-- \n -->
			</c:if>
			<span class="label">Sort By:</span> ${sortBy}
			<!-- \n -->
			<span class="label">Display Limit:</span> ${maxItems}
		</caption>
		<caption><!-- ////  Start Display Limit  //// -->
			<c:choose>
			<c:when test="${numberOfResults != totalResults}">
			${numberOfResults} of ${totalResults} matching items displayed.
			</c:when>
			<c:otherwise>
			<c:out value="${numberOfResults}" default="0"/> matching items displayed.
			</c:otherwise>
			</c:choose>
			<!-- ////  End Display Limit  //// -->
		</caption>
		<!-- ////  End Search Summary  //// -->
		<!-- ////  Start Results  //// -->
		<c:choose>
		<c:when test="${not empty strains}">
		<tr>
			<th>Strain Name</th>
			<td class="results-header" width="210">Strain Type</td>
			<th>Strain Notes</th>
		</tr>
		<c:forEach var="strain" items="${strains}" varStatus="status">
		<c:choose>
		<c:when test="${status.index%2==0}">
		<tr>
			</c:when>
			<c:otherwise>
			<tr>
				</c:otherwise>
				</c:choose>
				<td><a href="strainDetails.do?page=collapsed&amp;key=${strain.key}"><c:out value="${strain.name}" escapeXml="false"/></a></td>
				<td>
					<c:forEach var="strainType" items="${strain.types}" varStatus="status">
					${strainType}
					<c:if test="${status.last != true}">
					&amp;
					<!-- \n -->
					</c:if>
					</c:forEach>
				</td>
				<td><c:out value="${strain.description}" default="&nbsp;" escapeXml="false"/></td>
			</tr>
			</c:forEach>
			</c:when>
			<c:otherwise>
			<!-- No results found.	//-->
			</c:otherwise>
			</c:choose>
			<!-- ////  End Results  //// -->
		</table>
	</jax:mmhcpage>
	
