<%@page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib uri="http://tumor.informatics.jax.org/mtbwi/MTBWebUtils" prefix="wu" %>
<!doctype html>
	<html>
		<head>
			<c:import url="../../../meta.jsp">
				<c:param name="pageTitle" value="Gene Expression Data Set Search Results"/>
			</c:import>
		</head>
		
<body>
			<c:import url="../../../body.jsp" />

		
		<div class="wrap">
<nav><c:import url="../../../toolBar.jsp" /></nav>
<section class="main">

<header>
	<h1>Gene Expression Data Set Search Results</h1>
	<a class="help" href="userHelp.jsp#geneexpression"></a>
</header>
<table class="results">

<!-- ////  Start Search Summary  //// -->

<tr class="summary">
								<td colspan="5">
									<span class="label">Search Summary</span>
<!-- \n -->

									
									
									
									<c:if test="${not empty organs}">
										<c:choose>
											<c:when test="${fn:length(organs)>1}">
												<span class="label">Organs:</span>
											</c:when>
											<c:otherwise>	
												<span class="label">Organ:</span>
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
												<span class="label">Tumor Classifications:</span>
											</c:when>
											<c:otherwise>	
												<span class="label">Tumor Classification:</span>
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
										<span class="label">Strain:</span> ${strainName}
<!-- \n -->

									</c:if>
									
									
									
									<c:if test="${not empty platforms}">
										<c:choose>
											<c:when test="${fn:length(platforms)>1}">
												<span class="label">Platforms:</span>
											</c:when>
											<c:otherwise>	
												<span class="label">Platform:</span>
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
														<span class="label">${seriesWSamples} series has matching samples </span>
<!-- \n -->

													</c:when>
													<c:otherwise>
														<span class="label">${seriesWSamples} series have matching samples </span>
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
														<span class="label">${samplesWOSeries} matching sample not associated with a series </span>
<!-- \n -->

													</c:when>
													<c:otherwise>
														<span class="label">${samplesWOSeries} matching samples not associated with any series </span>
<!-- \n -->

													</c:otherwise>
												
											</c:choose>
												
												</c:when>
												
											</c:choose>
											
										</c:when>
										<c:otherwise>
											<span class="label">All samples for ${seriesId} </span>
<!-- \n -->

										</c:otherwise>
										
									</c:choose>
									
									
									
								</td>
							</tr>
							<tr class="summary">
								<td colspan="5">
								</td>
							</tr>

<!-- ////  End Search Summary  //// -->

<!-- ////  Start Results  //// -->

<c:choose>
							<c:when test="${not empty results}"> 
							<c:set var="lbl" value="1"/>
							
							
							<c:forEach var="series" items="${results}" >
							
							<c:choose>
								<c:when test="${not empty series.series.id}">
								 
								<tr class="results">
									<td class="results-header" colspan="1"><a name="${series.series.id}">Series ID</a></td>
									<td class="results-header" colspan="2">Title</td>
									<td class="results-header" colspan="2">Summary</td>

								</tr>
						 

								<tr class="stripe-1">
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
								 <tr class="results">
									<td class="results-header" colspan="5">Matching samples not associated with any series</td>
									

								</tr>
							</c:otherwise>
							</c:choose>
							
							<tr class="results">
								
								<td class="results-header" colspan="1">Sample ID</td>
								<td class="results-header" colspan="1">Title</td>
								<td class="results-header" colspan="1">Summary</td>
								<td class="results-header" colspan="1">Platform</td>
								<td class="results-header" colspan="1">MTB Details</td>
								
							</tr>
							
							
							<c:forEach var="sample" items="${series.samples}" varStatus="status">
							
							<c:choose>
								<c:when test="${status.index%2==0}">
									<tr class="stripe-2">
								</c:when>
								<c:otherwise>
									<tr class="stripe-1">
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

</section>
	</div>
</body>

	</html>
	

