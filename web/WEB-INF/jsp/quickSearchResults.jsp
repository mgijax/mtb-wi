<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Quick Search Results" help="interpreting">
	<jsp:attribute name="head">
		<link rel="stylesheet" type="text/css" href="./live/www/css/results.css"/>
		<script type="text/javascript" src="./live/www/js/results.js"></script>
	</jsp:attribute>
	<jsp:body>
	<table>
		<caption>
			<div class="result-summary">				
				<h4>Search Summary</h4>
				<jax:dl dt="Search For" dd="contains '${quickSearchTerm}'"/>
				<jax:dl dt="In these sections" dd="${searchSections}"/>
			</div>
		</caption>
	</table>	
	<c:choose>
	<c:when test="${not empty data}">
	<c:forEach var="result" items="${data}" varStatus="status">
	<table>
		<caption>
			<div class="result-summary">
				<h4>${result.searchName}</h4>
				<h5><a href="${result.mainSearchUrl}">${result.mainSearchName}</a></h5>
				<div>
					${result.searchCriteriaText}
				</div>
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
	</jsp:body>
</jax:mmhcpage>

