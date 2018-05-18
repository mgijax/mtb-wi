	 <%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib uri="http://tumor.informatics.jax.org/mtbwi/MTBWebUtils" prefix="wu" %>
<!doctype html>
<html>
<head>
<c:import url="../../../meta.jsp">
		<c:param name="pageTitle" value="Tumor Summary"/>
</c:import>
</head>

<body>
	<c:import url="../../../body.jsp" />
<div class="wrap">
<nav><c:import url="../../../toolBar.jsp"/></nav>
<section class="main">

<header>
	<h1>Tumor Summary</h1>
	<a class="help" href="userHelp.jsp#tumorsummary"></a>
</header>

<table>
		<tr>

<!-- ////  Start Top Left (Tumor)  //// -->

<td width="49%">
						<table class="results">
								<tr class="stripe-1">
										<td class="cat-1">Tumor Name</td>
										<td>
												<span class="enhance">
												<c:out value="${tumor.organOfOrigin}" escapeXml="false"/>
												
<!-- \n -->

												<c:out value="${tumor.tumorClassification}" escapeXml="false"/>
												</span>
										</td>
								</tr>
								<tr class="stripe-2">
										<td class="cat-2">Treatment Type</td>
										<td>
												<c:out value="${tumor.treatmentType}" escapeXml="false"/>
										</td>
								</tr>

								<c:set var="lbl" value="1"/>

								<c:choose>
								<c:when test="${not empty tumor.tumorSynonyms}">
										<c:set var="lbl" value="${lbl+1}"/>
										<tr class="stripe${(lbl%2)+1}">
												<c:choose>
												<c:when test="${fn:length(tumor.tumorSynonyms)>1}">
														<td class="cat${(lbl%2)+1}">Tumor Synonyms</td>
												</c:when>
												<c:otherwise>
														<td class="cat${(lbl%2)+1}">Tumor Synonym</td>
												</c:otherwise>
												</c:choose>

												<td>
														<c:forEach var="synonym" items="${tumor.tumorSynonyms}" varStatus="status">
																${synonym.key}
																<c:if test="${status.last != true}">
																		&nbsp;&#8226;&nbsp;
																</c:if>
														</c:forEach>
												</td>
										</tr>
								</c:when>
								<c:otherwise>
										<!--There are no synonyms associated with this tumor. //-->
								</c:otherwise>
								</c:choose>

						</table>
				</td>

<!-- ////  End Top Left (Tumor)  //// -->

<td width=20></td>

<!-- ////  Start Top Right (Strain)  //// -->

<td width="49%">
						<table class="results">
								<tr class="stripe-1">
										<td class="cat-1">Strain</td>
										<td>
												<table>
														<tr>
																<td class="enhance" colspan="2"><a href="strainDetails.do?key=${tumor.strainKey}"><c:out value="${tumor.strainName}" escapeXml="false"/></a></td>
														</tr>

												<c:if test="${not empty tumor.strainTypes}">
														<tr>
																<c:choose>
																<c:when test="${fn:length(tumor.strainTypes)>1}">
																		<td class="label"><div class="nowrap">Strain Types: </div></td>
																</c:when>
																<c:otherwise>
																		<td class="label"><div class="nowrap">Strain Type: </div></td>
																</c:otherwise>
																</c:choose>
																<td>
																		<c:forEach var="type" items="${tumor.strainTypes}" varStatus="status">
																				${type.type}
																				<c:if test="${status.last != true}">
																						&amp;
																				</c:if>
																		</c:forEach>
																</td>
														</tr>
												</c:if>
												<c:if test="${not empty tumor.strainNote}">
														<tr>
																<td class="label"><div class="nowrap">General Note: </div></td>
																<td>${tumor.strainNote}</td>
														</tr>
												</c:if>
												</table>
										</td>
								</tr>
								<c:choose>
								<c:when test="${not empty tumor.strainSynonyms}">
										<tr class="stripe-2">
												<c:choose>
												<c:when test="${fn:length(tumor.strainSynonyms)>1}">
														<td class="cat-2">Strain Synonyms</td>
												</c:when>
												<c:otherwise>
														<td class="cat-2">Strain Synonym</td>
												</c:otherwise>
												</c:choose>
												<td>
														<c:forEach var="synonym" items="${tumor.strainSynonyms}" varStatus="status">
																<span class="syn-div-2"><c:out value="${synonym.name}" escapeXml="false"/></span>
																<c:if test="${status.last != true}">
																		&nbsp;&#8226;&nbsp;
																</c:if>
														</c:forEach>
												</td>
										</tr>
								</c:when>
								<c:otherwise>
										<!--There are no synonyms associated with this strain. //-->
								</c:otherwise>
								</c:choose>

						</table>
				</td>

<!-- ////  End Top Right (Strain)  //// -->

</tr>
</table>

<!-- ////  End Tumor & Strain  //// -->

<!-- \n -->

<!-- ////  Start Frequency Records  //// -->

