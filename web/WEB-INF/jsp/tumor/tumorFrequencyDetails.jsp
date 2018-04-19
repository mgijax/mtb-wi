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
    <c:param name="pageTitle" value="Tumor Details"/>
</c:import>
</head>

<c:import url="../../../body.jsp">
     <c:param name="pageTitle" value="Tumor Details"/>
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
                       <a class="help" href="userHelp.jsp#tumordetails"><img src="${applicationScope.urlImageDir}/help_large.png" border=0 width=32 height=32 alt="Help"></a>
                   </td>
                   <td width="60%" class="pageTitle">
                       Tumor Details
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
            <table border="0" cellpadding=5 cellspacing=1 width="100%" class="results">
                <c:set var="lbl" value="1"/>
                
                <c:choose>
                    <c:when test="${tumorFreq.parentFrequencyKey>0}">
                        <c:set var="lbl" value="${lbl == 1 ? 2 : 1}"/>
                        <tr class="stripe${lbl}">
                            <td class="cat${lbl}">Metastatic Tumor</td>
                            <td class="data${lbl}">
                                <font class="enhance">
                                <c:out value="${tumorFreq.organAffected}"/>
                                </font>
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <!-- Not a metastatic tumor //-->
                    </c:otherwise>
                </c:choose>
            
                <c:set var="lbl" value="${lbl == 1 ? 2 : 1}"/>
                <tr class="stripe${lbl}">
                    <td class="cat${lbl}">Tumor Name</td>
                    <td class="data${lbl}">
                        <c:if test="${tumorFreq.parentFrequencyKey<=0}">
                            <font class="enhance">
                        </c:if>
                        <c:out value="${tumorFreq.organOfOrigin}" escapeXml="false"/>
                        <br>
                        <c:out value="${tumorFreq.tumorClassification}" escapeXml="false"/>
                        <c:if test="${tumorFreq.parentFrequencyKey<=0}">
                            </font>
                        </c:if>
                    </td>
                </tr>
                
                <c:set var="lbl" value="${lbl == 1 ? 2 : 1}"/>
                <tr class="stripe${lbl}">
                    <td class="cat${lbl}">Treatment Type</td>
                    <td class="data${lbl}">
                        <c:out value="${tumorFreq.treatmentType}" escapeXml="false"/>
                    </td>
                </tr>
                
                <c:choose>
                <c:when test="${not empty tumorFreq.tumorSynonyms}">
                    <c:set var="lbl" value="${lbl == 1 ? 2 : 1}"/>
                    <tr class="stripe${lbl}">
                        <c:choose>
                        <c:when test="${fn:length(tumor.agents)>1}">
                            <td class="cat${lbl}">Tumor Synonyms</td>
                        </c:when>
                        <c:otherwise>
                            <td class="cat${lbl}">Tumor Synonym</td>
                        </c:otherwise>
                        </c:choose>

                        <td class="data${lbl}">
                            <c:forEach var="synonym" items="${tumorFreq.tumorSynonyms}" varStatus="status">
                                ${synonym}
                                <c:if test="${status.last != true}">
                                    &nbsp;&#8226;&nbsp;
                                </c:if>
                            </c:forEach>
                        </td>
                    </tr>
                </c:when>
                <c:otherwise>
                    <!--There are no synonyms associated with this tumorFreq. //-->
                </c:otherwise>
                </c:choose>

                <c:choose>
                    <c:when test="${tumorFreq.parentFrequencyKey<=0}">
                        <c:choose>
                        <c:when test="${not empty tumorFreq.associatedFrequencyInfo}">
                            <c:set var="lbl" value="${lbl == 1 ? 2 : 1}"/>
                            <c:set var="pmets" value="-1"/>
                            <tr class="stripe${lbl}">
                                <td class="cat${lbl}">Metastases</td>
                                <td class="data${lbl}">
                                    <table border="0" cellpadding="0" cellspacing="3">
                                        <c:forEach var="mets" items="${tumorFreq.associatedFrequencyInfo}" varStatus="status">
                                            <%-- Don't incluse ourself in the list --%>
                                            <c:if test="${mets.label != tumorFreq.tumorFrequencyKey}">
                                                <tr>
                                                    <td valign="top"><a href="tumorFrequencyDetails.do?key=${mets.label}">MTB:${mets.label}</a></td>
                                                    <td valign="top">
                                                        ${mets.value}
                                                        <%--
                                                        <c:choose>
                                                        <c:when test="${mets.data=='0'}">
                                                            <c:set var="pmets" value="${mets.label}"/>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <font size="-2"><i>(metastasis from MTB:${pmets})</i></font>
                                                        </c:otherwise>
                                                        </c:choose>
                                                        --%>
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </c:forEach>
                                    </table>
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <!--There are no frequency records associated associated with this tumor frequency record . //-->
                        </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:otherwise>
                        <!-- Not a metastatic tumor //-->
                    </c:otherwise>
                </c:choose>
            </table>
        </td>
