<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
<c:import url="meta.jsp" />

<title>Server Information</title>
</head>
<body>

<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
<tr>
<td width="200" valign="top">
    <c:import url="toolBar.jsp" />
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
<table border="0" cellpadding=5 cellspacing=1 width="1000" class="results">
   <tr class="pageTitle">
       <td colspan="2" width="100%">
           <table width="100%" border=0 cellpadding=0 cellspacing=0>
               <tr>
                   <td width="20%" valign="middle" align="left">
                       <a class="help" href="userHelp.jsp"><img src="${applicationScope.urlImageDir}/help_large.png" border=0 width=32 height=32></a>
                   </td>
                   <td width="60%" class="pageTitle">
                       Server Information
                   </td>
                   <td width="20%" valign="middle" align="center">&nbsp;</td>
               </tr>
           </table>
       </td>
   </tr>
</table>
<!--======================= End Form Header ================================-->


<p>

<!--===================== Start JVM Information ============================-->
<table border="0" cellpadding=5 cellspacing=1 width="1000" class="results">
   <tr class="pageTitle">
       <td colspan="2">JVM Information</td>
   </tr>
<c:choose>
    <c:when test="${not empty jvm}">
        <tr>
            <td width="250" class="resultsHeader">Attribute</td>
            <td class="resultsHeader">Value</td>
        </tr>

        <c:forEach var="jvmItem" items="${jvm}" varStatus="status">
            <c:choose>
                <c:when test="${status.index%2==0}">
                    <tr class="stripe1">
                </c:when>
                <c:otherwise>
                    <tr class="stripe2">
                </c:otherwise>
            </c:choose>

                <td width="250">${jvmItem.label}</td>
                <td>${jvmItem.value}</td>
            </tr>
        </c:forEach>
    </c:when>
    <c:otherwise>
        <!-- No results found.  //-->
    </c:otherwise>
</c:choose>
</table>
<!--===================== End JVM Information ==============================-->

<p><p>

<!--===================== Start OS Information =============================-->
<table border="0" cellpadding=5 cellspacing=1 width="1000" class="results">
   <tr class="pageTitle">
       <td colspan="2">OS Information</td>
   </tr>
<c:choose>
    <c:when test="${not empty os}">
        <tr>
            <td width="250"  class="resultsHeader">Attribute</td>
            <td class="resultsHeader">Value</td>
        </tr>

        <c:forEach var="osInfoItem" items="${os}" varStatus="status">
            <c:choose>
                <c:when test="${status.index%2==0}">
                    <tr class="stripe1">
                </c:when>
                <c:otherwise>
                    <tr class="stripe2">
                </c:otherwise>
            </c:choose>

                <td width="250" >${osInfoItem.label}</td>
                <td>${osInfoItem.value}</td>
            </tr>
        </c:forEach>
    </c:when>
    <c:otherwise>
        <!-- No results found.  //-->
    </c:otherwise>
</c:choose>
</table>
<!--===================== End OS Information ===============================-->

<p><p>

<!--===================== Start System Property Information ================-->
<table border="0" cellpadding=5 cellspacing=1 width="1000" class="results">
   <tr class="pageTitle">
       <td colspan="2">System Properties</td>
   </tr>
<c:choose>
    <c:when test="${not empty sysProps}">
        <tr>
            <td width="250" class="resultsHeader">Attribute</td>
            <td class="resultsHeader">Value</td>
        </tr>

        <c:forEach var="itemVar" items="${sysProps}" varStatus="status">
            <c:choose>
                <c:when test="${status.index%2==0}">
                    <tr class="stripe1">
                </c:when>
                <c:otherwise>
                    <tr class="stripe2">
                </c:otherwise>
            </c:choose>

                <td width="250">${itemVar.label}</td>
                <td width="750">${itemVar.value}</td>
            </tr>
        </c:forEach>
    </c:when>
    <c:otherwise>
        <!-- No results found.  //-->
    </c:otherwise>
</c:choose>
</table>
<!--===================== End System Property Information ==================-->

<p><p>

