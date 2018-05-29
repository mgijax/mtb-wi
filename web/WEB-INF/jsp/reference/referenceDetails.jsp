<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Reference Detail" help="referencedetail">
	<table>
		<caption>
			<h2>Reference</h2>
		</caption>
		<tbody>
			<tr>
				<td><h4>Title: </h4></td>
				<td >${reference.title}${reference.title2}</td>
			</tr>
			<tr>
				<td><h4>Authors: </h4></td>
				<td >${reference.authors}${reference.authors2}</td>
			</tr>
			<tr>
				<td><h4>Journal: </h4></td>
				<td >${reference.journal}</td>
			</tr>
			<tr>
				<td><h4>Volume: </h4></td>
				<td >${reference.volume}</td>
			</tr>
			<tr>
				<td><h4>Issue: </h4></td>
				<td >${reference.issue}</td>
			</tr>
			<%--
			<tr>
				<td><h4>Date: </h4></td>
				<td >${reference.referenceDate}</td>
			</tr>
			//--%>
			<tr>
				<td><h4>Year: </h4></td>
				<td >${reference.year}</td>
			</tr>
			<tr>
				<td><h4>Pages: </h4></td>
				<td >${reference.pages}</td>
			</tr>
			<%--
			<tr>
				<td><h4>Review Status: </h4></td>
				<td ><em>Not implemented.</em></td>
			</tr>
			--%>
			<tr>
				<td><h4>Abstract: </h4></td>
				<td >${reference.abstractText}</td>
			</tr>
		</tbody>
	</table>
	<!-- ////  Start Reference Additional Info  //// -->
	<c:choose>
	<c:when test="${not empty reference.additionalInfo}">
	<c:if test="${reference.hasAdditionalInfo}">
	<table id="additional-info">
		<caption>
			<h2>Additional Information</h2>
		</caption>
		<tbody>
			<c:forEach var="info" items="${reference.additionalInfo}" varStatus="status">
			<c:choose>
			<c:when test="${info.label=='Tumor Records'}">
			<c:if test="${info.value!=0}">
			<tr><td>${info.label} (<a href="tumorSearchResults.do?referenceKey=${reference.key}&maxItems=No+Limit">${info.value}</a>)</td></tr>
			</c:if>
			</c:when>
			<c:when test="${info.label=='Strains'}">
			<c:if test="${info.value!=0}">
			<tr><td>${info.label} (<a href="strainSearchResults.do?referenceKey=${reference.key}&maxItems=No+Limit">${info.value}</a>)</td></tr>
			</c:if>
			</c:when>
			<c:when test="${info.label=='Pathology Images'}">
			<c:if test="${info.value!=0}">
			<tr><td>${info.label} (<a href="pathologyImageSearchResults.do?referenceKey=${reference.key}&maxItems=No+Limit">${info.value}</a>)</td></tr>
			</c:if>
			</c:when>
			<c:otherwise>
			<!-- ERROR //-->
			</c:otherwise>
			</c:choose>
			</c:forEach>
		</tbody>
	</table>
	</c:if>
	</c:when>
	<c:otherwise>
	<!-- There is no additional information in MTB associated with this reference. //-->
	</c:otherwise>
	</c:choose>
	<!-- ////  Start Other Accession Ids  //// -->
	<c:choose>
	<c:when test="${not empty reference.otherAccessionIds}">
	<table id="other-accession-ids">
		<caption>
			<h2>Other Accession IDs</h2>
		</caption>
		<tbody>
			<c:forEach var="info" items="${reference.otherAccessionIds}" varStatus="status">
			<tr>
				<td>
					${info.data}&nbsp; <a target="_new" href="${info.value}">${info.label}</a>
				</td>
			</tr>
			</c:forEach>
		</tbody>
	</table>
	</c:when>
	<c:otherwise>
	<!-- There are no other Accession Ids in MTB associated with this reference. //-->
	</c:otherwise>
	</c:choose>
</jax:mmhcpage>


