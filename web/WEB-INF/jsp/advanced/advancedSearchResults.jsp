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
    <c:param name="pageTitle" value="Advanced Search Results"/>
</c:import>
</head>

<c:import url="../../../body.jsp">
     <c:param name="pageTitle" value="Advanced Search Results"/>
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
       <td colspan="11" width="100%">
           <table width="100%" border=0 cellpadding=0 cellspacing=0>
               <tr>
                   <td width="20%" valign="middle" align="left">
                       <a class="help" href="userHelp.jsp#tumorresults"><img src="${applicationScope.urlImageDir}/help_large.png" border=0 width=32 height=32 alt="Help"></a>
                   </td>
                   <td width="60%" class="pageTitle">
                       Advanced Search Results
                   </td>
                   <td width="20%" valign="middle" align="center">&nbsp;</td>
               </tr>
           </table>
       </td>
   </tr>
<!--======================= End Form Header ================================-->
<!--======================= Start Search Summary ===========================-->
    <tr class="summary">
        <td colspan="11">
            <font class="label">Search Summary</font><br>
            
            <c:if test="${not empty strainName}">
                <font class="label">Strain Name:</font> ${strainNameComparison} "${strainName}"<br>
            </c:if>
            
            <c:if test="${not empty strainTypes}">
                <c:choose>
                    <c:when test="${strainTypesSize>'1'}">
                        <font class="label">Strain Types:</font>
                    </c:when>
                    <c:otherwise>
                        <font class="label">Strain Type:</font>
                    </c:otherwise>
                </c:choose>
                
                <c:forEach var="strainType" items="${strainTypes}" varStatus="status">
                    <c:choose>
                        <c:when test="${status.last != true}">
                            ${strainType},
                        </c:when>
                        <c:otherwise>
                            ${strainType}
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
                <br>
            </c:if>
            
            <c:if test="${not empty geneticName}">
                <font class="label">Genetic Name</font> ${geneticName}<br>
            </c:if>
            

            <c:if test="${not empty organTissueOrigins}">
                <c:choose>
                    <c:when test="${fn:length(organTissueOrigins)>1}">
                        <font class="label">Organs/Tissues of Origin:</font> 
                    </c:when>
                    <c:otherwise>
                        <font class="label">Organ/Tissue of Origin:</font> 
                    </c:otherwise>
                </c:choose>
                
                <c:forEach var="organ" items="${organTissueOrigins}" varStatus="status">
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

            <c:if test="${not empty organOfOriginName}">
                <font class="label">Organ/Tissue of Origin:</font> Contains "${organOfOriginName}"<br>
            </c:if>
            
            <c:if test="${not empty tumorClassifications}">
                <c:choose>
                    <c:when test="${fn:length(tumorClassifications)>1}">
                        <font class="label">Tumor Classifications:</font>
                    </c:when>
                    <c:otherwise>
                        <font class="label">Tumor Classification:</font> 
                    </c:otherwise>
                </c:choose>
                
                <c:forEach var="classification" items="${tumorClassifications}" varStatus="status">
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

            <c:if test="${not empty tumorName}">
                <font class="label">Tumor Name:</font> Contains "${tumorName}"<br>
            </c:if>
            
            <c:if test="${not empty agentType}">
                <font class="label">Treatment Type:</font> ${agentType}<br>
            </c:if>

            <c:if test="${not empty agent}">
                <font class="label">Treatment:</font>  Contains "${agent}"<br>
            </c:if>

            <c:if test="${not empty metastasisLimit}">
                <font class="label">Restrict search to metastatic tumors only.</font><br>
            </c:if>

            <c:if test="${not empty organsAffected}">
                <c:choose>
                    <c:when test="${fn:length(organsAffected)>1}">
                        <font class="label">Organs/Tissues Affected:</font>
                    </c:when>
                    <c:otherwise>
                        <font class="label">Organ/Tissue Affected:</font>
                    </c:otherwise>
                </c:choose>
                
                <c:forEach var="organ" items="${organsAffected}" varStatus="status">
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
            
            <c:if test="${not empty mustHaveImages}">
                <font class="label">Restrict search to entries with associated pathology images.</font><br>
            </c:if>

            <c:if test="${not empty geneticChange}">
                <font class="label">Genetic Change:</font> ${geneticChange}<br>
            </c:if>
            
            <c:if test="${not empty cytogeneticChange}">
                <font class="label">Cytogenetic Change:</font> ${cytogeneticChange}<br>
            </c:if>
            
            <c:if test="${not empty accId}">
                <font class="label">Accession Id:</font> ${accId}<br>
            </c:if>
            
            <font class="label">Sort By:</font> ${sortBy}<br>
            <font class="label">Display Limit:</font> ${maxItems}
        </td>
    </tr>
    <tr class="summary">
        <td colspan="11">