<!--===================== Start Request Information ========================-->
<table border="0" cellpadding=5 cellspacing=1 width="1000" class="results">
   <tr class="pageTitle">
       <td colspan="2">Request Information</td>
   </tr>
    <tr class="stripe1">
        <td colspan="2">
        <%-- Use the request object to show the server port and protocol --%>        
        The current request was made on <b>port 
         <c:out value='${pageContext.request.serverPort}'/></b>	
        with this <b>protocol:
         <c:out value='${pageContext.request.protocol}'/></b>.<br>

         <%-- Use the request object to show the user's preferred locale --%>
         The request <b>locale</b> is 
         <b><c:out value='${pageContext.request.locale}'/>.</b>
        </td>
    </tr>
<c:choose>
    <c:when test="${not empty requestAttributes}">
        <tr>
            <td width="250" class="resultsHeader">Attribute</td>
            <td class="resultsHeader">Value</td>
        </tr>

        <c:forEach var="reqAtt" items="${requestAttributes}" varStatus="status">
            <c:choose>
                <c:when test="${status.index%2==0}">
                    <tr class="stripe1">
                </c:when>
                <c:otherwise>
                    <tr class="stripe2">
                </c:otherwise>
            </c:choose>

                <td width="250">${reqAtt.label}</td>
                <td>${reqAtt.value}</td>
            </tr>
        </c:forEach>
    </c:when>
    <c:otherwise>
        <!-- No results found.  //-->
    </c:otherwise>
</c:choose>
<c:choose>
    <c:when test="${not empty detailRequestInfo}">
        <c:forEach var="reqAttDetail" items="${detailRequestInfo}" varStatus="status">
            <c:choose>
                <c:when test="${status.index%2==0}">
                    <tr class="stripe1">
                </c:when>
                <c:otherwise>
                    <tr class="stripe2">
                </c:otherwise>
            </c:choose>

                <td width="250">${reqAttDetail.label}</td>
                <td>${reqAttDetail.value}</td>
            </tr>
        </c:forEach>
    </c:when>
    <c:otherwise>
        <!-- No results found.  //-->
    </c:otherwise>
</c:choose>
    
    
</table>
<!--===================== End Request Information ==========================-->

<p><p>

<!--===================== Start Response Information =======================-->
<table border="0" cellpadding=5 cellspacing=1 width="1000" class="results">
   <tr class="pageTitle">
       <td>Response Information</td>
   </tr>
    <tr class="stripe1">
        <td>
             The response <b>locale</b> is 
             <b><c:out value='${pageContext.response.locale}'/>.</b>

             <%-- Use the response object to show whether the response
                  has been committed --%>
             The <b>response
             <c:choose>
                <c:when test='${pageContext.response.committed}'>
                   has
                </c:when>

                <c:otherwise>
                   has not
                </c:otherwise>
             </c:choose>   
             </b> been committed.
        </td>
    </tr>
</table>
<!--===================== End Response Information =========================-->

<p><p>

<!--===================== Start Servlet Init Params Information ============-->
<table border="0" cellpadding=5 cellspacing=1 width="1000" class="results">
   <tr class="pageTitle">
       <td colspan="2">Servlet Initialization Parameters</td>
   </tr>
<c:choose>
    <c:when test="${not empty servletInitParams}">
        <tr>
            <td width="250" class="resultsHeader">Attribute</td>
            <td class="resultsHeader">Value</td>
        </tr>

        <c:forEach var="servletParamItem" items="${servletInitParams}" varStatus="status">
            <c:choose>
                <c:when test="${status.index%2==0}">
                    <tr class="stripe1">
                </c:when>
                <c:otherwise>
                    <tr class="stripe2">
                </c:otherwise>
            </c:choose>

                <td width="250">${servletParamItem.label}</td>
                <td>${servletParamItem.value}</td>
            </tr>
        </c:forEach>
    </c:when>
    <c:otherwise>
        <!-- No results found.  //-->
    </c:otherwise>
</c:choose>
</table>
<!--===================== End Servlet Init Params Information ==============-->

<p><p>

