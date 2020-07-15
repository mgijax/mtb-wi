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
		<tr>
			<c:choose>
				<c:when test="${fn:length(dds)>1}">
					<td><h4><c:out value="${dts}" escapeXml="false" /></h4></td>
				</c:when>
				<c:otherwise>
					<td><h4><c:out value="${dt}" escapeXml="false" /></h4></td>
				</c:otherwise>
			</c:choose>
			<td>
				<c:forEach var="item" items="${dds}" varStatus="status">
					<c:out value="${item}" escapeXml="false" />
					<c:if test="${status.last != true}">
						&nbsp;&#8226;&nbsp;
					</c:if>	
				</c:forEach>
			</td>
		</tr>
	</c:when>
	<c:when test="${test}">
		<tr>
			<td><h4><c:out value="${dt}" escapeXml="false" /></h4></td>
			<c:if test="${not empty dd}">
				<td><c:out value="${dd}" escapeXml="false" /></td>
			</c:if>
		</tr>
	</c:when>
	<c:when test="${not empty dd && test != false}">
		<tr>
			<td><h4><c:out value="${dt}" escapeXml="false" /></h4></td>
			<td><c:out value="${dd}" escapeXml="false" /></td>
		</tr>
	</c:when>
</c:choose>
