<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib uri="http://tumor.informatics.jax.org/mtbwi/MTBWebUtils" prefix="wu" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<c:import url="../../../meta.jsp">
    <c:param name="pageTitle" value="Strain Search Results"/>
</c:import>
</head>
<c:import url="../../../body.jsp">
     <c:param name="pageTitle" value="Strain Search Results"/>
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
       <td colspan="3" width="100%">
           <table width="100%" border=0 cellpadding=0 cellspacing=0>
               <tr>
                   <td width="20%" valign="middle" align="left">
                       <a class="help" href="userHelp.jsp#straindetail"><img src="${applicationScope.urlImageDir}/help_large.png" border=0 width=32 height=32 alt="Help"></a>
                   </td>
                   <td width="60%" class="pageTitle">
                       Strain Search Results
                   </td>
                   <td width="20%" valign="middle" align="center">&nbsp;</td>
               </tr>
           </table>
       </td>
   </tr>
<!--======================= End Form Header ================================-->
<!--======================= Start Search Summary ===========================-->
    <tr class="summary">
        <td colspan="3">
            <font class="label">Search Summary</font><br>

            <c:if test="${not empty strainName}">
                <font class="label">Strain Name:</font> ${strainComparison} "${strainName}"<br>
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
                <font class="label">Gene or Allele</font> <i>(Symbol/Name/Synonym)</i>: Contains "${geneticName}"<br>
            </c:if>
            
            <%--
            <c:if test="${not empty strainNotes}">
                <b>Strain Notes:</b> contains ${strainNotes}<br>
            </c:if>
            --%>
            
            <c:if test="${not empty sites}">
                <font class="label">Other Database Links:</font> ${sites}<br>
            </c:if>
            
            <c:if test="${not empty jaxMiceStockNumber}">
                <font class="label">JAX<sup>&reg;</sup>Mice Stock No.:</font> ${jaxMiceStockNumber}<br>
            </c:if>
            
            <c:if test="${not empty accId}">
                <font class="label">Accession ID:</font> ${accId}<br>
            </c:if>
            
            <font class="label">Sort By:</font> ${sortBy}<br>
            <font class="label">Display Limit:</font> ${maxItems}
        </td>
    </tr>
    <tr class="summary">
        <td colspan="3">
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
    <c:when test="${not empty strains}">
        <tr>
            <td class="resultsHeader">Strain Name</td>
            <td class="resultsHeader" width="210">Strain Type</td>
            <td class="resultsHeader">Strain Notes</td>
        </tr>

        <c:forEach var="strain" items="${strains}" varStatus="status">
            <c:choose>
                <c:when test="${status.index%2==0}">
                    <tr class="stripe1">
                </c:when>
                <c:otherwise>
                    <tr class="stripe2">
                </c:otherwise>
            </c:choose>
                <td><a href="strainDetails.do?page=collapsed&amp;key=${strain.key}"><c:out value="${strain.name}" escapeXml="false"/></a></td>
                <td>
                    <c:forEach var="strainType" items="${strain.types}" varStatus="status">
                        ${strainType}
                        <c:if test="${status.last != true}">
                            &amp;<br>
                        </c:if>
                    </c:forEach>
                </td>
                <td><c:out value="${strain.description}" default="&nbsp;" escapeXml="false"/></td>
            </tr>
        </c:forEach>
    </c:when>
    <c:otherwise>
        <!-- No results found.  //-->
    </c:otherwise>
</c:choose>
<!--======================= End Results ====================================-->
</table>
<!--======================== End Main Section ==============================-->
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</body>
</html> 