<!--======================= End Top Left (Tumor) ===========================-->    
        <td width="20">&nbsp;</td>
<!--======================= Start Top Right (Strain) =======================-->    
        <c:set var="lbl" value="1"/>
        <td valign="top" width="49%">
            <table border="0" cellpadding=5 cellspacing=1 width="100%" class="results">
                <tr class="stripe1">
                    <td class="cat1">Strain</td>
                    <td class="data${(lbl%2)+1}">
                        <table border="0" cellspacing="2" align="left">
                            <tr>
                                <td class="enhance" colspan="2"><a href="strainDetails.do?key=${tumorFreq.strainKey}"><c:out value="${tumorFreq.strainName}" escapeXml="false"/></a></td>
                            </tr>

                        <c:if test="${not empty tumorFreq.strainTypes}">
                            <tr>
                                <c:choose>
                                <c:when test="${fn:length(tumorFreq.strainTypes)>1}">
                                    <td class="label"><span class="nowrap">Strain Types:</span> </td>
                                </c:when>
                                <c:otherwise>
                                    <td class="label"><span class="nowrap">Strain Type:</span> </td>
                                </c:otherwise>
                                </c:choose>
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
                                <td class="label"><span class="nowrap">General Note:</span> </td>
                                <td valign="top">${tumorFreq.strainNote}</td>
                            </tr>
                        </c:if>
                        </table>
                    </td>
                </tr>
            
                <c:set var="lbl" value="1"/>
                <c:choose>
                <c:when test="${not empty tumorFreq.strainSynonyms}">
                    <c:set var="lbl" value="${lbl == 1 ? 2 : 1}"/>
                    <tr class="stripe${lbl}">
                        <c:choose>
                        <c:when test="${fn:length(tumorFreq.strainSynonyms)>1}">
                            <td class="cat${lbl}">Strain Synonyms</td>
                        </c:when>
                        <c:otherwise>
                            <td class="cat${lbl}">Strain Synonym</td>
                        </c:otherwise>
                        </c:choose>
                        <td class="data${lbl}">
                            <c:forEach var="synonym" items="${tumorFreq.strainSynonyms}" varStatus="status">
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
    <table border="0" cellpadding=5 cellspacing=1 width="100%" class="results">
        <tr>
            <td class="resultsHeader">MTB ID</td>
            <td class="resultsHeader">Organ Affected</td>
            <td class="resultsHeader">Treatment Type<br><font size="-2"><i>Agents</i></font></td>
            <td class="resultsHeader">Strain Sex</td>
            <td class="resultsHeader">Reproductive Status</td>
            <td class="resultsHeader">Frequency</td>
            <td class="resultsHeader">Age Of<br>Onset</td>
            <td class="resultsHeader">Age Of<br>Detection</td>
            <td class="resultsHeader">Reference</td>
        </tr>
        <tr class="stripe1">
            <td>MTB:${tumorFreq.tumorFrequencyKey}</td>
            <td>
                <c:choose>
                <c:when test="${not empty tumorFreq.organAffected}">
                    <c:choose>
                    <c:when test="${tumorFreq.parentFrequencyKey>0}">
                        <font color="red">
                        <c:out value="${tumorFreq.organAffected}" escapeXml="false"/>
                        </font>
                    </c:when>
                    <c:otherwise>
                        <c:out value="${tumorFreq.organAffected}" escapeXml="false"/>
                    </c:otherwise>
                    </c:choose>
                </c:when>
                <c:otherwise>
                    &nbsp;
                    <!--There is no organ affected associated with this tumor frequency record . //-->
                </c:otherwise>
                </c:choose>
            </td>
            <td>
                <c:out value="${tumorFreq.treatmentType}" escapeXml="false"/>
                <c:choose>
                    <c:when test="${not empty tumorFreq.agents}">
                        <i>
                        <c:forEach var="agent" items="${tumorFreq.agents}" varStatus="status">
                            <font size="-2">
                            ${agent}
                            <c:if test="${status.last != true}">
                                <br>
                            </c:if>
                            </font>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <!--There are no agents associated with this tumorFreq. //-->
                    </c:otherwise>
                </c:choose>
            </td>
            <td><c:out value="${tumorFreq.strainSex}" default="&nbsp;" escapeXml="false"/></td>
            <td><c:out value="${tumorFreq.reproductiveStatus}" default="&nbsp;" escapeXml="false"/></td>
            <td>
                ${tumorFreq.frequencyString}
                <c:if test="${rec.numMiceAffected>=0&&rec.colonySize>=0}">
                    <br>
                    (${rec.numMiceAffected} of ${rec.colonySize} mice)
                </c:if>
            </td>
            <td><c:out value="${tumorFreq.ageOnset}" default="&nbsp;" escapeXml="false"/></td>
            <td><c:out value="${tumorFreq.ageDetection}" default="&nbsp;" escapeXml="false"/></td>
            <%--
            <td>
                <font size="-2">
                <c:choose>
                <c:when test="${tumorFreq.numImages>0&&(not empty(tumorFreq.pathologyRecs))}">
                    <a href="#pathology">Reports<br>and Images</a>
                </c:when>
                <c:when test="${tumorFreq.numImages>0&&(empty(tumorFreq.pathologyRecs))}">
                    <a href="#pathology">Images</a>
                </c:when>
                <c:when test="${tumorFreq.numImages<=0&&(not empty(tumorFreq.pathologyRecs))}">
                    <a href="#pathology">Reports</a>
                </c:when>
                <c:otherwise>
                    &nbsp;
                </c:otherwise>
                </c:choose>
                </font>
            </td>
            --%>
            <td>
                <c:choose>
                    <c:when test="${not empty tumorFreq.reference}">
                        <a href="referenceDetails.do?accId=${tumorFreq.reference}">${tumorFreq.reference}</a>
                    </c:when>
                    <c:otherwise>
                        &nbsp;
                        <!--There is no reference associated with this tumor frequency record . //-->
                    </c:otherwise>
                </c:choose>
            </td>
    </table>        
