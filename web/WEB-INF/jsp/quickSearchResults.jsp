<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Quick Search Results" help="interpreting">
	<table>
		<!-- ////  Start Search Summary  //// -->
		<caption>
			<div class="search-summary">				
				<h4>Search Summary</h4>
				<h5 class="label">Search For:</h5> contains "${quickSearchTerm}"
				<h5 class="label">In these sections:</h5> ${searchSections}
			</div>
		</caption>
	</table>	
	<c:choose>
	<c:when test="${not empty data}">
	<c:forEach var="result" items="${data}" varStatus="status">
	
	<table class="quick-search-results">
		<caption>
			<div class="search-summary">
				<h2>${result.searchName}</h2>
				<h3><a href="${result.mainSearchUrl}">${result.mainSearchName}</a></h3>
			</div>
			<div class="display-counts">
				${result.searchCriteriaText}
			</div>
		</caption>
		<c:choose>
		<c:when test="${not empty result.searchResultsText}">
		<tbody>	
			<c:choose>
			<c:when test="${fn:containsIgnoreCase(result.searchName, 'genetics')}">
			<tr>
				<td>
					${result.searchResultsText}
				</td>
			</tr>
			</c:when>
			<c:otherwise>
			${result.searchResultsText}
			</c:otherwise>
			</c:choose>
		</tbody>
		</c:when>
		<c:otherwise>
		</c:otherwise>
		</c:choose>
		<c:if test="${not fn:contains(result.searchResultsText, 'No results found')}">
		<tfoot>
			<tr>
				<td>
					<a href="${result.viewAllUrl}">All...</a>
				</td>
			</tr>
		</tfoot>
		</c:if>
	</table>
	</c:forEach>
	</c:when>
	<c:otherwise>
	<!-- No results found. //-->
	</c:otherwise>
	</c:choose>
</jax:mmhcpage>