<!--======================= Start Display Limit ============================-->
            <c:choose>
                <c:when test="${numberOfResults != totalResults}">
                    <c:choose>
                        <c:when test="${numberOfResults==1}">
                            <c:choose>
                                <c:when test="${tumorFrequencyRecords==1}">
                                    ${numberOfResults} unique tumor instance representing ${tumorFrequencyRecords} tumor frequency record returned.
                                </c:when>
                                <c:otherwise>
                                    ${numberOfResults} unique tumor instances (of ${totalResults} total) representing ${tumorFrequencyRecords} tumor frequency records returned.
                                </c:otherwise>
                            </c:choose>
                        </c:when>
                        <c:otherwise>
                            <c:choose>
                                <c:when test="${tumorFrequencyRecords==1}">
                                    ${numberOfResults} unique tumor instances (of ${totalResults} total) representing ${tumorFrequencyRecords} tumor frequency record returned.
                                </c:when>
                                <c:otherwise>
                                    ${numberOfResults} unique tumor instances (of ${totalResults} total) representing ${tumorFrequencyRecords} tumor frequency records returned.
                                </c:otherwise>
                            </c:choose>
                        </c:otherwise>
                    </c:choose>
                </c:when>
                <c:otherwise>
                    <c:choose>
                        <c:when test="${numberOfResults==1}">
                            <c:choose>
                                <c:when test="${tumorFrequencyRecords==1}">
                                    ${numberOfResults} unique tumor instance representing ${tumorFrequencyRecords} tumor frequency record returned.
                                </c:when>
                                <c:otherwise>
                                    ${numberOfResults} unique tumor instances representing ${tumorFrequencyRecords} tumor frequency records returned.
                                </c:otherwise>
                            </c:choose>
                        </c:when>
                        <c:otherwise>
                            <c:choose>
                                <c:when test="${tumorFrequencyRecords==1}">
                                    ${numberOfResults} unique tumor instances representing ${tumorFrequencyRecords} tumor frequency record returned.
                                </c:when>
                                <c:otherwise>
                                    ${numberOfResults} unique tumor instances representing ${tumorFrequencyRecords} tumor frequency records returned.
                                </c:otherwise>
                            </c:choose>
                        </c:otherwise>
                    </c:choose>
                </c:otherwise>
            </c:choose>
<!--======================= End Display Limit ==============================-->            
        </td>
    </tr>
