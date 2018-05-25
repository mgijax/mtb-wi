<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib uri="http://tumor.informatics.jax.org/mtbwi/MTBWebUtils" prefix="wu" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>

<jax:mmhcpage title="Pathology Image Search Results" help="pathresults">

<table class="results">

<!-- ////  Start Search Summary  //// -->

<tr class="summary">
	<td>
		<span class="label">Search Summary</span>
<!-- \n -->

<c:if test="${not empty organOriginSelected}">
	<c:choose>
		<c:when test="${fn:length(organOriginSelected)>1}">
			<span class="label">Organs/Tissues of Origin:</span> 
				</c:when>
					<c:otherwise>
						<span class="label">Organ/Tissue of Origin:</span> 
							</c:otherwise>
								</c:choose>

<c:forEach var="organ" items="${organOriginSelected}" varStatus="status">
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

<c:if test="${not empty tumorClassificationsSelected}">
	<c:choose>
		<c:when test="${fn:length(tumorClassificationsSelected)>1}">
			<span class="label">Tumor Classifications:</span> 
				</c:when>
					<c:otherwise>
						<span class="label">Tumor Classification:</span> 
							</c:otherwise>
								</c:choose>

<c:forEach var="classification" items="${tumorClassificationsSelected}" varStatus="status">
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

<c:if test="${not empty organsAffectedSelected}">
	<span class="label">Organ/Tissue Affected:</span> ${organsAffectedSelected}
<!-- \n -->

</c:if>

<c:if test="${not empty diagnosisDescription}">
	<span class="label">Diagnosis or Description:</span> Contains "${diagnosisDescription}"
<!-- \n -->

</c:if>

<c:if test="${not empty methodSelected}">
	<span class="label">Method:</span> ${methodSelected}
<!-- \n -->

</c:if>

<c:if test="${not empty antibodiesSelected}">
	<c:choose>
		<c:when test="${fn:length(antibodiesSelected)>1}">
			<span class="label">Antibodies:</span> 
				</c:when>
					<c:otherwise>
						<span class="label">Antibody:</span> 
							</c:otherwise>
								</c:choose>

<c:forEach var="antibody" items="${antibodiesSelected}" varStatus="status">
	<c:choose>
		<c:when test="${status.last != true}">
			${antibody},
				</c:when>
					<c:otherwise>
						${antibody}
							</c:otherwise>
								</c:choose>
								</c:forEach>

<!-- \n -->

</c:if>

<c:if test="${not empty imageContributors}">
	<c:choose>
		<c:when test="${fn:length(imageContributors)>1}">
			<span class="label">Contributors:</span> 
				</c:when>
					<c:otherwise>
						<span class="label">Contributor:</span> 
							</c:otherwise>
								</c:choose>

<c:forEach var="contributor" items="${imageContributors}" varStatus="status">
	<c:choose>
		<c:when test="${status.last != true}">
			${contributor},
				</c:when>
					<c:otherwise>
						${contributor}
							</c:otherwise>
								</c:choose>
								</c:forEach>

<!-- \n -->

</c:if>

<c:if test="${not empty accId}">
	<span class="label">Accession Id:</span> ${accId}
<!-- \n -->

</c:if>

<span class="label">Sort By:</span> ${sortBy}
<!-- \n -->

<span class="label">Display Limit:</span> ${maxItems}
	</td>
		</tr>
		<tr class="summary">
			<td>

<!-- ////  Start Display Limit  //// -->

<c:choose>
	<c:when test="${numberOfResults != totalResults}">
		<c:out value="${numberOfResults}" default="0"/> (of <c:out value="${totalResults}" default="0"/>) pathology reports displayed, including <c:out value="${totalNumOfPathImages}" default="0"/>	images.
								</c:when>
								<c:otherwise>
									<c:out value="${numberOfResults}" default="0"/> (of <c:out value="${totalResults}" default="0"/>) pathology reports displayed, including <c:out value="${totalNumOfPathImages}" default="0"/>	images.
								</c:otherwise>
						</c:choose>

<!-- ////  End Display Limit  //// -->

</td>
	</tr>
</table>

<!-- ////  End Search Summary  //// -->

<!-- ////  Start Results  //// -->

<c:choose>
	<c:when test="${not empty pathologyImages}">
		<c:forEach var="pathRec" items="${pathologyImages}" varStatus="status">

<!-- \n -->

<!-- \n -->

