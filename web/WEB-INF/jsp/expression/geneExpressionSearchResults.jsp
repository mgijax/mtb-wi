<%@page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Gene Expression Data Set Search Results" help="geneexpression">
	<table>
		<!-- ////  Start Search Summary  //// -->
		<caption><h5 class="label">Search Summary</h5>
			<!-- \n -->
			<c:if test="${not empty organs}">
			<c:choose>
			<c:when test="${fn:length(organs)>1}">
			<h5 class="label">Organs:</h5>
			</c:when>
			<c:otherwise>	
			<h5 class="label">Organ:</h5>
			</c:otherwise>
			</c:choose>
			<c:forEach var="organ" items="${organs}" varStatus="status">
			<c:choose>
			<c:when test="${status.last != true}">
			${organ},
			</c:when>
			<c:otherwise>
			${organ}
			</c:otherwise>
			</c:choose>
			</c:forEach>
			<!-- \n -->
			</c:if>
			<c:if test="${not empty tumorClassifications}">
			<c:choose>
			<c:when test="${fn:length(tumorClassifications)>1}">
			<h5 class="label">Tumor Classifications:</h5>
			</c:when>
			<c:otherwise>	
			<h5 class="label">Tumor Classification:</h5>
			</c:otherwise>
			</c:choose>
			<c:forEach var="classification" items="${tumorClassifications}" varStatus="status">
			<c:choose>
			<c:when test="${status.last != true}">
			${classification},
			</c:when>
			<c:otherwise>
			${classification}
			</c:otherwise>
			</c:choose>
			</c:forEach>
			<!-- \n -->
			</c:if>
			<c:if test="${not empty strainName}">
			<h5 class="label">Strain:</h5> ${strainName}
			<!-- \n -->
			</c:if>
			<c:if test="${not empty platforms}">
			<c:choose>
			<c:when test="${fn:length(platforms)>1}">
			<h5 class="label">Platforms:</h5>
			</c:when>
			<c:otherwise>	
			<h5 class="label">Platform:</h5>
			</c:otherwise>
			</c:choose>
			<c:forEach var="platform" items="${platforms}" varStatus="status">
			<c:choose>
			<c:when test="${status.last != true}">
			${platform},
			</c:when>
			<c:otherwise>
			${platform}
			</c:otherwise>
			</c:choose>
			</c:forEach>
			<!-- \n -->
			</c:if>
			<c:choose>
			<c:when test="${not empty samplesWOSeries || not empty seriesWSamples}">
			<c:choose>
			<c:when test="${not empty seriesWSamples}">
			<c:choose>
			<c:when test="${seriesWSamples == '1'}">
			<h5 class="label">${seriesWSamples} series has matching samples </h5>
			<!-- \n -->
			</c:when>
			<c:otherwise>
			<h5 class="label">${seriesWSamples} series have matching samples </h5>
			<c:forEach var="series" items="${results}" >
			<c:choose>
			<c:when test="${not empty series.series.id}">
			<a href="#${series.series.id}">${series.series.id}</a>
			</c:when>
			</c:choose>
			</c:forEach>
			</c:otherwise>
			</c:choose>
			</c:when>
			</c:choose>
			<c:choose>
			<c:when test="${not empty samplesWOSeries}">
			<!-- \n -->
			<c:choose>
			<c:when test="${samplesWOSeries == '1'}">
			<h5 class="label">${samplesWOSeries} matching sample not associated with a series </h5>
			<!-- \n -->
			</c:when>
			<c:otherwise>
			<h5 class="label">${samplesWOSeries} matching samples not associated with any series </h5>
			<!-- \n -->
			</c:otherwise>
			</c:choose>
			</c:when>
			</c:choose>
			</c:when>
			<c:otherwise>
			<h5 class="label">All samples for ${seriesId} </h5>
			<!-- \n -->
			</c:otherwise>
			</c:choose>
		</caption>
		<caption>		</caption>
		<!-- ////  End Search Summary  //// -->
		<!-- ////  Start Results  //// -->
		<c:choose>
		<c:when test="${not empty results}"> 
		<c:set var="lbl" value="1"/>
		<c:forEach var="series" items="${results}" >
		<c:choose>
		<c:when test="${not empty series.series.id}">
		<tr>
			<th><a name="${series.series.id}">Series ID</a></th>
			<th>Title</th>
			<th>Summary</th>
		</tr>
		<tr>
			<td colspan="1"><a href="${series.siteURL}${series.series.id}"><c:out value="${series.series.id} " escapeXml="false"/></a>
				<!-- \n -->
				<!-- \n -->
				<c:if test="${empty seriesId}">
				<c:out value="${series.sampleCount} of " escapeXml="false"/>
				<a href="geneExpressionSearchResults.do?seriesId=${series.series.id}"><c:out value="${series.totalSamples} samples" escapeXml="false"/></a>
				<!-- \n -->
				match the search criteria
				</c:if>
			</td>
			<td colspan="2"><c:out value="${series.series.title}" escapeXml="false"/></td>
			<td colspan="2"><c:out value="${series.series.summary}" escapeXml="false"/>
				<c:if test="${fn:length(series.series.summary)>=499}">
				<a href="${series.siteURL}${series.series.id}">...</a>
				</c:if>
			</td>
		</tr>
		</c:when>
		<c:otherwise>
		<tr>
			<th>Matching samples not associated with any series</th>
		</tr>
		</c:otherwise>
		</c:choose>
		<tr>
			<th>Sample ID</th>
			<th>Title</th>
			<th>Summary</th>
			<th>Platform</th>
			<th>MTB Details</th>
		</tr>
		<c:forEach var="sample" items="${series.samples}" varStatus="status">
		<c:choose>
		<c:when test="${status.index%2==0}">
		<tr>
			</c:when>
			<c:otherwise>
			<tr>
				</c:otherwise>
				</c:choose>
				<c:choose>
				<c:when test="${empty sample.url}">
				<td colspan="1"><c:out value="${sample.id}" escapeXml="false"/>
					</c:when>
					<c:otherwise>
					<td colspan="1"><a href="${sample.url}"><c:out value="${sample.id}" escapeXml="false"/></a>
						</c:otherwise>
						</c:choose>
						<!-- \n -->
						<c:choose> 
						<c:when test="${sample.isControl}">
						<!-- \n -->
						Control sample
						</c:when>
						</c:choose>
					</td>
					<td colspan="1"><c:out value="${sample.title}" escapeXml="false"/></td>
					<td colspan="1"><c:out value="${sample.summary}" escapeXml="false"/></td>
					<td colspan="1"><c:out value="${sample.platform}" escapeXml="false"/></td>
					<td colspan="1"><a href="summaryByExample.do?tumorFrequencyKeys=${sample.dataBean['tfKey']}"><c:out value="${sample.dataBean['tfDetail']}" escapeXml="false"/></a></td>
				</tr>
				</c:forEach>
				</c:forEach>
				</c:when>
				<c:otherwise>
				<tr><td> No results found. </td></tr>
				</c:otherwise>
				</c:choose>
				<!-- ////  End Results  //// -->
			</table>
		</jax:mmhcpage>
		
