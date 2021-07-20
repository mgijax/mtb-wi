<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean" %> 
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic" %> 
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Tumor Frequency Grid" subtitle="Inbred Strain Family &times; Organ">
<jsp:attribute name="head">
	<script type="text/javascript">
		function checkChecks(){
			var checked = false;
			try{
				if(document.DynamicGridForm.organChk.checked){
					checked = true;
				}
			}catch(err){}
			try{
				for(i=0; i < document.DynamicGridForm.organChk.length; i++){
					if(document.DynamicGridForm.organChk[i].checked){
						checked = true;	 
					}
				}
			}catch(err){}
			if(!checked){
				toggleOrgans();
			}
			checked = false;
			try{
				if(document.DynamicGridForm.strainChk !== null){
					for(i=0; i < document.DynamicGridForm.strainChk.length; i++){
						if(document.DynamicGridForm.strainChk[i].checked){
							checked = true;
						}
					}
				}
			}catch(err){}
			try{
				if(document.DynamicGridForm.strainChk.length === null){
					if(document.DynamicGridForm.strainChk.checked){
						checked = true;
					}
				}
			}catch(err){}
			try{
				if(document.DynamicGridForm.strainFamilyChk !== null){
					for(i=0; i < document.DynamicGridForm.strainFamilyChk.length; i++){
						if(document.DynamicGridForm.strainFamilyChk[i].checked){
							checked = true;
						}
					}
				}
			}catch(err){}
			try{		
				if(document.DynamicGridForm.strainFamilyChk.length == null){
					if(document.DynamicGridForm.strainFamilyChk.checked){
						checked = true;
					}
				}
			}catch(err){} 
			if(!checked){
				toggleStrains();
			}
			document.DynamicGridForm.submit();	
		}
		function toggleOrgans(){
			for(i=0; i < document.DynamicGridForm.organChk.length; i++){
				document.DynamicGridForm.organChk[i].checked= !document.DynamicGridForm.organChk[i].checked;
			}
			if(document.DynamicGridForm.organChk.length == null){
				document.DynamicGridForm.organChk.checked= !document.DynamicGridForm.organChk.checked;
			}
		}
		function toggleStrains(){
			if(document.DynamicGridForm.strainChk != null){
				for(i=0; i < document.DynamicGridForm.strainChk.length; i++){
					document.DynamicGridForm.strainChk[i].checked= !document.DynamicGridForm.strainChk[i].checked;
				}
				if(document.DynamicGridForm.strainChk.length == null){
					document.DynamicGridForm.strainChk.checked= !document.DynamicGridForm.strainChk.checked;
				}
			}
			if(document.DynamicGridForm.strainFamilyChk != null){
				for(i=0; i < document.DynamicGridForm.strainFamilyChk.length; i++){
					document.DynamicGridForm.strainFamilyChk[i].checked= !document.DynamicGridForm.strainFamilyChk[i].checked;
				}
				if(document.DynamicGridForm.strainFamilyChk.length == null){
					document.DynamicGridForm.strainFamilyChk.checked= !document.DynamicGridForm.strainFamilyChk.checked;
				}
			} 
		}
		function hideChecks(){
			if(document.DynamicGridForm.strainChk != null){
				if(document.DynamicGridForm.strainChk.length != null){
					for(i=0; i < document.DynamicGridForm.strainChk.length; i++){
						if(document.DynamicGridForm.strainChk[i].style.display!="none"){
							document.DynamicGridForm.strainChk[i].style.display="none";
						}else{
							document.DynamicGridForm.strainChk[i].style.display="inline";
						}
					}
				}else{
					if(document.DynamicGridForm.strainChk.style.display!="none"){
						document.DynamicGridForm.strainChk.style.display="none";
					}else{
						document.DynamicGridForm.strainChk.style.display="inline";
					}
				}
			}
			for(i=0; i < document.DynamicGridForm.organChk.length; i++){
				if(document.DynamicGridForm.organChk[i].style.display!="none"){
					document.DynamicGridForm.organChk[i].style.display="none";
				}else{
					document.DynamicGridForm.organChk[i].style.display="inline";
				}
			}
			if(document.DynamicGridForm.organChk.length == null){
				if(document.DynamicGridForm.organChk.style.display!="none"){
					document.DynamicGridForm.organChk.style.display="none";
				}else{
					document.DynamicGridForm.organChk.style.display="inline";
				}
			}
			if(document.DynamicGridForm.strainFamilyChk != null){
				if(document.DynamicGridForm.strainFamilyChk.length != null){	 
					for(i=0; i < document.DynamicGridForm.strainFamilyChk.length; i++){
						if(document.DynamicGridForm.strainFamilyChk[i].style.display!="none"){
							document.DynamicGridForm.strainFamilyChk[i].style.display="none";
						}else{
							document.DynamicGridForm.strainFamilyChk[i].style.display="inline";
						}
					}
				}else{
					if(document.DynamicGridForm.strainFamilyChk.style.display!="none"){
						document.DynamicGridForm.strainFamilyChk.style.display="none";
					}else{
						document.DynamicGridForm.strainFamilyChk.style.display="inline";
					}
				}
			}
		}
	</script>
	
