<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<c:import url="../../../meta.jsp">
    <c:param name="pageTitle" value="Genetic Change Summary"/>
</c:import>
</head>

<c:import url="../../../body.jsp">
    <c:param name="pageTitle" value="Genetic Change Summary"/>
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
                       <a class="help" href="userHelp.jsp#geneticchange"><img src="${applicationScope.urlImageDir}/help_large.png" border=0 width=32 height=32 alt="Help"></a>
                   </td>
                   <td width="60%" class="pageTitle">
                       Genetic Markers analyzed in the Tumor Summary
                   </td>
                   <td width="20%" valign="middle" align="center">&nbsp;</td>
               </tr>
           </table>
       </td>
   </tr>
<!--======================= End Form Header ================================-->
<!--======================= Start Genetics Summary Header ==================-->
    <tr class="stripe1">
        <td class="cat1">Gene Symbol</td>
        <td class="data1">
            <c:out value="${genetics.geneSymbol}" escapeXml="false"/>
        </td>
    </tr>
    <tr class="stripe2">
        <td class="cat2">Gene Name</td>
        <td class="data2">
            <c:out value="${genetics.geneName}" escapeXml="false"/>
        </td>
    </tr>
    <tr class="stripe1">
        <td class="cat1">Mouse Chromosome</td>
        <td class="data1">
            <c:out value="${genetics.mouseChromosome}" escapeXml="false"/>
        </td>
    </tr>
    <tr class="stripe2">
        <td class="cat2">Genetic Change Type</td>
        <td class="data2">
            <c:out value="${genetics.geneticChangeTypeName}" escapeXml="false"/>
        </td>
    </tr>
</table>
<!--======================= End Genetics Summary Header ====================-->
<br>
<!--======================= Start Search Results List ======================-->
<c:choose>
    <c:when test="${not empty genetics.alleleRecs}">
        <table border="0" cellpadding=5 cellspacing=1 width="100%" class="results">
            <tr class="results">
                <td class="resultsHeader">Mutation Location</td>
                <td class="resultsHeader">Tumor Name</td>
                <td class="resultsHeader">Treatment Type</td>
                <td class="resultsHeader">Number of Associated Tumor Frequencies</td>
            </tr>

            <c:set var="names" value="${genetics.names}"/>
            <c:set var="mutationSymbols" value="${genetics.mutationSymbols}"/>
            <c:set var="counter" value="0"/>
            <c:set var="items" value="0"/>

            <c:forEach var="rec" items="${genetics.alleleRecs}" varStatus="status">
                <c:set var="key" value="${rec.key}"/>
                <c:set var="counter" value="${counter+1}"/>

                <c:choose>
                    <c:when test="${status.index%2==0}">
                        <c:set var="classVal" value="stripe1"/>
                    </c:when>
                    <c:otherwise>
                        <c:set var="classVal" value="stripe2"/>
                    </c:otherwise>
                </c:choose>

                <tr class="${classVal}">

                <c:choose>
                    <c:when test="${fn:length(rec.value.recsCollection)>1}">
                        <td valign="top" rowspan="${fn:length(rec.value.recsCollection)}">
                            ${mutationSymbols[key]}
                            <c:if test="${not empty names[key]}">
                                <br><font size="-2"><i>${names[key]}</i></font>
                            </c:if>
                        </td>
                    </c:when>
                    <c:otherwise>
                        <td valign="top">
                            ${mutationSymbols[key]}
                            <c:if test="${not empty names[key]}">
                                <br><font size="-2"><i>${names[key]}</i></font>
                            </c:if>
                        </td>
                    </c:otherwise>
                </c:choose>

                <c:forEach var="subRec" items="${rec.value.recsCollection}" varStatus="status">
                    <c:if test="${status.index!=0}">
                        <tr class="${classVal}">
                    </c:if>
                    <c:set var="items" value="${items + 1}"/>

                    <td valign="top">${subRec.tumorName}</td>
                    <td valign="top">${subRec.agentType}</td>
                    <td valign="top">(<a href="tumorSearchResults.do?allelePairKey=${subRec.allelePairKey}&amp;organTissueOrigin=${subRec.organKey}&amp;tumorClassification=${subRec.tumorClassificationKey}&amp;agentType=${subRec.agentTypeKey}&amp;maxItems=No+Limit">${subRec.count}</a>)</td>
                    </tr>
                </c:forEach>
            </c:forEach>
        </table>

<%--
<pre>
+---------------------+
Debug Information
+---------------------+
Rows: ${counter}
Total Items: ${items}
+---------------------+
</pre>
--%>

    </c:when>
    <c:otherwise>
        No summary information found.
    </c:otherwise>
</c:choose>
<!--======================= End Search Results List ========================-->
<!--======================== End Main Section ==============================-->
        </td>
    </tr>
</table>
</td></tr></table>
</body>
</html>



