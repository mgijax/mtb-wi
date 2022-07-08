<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean" %> 
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic" %> 
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Tumor Frequency Grid">
	<!-- ////  Start Detail Section  //// -->
	<h3>Tumor Frequency Grid (Inbred Strain Family x Organ)</h3>
	<p>Clicking in a colored box will take you to a summary of the records for
		spontaneous tumors of that organ or organ system observed in inbred mice
		of the corresponding strain family and reported in the literature. <strong>The data
			represented in the grid is dynamically generated and reflects the most recent 
	data available in the MTB system.</strong></p>
	<p>The records will be sorted based on the highest reported frequency. This
		summary, in turn, is linked to more detailed information about each of
	the reported tumors.</p>
	<p>Additional information associated with a colored cell will be displayed
		in a popup window of your web browser when you hold your mouse over the
		cell. <em>(Requires JavaScript support.)</em></p>
	<hr>
	<c:set var="rowSpan" value="0"/>
	<c:set var="totalColumns" value="2"/>
	<c:set var="strainName" value=""/>
	<c:set var="organName" value=""/>
	<c:catch var="exception">
	<c:choose>
	<c:when test="${not empty anatomicalSystems}">
	<table class="grid">
		<!-- ////  START HEADER  //// -->
		<tr class="grid">
			<td colspan="2" rowspan="2">
				<table>
					<tr><td><img src="${applicationScope.urlImageDir}/grid/veryhigh.png" alt="VH"></td><td class="grid">Very High</td></tr>
					<tr><td><img src="${applicationScope.urlImageDir}/grid/high.png" alt="HI"></td><td class="grid">High</td></tr>
					<tr><td><img src="${applicationScope.urlImageDir}/grid/moderate.png" alt="MO"></td><td class="grid">Moderate</td></tr>
					<tr><td><img src="${applicationScope.urlImageDir}/grid/low.png" alt="LO"></td><td class="grid">Low</td></tr>
					<tr><td><img src="${applicationScope.urlImageDir}/grid/verylow.png" alt="VL"></td><td class="grid">Very Low</td></tr>
					<tr><td><img src="${applicationScope.urlImageDir}/grid/observed.png" alt="OB"></td><td class="grid">Observed</td></tr>
					<tr><td bgcolor="#ffffff" width="20">0</td><td class="grid">Zero</td></tr>
				</table>
			</td>
			<c:choose>
			<c:when test="${not empty organKey}">
			<c:forEach var="anatomicalSystem" items="${anatomicalSystems}" varStatus="status">
			<c:set var="colspan" value="${fn:length(anatomicalSystem.organs)}"/>
			<c:forEach var="organParent" items="${anatomicalSystem.organs}" varStatus="status">
			<c:if test="${organKey == organParent.organKey}">
			<c:set var="colspan" value="${fn:length(organParent.organs) + colspan - 1}"/>
			</c:if>
			</c:forEach>
			<th colspan="${colspan}"><img src="dynamicText?text=${anatomicalSystem.anatomicalSystemName}&amp;size=10" alt="X">
				<!-- \n -->
			<img src="${applicationScope.urlImageDir}/grid/grid_spacer.png" alt=" "></th>
			</c:forEach>
			</c:when>
			<c:otherwise>
			<c:forEach var="anatomicalSystem" items="${anatomicalSystems}" varStatus="status">
			<th colspan="${fn:length(anatomicalSystem.organs)}"><img src="dynamicText?text=${anatomicalSystem.anatomicalSystemName}&amp;size=10" alt="X"></th>
			</c:forEach>
			</c:otherwise>
			</c:choose>
		</tr>
		<tr class="grid">
			<c:forEach var="anatomicalSystem" items="${anatomicalSystems}" varStatus="status">
			<c:forEach var="organParent" items="${anatomicalSystem.organs}" varStatus="status">
			<c:set var="totalColumns" value="${totalColumns + 1}"/>
			<c:choose>
			<c:when test="${not empty organKey}">
			<c:choose>
			<c:when test="${organKey == organParent.organKey}">
			<c:forEach var="organ" items="${organParent.organs}" varStatus="status">
			<c:set var="totalColumns" value="${totalColumns + 1}"/>
			<c:choose>
			<c:when test="${organ.organKey == organKey}">
			<c:url var="redirectUrl" value="redirect.do">
			<c:param name="url" value="tumorFrequencyGrid.do?organKey=${organKey}&amp;currentOrganKey=${currentOrganKey}&amp;strainFamilyKey=${strainFamilyKey}&amp;currentStrainFamilyKey="/>
			</c:url>
			<%--
			<th><a href="${redirectUrl}"><img src="${applicationScope.urlImageDir}/grid/${organParent.organKey}.png"></a>
				<!-- \n -->
				<!-- \n -->
				<a href="${redirectUrl}"><img src="${applicationScope.urlImageDir}/gridCollapse.png"></a>
				<!-- \n -->
			</th>
			--%>
			<th><a href="${redirectUrl}"><img src="${applicationScope.urlImageDir}/grid/${organParent.organKey}.png" alt="X"></a>
				<!-- \n -->
				<a href="${redirectUrl}"><img src="${applicationScope.urlImageDir}/grid/grid_col_top.png" alt="-"></a>
				<!-- \n -->
			</th>
			</c:when>
			<c:otherwise>
			<th><img src="${applicationScope.urlImageDir}/grid/${organ.organKey}.png" alt="X">
				<!-- \n -->
				<img src="${applicationScope.urlImageDir}/grid/grid_spacer.png">
				<!-- \n -->
				<img src="${applicationScope.urlImageDir}/grid/grid_spacer.png" alt=" ">
				<!-- \n -->
			</th>
			</c:otherwise>
			</c:choose>
			</c:forEach>
			</c:when>
			<c:otherwise>
			<c:url var="redirectUrl" value="redirect.do">
			<c:param name="url" value="tumorFrequencyGrid.do?organKey=${organParent.organKey}&amp;currentOrganKey=${currentOrganKey}&amp;strainFamilyKey=${strainFamilyKey}&amp;currentStrainFamilyKey="/>
			</c:url>
			<%--
			<th><a href="${redirectUrl}"><img src="${applicationScope.urlImageDir}/grid/${organParent.organKey}.png"></a>
				<!-- \n -->
				<!-- \n -->
				<a href="${redirectUrl}"><img src="${applicationScope.urlImageDir}/gridExpand.png"></a>
				<!-- \n -->
			</th>
			--%>
			<c:choose>
			<c:when test="${fn:length(organParent.organs) == 1}">
			<th><img src="${applicationScope.urlImageDir}/grid/${organParent.organKey}.png" alt="X">
				<!-- \n -->
				<img src="${applicationScope.urlImageDir}/grid/grid_spacer.png" alt=" ">
				<!-- \n -->
			</th>
			</c:when>
			<c:otherwise>
			<th><a href="${redirectUrl}"><img src="${applicationScope.urlImageDir}/grid/${organParent.organKey}.png" alt="X"></a>
				<!-- \n -->
				<a href="${redirectUrl}"><img src="${applicationScope.urlImageDir}/grid/grid_exp_top.png" alt="+"></a>
				<!-- \n -->
			</th>
			</c:otherwise>
			</c:choose>
			</c:otherwise>
			</c:choose>
			</c:when>
			<c:otherwise>
			<c:url var="redirectUrl" value="redirect.do">
			<c:param name="url" value="tumorFrequencyGrid.do?organKey=${organParent.organKey}&currentOrganKey=${currentOrganKey}&amp;strainFamilyKey=${strainFamilyKey}&amp;currentStrainFamilyKey="/>
			</c:url>
			<%--
			<th><a href="${redirectUrl}"><img src="${applicationScope.urlImageDir}/grid/${organParent.organKey}.png"></a>
				<!-- \n -->
				<a href="${redirectUrl}"><img src="${applicationScope.urlImageDir}/gridExpand.png"></a></th>
			--%>
			<c:choose>
			<c:when test="${fn:length(organParent.organs) == 1}">
			<th><img src="${applicationScope.urlImageDir}/grid/${organParent.organKey}.png" alt="X">
				<!-- \n -->
			<img src="${applicationScope.urlImageDir}/grid/grid_spacer.png" alt=" "></th>
			</c:when>
			<c:otherwise>
			<th><a href="${redirectUrl}"><img src="${applicationScope.urlImageDir}/grid/${organParent.organKey}.png" alt="X"></a>
				<!-- \n -->
				<a href="${redirectUrl}"><img src="${applicationScope.urlImageDir}/grid/grid_exp_top.png" alt="+"></a></th>
			</c:otherwise>
			</c:choose>
			</c:otherwise>
			</c:choose>
			</c:forEach>
			</c:forEach>
		</tr>
		<!-- ////  END HEADER  //// -->
		<c:forEach var="rowHeredity" items="${strains}" varStatus="status1">
		<tr style="background-color:black; height:1px"><td colspan="${totalColumns}" style='border:solid 1px #000000; height:1px;'></td></tr>
		<tr class="grid">
			<c:set var="heredityGrid" value =""/>
			<c:set var="heredityAll" value =""/>
			<c:set var="familyGrid" value =""/>
			<c:set var="familyAll" value =""/>
			<%--Getting heredity...for ${rowHeredity.strainHeredityName}
			<!-- \n -->
			--%>
			<c:forEach var="heredityItem" items="${gridData}" varStatus="status2">
			<c:if test="${empty heredityGrid}">
			<c:if test="${heredityItem.value.strainHeredityKey == rowHeredity.strainHeredityKey}">
			<%--MATCH: heredityItem.value.strainHeredityKey == rowHeredity.strainHeredityKey
			<!-- \n -->
			--%>
			<%--MATCH: ${heredityItem.value.strainHeredityKey} == ${rowHeredity.strainHeredityKey}
			<!-- \n -->
			--%>
			<c:set var="heredityGrid" value="${heredityItem.value}"/>
			<c:set var="heredityAll" value="${rowHeredity}"/>
			</c:if>
			</c:if>
			</c:forEach>
			<c:set var="rowSpan" value="${fn:length(rowHeredity.families)}"/>
			<c:if test="${not empty heredityGrid}">
			<c:if test="${not empty strainFamilyKey}">
			<c:forEach var="fam" items="${heredityAll.families}" varStatus="status3">
			<c:if test="${fam.strainFamilyKey == strainFamilyKey}">
			<c:set var="rowSpan" value="${fn:length(fam.strains) + rowSpan}"/>
			</c:if>
			</c:forEach>
			</c:if>
			</c:if>
			<td class="grid" rowspan="${rowSpan}"><img src="${applicationScope.urlImageDir}/grid/sh${rowHeredity.strainHeredityKey}.png" alt="${rowHeredity.strainHeredityName}"><img src="${applicationScope.urlImageDir}/grid/grid_spacer.png" alt=" "></td>
			<%--Done Heredity!
			<!-- \n -->
			--%>
			<c:choose>
			<c:when test="${not empty heredityGrid}">
			<%--
			We have a heredity value. <strong>${heredityGrid.strainHeredityName}</strong>
			<!-- \n -->
			Getting family...
			<!-- \n -->
			--%>
			<c:forEach var="fam" items="${heredityAll.families}" varStatus="status3">
			<c:set var="familyGrid" value =""/>
			<c:set var="familyAll" value =""/>
			<c:if test="${!status3.first}">
			<tr class="grid">
				</c:if>
				<c:forEach var="familyItem" items="${heredityGrid.strainFamilies}" varStatus="status3">
				<%--===> looking for ${fam.strainFamilyName}
				<!-- \n -->
				--%>
				<c:if test="${familyItem.value.strainFamilyKey == fam.strainFamilyKey}">
				<%--MATCH: familyItem.value.strainFamilyKey == fam.strainFamilyKey
				<!-- \n -->
				MATCH: ${familyItem.value.strainFamilyKey} == ${fam.strainFamilyKey}
				<!-- \n -->
				--%>
				<c:set var="familyGrid" value="${familyItem.value}"/>
				<c:set var="familyAll" value="${fam}"/>
				</c:if>
				</c:forEach>
				<c:choose>
				<c:when test="${not empty familyGrid}">
				<%--
				<c:if test="${fam.strainFamilyKey == 86}">
				<pre>
					<c:out value="${familyGrid}"/>
				</pre>
				</c:if>
				--%>
				<%--We have a family value. <strong>${familyGrid.strainFamilyName}</strong>
				<!-- \n -->
				--%>
				<c:url var="redirectUrl" value="redirect.do">
				<c:param name="url" value="tumorFrequencyGrid.do?organKey=${organKey}&amp;currentOrganKey=&amp;strainFamilyKey=${familyGrid.strainFamilyKey}&amp;currentStrainFamilyKey=${currentStrainFamilyKey}"/>
				</c:url>
				<%-- DETERMINE STRAIN FAMILY IMAGE EXPANDED OR COLLAPSED --%>
				<c:choose>
				<c:when test="${not empty strainFamilyKey}">
				<c:choose>
				<c:when test="${fam.strainFamilyKey == strainFamilyKey}">
				<%--
				<td class="grid"><a href="${redirectUrl}"><img src="${applicationScope.urlImageDir}/gridCollapse.png"></a>&nbsp;&nbsp;${familyGrid.strainFamilyName} (ALL)</td>
				--%>
				<td class="grid"><a href="${redirectUrl}"><img src="${applicationScope.urlImageDir}/grid/grid_col_left.png" alt="-"></a>&nbsp;${familyGrid.strainFamilyName} (ALL)</td>
				</c:when>
				<c:otherwise>
				<%--
				<td class="grid"><a href="${redirectUrl}"><img src="${applicationScope.urlImageDir}/gridExpand.png"></a>&nbsp;&nbsp;${familyGrid.strainFamilyName}</td>
				--%>
				<td class="grid"><a href="${redirectUrl}"><img src="${applicationScope.urlImageDir}/grid/grid_exp_left.png" alt="+"></a>&nbsp;${familyGrid.strainFamilyName}</td>
				</c:otherwise>
				</c:choose>
				</c:when>
				<c:otherwise>
				<%--
				<td class="grid"><a href="${redirectUrl}"><img src="${applicationScope.urlImageDir}/gridExpand.png"></a>&nbsp;&nbsp;${familyGrid.strainFamilyName}</td>
				--%>
				<td class="grid"><a href="${redirectUrl}"><img src="${applicationScope.urlImageDir}/grid/grid_exp_left.png" alt="+"></a>&nbsp;${familyGrid.strainFamilyName}</td>
				</c:otherwise>
				</c:choose>
				<%-- DETERMINE IF WE HAVE EXPANDED STRAINS OR NOT --%>
				<c:choose>
				<c:when test="${not empty strainFamilyKey}">
				<%----------------------------------- START Strains are expanded -----------------------------------------%>
				<%-- <h2>Strains are expanded!!!</h2> --%>
				<c:choose>
				<c:when test="${fam.strainFamilyKey == strainFamilyKey}">
				<%----------------------------------- START Strain Family and expanded Strains ---------------------------%>
				<%----------------------------------- START Strain Family ------------------------------------------------%>																											 
				<c:forEach var="anatomicalSystem" items="${anatomicalSystems}" varStatus="status">
				<c:forEach var="organParent" items="${anatomicalSystem.organs}" varStatus="status">
				<c:set var="organ" value=""/>
				<c:choose>
				<c:when test="${not empty organKey}">
				<%--
				------------ POTENTIALLY EXPANDED GRID ------------------
				<!-- \n -->
				<h3>TESTING</h3>
				ORGAN KEY = ${organKey}
				<!-- \n -->
				ORGAN PARENT KEY = ${organParent.organKey}
				<!-- \n -->
				--%>
				<c:choose>
				<c:when test="${organKey == organParent.organKey}">
				<%-- ------------ LOOP THROUGH SUB ORGANS ------------------
				<!-- \n -->
				--%>
				<c:forEach var="subOrgan" items="${organParent.organs}" varStatus="status">
				<%-- SUBORGAN NAME: ${subOrgan.organName}
				<!-- \n -->
				--%>
				<c:set var="organ" value=""/>
				<c:forEach var="organItem" items="${familyGrid.organs}" varStatus="status">
				<c:forEach var="subOrganItem" items="${organItem.value.organs}" varStatus="status">
				<c:if test="${subOrgan.organKey == subOrganItem.value.organKey}">
				<%--
				MATCH: ${subOrgan.organKey} == ${subOrganItem.value.organKey}
				<!-- \n -->
				ORGAN: ${subOrgan.organName}
				<!-- \n -->
				--%>
				<c:set var="organ" value="${subOrganItem.value}"/>
				</c:if>
				</c:forEach>
				</c:forEach>
				<c:choose>
				<c:when test="${not empty organ}">
				<c:set var="tdOut" value=""/>
				<c:choose>
				<c:when test="${organ.frequencyDetail.noTumors}">
				<c:set var="tdOut" value="0"/>
				</c:when>
				<c:otherwise>
				<c:set var="tdOut" value="<img src='${applicationScope.urlImageDir}/grid/${organ.frequencyDetail.descriptionHighest}.png' alt='-'>"/>
				</c:otherwise>
				</c:choose>
				<%--
				Removed from popup. For debugging purposes only.
				<tr><td class="gridDetails">Frequency Keys:</td><td class="gridDetails">${organ.frequencyDetail.TFKeys}</td></tr>
		--%>
		<td><a href="tumorSearchResults.do?grid=1&amp;strainFamilyKey=${familyGrid.strainFamilyKey}&amp;organKey=${organ.organKey}">${tdOut}<div role="tooltip"><table class="gridDetails"><tr><td class="gridDetails">Strain Family:</td><td class="gridDetails">${familyGrid.strainFamilyName}</td></tr><tr><td class="gridDetails">Organ:</td><td class="gridDetails">${organ.organName}</td></tr><tr><td class="gridDetails">Highest reported tumor frequency:</td><td class="gridDetails">${organ.frequencyDetail.longDescriptionHighest}</td></tr><tr><td class="gridDetails"># Tumor Frequency Records:</td><td class="gridDetails">${organ.frequencyDetail.count}</td></tr></table></div></a></td>
