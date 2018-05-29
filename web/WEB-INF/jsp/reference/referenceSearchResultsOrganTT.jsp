<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Reference Search Results" help="referenceresults">
	<table>
		<caption>
			<div class="search-summary">
				<h4>Search Summary</h4>
				<!-- \n -->
				<c:if test="${not empty accId}">
				<h5 class="label">Accession Id:</h5> ${accId}
				<!-- \n -->
				</c:if>
				<c:if test="${not empty firstAuthor}">
				<h5 class="label">First Author:</h5> ${firstAuthorComparison} "${firstAuthor}"
				<!-- \n -->
				</c:if>
				<c:if test="${not empty authors}">
				<h5 class="label">Authors:</h5> Contains "${authors}"
				<!-- \n -->
				</c:if>
				<c:if test="${not empty journal}">
				<h5 class="label">Journal:</h5> ${journalComparison} "${journal}"
				<!-- \n -->
				</c:if>
				<c:if test="${not empty year}">
				<h5 class="label">Year:</h5> ${yearComparison} ${year}
				<!-- \n -->
				</c:if>
				<c:if test="${not empty volume}">
				<h5 class="label">Volume:</h5> ${volumeComparison} "${volume}"
				<!-- \n -->
				</c:if>
				<c:if test="${not empty pages}">
				<h5 class="label">Pages:</h5> ${pagesComparison} "${pages}"
				<!-- \n -->
				</c:if>
				<c:if test="${not empty title}">
				<h5 class="label">Title:</h5> ${titleComparison} "${title}"
				<!-- \n -->
				</c:if>
				<c:if test="${not empty organ}">
				<h5 class="label">Organ:</h5> ${organ}
				<!-- \n -->
				</c:if>
				<c:if test="${not empty tumorType}">
				<h5 class="label">Tumor Type:</h5>${tumorType}
				<!-- \n -->
				</c:if>
				<%--
				<c:if test="${not empty abstract}">
				<strong>Abstract:</strong> contains ${abstract}
				<!-- \n -->
				</c:if>
				--%>
				<h5 class="label">Sort By:</h5> ${sortBy}
				<!-- \n -->
				<h5 class="label">Display Limit:</h5> ${maxItems} 
			</div>
			<div class="display-counts">
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
		<c:when test="${not empty references}">
		<thead>
			<tr>
				<th>Accession Id</th>
				<th>Reference</th>
				<th>Additional Info</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="reference" items="${references}" varStatus="status">
			<tr>
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
		</tbody>
		</c:when>
		<c:otherwise>
		<!-- No results found. //-->
		</c:otherwise>
		</c:choose>
	</table>
</jax:mmhcpage>