<c:choose>
		<c:when test="${not empty tumor.frequencyRecs}">
				<table class="results">
						<tr>
								<td class="results-header">MTB ID</td>
								<td class="results-header">Organ Affected</td>
								<td class="results-header">Treatment Type
<!-- \n -->
<span size="-2"><em>Agents</em></span></td>
								<td class="results-header">Strain Sex</td>
								<td class="results-header">Reproductive Status</td>
								<td class="results-header">Infection Status</td>
								<td class="results-header">Frequency</td>
								<td class="results-header">Age Of
<!-- \n -->
Onset</td>
								<td class="results-header">Age Of
<!-- \n -->
Detection</td>
								<td class="results-header">Additional
<!-- \n -->
Information</td>
								<td class="results-header">Reference</td>
						</tr>

						<c:set var="lbl" value="1"/>
						<c:set var="previousParent" value="-100"/>
						<c:set var="rowClass" value="stripe1"/>

						<c:forEach var="rec" items="${tumor.frequencyRecs}" varStatus="status">
						
							<c:if test="${(status.index == 1) && not empty byExample}">
							<tr>
								<td class="results-header" colspan="11">Additional tumor frequency records with the same strain, classification and treatment type </td>
								
							</tr>
						</c:if>
						
						
								<c:set var="currentParent" value="${rec.sortOrder}"/>

								<c:choose>
										<c:when test="${currentParent!=previousParent}">
												<c:set var="lbl" value="${lbl+1}"/>
												<c:set var="previousParent" value="${rec.sortOrder}"/>
												<c:set var="rowClass" value="stripe${(lbl%2)+1}"/>
										</c:when>
										<c:otherwise>
										</c:otherwise>
								</c:choose>

								<tr class="${rowClass}">

								<c:choose>
										<c:when test="${rec.tumorFrequencyKey!=rec.parentFrequencyKey}">
												<td class="hilite">
										</c:when>
										<c:otherwise>
												<td>
										</c:otherwise>
								</c:choose>
												MTB:${rec.tumorFrequencyKey}
												<c:if test="${rec.tumorFrequencyKey!=rec.parentFrequencyKey}">
														
<!-- \n -->

														<div class="nowrap"><span size="-2"><em>(metastasis
<!-- \n -->
from MTB:${rec.parentFrequencyKey})</em></span></div>
												</c:if>
										</td>
										<td><c:out value="${rec.organAffected}" escapeXml="false" default="&nbsp;"/></td>
										<td>
												<c:out value="${tumor.treatmentType}" escapeXml="false"/>

												<c:if test="${not empty rec.sortedAgents}">
														<span size="-2">
														<em>
														<c:forEach var="agent" items="${rec.sortedAgents}" varStatus="status">
																
<!-- \n -->

																<c:out value="${agent}" escapeXml="false"/>
																<c:choose>
																	<c:when test="${status.last != true}">
																		<c:out value=", "/>
																		
																	</c:when>
																</c:choose>
														</c:forEach>
														</em>
														</span>
												</c:if>
										</td>
										<td><c:out value="${rec.strainSex}" escapeXml="false" default="&nbsp;"/></td>
										<td><c:out value="${rec.reproductiveStatus}" escapeXml="false" default="&nbsp;"/></td>
										<td><c:out value="${rec.infectionStatus}" escapeXml="false" default="&nbsp;"/></td>
										<td>
												<c:out value="${rec.frequencyString}" escapeXml="false" default="&nbsp;"/>
												<c:if test="${rec.numMiceAffected>=0&&rec.colonySize>=0}">
														
