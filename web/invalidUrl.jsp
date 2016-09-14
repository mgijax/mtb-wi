<%@ page language="java" isErrorPage="true" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>

<c:import url="meta.jsp">
    <c:param name="pageTitle" value="MTB Invalid Url"/>
</c:import>

</head>

<c:import url="body.jsp">
     <c:param name="pageTitle" value="MTB Invalid Url"/>
</c:import>

<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr>
        <td width="200" valign="top">
            <c:import url="toolBar.jsp" />
        </td>
        <td bgcolor="#888888">
            <img src="img/pixel.gif" width="1" height="100%">
        </td>
        <td valign="top">
            <table width="95%" align="center" border="0" cellspacing="1" cellpadding="4">
                <tr>
                    <td>

<!--======================= Start Main Section =============================-->
<table border="0" cellpadding=5 cellspacing=1 width="100%" class="results">
   <tr class="pageTitle">
       <td colspan="2" width="100%">
           <table width="100%" border=0 cellpadding=0 cellspacing=0>
               <tr>
                   <td width="20%" valign="middle" align="left">
                       <a class="help" href="userHelp.jsp"><img src="${applicationScope.urlImageDir}/help_large.png" border=0 width=32 height=32></a>
                   </td>
                   <td width="60%" class="pageTitle">
                       Invalid URL
                   </td>
                   <td width="20%" valign="middle" align="center">&nbsp;</td>
               </tr>
           </table>
       </td>
   </tr>
</table>

<p>
If you arrived here from a bookmark generated from a previous version of MTB, 
those URLs are no longer valid. Please perform your search again using the 
search forms to the left.
</p>

<hr>

If you need assistance searching the new version of MTB or coding URL links to 
specific data in the database please contact <a href="http://www.informatics.jax.org/mgihome/support/mgi_inbox.shtml">User Support</a>. 

<!--

<jsp:useBean id="now" class="java.util.Date" />

<b>Time</b>: ${now}

<pre>
Error Details
================================================================================
Time: ${now}
Status Code: ${pageContext.errorData.statusCode}
Request URL:  <%= request.getRequestURL() %>
Request URI:  <%= request.getRequestURI() %>
Server Name:  <%= request.getServerName() %>
Server Port:  <%= request.getServerPort() %>
URI: ${pageContext.errorData.requestURI}
Servlet Name: ${pageContext.errorData.servletName}
Path Info:  <%= request.getPathInfo() %>
Path Translated:  <%= request.getPathTranslated() %>
Servlet Path:  <%= request.getServletPath() %>
Context Path:  <%= request.getContextPath() %>
Content Type:  <%= request.getContentType() %>
Content Length:  <%= request.getContentLength() %>
Query String:  <%= request.getQueryString() %>
Message: <%= request.getAttribute("javax.servlet.error.message") %>
Exception: <%= request.getAttribute("javax.servlet.error.exception") %>
Exception Type: <%= request.getAttribute("javax.servlet.error.exception_type") %>

Headers
================================================================================
Protocol: <%= request.getProtocol() %>
Method: <%= request.getMethod() %>
<%
    java.util.Enumeration names = request.getHeaderNames();
    while (names.hasMoreElements()) {
        String name = (String)names.nextElement();
        out.println(name +": " + request.getHeader(name));
    }
%>
</pre>

//-->

<!--======================== End Main Section ==============================-->

        </td>
    </tr>
</table>

</body>
</html> 



