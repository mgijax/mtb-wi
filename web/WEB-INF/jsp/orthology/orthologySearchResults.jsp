<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Orthology Search Results" help="humangeneresults">
	<a name="top"></a>
	<table class="results">
		<!-- ////  Start Search Summary  //// -->
		<caption><span class="label">Search Summary</span>
			<!-- \n -->
		</caption>
		<caption><!-- ////  Start Display Limit  //// -->
			<table>
				<tr>
					<td><strong>Gene Identifier(s):</strong>
						<td>
							${humanGS}
						</caption>
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
				<th>Human Gene Symbol</th>
				<th>Mouse Gene Symbol</th>
				<th>Name</th>
				<th>Alleles/Transgenes in Strains</th>
				<th>Classes of Tumor Specific Alterations</th>
			</tr>
			<c:forEach var="rec" items="${orthos}" varStatus="status">
			<c:choose>
			<c:when test="${status.index%2==0}">
			<tr>
				</c:when>
				<c:otherwise>
				<tr>
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
		</jax:mmhcpage>
		
