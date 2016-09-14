<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic" %> 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<c:import url="../../meta.jsp">
    <c:param name="pageTitle" value="Quick Search Results"/>
</c:import>

</head>

<c:import url="../../body.jsp">
     <c:param name="pageTitle" value="Quick Search Results"/>
</c:import>

<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr>
        <td width="200" valign="top">
            <c:import url="../../toolBar.jsp" />
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
                       <a class="help" href="userHelp.jsp#interpreting"><img src="${applicationScope.urlImageDir}/help_large.png" border=0 width=32 height=32 alt="Help"></a>
                   </td>
                   <td width="60%" class="pageTitle">
                       Quick Search Results
                   </td>
                   <td width="20%" valign="middle" align="center">&nbsp;</td>
               </tr>
           </table>
       </td>
   </tr>
</table>
<!--======================= End Form Header ================================-->
<table border="0" cellpadding=5 width="100%">
<!--======================= Start Search Summary ===========================-->
    <tr class="summary">
        <td>
            <font class="label">Search Summary</font><br>
            <font class="label">Search For:</font> contains "${quickSearchTerm}"<br>
            <font class="label">In these sections:</font> ${searchSections}<br>
        </td>
    </tr>
<!--======================= End Search Summary =============================-->
</table>

<!--======================= Start Search Results List ======================-->
<table width="100%" border=0>
    <c:choose>
        <c:when test="${not empty data}">
            <c:forEach var="result" items="${data}" varStatus="status">
<!--======================= Start ${result.searchName} ==========================-->
                <tr>
                    <td>
                        <table border="0" cellpadding=5 cellspacing=1 width="100%" class="results">
                            <tr class="pageTitle">
                                <td>
                                    <table border="0" cellpadding=0 cellspacing=0 width="100%">
                                        <tr>
                                            <td class="resultsHeaderLeft">
                                                <font class="larger">${result.searchName}</font>
                                            </td>
                                            <td align="right">
                                                <a href="${result.mainSearchUrl}">${result.mainSearchName}</a>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        ${result.searchCriteriaText}
                    </td>
                </tr>
                <tr>
                    <td>
                        <c:choose>
                            <c:when test="${not empty result.searchResultsText}">
                                <c:choose>
                                    <c:when test="${fn:containsIgnoreCase(result.searchName, 'genetics')}">
                                        <table border="0" width="100%">
                                            <tr class="stripe1">
                                                <td class="data1">
                                                    ${result.searchResultsText}
                                                </td>
                                            </tr>
                                        </table>
                                    </c:when>
                                    <c:otherwise>
                                        <table border="0" cellpadding=5 cellspacing=1 width="100%" class="results">
                                            ${result.searchResultsText}
                                        </table>
                                    </c:otherwise>
                                </c:choose>
                            </c:when>
                            <c:otherwise>
                                &nbsp;
                            </c:otherwise>
                        </c:choose>
                        
                        <c:if test="${not fn:contains(result.searchResultsText, 'No results found')}">
                            <br>
                            <a href="${result.viewAllUrl}">All...</a>
                        </c:if>

                        <br><br><hr><br><br>
                    </td>
                </tr>
<!--======================= End ${result.searchName} ============================-->
            </c:forEach>
        </c:when>
        <c:otherwise>
            <!-- No results found. //-->
        </c:otherwise>
    </c:choose>
</table>
<!--======================= End Search Results List ========================-->
<!--======================== End Main Section ==============================-->
        </td>
    </tr>
</table>
</body>
</html> 