<!--======================= Start Tumor Genetics Section ===================-->    
    <c:choose>
    <c:when test="${not empty tumorFreq.tumorGenetics}">
        <br>
        <table border="0" cellpadding=5 cellspacing=1 width="100%" class="results">
            <tr>
                <td colspan="5" class="resultsHeaderLeft">
                    <font class="larger">Tumor Genetics</font>
                </td>
            </tr>
            <tr>
                <td class="headerLabel">Marker<br>Symbol</td>
                <td class="headerLabel">Marker<br>Name</td>
                <td class="headerLabel">Mouse<br>Chromosome</td>
                <td class="headerLabel">Mutation<br>Types</td>
                <td class="headerLabel">Genetic<br>Change</td>
            </tr>

                    <c:forEach var="genetics" items="${tumorFreq.tumorGenetics}" varStatus="status">
                        <c:choose>
                            <c:when test="${status.index%2==0}">
                                <tr class="stripe1">
                            </c:when>
                            <c:otherwise>
                                <tr class="stripe2">
                            </c:otherwise>
                        </c:choose>
                            <td>
                                <c:choose>
                                <c:when test="${not empty genetics.geneSymbol}">
                                    <c:choose>
                                        <c:when test="${fn:indexOf(genetics.geneSymbol, '+')<0}">
                                            <a href="redirect?key=${genetics.markerKey}&type=1" target="MGI"><c:out value="${genetics.geneSymbol}" escapeXml="false"/></a>
                                        </c:when>
                                        <c:otherwise>
                                            <c:out value="${genetics.geneSymbol}" escapeXml="false"/>
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                    &nbsp;
                                </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:out value="${genetics.geneName}" escapeXml="false"/>
                            </td>
                            <td align="center">
                                <c:out value="${genetics.chromosome}" escapeXml="false"/>
                            </td>
                            <td>
                                <c:out value="${genetics.alleleType}" escapeXml="false"/>
                            </td>
                            
                            <td>
                                <c:forEach var="row" items="${genetics.genotypes}" varStatus="status">
                                    ${row.allele1Symbol} / ${row.allele2Symbol}
                                </c:forEach>
                            
                            </td>
                        </tr>
                    </c:forEach>
        </table>
    </c:when>
    <c:otherwise>
        <!-- No genetics for this frequency record //-->
    </c:otherwise>
    </c:choose>
<!--======================= End Tumor Genetics Section =====================-->    
<!--======================= Start Additional Notes Records =================-->    
    <c:choose>
    <c:when test="${(not empty tumorFreq.additionalNotes) || (not empty tumorFreq.note)}">
        <br>
        <table border="0" cellpadding=5 cellspacing=1 width="100%" class="results">
            <tr>
                <td colspan="2" class="resultsHeaderLeft">
                    <font class="larger">Additional Notes</font>
                </td>
            </tr>
            <tr>
                <td class="resultsHeader">Note</td>
                <td class="resultsHeader">Reference</td>
            </tr>
            
            <c:set var="noteRow" value="2"/>
            
            <c:if test="${not empty tumorFreq.note}">
                <c:set var="noteRow" value="1"/>
                <tr class="stripe1">
                    <td><c:out value="${tumorFreq.note}"/></td>
                    <td><a href="referenceDetails.do?accId=${tumorFreq.reference}">${tumorFreq.reference}</a></td>
                </tr>
            </c:if>
            
            <c:forEach var="rec" items="${tumorFreq.additionalNotes}" varStatus="status">
                <c:set var="noteRow" value="${noteRow == 1 ? 2 : 1}"/>
                <tr class="stripe${noteRow}">
                    <td><c:out value="${rec.label}" escapeXml="false"/></td>
                    <td><a href="referenceDetails.do?key=${rec.data}">${rec.value}</a></td>
                </tr>
            </c:forEach>
        </table>
    </c:when>
    <c:otherwise>
        <!-- No notes for this frequency record //-->
    </c:otherwise>
    </c:choose>
