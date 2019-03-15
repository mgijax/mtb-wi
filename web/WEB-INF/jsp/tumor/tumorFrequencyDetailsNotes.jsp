<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Tumor Notes">
	<c:if test="${not empty tumorFreq.additionalNotes}">
	<table>
		<thead>
			<tr>
				<th>Note</th>
				<th>Reference</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="rec" items="${tumorFreq.additionalNotes}" varStatus="status">
			<tr>
				<td><c:out value="${rec.label}" escapeXml="false"/></td>
				<td><a href="nojavascript.jsp" onclick="focusBackToOpener('referenceDetails.do?key=${rec.data}');return false;">${rec.value}</a></td>
			</tr>
			</c:forEach>
		</tbody>
	</table>
	</c:if>
</jax:mmhcpage>
