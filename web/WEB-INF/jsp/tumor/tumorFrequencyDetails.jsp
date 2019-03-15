<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<div class="detail-group">

<h3>Tumor Details</h3> 

<table>
	<caption>Tumor</caption>

	<c:if test="${tumorFreq.parentFrequencyKey > 0}">
	<tr>
		<th>Metastatic Tumor</th>
		<td><c:out value="${tumorFreq.organAffected}"/></td>
	</tr>
	</c:if>

	<tr>
		<th>Tumor Name</th>
		<td class="${tumorFreq.parentFrequencyKey <= 0 ? 'enhance' : ''}">
			<c:out value="${tumorFreq.organOfOrigin}" escapeXml="false"/>
			<c:out value="${tumorFreq.tumorClassification}" escapeXml="false"/>
		</td>
	</tr>

	<tr>
		<th>Treatment Type</th>
		<td><c:out value="${tumorFreq.treatmentType}" escapeXml="false"/></td>
	</tr>				

	<c:if test="${not empty tumorFreq.tumorSynonyms}">
	<tr>
		<th>Tumor Synonym<c:if test="${fn:length(tumor.agents) > 1}">s</c:if></th>
		<td>
			<c:forEach var="synonym" items="${tumorFreq.tumorSynonyms}" varStatus="status">
				${synonym}
				<c:if test="${status.last != true}">
					&#8226;
				</c:if>
			</c:forEach>
		</td>
	</tr>
	</c:if>



	<c:if test="${tumorFreq.parentFrequencyKey <= 0 && not empty tumorFreq.associatedFrequencyInfo}">
	<c:set var="pmets" value="-1"/>
	<tr>
		<th colspan="2">Metastases</th>
	</tr>

	<c:forEach var="mets" items="${tumorFreq.associatedFrequencyInfo}" varStatus="status">
		<%-- Don't incluse ourself in the list --%>
		<c:if test="${mets.label != tumorFreq.tumorFrequencyKey}">
			<tr>
				<td><a href="tumorFrequencyDetails.do?key=${mets.label}">MTB:${mets.label}</a></td>
				<td>
					${mets.value}
					<%--
					<c:choose>
					<c:when test="${mets.data=='0'}">
						<c:set var="pmets" value="${mets.label}"/>
					</c:when>
					<c:otherwise>
						<em>(metastasis from MTB:${pmets})</em>
					</c:otherwise>
					</c:choose>
					--%>
				</td>
			</tr>
		</c:if>
	</c:forEach>
	</c:if>
</table>

<table>
	<caption>Strain</caption>	
	<tr>
		<th>Strain Name</th>
		<td class="enhance" colspan="2"><a href="strainDetails.do?key=${tumorFreq.strainKey}"><c:out value="${tumorFreq.strainName}" escapeXml="false"/></a></td>
	</tr>
	<c:if test="${not empty tumorFreq.strainTypes}">
	<tr>
		<th>Strain Type<c:if test="${fn:length(tumorFreq.strainTypes) > 1}">s</c:if></th>
		<td>
			<c:forEach var="type" items="${tumorFreq.strainTypes}" varStatus="status">
				${type.type}
				<c:if test="${status.last != true}">
					&amp;
				</c:if>
			</c:forEach>
		</td>
	</tr>
	</c:if>
	<c:if test="${not empty tumorFreq.strainNote}">
	<tr>
		<th>General Note</th>
		<td>${tumorFreq.strainNote}</td>
	</tr>
	</c:if>		
	<c:if test="${not empty tumorFreq.strainSynonyms}">
	<tr>
		<th>Strain Synonym<c:if test="${fn:length(tumorFreq.strainSynonyms) > 1}">s</c:if></th>
		<td class="strain-synonyms">
			<c:forEach var="synonym" items="${tumorFreq.strainSynonyms}" varStatus="status">
				<c:out value="${synonym.name}" escapeXml="false"/>								
				<c:if test="${status.last != true}">
					&#8226;
				</c:if>
			</c:forEach>
		</td>
	</tr>
	</c:if>

