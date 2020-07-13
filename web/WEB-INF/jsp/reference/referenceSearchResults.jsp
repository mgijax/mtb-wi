<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Reference Search Results">
	<jsp:attribute name="head">
		<link rel="stylesheet" type="text/css" href="./live/www/css/results.css"/>
		<script type="text/javascript" src="./live/www/js/results.js"></script>
	</jsp:attribute>
	<jsp:body>
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
				<%-- <jax:dl dt="Abstract" dd="contains '${abstract}'"/> --%>
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
		<tr>
			<th>Accession Id</th>
			<th>Reference</th>
		</tr>
		<c:forEach var="reference" items="${references}" varStatus="status">
		<tr>				<td><a href="referenceDetails.do?key=${reference.key}">${reference.accId}</a></td>
			<td>${reference.authors}, ${reference.title}, ${reference.citation}</td>
		</tr>
		</c:forEach>
		</c:when>
		<c:otherwise>
		<!-- No results found. //-->
		</c:otherwise>
		</c:choose>
	</table>
	</jsp:body>
</jax:mmhcpage>