</c:when>
<c:otherwise>
<td></td>
</c:otherwise>
</c:choose>
<c:set var="organ" value=""/>
</c:forEach>
</c:when>
<c:otherwise>
<%-- ------------ LOOP THROUGH PARENT ORGANS------------------
<!-- \n -->
--%>
<c:forEach var="organItem" items="${familyGrid.organs}" varStatus="status4">
<c:if test="${organParent.organKey == organItem.value.organKey}">
<%--MATCH: ${organParent.organKey} == ${organItem.value.organKey}
<!-- \n -->
ORGAN: ${organParent.organName}
<!-- \n -->
--%>
<c:set var="organ" value="${organItem.value}"/>
</c:if>
</c:forEach>
<c:choose>
<c:when test="${not empty organ}">
<c:set var="tdOut" value=""/>
<c:choose>
<c:when test="${organ.frequencyDetail.noTumors}">
<c:set var="tdOut" value="0"/>
</c:when>
<c:otherwise>
<c:set var="tdOut" value="<img src='${applicationScope.urlImageDir}/grid/${organ.frequencyDetail.descriptionHighest}.png' alt='-'>"/>
</c:otherwise>
</c:choose>
<td><a href="tumorSearchResults.do?grid=1&strainFamilyKey=${familyGrid.strainFamilyKey}&amp;organParentKey=${organ.organKey}">${tdOut}<div role="tooltip"><table class="gridDetails"><tr><td class="gridDetails">Strain Family:</td><td class="gridDetails">${familyGrid.strainFamilyName}</td></tr><tr><td class="gridDetails">Organ:</td><td class="gridDetails">${organ.organName}</td></tr><tr><td class="gridDetails">Highest reported tumor frequency:</td><td class="gridDetails">${organ.frequencyDetail.longDescriptionHighest}</td></tr><tr><td class="gridDetails"># Tumor Frequency Records:</td><td class="gridDetails">${organ.frequencyDetail.count}</td></tr></table></div></a></td>
</c:when>
<c:otherwise>
<td></td>
</c:otherwise>
</c:choose>
</c:otherwise>
</c:choose>
</c:when>
<c:otherwise>
<%-- ------------ COLLAPSED GRID ------------------
<!-- \n -->
--%>
<c:forEach var="organItem" items="${familyGrid.organs}" varStatus="status4">
<c:if test="${organParent.organKey == organItem.value.organKey}">
<%--MATCH: ${organParent.organKey} == ${organItem.value.organKey}
<!-- \n -->
ORGAN: ${organParent.organName}
<!-- \n -->
--%>
<c:set var="organ" value="${organItem.value}"/>
</c:if>
</c:forEach>
<c:choose>
<c:when test="${not empty organ}">
<c:set var="tdOut" value=""/>
<c:choose>
<c:when test="${organ.frequencyDetail.noTumors}">
<c:set var="tdOut" value="0"/>
</c:when>
<c:otherwise>
<c:set var="tdOut" value="<img src='${applicationScope.urlImageDir}/grid/${organ.frequencyDetail.descriptionHighest}.png' alt='-'>"/>
</c:otherwise>
</c:choose>
<td><a href="tumorSearchResults.do?grid=1&amp;strainFamilyKey=${familyGrid.strainFamilyKey}&amp;organParentKey=${organ.organKey}">${tdOut}<div role="tooltip"><table class="gridDetails"><tr><td class="gridDetails">Strain Family:</td><td class="gridDetails">${familyGrid.strainFamilyName}</td></tr><tr><td class="gridDetails">Organ:</td><td class="gridDetails">${organ.organName}</td></tr><tr><td class="gridDetails">Highest reported tumor frequency:</td><td class="gridDetails">${organ.frequencyDetail.longDescriptionHighest}</td></tr><tr><td class="gridDetails"># Tumor Frequency Records:</td><td class="gridDetails">${organ.frequencyDetail.count}</td></tr></table></div></a></td>
</c:when>
<c:otherwise>
<td></td>
</c:otherwise>
</c:choose>
</c:otherwise>
</c:choose>
</c:forEach>
</c:forEach>
</tr>
<%----------------------------------- END Strain Family ------------------------------------------------%>
<%----------------------------------- START Strain Expansion -------------------------------------------%>
<%--
${fam.strainFamilyKey} == ${strainFamilyKey}
<!-- \n -->
DISPLAY SUB STRAINS!
<!-- \n -->
--%>
<c:set var="theStrain" value=""/>
<c:forEach var="strainCat" items="${familyAll.strains}" varStatus="status2000">
<c:set var="theStrain" value=""/>
<c:forEach var="strainItem" items="${familyGrid.strains}" varStatus="status2001">
<c:if test="${strainCat.strainKey == strainItem.value.strainKey}">
<c:set var="theStrain" value="${strainItem.value}"/>
</c:if>
</c:forEach>
<tr class="grid">
	<td class="grid"><img src="${applicationScope.urlImageDir}/grid/grid_spacer.png" alt=" "><img src="${applicationScope.urlImageDir}/grid/grid_spacer.png" alt=" "><img src="${applicationScope.urlImageDir}/grid/grid_spacer.png" alt=" "><c:out value="${strainCat.strainName}" escapeXml="false"/></td>
	<c:choose>
	<c:when test="${not empty theStrain}">
	<c:forEach var="anatomicalSystem" items="${anatomicalSystems}" varStatus="status">
	<c:forEach var="organParent" items="${anatomicalSystem.organs}" varStatus="status">
	<c:set var="organ" value=""/>
	<c:choose>
	<c:when test="${not empty organKey}">
	<%--
	------------ POTENTIALLY EXPANDED GRID ------------------
	<!-- \n -->
	<h3>TESTING</h3>
	ORGAN KEY = ${organKey}
	<!-- \n -->
	ORGAN PARENT KEY = ${organParent.organKey}
	<!-- \n -->
	--%>
	<c:choose>
	<c:when test="${organKey == organParent.organKey}">
	<%-- ------------ LOOP THROUGH SUB ORGANS ------------------
	<!-- \n -->
	--%>
	<c:forEach var="subOrgan" items="${organParent.organs}" varStatus="status">
	<%-- SUBORGAN NAME: ${subOrgan.organName}
	<!-- \n -->
	--%>
	<c:set var="organ" value=""/>
	<c:forEach var="organItem" items="${theStrain.organs}" varStatus="status">
	<%-- <strong>organItem = ${organItem}</strong> --%>
	<c:forEach var="subOrganItem" items="${organItem.value.organs}" varStatus="status">
	<%-- TESTING ${subOrgan.organKey} TO ${subOrganItem.value.organKey}
	<!-- \n -->
	--%>
	<c:if test="${subOrgan.organKey == subOrganItem.value.organKey}">
	<%--
	SUB
	<!-- \n -->
	MATCH: ${subOrgan.organKey} == ${subOrganItem.value.organKey}
	<!-- \n -->
	ORGAN: ${subOrgan.organName}
	<!-- \n -->
	--%>
	<c:set var="organ" value="${subOrganItem.value}"/>
	</c:if>
	</c:forEach>
	</c:forEach>
	<c:choose>
	<c:when test="${not empty organ}">
	<c:set var="tdOut" value=""/>
	<c:choose>
	<c:when test="${organ.frequencyDetail.noTumors}">
	<c:set var="tdOut" value="0"/>
	</c:when>
	<c:otherwise>
	<c:set var="tdOut" value="<img src='${applicationScope.urlImageDir}/grid/${organ.frequencyDetail.descriptionHighest}.png' alt='H'>"/>
	</c:otherwise>
	</c:choose>
	<td><a href="tumorSearchResults.do?grid=1&amp;strainKey=${theStrain.strainKey}&amp;organKey=${organ.organKey}">${tdOut}<div role="tooltip"><table class="gridDetails"><tr><td class="gridDetails">Strain:</td><td class="gridDetails">${theStrain.strainName}</td></tr><tr><td class="gridDetails">Organ:</td><td class="gridDetails">${organ.organName}</td></tr><tr><td class="gridDetails">Highest reported tumor frequency:</td><td class="gridDetails">${organ.frequencyDetail.longDescriptionHighest}</td></tr><tr><td class="gridDetails"># Tumor Frequency Records:</td><td class="gridDetails">${organ.frequencyDetail.count}</td></tr></table></div></a></td>