<!--===================== Start Context Information ========================-->
<table border="0" cellpadding=5 cellspacing=1 width="1000" class="results">
   <tr class="pageTitle">
       <td colspan="2">Context Attributes</td>
   </tr>
<c:choose>
    <c:when test="${not empty contextAttributes}">
        <tr>
            <td width="250" class="resultsHeader">Attribute</td>
            <td class="resultsHeader">Value</td>
        </tr>

        <c:forEach var="contextAtt" items="${contextAttributes}" varStatus="status">
            <c:choose>
                <c:when test="${status.index%2==0}">
                    <tr class="stripe1">
                </c:when>
                <c:otherwise>
                    <tr class="stripe2">
                </c:otherwise>
            </c:choose>

                <td width="250">${contextAtt.label}</td>
                <td>${contextAtt.value}</td>
            </tr>
        </c:forEach>
    </c:when>
    <c:otherwise>
        <tr class="stripe1">
            <td colspan="2">No context information</td>
        </tr>
    </c:otherwise>
</c:choose>
</table>
<!--===================== End Context Information ==========================-->

<p><p>

<!--===================== Start Session Information ========================-->
<table border="0" cellpadding=5 cellspacing=1 width="1000" class="results">
   <tr class="pageTitle">
       <td colspan="2">Session Information</td>
   </tr>
    <tr class="stripe1">
        <td colspan="2">
            Session ID: 
            <b><c:out value='${pageContext.session.id}'/></b><br>
            Max Session Inactive Interval:<b>
            <c:out  value='${pageContext.session.maxInactiveInterval}'/> 
            </b>seconds.
        </td>
    </tr>
<c:choose>
    <c:when test="${not empty sessionInfo}">
        <tr>
            <td width="250" class="resultsHeader">Attribute</td>
            <td class="resultsHeader">Value</td>
        </tr>

        <c:forEach var="sessInfoItem" items="${sessionInfo}" varStatus="status">
            <c:choose>
                <c:when test="${status.index%2==0}">
                    <tr class="stripe1">
                </c:when>
                <c:otherwise>
                    <tr class="stripe2">
                </c:otherwise>
            </c:choose>

                <td width="250">${sessInfoItem.label}</td>
                <td>${sessInfoItem.value}</td>
            </tr>
        </c:forEach>
    </c:when>
    <c:otherwise>
        <!-- No results found.  //-->
    </c:otherwise>
</c:choose>
</table>
<!--===================== End Session Information ==========================-->

<p><p>

<!--===================== Start Application Information ====================-->
<table border="0" cellpadding=5 cellspacing=1 width="1000" class="results">
   <tr class="pageTitle">
       <td colspan="2">Application Information</td>
   </tr>
    <tr class="stripe1">
        <td colspan="2">
            <%-- Store the servlet context in a page-scoped variable
                  named app for better readability --%>
             <c:set var='app' value='${pageContext.servletContext}'/>

             <%-- Use the application object to show the major and minor 
                  versions of the servlet API that the container supports --%>
             Your servlet container supports version<b> 
             <c:out  value='${app.majorVersion}.${app.minorVersion}'/></b>
             of the servlet API.
        </td>
    </tr>
    <tr class="stripe2">
        <td width="250">Servlet Specification</td>
        <td>${servletSpec}</td>
    </tr>
    <tr class="stripe1">
        <td width="250">JSP Specification</td>
        <td>${jspSpec}</td>
    </tr>
</table>
<!--===================== End Application Information ======================-->

<p><p>

<!--===================== Start JSTL Headers Information ===================-->
<%-- Loop over the JSTL headerValues implicit object,
     which is a map --%>
<table border="0" cellpadding=5 cellspacing=1 width="1000" class="results">
   <tr class="pageTitle">
       <td colspan="2">
           JSTL Header Values
       </td>
   </tr>
    <tr>
        <td class="resultsHeader">Name</td>
        <td class="resultsHeader">Value</td>
    </tr>
