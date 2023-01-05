<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Strain Summary" subtitle="${strain.name}">
	<jsp:attribute name="head">
		<link rel="stylesheet" type="text/css" href="./live/www/css/results.css"/>
		<script type="text/javascript" src="https://cdn.datatables.net/1.13.1/js/jquery.dataTables.min.js"></script>	
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
               
                                        <%-- Moved to reference details
                                        <c:if test="${not empty strain.notes}">
					<tr>
						<td><h4>Strain Notes</h4></td>
                                                <td>
						<c:forEach var="note" items="${strain.notes}" varStatus="status">
							
                                                            <c:out value="${note.note}" escapeXml="false"/>&nbsp;
                                                             <a href="referenceDetails.do?accId=${note.dataBean['ACCID']}">${note.dataBean['CITE']}}</a>
                                                            <c:if test="${status.last != true}">
                                                                &nbsp;&#8226;&nbsp;<br>
                                                            </c:if>
                                                    
						</c:forEach>
                                                </td>
					</tr>
					</c:if>
                                        --%>
                                         <c:if test="${not empty strain.links}">
					<tr>
						<td><h4>Strain Links</h4></td>
                                                <td>
						<c:forEach var="link" items="${strain.links}" varStatus="status">
							
                                                            &#8226;&nbsp;<a href="${link.accessionUrl}" target="_new">${link.siteName}</a>
                                                            <c:if test="${status.last != true}">
                                                                <br>
                                                            </c:if>
                                                    
						</c:forEach>
                                                </td>
					</tr>
					</c:if>
					
					
					
<!--
					<c:if test="${not empty strain.types}">
					<tr>
						<td><h4>Types/<h4></td>
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
						<c:set var="firstGenetics" value="true" />

						<c:forEach var="genetics" items="${strain.consolidatedGenetics}">

							<c:set var="a1" value="${empty genetics.allele1Symbol ? 'none' : genetics.allele1Symbol}" />
							<c:set var="a2" value="${empty genetics.allele2Symbol ? 'none' : genetics.allele2Symbol}" />

							
								<tr>
									
									<c:choose>
									<c:when test="${firstGenetics != true}">
										<td style="border-top-color:transparent;"></td>
									</c:when>
									<c:otherwise>
										<td><h4>Strain Genetics</h4></td>
									</c:otherwise>
									</c:choose>

									<td>
											<div style="float:right;">
                                                                                        <c:if test="${not fn:endsWith(genetics.allele1Symbol,'+</sup>') && not fn:endsWith(genetics.allele1Symbol,'?</sup>')}">
                                                                                            <a href="facetedSearch.do#fq=strainMarker%3A%22${genetics.allele1Symbol}%22">List all models in MMHCdb carrying the ${genetics.allele1Symbol} allele</a>
                                                                                        </c:if>
											<c:if test="${not empty genetics.allele2Symbol && not fn:endsWith(genetics.allele2Symbol,'+</sup>')  && not fn:endsWith(genetics.allele2Symbol,'?</sup>') &&  (a1 != a2) }">
												<br><a href="facetedSearch.do#fq=strainMarker%3A%22${genetics.allele2Symbol}%22">List all models in MMHCdb carrying the ${genetics.allele2Symbol} allele</a>
											</c:if>
											</div>
                                                                                        
                                                                                         <c:choose>
                                                                                                <c:when test="${not fn:endsWith(genetics.allele1Symbol,'+</sup>') && not fn:endsWith(genetics.allele1Symbol,'?</sup>')}">
                                                                                                    <a href="${genetics.allele1Url}" target="_blank">${genetics.allele1Symbol}</a>
                                                                                                </c:when>
                                                                                                <c:otherwise>
                                                                                                    ${genetics.allele1Symbol}
                                                                                                </c:otherwise>
                                                                                         </c:choose>
											
											
											
											<c:if test="${not empty genetics.allele2Symbol}">
                                                                                         /
                                                                                            <c:choose>
                                                                                                <c:when test="${not fn:endsWith(genetics.allele2Symbol,'+</sup>') && not fn:endsWith(genetics.allele2Symbol,'?</sup>')}">
                                                                                                    <a href="${genetics.allele2Url}" target="_blank">${genetics.allele2Symbol}</a>
                                                                                                </c:when>
                                                                                                <c:otherwise>
                                                                                                    ${genetics.allele2Symbol}
                                                                                                </c:otherwise>
                                                                                         </c:choose>
											</c:if>
									</td>
								</tr>
								
								<c:set var="firstGenetics" value="false" />
								
							
						
						</c:forEach>

					</c:if>
					
					
					
				</tbody>
			</table>
		</div>
	</section>
	
	
	<section id="detail">
	
		<!-- ////  Start Strain Tumors  //// -->
		<c:choose>
		<c:when test="${not empty strain.tumors}">
	
				<table class="detail-table" id="detail-table-strain" style="width:100%;">
					<caption>
						<h2>Models</h2>
						<c:set var="statsBean" value="${strain.tumorStats}"/>
						${statsBean.label} unique models displayed.
						<em>A model is a set of tumors that share the same tumor name, organ(s) affected, and treatment type for a specific strain.</em>
					</caption>
					<thead>
						<tr>
							<th colspan="3"></th>
							<th colspan="4">Frequency</th>
							<th colspan="2"></th>
						</tr>
						<tr>
							<th>Model Name</th>
							<th>Organ Affected</th>
							<th>Tumor Inducing Agent(s)</th>
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
							<td>
								
								<!-- <c:out value="${tumor.treatmentType}" escapeXml="false"/> -->
								<c:if test="${not empty tumor.agents}">

								<c:forEach var="agent" items="${tumor.agents}" varStatus="status">
									<c:if test="${status.first != true}">
										 &nbsp;&nbsp;&sdot;&nbsp;&nbsp; 
									</c:if>
									<c:out value="${agent}" escapeXml="false"/>
								</c:forEach>

								</c:if>
							</td>							
							
							
											
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
								<c:if test="${tumor.cytoImages > 0}">
								<p>${tumor.cytoImages} cytogenetic image(s)</p>
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
			$('#detail-table-strain').DataTable({
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

