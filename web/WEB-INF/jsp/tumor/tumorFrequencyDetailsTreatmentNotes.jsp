<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>

<c:if test="${not empty tumorFreq.note}">
<table>
	<caption>Treatment Note</caption>
	<!--
	<tr>
		<th>Note</th>
		<th>Reference</th>
	</tr>
	-->
	<tbody>
	<tr>
		<td>${tumorFreq.note}</td>
		<!--<td><a href="nojavascript.jsp" onclick="focusBackToOpener('referenceDetails.do?accId=${tumorFreq.reference}');return false;">${tumorFreq.reference}</a></td>-->
	</tr>
	</tbody>
</table>
</c:if>
