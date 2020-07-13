<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Cytogenetic Summary">
	<!-- ////  Start Frequency Records  //// -->
	<c:choose>
	<c:when test="${not empty tumor}">
	<table>
		<thead>
			<tr>
				<th>Chromosomes</th>
				<th>Name</th>
				<th>Note</th>
				<th>Type</th>
				<th>Assay Type</th>
				<th>Tumor Name</th>
				<th>Treatment Type</th>
				<th>Images</th>
				<th>Tumor Summary</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="genetics" items="${tumor}" varStatus="status">
			<tr>
				<td>
					<c:out value="${genetics.displayChromosomes}" escapeXml="false"/>
				</td>
				<td>
					<c:out value="${genetics.name}" escapeXml="false"/>
				</td>
				<td>
					<c:out value="${genetics.notes}" escapeXml="false"/>
				</td>
				<td>
					<c:out value="${genetics.alleleTypeName}" escapeXml="false"/>
				</td>
				<td>
					<c:out value="${genetics.assayType}" escapeXml="false"/>
				</td>
				<td>
					<c:out value="${genetics.tumorName}" escapeXml="false"/>
				</td>
				<td>
					<c:out value="${genetics.treatmentType}" escapeXml="false"/>
				</td>
				<td>
					<c:choose>
					<c:when test="${not empty genetics.assayImages}">
					<c:forEach var="image" items="${genetics.assayImages}">
					<a href="nojavascript.jsp" onClick="popPathWin('assayImageDetails.do?key=${image.assayImagesKey}&amp;page=pathology', '${image.assayImagesKey}');return false;">
						<img width="150" src="${applicationScope.assayImageURL}/${applicationScope.assayImagePath}/${image.lowResName}" alt="X">
					</a>
					<!-- \n -->
					<!-- \n -->
					</c:forEach>
					</c:when>
					</c:choose>
				</td>
				<td>
					<a href="tumorSummary.do?tumorFrequencyKeys=${genetics.tumorFrequencyKey}">Tumor Summary</a> 
				</td>
			</tr>
			</c:forEach>
		</tbody>
	</table>
	</c:when>
	<c:otherwise>
	<!-- There are no tumor frequency records associated with this tumor. -->
	</c:otherwise>
	</c:choose>
</jax:mmhcpage>

