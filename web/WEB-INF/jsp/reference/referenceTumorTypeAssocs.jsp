<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Reference Tumor Type Associations" help="referenceresults">
	<table>
		<caption>Probably put some reference details here</caption>
		<c:if test="${not empty tumorTypes}">
		<thead>
			<tr>
				<th>Tumor Type</th>
				<th>Index Type</th>
			</tr>
		</thead>
		
		<tbody>
			<c:forEach var="tt" items="${tumorTypes}" varStatus="status">
			<tr>
				<td>${tt.label}</td>
				<td>${tt.value}</td>
			</tr>
			</c:forEach>
			</c:if>
		</tbody>
		
	</table>
</jax:mmhcpage>