</table>

<table>
	<tr>
		<th>MTB ID</th>
		<th>Organ Affected</th>
		<th>Treatment Type<em>Agents</em></th>
		<th>Strain Sex</th>
		<th>Reproductive Status</th>
		<th>Frequency</th>
		<th>Age Of Onset</th>
		<th>Age Of Detection</th>
		<th>Reference</th>
	</tr>
	<tr>
		<td>MTB:${tumorFreq.tumorFrequencyKey}</td>
		<td class="${tumorFreq.parentFrequencyKey > 0 ? 'enhance' : ''}">
			<c:out value="${tumorFreq.organAffected}" escapeXml="false"/>
		</td>
		<td>
			<c:out value="${tumorFreq.treatmentType}" escapeXml="false"/>
			<c:if test="${not empty tumorFreq.agents}">
				<c:forEach var="agent" items="${tumorFreq.agents}" varStatus="status">
					${agent}
					<c:if test="${status.last != true}">
						&nbsp;
					</c:if>
				</c:forEach>
			</c:if>
		</td>
		<td><c:out value="${tumorFreq.strainSex}" default="" escapeXml="false"/></td>
		<td><c:out value="${tumorFreq.reproductiveStatus}" default="" escapeXml="false"/></td>
		<td>
			${tumorFreq.frequencyString}
			<c:if test="${rec.numMiceAffected>=0&&rec.colonySize >= 0}">
				(${rec.numMiceAffected} of ${rec.colonySize} mice)
			</c:if>
		</td>
		<td><c:out value="${tumorFreq.ageOnset}" default="" escapeXml="false"/></td>
		<td><c:out value="${tumorFreq.ageDetection}" default="" escapeXml="false"/></td>
		<%--
		<td>
			<h6>
			<c:choose>
			<c:when test="${tumorFreq.numImages>0&&(not empty(tumorFreq.pathologyRecs))}">
				<a href="#pathology">Reportsand Images</a>
			</c:when>
			<c:when test="${tumorFreq.numImages>0&&(empty(tumorFreq.pathologyRecs))}">
				<a href="#pathology">Images</a>
			</c:when>
			<c:when test="${tumorFreq.numImages<=0&&(not empty(tumorFreq.pathologyRecs))}">
				<a href="#pathology">Reports</a>
			</c:when>
			<c:otherwise>
				
			</c:otherwise>
			</c:choose>
			</h6>
		</td>
		--%>
		<td>
			<c:if test="${not empty tumorFreq.reference}">
				<a href="referenceDetails.do?accId=${tumorFreq.reference}">${tumorFreq.reference}</a>
			</c:if>
		</td>
	</tr>
</table>	

<c:if test="${not empty tumorFreq.tumorGenetics}">
<table>
	<caption>Tumor Genetics</caption>
	<tr>
		<th>MarkerSymbol</th>
		<th>MarkerName</th>
		<th>MouseChromosome</th>
		<th>MutationTypes</th>
		<th>GeneticChange</th>
	</tr>
	<c:forEach var="genetics" items="${tumorFreq.tumorGenetics}" varStatus="status">
	<tr>
		<td>
			<c:if test="${not empty genetics.geneSymbol}">
				<c:choose>
					<c:when test="${fn:indexOf(genetics.geneSymbol, '+') < 0}">
						<a href="redirect?key=${genetics.markerKey}&type=1" target="MGI"><c:out value="${genetics.geneSymbol}" escapeXml="false"/></a>
					</c:when>
					<c:otherwise>
						<c:out value="${genetics.geneSymbol}" escapeXml="false"/>
					</c:otherwise>
				</c:choose>
			</c:if>
		</td>
		<td><c:out value="${genetics.geneName}" escapeXml="false"/></td>
		<td><c:out value="${genetics.chromosome}" escapeXml="false"/></td>
		<td><c:out value="${genetics.alleleType}" escapeXml="false"/></td>
		<td>
			<c:forEach var="row" items="${genetics.genotypes}" varStatus="status">
				${row.allele1Symbol} / ${row.allele2Symbol}
			</c:forEach>
		</td>
	</tr>
	</c:forEach>
