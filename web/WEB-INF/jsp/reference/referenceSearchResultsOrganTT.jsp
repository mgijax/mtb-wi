<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Reference Search Results">
	<table>
		<caption>
			<div class="result-summary">
				<h4>Search Summary</h4>
				<jax:dl dt="Accession Id" dd="${accId}"/>
				<jax:dl dt="First Author" dd="${firstAuthorComparison} '${firstAuthor}'"/>
				<jax:dl dt="Authors" dd="Contains '${authors}'"/>
				<jax:dl dt="Journal" dd="${journalComparison} '${journal}'"/>
				<jax:dl dt="Year" dd="${yearComparison} ${year}"/>
				<jax:dl dt="Volume" dd="${volumeComparison} '${volume}'"/>
				<jax:dl dt="Pages" dd="${pagesComparison} '${pages}'"/>
				<jax:dl dt="Title" dd="${titleComparison} '${title}'"/>
				<jax:dl dt="Organ" dd="${organ}"/>
				<jax:dl dt="Tumor Type" dd="${tumorType}"/>
				<%-- <jax:dl dt="Abstract" dd="contains ${abstract}"/> --%>
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
