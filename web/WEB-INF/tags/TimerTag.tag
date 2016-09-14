<%@tag description = "Simple Timer Tag" pageEncoding="UTF-8"%>

<%-- Taglib directives can be specified here: --%>
<%--
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
--%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%-- The list of normal or fragment attributes can be specified here: --%>
<%--
<%@attribute name="example" required="true"%>
--%>
<%@attribute name="title" required="false"%>

<%-- Use expression language to work with normal attributes or use --%>
<%-- the <jsp:invoke> or <jsp:doBody> actions to invoke JSP fragments or tag body: --%>

<c:set var="TimerStartTime" value="<%=Long.toString(System.currentTimeMillis())%>"/>

<jsp:doBody/>

<c:set var="TimerEndTime" value="<%=Long.toString(System.currentTimeMillis())%>"/>

<!--

JSP TIME: ${TimerEndTime - TimerStartTime} milliseconds

//-->

