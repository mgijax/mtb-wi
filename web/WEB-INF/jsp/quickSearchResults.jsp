<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Quick Search Results" help="interpreting">
	<table>
		<!-- ////  Start Search Summary  //// -->
		<caption><span class="label">Search Summary</span>
			<!-- \n -->
			<span class="label">Search For:</span> contains "${quickSearchTerm}"
			<!-- \n -->
			<span class="label">In these sections:</span> ${searchSections}
			<!-- \n -->
		</caption>
		<!-- ////  End Search Summary  //// -->
	</table>
	<!-- ////  Start Search Results List  //// -->
	<table>
		<c:choose>
		<c:when test="${not empty data}">
		<c:forEach var="result" items="${data}" varStatus="status">
		<!-- ////  Start ${result.searchName}  //// -->
		<tr>
			<td>
				<table class="results">
					<tr class="page-title">
						<td>
							<table>
								<tr>
									<td class="results-header-left">
										<h3>${result.searchName}</h3>
									</td>
									<td align="right">
										<a href="${result.mainSearchUrl}">${result.mainSearchName}</a>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>
				${result.searchCriteriaText}
			</td>
		</tr>
		<tr>
			<td>
				<c:choose>
				<c:when test="${not empty result.searchResultsText}">
				<c:choose>
				<c:when test="${fn:containsIgnoreCase(result.searchName, 'genetics')}">
				<table>
					<tr>
						<td>
							${result.searchResultsText}
						</td>
					</tr>
				</table>
				</c:when>
				<c:otherwise>
				<table class="results">
					${result.searchResultsText}
				</table>
				</c:otherwise>
				</c:choose>
				</c:when>
				<c:otherwise>
				</c:otherwise>
				</c:choose>
				<c:if test="${not fn:contains(result.searchResultsText, 'No results found')}">
				<!-- \n -->
				<a href="${result.viewAllUrl}">All...</a>
				</c:if>
				<!-- \n -->
				<!-- \n -->
				<hr>
				<!-- \n -->
				<!-- \n -->
			</td>
		</tr>
		<!-- ////  End ${result.searchName}  //// -->
		</c:forEach>
		</c:when>
		<c:otherwise>
		<!-- No results found. //-->
		</c:otherwise>
		</c:choose>
	</table>
	<!-- ////  End Search Results List  //// -->
</jax:mmhcpage>

