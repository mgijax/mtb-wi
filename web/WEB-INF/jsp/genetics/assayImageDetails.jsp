<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib uri="http://tumor.informatics.jax.org/mtbwi/MTBWebUtils" prefix="wu" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>

<jax:mmhcpage title="Assay Image Detail" help="assayImageDetail">

<table class="results">

<!-- ////  Start Detail Section  //// -->

<!-- ////  Start assayImage Image  //// -->

<tr class="stripe-1">
	<td colspan="2">
		<div>

<img src="${applicationScope.assayImageURL}/${applicationScope.assayImagePath}/${assayImage.imageName}">

</div>
	</td>
		</tr>

<!-- ////  End assayImage Image  //// -->

<!-- ////  Start assayImage  //// -->
	<c:set var="num" value="1"/>

<c:choose>
	<c:when test="${not empty assayImage.caption}">
	<c:set var="num" value="${num == 1 ? 2 : 1}"/>
		<tr class="stripe${num}">
			<td class="cat${num}">Caption</td>
				<td>${assayImage.caption}</td>
					</tr>
				</c:when>
				<c:otherwise>
					<!-- Image caption is null. //-->
				</c:otherwise>
		</c:choose>

<c:choose>
	<c:when test="${not empty assayImage.sourceOfImage}">
	<c:set var="num" value="${num == 1 ? 2 : 1}"/>
		<tr class="stripe${num}">
			<td class="cat${num}">Contributor</td>
				<td>
					${assayImage.sourceOfImage} &nbsp;
						 (<a href="nojavascript.jsp" onClick="focusBackToOpener('referenceDetails.do?key=${assayImage.imgRefKey}');return false;">${assayImage.imgRefAccId}</a>)
							<c:if test="${not empty image.institution}">

<!-- \n -->
${assayImage.institution}
	</c:if>
		</td>
			</tr>
				</c:when>
				<c:otherwise>
					<!-- Source of image is null. //-->
				</c:otherwise>
		</c:choose>

<c:choose>
	<c:when test="${not empty assayImage.copyright}">
	<c:set var="num" value="${num == 1 ? 2 : 1}"/>
		<tr class="stripe${num}">
			<td class="cat${num}">Copyright</td>
				<td>${assayImage.copyright}</td>
					</tr>
				</c:when>
				<c:otherwise>
					<!-- cytogenetic notes are null. //-->
				</c:otherwise>
		</c:choose>

</table>

<tr class="stripe-1">
	<td>
	 <table class="results" >
	<tr>
		<td class="results-header">Mouse Chromosomes</td>
			<td class="results-header">Name</td>
		<td class="results-header">Cytogenetic Type</td>
		<td class="results-header">Assay Type</td>
		<td class="results-header">Notes</td>
	</tr>
		<c:forEach var="dtoTGC" items="${dtoTGCs}">
	<c:set var="num" value="${num == 1 ? 2 : 1}"/>
		<tr class="stripe${num}">
		<c:choose>
			<c:when test="${not empty dtoTGC.displayChromosomes}">
				<td>${dtoTGC.displayChromosomes}</td>
				</c:when>
				<c:otherwise>
					<!-- Chromosomes are null //-->
		<td>
<!-- \n -->
</td>
	</c:otherwise>
		</c:choose>

<c:choose>
	<c:when test="${not empty dtoTGC.name}">
		<td>${dtoTGC.name}</td>
			</c:when>
				<c:otherwise>

<td>
<!-- \n -->
</td>
	</c:otherwise>
		</c:choose>

<c:choose>
	<c:when test="${not empty dtoTGC.alleleTypeName}">
		<td>${dtoTGC.alleleTypeName}</td>
			</c:when>
				<c:otherwise>
					<!-- Allele type is null. //-->
		<td>
<!-- \n -->
</td>
	</c:otherwise>
		</c:choose>

<c:choose>
	<c:when test="${not empty dtoTGC.assayType}">
		<td>${dtoTGC.assayType}</td>
			</c:when>
				<c:otherwise>
					<!-- assay type is null. //-->
		<td>
<!-- \n -->
</td>
	</c:otherwise>
		</c:choose>

<c:choose>
	<c:when test="${not empty dtoTGC.notes}">
		<td>${dtoTGC.notes}</td>
			</c:when>
				<c:otherwise>
					<td>
<!-- \n -->
</td>
	</c:otherwise>
		</c:choose>
	</tr>

</c:forEach>
 </table>
 </td>
</tr>

<!-- ////  End assayImage  //// -->

<!-- \n -->

<!-- ////  Start Tumor & Strain  //// -->

<table>
	<tr>

