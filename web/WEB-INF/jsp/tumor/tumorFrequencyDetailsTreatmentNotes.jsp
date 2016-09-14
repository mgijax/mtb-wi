<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<c:import url="../../../meta.jsp">
    <c:param name="pageTitle" value="Tumor Treatment Note"/>
</c:import>
</head>

<c:import url="../../../body.jsp">
     <c:param name="pageTitle" value="Tumor Treatment Note"/>
</c:import>

<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr>
        <td valign="top">
            <table width="95%" align="center" border="0" cellspacing="1" cellpadding="4">
                <tr>
                    <td>
<!--======================= Start Additional Notes Records =================-->
    <c:choose>
    <c:when test="${not empty tumorFreq.note}">
        <table border="0" cellpadding=5 cellspacing=1 width="100%" class="results">
            <tr>
                <td colspan="2" class="resultsHeaderLeft">
                    <font class="larger">Treatment Note</font>
                </td>
            </tr>
            <tr>
                <td class="resultsHeader">Note</td>
                <td class="resultsHeader">Reference</td>
            </tr>

            <c:if test="${not empty tumorFreq.note}">
                <c:set var="noteRow" value="1"/>
                <tr class="stripe1">
                    <td>${tumorFreq.note}</td>
                    <td><a href="nojavascript.jsp" onclick="focusBackToOpener('referenceDetails.do?accId=${tumorFreq.reference}');return false;">${tumorFreq.reference}</a></td>
                </tr>
            </c:if>
           
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
