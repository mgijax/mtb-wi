<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<c:import url="../../../meta.jsp">
    <c:param name="pageTitle" value="Reference Detail"/>
</c:import>
</head>

<c:import url="../../../body.jsp">
     <c:param name="pageTitle" value="Reference Detail"/>
</c:import>

<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr>
        <td width="200" valign="top">
            <c:import url="../../../toolBar.jsp" />
        </td>
        <td class="separator">
            &nbsp;
        </td>
        <td valign="top">
            <table width="95%" align="center" border="0" cellspacing="1" cellpadding="4">
                <tr>
                    <td>
<!--======================= Start Main Section =============================-->
<!--======================= Start Form Header ==============================-->
<table border="0" cellpadding=5 cellspacing=1 width="100%" class="results">
   <tr class="pageTitle">
       <td colspan="2">
           <table width="100%" border=0 cellpadding=0 cellspacing=0>
               <tr>
                   <td width="20%" valign="middle" align="left">
                       <a class="help" href="userHelp.jsp#referencedetail"><img src="${applicationScope.urlImageDir}/help_large.png" border=0 width=32 height=32 alt="Help"></a>
                   </td>
                   <td width="60%" class="pageTitle">
                       Reference Detail
                   </td>
                   <td width="20%" valign="middle" align="center">&nbsp;</td>
               </tr>
           </table>
       </td>
   </tr>
<!--======================= End Form Header ================================-->
<!--======================= Start Reference Detail==========================-->    
    <tr class="stripe1">
        <td class="cat1">
            Reference
        </td>
        <td class="data1">
            <table border=0 cellpadding=5 cellspacing=0 width="100%">
                <tr>
                    <td class="label"  valign="top">Title: </td>
                    <td >${reference.title}${reference.title2}</td>
                </tr>
                <tr>
                    <td class="label"  valign="top">Authors: </td>
                    <td >${reference.authors}${reference.authors2}</td>
                </tr>
                <tr>
                    <td class="label">Journal: </td>
                    <td >${reference.journal}</td>
                </tr>
                <tr>
                    <td class="label">Volume: </td>
                    <td >${reference.volume}</td>
                </tr>
                <tr>
                    <td class="label">Issue: </td>
                    <td >${reference.issue}</td>
                </tr>
                <%--
                <tr>
                    <td class="label">Date: </td>
                    <td >${reference.referenceDate}</td>
                </tr>
                //--%>
                <tr>
                    <td class="label">Year: </td>
                    <td >${reference.year}</td>
                </tr>
                <tr>
                    <td class="label">Pages: </td>
                    <td >${reference.pages}</td>
                </tr>
                <%--
                <tr>
                    <td class="label">Review Status: </td>
                    <td ><i>Not implemented.</i></td>
                </tr>
                --%>
                <tr>
                    <td class="label" valign="top">Abstract: </td>
                    <td >${reference.abstractText}</td>
                </tr>
            </table>
        </td>
    </tr>
<!--======================= End Reference Detail ===========================-->    
<!--======================= Start Reference Additional Info ================-->
    <c:set var="lbl" value="2"/>
    
    <c:choose>
    <c:when test="${not empty reference.additionalInfo}">
        <c:if test="${reference.hasAdditionalInfo}">
            <c:set var="lbl" value="${lbl+1}"/>
            <tr class="stripe${(lbl%2)+1}">
                <td class="cat${(lbl%2)+1}">Additional<br>Information<br>in MTB </td>
                <td class="data${(lbl%2)+1}">
                    <table border=0 width="100%" cellpadding=5 cellspacing=0>
                        <c:forEach var="info" items="${reference.additionalInfo}" varStatus="status">
                            <c:choose>
                                <c:when test="${info.label=='Tumor Records'}">
                                    <c:if test="${info.value!=0}">
                                        <tr><td>${info.label} (<a href="tumorSearchResults.do?referenceKey=${reference.key}&maxItems=No+Limit">${info.value}</a>)</td></tr>
                                    </c:if>
                                </c:when>
                                <c:when test="${info.label=='Strains'}">
                                    <c:if test="${info.value!=0}">
                                        <tr><td>${info.label} (<a href="strainSearchResults.do?referenceKey=${reference.key}&maxItems=No+Limit">${info.value}</a>)</td></tr>
                                    </c:if>
                                </c:when>
                                <c:when test="${info.label=='Pathology Images'}">
                                    <c:if test="${info.value!=0}">
                                        <tr><td>${info.label} (<a href="pathologyImageSearchResults.do?referenceKey=${reference.key}&maxItems=No+Limit">${info.value}</a>)</td</tr>
                                    </c:if>
                                </c:when>
                                <c:otherwise>
                                    <!-- ERROR //-->
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </table>
                </td>
            </tr>
        </c:if>
    </c:when>
    <c:otherwise>
        <!-- There is no additional information in MTB associated with this reference. //-->
    </c:otherwise>
    </c:choose>
<!--======================= End Reference Additional Info ==================-->
<!--======================= Start Other Accession Ids ======================-->
    <c:choose>
    <c:when test="${not empty reference.otherAccessionIds}">
        <c:set var="lbl" value="${lbl+1}"/>
        <tr class="stripe${(lbl%2)+1}">
            <td class="cat${(lbl%2)+1}">Other<br>Accession<br>IDs</td>
            <td class="data${(lbl%2)+1}">
                <table border=0 width="100%" cellpadding=5 cellspacing=0>
                    <c:forEach var="info" items="${reference.otherAccessionIds}" varStatus="status">
                        <c:choose>
                            <c:when test="${status.index%2==1}">
                                <tr >
                            </c:when>
                            <c:otherwise>
                                <tr >
                            </c:otherwise>
                        </c:choose>
                            <td>
                                ${info.data}&nbsp; <a target="_new" href="${info.value}">${info.label}</a>
                            </td>
                        </tr>
                    </c:forEach>
                </table>
            </td>
        </tr>
    </c:when>
    <c:otherwise>
        <!-- There are no other Accession Ids in MTB associated with this reference. //-->
    </c:otherwise>
    </c:choose>
<!--======================= End Other Accession Ids ========================-->
<!--======================= End Detail Section =============================-->
</table>
<!--======================= End Main Section ===============================-->
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</body>
</html> 

