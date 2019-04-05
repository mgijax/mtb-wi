<%@ tag description="Jax search summary criterion" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ attribute name="dt" required="true" %>
<%@ attribute name="dts" required="false" %>
<%@ attribute name="dd" required="false" %>
<%@ attribute name="dds" type="java.util.Collection" required="false" %>
<%@ attribute name="test" type="java.lang.Boolean" required="false" %>
<c:choose>
<c:when test="${not empty dds && test != false}">
<c:if test="${empty dts}">
<c:set var="dts" value="${dt}"/>
</c:if>
<dl>
	<c:choose>
	<c:when test="${fn:length(items)>1}">
	<dt>${dts}</dt>
	</c:when>
	<c:otherwise>
	<dt>${dt}</dt>
	</c:otherwise>
	</c:choose>
	<c:forEach var="item" items="${dds}">
	<dd>${item}</dd>
	</c:forEach>
</dl>
</c:when>
<c:when test="${test}">
<dl>
	<dt>${dt}</dt>
	<c:if test="${not empty dd}">
	<dd>${dd}</dd>
	</c:if>
</dl>
</c:when>
<c:when test="${not empty dd && test != false}">
<dl>
	<dt>${dt}</dt>
	<dd>${dd}</dd>
</dl>
</c:when>
</c:choose>
