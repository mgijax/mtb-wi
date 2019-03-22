<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib uri="http://tumor.informatics.jax.org/mtbwi/MTBWebUtils" prefix="wu" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<c:import url="../../../meta.jsp">
    <c:param name="pageTitle" value="Strain Tumor Overview (Expanded View)"/>
</c:import>
</head>

<c:import url="../../../body.jsp">
     <c:param name="pageTitle" value="Strain Tumor Overview (Expanded View)"/>
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
                       <a class="help" href="userHelp.jsp#straindetail"><img src="${applicationScope.urlImageDir}/help_large.png" border=0 width=32 height=32 style="vertical-align:middle" alt="Help">Help and Documentation</a>
                   </td>
                   <td width="60%" class="pageTitle">
                       Strain Tumor Overview<br><div class="normal">Expanded View</div>
                   </td>
                   <td width="20%" valign="middle" align="center">
                       &nbsp;
                   </td>
               </tr>
           </table>
       </td>
   </tr>
<!--======================= End Form Header ================================-->
<!--======================= Start Detail Section ===========================-->
<!--======================= Start Strain Header ============================-->
    <tr class="stripe1">
        <td class="cat1">
            Strain
        </td>
        <td class="data1">
            <table border="0" width="100%">
                <tr>
                    <td width="70%">
                        <table border="0" cellspacing="2">
                            <tr>
                                <td class="enhance" colspan="2"><c:out value="${strain.name}" escapeXml="false"/></td>
                            </tr>
<!--======================= Start Strain Synonyms ==========================-->
                            <c:choose>
                            <c:when test="${not empty strain.synonyms}">
                                <tr>
                                    <td class="label" valign="top">Strain Synonyms</td>
                                    <td>
                                        <c:forEach var="synonym" items="${strain.synonyms}" varStatus="status">
                                        <c:out value="${synonym.name}" escapeXml="false"/>
                                            <c:if test="${status.last != true}">
                                                &nbsp;&#8226;&nbsp;
                                            </c:if>
                                        </c:forEach>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <!-- There are no synonyms associated with this strain. -->
                            </c:otherwise>
                            </c:choose>
  
                        <c:if test="${not empty strain.description}">
                            <tr>
                                <td class="label" valign="top">Strain Note: </td>
                                <td valign="top">${strain.description}</td>
                            </tr>
                        </c:if>
                        </table>
                    </td>
                    <td width="30%" valign="top" align="right">
                        <a href="strainDetails.do?page=collapsed&amp;key=${strain.strainKey}">Strain Tumor Overview Collapsed View</a>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
<!--======================= End Strain Header ==============================-->
    <c:set var="num" value="1"/>

<!--======================= Start Strain Tumors ============================-->
    <c:choose>
    <c:when test="${not empty strain.tumors}">
        <c:set var="num" value="${num == 1 ? 2 : 1}"/>
        <tr class="stripe${num}">
            <td class="cat${num}">Tumors</td>
            <td class="data${num}">
                <c:set var="statsBean" value="${strain.tumorStats}"/>
                ${statsBean.label} unique tumor sub-types displayed. <!-- representing ${statsBean.value} tumor detail records. -->
                <br><br>
                <i>A tumor sub-type is a set of tumors that share the same tumor name, organ affected, treatment agent, and metastatic status/localization.</i>
                <br><br>
                <table border="0" cellpadding=5 cellspacing=1 width="100%" class="results">
                    <tr>
                        <td class="headerLabel">Tumor Name</td>
                        <td class="headerLabel">Organ(s) Affected</td>
                        <td class="headerLabel">Treatment Type<br><font size="-2"><i>Agents</i></font></td>
                        <td class="headerLabelSmall">Metastasizes<br>To</td>
                        <td class="headerLabel">References</td>
                        <td class="headerLabel">Number of<br>Tumor Sub-type Records</td>
                        <td class="headerLabel">Frequency Range</td>
                    </tr>
                    <c:forEach var="tumor" items="${strain.tumors}" varStatus="status">
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
                                <c:if test="${not empty tumor.agents}">
                                    <br>
                                    <font size="-2"><i>
                                    <c:forEach var="agent" items="${tumor.agents}" varStatus="status">
                                        <c:out value="${agent}" escapeXml="false"/>
                                        <c:if test="${status.last != true}">
                                            <br>
                                        </c:if>
                                    </c:forEach>
                                    </i></font> 
                                </c:if>
                            </td>
                            <td>
                                <c:choose>
                                <c:when test="${not empty tumor.metastasizesToDisplay}">
                                    <c:forEach var="organ" items="${tumor.metastasizesToDisplay}" varStatus="status">
                                        ${organ}
                                        <c:if test="${status.last != true}">
                                            <br>
                                        </c:if>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    &nbsp;
                                </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                <c:when test="${not empty tumor.sortedRefAccIds}">
                                    <c:forEach var="ref" items="${tumor.sortedRefAccIds}" varStatus="status">
                                        <a href="referenceDetails.do?accId=${ref}">${ref}</a>
                                        <c:if test="${status.last != true}">
                                            <br>
                                        </c:if>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    &nbsp;
                                </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                               <a href="tumorSummary.do?strainKey=${tumor.strainKey}&amp;organOfOriginKey=${tumor.organOfOriginKey}&amp;tumorFrequencyKeys=${tumor.allTFKeysAsParams}">${tumor.numberTFRecords}</a>
                            </td>
                            <td><c:out value="${tumor.freqAllString}" escapeXml="false"/></td>
                        </tr>
                    </c:forEach>
                </table>
            </td>
        </tr>
    </c:when>
    <c:otherwise>
        <!-- There is no tumor information associated with this strain. -->
    </c:otherwise>
    </c:choose>