</table>
</c:if>

<c:if test="${(not empty tumorFreq.additionalNotes) || (not empty tumorFreq.note)}">
<table>
	<caption>Additional Notes</caption>
	<tr>
		<th>Note</th>
		<th>Reference</th>
	</tr>
	<c:if test="${not empty tumorFreq.note}">
	<tr>
		<td><c:out value="${tumorFreq.note}"/></td>
		<td><a href="referenceDetails.do?accId=${tumorFreq.reference}">${tumorFreq.reference}</a></td>
	</tr>
	</c:if>
	
	<c:forEach var="rec" items="${tumorFreq.additionalNotes}" varStatus="status">
	<tr>
		<td><c:out value="${rec.label}" escapeXml="false"/></td>
		<td><a href="referenceDetails.do?key=${rec.data}">${rec.value}</a></td>
	</tr>
	</c:forEach>
</table>
</c:if>

<c:if test="${not empty tumorFreq.pathologyRecs}">
<a name="pathology"></a>
<table class="results">
	<caption>
			Pathology
			<p>${tumorFreq.numPathologyRecs} entr${tumorFreq.numPathologyRecs != 1 ? 'ies' : 'y'}</p>
			<p>${tumorFreq.numImages} image<c:if test="${tumorFreq.numImages != 1}">s</c:if></p>
	</caption>
	<tr>
		<th>Age at Necropsy</th>
		<th>Description</th>
		<th>Notes</th>
		<th>Images</th>
	</tr>

	<c:forEach var="rec" items="${tumorFreq.pathologyRecs}" varStatus="status">

		<c:set var="rowSpan" value="${fn:length(rec.images)}"/>
		<c:if test="${rowSpan<1}"><c:set var="rowSpan" value="1"/></c:if>
		
		<tr>
	
			<td rowspan="${rowSpan}"><c:out value="${rec.ageAtNecropsy}" escapeXml="false" default=""/></td>
			<td rowspan="${rowSpan}"><c:out value="${rec.description}" escapeXml="false" default=""/></td>
			<td rowspan="${rowSpan}"><c:out value="${rec.note}" escapeXml="false" default=""/></td>
			
		<c:choose>
		<c:when test="${not empty rec.images}">
			<c:forEach var="image" items="${rec.images}" varStatus="status2">
			
		<c:if test="${status2.first!=true}">
		<tr class="${rowClass}">
		</c:if>
			
			<td>								
				<table>
					<tr>
						<td>
							<a href="nojavascript.jsp" onClick="popPathWin('pathologyImageDetails.do?key=${image.imageId}', 'ImageID${image.imageId}');return false;">
							<img  src="${image.imageUrl}/${image.imageUrlPath}/${image.imageThumbName}"></a>
						</td>
						<td>
							<table>
								<tr>
									<td><b>Image ID</b>:</td>
									<td>${image.imageId}</td>
								</tr>
								<tr>
									<td><b>Source of Image</b>:</td>
									<td>
										<c:choose>
										<c:when test="${not empty image.institution}">
											${image.sourceOfImage}, ${image.institution}
										</c:when>
										<c:otherwise>
											${image.sourceOfImage}
										</c:otherwise>
										</c:choose>
									</td>
								</tr>
								<tr>
									<td><b>Method / Stain</b>:</td>
									<td>${image.stainMethod}</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<b>Image Caption</b>:
							${image.imageCaption}
						</td>
					</tr>
				</table>
			
			</td>
		</tr>
		</c:forEach>
		</c:when>
		<c:otherwise>
			<!--There are no pathology images associated with this pathology entry. //-->
			<td></td>
		</c:otherwise>
		</c:choose>
	</c:forEach>
</table>
</c:if>

</div>
