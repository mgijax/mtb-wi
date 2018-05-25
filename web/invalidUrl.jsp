<%@ page language="java" isErrorPage="true" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<jax:mmhcpage title="Invalid URL" help="#">

<table class="results">

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

<strong>Time</strong>: ${now}

<pre>
Error Details
================================================================================
Time: ${now}
Status Code: ${pageContext.errorData.statusCode}
Request URL:	<%= request.getRequestURL() %>
Request URI:	<%= request.getRequestURI() %>
Server Name:	<%= request.getServerName() %>
Server Port:	<%= request.getServerPort() %>
URI: ${pageContext.errorData.requestURI}
Servlet Name: ${pageContext.errorData.servletName}
Path Info:	<%= request.getPathInfo() %>
Path Translated:	<%= request.getPathTranslated() %>
Servlet Path:	<%= request.getServletPath() %>
Context Path:	<%= request.getContextPath() %>
Content Type:	<%= request.getContentType() %>
Content Length:	<%= request.getContentLength() %>
Query String:	<%= request.getQueryString() %>
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

</jax:mmhcpage>

