<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>

<table>
	<caption>
		Gene Expression Data

			<!--
				<jax:dl dt="Organ" dds="${organs}"/>
				<jax:dl dt="Tumor Classification" dds="${tumorClassifications}"/>
				<jax:dl dt="Strain" dd="${strainName}"/>
				<jax:dl dt="Platform" dds="${platforms}"/>		
			-->
		<span>
			<c:choose>
				<c:when test="${not empty samplesWOSeries || not empty seriesWSamples}">
					<c:choose>
						<c:when test="${not empty seriesWSamples}">
							<c:choose>
								<c:when test="${seriesWSamples == '1'}">
									&mdash; ${seriesWSamples} series has matching samples
								</c:when>
								<c:otherwise>
									&mdash; ${seriesWSamples} series have matching samples
									<!--
									<c:forEach var="series" items="${results}" >
										<c:choose>
											<c:when test="${not empty series.series.id}">
												<dd><a href="#${series.series.id}">${series.series.id}</a></dd>
											</c:when>
										</c:choose>
									</c:forEach>
									-->
								</c:otherwise>
							</c:choose>
						</c:when>
					</c:choose>
					<c:choose>
						<c:when test="${not empty samplesWOSeries}">
							<c:choose>
								<c:when test="${samplesWOSeries == '1'}">
									, ${samplesWOSeries} sample not associated with a series
								</c:when>
								<c:otherwise>
									, ${samplesWOSeries} samples not associated with any series
								</c:otherwise>
							</c:choose>
						</c:when>
					</c:choose>
				</c:when>
				<c:otherwise>
					&mdash; All samples for ${seriesId}
				</c:otherwise>
			</c:choose>
		</span>

	</caption>
	
	<c:choose>
		<c:when test="${not empty results}"> 			
			<c:forEach var="series" items="${results}">
				<tbody>
					<c:choose>
						<c:when test="${not empty series.series.id}">
							<tr class="series-head series-summary">
								<td><a href="${series.siteURL}${series.series.id}"><c:out value="${series.series.id} " escapeXml="false"/> Series</a></td>
								<td><c:out value="${series.series.title}" escapeXml="false"/></td>
								<td>
									<c:out value="${series.series.summary}" escapeXml="false"/>
									<c:if test="${fn:length(series.series.summary)>=499}">
										<a href="${series.siteURL}${series.series.id}">...</a>
									</c:if>
								</td>								
							</tr>
							<tr class="series-head series-showing">
								<td colspan="3">
									${series.sampleCount} sample(s) from <a href="geneExpressionSearchResults.do?seriesId=${series.series.id}"><c:out value="${series.totalSamples} total" escapeXml="false"/></a> in the <c:out value="${series.series.id} " escapeXml="false"/> series
								</td>
							</tr>
						</c:when>
						<c:otherwise>
							<tr class="series-head series-showing">
								<td colpsan="3">Samples not associated with any series</td>
							</tr>
						</c:otherwise>
					</c:choose>
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
						</tr>
					</c:forEach>
				</tbody>
			</c:forEach> 
		</c:when>
		<c:otherwise>

		</c:otherwise>
	</c:choose>

</table>