<c:forEach items='${headerValues}' var='hv' varStatus="status">
    <c:choose>
        <c:when test="${status.index%2==0}">
            <tr class="stripe1">
        </c:when>
        <c:otherwise>
            <tr class="stripe2">
        </c:otherwise>
    </c:choose>
      <%-- Display the key of the current item; that item
           is a Map.Entry --%>
      <td width="250"><c:out value='${hv.key}'/></td>
      <td>
          <%-- The value of the current item, which is
               accessed with the value method from 
               Map.Entry, is an array of strings 
               representing request header values, so
               we iterate over that array of strings --%>
          <c:forEach items='${hv.value}' var='value'>
               <c:out value='${value}'/><br>
          </c:forEach>
      </td>
   </tr>
</c:forEach>
</table>         
<!--===================== End JSTL Headers Information =====================-->

<p><p>

<!--===================== Start Header Information =========================-->
<table border="0" cellpadding=5 cellspacing=1 width="1000" class="results">
   <tr class="pageTitle">
       <td colspan="2">Header Information</td>
   </tr>
<c:choose>
    <c:when test="${not empty headers}">
        <tr>
            <td width="250" class="resultsHeader">Attribute</td>
            <td class="resultsHeader">Value</td>
        </tr>

        <c:forEach var="headerItem" items="${headers}" varStatus="status">
            <c:choose>
                <c:when test="${status.index%2==0}">
                    <tr class="stripe1">
                </c:when>
                <c:otherwise>
                    <tr class="stripe2">
                </c:otherwise>
            </c:choose>

                <td width="250">${headerItem.label}</td>
                <td>${headerItem.value}</td>
            </tr>
        </c:forEach>
    </c:when>
    <c:otherwise>
        <!-- No results found.  //-->
    </c:otherwise>
</c:choose>
</table>
<!--===================== End Header Information ===========================-->

<p><p>

<!--===================== Start Param Names Information ====================-->
<table border="0" cellpadding=5 cellspacing=1 width="1000" class="results">
   <tr class="pageTitle">
       <td colspan="2">Param Names</td>
   </tr>
<c:choose>
    <c:when test="${not empty paramNames}">
        <tr>
            <td width="250" class="resultsHeader">Attribute</td>
            <td class="resultsHeader">Value</td>
        </tr>

        <c:forEach var="paramNamesItem" items="${paramNames}" varStatus="status">
            <c:choose>
                <c:when test="${status.index%2==0}">
                    <tr class="stripe1">
                </c:when>
                <c:otherwise>
                    <tr class="stripe2">
                </c:otherwise>
            </c:choose>

                <td width="250">${paramNamesItem.label}</td>
                <td>${paramNamesItem.value}</td>
            </tr>
        </c:forEach>
    </c:when>
    <c:otherwise>
        <tr class="stripe1">
            <td colspan="2">No param name information</td>
        </tr>
    </c:otherwise>
</c:choose>
</table>
<!--===================== End Param Names Information ======================-->

<p><p>

<!--===================== Start Cookie Information =========================-->
<table border="0" cellpadding=5 cellspacing=1 width="1000" class="results">
   <tr class="pageTitle">
       <td colspan="2">Cookie Information</td>
   </tr>
<c:choose>
    <c:when test="${not empty cookies}">
        <tr>
            <td width="250" class="resultsHeader">Attribute</td>
            <td class="resultsHeader">Value</td>
        </tr>

        <c:forEach var="cookiesItem" items="${cookies}" varStatus="status">
            <c:choose>
                <c:when test="${status.index%2==0}">
                    <tr class="stripe1">
                </c:when>
                <c:otherwise>
                    <tr class="stripe2">
                </c:otherwise>
            </c:choose>

                <td width="250">${cookiesItem.label}</td>
                <td>${cookiesItem.value}</td>
            </tr>
        </c:forEach>
    </c:when>
    <c:otherwise>
        <tr class="stripe1">
            <td colspan="2">No cookie information</td>
        </tr>
    </c:otherwise>
</c:choose>
</table>
<!--===================== End Cookie Information ===========================-->


<!--======================== End Main Section ==============================-->

            </td>
        </tr>
    </table>

    </body>
</html> 



