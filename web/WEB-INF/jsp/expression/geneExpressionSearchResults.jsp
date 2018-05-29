<%@page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Gene Expression Data Set Search Results" help="geneexpression">
	<table>
		<caption>
			<div class="search-summary">
				<h4>Search Summary</h4>
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
			</div>
		</caption>
		<tbody>
			<!-- ////  Start Results  //// -->
			<c:choose>
			<c:when test="${not empty results}"> 
			
			<c:forEach var="series" items="${results}">
			<c:choose>
			<c:when test="${not empty series.series.id}">
			<tr class="series-head">
				<td><a name="${series.series.id}">Series ID</a></td>
				<td colspan="2">Title</td>
				<td colspan="2">Summary</td>
			</tr>
			<tr class="series-info">
				<td><a href="${series.siteURL}${series.series.id}"><c:out value="${series.series.id} " escapeXml="false"/></a>
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
			<tr class="series-head">
				<td colpsan="5">Matching samples not associated with any series</td>
			</tr>
			</c:otherwise>
			</c:choose>
			<tr class="sample-head">
				<td>Sample ID</td>
				<td>Title</td>
				<td>Summary</td>
				<td>Platform</td>
				<td>MTB Details</td>
			</tr>
			<c:forEach var="sample" items="${series.samples}" varStatus="status">
			<tr>
				<td>
					<c:choose>
					<c:when test="${empty sample.url}">
					<c:out value="${sample.id}" escapeXml="false"/>
					</c:when>
					<c:otherwise>
					<a href="${sample.url}"><c:out value="${sample.id}" escapeXml="false"/></a>
					</c:otherwise>
					</c:choose>
					<c:choose> 
					<c:when test="${sample.isControl}">
					Control sample
					</c:when>
					</c:choose>
				</td>
				<td><c:out value="${sample.title}" escapeXml="false"/></td>
				<td><c:out value="${sample.summary}" escapeXml="false"/></td>
				<td><c:out value="${sample.platform}" escapeXml="false"/></td>
				<td><a href="summaryByExample.do?tumorFrequencyKeys=${sample.dataBean['tfKey']}"><c:out value="${sample.dataBean['tfDetail']}" escapeXml="false"/></a></td>
			</tr>
			</c:forEach> <!-- sample -->
			</c:forEach> <!-- series -->
			</c:when>
			<c:otherwise>
			<tr>
				<td>No results found.</td>
			</tr>
			</c:otherwise>
			</c:choose>
		</tbody>
	</table>
</jax:mmhcpage>