<!-- ////  Start Bottom Left  //// -->
	<c:set var="num" value="1"/>

<td width="49%" >

<table class="results">
	<c:choose>
		<c:when test="${not empty assayImage.tumorFrequencyKey}">
	<c:set var="num" value="${num == 1 ? 2 : 1}"/>
		<tr class="stripe${num}">
			<td class="cat${num}">MTB ID</td>
				<td class="enhance">
					 <a href="tumorSummary.do?tumorFrequencyKeys=${assayImage.tumorFrequencyKey}">MTB:${assayImage.tumorFrequencyKey}</a>
						</td>
							</tr>
								</c:when>
									<c:otherwise>
										<!-- Tumor Frequency ID is null. //-->
										</c:otherwise>
								</c:choose>

<c:choose>
	<c:when test="${not empty assayImage.tumorClassName}">
	<c:set var="num" value="${num == 1 ? 2 : 1}"/>
		<tr class="stripe${num}">
			<td class="cat${num}">Tumor Name</td>
				<td>
					<span class="enhance">
						${assayImage.organOrigin} 
<!-- \n -->

${assayImage.tumorClassName}
	</span>
		</td>
			</tr>
				</c:when>
					<c:otherwise>
						<!-- Tumor Name is null. //-->
							</c:otherwise>
								</c:choose>

<c:choose>
	<c:when test="${not empty assayImage.treatmentType}">
	<c:set var="num" value="${num == 1 ? 2 : 1}"/>
		<tr class="stripe${num}">
			<td class="cat${num}">Treatment Type</td>
				<td>${assayImage.treatmentType}</td>
					</tr>
						</c:when>
							<c:otherwise>
								<!-- Treatment type is null. //-->
									</c:otherwise>
								</c:choose>

<c:choose>
	<c:when test="${not empty assayImage.agents}">
	<c:set var="num" value="${num == 1 ? 2 : 1}"/>
		<tr class="stripe${num}">
			<td class="cat${num}">Agents</td>
				<td>
					<c:forEach var="agent" items="${assayImage.agents}" varStatus="status">
						<c:out value="${agent.name}" escapeXml="false"/>
							<c:if test="${status.last != true}">
								,
									</c:if>
										</c:forEach>
											</td>
												</tr>
										</c:when>
										<c:otherwise>
											<!-- Agents is null. //-->
										</c:otherwise>
								</c:choose>

<c:choose>
	<c:when test="${not empty assayImage.tumorSynonyms}">
	<c:set var="num" value="${num == 1 ? 2 : 1}"/>
		<tr class="stripe${num}">
			<td class="cat${num}">Tumor Synonyms</td>
				<td>
					<c:forEach var="tumorSynonym" items="${assayImage.tumorSynonyms}" varStatus="status">
						<c:out value="${tumorSynonym.name}" escapeXml="false"/>
							<c:if test="${status.last != true}">
								&nbsp;&#8226;&nbsp;
									</c:if>
										</c:forEach>
											</td>
												</tr>
										</c:when>
										<c:otherwise>
											<!-- Tumor synonyms is null. //-->
										</c:otherwise>
								</c:choose>

<c:choose>
	<c:when test="${not empty assayImage.organAffected}">
	<c:set var="num" value="${num == 1 ? 2 : 1}"/>
		<tr class="stripe${num}">
			<td class="cat${num}">Organ Affected</td>
				<td>${assayImage.organAffected}</td>
					</tr>
						</c:when>
							<c:otherwise>
								<!-- Organ affected is null. //-->
									</c:otherwise>
								</c:choose>

<c:choose>
	<c:when test="${not empty assayImage.frequency}">
	<c:set var="num" value="${num == 1 ? 2 : 1}"/>
		<tr class="stripe${num}">
			<td class="cat${num}">Frequency</td>
				<td>${assayImage.frequencyString}</td>
					</tr>
						</c:when>
							<c:otherwise>
								<!-- Frequency is null. //-->
									</c:otherwise>
								</c:choose>

<c:choose>
	<c:when test="${not empty assayImage.frequencyNote}">
	<c:set var="num" value="${num == 1 ? 2 : 1}"/>
		<tr class="stripe${num}">
			<td class="cat${num}">Frequency Note</td>
				<td>${assayImage.frequencyNote}</td>
					</tr>
						</c:when>
							<c:otherwise>
								<!-- Frequency note is null. //-->
									</c:otherwise>
								</c:choose>

