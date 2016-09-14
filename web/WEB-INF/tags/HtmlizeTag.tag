<%@ tag body-content="scriptless"  %>
<%@ attribute name="text" required="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<c:set var="start" value="<"/>
<c:set var="stop" value=">"/>
<c:set var="supStart" value="<sup>"/>
<c:set var="supStop" value="</sup>"/>
<c:set var="retVal" value=""/>

<c:if test="${text != null}">
    <c:set var="startPos" value="${fn:indexOf(start, text)}"/>
    <c:set var="stopPos" value="${fn:indexOf(stop, text)}"/>
    
    <c:if test="${startPos > 0) && (stopPos > 0)}">
    
        <c:set var="startLen" value="${fn:length(start)}"/>
        <c:set var="stopLen" value="${fn:length(stop)}"/>
        <c:set var="sectionStart" value="0"/>
        <c:set var="sb" value=""/>

        <c:forEach var="" varStatus="" items="" begin="startIndex" end="" step=""
        while ((startPos != -1) && (stopPos != -1)) {
            <c:set var="sb" value="${sb + fn:substring(text, sectionStart, startPos)}"/>
            <c:set var="sb" value="${sb + supStart}"/>
            <c:set var="sb" value="${sb + fn:substring(text, startPos + startLen, stopPos)}"/>
            <c:set var="sb" value="${sb + supStop}"/>

            <c:set var="sectionStart" value="${stopPos + stopLen}"/>
            <c:set var="startPos" value="${fn:indexOf(theText, start, sectionStart)}"/>
            <c:set var="stopPos" value="${fn:indexOf(theText, stop, sectionStart)}"/>
        <c:forEach>
        
        <c:set var="retVal" value="${sb + fn:substring(theText, sectionStart)}"/>
    </c:if>
</c:if>