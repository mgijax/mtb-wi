<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<c:import url="../../../meta.jsp">
    <c:param name="pageTitle" value="Tumor Pathology Report/Images"/>
</c:import>
</head>

<c:import url="../../../body.jsp">
     <c:param name="pageTitle" value="Tumor Pathology Report/Images"/>
</c:import>

<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr>
        <td valign="top">
            <table width="95%" align="center" border="0" cellspacing="1" cellpadding="4">
                <tr>
                    <td>
<!--======================= Start Pathology Records ========================-->    
    <c:choose>
    <c:when test="${not empty tumorFreq.pathologyRecs}">
        <a name="pathology"><br></a>
        <table border="0" cellpadding=5 cellspacing=1 width="100%" class="results">
            <tr>
                <td colspan="4" class="resultsHeaderLeft">
                    <font class="larger">Pathology</font>
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <c:choose>
                    <c:when test="${tumorFreq.numPathologyRecs!=1}">
                        ${tumorFreq.numPathologyRecs} entries
                    </c:when>
                    <c:otherwise>
                        ${tumorFreq.numPathologyRecs} entry
                    </c:otherwise>
                    </c:choose>
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <c:choose>
                    <c:when test="${tumorFreq.numImages!=1}">
                        ${tumorFreq.numImages} images
                    </c:when>
                    <c:otherwise>
                        ${tumorFreq.numImages} image
                    </c:otherwise>
                    </c:choose>
                </td>
            </tr>
            <tr>
                <td class="resultsHeader">Age at Necropsy</td>
                <td class="resultsHeader">Description</td>
                <td class="resultsHeader">Notes</td>
                <td class="resultsHeader">Images</td>
            </tr>
            
            <c:set var="lbl" value="1"/>
            <c:set var="rowClass" value="stripe1"/>
            
            <c:forEach var="rec" items="${tumorFreq.pathologyRecs}" varStatus="status">

                <c:set var="lbl" value="${lbl+1}"/>
                <c:set var="rowClass" value="stripe${(lbl%2)+1}"/>
                <c:set var="rowSpan" value="${fn:length(rec.images)}"/>
                
                <c:if test="${rowSpan<1}">
                    <c:set var="rowSpan" value="1"/>
                </c:if>
                
                <tr class="${rowClass}">
            
                    <td rowspan="${rowSpan}" valign="top"><c:out value="${rec.ageAtNecropsy}" escapeXml="false" default="&nbsp;"/></td>
                    <td rowspan="${rowSpan}" valign="top"><c:out value="${rec.description}" escapeXml="false" default="&nbsp;"/></td>
                    <td rowspan="${rowSpan}" valign="top"><c:out value="${rec.note}" escapeXml="false" default="&nbsp;"/></td>
                    
                        <c:choose>
                        <c:when test="${not empty rec.images}">
                            <c:forEach var="image" items="${rec.images}" varStatus="status2">
                            
                                <c:if test="${status2.first!=true}">
                                    <tr class="${rowClass}">
                                </c:if>
                            
                            <td valign="top">                                
                                <table border=0 cellspacing=5 cellpadding=5>
                                    <tr>
                                        <td width="160">
                                        
                                            <a href="pathologyImageDetails.do?key=${image.imageId}">
                                            <img width="150" src="${applicationScope.pathologyImageUrl}/${applicationScope.pathologyImagePath}/${image.imageThumbName}"></a>
                                        </td>
                                        <td valign="top" align="left">
                                            <table border=0 cellspacing=1 cellpadding=1 align="left">
                                                <tr>
                                                    <td class="small" align="right"><b>Image ID</b>:</td>
                                                    <td class="small">${image.imageId}</td>
                                                </tr>
                                                <tr>
                                                    <td class="small" align="right"><b>Source of Image</b>:</td>
                                                    <td class="small">
                                                        <c:choose>
                                                        <c:when test="${fn:length(image.institution) > 0}">
                                                            ${image.sourceOfImage}, ${image.institution}
                                                        </c:when>
                                                        <c:otherwise>
                                                            ${image.sourceOfImage}
                                                        </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="small" align="right"><b>Method / Stain</b>:</td>
                                                    <td class="small">${image.stainMethod}</td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="small" colspan=2>
                                            <b>Image Caption</b>:<br>
                                            ${image.imageCaption}
                                        </td>
                                    </tr>
                                </table>
                            
                                </td>
                            </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <!--There are no pathology images associated with this pathology entry. //-->
                            <td>&nbsp;</td>
                        </c:otherwise>
                        </c:choose>
            </c:forEach>
        </table>
    </c:when>
    <c:otherwise>
        <!-- There are no pathology records associated with this tumorFreq. -->
    </c:otherwise>
    </c:choose>
<!--======================= End Pathology Records ==========================-->    
        </td>
    </tr>
</table>
</body>
</html> 
