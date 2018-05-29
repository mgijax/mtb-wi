<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Tumor Notes">
	<table>
		<tr>
			<td>
				<!-- ////  Start Additional Notes Records  //// -->
				<c:choose>
				<c:when test="${not empty tumorFreq.additionalNotes}">
				<table>
					<tr>
						<td colspan="2" class="results-header-left">
							<h3>Additional Notes</h3>
						</td>
					</tr>
					<tr>
						<th>Note</th>
						<th>Reference</th>
					</tr>
					<c:set var="noteRow" value="2"/>
					<c:forEach var="rec" items="${tumorFreq.additionalNotes}" varStatus="status">
					<c:set var="noteRow" value="${noteRow == 1 ? 2 : 1}"/>
					<tr>
						<td><c:out value="${rec.label}" escapeXml="false"/></td>
						<td><a href="nojavascript.jsp" onclick="focusBackToOpener('referenceDetails.do?key=${rec.data}');return false;">${rec.value}</a></td>
					</tr>
					</c:forEach>
				</table>
				</c:when>
				<c:otherwise>
				<!-- No notes for this frequency record //-->
				</c:otherwise>
				</c:choose>
				<!-- ////  End Additional Notes Records  //// -->
			</td>
		</tr>
	</table>
</jax:mmhcpage>
			