<!--======================= End Search Summary =============================-->
<!--======================= Start Results ==================================-->
<c:choose>
<c:when test="${not empty tumors}">
    <c:set var="lbl" value="1"/>
        <tr class="results">
            <td class="resultsHeader" rowspan="2">Tumor Name</b></td>
            <td class="resultsHeader" rowspan="2">Organ Affected</td>
            <td class="resultsHeader" rowspan="2">Treatment Type<br><font size="-2"><i>Agents</i></font></td>
            <td class="resultsHeader" rowspan="2">Strain Name<br><font size="-2"><i>Strain Types</i></font></td>
            <td class="resultsHeader" colspan="4">Tumor Frequency Range</td>
            <td class="resultsHeaderSmall" rowspan="2">Metastasizes<br>To</td>
            <td class="resultsHeaderSmall" rowspan="2">Images</td>
            <td class="resultsHeader" rowspan="2">Tumor<br>Summary</td>
        </tr>
        <tr class="results">
            <td width="40" class="resultsHeaderSmall">F</td>
            <td width="40" class="resultsHeaderSmall">M</td>
            <td width="40" class="resultsHeaderSmall">Mixed</td>
            <td width="40" class="resultsHeaderSmall">Un.</td>
        </tr>
        <c:forEach var="tumor" items="${tumors}" varStatus="status">
            <c:choose>
                <c:when test="${status.index%2==0}">
                    <tr class="stripe1">
                </c:when>
                <c:otherwise>
                    <tr class="stripe2">
                </c:otherwise>
            </c:choose>
            <td width="250"><c:out value="${tumor.tumorName}" escapeXml="false"/></td>
            <td><c:out value="${tumor.organAffectedName}" escapeXml="false"/></td>
            <td width="200">
                <c:out value="${tumor.treatmentType}" escapeXml="false"/>
                <c:if test="${not empty tumor.agentsCollection}">
                    <br>
                    <font size="-2"><i>
                    <c:forEach var="agent" items="${tumor.agentsCollection}" varStatus="status">
                        <c:out value="${agent}" escapeXml="false"/>
                        <c:if test="${status.last != true}">
                            <br>
                        </c:if>
                    </c:forEach>
                    </i></font> 
                </c:if>
            </td>
            <td><a href="strainDetails.do?key=${tumor.strainKey}"><c:out value="${tumor.strainName}" escapeXml="false"/></a>
                <c:if test="${not empty tumor.strainTypesCollection}">
                    <br>
                    <font size="-2"><i>
                    <c:forEach var="strainType" items="${tumor.strainTypesCollection}" varStatus="status">
                        ${strainType}
                        <c:if test="${status.last != true}">
                            <br>
                        </c:if>
                    </c:forEach>
                    </i></font>
                </c:if>
            </td>
            <td width="40" class="smallCenter"><c:out value="${tumor.freqFemaleString}" escapeXml="false" default="&nbsp;"/></td>
            <td width="40" class="smallCenter"><c:out value="${tumor.freqMaleString}" escapeXml="false" default="&nbsp;"/></td>
            <td width="40" class="smallCenter"><c:out value="${tumor.freqMixedString}" escapeXml="false" default="&nbsp;"/></td>
            <td width="40" class="smallCenter"><c:out value="${tumor.freqUnknownString}" escapeXml="false" default="&nbsp;"/></td>
            <td>
                <c:choose>
                <c:when test="${not empty tumor.metastasizesToDisplay}">
                    <font size="-2">
                    <c:forEach var="organ" items="${tumor.metastasizesToDisplay}" varStatus="status">
                        ${organ}
                        <c:if test="${status.last != true}">
                            <br>
                        </c:if>
                    </c:forEach>
                    </font>
               </c:when>
                <c:otherwise>
                    &nbsp;
                </c:otherwise>
                </c:choose>
            </td>
            <td>
               <c:choose>
               <c:when test="${tumor.images==true}">
                  <center><img src="${applicationScope.urlImageDir}/pic.gif" alt="X" border="0"></center>
               </c:when>
               <c:otherwise>
                   &nbsp;
               </c:otherwise>
               </c:choose>
            </td>
            <td>
                <a href="tumorSummary.do?strainKey=${tumor.strainKey}&amp;organOfOriginKey=${tumor.organOfOriginKey}&amp;tumorFrequencyKeys=${tumor.allTFKeysAsParams}">Summary</a>
            </td>
        </tr>
    </c:forEach>
</c:when>
<c:otherwise>
    <!-- No results found. //-->
</c:otherwise>
</c:choose>
<!--======================= End Results ====================================-->
    </table>
<!--======================== End Main Section ==============================-->
        </td>
    </tr>
</table>
</td></tr></table>
</body>
</html> 
