<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Strain Summary" subtitle="${strain.name}" help="straindetail">
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
						<td><h4>Strain Name</h4></td>
						<td>${strain.name}</td>
					</tr>
					
					<tr>
						<td><h4>Strain Type(s)</h4></td>
						<td>
							<c:forEach var="st" items="${strain.types}" varStatus="status">
							<c:out value="${st.type}" escapeXml="false"/>
							<c:if test="${status.last != true}">
							&nbsp;&#8226;&nbsp;
							</c:if>
							</c:forEach>
						</td>			
					</tr>
					

							
					<c:choose>
					<c:when test="${not empty strain.synonyms}">
					<tr>
						<td><h4>Strain Synonym(s)</h4></td>
						<td>
							<c:forEach var="synonym" items="${strain.synonyms}" varStatus="status">
							<c:out value="${synonym.name}" escapeXml="false"/>
							<c:if test="${status.last != true}">
							&nbsp;&#8226;&nbsp;
							</c:if>
							</c:forEach>
						</td>
					</tr>
					</c:when>
					<c:otherwise>
					<!-- There are no synonyms associated with this strain. -->
					</c:otherwise>
					</c:choose>
					<!-- ////  End Strain Synonyms  //// -->
					<c:if test="${not empty strain.description}">
					<tr>
						<td><h4>Description</h4></td>
						<td>${strain.description}</td>
					</tr>
					</c:if>
					
					
					
<!--
					<c:if test="${not empty strain.types}">
					<tr>
						<td><h4>Notes</h4></td>
						<td>
							<c:forEach var="st" items="${strain.types}" varStatus="status">
							<c:if test="${not empty st.description}">
								<c:out value="${st.description}" escapeXml="false"/>
								<c:if test="${status.last != true}">
								&nbsp;&#8226;&nbsp;
								</c:if>
							</c:if>
							</c:forEach>
						</td>

					</tr>				
					</c:if>
-->
					
					
					<c:if test="${not empty strain.genetics}">
					<tr>
						<td><h4>Strain Genetics</h4></td>
						

										
								
								
								
								<c:forEach var="genetics" items="${strain.genetics}" varStatus="status">
								
								<c:if test="${status.first != true}">
								<tr>
									<td style="border-top-color:transparent;"></td>
								</c:if>
								
								<!--
									
									http://bhmtbdb01:8080/mtbwi2/facetedSearch.do#fq=strainMarker%3A%22Brca1%3Csup%3Etm1Cxd%3C%2Fsup%3E%22
									-->
								
								<td>
										<div style="float:right;">
										<a href="facetedSearch.do#fq=strainMarker%3A%22${genetics.allele1Symbol}%22">List all models in MMHCdb carrying the ${genetics.allele1Symbol} allele</a>
										<c:if test="${not empty genetics.allele2Url}">
											<br><a href="facetedSearch.do#fq=strainMarker%3A%22${genetics.allele2Symbol}%22">List all models in MMHCdb carrying the ${genetics.allele2Symbol} allele</a>
										</c:if>
										</div>
										
										<a href="${genetics.allele1Url}" target="_blank">${genetics.allele1Symbol}</a>
										
										<c:if test="${not empty genetics.allele2Url}">
										 / <a href="${genetics.allele2Url}" target="_blank">${genetics.allele2Symbol}</a>
										</c:if>
								</td>
								</tr>
								
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
		<c:when test="${not empty strain.tumors}">
	
				<table id="detail-table" style="width:100%;">
					<caption>
						<h2>Models</h2>
						<c:set var="statsBean" value="${strain.tumorStats}"/>
						${statsBean.label} unique model types displayed.
						<em>A model group is a set of tumors that share the same tumor name, organ(s) affected, and treatment type for a specific strain.</em>
					</caption>
					<thead>
						<tr>
							<th colspan="2"></th>
							<th colspan="4">Frequency</th>
							<th colspan="2"></th>
						</tr>
						<tr>
							<th>Model Name</th>
							<th>Organ Affected</th>
							<th class="freq">Female</th>
							<th class="freq">Male</th>
							<th class="freq">Mixed&nbsp;Pop.</th>
							<th class="freq">Unspecified</th>
							<th>Additional Information</th>
							<th>Model Details</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="tumor" items="${strain.tumors}" varStatus="status">
						<tr>
							<td><c:out value="${tumor.tumorName}" escapeXml="false"/></td>
							<td><c:out value="${tumor.organAffectedName}" escapeXml="false"/></td>
											
							<td class="freq" data-order="${1000 + tumor.maxFreqFemale}" data-freq="${tumor.maxFreqFemale}">
								<p class="fr"><c:out value="${tumor.freqFemaleString}" escapeXml="false"/></p>
							</td>
							<td class="freq" data-order="${1000 + tumor.maxFreqMale}" data-freq="${tumor.maxFreqMale}">
								<p class="fr"><c:out value="${tumor.freqMaleString}" escapeXml="false"/></p>
							</td>						
							<td class="freq" data-order="${1000 + tumor.maxFreqMixed}" data-freq="${tumor.maxFreqMixed}">
								<p class="fr"><c:out value="${tumor.freqMixedString}" escapeXml="false"/></p>
							</td>						
							<td class="freq" data-order="${1000 + tumor.maxFreqUnknown}" data-freq="${tumor.maxFreqUnknown}">
								<p class="fr"><c:out value="${tumor.freqUnknownString}" escapeXml="false"/></p>
							</td>						
	
							
							<td>
								<c:if test="${not empty tumor.citations}">
								<p>References: 
									<c:forEach var="cite" items="${tumor.citations}" varStatus="status">
										<c:if test="${status.first != true}">
											&nbsp;&nbsp;&sdot;&nbsp;&nbsp;
										</c:if>
									   <a href="referenceDetails.do?accId=${cite.accID}">${cite.shortCitation}</a>
									</c:forEach>
								</p>
								</c:if>
								<c:if test="${not empty tumor.metastasizesToDisplay}">
								<p>Sites of Metastasis: 
									<c:forEach var="met" items="${tumor.metastasizesToDisplay}" varStatus="status">
										<c:if test="${status.first != true}">
											, 
										</c:if>
										${met}
									</c:forEach>
								</p>								
								</c:if>
								<c:if test="${tumor.imageCount > 0}">
								<p>${tumor.imageCount} pathology image(s)</p>
								</c:if>

							
							
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
	
		</c:when>
		<c:otherwise>
		<!-- There is no tumor information associated with this strain. -->
		</c:otherwise>
		</c:choose>

	</section>

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
					{ "orderable": true },
					{ "orderable": true }
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
	</jsp:body>
</jax:mmhcpage>