</c:when>
<c:otherwise>
<td></td>
</c:otherwise>
</c:choose>
<c:set var="organ" value=""/>
</c:forEach>
</c:when>
<c:otherwise>
<%-- ------------ LOOP THROUGH PARENT ORGANS------------------
<!-- \n -->
--%>
<c:forEach var="organItem" items="${theStrain.organs}" varStatus="status4">
<%-- <strong>organ item = ${organItem}</strong> --%>
<c:if test="${organParent.organKey == organItem.value.organKey}">
<%--
PARENT
<!-- \n -->
MATCH: ${organParent.organKey} == ${organItem.value.organKey}
<!-- \n -->
ORGAN: ${organParent.organName}
<!-- \n -->
--%>
<c:set var="organ" value="${organItem.value}"/>
</c:if>
</c:forEach>
<c:choose>
<c:when test="${not empty organ}">
<c:set var="tdOut" value=""/>
<c:choose>
<c:when test="${organ.frequencyDetail.noTumors}">
<c:set var="tdOut" value="0"/>
</c:when>
<c:otherwise>
<c:set var="tdOut" value="<img src='${applicationScope.urlImageDir}/grid/${organ.frequencyDetail.descriptionHighest}.png' alt='H'>"/>
</c:otherwise>
</c:choose>
<td><a href="tumorSearchResults.do?grid=1&amp;strainKey=${theStrain.strainKey}&amp;organParentKey=${organ.organKey}">${tdOut}<div role="tooltip"><table class="gridDetails"><tr><td class="gridDetails">Strain:</td><td class="gridDetails">${theStrain.strainName}</td></tr><tr><td class="gridDetails">Organ:</td><td class="gridDetails">${organ.organName}</td></tr><tr><td class="gridDetails">Highest reported tumor frequency:</td><td class="gridDetails">${organ.frequencyDetail.longDescriptionHighest}</td></tr><tr><td class="gridDetails"># Tumor Frequency Records:</td><td class="gridDetails">${organ.frequencyDetail.count}</td></tr></table></div></a></td>
</c:when>
<c:otherwise>
<td></td>
</c:otherwise>
</c:choose>
</c:otherwise>
</c:choose>
</c:when>
<c:otherwise>
<%-- ------------ COLLAPSED GRID ------------------
<!-- \n -->
--%>
<c:forEach var="organItem" items="${theStrain.organs}" varStatus="status4">
<c:if test="${organParent.organKey == organItem.value.organKey}">
<%--
COLLAPSED
<!-- \n -->
MATCH: ${organParent.organKey} == ${organItem.value.organKey}
<!-- \n -->
ORGAN: ${organParent.organName}
<!-- \n -->
--%>
<c:set var="organ" value="${organItem.value}"/>
</c:if>
</c:forEach>
<c:choose>
<c:when test="${not empty organ}">
<c:set var="tdOut" value=""/>
<c:choose>
<c:when test="${organ.frequencyDetail.noTumors}">
<c:set var="tdOut" value="0"/>
</c:when>
<c:otherwise>
<c:set var="tdOut" value="<img src='${applicationScope.urlImageDir}/grid/${organ.frequencyDetail.descriptionHighest}.png' alt='H'>"/>
</c:otherwise>
</c:choose>
<td><a href="tumorSearchResults.do?grid=1&amp;strainKey=${theStrain.strainKey}&amp;organParentKey=${organ.organKey}">${tdOut}<div role="tooltip"><table class="gridDetails"><tr><td class="gridDetails">Strain:</td><td class="gridDetails">${theStrain.strainName}</td></tr><tr><td class="gridDetails">Organ:</td><td class="gridDetails">${organ.organName}</td></tr><tr><td class="gridDetails">Highest reported tumor frequency:</td><td class="gridDetails">${organ.frequencyDetail.longDescriptionHighest}</td></tr><tr><td class="gridDetails"># Tumor Frequency Records:</td><td class="gridDetails">${organ.frequencyDetail.count}</td></tr></table></div></a></td>
</c:when>
<c:otherwise>
<td></td>
</c:otherwise>
</c:choose>
</c:otherwise>
</c:choose>
</c:forEach>
</c:forEach>
</c:when>
<c:otherwise>
<%--We <strong>DO NOT</strong> have a strain value...dump out a row of empty values.
<!-- \n -->
--%>
<c:set var="startColumn" value="3"/>
<c:if test="${not empty organKey}">
<c:set var="startColumn" value="4"/>
</c:if>
<c:forEach var="i" begin="${startColumn}" end="${totalColumns}">
<td bgcolor="#ffffff"></td>
</c:forEach>
</c:otherwise>
</c:choose>
</tr>
</c:forEach>
<%----------------------------------- END Strain Expansion ---------------------------------------------%>
<%----------------------------------- END Strain Family and expanded Strains ---------------------------%>
</c:when>
<c:otherwise>
<%----------------------------------- START Strain Family and NO expanded Strains ----------------------%>
<%--
${fam.strainFamilyKey} != ${strainFamilyKey}
<!-- \n -->
DISPLAY FAMILY AS NORMAL!
<!-- \n -->
--%>
<c:forEach var="anatomicalSystem" items="${anatomicalSystems}" varStatus="status">
<c:forEach var="organParent" items="${anatomicalSystem.organs}" varStatus="status">
<c:set var="organ" value=""/>
<c:choose>
<c:when test="${not empty organKey}">
<%----------------------------------- START Organs Expanded Strains ------------------------------------%>
<%--
<h3>TESTING</h3>
ORGAN KEY = ${organKey}
<!-- \n -->
ORGAN PARENT KEY = ${organParent.organKey}
<!-- \n -->
--%>
<c:choose>
<c:when test="${organKey == organParent.organKey}">
<%-- ------------ LOOP THROUGH SUB ORGANS ------------------
<!-- \n -->
--%>
<c:forEach var="subOrgan" items="${organParent.organs}" varStatus="status">
<%-- SUBORGAN NAME: ${subOrgan.organName}
<!-- \n -->
--%>
<c:set var="organ" value=""/>
<c:forEach var="organItem" items="${familyGrid.organs}" varStatus="status">
<c:forEach var="subOrganItem" items="${organItem.value.organs}" varStatus="status">
<c:if test="${subOrgan.organKey == subOrganItem.value.organKey}">
<%--
MATCH: ${subOrgan.organKey} == ${subOrganItem.value.organKey}
<!-- \n -->
ORGAN: ${subOrgan.organName}
<!-- \n -->
--%>
<c:set var="organ" value="${subOrganItem.value}"/>
</c:if>
</c:forEach>
</c:forEach>
<c:choose>
<c:when test="${not empty organ}">
<c:set var="tdOut" value=""/>
<c:choose>
<c:when test="${organ.frequencyDetail.noTumors}">
<c:set var="tdOut" value="0"/>
</c:when>
<c:otherwise>
<c:set var="tdOut" value="<img src='${applicationScope.urlImageDir}/grid/${organ.frequencyDetail.descriptionHighest}.png' alt='H'>"/>
</c:otherwise>
</c:choose>
<td><a href="tumorSearchResults.do?grid=1&amp;strainFamilyKey=${familyGrid.strainFamilyKey}&amp;organKey=${organ.organKey}">${tdOut}<div role="tooltip"><table class="gridDetails"><tr><td class="gridDetails">Strain Family:</td><td class="gridDetails">${familyGrid.strainFamilyName}</td></tr><tr><td class="gridDetails">Organ:</td><td class="gridDetails">${organ.organName}</td></tr><tr><td class="gridDetails">Highest reported tumor frequency:</td><td class="gridDetails">${organ.frequencyDetail.longDescriptionHighest}</td></tr><tr><td class="gridDetails"># Tumor Frequency Records:</td><td class="gridDetails">${organ.frequencyDetail.count}</td></tr></table></div></a></td>
</c:when>
<c:otherwise>
<td></td>
</c:otherwise>
</c:choose>
<c:set var="organ" value=""/>
</c:forEach>
</c:when>
<c:otherwise>
<%-- ------------ LOOP THROUGH PARENT ORGANS------------------
<!-- \n -->
--%>
<c:forEach var="organItem" items="${familyGrid.organs}" varStatus="status4">
<c:if test="${organParent.organKey == organItem.value.organKey}">
<%--MATCH: ${organParent.organKey} == ${organItem.value.organKey}
<!-- \n -->
ORGAN: ${organParent.organName}
<!-- \n -->
--%>
<c:set var="organ" value="${organItem.value}"/>
</c:if>
</c:forEach>
<c:choose>
<c:when test="${not empty organ}">
<c:set var="tdOut" value=""/>
<c:choose>
<c:when test="${organ.frequencyDetail.noTumors}">
<c:set var="tdOut" value="0"/>
</c:when>
<c:otherwise>
<c:set var="tdOut" value="<img src='${applicationScope.urlImageDir}/grid/${organ.frequencyDetail.descriptionHighest}.png' alt='H'>"/>
</c:otherwise>
</c:choose>
<td><a href="tumorSearchResults.do?grid=1&amp;strainFamilyKey=${familyGrid.strainFamilyKey}&amp;organParentKey=${organ.organKey}">${tdOut}<div role="tooltip"><table class="gridDetails"><tr><td class="gridDetails">Strain Family:</td><td class="gridDetails">${familyGrid.strainFamilyName}</td></tr><tr><td class="gridDetails">Organ:</td><td class="gridDetails">${organ.organName}</td></tr><tr><td class="gridDetails">Highest reported tumor frequency:</td><td class="gridDetails">${organ.frequencyDetail.longDescriptionHighest}</td></tr><tr><td class="gridDetails"># Tumor Frequency Records:</td><td class="gridDetails">${organ.frequencyDetail.count}</td></tr></table></div></a></td>
</c:when>
<c:otherwise>
<td></td>
</c:otherwise>
</c:choose>
</c:otherwise>
</c:choose>
<%----------------------------------- END Organs Expanded Strains ----------------------------------------%>
</c:when>
<c:otherwise>
<%----------------------------------- START Organs are NOT expanded --------------------------------------%>
<c:forEach var="organItem" items="${familyGrid.organs}" varStatus="status4">
<c:if test="${organParent.organKey == organItem.value.organKey}">
<%--MATCH: ${organParent.organKey} == ${organItem.value.organKey}
<!-- \n -->
ORGAN: ${organParent.organName}
<!-- \n -->
--%>
<c:set var="organ" value="${organItem.value}"/>
</c:if>
</c:forEach>
<c:choose>
<c:when test="${not empty organ}">
<c:set var="tdOut" value=""/>
<c:choose>
<c:when test="${organ.frequencyDetail.noTumors}">
<c:set var="tdOut" value="0"/>
</c:when>
<c:otherwise>
<c:set var="tdOut" value="<img src='${applicationScope.urlImageDir}/grid/${organ.frequencyDetail.descriptionHighest}.png' alt='H'>"/>
</c:otherwise>
</c:choose>
<td><a href="tumorSearchResults.do?grid=1&amp;strainFamilyKey=${familyGrid.strainFamilyKey}&amp;organParentKey=${organ.organKey}">${tdOut}<div role="tooltip"><table class="gridDetails"><tr><td class="gridDetails">Strain Family:</td><td class="gridDetails">${familyGrid.strainFamilyName}</td></tr><tr><td class="gridDetails">Organ:</td><td class="gridDetails">${organ.organName}</td></tr><tr><td class="gridDetails">Highest reported tumor frequency:</td><td class="gridDetails">${organ.frequencyDetail.longDescriptionHighest}</td></tr><tr><td class="gridDetails"># Tumor Frequency Records:</td><td class="gridDetails">${organ.frequencyDetail.count}</td></tr></table></div></a></td>
</c:when>
<c:otherwise>
<td></td>
</c:otherwise>
</c:choose>
<%----------------------------------- END Organs are NOT expanded -------------------------------------------%>
</c:otherwise>
</c:choose>
</c:forEach>
</c:forEach>
<%----------------------------------- END Strain Family and NO expanded Strains ------------------------%>
</c:otherwise>
</c:choose>
<%----------------------------------- END Strains are expanded -----------------------------------------%>
</c:when>
<c:otherwise>
<%----------------------------------- START Strains are not expanded -----------------------------------%>
<%--Getting organ...
<!-- \n -->
--%>
<c:forEach var="anatomicalSystem" items="${anatomicalSystems}" varStatus="status">
<c:forEach var="organParent" items="${anatomicalSystem.organs}" varStatus="status">
<c:set var="organ" value=""/>
<c:choose>
<c:when test="${not empty organKey}">
<%--
------------ POTENTIALLY EXPANDED GRID ------------------
<!-- \n -->
<h3>TESTING</h3>
ORGAN KEY = ${organKey}
<!-- \n -->
ORGAN PARENT KEY = ${organParent.organKey}
<!-- \n -->
--%>
<c:choose>
<c:when test="${organKey == organParent.organKey}">
<%-- ------------ LOOP THROUGH SUB ORGANS ------------------
<!-- \n -->
--%>
<c:forEach var="subOrgan" items="${organParent.organs}" varStatus="status">
<%-- SUBORGAN NAME: ${subOrgan.organName}
<!-- \n -->
--%>
<c:set var="organ" value=""/>
<c:forEach var="organItem" items="${familyGrid.organs}" varStatus="status">
<c:forEach var="subOrganItem" items="${organItem.value.organs}" varStatus="status">
<c:if test="${subOrgan.organKey == subOrganItem.value.organKey}">
<%--
MATCH: ${subOrgan.organKey} == ${subOrganItem.value.organKey}
<!-- \n -->
ORGAN: ${subOrgan.organName}
<!-- \n -->
--%>
<c:set var="organ" value="${subOrganItem.value}"/>
</c:if>
</c:forEach>
</c:forEach>
<c:choose>
<c:when test="${not empty organ}">
<c:set var="tdOut" value=""/>
<c:choose>
<c:when test="${organ.frequencyDetail.noTumors}">
<c:set var="tdOut" value="0"/>
</c:when>
<c:otherwise>
<c:set var="tdOut" value="<img src='${applicationScope.urlImageDir}/grid/${organ.frequencyDetail.descriptionHighest}.png' alt='H'>"/>
</c:otherwise>
</c:choose>
<td><a href="tumorSearchResults.do?grid=1&amp;strainFamilyKey=${familyGrid.strainFamilyKey}&amp;organKey=${organ.organKey}">${tdOut}<div role="tooltip"><table class="gridDetails"><tr><td class="gridDetails">Strain Family:</td><td class="gridDetails">${familyGrid.strainFamilyName}</td></tr><tr><td class="gridDetails">Organ:</td><td class="gridDetails">${organ.organName}</td></tr><tr><td class="gridDetails">Highest reported tumor frequency:</td><td class="gridDetails">${organ.frequencyDetail.longDescriptionHighest}</td></tr><tr><td class="gridDetails"># Tumor Frequency Records:</td><td class="gridDetails">${organ.frequencyDetail.count}</td></tr></table></div></a></td>
</c:when>
<c:otherwise>
<td></td>
</c:otherwise>
</c:choose>
<c:set var="organ" value=""/>
</c:forEach>
</c:when>
<c:otherwise>
<%-- ------------ LOOP THROUGH PARENT ORGANS------------------
<!-- \n -->
--%>
<c:forEach var="organItem" items="${familyGrid.organs}" varStatus="status4">
<c:if test="${organParent.organKey == organItem.value.organKey}">
<%--MATCH: ${organParent.organKey} == ${organItem.value.organKey}
<!-- \n -->
ORGAN: ${organParent.organName}
<!-- \n -->
--%>
<c:set var="organ" value="${organItem.value}"/>
</c:if>
</c:forEach>
<c:choose>
<c:when test="${not empty organ}">
<c:set var="tdOut" value=""/>
<c:choose>
<c:when test="${organ.frequencyDetail.noTumors}">
<c:set var="tdOut" value="0"/>
</c:when>
<c:otherwise>
<c:set var="tdOut" value="<img src='${applicationScope.urlImageDir}/grid/${organ.frequencyDetail.descriptionHighest}.png' alt='H'>"/>
</c:otherwise>
</c:choose>
<td><a href="tumorSearchResults.do?grid=1&amp;strainFamilyKey=${familyGrid.strainFamilyKey}&amp;organParentKey=${organ.organKey}">${tdOut}<div role="tooltip"><table class="gridDetails"><tr><td class="gridDetails">Strain Family:</td><td class="gridDetails">${familyGrid.strainFamilyName}</td></tr><tr><td class="gridDetails">Organ:</td><td class="gridDetails">${organ.organName}</td></tr><tr><td class="gridDetails">Highest reported tumor frequency:</td><td class="gridDetails">${organ.frequencyDetail.longDescriptionHighest}</td></tr><tr><td class="gridDetails"># Tumor Frequency Records:</td><td class="gridDetails">${organ.frequencyDetail.count}</td></tr></table></div></a></td>
</c:when>
<c:otherwise>
<td></td>
</c:otherwise>
</c:choose>
</c:otherwise>
</c:choose>
</c:when>
<c:otherwise>
<%-- ------------ COLLAPSED GRID ------------------
<!-- \n -->
--%>
<c:forEach var="organItem" items="${familyGrid.organs}" varStatus="status4">
<c:if test="${organParent.organKey == organItem.value.organKey}">
<%--MATCH: ${organParent.organKey} == ${organItem.value.organKey}
<!-- \n -->
ORGAN: ${organParent.organName}
<!-- \n -->
--%>
<c:set var="organ" value="${organItem.value}"/>
</c:if>
</c:forEach>
<c:choose>
<c:when test="${not empty organ}">
<c:set var="tdOut" value=""/>
<c:choose>
<c:when test="${organ.frequencyDetail.noTumors}">
<c:set var="tdOut" value="0"/>
</c:when>
<c:otherwise>
<c:set var="tdOut" value="<img src='${applicationScope.urlImageDir}/grid/${organ.frequencyDetail.descriptionHighest}.png' alt='H'>"/>
</c:otherwise>
</c:choose>
<td><a href="tumorSearchResults.do?grid=1&amp;strainFamilyKey=${familyGrid.strainFamilyKey}&amp;organParentKey=${organ.organKey}">${tdOut}<div role="tooltip"><table class="gridDetails"><tr><td class="gridDetails">Strain Family:</td><td class="gridDetails">${familyGrid.strainFamilyName}</td></tr><tr><td class="gridDetails">Organ:</td><td class="gridDetails">${organ.organName}</td></tr><tr><td class="gridDetails">Highest reported tumor frequency:</td><td class="gridDetails">${organ.frequencyDetail.longDescriptionHighest}</td></tr><tr><td class="gridDetails"># Tumor Frequency Records:</td><td class="gridDetails">${organ.frequencyDetail.count}</td></tr></table></div></a></td>
</c:when>
<c:otherwise>
<td></td>
</c:otherwise>
</c:choose>
</c:otherwise>
</c:choose>
</c:forEach>
</c:forEach>
<%----------------------------------- END Strains are not expanded -------------------------------------%>
</c:otherwise>
</c:choose>
</c:when>
<c:otherwise>
<%--We <strong>DO NOT</strong> have a family value...dump out a row of empty values.
<!-- \n -->
--%>
<td class="grid"><img src="${applicationScope.urlImageDir}/grid/grid_spacer.png" alt=" ">&nbsp;${fam.strainFamilyName}</td>
<c:set var="startColumn" value="3"/>
<c:if test="${not empty organKey}">
<c:set var="startColumn" value="4"/>
</c:if>
<c:forEach var="i" begin="${startColumn}" end="${totalColumns}">
<td bgcolor="#ffffff"></td>
</c:forEach>
</c:otherwise>
</c:choose>
</tr>
</c:forEach>
</c:when>
<c:otherwise>
<%--We <strong>DO NOT</strong> have a heredity value...dump out a row of empty values.
<!-- \n -->
--%>
<c:forEach var="fam" items="${rowHeredity.families}" varStatus="status3">
<c:if test="${!status3.first}">
<tr class="grid">
	</c:if>
	<td class="grid" bgcolor="#ffffff"><img src="${applicationScope.urlImageDir}/grid/grid_spacer.png" alt=" ">&nbsp;${fam.strainFamilyName}</td>
	<c:set var="startColumn" value="3"/>
	<c:if test="${not empty organKey}">
	<c:set var="startColumn" value="4"/>
	</c:if>
	<c:forEach var="i" begin="${startColumn}" end="${totalColumns}">
	<td bgcolor="#ffffff"></td>
	</c:forEach>