<!--======================= End Additional Notes Records ===================-->    
<!--======================= Start Pathology Records ========================-->    
    <c:choose>
    <c:when test="${not empty tumorFreq.pathologyRecs}">
        <a name="pathology"><br></a>
        <table border="0" cellpadding=5 cellspacing=1 width="100%" class="results">
            <tr>
                <td colspan="4" class="resultsHeaderLeft">
                    <font class="larger">Pathology</font>
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <c:choose>
                    <c:when test="${tumorFreq.numPathologyRecs!=1}">
                        ${tumorFreq.numPathologyRecs} entries
                    </c:when>
                    <c:otherwise>
                        ${tumorFreq.numPathologyRecs} entry
                    </c:otherwise>
                    </c:choose>
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <c:choose>
                    <c:when test="${tumorFreq.numImages!=1}">
                        ${tumorFreq.numImages} images
                    </c:when>
                    <c:otherwise>
                        ${tumorFreq.numImages} image
                    </c:otherwise>
                    </c:choose>
                </td>
            </tr>
            <tr>
                <td class="resultsHeader">Age at Necropsy</td>
                <td class="resultsHeader">Description</td>
                <td class="resultsHeader">Notes</td>
                <td class="resultsHeader">Images</td>
            </tr>
            
            <c:set var="lbl" value="1"/>
            <c:set var="rowClass" value="stripe1"/>
            
            <c:forEach var="rec" items="${tumorFreq.pathologyRecs}" varStatus="status">

                <c:set var="lbl" value="${lbl+1}"/>
                <c:set var="rowClass" value="stripe${(lbl%2)+1}"/>
                <c:set var="rowSpan" value="${fn:length(rec.images)}"/>
                
                <c:if test="${rowSpan<1}">
                    <c:set var="rowSpan" value="1"/>
                </c:if>
                
                <tr class="${rowClass}">
            
                    <td rowspan="${rowSpan}" valign="top"><c:out value="${rec.ageAtNecropsy}" escapeXml="false" default="&nbsp;"/></td>
                    <td rowspan="${rowSpan}" valign="top"><c:out value="${rec.description}" escapeXml="false" default="&nbsp;"/></td>
                    <td rowspan="${rowSpan}" valign="top"><c:out value="${rec.note}" escapeXml="false" default="&nbsp;"/></td>
                    
                        <c:choose>
                        <c:when test="${not empty rec.images}">
                            <c:forEach var="image" items="${rec.images}" varStatus="status2">
                            
                                <c:if test="${status2.first!=true}">
                                    <tr class="${rowClass}">
                                </c:if>
                            
                            <td valign="top">                                
                                <table border=0 cellspacing=5 cellpadding=5>
                                    <tr>
                                        <td width="160">
                                            <a href="nojavascript.jsp" onClick="popPathWin('pathologyImageDetails.do?key=${image.imageId}', 'ImageID${image.imageId}');return false;">
                                            <img width="150" src="${image.imageUrl}/${image.imageUrlPath}/${image.imageThumbName}"></a>
                                        </td>
                                        <td valign="top" align="left">
                                            <table border=0 cellspacing=1 cellpadding=1 align="left">
                                                <tr>
                                                    <td class="small" align="right"><b>Image ID</b>:</td>
                                                    <td class="small">${image.imageId}</td>
                                                </tr>
                                                <tr>
                                                    <td class="small" align="right"><b>Source of Image</b>:</td>
                                                    <td class="small">
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
                                                    <td class="small" align="right"><b>Method / Stain</b>:</td>
                                                    <td class="small">${image.stainMethod}</td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="small" colspan=2>
                                            <b>Image Caption</b>:<br>
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
                            <td>&nbsp;</td>
                        </c:otherwise>
                        </c:choose>
            </c:forEach>
        </table>
    </c:when>
    <c:otherwise>
        <!-- There are no pathology records associated with this tumorFreq. -->
    </c:otherwise>
    </c:choose>
<!--======================= End Pathology Records ==========================-->    
<!--======================= End Detail Section =============================-->
<!--======================= End Main Section ===============================-->
        </td>
    </tr>
</table>
</td></tr></table>
</body>
</html> 
