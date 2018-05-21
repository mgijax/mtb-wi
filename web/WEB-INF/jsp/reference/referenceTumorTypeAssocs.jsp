<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<!doctype html>
<html>
<head>
	<c:set var="pageTitle" scope="request" value="Reference Tumor Type Associations"/>
	<c:import url="../../../meta.jsp"/>
</head>

<body>
	<c:import url="../../../body.jsp" />

<div class="wrap">
<nav><c:import url="../../../toolBar.jsp" /></nav>
<section class="main">

<header>
	<h1>${pageTitle}</h1>
	<a class="help" href="userHelp.jsp#referenceresults"></a>
</header>

<table class="results">

<!-- ////  Start Search Summary  //// -->

<tr class="summary">
				<td colspan="2">
						Probably put some reference details here
				</td>
				</tr>

<!-- ////  Start Display Limit  //// -->

<c:if test="${not empty tumorTypes}">
							 
								<tr class="results">
						<td class="results-header">Tumor Type</td>
						<td class="results-header">Index Type</td>
				</tr>

				<c:forEach var="tt" items="${tumorTypes}" varStatus="status">
						<c:choose>
								<c:when test="${status.index%2==0}">
										<tr class="stripe-1">
								</c:when>
								<c:otherwise>
										<tr class="stripe-2">
								</c:otherwise>
						</c:choose>

								<td>${tt.label}</td>
								<td>${tt.value}</td>
								
						</tr>
				</c:forEach>
							 
							 
							 
							 
							 
							 
							 
							 
					 </c:if>

<!-- ////  End Display Limit  //// -->

</table>

</section>
</div>
</body>
</html>
 

