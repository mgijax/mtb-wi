<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>

<table>
	<caption>
		Gene Expression Data

			
		

	</caption>
	
	<c:choose>
		<c:when test="${not empty results}"> 			
			<c:forEach var="series" items="${results}">
				<tbody>
					<c:choose>
						<c:when test="${not empty series.series.id}">
							<tr class="series-head series-summary">
								<td><a href="${series.siteURL}${series.series.id}" target="_blank"><c:out value="${series.series.id} " escapeXml="false"/> </a></td>
								<td><c:out value="${series.series.title}" escapeXml="false"/></td>
															
							</tr>
							
						</c:when>
						
					</c:choose>
					
				</tbody>
			</c:forEach> 
		</c:when>
		<c:otherwise>

		</c:otherwise>
	</c:choose>

</table>

