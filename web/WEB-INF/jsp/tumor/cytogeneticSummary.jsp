<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib uri="http://tumor.informatics.jax.org/mtbwi/MTBWebUtils" prefix="wu" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>

<jax:mmhcpage title="Cytogenetic Summary" help="cytogeneticsummary">

<!-- ////  Start Frequency Records  //// -->

<c:choose>
	<c:when test="${not empty tumor}">

<table class="results">
	<tr>
		<td class="results-header">Chromosomes</td>
			<td class="results-header">Name</td>
				<td class="results-header">Note</td>
					<td class="results-header">Type</td>
						<td class="results-header">Assay Type</td>
							<td class="results-header">Tumor Name</td>
								<td class="results-header">Treatment Type</td>
								<td class="results-header">Images</td>
								<td class="results-header">Tumor Summary</td>
						</tr>

<c:forEach var="genetics" items="${tumor}" varStatus="status">
	<c:choose>
		<c:when test="${status.index%2==0}">
			<tr class="stripe-1">
				</c:when>
					<c:otherwise>
						<tr class="stripe-2">
							</c:otherwise>
								</c:choose>
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

</c:when>
	<c:otherwise>
		<!-- There are no tumor frequency records associated with this tumor. -->
		</c:otherwise>
		</c:choose>

<!-- ////  End Frequency Records  //// -->

<!-- ////  End Detail Section  //// -->

</jax:mmhcpage>

