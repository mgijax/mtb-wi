<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 

<jax:mmhcpage title="Tumor Pathology Report/Images">

<!-- ////  Start Pathology Records  //// -->

<c:choose>
		<c:when test="${not empty tumorFreq.pathologyRecs}">
				<a name="pathology"></a>

<table class="results">
						<tr>
								<td colspan="4" class="results-header-left">
										<span class="larger">Pathology</span>
										&nbsp;&nbsp;&nbsp;&nbsp;
										<c:choose>
										<c:when test="${tumorFreq.numPathologyRecs!=1}">
												${tumorFreq.numPathologyRecs} entries
										</c:when>
										<c:otherwise>
												${tumorFreq.numPathologyRecs} entry
										</c:otherwise>
										</c:choose>
										&nbsp;&nbsp;&nbsp;&nbsp;
										<c:choose>
										<c:when test="${tumorFreq.numImages!=1}">
												${tumorFreq.numImages} images
										</c:when>
										<c:otherwise>
												${tumorFreq.numImages} image
										</c:otherwise>
										</c:choose>
								</td>
						</tr>
						<tr>
								<td class="results-header">Age at Necropsy</td>
								<td class="results-header">Description</td>
								<td class="results-header">Notes</td>
								<td class="results-header">Images</td>
						</tr>
	<c:set var="lbl" value="1"/>
	<c:set var="rowClass" value="stripe1"/>

<c:forEach var="rec" items="${tumorFreq.pathologyRecs}" varStatus="status">
	<c:set var="lbl" value="${lbl+1}"/>
	<c:set var="rowClass" value="stripe${(lbl%2)+1}"/>
	<c:set var="rowSpan" value="${fn:length(rec.images)}"/>

<c:if test="${rowSpan<1}">
	<c:set var="rowSpan" value="1"/>
								</c:if>

<tr class="${rowClass}">

<td rowspan="${rowSpan}"><c:out value="${rec.ageAtNecropsy}" escapeXml="false" default="&nbsp;"/></td>
										<td rowspan="${rowSpan}"><c:out value="${rec.description}" escapeXml="false" default="&nbsp;"/></td>
										<td rowspan="${rowSpan}"><c:out value="${rec.note}" escapeXml="false" default="&nbsp;"/></td>

<c:choose>
												<c:when test="${not empty rec.images}">
														<c:forEach var="image" items="${rec.images}" varStatus="status2">

<c:if test="${status2.first!=true}">
																		<tr class="${rowClass}">
																</c:if>

<td>																
																<table>
																		<tr>
																				<td width="160">

<a href="pathologyImageDetails.do?key=${image.imageId}">
																						<img width="150" src="${applicationScope.pathologyImageUrl}/${applicationScope.pathologyImagePath}/${image.imageThumbName}"></a>
																				</td>
																				<td align="left">
																						<table align="left">
																								<tr>
																										<td class="small" align="right"><strong>Image ID</strong>:</td>
																										<td class="small">${image.imageId}</td>
																								</tr>
																								<tr>
																										<td class="small" align="right"><strong>Source of Image</strong>:</td>
																										<td class="small">
																												<c:choose>
																												<c:when test="${fn:length(image.institution) > 0}">
																														${image.sourceOfImage}, ${image.institution}
																												</c:when>
																												<c:otherwise>
																														${image.sourceOfImage}
																												</c:otherwise>
																												</c:choose>
																										</td>
																								</tr>
																								<tr>
																										<td class="small" align="right"><strong>Method / Stain</strong>:</td>
																										<td class="small">${image.stainMethod}</td>
																								</tr>
																						</table>
																				</td>
																		</tr>
																		<tr>
																				<td class="small" colspan=2>
																						<strong>Image Caption</strong>:
<!-- \n -->

${image.imageCaption}
																				</td>
																		</tr>
																</table>

</td>
														</tr>
														</c:forEach>
												</c:when>
												<c:otherwise>
														<!--There are no pathology images associated with this pathology entry. //-->
														<td></td>
												</c:otherwise>
												</c:choose>
						</c:forEach>
				</table>
		</c:when>
		<c:otherwise>
				<!-- There are no pathology records associated with this tumorFreq. -->
		</c:otherwise>
		</c:choose>

<!-- ////  End Pathology Records  //// -->

</jax:mmhcpage>

