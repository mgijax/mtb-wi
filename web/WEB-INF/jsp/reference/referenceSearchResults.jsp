<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<c:import url="../../../meta.jsp">
    <c:param name="pageTitle" value="Reference Search Results"/>
</c:import>
</head>

<c:import url="../../../body.jsp">
     <c:param name="pageTitle" value="Reference Search Results"/>
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
       <td colspan="2" width="100%">
           <table width="100%" border=0 cellpadding=0 cellspacing=0>
               <tr>
                   <td width="20%" valign="middle" align="left">
                       <a class="help" href="userHelp.jsp#referenceresults"><img src="${applicationScope.urlImageDir}/help_large.png" border=0 width=32 height=32 alt="Help"></a>
                   </td>
                   <td width="60%" class="pageTitle">
                       Reference Search Results
                   </td>
                   <td width="20%" valign="middle" align="center">&nbsp;</td>
               </tr>
           </table>
       </td>
   </tr>
<!--======================= End Form Header ================================-->
<!--======================= Start Search Summary ===========================-->
    <tr class="summary">
        <td colspan="2">
            <font class="label">Search Summary</font><br>

            <c:if test="${not empty accId}">
                <font class="label">Accession Id:</font> ${accId}<br>
            </c:if>
            
            <c:if test="${not empty firstAuthor}">
                <font class="label">First Author:</font> ${firstAuthorComparison} "${firstAuthor}"<br>
            </c:if>
            
            <c:if test="${not empty authors}">
                <font class="label">Authors:</font> Contains "${authors}"<br>
            </c:if>
            
            <c:if test="${not empty journal}">
                <font class="label">Journal:</font> ${journalComparison} "${journal}"<br>
            </c:if>
            
            <c:if test="${not empty year}">
                <font class="label">Year:</font> ${yearComparison} ${year}<br>
            </c:if>
            
            <c:if test="${not empty volume}">
                <font class="label">Volume:</font> ${volumeComparison} "${volume}"<br>
            </c:if>
            
            <c:if test="${not empty pages}">
                <font class="label">Pages:</font> ${pagesComparison} "${pages}"<br>
            </c:if>
            
            <c:if test="${not empty title}">
                <font class="label">Title:</font> ${titleComparison} "${title}"<br>
            </c:if>
            
            
            <%--
            <c:if test="${not empty abstract}">
                <b>Abstract:</b> contains ${abstract}<br>
            </c:if>
            --%>
            
            <font class="label">Sort By:</font> ${sortBy}<br>
            <font class="label">Display Limit:</font> ${maxItems} 
        </td>
    </tr>
    <tr class="summary">
        <td colspan="2">
<!--======================= Start Display Limit ============================-->
            <c:choose>
                <c:when test="${numberOfResults != totalResults}">
                    ${numberOfResults} of ${totalResults} matching items displayed.
                </c:when>
                <c:otherwise>
                    <c:out value="${numberOfResults}" default="0"/> matching items displayed.
                </c:otherwise>
            </c:choose>
<!--======================= End Display Limit ==============================-->
        </td>
    </tr>
<!--======================= End Search Summary =============================-->
<!--======================= Start Results ==================================-->
<c:choose>
    <c:when test="${not empty references}">
        <tr class="results">
            <td class="resultsHeader">Accession Id</td>
            <td class="resultsHeader">Reference</td>
        </tr>

        <c:forEach var="reference" items="${references}" varStatus="status">
            <c:choose>
                <c:when test="${status.index%2==0}">
                    <tr class="stripe1">
                </c:when>
                <c:otherwise>
                    <tr class="stripe2">
                </c:otherwise>
            </c:choose>

                <td><a href="referenceDetails.do?key=${reference.key}">${reference.accId}</a></td>
                <td>${reference.authors}, ${reference.title}, ${reference.citation}</td>
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



