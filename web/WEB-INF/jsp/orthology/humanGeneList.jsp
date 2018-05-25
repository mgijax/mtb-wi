<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 

<jax:mmhcpage title="Human Gene List">

<a name="top"></a>

<!-- ////  Start Results  //// -->

<!-- ////  Start Strain Genetics Results List  //// -->

<table class="results">
		<tr>
			<td class="results-header-left" colspan="6"><span class="larger"></span></td>
		</tr>				
		<tr>
			<td class="results-header">Entrez Gene ID</td>
			<td class="results-header">Human Gene Symbol</td>
			<td class="results-header">Gene Name</td>
		</tr>

<c:forEach var="rec" items="${symbols}" varStatus="status">

<c:choose>
			<c:when test="${status.index%2==0}">
				<tr class="stripe-1">
			</c:when>
			<c:otherwise>
				<tr class="stripe-2">
			</c:otherwise>
		</c:choose>

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