</tr>
</c:forEach>
</c:otherwise>
</c:choose>
</c:forEach>
</table>
</c:when>
<c:otherwise>
No data!
</c:otherwise>
</c:choose>
</c:catch>
<c:if test="${not empty exception}">
</tr>
</table>
<pre>
	<!--
	<c:out value="${exception}"/>
	An error occurred <c:out value="${exception.message}"/>
	<!-- \n -->
	Stacktrace: 
	<!-- \n -->
	<%		
	Throwable t = (Throwable)pageContext.getAttribute("exception");
	t.printStackTrace(new java.io.PrintWriter(out));
	%>
	//-->
</pre>
</c:if>
<hr><a NAME="legend"></a><strong>Legend</strong>
<ul>
	<li>
		"Very High" - includes frequencies reported in the literature as being between
	&gt;80% and 100% as well as frequnecies reported to be "very high"</li>
	<li>
		"High" - includes frequencies reported in the literature as being between
	&gt;50% and 80% as well as frequencies reported to be "high"</li>
	<li>
		"Moderate" - includes frequencies reported in the literature as being between
	&gt;20% and 50% as well as frequencies reported to be "moderate"</li>
	<li>
		"Low" - includes frequencies reported in the literature as being between
	&gt;10% and 20% as well as frequencies reported to be "low"</li>
	<li>
		"Very Low" - includes frequencies reported in the literature as being between
		&gt;0% and 10% as well as frequencies reported to be "sporadic" and "very
	low"</li>
	<li>
		"Observed" - the literature reported that tumors were observed but the
	authors did not indicate frequency</li>
	<li>
	"Zero" - the literature reported that no tumors were observed</li>
	<li>
	&nbsp;empty cell - no data in MMHCdb</li>
</ul>
<hr><strong>Notes</strong>
<ul>
	<li>
		The colors of the cells are based on the highest reported frequency for
	each strain family/organ or organ system combination.</li>
	<li>
		The strain families used in this grid are grouped according to the mouse
		strain genealogy published in Beck JA, Lloyd S, Hafezparast M, Lennon-Pierce
		M, Eppig JT, Festing MFW, Fisher EMC. 2000. Nature Genetics 24: 23-25.
		The strain genealogy chart from that reference may be accessed via <a href="http://www.informatics.jax.org/mgihome/genealogy/">http://www.informatics.jax.org/mgihome/genealogy/</a>.</li>
	<li>
		Most of the above strains are projected to be used in the Mouse Phenome
		Project (<a href="http://link.springer-ny.com/link/service/journals/00335/bibs/0011009/00110715.html">Paigen
		K, Eppig JT. 2000. Mamm Genome 11(9):715-7</a>). The exceptions are DBA/1,
	NZO, and RIII.</li>
</ul>
<!-- ////  End Detail Section  //// -->
</jax:mmhcpage>

