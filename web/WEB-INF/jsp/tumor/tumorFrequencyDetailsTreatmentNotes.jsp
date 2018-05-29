<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Tumor Treatment Note">
	<!-- ////  Start Additional Notes Records  //// -->
	<c:choose>
	<c:when test="${not empty tumorFreq.note}">
	<table>
		<caption>
			<h2>Treatment Note</h2>
		</caption>
		<thead>
			<tr>
				<th>Note</th>
				<th>Reference</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td>${tumorFreq.note}</td>
				<td><a href="nojavascript.jsp" onclick="focusBackToOpener('referenceDetails.do?accId=${tumorFreq.reference}');return false;">${tumorFreq.reference}</a></td>
			</tr>
		</tbody>
	</table>
	</c:when>
	<c:otherwise>
	<!-- No notes for this frequency record //-->
	</c:otherwise>
	</c:choose>
	<!-- ////  End Additional Notes Records  //// -->
</jax:mmhcpage>
