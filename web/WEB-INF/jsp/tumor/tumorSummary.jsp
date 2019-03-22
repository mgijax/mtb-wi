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
    <c:param name="pageTitle" value="Tumor Summary"/>
</c:import>
</head>

<c:import url="../../../body.jsp">
     <c:param name="pageTitle" value="Tumor Summary"/>
</c:import>

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
       <td colspan="2">
           <table width="100%" border=0 cellpadding=0 cellspacing=0>
               <tr>
                   <td width="20%" valign="middle" align="left">
                       <a class="help" href="userHelp.jsp#tumorsummary"><img src="${applicationScope.urlImageDir}/help_large.png" border=0 width=32 height=32 style="vertical-align:middle" alt="Help">Help and Documentation</a>
                   </td>
                   <td width="60%" class="pageTitle">
                       Tumor Summary
                   </td>
                   <td width="20%" valign="middle" align="center">&nbsp;</td>
               </tr>
           </table>
       </td>
   </tr>
</table>
<!--======================= End Form Header ================================-->
<br>
<!--======================= Start Detail Section ===========================-->
<!--======================= Start Tumor & Strain ===========================-->
<table border=0 cellpadding="0" cellspacing="0" width="100%">
    <tr>
<!--======================= Start Top Left (Tumor) =========================-->
        <td valign="top" width="49%">
            <table border=0 cellpadding=5 cellspacing=1 width="100%" class="results">
                <tr class="stripe1">
                    <td class="cat1">Tumor Name</td>
                    <td>
                        <font class="enhance">
                        <c:out value="${tumor.organOfOrigin}" escapeXml="false"/>
                        <br>
                        <c:out value="${tumor.tumorClassification}" escapeXml="false"/>
                        </font>
                    </td>
                </tr>
                <tr class="stripe2">
                    <td class="cat2">Treatment Type</td>
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
<!--======================= End Top Left (Tumor) ===========================-->
        <td width=20>&nbsp;</td>
<!--======================= Start Top Right (Strain) =======================-->
        <td valign="top" width="49%">
            <table border=0 cellpadding=5 cellspacing=1 width="100%" class="results">
                <tr class="stripe1">
                    <td class="cat1">Strain</td>
                    <td>
                        <table border="0" cellspacing="2">
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
                                <td class="label" valign="top"><div class="nowrap">General Note: </div></td>
                                <td valign="top">${tumor.strainNote}</td>
                            </tr>
                        </c:if>
                        </table>
                    </td>
                </tr>
                <c:choose>
                <c:when test="${not empty tumor.strainSynonyms}">
                    <tr class="stripe2">
                        <c:choose>
                        <c:when test="${fn:length(tumor.strainSynonyms)>1}">
                            <td class="cat2">Strain Synonyms</td>
                        </c:when>
                        <c:otherwise>
                            <td class="cat2">Strain Synonym</td>
                        </c:otherwise>
                        </c:choose>
                        <td>
                            <c:forEach var="synonym" items="${tumor.strainSynonyms}" varStatus="status">
                                <span class="synDiv2"><c:out value="${synonym.name}" escapeXml="false"/></span>
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
<!--======================= End Top Right (Strain) =========================-->
    </tr>
</table>
<!--======================= End Tumor & Strain =============================-->
<br>
<!--======================= Start Frequency Records ========================-->
    <c:choose>
    <c:when test="${not empty tumor.frequencyRecs}">
        <table border="0" cellpadding=5 cellspacing=1 width="100%" class="results">
            <tr>
                <td class="resultsHeader">MTB ID</td>
                <td class="resultsHeader">Organ Affected</td>
                <td class="resultsHeader">Treatment Type<br><font size="-2"><i>Agents</i></font></td>
                <td class="resultsHeader">Strain Sex</td>
                <td class="resultsHeader">Reproductive Status</td>
                <td class="resultsHeader">Infection Status</td>
                <td class="resultsHeader">Frequency</td>
                <td class="resultsHeader">Age Of<br>Onset</td>
                <td class="resultsHeader">Age Of<br>Detection</td>
                <td class="resultsHeader">Additional<br>Information</td>
                <td class="resultsHeader">Reference</td>
            </tr>

            <c:set var="lbl" value="1"/>
            <c:set var="previousParent" value="-100"/>
            <c:set var="rowClass" value="stripe1"/>

            <c:forEach var="rec" items="${tumor.frequencyRecs}" varStatus="status">
            
              <c:if test="${(status.index == 1) && not empty byExample}">
              <tr>
                <td class="resultsHeader" colspan="11">Additional tumor frequency records with the same strain, classification and treatment type </td>
                
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
                            <br>
                            <div class="nowrap"><font size="-2"><i>(metastasis<br>from MTB:${rec.parentFrequencyKey})</i></font></div>
                        </c:if>
                    </td>
                    <td><c:out value="${rec.organAffected}" escapeXml="false" default="&nbsp;"/></td>
                    <td>
                        <c:out value="${tumor.treatmentType}" escapeXml="false"/>

                        <c:if test="${not empty rec.sortedAgents}">
                            <font size="-2">
                            <i>
                            <c:forEach var="agent" items="${rec.sortedAgents}" varStatus="status">
                                <br>
                                <c:out value="${agent}" escapeXml="false"/>
                                <c:choose>
                                  <c:when test="${status.last != true}">
                                    <c:out value=", "/>
                                    
                                  </c:when>
                                </c:choose>
                            </c:forEach>
                            </i>
                            </font>
                        </c:if>
                    </td>
                    <td><c:out value="${rec.strainSex}" escapeXml="false" default="&nbsp;"/></td>
                    <td><c:out value="${rec.reproductiveStatus}" escapeXml="false" default="&nbsp;"/></td>
                    <td><c:out value="${rec.infectionStatus}" escapeXml="false" default="&nbsp;"/></td>
                    <td>
                        <c:out value="${rec.frequencyString}" escapeXml="false" default="&nbsp;"/>
                        <c:if test="${rec.numMiceAffected>=0&&rec.colonySize>=0}">
                            <br>
                            (${rec.numMiceAffected} of ${rec.colonySize} mice)
                        </c:if>
                    </td>
                    <td><c:out value="${rec.ageOnset}" escapeXml="false" default="&nbsp;"/></td>
                    <td><c:out value="${rec.ageDetection}" escapeXml="false" default="&nbsp;"/></td>
                    <!-- Additional Information -->
                    <td>
                        <c:set var="additionalInfoText" value=""/>
                        <font size="-2">
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
                                  <c:set var="additionalInfoText" value="${additionalInfoText}<br> <br>"/>
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
                                    <c:set var="additionalInfoText" value="${additionalInfoText}<br> <br>"/>
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
                                    <c:set var="additionalInfoText" value="${additionalInfoText}<br> <br>"/>
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
                                    <c:set var="additionalInfoText" value="${additionalInfoText}<br> <br>"/>
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
                                &nbsp;
                            </c:otherwise>
                        </c:choose>
                        </font>
                    </td>
                    <td>
                        <c:choose>
                        <c:when test="${not empty rec.reference}">
                            <a href="referenceDetails.do?accId=${rec.reference}">${rec.reference}</a>
                        </c:when>
                        <c:otherwise>
                            &nbsp;
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
<!--======================= End Frequency Records ==========================-->
<!--======================= End Detail Section =============================-->
<!--======================= End Main Section ===============================-->
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</body>
</html>