<!--======================= End Strain Tumors ==============================-->

<!--======================= Start Other Database Links =====================-->
    <c:choose>
    <c:when test="${not empty strain.links || not empty strain.linksGeneral}">
        <c:set var="num" value="${num == 1 ? 2 : 1}"/>
        <tr class="stripe${num}">
            <td class="cat${num}">Other Database Links</td>
            <td class="data${num}">
                <table border="0" cellpadding=5 cellspacing=1 width="100%" class="results">
                    <c:choose>
                    <c:when test="${not empty strain.links}">
                        <tr>
                            <td class="headerLabel" colspan=2><b>Additional information about these mice:</b></td>
                        </tr>
                        <c:forEach var="link" items="${strain.links}" varStatus="status">
                            <c:choose>
                                <c:when test="${status.index%2==0}">
                                    <tr class="stripe1">
                                </c:when>
                                <c:otherwise>
                                    <tr class="stripe2">
                                </c:otherwise>
                            </c:choose>
                            <%--
                            <td><a href="${link.siteUrl}" target="${link.siteName}"><c:out value="${link.siteName}" escapeXml="false"/></a></td>
                            --%>
                            <td><c:out value="${link.siteName}" escapeXml="false"/></td>
                            <td><a href="${link.accessionUrl}" target="${link.siteName}"><c:out value="${link.accessionUrl}" escapeXml="false"/></a></td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <!-- There are is no additional information associated with this strain. -->
                    </c:otherwise>
                    </c:choose>

                    <c:choose>
                    <c:when test="${not empty strain.linksGeneral}">
                        <tr>
                            <td class="headerLabel" colspan=2><b>Information about mice carrying the same mutant allele(s):</b></td>
                        </tr>
                        <c:forEach var="linkGeneral" items="${strain.linksGeneral}" varStatus="status">
                            <c:choose>
                                <c:when test="${status.index%2==0}">
                                    <tr class="stripe1">
                                </c:when>
                                <c:otherwise>
                                    <tr class="stripe2">
                                </c:otherwise>
                            </c:choose>
                           
                               <td><a href="${linkGeneral.siteUrl}" target="${linkGeneral.siteName}"><c:out value="${linkGeneral.siteName}" escapeXml="false"/></a></td>
                            <td><a href="${linkGeneral.accessionUrl}" target="${linkGeneral.siteName}"><c:out value="${linkGeneral.accessionUrl}" escapeXml="false"/></a></td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <!-- There are no other database links associated with this strain. //-->
                    </c:otherwise>
                    </c:choose>
                </table>
            </td>
        </tr>
    </c:when>
    <c:otherwise>
        <!-- There are no other database links associated with this strain. -->
    </c:otherwise>
    </c:choose>
<!--======================= End Other Database Links =======================-->

</table>
<!--======================= End Detail Section =============================-->
<!--======================== End Main Section ==============================-->
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</body>
</html> 



