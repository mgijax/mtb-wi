<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib uri="http://tumor.informatics.jax.org/mtbwi/MTBWebUtils" prefix="wu" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<c:import url="../../../meta.jsp">
    <c:param name="pageTitle" value="Pathology Image Search Results"/>
</c:import>
</head>

<c:import url="../../../body.jsp">
     <c:param name="pageTitle" value="Pathology Image Search Results"/>
</c:import>

<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr>
        <td width="200" valign="top">
            <c:import url="../../../toolBar.jsp" />
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
       <td width="100%">
           <table width="100%" border=0 cellpadding=0 cellspacing=0>
               <tr>
                   <td width="20%" valign="middle" align="left">
                       <a class="help" href="userHelp.jsp#pathresults"><img src="${applicationScope.urlImageDir}/help_large.png" border=0 width=32 height=32 style="vertical-align:middle" alt="Help">Help and Documentation</a>
                   </td>
                   <td width="60%" class="pageTitle">
                       Pathology Image Search Results
                   </td>
                   <td width="20%" valign="middle" align="center">&nbsp;</td>
               </tr>
           </table>
       </td>
   </tr>
<!--======================= End Form Header ================================-->
<!--======================= Start Search Summary ===========================-->
    <tr class="summary">
        <td>
            <font class="label">Search Summary</font><br>
            
            <c:if test="${not empty organOriginSelected}">
                <c:choose>
                    <c:when test="${fn:length(organOriginSelected)>1}">
                        <font class="label">Organs/Tissues of Origin:</font> 
                    </c:when>
                    <c:otherwise>
                        <font class="label">Organ/Tissue of Origin:</font> 
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
                <br>
            </c:if>

            <c:if test="${not empty tumorClassificationsSelected}">
                <c:choose>
                    <c:when test="${fn:length(tumorClassificationsSelected)>1}">
                        <font class="label">Tumor Classifications:</font> 
                    </c:when>
                    <c:otherwise>
                        <font class="label">Tumor Classification:</font> 
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
                <br>
            </c:if>

            <c:if test="${not empty organsAffectedSelected}">
                <font class="label">Organ/Tissue Affected:</font> ${organsAffectedSelected}<br>
            </c:if>
            
            <c:if test="${not empty diagnosisDescription}">
                <font class="label">Diagnosis or Description:</font> Contains "${diagnosisDescription}"<br>
            </c:if>
            
            <c:if test="${not empty methodSelected}">
                <font class="label">Method:</font> ${methodSelected}<br>
            </c:if>
            
            <c:if test="${not empty antibodiesSelected}">
                <c:choose>
                    <c:when test="${fn:length(antibodiesSelected)>1}">
                        <font class="label">Antibodies:</font> 
                    </c:when>
                    <c:otherwise>
                        <font class="label">Antibody:</font> 
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
                <br>
            </c:if>

            <c:if test="${not empty imageContributors}">
                <c:choose>
                    <c:when test="${fn:length(imageContributors)>1}">
                        <font class="label">Contributors:</font> 
                    </c:when>
                    <c:otherwise>
                        <font class="label">Contributor:</font> 
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
                <br>
            </c:if>
            
            <c:if test="${not empty accId}">
                <font class="label">Accession Id:</font> ${accId}<br>
            </c:if>

            <font class="label">Sort By:</font> ${sortBy}<br>
            <font class="label">Display Limit:</font> ${maxItems}
        </td>
    </tr>
    <tr class="summary">
        <td>
<!--======================= Start Display Limit ============================-->
            <c:choose>
                <c:when test="${numberOfResults != totalResults}">
                    <c:out value="${numberOfResults}" default="0"/> (of <c:out value="${totalResults}" default="0"/>) pathology reports displayed, including <c:out value="${totalNumOfPathImages}" default="0"/>  images.
                </c:when>
                <c:otherwise>
                    <c:out value="${numberOfResults}" default="0"/> (of <c:out value="${totalResults}" default="0"/>) pathology reports displayed, including <c:out value="${totalNumOfPathImages}" default="0"/>  images.
                </c:otherwise>
            </c:choose>
<!--======================= End Display Limit ==============================-->
        </td>
    </tr>