<c:choose>
	<c:when test="${(not empty assayImage.referenceKey) && (not empty assayImage.accessionId)}">
	<c:set var="num" value="${num == 1 ? 2 : 1}"/>
		<tr class="stripe${num}">
			<td class="cat${num}">Reference</td>
				<td>
					<a href="nojavascript.jsp" onClick="focusBackToOpener('referenceDetails.do?key=${assayImage.referenceKey}');return false;">${assayImage.accessionId}</a>
						</td>
							</tr>
								</c:when>
									<c:otherwise>
										<!-- Reference is null. //-->
										</c:otherwise>
								</c:choose>

</table>
	</td>

<!-- ////  End Bottom Left  //// -->

<td width="20">
	</td>

<!-- ////  Start Bottom Right  //// -->
	<c:set var="num" value="1"/>

<td width="49%">

<table class="results">
	<c:choose>
		<c:when test="${not empty assayImage.strainName}">
	<c:set var="num" value="${num == 1 ? 2 : 1}"/>
		<tr class="stripe${num}">
			<td class="cat${num}">Strain</td>
				<td>
					<table>
						<tr>
							<td class="enhance" colspan="2"><a href="nojavascript.jsp" onclick="focusBackToOpener('strainDetails.do?key=${assayImage.strainKey}');return false;"><c:out value="${assayImage.strainName}" escapeXml="false"/></a></td>
								</tr>

<c:if test="${not empty assayImage.strainTypes}">
	<tr>
		<td class="label">Strain Types: </td>
			<td>
				<c:forEach var="type" items="${assayImage.strainTypes}" varStatus="status">
					${type.type}
						<c:if test="${status.last != true}">
							&amp;
								</c:if>
									</c:forEach>
										</td>
											</tr>
												</c:if>
													<c:if test="${not empty assayImage.strainNote}">
														<tr>
															<td class="label">General Note: </td>
																<td>${assayImage.strainNote}</td>
																	</tr>
																</c:if>
																</table>
														</td>
												</tr>
										</c:when>
										<c:otherwise>
											<!-- Strain name is null. //-->
										</c:otherwise>
								</c:choose>

<c:choose>
	<c:when test="${not empty assayImage.strainSynonyms}">
	<c:set var="num" value="${num == 1 ? 2 : 1}"/>
		<tr class="stripe${num}">
			<td class="cat${num}">Strain Synonyms</td>
				<td>
					<c:forEach var="synonym" items="${assayImage.strainSynonyms}" varStatus="status">
						<span class="syn-div-2"><c:out value="${synonym.name}" escapeXml="false"/></span>
							<c:if test="${status.last != true}">
								&nbsp;&#8226;&nbsp;
									</c:if>
										</c:forEach>
											</td>
												</tr>
										</c:when>
										<c:otherwise>
											<!-- Strain synonyms is null. //-->
										</c:otherwise>
								</c:choose>

<c:choose>
	<c:when test="${not empty assayImage.sex}">
	<c:set var="num" value="${num == 1 ? 2 : 1}"/>
		<tr class="stripe${num}">
			<td class="cat${num}">Strain Sex</td>
				<td>${assayImage.sex}</td>
					</tr>
						</c:when>
							<c:otherwise>
								<!-- Strain sex is null. //-->
									</c:otherwise>
								</c:choose>

<c:choose>
	<c:when test="${not empty assayImage.reproductiveStatus}">
	<c:set var="num" value="${num == 1 ? 2 : 1}"/>
		<tr class="stripe${num}">
			<td class="cat${num}">Reproductive Status</td>
				<td>${assayImage.reproductiveStatus}</td>
					</tr>
						</c:when>
							<c:otherwise>
								<!-- Reproductive status is null. //-->
									</c:otherwise>
								</c:choose>

<c:choose>
	<c:when test="${not empty assayImage.ageOfOnset}">
	<c:set var="num" value="${num == 1 ? 2 : 1}"/>
		<tr class="stripe${num}">
			<td class="cat${num}">Age of Onset</td>
				<td>${assayImage.ageOfOnset}</td>
					</tr>
						</c:when>
							<c:otherwise>
								<!-- Age of onset is null. //-->
									</c:otherwise>
								</c:choose>

<c:choose>
	<c:when test="${not empty assayImage.ageOfDetection}">
	<c:set var="num" value="${num == 1 ? 2 : 1}"/>
		<tr class="stripe${num}">
			<td class="cat${num}">Age of Detection</td>
				<td>${assayImage.ageOfDetection}</td>
					</tr>
						</c:when>
							<c:otherwise>
								<!-- Age of detection status is null. //-->
									</c:otherwise>
								</c:choose>
						</table>

<!-- ////  End Bottom Right  //// -->

<!-- ////  End Tumor & Strain  //// -->

<!-- ////  End Detail Section  //// -->

</jax:mmhcpage>

