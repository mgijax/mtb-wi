<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib uri="http://tumor.informatics.jax.org/mtbwi/MTBWebUtils" prefix="wu" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>

<jax:mmhcpage title="List of Selected Cancer QTLs" help="QTLList">

<table class="results">

<!-- ////  Start Detail Section  //// -->

<tr>
	<td colspan="2">

<c:choose>
	<c:when test="${not empty features}">
		<tr>
			<td colspan="2">

<table class="results">
	<tr>
		<td class="results-header">MGI ID</td>
			<td class="results-header">QTL</td>
				<td class="results-header">Name</td>
					<td class="results-header">Organ</td>
						<td class="results-header">Chromosome:Start..End</td>
							<td class="results-header">Earliest Reference</td>

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