</table>
<!--======================= End Search Summary =============================-->
<!--======================= Start Results ==================================-->
<c:choose>
    <c:when test="${not empty pathologyImages}">
        <c:forEach var="pathRec" items="${pathologyImages}" varStatus="status">
            <br><br>
            <table border="0" cellpadding=5 cellspacing=1 width="100%" class="results">
                <tr>
                    <td width="8%" class="resultsHeader">MTB ID</td>
                    <td width="14%" class="resultsHeader">Tumor Name</td>
                    <td width="13%" class="resultsHeader">Organ(s) Affected</td>
                    <td width="13%" class="resultsHeader">Treatment Type<br><font class="small"><i>Agents</i></font></td>
                    <td width="14%" class="resultsHeader">Strain Name<br><font class="small">Strain Sex<br>Reproductive Status</font></td>
                    <td width="9%" class="resultsHeader">Tumor<br>Frequency</td>
                    <td width="9%" class="resultsHeader">Age at<br>Necropsy</td>
                    <td width="13%" class="resultsHeader">Description</td>
                    <td width="7%" class="resultsHeader">Reference</td>
                </tr>
                <tr class="stripe1">
                   
                    <td align="center"><a href="tumorSummary.do?tumorFrequencyKeys=${pathRec.tumorFrequencyKey}">MTB:${pathRec.tumorFrequencyKey}</a></td>
                    <td align="center">${pathRec.organOriginName} &nbsp; ${pathRec.tumorClassName}</td>
                    <td align="center">${pathRec.organAffectedName}</td>
                    <td align="center">
                        <c:out value="${pathRec.treatmentType}" escapeXml="false"/>
                        <c:if test="${not empty pathRec.agents}">
                            <br>
                            <font size="-2"><i>
                            <c:forEach var="agent" items="${pathRec.agents}" varStatus="status">
                                <c:out value="${agent}" escapeXml="false"/>
                                <c:if test="${status.last != true}">
                                    <br>
                                </c:if>
                            </c:forEach>
                            </i></font> 
                        </c:if>
                    </td>
                    <td align="center">
                        <font class="enhance"><a href="strainDetails.do?key=${pathRec.strainKey}"><c:out value="${pathRec.strainName}" escapeXml="false"/></a></font>
                        <br>${pathRec.strainSex}
                        <c:if test="${not empty pathRec.reproductiveStatus}">
                            <br>${pathRec.reproductiveStatus}
                        </c:if>
                    </td>
                    <td align="center">${pathRec.frequencyString}</td>
                    <td align="center">${pathRec.ageAtNecropsy}</td>
                    <td align="center">${pathRec.note}</td>
                    <td align="center"><a href="referenceDetails.do?accId=${pathRec.accID}">${pathRec.accID}</a></td>
                </tr>
                <c:forEach var="image" items="${pathRec.images}" varStatus="status">
                    <c:choose>
                        <c:when test="${status.index%2==1}">
                            <tr class="stripe1">
                        </c:when>
                        <c:otherwise>
                            <tr class="stripe2">
                        </c:otherwise>
                    </c:choose>
                        <td colspan=9>
                            <table border=0 cellspacing=5 cellpadding=5>
                                <tr>
                                    <td>
                                        <a href="nojavascript.jsp" onClick="popPathWin('pathologyImageDetails.do?key=${image.imageId}', 'ImageId${image.imageId}');return false;">
                                        <img width=150 src="${applicationScope.pathologyImageUrl}/${applicationScope.pathologyImagePath}/${image.imageThumbName}" alt="${image.imageId}"></a>
                                    </td>
                                    <td width=250 valign="top">
                                        <table border=0 cellspacing=1 cellpadding=1>
                                            <tr>
                                                <td class="small" align="right"><div class="nowrap"><font class="label">Image ID:</font></div></td>
                                                <td class="small">${image.imageId}</td>
                                            </tr>
                                            <tr>
                                                <td class="small" align="right"><div class="nowrap"><font class="label">Source of Image:</font></div></td>
                                                <td class="small">
                                                    ${image.sourceOfImage}
                                                   
                                                </td>
                                            </tr>
                                            
                                             <tr>
                                                <td class="small" align="right"><div class="nowrap"><font class="label">Pathologist:</font></div></td>
                                                <td class="small">
                                                    ${image.pathologist}
                                                   
                                                </td>
                                            </tr>
                                            <c:choose>
                                               <c:when test="${not empty image.stainMethod}">
                                                <tr>
                                                  <td class="small" align="right"><div class="nowrap"><font class="label">Method / Stain:</font></div></td>
                                                  <td class="small">${image.stainMethod}</td>
                                                </tr>
                                              </c:when>
                                            </c:choose>
                                        </table>
                                    </td>
                                    <td class="small" colspan=5>
                                        <font class="label">Image Caption</font>:<br>
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
<!--======================= End Results ====================================-->
<!--======================== End Main Section ==============================-->
        </table>
        </td>
    </tr>
</table>
</body>
</html> 

