<%@page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Gene Expression Data Set Search Results">
	<jsp:attribute name="head">
		<link rel="stylesheet" type="text/css" href="./live/www/css/results.css"/>
		<script type="text/javascript" src="./live/www/js/results.js"></script>
	</jsp:attribute>
	<jsp:body>
	<table>
		<caption>
			<div class="result-summary">
				<h4>Search Summary</h4>
				<jax:dl dt="Organ" dds="${organs}"/>
				<jax:dl dt="Tumor Classification" dds="${tumorClassifications}"/>
				<jax:dl dt="Strain" dd="${strainName}"/>
				<jax:dl dt="Platform" dds="${platforms}"/>		
				<dl>
					<c:choose>
					<c:when test="${not empty samplesWOSeries || not empty seriesWSamples}">
					<c:choose>
					<c:when test="${not empty seriesWSamples}">
					<c:choose>
					<c:when test="${seriesWSamples == '1'}">
					<dt>${seriesWSamples} series has matching samples</dt>
					</c:when>
					<c:otherwise>
					<dt>${seriesWSamples} series have matching samples</dt>
					<c:forEach var="series" items="${results}" >
					<c:choose>
					<c:when test="${not empty series.series.id}">
					<dd><a href="#${series.series.id}">${series.series.id}</a></dd>
					</c:when>
					</c:choose>
					</c:forEach>
					</c:otherwise>
					</c:choose>
					</c:when>
					</c:choose>
					<c:choose>
					<c:when test="${not empty samplesWOSeries}">
					<c:choose>
					<c:when test="${samplesWOSeries == '1'}">
					<dt>${samplesWOSeries} matching sample not associated with a series</dt>
					</c:when>
					<c:otherwise>
					<dt>${samplesWOSeries} matching samples not associated with any series</dt>
					</c:otherwise>
					</c:choose>
					</c:when>
					</c:choose>
					</c:when>
					<c:otherwise>
					<dt>All samples for ${seriesId}</dt>
					</c:otherwise>
					</c:choose>
				</dl>
			</div>
		</caption>
		<tbody>
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
				<td><a href="tumorSummary.do?tumorFrequencyKeys=${sample.dataBean['tfKey']}"><c:out value="${sample.dataBean['tfDetail']}" escapeXml="false"/></a></td>
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
	</jsp:body>
</jax:mmhcpage>
