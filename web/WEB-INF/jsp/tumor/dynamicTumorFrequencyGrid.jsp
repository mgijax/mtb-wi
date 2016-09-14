<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean" %> 
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic" %> 
<%@ taglib uri="http://tumor.informatics.jax.org/mtbwi/MTBWebUtils" prefix="wu" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
  <head>
    <c:import url="../../../meta.jsp">
      <c:param name="pageTitle" value="Tumor Frequency Grid"/>
    </c:import>
    
    
  </head>
  
  <c:import url="../../../body.jsp">
    <c:param name="pageTitle" value="Tumor Frequency Grid"/>
  </c:import>
  
  <script language="JavaScript"  >
    
    function checkChecks(){
      var selected = false;
      
      for(i=0; i < document.DynamicGridForm.organGrpChk.length; i++){
        if(document.DynamicGridForm.organGrpChk[i].checked){
          selected = true;
        }
      }
      
      if(!selected){
       
       toggleOrgans();
       
      }
      
      selected = false;
      
      
      for(i=0; i < document.DynamicGridForm.strainFamilyChk.length; i++){
        if(document.DynamicGridForm.strainFamilyChk[i].checked){
          selected = true;
        }
          
      }
      
      if(!selected){
       
       toggleStrains();
          
        
      }
      
      document.DynamicGridForm.submit();
    }
    
    
    function submitFormOrgan(organKey){
  
      document.DynamicGridForm.currentStrainFamilyKey.value = '';
      document.DynamicGridForm.currentOrganKey.value=organKey;
      
      document.DynamicGridForm.expandColapse.value = "true";

      document.DynamicGridForm.submit();
      
    }
    
    function submitFormStrain(strainFamilyKey){
     
      document.DynamicGridForm.currentStrainFamilyKey.value = strainFamilyKey;
      document.DynamicGridForm.currentOrganKey.value = '';
      
      document.DynamicGridForm.expandColapse.value = "true";

      document.DynamicGridForm.submit();
      
    }
    
    function toggleOrgans(){
      for(i=0; i < document.DynamicGridForm.organGrpChk.length; i++){
        document.DynamicGridForm.organGrpChk[i].checked= !document.DynamicGridForm.organGrpChk[i].checked;
      }
    }
    
    function toggleStrains(){
      for(i=0; i < document.DynamicGridForm.strainFamilyChk.length; i++){
        document.DynamicGridForm.strainFamilyChk[i].checked= !document.DynamicGridForm.strainFamilyChk[i].checked;
      }
    }
    
    function hideChecks(){
      for(i=0; i < document.DynamicGridForm.strainFamilyChk.length; i++){
        if(document.DynamicGridForm.strainFamilyChk[i].style.display!="none"){
          document.DynamicGridForm.strainFamilyChk[i].style.display="none";
        }else{
          document.DynamicGridForm.strainFamilyChk[i].style.display="inline";
        }
      }
      
      for(i=0; i < document.DynamicGridForm.organGrpChk.length; i++){
        if(document.DynamicGridForm.organGrpChk[i].style.display!="none"){
          document.DynamicGridForm.organGrpChk[i].style.display="none";
        }else{
          document.DynamicGridForm.organGrpChk[i].style.display="inline";
        }
      }
    }
    
  </script>
  
  <table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr>
      <td width="200" valign="top">
        <c:import url="../../../toolBar.jsp"/>
      </td>
      <td class="separator">
        &nbsp;
      </td>
      <td valign="top">
      <table width="95%" align="center" border="0" cellspacing="1" cellpadding="4">
      <tr>
        <td>
        <!--======================= Start Main Section =============================-->
        <!--======================= Start Form Header ==============================-->
        <table border="0" cellpadding=5 cellspacing=1 width="100%" class="results">
          <tr class="pageTitle">
            <td colspan="2" width="100%">
              <table width="100%" border=0 cellpadding=0 cellspacing=0>
                <tr>
                  <td width="20%" valign="middle" align="left">
                    <a class="help" href="userHelp.jsp#dynamicgrid"><img src="${applicationScope.urlImageDir}/help_large.png" border=0 width=32 height=32 alt="Help"></a>
                  </td>
                  <td width="60%" class="pageTitle">
                    Dynamic Tumor Frequency Grid
                  </td>
                  <td width="20%" valign="middle" align="center">&nbsp;</td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
        <!--======================= End Form Header ================================-->
