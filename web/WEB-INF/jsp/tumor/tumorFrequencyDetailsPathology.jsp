<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Tumor Pathology Report/Images">
	<c:choose>
	<c:when test="${not empty tumorFreq.pathologyRecs}">
	<a name="pathology"></a>
	<table>
		<caption>
			<h2>Pathology</h2>
			<div class="display-counts">
				<c:choose>
				<c:when test="${tumorFreq.numPathologyRecs!=1}">
				${tumorFreq.numPathologyRecs} entries
				</c:when>
				<c:otherwise>
				${tumorFreq.numPathologyRecs} entry
				</c:otherwise>
				</c:choose>
				<c:choose>
				<c:when test="${tumorFreq.numImages!=1}">
				${tumorFreq.numImages} images
				</c:when>
				<c:otherwise>
				${tumorFreq.numImages} image
				</c:otherwise>
				</c:choose>
			</div>
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
			<c:if test="${rowSpan<1}">
			<c:set var="rowSpan" value="1"/>
			</c:if>
			
			<tr>
				<td><c:out value="${rec.ageAtNecropsy}" escapeXml="false" default="&nbsp;"/></td>
				<td><c:out value="${rec.description}" escapeXml="false" default="&nbsp;"/></td>
				<td><c:out value="${rec.note}" escapeXml="false" default="&nbsp;"/></td>
				<td class="tumor-images">
					<c:choose>
					<c:when test="${not empty rec.images}">
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
							<!-- \n -->
							${image.imageCaption}
						</figcaption>
					</figure>
					</c:forEach>
					</c:when>
					<c:otherwise>
					<!--There are no pathology images associated with this pathology entry. //-->
					</c:otherwise>
					</c:choose>
				</td>
			</tr>
			</c:forEach>
		</tbody>
	</table>
	</c:when>
	<c:otherwise>
	<!-- There are no pathology records associated with this tumorFreq. -->
	</c:otherwise>
	</c:choose>
	<!-- ////  End Pathology Records  //// -->
</jax:mmhcpage>