<!-- \n -->

														(${rec.numMiceAffected} of ${rec.colonySize} mice)
												</c:if>
										</td>
										<td><c:out value="${rec.ageOnset}" escapeXml="false" default="&nbsp;"/></td>
										<td><c:out value="${rec.ageDetection}" escapeXml="false" default="&nbsp;"/></td>
										<!-- Additional Information -->
										<td>
												<c:set var="additionalInfoText" value=""/>
												<span size="-2">
												<%-- Check to see if we have pathology information about the tumor --%>
												<c:choose>
												<c:when test="${rec.numImages>0&&rec.numPathEntries>0}">
														<c:set var="additionalInfoText" value="<a href=\"nojavascript.jsp\" onClick=\"popPathWin('tumorFrequencyDetails.do?key=${rec.tumorFrequencyKey}&amp;page=pathology', '${rec.tumorFrequencyKey}');return false;\">Pathology Reports</a> <img src=\"${applicationScope.urlImageDir}/pic.gif\" alt=\"X\" border=\"0\">"/>
												</c:when>
												<c:when test="${rec.numImages>0&&rec.numPathEntries<=0}">
														<c:set var="additionalInfoText" value="<a href=\"nojavascript.jsp\" onClick=\"popPathWin('tumorFrequencyDetails.do?key=${rec.tumorFrequencyKey}&amp;page=pathology', '${rec.tumorFrequencyKey}');return false;\">Pathology Reports</a> <img src=\"${applicationScope.urlImageDir}/pic.gif\" alt=\"X\" border=\"0\">"/>
												</c:when>
												<c:when test="${rec.numImages<=0&&rec.numPathEntries>0}">
														<c:set var="additionalInfoText" value="<a href=\"nojavascript.jsp\" onClick=\"popPathWin('tumorFrequencyDetails.do?key=${rec.tumorFrequencyKey}&amp;page=pathology', '${rec.tumorFrequencyKey}');return false;\">Pathology Reports</a> "/>
												</c:when>
											 
												</c:choose>

												<%-- Check to see if we have genetic information about the tumor --%>
												<c:choose>
												<c:when test="${rec.numGenetics>0}">
												
														 <c:choose>
																<c:when test="${not empty additionalInfoText}">
																	<c:set var="additionalInfoText" value="${additionalInfoText}"/>
																</c:when>
														 </c:choose>
														<c:choose>
																<c:when test="${rec.numAssayImages > 0}">
																		<c:set var="additionalInfoText" value="${additionalInfoText}<a href=\"nojavascript.jsp\" onClick=\"popPathWin('tumorFrequencyDetails.do?key=${rec.tumorFrequencyKey}&amp;page=genetics', '${rec.tumorFrequencyKey}');return false;\">Genetics</a><img src=\"${applicationScope.urlImageDir}/pic.gif\" alt=\"X\" border=\"0\">"/>
																</c:when>
																<c:otherwise>
																		<c:set var="additionalInfoText" value="${additionalInfoText}<a href=\"nojavascript.jsp\" onClick=\"popPathWin('tumorFrequencyDetails.do?key=${rec.tumorFrequencyKey}&amp;page=genetics', '${rec.tumorFrequencyKey}');return false;\">Genetics</a>"/>
																</c:otherwise>
														</c:choose>
												</c:when>
												<c:otherwise>
														<!-- No genetics information //-->
												</c:otherwise>
												</c:choose>

												<%-- Check to see if we have additional notes about the tumor --%>
												<c:set var="notesLinkName" value=""/>
												<c:choose>
												<c:when test="${rec.numNotes>0}">
														<c:choose>
																<c:when test="${not empty additionalInfoText}">
																		<c:set var="additionalInfoText" value="${additionalInfoText}"/>
																</c:when>
														</c:choose>
														<c:choose>
															<c:when test="${true}">
																	<c:set var="additionalInfoText" value="${additionalInfoText}<a href=\"nojavascript.jsp\" onClick=\"popPathWin('tumorFrequencyDetails.do?key=${rec.tumorFrequencyKey}&amp;page=notes', '${rec.tumorFrequencyKey}');return false;\">Additional Notes</a>" />
															</c:when>
														</c:choose>
															
												</c:when>
												<c:otherwise>
														<!-- No additional Notes //-->
												</c:otherwise>
												</c:choose>
												
												<c:choose>
												<c:when test="${not empty rec.note}">
														<c:choose>
																<c:when test="${not empty additionalInfoText}">
																		<c:set var="additionalInfoText" value="${additionalInfoText}"/>
																</c:when>
														</c:choose>
														<c:choose>
															<c:when test="${true}">
																	<c:set var="additionalInfoText" value="${additionalInfoText}<a href=\"nojavascript.jsp\" onClick=\"popPathWin('tumorFrequencyDetails.do?key=${rec.tumorFrequencyKey}&amp;page=tnotes', '${rec.tumorFrequencyKey}');return false;\">Treatment Note</a>" />
															</c:when>
														</c:choose>
															
												</c:when>
											</c:choose>
											
											<c:choose>
												<c:when test="${rec.numSamples > 0}">
														<c:choose>
																<c:when test="${not empty additionalInfoText}">
																		<c:set var="additionalInfoText" value="${additionalInfoText}"/>
																</c:when>
														</c:choose>
														<c:choose>
															<c:when test="${true}">
																	<c:set var="additionalInfoText" value="${additionalInfoText}<a href=\"nojavascript.jsp\" onClick=\"popPathWin('geneExpressionSearchResults.do?tfKey=${rec.tumorFrequencyKey}&amp;page=arrays', '${rec.tumorFrequencyKey}');return false;\">Expression Data</a>" />
															</c:when>
														</c:choose>
															
												</c:when>
											</c:choose>

												<c:choose>
														<c:when test="${not empty additionalInfoText}">
																${additionalInfoText}
														</c:when>
														<c:otherwise>
																
														</c:otherwise>
												</c:choose>
												</span>
										</td>
										<td>
												<c:choose>
												<c:when test="${not empty rec.reference}">
														<a href="referenceDetails.do?accId=${rec.reference}">${rec.reference}</a>
												</c:when>
												<c:otherwise>
														
												</c:otherwise>
												</c:choose>
										</td>
								</tr>
						</c:forEach>
				</table>
		</c:when>
		<c:otherwise>
				<!-- There are no tumor frequency records associated with this tumor. -->
		</c:otherwise>
		</c:choose>

<!-- ////  End Frequency Records  //// -->

<!-- ////  End Detail Section  //// -->


</section>
</div>
</body>
</html>