<!--======================= Start Detail Section ===========================-->

        <font class="larger">Tumor Frequency Grid (Inbred Strain Family x Organ)</font>
        <br><br>
        Clicking in a colored box will take you to a summary of the records for
        spontaneous tumors of that organ or organ system observed in inbred mice
        of the corresponding strain family and reported in the literature.  <b>The data
          represented in the grid is dynamically generated and reflects the most recent 
        data available in the MTB system.</b>
        The records will be sorted based on the highest reported frequency. This
        summary, in turn, is linked to more detailed information about each of
        the reported tumors.
        <p>Additional information associated with a colored cell will be displayed
        in a popup window of your web browser when you hold your mouse over the
        cell. <i>(Requires JavaScript support.)</i>
        <br>
        <hr>
        
        <c:set var="rowSpan" value="0"/>
        <c:set var="totalColumns" value="2"/>
        <c:set var="strainName" value=""/>
        <c:set var="organName" value=""/>
        <c:catch var="exception">
        <c:choose>
          <c:when test="${not empty anatomicalSystems}">
            <html:form action="dynamicGrid" method="GET">
            <input type="hidden" name="organKey" value="${organKey}"/>
            <input type="hidden" name="currentOrganKey" value="${organKey}" />
            <input type="hidden" name="strainFamilyKey" value="${strainFamilyKey}" />
            <input type="hidden" name="currentStrainFamilyKey" value="${strainFamilyKey}" />
            <input type="hidden" name="expandColapse" value="false" />
            
            <table class="grid" cellpadding="0" cellspacing="0">
            <!--======================= START HEADER ===============================-->
            <tr class="grid">
              <td colspan="2" rowspan="2" align="center">
                <table border="0">
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
                      <c:set var ="compy" value="|${organParent.organKey}|" />
                      <c:if test="${fn:contains(organKey, compy)}">
                        <c:set var="colspan" value="${fn:length(organParent.organs) + colspan - 1}"/>
                      </c:if>
                    </c:forEach>
                    <th colspan="${colspan}"><img src="dynamicText?text=${anatomicalSystem.anatomicalSystemName}&amp;size=10" alt="X"><br><img src="${applicationScope.urlImageDir}/grid/grid_spacer.png" alt=" "></th>
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
                  <c:set var ="compy" value="|${organParent.organKey}|" />
                  <c:choose>
                    <c:when test="${not empty organKey}">
                      <c:choose>
                        <c:when test="${fn:contains(organKey, compy)}">
                          <c:forEach var="organ" items="${organParent.organs}" varStatus="status">
                            <c:set var="totalColumns" value="${totalColumns + 1}"/>
                            <c:set var="compy" value="|${organ.organKey}|"/>
                            <c:choose>
                              <c:when test="${fn:contains(organKey, compy) }">
                                
                                
                                <th><a href="javascript: submitFormOrgan(${organ.organKey})"><img src="${applicationScope.urlImageDir}/grid/${organParent.organKey}.png" border="0" alt="X"></a><br><a href="javascript: submitFormOrgan(${organParent.organKey})"><img src="${applicationScope.urlImageDir}/grid/grid_col_top.png" border="0" alt="-"></a><br><html:multibox property="organGrpChk" value="${organParent.organKey}" /></th>
                              </c:when>
                              <c:otherwise>
                                <th><img src="${applicationScope.urlImageDir}/grid/${organ.organKey}.png" border="0" alt="X"><br><img src="${applicationScope.urlImageDir}/grid/grid_spacer.png" border="0"><br><img src="${applicationScope.urlImageDir}/grid/grid_spacer.png" border="0" alt=" "><br></th>
                              </c:otherwise>
                            </c:choose>
                          </c:forEach>
                        </c:when>
                        <c:otherwise>
                          
                          <c:choose>
                            <c:when test="${fn:length(organParent.organs) == 1}">
                              <th><img src="${applicationScope.urlImageDir}/grid/${organParent.organKey}.png" border="0" alt="X"><br><img src="${applicationScope.urlImageDir}/grid/grid_spacer.png" border="0" alt=" "><br><html:multibox property="organGrpChk" value="${organParent.organKey}" /></th>
                            </c:when>
                            <c:otherwise>
                              <th><a href="javascript: submitFormOrgan(${organParent.organKey})"><img src="${applicationScope.urlImageDir}/grid/${organParent.organKey}.png" border="0" alt="X"></a><br><a href="javascript: submitFormOrgan(${organParent.organKey})"><img src="${applicationScope.urlImageDir}/grid/grid_exp_top.png" border="0" alt="+"></a><br><html:multibox property="organGrpChk" value="${organParent.organKey}" /></th>
                            </c:otherwise>
                          </c:choose>
                        </c:otherwise>
                      </c:choose>
                    </c:when>
                    <c:otherwise>
                      
                      <c:choose>
                        <c:when test="${fn:length(organParent.organs) == 1}">
                          <th valign="bottom"><img src="${applicationScope.urlImageDir}/grid/${organParent.organKey}.png" border="0" alt="X"><br><img src="${applicationScope.urlImageDir}/grid/grid_spacer.png" border="0" alt=" "><html:multibox property="organGrpChk" value="${organParent.organKey}" /></th>
                        </c:when>
                        <c:otherwise>
                          <th valign="bottom"><a href="javascript: submitFormOrgan(${organParent.organKey})"><img src="${applicationScope.urlImageDir}/grid/${organParent.organKey}.png" border="0" alt="X"></a><br><a href="javascript: submitFormOrgan(${organParent.organKey})"><img src="${applicationScope.urlImageDir}/grid/grid_exp_top.png" border="0" alt="+"></a><html:multibox property="organGrpChk" value="${organParent.organKey}" /></th>
                        </c:otherwise>
                      </c:choose>
                    </c:otherwise>
                  </c:choose>
                </c:forEach>
              </c:forEach>
            </tr>
            <!--======================= END HEADER ===============================-->
            <c:forEach var="rowHeredity" items="${strains}" varStatus="status1">
            <tr style="background-color:black; height:1px"><td colspan="${totalColumns}" style='border:solid 1px #000000; height:1px;'></td></tr>
            <tr class="grid">
              <c:set var="heredityGrid" value =""/>
              <c:set var="heredityAll" value =""/>
              <c:set var="familyGrid" value =""/>
              <c:set var="familyAll" value =""/>
              <%--Getting heredity...for ${rowHeredity.strainHeredityName}<br>--%>
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
                <c:if test="${not empty strainFamilyKey}">
                  <c:forEach var="fam" items="${heredityAll.families}" varStatus="status3">
                    <c:set var="SFToken" value="|${fam.strainFamilyKey}|"/>
                    <c:if test="${fn:contains(strainFamilyKey,SFToken)}">
                      <c:set var="rowSpan" value="${fn:length(fam.strains) + rowSpan}"/>
                    </c:if>
                  </c:forEach>
                </c:if>
              </c:if>
              <td class="grid" align="right" valign="middle" rowspan="${rowSpan}"><img src="${applicationScope.urlImageDir}/grid/sh${rowHeredity.strainHeredityKey}.png" alt="${rowHeredity.strainHeredityName}"><img src="${applicationScope.urlImageDir}/grid/grid_spacer.png" alt=" "></td>
              <%--Done Heredity!<br>--%>
              <c:choose>
              <c:when test="${not empty heredityGrid}">
              <%--
                            We have a heredity value. <b>${heredityGrid.strainHeredityName}</b><br>
                            Getting family...<br>
              --%>
              <c:forEach var="fam" items="${heredityAll.families}" varStatus="status3">
              <c:set var="familyGrid" value =""/>
              <c:set var="familyAll" value =""/>
              <c:set var="SFToken" value="|${fam.strainFamilyKey}|"/>
              <c:if test="${!status3.first}">
                <tr class="grid">
              </c:if>
              <c:forEach var="familyItem" items="${heredityGrid.strainFamilies}" varStatus="status3">
                <%--===> looking for ${fam.strainFamilyName}<br>--%>
                <c:if test="${familyItem.value.strainFamilyKey == fam.strainFamilyKey}">
                  
                  
                  <c:set var="familyGrid" value="${familyItem.value}"/>
                  <c:set var="familyAll" value="${fam}"/>
                </c:if>
              </c:forEach>
              <c:choose>
              <c:when test="${not empty familyGrid}">
              
              
              <%-- DETERMINE STRAIN FAMILY IMAGE EXPANDED OR COLLAPSED --%>
              <c:choose>
                <c:when test="${not empty strainFamilyKey}">
                  <c:choose>
                    <c:when test="${fn:contains(strainFamilyKey,SFToken)}">
                      
                      
                      <td class="grid" align="right"> <span style="white-space:nowrap"><a href="javascript: submitFormStrain(${familyGrid.strainFamilyKey})"><img src="${applicationScope.urlImageDir}/grid/grid_col_left.png" border="0" alt="-"></a>&nbsp;${familyGrid.strainFamilyName} (Summary)<html:multibox property="strainFamilyChk" value="${familyGrid.strainFamilyKey}" /></span></td>
                    </c:when>
                    <c:otherwise>
                      
                      
                      <td class="grid" align="right"> <span style="white-space:nowrap"><a href="javascript: submitFormStrain(${familyGrid.strainFamilyKey})"><img src="${applicationScope.urlImageDir}/grid/grid_exp_left.png" border="0" alt="+"></a>&nbsp;${familyGrid.strainFamilyName}<html:multibox property="strainFamilyChk" value="${familyGrid.strainFamilyKey}" /></span></td>
                    </c:otherwise>
                  </c:choose>
                </c:when>
                <c:otherwise>
                  
                  
                  <td class="grid" align="right"><span style="white-space:nowrap"><a href="javascript: submitFormStrain(${familyGrid.strainFamilyKey})"><img src="${applicationScope.urlImageDir}/grid/grid_exp_left.png" border="0" alt="+"></a>&nbsp;${familyGrid.strainFamilyName}<html:multibox property="strainFamilyChk" value="${familyGrid.strainFamilyKey}" /></span></td>
                </c:otherwise>
              </c:choose>
              <%-- DETERMINE IF WE HAVE EXPANDED STRAINS OR NOT --%>
              <c:choose>
              <c:when test="${not empty strainFamilyKey}">
              <%----------------------------------- START Strains are expanded -----------------------------------------%>
              <%-- <h2>Strains are expanded!!!</h2> --%>
              <c:choose>
              <c:when test="${fn:contains(strainFamilyKey,SFToken)}">
              <%----------------------------------- START Strain Family and expanded Strains ---------------------------%>
              <%----------------------------------- START Strain Family ------------------------------------------------%>                                                       
              <c:forEach var="anatomicalSystem" items="${anatomicalSystems}" varStatus="status">
                <c:forEach var="organParent" items="${anatomicalSystem.organs}" varStatus="status">
                  <c:set var="organ" value=""/>
                  <c:set var="compy" value="|${organParent.organKey}|" />
                  <c:choose>
                    <c:when test="${not empty organKey}">
                      
                      
                      <c:choose>
                        <c:when test="${fn:contains(organKey,compy)}">
                          <%-- ------------ LOOP THROUGH SUB ORGANS ------------------<br> --%>
                          <c:forEach var="subOrgan" items="${organParent.organs}" varStatus="status">
                            <%-- SUBORGAN NAME: ${subOrgan.organName}<br> --%>
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
                                    <c:set var="tdOut" value="<img src='${applicationScope.urlImageDir}/grid/${organ.frequencyDetail.descriptionHighest}.png' border='0' alt='-' ' width='100%' height='100%'>"/>
                                  </c:otherwise>
                                </c:choose>
                                
                                
                                <td align="center"><a href="tumorSearchResults.do?grid=1&amp;strainFamilyKey=${familyGrid.strainFamilyKey}&amp;organKey=${organ.organKey}" style="text-decoration: none; cursor:help;" onmouseover="return overlib('<table class=\'gridDetails\' border=0><tr><td class=\'gridDetails\'>Strain Family:</td><td class=\'gridDetails\'>${familyGrid.strainFamilyName}</td></tr><tr><td class=\'gridDetails\'>Organ:</td><td class=\'gridDetails\'>${organ.organName}</td></tr><tr><td class=\'gridDetails\'>Highest reported tumor frequency:</td><td class=\'gridDetails\'>${organ.frequencyDetail.longDescriptionHighest}</td></tr><tr><td class=\'gridDetails\'># Tumor Frequency Records:</td><td class=\'gridDetails\'>${organ.frequencyDetail.count}</td></tr></table>');" onmouseout="return nd();">${tdOut}</a></td>
                              </c:when>
                              <c:otherwise>
                                <td>&nbsp;</td>
                              </c:otherwise>
                            </c:choose>
                            <c:set var="organ" value=""/>
                          </c:forEach>
                        </c:when>
                        <c:otherwise>
                          <%-- ------------ LOOP THROUGH PARENT ORGANS------------------<br> --%>
                          <c:forEach var="organItem" items="${familyGrid.organs}" varStatus="status4">
                            <c:if test="${organParent.organKey == organItem.value.organKey}">
                              
                              
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
                                  <c:set var="tdOut" value="<img src='${applicationScope.urlImageDir}/grid/${organ.frequencyDetail.descriptionHighest}.png' border='0' alt='-' width='100%' height='100%'> "/>
                                </c:otherwise>
                              </c:choose>
                              <td align="center"><a href="tumorSearchResults.do?grid=1&strainFamilyKey=${familyGrid.strainFamilyKey}&amp;organParentKey=${organ.organKey}" style="text-decoration: none; cursor:help;" onmouseover="return overlib('<table class=\'gridDetails\' border=0><tr><td class=\'gridDetails\'>Strain Family:</td><td class=\'gridDetails\'>${familyGrid.strainFamilyName}</td></tr><tr><td class=\'gridDetails\'>Organ:</td><td class=\'gridDetails\'>${organ.organName}</td></tr><tr><td class=\'gridDetails\'>Highest reported tumor frequency:</td><td class=\'gridDetails\'>${organ.frequencyDetail.longDescriptionHighest}</td></tr><tr><td class=\'gridDetails\'># Tumor Frequency Records:</td><td class=\'gridDetails\'>${organ.frequencyDetail.count}</td></tr></table>');" onmouseout="return nd();">${tdOut}</a></td>
                            </c:when>
                            <c:otherwise>
                              <td>&nbsp;</td>
                            </c:otherwise>
                          </c:choose>
                        </c:otherwise>
                      </c:choose>
                    </c:when>
                    <c:otherwise>
                      <%-- ------------ COLLAPSED GRID ------------------<br> --%>
                      <c:forEach var="organItem" items="${familyGrid.organs}" varStatus="status4">
                        <c:if test="${organParent.organKey == organItem.value.organKey}">
                          
                          
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
                              <c:set var="tdOut" value="<img src='${applicationScope.urlImageDir}/grid/${organ.frequencyDetail.descriptionHighest}.png' border='0' alt='-' width='100%' height='100%'>" />
                            </c:otherwise>
                          </c:choose>
                          <td align="center"><a href="tumorSearchResults.do?grid=1&amp;strainFamilyKey=${familyGrid.strainFamilyKey}&amp;organParentKey=${organ.organKey}" style="text-decoration: none; cursor:help;" onmouseover="return overlib('<table class=\'gridDetails\' border=0><tr><td class=\'gridDetails\'>Strain Family:</td><td class=\'gridDetails\'>${familyGrid.strainFamilyName}</td></tr><tr><td class=\'gridDetails\'>Organ:</td><td class=\'gridDetails\'>${organ.organName}</td></tr><tr><td class=\'gridDetails\'>Highest reported tumor frequency:</td><td class=\'gridDetails\'>${organ.frequencyDetail.longDescriptionHighest}</td></tr><tr><td class=\'gridDetails\'># Tumor Frequency Records:</td><td class=\'gridDetails\'>${organ.frequencyDetail.count}</td></tr></table>');" onmouseout="return nd();">${tdOut}</a></td>
                        </c:when>
                        <c:otherwise>
                          <td>&nbsp;</td>
                        </c:otherwise>
                      </c:choose>
                    </c:otherwise>
                  </c:choose>
                </c:forEach>
              </c:forEach>
            </tr>
            <%----------------------------------- END Strain Family ------------------------------------------------%>
            <%----------------------------------- START Strain Expansion -------------------------------------------%>
            

            <c:set var="theStrain" value=""/>
            <c:forEach var="strainCat" items="${familyAll.strains}" varStatus="status2000">
              <c:set var="theStrain" value=""/>
              <c:forEach var="strainItem" items="${familyGrid.strains}" varStatus="status2001">
                <c:if test="${strainCat.strainKey == strainItem.value.strainKey}">
                  <c:set var="theStrain" value="${strainItem.value}"/>
                </c:if>
              </c:forEach>
              <tr class="grid">
                <td class="grid" align="right"><span style="white-space:nowrap"><c:out value="${strainCat.strainName}" escapeXml="false"/><img src="${applicationScope.urlImageDir}/grid/grid_spacer.png" border="0" alt=" "></span></td>
                <c:choose>
                  <c:when test="${not empty theStrain}">
                    <c:forEach var="anatomicalSystem" items="${anatomicalSystems}" varStatus="status">
                      <c:forEach var="organParent" items="${anatomicalSystem.organs}" varStatus="status">
                        <c:set var="organ" value=""/>
                        <c:set var="compy" value="|${organParent.organKey}|" />
                        <c:choose>
                          <c:when test="${not empty organKey}">
                            
                            
                            <c:choose>
                              <c:when test="${fn:contains(organKey,compy)}">
                                <%-- ------------ LOOP THROUGH SUB ORGANS ------------------<br> --%>
                                <c:forEach var="subOrgan" items="${organParent.organs}" varStatus="status">
                                  <%-- SUBORGAN NAME: ${subOrgan.organName}<br> --%>
                                  <c:set var="organ" value=""/>
                                  <c:forEach var="organItem" items="${theStrain.organs}" varStatus="status">
                                    <%-- <b>organItem = ${organItem}</b> --%>
                                    <c:forEach var="subOrganItem" items="${organItem.value.organs}" varStatus="status">
                                      <%-- TESTING ${subOrgan.organKey} TO ${subOrganItem.value.organKey}<br> --%>
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
                                          <c:set var="tdOut" value="<img src='${applicationScope.urlImageDir}/grid/${organ.frequencyDetail.descriptionHighest}.png' border='0' alt='H' width='100%' height='100%'>"/>
                                        </c:otherwise>
                                      </c:choose>
                                      <td align="center"><a href="tumorSearchResults.do?grid=1&amp;strainKey=${theStrain.strainKey}&amp;organKey=${organ.organKey}" style="text-decoration: none; cursor:help;" onmouseover="return overlib('<table class=\'gridDetails\' border=0><tr><td class=\'gridDetails\'>Strain:</td><td class=\'gridDetails\'>${theStrain.strainName}</td></tr><tr><td class=\'gridDetails\'>Organ:</td><td class=\'gridDetails\'>${organ.organName}</td></tr><tr><td class=\'gridDetails\'>Highest reported tumor frequency:</td><td class=\'gridDetails\'>${organ.frequencyDetail.longDescriptionHighest}</td></tr><tr><td class=\'gridDetails\'># Tumor Frequency Records:</td><td class=\'gridDetails\'>${organ.frequencyDetail.count}</td></tr></table>');" onmouseout="return nd();">${tdOut}</a></td>
                                    </c:when>
                                    <c:otherwise>
                                      <td>&nbsp;</td>
                                    </c:otherwise>
                                  </c:choose>
                                  <c:set var="organ" value=""/>
                                </c:forEach>
                              </c:when>
                              <c:otherwise>
                                <%-- ------------ LOOP THROUGH PARENT ORGANS------------------<br> --%>
                                <c:forEach var="organItem" items="${theStrain.organs}" varStatus="status4">
                                  <%-- <b>organ item = ${organItem}</b> --%>
                                  <c:if test="${organParent.organKey == organItem.value.organKey}">
                                    
                                    
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
                                        <c:set var="tdOut" value="<img src='${applicationScope.urlImageDir}/grid/${organ.frequencyDetail.descriptionHighest}.png' border='0' alt='H'  width='100%' height='100%'>"/>
                                      </c:otherwise>
                                    </c:choose>
                                    <td align="center"><a href="tumorSearchResults.do?grid=1&amp;strainKey=${theStrain.strainKey}&amp;organParentKey=${organ.organKey}" style="text-decoration: none; cursor:help;" onmouseover="return overlib('<table class=\'gridDetails\' border=0><tr><td class=\'gridDetails\'>Strain:</td><td class=\'gridDetails\'>${theStrain.strainName}</td></tr><tr><td class=\'gridDetails\'>Organ:</td><td class=\'gridDetails\'>${organ.organName}</td></tr><tr><td class=\'gridDetails\'>Highest reported tumor frequency:</td><td class=\'gridDetails\'>${organ.frequencyDetail.longDescriptionHighest}</td></tr><tr><td class=\'gridDetails\'># Tumor Frequency Records:</td><td class=\'gridDetails\'>${organ.frequencyDetail.count}</td></tr></table>');" onmouseout="return nd();">${tdOut}</a></td>
                                  </c:when>
                                  <c:otherwise>
                                    <td>&nbsp;</td>
                                  </c:otherwise>
                                </c:choose>
                              </c:otherwise>
                            </c:choose>
                          </c:when>
                          <c:otherwise>
                            <%-- ------------ COLLAPSED GRID ------------------<br> --%>
                            <c:forEach var="organItem" items="${theStrain.organs}" varStatus="status4">
                              <c:if test="${organParent.organKey == organItem.value.organKey}">
                                
                                
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
                                    <c:set var="tdOut" value="<img src='${applicationScope.urlImageDir}/grid/${organ.frequencyDetail.descriptionHighest}.png' border='0' alt='H'  width='100%' height='100%'>"/>
                                  </c:otherwise>
                                </c:choose>
                                <td align="center"><a href="tumorSearchResults.do?grid=1&amp;strainKey=${theStrain.strainKey}&amp;organParentKey=${organ.organKey}" style="text-decoration: none; cursor:help;" onmouseover="return overlib('<table class=\'gridDetails\' border=0><tr><td class=\'gridDetails\'>Strain:</td><td class=\'gridDetails\'>${theStrain.strainName}</td></tr><tr><td class=\'gridDetails\'>Organ:</td><td class=\'gridDetails\'>${organ.organName}</td></tr><tr><td class=\'gridDetails\'>Highest reported tumor frequency:</td><td class=\'gridDetails\'>${organ.frequencyDetail.longDescriptionHighest}</td></tr><tr><td class=\'gridDetails\'># Tumor Frequency Records:</td><td class=\'gridDetails\'>${organ.frequencyDetail.count}</td></tr></table>');" onmouseout="return nd();">${tdOut}</a></td>
                              </c:when>
                              <c:otherwise>
                                <td>&nbsp;</td>
                              </c:otherwise>
                            </c:choose>
                          </c:otherwise>
                        </c:choose>
                      </c:forEach>
                    </c:forEach>
                  </c:when>
                  <c:otherwise>
                    <%--We <b>DO NOT</b> have a strain value...dump out a row of empty values.<br>--%>
                    
                    <c:set var="startColumn" value="3"/>
                    <c:if test="${not empty organKey}">
                      <c:set var="startColumn" value="4"/>
                    </c:if>
                    <c:if test="${not empty expOrganCount}" >
                      <c:set var="startColumn" value="${expOrganCount+3}"/>
                    </c:if>
                    <c:forEach var="i" begin="${startColumn}" end="${totalColumns}">
                      <td bgcolor="#ffffff">&nbsp;</td>
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
            

            <c:forEach var="anatomicalSystem" items="${anatomicalSystems}" varStatus="status">
              <c:forEach var="organParent" items="${anatomicalSystem.organs}" varStatus="status">
                <c:set var="organ" value=""/>
                <c:set var="compy" value="|${organParent.organKey}|" />
                <c:choose>
                  <c:when test="${not empty organKey}">
                    <%----------------------------------- START Organs Expanded Strains ------------------------------------%>
                    

                    <c:choose>
                      <c:when test="${fn:contains(organKey, compy)}">
                        <%-- ------------ LOOP THROUGH SUB ORGANS ------------------<br> --%>
                        <c:forEach var="subOrgan" items="${organParent.organs}" varStatus="status">
                          <%-- SUBORGAN NAME: ${subOrgan.organName}<br> --%>
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
                                  <c:set var="tdOut" value="<img src='${applicationScope.urlImageDir}/grid/${organ.frequencyDetail.descriptionHighest}.png' border='0' alt='H'  width='100%' height='100%'>"/>
                                </c:otherwise>
                              </c:choose>
                              <td align="center"><a href="tumorSearchResults.do?grid=1&amp;strainFamilyKey=${familyGrid.strainFamilyKey}&amp;organKey=${organ.organKey}" style="text-decoration: none; cursor:help;" onmouseover="return overlib('<table class=\'gridDetails\' border=0><tr><td class=\'gridDetails\'>Strain Family:</td><td class=\'gridDetails\'>${familyGrid.strainFamilyName}</td></tr><tr><td class=\'gridDetails\'>Organ:</td><td class=\'gridDetails\'>${organ.organName}</td></tr><tr><td class=\'gridDetails\'>Highest reported tumor frequency:</td><td class=\'gridDetails\'>${organ.frequencyDetail.longDescriptionHighest}</td></tr><tr><td class=\'gridDetails\'># Tumor Frequency Records:</td><td class=\'gridDetails\'>${organ.frequencyDetail.count}</td></tr></table>');" onmouseout="return nd();">${tdOut}</a></td>
                            </c:when>
                            <c:otherwise>
                              <td>&nbsp;</td>
                            </c:otherwise>
                          </c:choose>
                          <c:set var="organ" value=""/>
                        </c:forEach>
                      </c:when>
                      <c:otherwise>
                        <%-- ------------ LOOP THROUGH PARENT ORGANS------------------<br> --%>
                        <c:forEach var="organItem" items="${familyGrid.organs}" varStatus="status4">
                          <c:if test="${organParent.organKey == organItem.value.organKey}">
                            
                            
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
                                <c:set var="tdOut" value="<img src='${applicationScope.urlImageDir}/grid/${organ.frequencyDetail.descriptionHighest}.png' border='0' alt='H'  width='100%' height='100%'>"/>
                              </c:otherwise>
                            </c:choose>
                            <td align="center"><a href="tumorSearchResults.do?grid=1&amp;strainFamilyKey=${familyGrid.strainFamilyKey}&amp;organParentKey=${organ.organKey}" style="text-decoration: none; cursor:help;" onmouseover="return overlib('<table class=\'gridDetails\' border=0><tr><td class=\'gridDetails\'>Strain Family:</td><td class=\'gridDetails\'>${familyGrid.strainFamilyName}</td></tr><tr><td class=\'gridDetails\'>Organ:</td><td class=\'gridDetails\'>${organ.organName}</td></tr><tr><td class=\'gridDetails\'>Highest reported tumor frequency:</td><td class=\'gridDetails\'>${organ.frequencyDetail.longDescriptionHighest}</td></tr><tr><td class=\'gridDetails\'># Tumor Frequency Records:</td><td class=\'gridDetails\'>${organ.frequencyDetail.count}</td></tr></table>');" onmouseout="return nd();">${tdOut}</a></td>
                          </c:when>
                          <c:otherwise>
                            <td>&nbsp;</td>
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
                            <c:set var="tdOut" value="<img src='${applicationScope.urlImageDir}/grid/${organ.frequencyDetail.descriptionHighest}.png' border='0' alt='H'  width='100%' height='100%'>"/>
                          </c:otherwise>
                        </c:choose>
                        <td align="center"><a href="tumorSearchResults.do?grid=1&amp;strainFamilyKey=${familyGrid.strainFamilyKey}&amp;organParentKey=${organ.organKey}" style="text-decoration: none; cursor:help;" onmouseover="return overlib('<table class=\'gridDetails\' border=0><tr><td class=\'gridDetails\'>Strain Family:</td><td class=\'gridDetails\'>${familyGrid.strainFamilyName}</td></tr><tr><td class=\'gridDetails\'>Organ:</td><td class=\'gridDetails\'>${organ.organName}</td></tr><tr><td class=\'gridDetails\'>Highest reported tumor frequency:</td><td class=\'gridDetails\'>${organ.frequencyDetail.longDescriptionHighest}</td></tr><tr><td class=\'gridDetails\'># Tumor Frequency Records:</td><td class=\'gridDetails\'>${organ.frequencyDetail.count}</td></tr></table>');" onmouseout="return nd();">${tdOut}</a></td>
                      </c:when>
                      <c:otherwise>
                        <td>&nbsp;</td>
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

          <%--Getting organ...<br>--%>
          <c:forEach var="anatomicalSystem" items="${anatomicalSystems}" varStatus="status">
            <c:forEach var="organParent" items="${anatomicalSystem.organs}" varStatus="status">
              <c:set var="organ" value=""/>
              <c:set var="compy" value="|${organParent.organKey}|" />
              <c:choose>
                <c:when test="${not empty organKey}">
                  <%--
                         ------------ POTENTIALLY EXPANDED GRID ------------------<br>
                                                             
                  --%>
                  <c:choose>
                    <c:when test="${fn:contains(organKey, compy)}">
                      <%-- ------------ LOOP THROUGH SUB ORGANS ------------------<br> --%>
                      <c:forEach var="subOrgan" items="${organParent.organs}" varStatus="status">
                        <%-- SUBORGAN NAME: ${subOrgan.organName}<br> --%>
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
                                <c:set var="tdOut" value="<img src='${applicationScope.urlImageDir}/grid/${organ.frequencyDetail.descriptionHighest}.png' border='0' alt='H' width='100%' height='100%'>"/>
                              </c:otherwise>
                            </c:choose>
                            <td align="center"><a href="tumorSearchResults.do?grid=1&amp;strainFamilyKey=${familyGrid.strainFamilyKey}&amp;organKey=${organ.organKey}" style="text-decoration: none; cursor:help;" onmouseover="return overlib('<table class=\'gridDetails\' border=0><tr><td class=\'gridDetails\'>Strain Family:</td><td class=\'gridDetails\'>${familyGrid.strainFamilyName}</td></tr><tr><td class=\'gridDetails\'>Organ:</td><td class=\'gridDetails\'>${organ.organName}</td></tr><tr><td class=\'gridDetails\'>Highest reported tumor frequency:</td><td class=\'gridDetails\'>${organ.frequencyDetail.longDescriptionHighest}</td></tr><tr><td class=\'gridDetails\'># Tumor Frequency Records:</td><td class=\'gridDetails\'>${organ.frequencyDetail.count}</td></tr></table>');" onmouseout="return nd();">${tdOut}</a></td>
                          </c:when>
                          <c:otherwise>
                            <td>&nbsp;</td>
                          </c:otherwise>
                        </c:choose>
                        <c:set var="organ" value=""/>
                      </c:forEach>
                    </c:when>
                    <c:otherwise>
                      <%-- ------------ LOOP THROUGH PARENT ORGANS------------------<br> --%>
                      <c:forEach var="organItem" items="${familyGrid.organs}" varStatus="status4">
                        <c:if test="${organParent.organKey == organItem.value.organKey}">
                          
                          
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
                              <c:set var="tdOut" value="<img src='${applicationScope.urlImageDir}/grid/${organ.frequencyDetail.descriptionHighest}.png' border='0' alt='H' width='100%' height='100%'>"/>
                            </c:otherwise>
                          </c:choose>
                          <td align="center"><a href="tumorSearchResults.do?grid=1&amp;strainFamilyKey=${familyGrid.strainFamilyKey}&amp;organParentKey=${organ.organKey}" style="text-decoration: none; cursor:help;" onmouseover="return overlib('<table class=\'gridDetails\' border=0><tr><td class=\'gridDetails\'>Strain Family:</td><td class=\'gridDetails\'>${familyGrid.strainFamilyName}</td></tr><tr><td class=\'gridDetails\'>Organ:</td><td class=\'gridDetails\'>${organ.organName}</td></tr><tr><td class=\'gridDetails\'>Highest reported tumor frequency:</td><td class=\'gridDetails\'>${organ.frequencyDetail.longDescriptionHighest}</td></tr><tr><td class=\'gridDetails\'># Tumor Frequency Records:</td><td class=\'gridDetails\'>${organ.frequencyDetail.count}</td></tr></table>');" onmouseout="return nd();">${tdOut}</a></td>
                        </c:when>
                        <c:otherwise>
                          <td>&nbsp;</td>
                        </c:otherwise>
                      </c:choose>
                    </c:otherwise>
                  </c:choose>
                </c:when>
                <c:otherwise>
                  <%-- ------------ COLLAPSED GRID ------------------<br> --%>
                  <c:forEach var="organItem" items="${familyGrid.organs}" varStatus="status4">
                    <c:if test="${organParent.organKey == organItem.value.organKey}">
                      
                      
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
                          <c:set var="tdOut" value="<img src='${applicationScope.urlImageDir}/grid/${organ.frequencyDetail.descriptionHighest}.png' border='0' alt='H' width='100%' height='100%'>"/>
                        </c:otherwise>
                      </c:choose>
                      <td align="center"><a href="tumorSearchResults.do?grid=1&amp;strainFamilyKey=${familyGrid.strainFamilyKey}&amp;organParentKey=${organ.organKey}" style="text-decoration: none; cursor:help;" onmouseover="return overlib('<table class=\'gridDetails\' border=0><tr><td class=\'gridDetails\'>Strain Family:</td><td class=\'gridDetails\'>${familyGrid.strainFamilyName}</td></tr><tr><td class=\'gridDetails\'>Organ:</td><td class=\'gridDetails\'>${organ.organName}</td></tr><tr><td class=\'gridDetails\'>Highest reported tumor frequency:</td><td class=\'gridDetails\'>${organ.frequencyDetail.longDescriptionHighest}</td></tr><tr><td class=\'gridDetails\'># Tumor Frequency Records:</td><td class=\'gridDetails\'>${organ.frequencyDetail.count}</td></tr></table>');" onmouseout="return nd();">${tdOut}</a></td>
                    </c:when>
                    <c:otherwise>
                      <td>&nbsp;</td>
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
          <%--We <b>DO NOT</b> have a family value...dump out a row of empty values.<br>--%>
          <td class="grid" align="right"><img src="${applicationScope.urlImageDir}/grid/grid_spacer.png" border="0" alt=" ">&nbsp;${fam.strainFamilyName}</td>
          <c:set var="startColumn" value="3"/>
          <c:if test="${not empty organKey}">
            <c:set var="startColumn" value="4"/>
          </c:if>
          <c:if test="${not empty expOrganCount}" >
            <c:set var="startColumn" value="${expOrganCount+3}"/>
          </c:if>
          <c:forEach var="i" begin="${startColumn}" end="${totalColumns}">
            <td bgcolor="#ffffff">&nbsp;</td>
          </c:forEach>
        </c:otherwise>
        </c:choose>
      </tr>
      </c:forEach>
      </c:when>
      <c:otherwise>
      <%--We <b>DO NOT</b> have a heredity value...dump out a row of empty values.<br>--%>
      <c:forEach var="fam" items="${rowHeredity.families}" varStatus="status3">
      <c:if test="${!status3.first}">
        <tr class="grid">
      </c:if>
      <td class="grid" bgcolor="#ffffff"><img src="${applicationScope.urlImageDir}/grid/grid_spacer.png" border="0" alt=" ">&nbsp;${fam.strainFamilyName}</td>
      <c:set var="startColumn" value="3"/>
      <c:if test="${not empty organKey}">
        <c:set var="startColumn" value="4"/>
      </c:if>
      <c:if test="${not empty expOrganCount}" >
        <c:set var="startColumn" value="${expOrganCount+3}"/>
      </c:if>
      <c:forEach var="i" begin="${startColumn}" end="${totalColumns}">
        <td bgcolor="#ffffff">&nbsp;</td>
      </c:forEach>
    </tr>
    </c:forEach>
    </c:otherwise>
    </c:choose>
    </c:forEach>
  </table>
  <table>
    <tr class="buttons">
      <td colspan="2">
        <table border=0 cellspacing=5 width="100%">
          <tr>
            <td>
              <input type="hidden" value="showAllStrains" name="showAllStrains" >
              
              <input type="button" VALUE="Generate Grid" onClick="javascript:checkChecks()">
              <input type="button" value="Invert Selected Organ Groups" onClick="javascript: toggleOrgans()">
              <input type="button" value="Invert Selected Strain Families" onClick="javascript: toggleStrains()">
              
              <input type="button" value="hide/show checkboxes" onClick="javascript: hideChecks()">
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
  </html:form>
  </c:when>
  <c:otherwise>
    <h2> <b>${message}</b> </h2>
  </c:otherwise>
  </c:choose>
  </c:catch>
  <c:if test="${not empty exception}">
    </tr>
    </table>
    <pre>

    <c:out value="${exception}"/>
      An error occurred <c:out value="${exception.message}"/><br>
      
        Stacktrace: <br>
<%
    Throwable t = (Throwable) pageContext.getAttribute("exception");
    t.printStackTrace(new java.io.PrintWriter(out));
%>

    </pre>
  </c:if>
  <hr><a NAME="legend"></a><b>Legend</b>
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
  
  <hr><b>Notes</b>
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
  
  <!--======================= End Detail Section =============================-->
<!--======================= End Main Section ===============================-->
  </td>
  </tr>
  </table>
  </body>
</html> 
