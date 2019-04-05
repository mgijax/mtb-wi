<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Human Gene List">
	<a name="top"></a>
	<table>
		<caption><span class="larger"></span></caption>				
		<tr>
			<th>Entrez Gene ID</th>
			<th>Human Gene Symbol</th>
			<th>Gene Name</th>
		</tr>
		<c:forEach var="rec" items="${symbols}" varStatus="status">
		<tr>
			<td><c:out value="GeneID:${rec.value}" default="&nbsp;" escapeXml="false"/>
			</td>
			<td>${rec.label}</td>
			<td>${rec.data}</td>
		</tr>
		</c:forEach>
		<tr class="buttons" ><td colspan="3">
				<a href="<c:url value='/orthologySearch.do?sortBy=HumanGS&compare=Equals&reference=${reference}'/>"><input type="button" value="Search MTB"></a>
		</td></tr>
	</table>
</jax:mmhcpage>