</jsp:attribute>
<jsp:body>




<section id="summary">
	<div class="container">	
		<p>Clicking in a colored box will take you to a summary of the records for
		spontaneous tumors of that organ or organ system observed in inbred mice
		of the corresponding strain family and reported in the literature.	<strong>The data
			represented in the grid is dynamically generated and reflects the most recent 
		data available in the MTB system.</strong>
		The records will be sorted based on the highest reported frequency. This
		summary, in turn, is linked to more detailed information about each of
		the reported tumors.</p>
		<p>Additional information associated with a colored cell will be displayed
			in a popup window of your web browser when you hold your mouse over the
			cell. <em>(Requires JavaScript support.)</em></p>
	</div>
</section>
<section id="detail" style>
    
     <html:form action="dynamicGrid" method="GET">
            <c:set var="rowSpan" value="0"/>
            <c:set var="totalColumns" value="2"/>
            <c:set var="strainName" value=""/>
            <c:set var="organName" value=""/>
            <input type="hidden" name="expandColapse" value ="false">
            <input type="hidden" name="whichGrid" value="two">
    <c:choose>
            <c:when test="${not empty anatomicalSystems}">
    <table style="width:100%">
        <tr align="center">
            
        <td>  
            <table class="grid" style="width:auto">
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
                            <c:forEach var="anatomicalSystem" items="${anatomicalSystems}" varStatus="status">
                            <c:set var="colspan" value="${fn:length(anatomicalSystem.organs)}"/>
                            <c:forEach var="organParent" items="${anatomicalSystem.organs}" varStatus="status">
                            <c:set var="colspan" value="${fn:length(organParent.organs) + colspan - 1}"/>
                            </c:forEach>
                            <th colspan="${colspan}"><img src="dynamicText?text=${anatomicalSystem.anatomicalSystemName}&amp;size=10" alt="X">
                                    <!-- \n -->
                            <img src="${applicationScope.urlImageDir}/grid/grid_spacer.png" alt=" "></th>
                            </c:forEach>
                    </tr>
                    <tr class="grid">
                            <c:forEach var="anatomicalSystem" items="${anatomicalSystems}" varStatus="status">
                            <c:forEach var="organParent" items="${anatomicalSystem.organs}" varStatus="status">
                            <c:forEach var="organ" items="${organParent.organs}" varStatus="status">
                            <c:set var="totalColumns" value="${totalColumns + 1}"/> 
                            <th>
                                    <img src="${applicationScope.urlImageDir}/grid/${organ.organKey}.png" alt="X">
                                    <!-- \n -->
                                    <img src="${applicationScope.urlImageDir}/grid/grid_spacer.png">
                                    <!-- \n -->
                                    <img src="${applicationScope.urlImageDir}/grid/grid_spacer.png" alt=" ">
                                    <!-- \n -->
                                    <input type ="checkbox" name="organChk" value="${organ.organKey}" >
                            </th>
                            </c:forEach>
                            </c:forEach>
                            </c:forEach>
                    </tr>
                    <!-- ////  END HEADER  //// -->
                    <c:forEach var="rowHeredity" items="${strains}" varStatus="status1">
                    <tr style="background-color:black; height:1px">
                            <td colspan="${totalColumns}" style='border:solid 1px #000000; height:1px;'></td>
                    </tr>
                    <tr class="grid">
                            <c:set var="heredityGrid" value =""/>
                            <c:set var="heredityAll" value =""/>
                            <c:set var="familyGrid" value =""/>
                            <c:set var="familyAll" value =""/>
                            <%--Getting heredity...for ${rowHeredity.strainHeredityName}
                            <!-- \n -->
                            --%>
                            <%--Figure out how many rows each Heredity label needs to span
                            If all strains are displayed count all the strains for each family
                            otherwise just count the selected strains for each family
                            --%>
                            <c:forEach var="heredityItem" items="${gridData}" varStatus="status2">
                            <c:if test="${empty heredityGrid}">
                            <c:if test="${heredityItem.value.strainHeredityKey == rowHeredity.strainHeredityKey}">
                            <c:set var="heredityGrid" value="${heredityItem.value}"/>
                            <c:set var="heredityAll" value="${rowHeredity}"/>
                            </c:if>
                            </c:if>
                            </c:forEach>
                            <c:set var="rowSpan" value="${fn:length(rowHeredity.families)}"/>
                            <c:if test="${not empty heredityGrid}">
                            <c:choose>
                            <c:when test="${not empty showAllStrains}">
                            <c:forEach var="fam" items="${heredityAll.families}" varStatus="status3">
                            <c:set var="rowSpan" value="${fn:length(fam.strains) + rowSpan}"/>	
                            </c:forEach>
                            </c:when>
                            <c:otherwise>
                            <c:forEach var="fam" items="${heredityAll.families}" varStatus="status3">
                            <c:forEach var="st" items="${fam.strains}">
                            <c:forEach var="checkStrain" items="${strainChk}">
                            <c:if test="${st.strainKey == checkStrain}">
                            <c:set var="rowSpan" value="${rowSpan + 1}"/>	
                            </c:if>
                            </c:forEach>
                            </c:forEach>
                            </c:forEach>
                            </c:otherwise>
                            </c:choose>
                            <%-- else need to add only fam.strains that have been selected --%>
                            </c:if>
                            <td class="grid" rowspan="${rowSpan}">
                                    <img src="${applicationScope.urlImageDir}/grid/sh${rowHeredity.strainHeredityKey}.png" alt="${rowHeredity.strainHeredityName}">
                            <img src="${applicationScope.urlImageDir}/grid/grid_spacer.png" alt=" "></td>
                            <%--Done Heredity!
                            <!-- \n -->
                            --%>
                            <c:choose>
                            <c:when test="${not empty heredityGrid}">
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
                                    <c:set var="familyGrid" value="${familyItem.value}"/>
                                    <c:set var="familyAll" value="${fam}"/>
                                    </c:if>
                                    </c:forEach>
                                    <c:choose>
                                    <c:when test="${not empty familyGrid}">
                                    <c:forEach var="strainFam" items="${strainFamilyChk}" >
                                    <c:if test="${strainFam == familyGrid.strainFamilyKey}">
                                    <%-- DETERMINE STRAIN FAMILY IMAGE EXPANDED OR COLLAPSED --%>
                                    <td class="grid"> 
                                            <span style="white-space:nowrap">
                                                    &nbsp;${familyGrid.strainFamilyName} (Summary)<html:multibox property="strainFamilyChk" value="${familyGrid.strainFamilyKey}" />
                                            </span>
                                    </td>
                                    <%-- DETERMINE IF WE HAVE EXPANDED STRAINS OR NOT --%>
                                    <%----------------------------------- START Strain Family and expanded Strains ---------------------------%>
                                    <%----------------------------------- START Strain Family ------------------------------------------------%>																											 
                                    <c:forEach var="anatomicalSystem" items="${anatomicalSystems}" varStatus="status">
                                    <c:forEach var="organParent" items="${anatomicalSystem.organs}" varStatus="status">
                                    <c:set var="organ" value=""/>
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
                                    <c:set var="tdOut" value="<img src='${applicationScope.urlImageDir}/grid/${organ.frequencyDetail.descriptionHighest}.png' alt='H' height='100%'>" />
                                    </c:otherwise>
                                    </c:choose>
                                    <td><a href="tumorSearchResults.do?grid=1&amp;strainFamilyKey=${familyGrid.strainFamilyKey}&amp;organKey=${organ.organKey}" class="tip">${tdOut}<div role="tooltip"><table class="gridDetails"><tr><td class="gridDetails">Strain Family:</td><td class="gridDetails">${familyGrid.strainFamilyName}</td></tr><tr><td class="gridDetails">Organ:</td><td class="gridDetails">${organ.organName}</td></tr><tr><td class="gridDetails">Highest reported tumor frequency:</td><td class="gridDetails">${organ.frequencyDetail.longDescriptionHighest}</td></tr><tr><td class="gridDetails"># Tumor Frequency Records:</td><td class="gridDetails">${organ.frequencyDetail.count}</td></tr></table></div></a></td>
    </c:when>
    <c:otherwise>
    <td></td>
    </c:otherwise>
    </c:choose>
    <c:set var="organ" value=""/>
    </c:forEach>
    </c:forEach>
    </c:forEach>
    </tr>
    </c:if>
    </c:forEach>
    <c:set var="theStrain" value=""/>
    <c:forEach var="strainCat" items="${familyAll.strains}" varStatus="status2000">
    <c:set var="showStrain" value=""/>
    <c:if test="${not empty showAllStrains}">
    <c:set var="showStrain" value="true"/>
    </c:if>
    <c:forEach var="selectStrain" items="${strainChk}">
    <c:if test="${selectStrain == strainCat.strainKey}" >
    <c:set var="showStrain" value="true"/>
    </c:if>
    </c:forEach>
    <c:if test="${not empty showStrain}" > 
    <c:set var="theStrain" value=""/>
    <c:forEach var="strainItem" items="${familyGrid.strains}" varStatus="status2001">
    <c:if test="${strainCat.strainKey == strainItem.value.strainKey}">
    <c:set var="theStrain" value="${strainItem.value}"/>
    </c:if>
    </c:forEach>
    <tr class="grid">
            <td class="grid" >
                    <span style="white-space:nowrap">
                            <c:out value="${strainCat.strainName}" escapeXml="false"/>
                            <input type="checkbox" name="strainChk" value="${strainCat.strainKey}" >
                    </span>
            </td>
            <c:choose>
            <c:when test="${not empty theStrain}">
            <c:forEach var="anatomicalSystem" items="${anatomicalSystems}" varStatus="status">
            <c:forEach var="organParent" items="${anatomicalSystem.organs}" varStatus="status">
            <c:set var="organ" value=""/>
            <%-- ------------ LOOP THROUGH SUB ORGANS ------------------
            <!-- \n -->
            --%>
            <c:forEach var="subOrgan" items="${organParent.organs}" varStatus="status">
            <%-- SUBORGAN NAME: ${subOrgan.organName}
            <!-- \n -->
            --%>
            <c:set var="organ" value=""/>
            <c:forEach var="organItem" items="${theStrain.organs}" varStatus="status">
            <c:forEach var="subOrganItem" items="${organItem.value.organs}" varStatus="status">
            <c:if test="${subOrgan.organKey == subOrganItem.value.organKey}">
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
            <c:set var="tdOut" value="<img src='${applicationScope.urlImageDir}/grid/${organ.frequencyDetail.descriptionHighest}.png' alt='H' height='100%'>"/>
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
    </c:forEach>
    </c:forEach>
    </c:when>
    <c:otherwise>
    <%--We <strong>DO NOT</strong> have a strain value...dump out a row of empty values.
    <!-- \n -->
    --%>
    <c:set var="startColumn" value="3"/>
    <c:forEach var="i" begin="${startColumn}" end="${totalColumns}">
    <td bgcolor="#ffffff"></td>
    </c:forEach>
    </c:otherwise>
    </c:choose>
    </tr>
    </c:if>
    </c:forEach>
    </c:when>
    <c:otherwise>
    <%--We <strong>DO NOT</strong> have a family value...dump out a row of empty values.
    <!-- \n -->
    --%>
    <td class="grid"><img src="${applicationScope.urlImageDir}/grid/grid_spacer.png" alt=" ">&nbsp;${fam.strainFamilyName}</td>
    <c:set var="startColumn" value="4"/>
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
            <td class="grid" bgcolor="#ffffff">
                    <img src="${applicationScope.urlImageDir}/grid/grid_spacer.png" alt=" ">&nbsp;${fam.strainFamilyName}
            </td>
            <c:set var="startColumn" value="4"/> 
            <c:forEach var="i" begin="${startColumn}" end="${totalColumns}">
            <td bgcolor="#ffffff"></td>
            </c:forEach>
    </tr>	 
    </c:forEach>
    </c:otherwise>
    </c:choose>
    </c:forEach>
        </table>
                </td>
            </tr>
            <tr align="center"><td>
        <input type="button" value="Generate Grid" onClick="javascrpt: checkChecks();" >
        <input type="button" value="Invert Selected Organs" onClick="javascript: toggleOrgans()">
        <input type="button" value="Invert Selected Strains" onClick="javascript: toggleStrains()">
        <input type="button" value="hide/show checkboxes" onClick="javascript: hideChecks()">
         </td>
    </tr>
    </table>
    </c:when>
    <c:otherwise>
    <h2> <strong> ${message} </strong> </h2>
    </c:otherwise>
    </c:choose>
    </html:form>
   

<div class="container">
	
<a NAME="legend"></a><strong>Legend</strong>	
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
	&nbsp;empty cell - no data in MTB</li>
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
</div>
</section>
</jsp:body>
</jax:mmhcpage>

