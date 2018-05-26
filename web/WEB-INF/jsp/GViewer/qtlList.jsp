<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="List of Selected Cancer QTLs" help="QTLList">
	<table>
		<c:choose>
		<c:when test="${not empty features}">
		<tr>
			<td colspan="2">
				<table class="results">
					<tr>
						<th>MGI ID</th>
						<th>QTL</th>
						<th>Name</th>
						<th>Organ</th>
						<th>Chromosome:Start..End</th>
						<th>Earliest Reference</th>
					</tr>
					<c:forEach var="feature" items="${features}">
					<c:set var="num" value="${num == 1 ? 2 : 1}"/>
					<tr>
						<td>${feature.mgiId}</td>
						<td><a href="gViewer.do?id=${feature.mgiId}&name=${feature.chromosome}:${feature.start}..${feature.end}&label=${feature.label}&primeRef=${feature.primeRef}&qtlName=${feature.name}" >${feature.label}</a></td>
						<td>${feature.name}</td>
						<td>${feature.organ}</td>
						<td>${feature.chromosome}:${feature.start}..${feature.end}</td>
						<td>${feature.primeRef}</td>
					</tr>
					</c:forEach>
				</table>
			</td>
		</tr>
		</c:when>
		</c:choose>
	</table>
</jax:mmhcpage>
