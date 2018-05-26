<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib uri="http://tumor.informatics.jax.org/mtbwi/MTBWebUtils" prefix="wu" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Pathology Image Detail" help="pathdetail">
	<jsp:attribute name="head">
	<script type="text/javascript">
		<!--
		var flashinstalled = 0;
		var flashversion = 0;
		MSDetect = "false";
		if (navigator.plugins && navigator.plugins.length) {
			x = navigator.plugins["Shockwave Flash"];
			if (x) {
				flashinstalled = 2;
				if (x.description) {
					y = x.description;
					flashversion = y.charAt(y.indexOf('.')-1);
				}
			} else {
				flashinstalled = 1;
			}
			if (navigator.plugins["Shockwave Flash 2.0"]) {
				flashinstalled = 2;
				flashversion = 2;
			}
		} else if (navigator.mimeTypes && navigator.mimeTypes.length) {
			x = navigator.mimeTypes['application/x-shockwave-flash'];
			if (x && x.enabledPlugin)
			flashinstalled = 2;
			else
			flashinstalled = 1;
		} else {
			MSDetect = "true";
		}
		// -->
	</script>
	<script language="VBScript">
		on error resume next
		If MSDetect = "true" Then
		For i = 2 to 6
		If Not(IsObject(CreateObject("ShockwaveFlash.ShockwaveFlash." & i))) Then
		Else
		flashinstalled = 2
		flashversion = i
		End If
		Next
		End If
		If flashinstalled = 0 Then
		flashinstalled = 1
		End If
	</script>
	</jsp:attribute>
	<jsp:body>
	<table class="results">
		<!-- ////  Start Detail Section  //// -->
		<!-- ////  Start Pathology Image  //// -->
		<tr>
			<td colspan="2">
				<div>
					<c:choose>
					<c:when test="${not empty pathology.zoomifyDir}">
					<!-- ZOOMIFY CHECK -->
					<script language="javascript" type="text/javascript">
						<!--
						if (flashinstalled == 2) {
							document.write("<DIV ALIGN=\"center\">");
							document.write("<OBJECT CLASSID=\"clsid:D27CDB6E-AE6D-11cf-96B8-444553540000\" CODEBASE=\"http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,40,0\" WIDTH=\"900\" HEIGHT=\"550\" ID=\"theMovie\">");
							document.write("		<PARAM NAME=\"FlashVars\" VALUE=\"zoomifyImagePath=${applicationScope.pathologyImageUrl}/${applicationScope.pathologyImagePath}/${pathology.zoomifyDir}\">");
							document.write("		<PARAM NAME=\"src\" VALUE=\"${applicationScope.urlZoomify}\">");
							document.write("		<EMBED FlashVars=\"zoomifyImagePath=${applicationScope.pathologyImageUrl}/${applicationScope.pathologyImagePath}/${pathology.zoomifyDir}\" SRC=\"${applicationScope.urlZoomify}\" PLUGINSPAGE=\"http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash\"	WIDTH=\"900\" HEIGHT=\"550\" NAME=\"theMovie\">");
							document.write("		</EMBED>");
							document.write("</OBJECT>");
							document.write("</DIV>");
						} else {
							document.write("<img src=\"${applicationScope.pathologyImageUrl}/${applicationScope.pathologyImagePath}/${pathology.imageName}\">");
						}
						// -->
					</script>
					</c:when>
					<c:otherwise>
					<!-- IMAGE HAS NOT BEEN ZOOMIFIED -->
					<img src="${applicationScope.pathologyImageUrl}/${applicationScope.pathologyImagePath}/${pathology.imageName}">
					</c:otherwise>
					</c:choose>
				</div>
			</td>
		</tr>
		<!-- ////  End Pathology Image  //// -->
		<!-- ////  Start Pathology  //// -->
		<c:set var="num" value="1"/>
		<c:choose>
		<c:when test="${not empty pathology.caption}">
		<c:set var="num" value="${num == 1 ? 2 : 1}"/>
		<tr>
			<td><h4>Caption</h4></td>
			<td>${pathology.caption}</td>
		</tr>
		</c:when>
		<c:otherwise>
		<!-- Image caption is null. //-->
		</c:otherwise>
		</c:choose>
		<c:choose>
		<c:when test="${not empty pathology.pathologyDescription}">
		<c:set var="num" value="${num == 1 ? 2 : 1}"/>
		<tr>
			<td><h4>Description</h4></td>
			<td>${pathology.pathologyDescription}</td>
		</tr>
		</c:when>
		<c:otherwise>
		<!-- Pathology description is null. //-->
		</c:otherwise>
		</c:choose>
		<c:choose>
		<c:when test="${not empty pathology.ageAtNecropsy}">
		<c:set var="num" value="${num == 1 ? 2 : 1}"/>
		<tr>
			<td><h4>Age at Necropsy</h4></td>
			<td>${pathology.ageAtNecropsy}</td>
		</tr>
		</c:when>
		<c:otherwise>
		<!-- Age at necropsy is null. //-->
		</c:otherwise>
		</c:choose>
		<c:choose>
		<c:when test="${not empty pathology.pathologyNote}">
		<c:set var="num" value="${num == 1 ? 2 : 1}"/>
		<tr>
			<td><h4>Notes</h4></td>
			<td>${pathology.pathologyNote}</td>
		</tr>
		</c:when>
		<c:otherwise>
		<!-- Pathology note is null. //-->
		</c:otherwise>
		</c:choose>
		<c:choose>
		<c:when test="${not empty pathology.sourceOfImage}">
		<c:set var="num" value="${num == 1 ? 2 : 1}"/>
		<tr>
			<td><h4>Contributor</h4></td>
			<td>
				${pathology.sourceOfImage}&nbsp;
				(<a href="nojavascript.jsp" onClick="focusBackToOpener('referenceDetails.do?key=${pathology.imgRefKey}');return false;">${pathology.imgRefAccId}</a>)
			</td>
		</tr>
		</c:when>
		<c:otherwise>
		<!-- Source of image is null. //-->
		</c:otherwise>
		</c:choose>
		<c:choose>
		<c:when test="${not empty pathology.pathologist}">
		<c:set var="num" value="${num == 1 ? 2 : 1}"/>
		<tr>
			<td><h4>Pathologist</h4></td>
			<td>
				${pathology.pathologist}&nbsp;
				(<a href="nojavascript.jsp" onClick="focusBackToOpener('referenceDetails.do?key=${pathology.pathologistRefKey}');return false;">${pathology.pathologistAccId}</a>)
			</td>
		</tr>
		</c:when>
		<c:otherwise>
		<!-- Source of image is null. //-->
		</c:otherwise>
		</c:choose>
		<c:choose>
		<c:when test="${not empty pathology.copyright}">
		<c:set var="num" value="${num == 1 ? 2 : 1}"/>
		<tr>
			<td><h4>Copyright</h4></td>
			<td>
				${pathology.copyright}
			</td>
		</tr>
		</c:when>
		<c:otherwise>
		<!--copyright is null. //-->
		</c:otherwise>
		</c:choose>
		<c:choose>
		<c:when test="${not empty pathology.method}">
		<c:set var="num" value="${num == 1 ? 2 : 1}"/>
		<tr>
			<td><h4>Method</h4></td>
			<td>${pathology.method}</td>
		</tr>
		</c:when>
		<c:otherwise>
		<!-- method is null. //-->
		</c:otherwise>
		</c:choose>
		<!-- ////  End Pathology  //// -->
	</table>
	<c:choose>
	<c:when test="${not empty pathology.probes}">
	<!-- \n -->
	<table class="results">
		<tr>
			<td colspan="4" class="cat-title">Image Probes</td>
		</tr>
		<c:forEach var="probe" items="${pathology.probes}" varStatus="status">
		<tr>
			<td><h4>Type</h4></td><td>${probe.type}</td>
			<c:choose>
			<c:when test="${not empty probe.url}">
			<td class="cat-2" >Name</td><td><a href="${probe.url}">${probe.name}</a></td>
			</c:when>
			<c:otherwise>
			<td><h4>Name</h4></td><td>${probe.name}</td>
			</c:otherwise>
			</c:choose>
			<tr>
				<td><h4>Target</h4></td><td>${probe.target}</td> 
				<c:choose>
				<c:when test="${not empty probe.supplierUrl}">
				<td><h4>Supplier</h4></td><td><a href="${probe.supplierUrl}">${probe.supplierName}</a></td>
				</c:when>
				<c:otherwise>
				<td><h4>Supplier</h4></td><td>${probe.supplierName}</td>
				</c:otherwise>
				</c:choose>
				<tr class="stripe-2"">	
				<td><h4>Notes</h4></td><td colspan="3">${probe.notes}</td>
			</tr>
			<c:if test="${status.last != true}">
			<tr class="tablebreak"><td colspan="4"></tr>
				</c:if>
				</c:forEach>
			</table>
			</c:when>
			</c:choose>
			<!-- \n -->
			<!-- ////  Start Tumor & Strain  //// -->
			<table>
				<tr>
					<!-- ////  Start Bottom Left  //// -->
					<c:set var="num" value="1"/>
					<td width="49%" >
						<table class="results">
							<c:choose>
							<c:when test="${not empty pathology.tumorFrequencyKey}">
							<c:set var="num" value="${num == 1 ? 2 : 1}"/>
							<tr>
								<td><h4>MTB ID</h4></td>
								<td class="enhance">
									<a href="tumorSummary.do?tumorFrequencyKeys=${pathology.tumorFrequencyKey}">MTB:${pathology.tumorFrequencyKey}</a>
								</td>
							</tr>
							</c:when>
							<c:otherwise>
							<!-- Tumor Frequency ID is null. //-->
							</c:otherwise>
							</c:choose>
							<c:choose>
							<c:when test="${not empty pathology.tumorClassName}">
							<c:set var="num" value="${num == 1 ? 2 : 1}"/>
							<tr>
								<td><h4>Tumor Name</h4></td>
								<td>
									<h5>
										${pathology.organOrigin} 
										<!-- \n -->
										${pathology.tumorClassName}
									</h5>
								</td>
							</tr>
							</c:when>
							<c:otherwise>
							<!-- Tumor Name is null. //-->
							</c:otherwise>
							</c:choose>
							<c:choose>
							<c:when test="${not empty pathology.treatmentType}">
							<c:set var="num" value="${num == 1 ? 2 : 1}"/>
							<tr>
								<td><h4>Treatment Type</h4></td>
								<td>${pathology.treatmentType}</td>
							</tr>
							</c:when>
							<c:otherwise>
							<!-- Treatment type is null. //-->
							</c:otherwise>
							</c:choose>
							<c:choose>
							<c:when test="${not empty pathology.agents}">
							<c:set var="num" value="${num == 1 ? 2 : 1}"/>
							<tr>
								<td><h4>Agents</h4></td>
								<td>
									<c:forEach var="agent" items="${pathology.agents}" varStatus="status">
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
							<c:when test="${not empty pathology.tumorSynonyms}">
							<c:set var="num" value="${num == 1 ? 2 : 1}"/>
							<tr>
								<td><h4>Tumor Synonyms</h4></td>
								<td>
									<c:forEach var="tumorSynonym" items="${pathology.tumorSynonyms}" varStatus="status">
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
							<c:when test="${not empty pathology.organAffected}">
							<c:set var="num" value="${num == 1 ? 2 : 1}"/>
							<tr>
								<td><h4>Organ Affected</h4></td>
								<td>${pathology.organAffected}</td>
							</tr>
							</c:when>
							<c:otherwise>
							<!-- Organ affected is null. //-->
							</c:otherwise>
							</c:choose>
							<c:choose>
							<c:when test="${not empty pathology.frequency}">
							<c:set var="num" value="${num == 1 ? 2 : 1}"/>
							<tr>
								<td><h4>Frequency</h4></td>
								<td>${pathology.frequencyString}</td>
							</tr>
							</c:when>
							<c:otherwise>
							<!-- Frequency is null. //-->
							</c:otherwise>
							</c:choose>
							<c:choose>
							<c:when test="${not empty pathology.frequencyNote}">
							<c:set var="num" value="${num == 1 ? 2 : 1}"/>
							<tr>
								<td><h4>Frequency Note</h4></td>
								<td>${pathology.frequencyNote}</td>
							</tr>
							</c:when>
							<c:otherwise>
							<!-- Frequency note is null. //-->
							</c:otherwise>
							</c:choose>
							<c:choose>
							<c:when test="${(not empty pathology.referenceKey) && (not empty pathology.accessionId)}">
							<c:set var="num" value="${num == 1 ? 2 : 1}"/>
							<tr>
								<td><h4>Reference</h4></td>
								<td>
									<a href="nojavascript.jsp" onClick="focusBackToOpener('referenceDetails.do?key=${pathology.referenceKey}');return false;">${pathology.accessionId}</a>
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
							<c:when test="${not empty pathology.strainName}">
							<c:set var="num" value="${num == 1 ? 2 : 1}"/>
							<tr>
								<td><h4>Strain</h4></td>
								<td>
									<table>
										<tr>
											<td class="enhance" colspan="2"><a href="nojavascript.jsp" onclick="focusBackToOpener('strainDetails.do?key=${pathology.strainKey}');return false;"><c:out value="${pathology.strainName}" escapeXml="false"/></a></td>
										</tr>
										<c:if test="${not empty pathology.strainTypes}">
										<tr>
											<td class="label">Strain Types: </td>
											<td>
												<c:forEach var="type" items="${pathology.strainTypes}" varStatus="status">
												${type.type}
												<c:if test="${status.last != true}">
												&amp;
												</c:if>
												</c:forEach>
											</td>
										</tr>
										</c:if>
										<c:if test="${not empty pathology.strainNote}">
										<tr>
											<td class="label">General Note: </td>
											<td>${pathology.strainNote}</td>
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
							<c:when test="${not empty pathology.strainSynonyms}">
							<c:set var="num" value="${num == 1 ? 2 : 1}"/>
							<tr>
								<td><h4>Strain Synonyms</h4></td>
								<td>
									<c:forEach var="synonym" items="${pathology.strainSynonyms}" varStatus="status">
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
							<c:when test="${not empty pathology.sex}">
							<c:set var="num" value="${num == 1 ? 2 : 1}"/>
							<tr>
								<td><h4>Strain Sex</h4></td>
								<td>${pathology.sex}</td>
							</tr>
							</c:when>
							<c:otherwise>
							<!-- Strain sex is null. //-->
							</c:otherwise>
							</c:choose>
							<c:choose>
							<c:when test="${not empty pathology.reproductiveStatus}">
							<c:set var="num" value="${num == 1 ? 2 : 1}"/>
							<tr>
								<td><h4>Reproductive Status</h4></td>
								<td>${pathology.reproductiveStatus}</td>
							</tr>
							</c:when>
							<c:otherwise>
							<!-- Reproductive status is null. //-->
							</c:otherwise>
							</c:choose>
							<c:choose>
							<c:when test="${not empty pathology.ageOfOnset}">
							<c:set var="num" value="${num == 1 ? 2 : 1}"/>
							<tr>
								<td><h4>Age of Onset</h4></td>
								<td>${pathology.ageOfOnset}</td>
							</tr>
							</c:when>
							<c:otherwise>
							<!-- Age of onset is null. //-->
							</c:otherwise>
							</c:choose>
							<c:choose>
							<c:when test="${not empty pathology.ageOfDetection}">
							<c:set var="num" value="${num == 1 ? 2 : 1}"/>
							<tr>
								<td><h4>Age of Detection</h4></td>
								<td>${pathology.ageOfDetection}</td>
							</tr>
							</c:when>
							<c:otherwise>
							<!-- Age of detection status is null. //-->
							</c:otherwise>
							</c:choose>
						</table>
					</td>
					<!-- ////  End Bottom Right  //// -->
				</tr>
			</table>
			<!-- ////  End Tumor & Strain  //// -->
			<!-- ////  End Detail Section  //// -->
			</jsp:body>
		</jax:mmhcpage>
		
