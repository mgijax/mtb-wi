<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Assay Image Detail">
	<table>
		<!-- ////  Start Detail Section  //// -->
		<!-- ////  Start assayImage Image  //// -->
		<tr>
			<td colspan="2">
				<div>
					<img src="${applicationScope.assayImageURL}/${applicationScope.assayImagePath}/${assayImage.imageName}">
				</div>
			</td>
		</tr>
		<!-- ////  End assayImage Image  //// -->
		<!-- ////  Start assayImage  //// -->
		
		<c:choose>
		<c:when test="${not empty assayImage.caption}">
		
		<tr>
			<td><h4>Caption</h4></td>
			<td>${assayImage.caption}</td>
		</tr>
		</c:when>
		<c:otherwise>
		<!-- Image caption is null. //-->
		</c:otherwise>
		</c:choose>
		<c:choose>
		<c:when test="${not empty assayImage.sourceOfImage}">
		
		<tr>
			<td><h4>Contributor</h4></td>
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
		
		<tr>
			<td><h4>Copyright</h4></td>
			<td>${assayImage.copyright}</td>
		</tr>
		</c:when>
		<c:otherwise>
		<!-- cytogenetic notes are null. //-->
		</c:otherwise>
		</c:choose>
	</table>
	<tr>
		<td>
			<table >
				<tr>
					<th>Mouse Chromosomes</th>
					<th>Name</th>
					<th>Cytogenetic Type</th>
					<th>Assay Type</th>
					<th>Notes</th>
				</tr>
				<c:forEach var="dtoTGC" items="${dtoTGCs}">
				
				<tr>
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
			
			<td width="49%" >
				<table>
					<c:choose>
					<c:when test="${not empty assayImage.tumorFrequencyKey}">
					
					<tr>
						<td><h4>MTB ID</h4></td>
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
					
					<tr>
						<td><h4>Tumor Name</h4></td>
						<td>
							<h5>
								${assayImage.organOrigin} 
								<!-- \n -->
								${assayImage.tumorClassName}
							</h5>
						</td>
					</tr>
					</c:when>
					<c:otherwise>
					<!-- Tumor Name is null. //-->
					</c:otherwise>
					</c:choose>
					<c:choose>
					<c:when test="${not empty assayImage.treatmentType}">
					
					<tr>
						<td><h4>Treatment Type</h4></td>
						<td>${assayImage.treatmentType}</td>
					</tr>
					</c:when>
					<c:otherwise>
					<!-- Treatment type is null. //-->
					</c:otherwise>
					</c:choose>
					<c:choose>
					<c:when test="${not empty assayImage.agents}">
					
					<tr>
						<td><h4>Agents</h4></td>
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
					
					<tr>
						<td><h4>Tumor Synonyms</h4></td>
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
					
					<tr>
						<td><h4>Organ Affected</h4></td>
						<td>${assayImage.organAffected}</td>
					</tr>
					</c:when>
					<c:otherwise>
					<!-- Organ affected is null. //-->
					</c:otherwise>
					</c:choose>
					<c:choose>
					<c:when test="${not empty assayImage.frequency}">
					
					<tr>
						<td><h4>Frequency</h4></td>
						<td>${assayImage.frequencyString}</td>
					</tr>
					</c:when>
					<c:otherwise>
					<!-- Frequency is null. //-->
					</c:otherwise>
					</c:choose>
					<c:choose>
					<c:when test="${not empty assayImage.frequencyNote}">
					
					<tr>
						<td><h4>Frequency Note</h4></td>
						<td>${assayImage.frequencyNote}</td>
					</tr>
					</c:when>
					<c:otherwise>
					<!-- Frequency note is null. //-->
					</c:otherwise>
					</c:choose>
					<c:choose>
					<c:when test="${(not empty assayImage.referenceKey) && (not empty assayImage.accessionId)}">
					
					<tr>
						<td><h4>Reference</h4></td>
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
			
			<td width="49%">
				<table>
					<c:choose>
					<c:when test="${not empty assayImage.strainName}">
					
					<tr>
						<td><h4>Strain</h4></td>
						<td>
							<table>
								<tr>
									<td class="enhance" colspan="2"><a href="nojavascript.jsp" onclick="focusBackToOpener('strainDetails.do?key=${assayImage.strainKey}');return false;"><c:out value="${assayImage.strainName}" escapeXml="false"/></a></td>
								</tr>
								<c:if test="${not empty assayImage.strainTypes}">
								<tr>
									<td><h4>Strain Types: </h4></td>
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
									<td><h4>General Note: </h4></td>
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
					
					<tr>
						<td><h4>Strain Synonyms</h4></td>
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
					
					<tr>
						<td><h4>Strain Sex</h4></td>
						<td>${assayImage.sex}</td>
					</tr>
					</c:when>
					<c:otherwise>
					<!-- Strain sex is null. //-->
					</c:otherwise>
					</c:choose>
					<c:choose>
					<c:when test="${not empty assayImage.reproductiveStatus}">
					
					<tr>
						<td><h4>Reproductive Status</h4></td>
						<td>${assayImage.reproductiveStatus}</td>
					</tr>
					</c:when>
					<c:otherwise>
					<!-- Reproductive status is null. //-->
					</c:otherwise>
					</c:choose>
					<c:choose>
					<c:when test="${not empty assayImage.ageOfOnset}">
					
					<tr>
						<td><h4>Age of Onset</h4></td>
						<td>${assayImage.ageOfOnset}</td>
					</tr>
					</c:when>
					<c:otherwise>
					<!-- Age of onset is null. //-->
					</c:otherwise>
					</c:choose>
					<c:choose>
					<c:when test="${not empty assayImage.ageOfDetection}">
					
					<tr>
						<td><h4>Age of Detection</h4></td>
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
			
