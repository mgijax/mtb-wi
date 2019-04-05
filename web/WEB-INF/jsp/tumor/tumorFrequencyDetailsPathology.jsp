<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>

<c:if test="${not empty tumorFreq.pathologyRecs}">
<table>
	<caption>
		Pathology <span>&mdash; ${tumorFreq.numPathologyRecs} entr${tumorFreq.numPathologyRecs != 1 ? 'ies' : 'y'}, ${tumorFreq.numImages} image<c:if test="${tumorFreq.numImages != 1}">s</c:if></span>
	</caption>
	<thead>
	<tr>
		<th>Age at Necropsy</th>
		<th>Description</th>
		<th>Notes</th>
		<th>Images</th>
	</tr>
	</thead>
	<tbody>
	<c:forEach var="rec" items="${tumorFreq.pathologyRecs}" varStatus="status">
	<c:set var="rowSpan" value="${fn:length(rec.images)}"/>
	<c:if test="${rowSpan < 1}">
	<c:set var="rowSpan" value="1"/>
	</c:if>
	
	<tr>
		<td><c:out value="${rec.ageAtNecropsy}" escapeXml="false" default="&nbsp;"/></td>
		<td><c:out value="${rec.description}" escapeXml="false" default="&nbsp;"/></td>
		<td><c:out value="${rec.note}" escapeXml="false" default="&nbsp;"/></td>
		<td class="tumor-images">
			<c:if test="${not empty rec.images}">
			<c:forEach var="image" items="${rec.images}" varStatus="status2">																
			<figure>
				<a href="pathologyImageDetails.do?key=${image.imageId}">
					<img width="150" src="${applicationScope.pathologyImageUrl}/${applicationScope.pathologyImagePath}/${image.imageThumbName}">
				</a>
				<figcaption>
					<h4>Image ID</h4>:
					<p>${image.imageId}</p>
					<h4>Source of Image</h4>:
					<p>
						<c:choose>
						<c:when test="${fn:length(image.institution) > 0}">
						${image.sourceOfImage}, ${image.institution}
						</c:when>
						<c:otherwise>
						${image.sourceOfImage}
						</c:otherwise>
						</c:choose>
					</p>
					<h4>Method / Stain</h4>:
					<p>${image.stainMethod}</p>
					<h4>Image Caption</h4>:
					${image.imageCaption}
				</figcaption>
			</figure>
			</c:forEach>
			</c:if>
		</td>
	</tr>
	</c:forEach>
	</tbody>
</table>
</c:if>
