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
		
		<th>Description</th>
		<th>Notes</th>
		<th>Age at Necropsy</th>
	</tr>
	</thead>
	
	<c:forEach var="rec" items="${tumorFreq.pathologyRecs}" varStatus="status">

	<tbody>
	<tr>
		
		<td><c:out value="${rec.description}" escapeXml="false" default="&nbsp;"/></td>
		<td><c:out value="${rec.note}" escapeXml="false" default="&nbsp;"/></td>	
		<td><c:out value="${rec.ageAtNecropsy}" escapeXml="false" default="&nbsp;"/></td>	
	</tr>
	<c:if test="${not empty rec.images}">
	
			
			<c:forEach var="image" items="${rec.images}" varStatus="status2">	
                            
                        <tr>
                            <td class="tumor-images" colspan="3">    
			<figure>
				<a href="pathologyImageDetails.do?key=${image.imageId}">
					<img src="${applicationScope.pathologyImageUrl}/${applicationScope.pathologyImagePath}/${image.imageThumbName}">
				</a>
				<figcaption>
				
					<div><h5>Image ID</h5>
					<p>${image.imageId}</p></div>
					<div><h5>Source of Image</h5>
					<p>
						<c:choose>
						<c:when test="${fn:length(image.institution) > 0}">
						${image.sourceOfImage}, ${image.institution}
						</c:when>
						<c:otherwise>
						${image.sourceOfImage}
						</c:otherwise>
						</c:choose>
					</p></div>
					<div><h5>Method / Stain</h5>
					<p>${image.stainMethod}</p></div>
					<h5>Image Caption</h5>
					<p>${image.imageCaption}</p>
				</figcaption>
                        </figure>
                                
                                </td>
                            </tr>
			</c:forEach>
			
		
	</c:if>
	</tbody>
	</c:forEach>
	
</table>
</c:if>
