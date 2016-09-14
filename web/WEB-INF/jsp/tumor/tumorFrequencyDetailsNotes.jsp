<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<c:import url="../../../meta.jsp">
    <c:param name="pageTitle" value="Tumor Notes"/>
</c:import>
</head>

<c:import url="../../../body.jsp">
     <c:param name="pageTitle" value="Tumor Notes"/>
</c:import>

<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr>
        <td valign="top">
            <table width="95%" align="center" border="0" cellspacing="1" cellpadding="4">
                <tr>
                    <td>
<!--======================= Start Additional Notes Records =================-->
    <c:choose>
    <c:when test="${not empty tumorFreq.additionalNotes}">
        <table border="0" cellpadding=5 cellspacing=1 width="100%" class="results">
            <tr>
                <td colspan="2" class="resultsHeaderLeft">
                    <font class="larger">Additional Notes</font>
                </td>
            </tr>
            <tr>
                <td class="resultsHeader">Note</td>
                <td class="resultsHeader">Reference</td>
            </tr>

            <c:set var="noteRow" value="2"/>

           
            <c:forEach var="rec" items="${tumorFreq.additionalNotes}" varStatus="status">
                <c:set var="noteRow" value="${noteRow == 1 ? 2 : 1}"/>
                <tr class="stripe${noteRow}">
                    <td><c:out value="${rec.label}" escapeXml="false"/></td>
                    <td><a href="nojavascript.jsp" onclick="focusBackToOpener('referenceDetails.do?key=${rec.data}');return false;">${rec.value}</a></td>
                </tr>
            </c:forEach>
        </table>
    </c:when>
    <c:otherwise>
        <!-- No notes for this frequency record //-->
    </c:otherwise>
    </c:choose>
<!--======================= End Additional Notes Records ===================-->
        </td>
    </tr>
</table>
</body>
</html>
