<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<!doctype html>
<html>
<head>
	<c:import url="../../../meta.jsp">
		<c:param name="pageTitle" value="Orthology Search Results"/>
	</c:import>
</head>

<body>
	<c:import url="../../../body.jsp" />

<a name="top"></a>

<div class="wrap">
<nav><c:import url="../../../toolBar.jsp" /></nav>
<section class="main">

<header>
	<h1>Orthology Search Results</h1>
	<a class="help" href="userHelp.jsp#humangeneresults"></a>
</header>
<table class="results">

<!-- ////  Start Search Summary  //// -->

<tr class="summary">
							<td>
								<span class="label">Search Summary</span>
<!-- \n -->

								
							</td> 
						</tr>
						<tr class="summary">
							<td>

<!-- ////  Start Display Limit  //// -->

<table>
							<tr>
								<td><strong>Gene Identifier(s):</strong>
								<td>
								 ${humanGS}
								</td>
							</tr>
						</tr>
						<tr>
								<td><strong>Sort By:</strong>
								<td>
								 ${sortBy}
								</td>
							</tr>
					 
					</table>

<!-- ////  End Display Limit  //// -->

</td>
			</tr>
		</table>

<!-- ////  End Search Summary  //// -->

<!-- \n -->

<!-- ////  Start Results  //// -->

<!-- ////  Start Strain Genetics Results List  //// -->

<table class="results">
		<tr>
			<td class="results-header-left" colspan="6"><span class="larger"></span></td>
		</tr>				
		<tr>
			<td class="results-header">Human Gene Symbol</td>
			<td class="results-header">Mouse Gene Symbol</td>
			<td class="results-header">Name</td>
			<td class="results-header">Alleles/Transgenes in Strains</td>
			<td class="results-header">Classes of Tumor Specific Alterations</td>
		</tr>
		
		<c:forEach var="rec" items="${orthos}" varStatus="status">
		
		<c:choose>
			<c:when test="${status.index%2==0}">
				<tr class="stripe-1">
			</c:when>
			<c:otherwise>
				<tr class="stripe-2">
			</c:otherwise>
		</c:choose>
		
		
		<td><c:out value="${rec.humanGS}" default="&nbsp;" escapeXml="false"/></td>
		<td><a href="http://www.informatics.jax.org/marker/key/${rec.mgiGSKey}">${rec.mouseGS}</a></td>
		<td>${rec.symbol}</td>
		<c:choose>
		<c:when test="${rec.strains!='0'}">
		<td><a href="geneticsSearchResults.do?sortBy=Gene+Symbol&markerNameComparison=Equals&markerName=${rec.mouseGS}">${rec.strains}</a></td>
		</c:when>
		<c:otherwise>
			<td>${rec.strains}</td>
		</c:otherwise>
	</c:choose>
		<c:choose>
		<c:when test="${rec.tumors!='0'}">
		 <td><a href="geneticsSearchResults.do?sortBy=Gene+Symbol&markerNameComparison=Equals&markerName=${rec.mouseGS}#tumorGenetics">${rec.tumors}</a></td>
		</c:when>
		<c:otherwise>
			<td>${rec.tumors}</td>
		</c:otherwise>
	</c:choose>
	</tr>
	</c:forEach>
	<html:form action="orthologySearch" method="GET">
	<tr class="buttons"><td colspan="6"><input type="submit" value="Search Again"/></td></tr>
</html:form>
	
</table>

<!-- ////  End Results  //// -->


</section>
</div>
</body>
</html>
 
