<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<c:import url="../../../meta.jsp">
    <c:param name="pageTitle" value="Reference Tumor Type Associations"/>
</c:import>
</head>

<c:import url="../../../body.jsp">
     <c:param name="pageTitle" value="Reference Tumor Type Associations"/>
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
                       <a class="help" href="userHelp.jsp#referenceresults"><img src="${applicationScope.urlImageDir}/help_large.png" border=0 width=32 height=32 alt="Help"></a>
                   </td>
                   <td width="60%" class="pageTitle">
                       Reference Tumor Type Associations
                   </td>
                   <td width="20%" valign="middle" align="center">&nbsp;</td>
               </tr>
           </table>
       </td>
   </tr>
<!--======================= End Form Header ================================-->
<!--======================= Start Search Summary ===========================-->
    
    <tr class="summary">
        <td colspan="2" align="center">
            Probably put some reference details here
        </td>
<!--======================= Start Display Limit ============================-->
           <c:if test="${not empty tumorTypes}">
               
                <tr class="results">
            <td class="resultsHeader">Tumor Type</td>
            <td class="resultsHeader">Index Type</td>
        </tr>

        <c:forEach var="tt" items="${tumorTypes}" varStatus="status">
            <c:choose>
                <c:when test="${status.index%2==0}">
                    <tr class="stripe1">
                </c:when>
                <c:otherwise>
                    <tr class="stripe2">
                </c:otherwise>
            </c:choose>

                <td>${tt.label}</td>
                <td>${tt.value}</td>
                
            </tr>
        </c:forEach>
               
               
               
               
               
               
               
               
           </c:if>     
<!--======================= End Display Limit ==============================-->
        </td>
    </tr>
    
</table>
<!--======================== End Main Section ==============================-->
        </td>
    </tr>
</table>
</body>
</html> 



