<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Strain Search Results" help="straindetail">
	<table>
		<caption>
			<div class="search-summary">
				<h4>Search Summary</h4>
				<!-- \n -->
				<c:if test="${not empty strainName}">
				<h5 class="label">Strain Name:</h5> ${strainComparison} "${strainName}"
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
				</c:if>
				<c:if test="${not empty geneticName}">
				<h5 class="label">Gene or Allele</h5> <em>(Symbol/Name/Synonym)</em>: Contains "${geneticName}"
				</c:if>
				<%--
				<c:if test="${not empty strainNotes}">
				<strong>Strain Notes:</strong> contains ${strainNotes}
				</c:if>
				--%>
				<c:if test="${not empty sites}">
				<h5 class="label">Other Database Links:</h5> ${sites}
				</c:if>
				<c:if test="${not empty jaxMiceStockNumber}">
				<h5 class="label">JAX<sup>&reg;</sup>Mice Stock No.:</h5> ${jaxMiceStockNumber}
				</c:if>
				<c:if test="${not empty accId}">
				<h5 class="label">Accession ID:</h5> ${accId}
				</c:if>
				<h5 class="label">Sort By:</h5> ${sortBy}
				<h5 class="label">Display Limit:</h5> ${maxItems}
			</div>
			<div class="display-counts"><!-- ////  Start Display Limit  //// -->
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

		<!-- ////  Start Results  //// -->
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
		<!-- ////  End Results  //// -->
	</table>
</jax:mmhcpage>

