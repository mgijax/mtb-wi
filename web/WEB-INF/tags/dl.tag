<%@ tag description="Jax search summary criterion" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ attribute name="dt" required="true" %>
<%@ attribute name="dts" required="false" %>
<%@ attribute name="dd" required="false" %>
<%@ attribute name="dds" type="java.util.Collection" required="false" %>
<%@ attribute name="test" type="java.lang.Boolean" required="false" %>
<%@ attribute name="showNoData" type="java.lang.Boolean" required="false" %>
    <%-- false test do nothing --%>
<c:if test="${test != false}">
    
    <c:if test="${not empty dds}">
        <c:if test="${empty dts}">
            <c:set var="dts" value="${dt}"/>
        </c:if>
        <dl>
                <c:choose>
                <c:when test="${fn:length(dds)>1}">
                <dt><c:out value="${dts}" escapeXml="false" /></dt>
                </c:when>
                <c:otherwise>
                <dt><c:out value="${dt}" escapeXml="false" /></dt>
                </c:otherwise>
                </c:choose>
                <c:forEach var="item" items="${dds}">
                <dd><c:out value="${item}" escapeXml="false" /></dd>
                </c:forEach>
        </dl>
     
    </c:if>
    <c:if test="${not empty dd && empty dds}">
      <dl>
        <dt><c:out value="${dt}" escapeXml="false" /></dt>
        <dd><c:out value="${dd}" escapeXml="false" /></dd>
      </dl>
     
    </c:if>
    <c:if test="${empty dd && empty dds && showNoData}">
    <dl>
            <dt><c:out value="${dt}" escapeXml="false" /></dt>
            <dd><i>no data</i></dd>
    </dl>
    </c:if>

  </c:if>