<table class="results">
	<tr>
		<td width="8%" class="results-header">MTB ID</td>
			<td width="14%" class="results-header">Tumor Name</td>
				<td width="13%" class="results-header">Organ(s) Affected</td>
					<td width="13%" class="results-header">Treatment Type
<!-- \n -->
<span class="small"><em>Agents</em></span></td>
	<td width="14%" class="results-header">Strain Name
<!-- \n -->
<span class="small">Strain Sex
<!-- \n -->
Reproductive Status</span></td>
	<td width="9%" class="results-header">Tumor
<!-- \n -->
Frequency</td>
	<td width="9%" class="results-header">Age at
<!-- \n -->
Necropsy</td>
	<td width="13%" class="results-header">Description</td>
		<td width="7%" class="results-header">Reference</td>
			</tr>
				<tr class="stripe-1">

<td><a href="tumorSummary.do?tumorFrequencyKeys=${pathRec.tumorFrequencyKey}">MTB:${pathRec.tumorFrequencyKey}</a></td>
	<td>${pathRec.organOriginName} &nbsp; ${pathRec.tumorClassName}</td>
		<td>${pathRec.organAffectedName}</td>
			<td>
				<c:out value="${pathRec.treatmentType}" escapeXml="false"/>
					<c:if test="${not empty pathRec.agents}">

<!-- \n -->

<span size="-2"><em>
	<c:forEach var="agent" items="${pathRec.agents}" varStatus="status">
		<c:out value="${agent}" escapeXml="false"/>
			<c:if test="${status.last != true}">

<!-- \n -->

</c:if>
	</c:forEach>
		</em></span> 
			</c:if>
				</td>
					<td>
						<span class="enhance"><a href="strainDetails.do?key=${pathRec.strainKey}"><c:out value="${pathRec.strainName}" escapeXml="false"/></a></span>

<!-- \n -->
${pathRec.strainSex}
	<c:if test="${not empty pathRec.reproductiveStatus}">

<!-- \n -->
${pathRec.reproductiveStatus}
	</c:if>
		</td>
			<td>${pathRec.frequencyString}</td>
				<td>${pathRec.ageAtNecropsy}</td>
					<td>${pathRec.note}</td>
						<td><a href="referenceDetails.do?accId=${pathRec.accID}">${pathRec.accID}</a></td>
							</tr>
								<c:forEach var="image" items="${pathRec.images}" varStatus="status">
									<c:choose>
										<c:when test="${status.index%2==1}">
											<tr class="stripe-1">
												</c:when>
												<c:otherwise>
													<tr class="stripe-2">
												</c:otherwise>
										</c:choose>
											<td colspan=9>
												<table>
													<tr>
														<td>
															<a href="nojavascript.jsp" onClick="popPathWin('pathologyImageDetails.do?key=${image.imageId}', 'ImageId${image.imageId}');return false;">
																<img width=150 src="${applicationScope.pathologyImageUrl}/${applicationScope.pathologyImagePath}/${image.imageThumbName}" alt="${image.imageId}"></a>
																	</td>
																		<td width=250>
																			<table>
																				<tr>
																					<td class="small" align="right"><div class="nowrap"><span class="label">Image ID:</span></div></td>
																						<td class="small">${image.imageId}</td>
																						</tr>
																						<tr>
																							<td class="small" align="right"><div class="nowrap"><span class="label">Source of Image:</span></div></td>
																								<td class="small">
																									${image.sourceOfImage}

</td>
	</tr>

<tr>
	<td class="small" align="right"><div class="nowrap"><span class="label">Pathologist:</span></div></td>
		<td class="small">
			${image.pathologist}

</td>
	</tr>
		<c:choose>
			 <c:when test="${not empty image.stainMethod}">
				<tr>
					<td class="small" align="right"><div class="nowrap"><span class="label">Method / Stain:</span></div></td>
						<td class="small">${image.stainMethod}</td>
							</tr>
								</c:when>
									</c:choose>
										</table>
											</td>
												<td class="small" colspan=5>
													<span class="label">Image Caption</span>:
<!-- \n -->

${image.imageCaption}
	</td>
		</tr>
			</table>
				</td>
					</tr>
						</c:forEach>
						</table>
				</c:forEach>
		</c:when>
		<c:otherwise>
			<!-- No results found. //-->
		</c:otherwise>
</c:choose>

<!-- ////  End Results  //// -->

</jax:mmhcpage>

