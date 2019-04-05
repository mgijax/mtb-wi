<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Orthology Search Results" help="humangeneresults">
	<jsp:attribute name="head">
		<link rel="stylesheet" type="text/css" href="./live/www/css/results.css"/>
		<script type="text/javascript" src="./live/www/js/results.js"></script>
	</jsp:attribute>
	<jsp:body>
	<a name="top"></a>
	<table>
		<caption>
			<div class="result-summary">
				<h4>Search Summary</h4>
				<jax:dl dt="Gene Identifier(s)" dd="${humanGS}"/>
				<jax:dl dt="Sort By" dd="${sortBy}"/>
			</div>
		</caption>
		<thead>			
			<tr>
				<th>Human Gene Symbol</th>
				<th>Mouse Gene Symbol</th>
				<th>Name</th>
				<th>Alleles/Transgenes in Strains</th>
				<th>Classes of Tumor Specific Alterations</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="rec" items="${orthos}" varStatus="status">
			<tr>					
				<td><c:out value="${rec.humanGS}" default="&nbsp;" escapeXml="false"/></td>
				<td><a href="http://www.informatics.jax.org/marker/key/${rec.mgiGSKey}">${rec.mouseGS}</a></td>
				<td>${rec.symbol}</td>
				<c:choose>
				<c:when test="${rec.strains!='0'}">
				<td><a href="geneticsSearchResults.do?sortBy=Gene+Symbol&markerNameComparison=Equals&markerName=${rec.mouseGS}">${rec.strains}</a></td>
				</c:when>
				<c:otherwise>
				<td>${rec.strains}</td>
				</c:otherwise>
				</c:choose>
				<c:choose>
				<c:when test="${rec.tumors!='0'}">
				<td><a href="geneticsSearchResults.do?sortBy=Gene+Symbol&markerNameComparison=Equals&markerName=${rec.mouseGS}#tumorGenetics">${rec.tumors}</a></td>
				</c:when>
				<c:otherwise>
				<td>${rec.tumors}</td>
				</c:otherwise>
				</c:choose>
			</tr>
			</c:forEach>
		</tbody>
		<tfoot>
			<html:form action="orthologySearch" method="GET">
			<tr class="buttons"><td colspan="5"><input type="submit" value="Search Again"/></td></tr>
			</html:form>
		</tfoot>
	</table>
	</jsp:body>
</jax:mmhcpage>
