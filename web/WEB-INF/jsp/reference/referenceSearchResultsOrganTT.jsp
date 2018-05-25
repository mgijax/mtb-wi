<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>

<jax:mmhcpage title="Reference Search Results" help="referenceresults">

<table class="results">

<!-- ////  Start Search Summary  //// -->

<tr class="summary">
	<td colspan="3">
		<span class="label">Search Summary</span>
<!-- \n -->

<c:if test="${not empty accId}">
	<span class="label">Accession Id:</span> ${accId}
<!-- \n -->

</c:if>

<c:if test="${not empty firstAuthor}">
	<span class="label">First Author:</span> ${firstAuthorComparison} "${firstAuthor}"
<!-- \n -->

</c:if>

<c:if test="${not empty authors}">
	<span class="label">Authors:</span> Contains "${authors}"
<!-- \n -->

</c:if>

<c:if test="${not empty journal}">
	<span class="label">Journal:</span> ${journalComparison} "${journal}"
<!-- \n -->

</c:if>

<c:if test="${not empty year}">
	<span class="label">Year:</span> ${yearComparison} ${year}
<!-- \n -->

</c:if>

<c:if test="${not empty volume}">
	<span class="label">Volume:</span> ${volumeComparison} "${volume}"
<!-- \n -->

</c:if>

<c:if test="${not empty pages}">
	<span class="label">Pages:</span> ${pagesComparison} "${pages}"
<!-- \n -->

</c:if>

<c:if test="${not empty title}">
	<span class="label">Title:</span> ${titleComparison} "${title}"
<!-- \n -->

</c:if>

<c:if test="${not empty organ}">
	<span class="label">Organ:</span> ${organ}
<!-- \n -->

</c:if>

<c:if test="${not empty tumorType}">
	<span class="label">Tumor Type:</span>${tumorType}
<!-- \n -->

</c:if>

<%--
	<c:if test="${not empty abstract}">
		<strong>Abstract:</strong> contains ${abstract}
<!-- \n -->

</c:if>
	--%>

<span class="label">Sort By:</span> ${sortBy}
<!-- \n -->

<span class="label">Display Limit:</span> ${maxItems} 
	</td>
		</tr>
		<tr class="summary">
			<td colspan="3">

<!-- ////  Start Display Limit  //// -->

<c:choose>
	<c:when test="${numberOfResults != totalResults}">
		${numberOfResults} of ${totalResults} matching items displayed.
			</c:when>
				<c:otherwise>
					<c:out value="${numberOfResults}" default="0"/> matching items displayed.
						</c:otherwise>
						</c:choose>

<!-- ////  End Display Limit  //// -->

</td>
	</tr>

<!-- ////  End Search Summary  //// -->

<!-- ////  Start Results  //// -->

<c:choose>
	<c:when test="${not empty references}">
		<tr class="results">
			<td class="results-header">Accession Id</td>
				<td class="results-header">Reference</td>
					<td class="results-header">Additional Info</td>
				</tr>

<c:forEach var="reference" items="${references}" varStatus="status">
	<c:choose>
		<c:when test="${status.index%2==0}">
			<tr class="stripe-1">
				</c:when>
					<c:otherwise>
						<tr class="stripe-2">
							</c:otherwise>
						</c:choose>

<td><a href="referenceDetails.do?key=${reference.key}">${reference.accId}</a></td>
	<td>${reference.authors}, ${reference.title}, ${reference.citation}</td>
		<td style="white-space: nowrap">

<c:if test="${reference.tumorFreqAssocs > 0}">
	Curated Tumor Records: <a href="tumorSearchResults.do?referenceKey=${reference.key}&maxItems=No+Limit">${reference.tumorFreqAssocs}</a>
<!-- \n -->

</c:if>

<c:if test="${reference.strainAssocs > 0}">
	Curated Strains: <a href="strainSearchResults.do?referenceKey=${reference.key}&maxItems=No+Limit">${reference.strainAssocs}</a>
<!-- \n -->

</c:if>

<c:if test="${reference.tumorFreqAssocs ==0 && reference.tumorTypeAssocs > 0}">
	Indexed Tumor Types: <a href="referenceTumorTypeAssocs.do?referenceKey=${reference.key}">${reference.tumorTypeAssocs}</a>
<!-- \n -->

</c:if>

<c:if test="${reference.isReviewArticle}">
	<strong>Review Article</strong>
		</c:if>
			</td>	 
						</tr>
				</c:forEach>
		</c:when>
		<c:otherwise>
		<!-- No results found. //-->
		</c:otherwise>
</c:choose>

<!-- ////  End Results  //// -->

</table>

</jax:mmhcpage>

