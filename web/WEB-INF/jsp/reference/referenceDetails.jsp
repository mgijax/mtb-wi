<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Reference Summary" subtitle="${reference.title}" help="referencedetail">
	<jsp:attribute name="head">
		<link rel="stylesheet" type="text/css" href="./live/www/css/results.css"/>
		<script type="text/javascript" src="/_res/js/datatables.min.js"></script>
	</jsp:attribute>
	<jsp:body>
	
		<section id="summary">
			<div class="container">
				<table>
					<tbody>
		
						<tr>
							<td><h4>Title</h4></td>
							<td >${reference.title}${reference.title2}</td>
						</tr>
						<tr>
							<td><h4>Authors</h4></td>
							<td >${reference.authors}${reference.authors2}</td>
						</tr>
						<tr>
							<td><h4>Journal</h4></td>
							<td >${reference.journal}</td>
						</tr>
						<tr>
							<td><h4>Volume</h4></td>
							<td >${reference.volume}</td>
						</tr>
						<tr>
							<td><h4>Issue</h4></td>
							<td >${reference.issue}</td>
						</tr>

						<tr>
							<td><h4>Year</h4></td>
							<td >${reference.year}</td>
						</tr>
						<tr>
							<td><h4>Pages</h4></td>
							<td >${reference.pages}</td>
						</tr>

						<tr>
							<td><h4>Abstract</h4></td>
							<td >${reference.abstractText}</td>
						</tr>
						
						<c:if test="${not empty reference.otherAccessionIds}">
						
						<tr>
							<td><h4>Links</h4></td>
							<td>
								<c:forEach var="info" items="${reference.otherAccessionIds}" varStatus="status">
                                	${info.data}&nbsp; <a target="_blank" href="${info.value}">${info.label}</a><br>
								</c:forEach>
							</td>

						</tr>
						
						</c:if>



					</tbody>
		
				</table>
			</div>
			
		</section>
		
	<section id="detail">
	
		<!-- ////  Start Strain Tumors  //// -->
		<c:choose>
		<c:when test="${not empty reference.tumors}">
	
				<table id="detail-table" style="width:100%;">
					<caption>
						<h2>Tumors</h2>
						<!--<c:set var="statsBean" value="${strain.tumorStats}"/>
						${statsBean.label} unique tumor types displayed.
						<em>A tumor group is a set of tumors that share the same tumor name, organ(s) affected, and treatment type.</em>-->
					</caption>
					<thead>
						<tr>
							<th>Strain</th>
							<th>Model Name</th>
							<th>Treatment Agent(s)</th>
							<th>Organ Affected</th>
							<th class="freq">Frequency</th>
							<th>Model Details</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="tumor" items="${reference.tumors}" varStatus="status">
						<tr>
							<td><c:out value="${tumor.strainName}" escapeXml="false"/></td>
							<td><c:out value="${tumor.tumorName}" escapeXml="false"/></td>
							<td>
								<c:if test="${fn:length(tumor.agents) > 0}">
								<ul>
									<c:forEach var="agent" items="${tumor.agents}">
									   <li>${agent}</li>
									</c:forEach>
								</ul>
								</c:if>								
								
							</td>
							<td><c:out value="${tumor.organAffectedName}" escapeXml="false"/></td>
							
							
							<td class="freq" data-order="${1000 + tumor.max}" data-freq="${tumor.max}">
								<p class="fr"><c:out value="${tumor.freqAllString}" escapeXml="false"/></p>
							</td>							
							
							<td><a href="tumorSummary.do?strainKey=${tumor.strainKey}&amp;organOfOriginKey=${tumor.organOfOriginKey}&amp;tumorFrequencyKeys=${tumor.allTFKeysAsParams}"><i class="mo"></i></a></td>
						</tr>
							
							<!--
							<td><c:out value="${tumor.treatmentType}" escapeXml="false"/></td>
							<td>
								<a href="tumorSummary.do?strainKey=${tumor.strainKey}&amp;organOfOriginKey=${tumor.organOfOriginKey}&amp;tumorFrequencyKeys=${tumor.allTFKeysAsParams}">${tumor.numberTFRecords}</a>
							</td>
							<td><c:out value="${tumor.freqAllString}" escapeXml="false"/></td>
							-->
						</tr>
						</c:forEach>
					</tbody>
				</table>		
		
		</section>	
		
			</c:when>
		<c:otherwise>
		<!-- There is no tumor information associated with this strain. -->
		</c:otherwise>
		</c:choose>	
		
		
		
		
		
			<script type="text/javascript">
		$(function() {
			$('#detail-table').DataTable({
		        'paging': false,
		        'searching': false,
				'info': false,
				'columns': [
					{ "orderable": true },
					{ "orderable": true },
					{ "orderable": true },
					{ "orderable": true },
					{ "orderable": true },
					{ "orderable": true },
				]
			});
			$('[data-order]').each(function() {
				var $td = $(this),
					f = parseInt($td.data('freq'), 10),
					$fr = $td.find('.fr'),
					fc;
					
				if (f >= 80) {
					fc = 'fr-80';
				} else if (f >= 50) {
					fc = 'fr-50';
				} else if (f >= 20) {
					fc = 'fr-20';
				} else if (f >= 10) {
					fc = 'fr-10';
				} else if (f >= 1) {
					fc = 'fr-01';
				} else {
					fc = 'fr-0';
				}
			
				$fr.addClass(fc);					

			});
					
		});
	</script>
		
	<!--	
	
		<section id="detail">	
	
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

					</c:otherwise>
					</c:choose>
					</c:forEach>
				</tbody>
			</table>
			</c:if>
			</c:when>
			<c:otherwise>

			</c:otherwise>
			</c:choose>

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

			</c:otherwise>
			</c:choose>
		</section>
	-->	
		
	</jsp:body>
</jax:mmhcpage>


