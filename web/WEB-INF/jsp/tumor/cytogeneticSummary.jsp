  <%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib uri="http://tumor.informatics.jax.org/mtbwi/MTBWebUtils" prefix="wu" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<c:import url="../../../meta.jsp">
    <c:param name="pageTitle" value="Cytogenetic Summary"/>
</c:import>
</head>

<c:import url="../../../body.jsp">
     <c:param name="pageTitle" value="Cytogenetic Summary"/>
</c:import>

<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr>
        <td width="200" valign="top">
            <c:import url="../../../toolBar.jsp"/>
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
                       <a class="help" href="userHelp.jsp#cytogeneticsummary"><img src="${applicationScope.urlImageDir}/help_large.png" border=0 width=32 height=32 alt="Help"></a>
                   </td>
                   <td width="60%" class="pageTitle">
                       Cytogenetic Summary
                   </td>
                   <td width="20%" valign="middle" align="center">&nbsp;</td>
               </tr>
           </table>
       </td>
   </tr>
</table>
<!--======================= End Form Header ================================-->
<br>
<!--======================= Start Detail Section ===========================-->
<!--======================= Start Tumor & Strain ===========================-->
<!--======================= End Tumor & Strain =============================-->
<br>
<!--======================= Start Frequency Records ========================-->
    <c:choose>
    <c:when test="${not empty tumor}">
        <table border="0" cellpadding=5 cellspacing=1 width="100%" class="results">
            <tr>
                <td class="resultsHeader">Chromosomes</td>
                <td class="resultsHeader">Name</td>
                <td class="resultsHeader">Note</td>
                <td class="resultsHeader">Type</td>
                <td class="resultsHeader">Assay Type</td>
                <td class="resultsHeader">Tumor Name</td>
                <td class="resultsHeader">Treatment Type</td>
                <td class="resultsHeader">Images</td>
                <td class="resultsHeader">Tumor Summary</td>
            </tr>
            
              <c:forEach var="genetics" items="${tumor}" varStatus="status">
                        <c:choose>
                            <c:when test="${status.index%2==0}">
                                <tr class="stripe1">
                            </c:when>
                            <c:otherwise>
                                <tr class="stripe2">
                            </c:otherwise>
                        </c:choose>
                           <td align="center">
                                <c:out value="${genetics.displayChromosomes}" escapeXml="false"/>
                            </td>
                            
                            <td>
                                
                               <c:out value="${genetics.name}" escapeXml="false"/>
                                  
                            </td>
                            
                             <td>
                                <c:out value="${genetics.notes}" escapeXml="false"/>
                            </td>
                            
                            <td>
                                <c:out value="${genetics.alleleTypeName}" escapeXml="false"/>
                            </td>
                            
                             <td>
                                <c:out value="${genetics.assayType}" escapeXml="false"/>
                            </td>
				    
                             <td>
                                <c:out value="${genetics.tumorName}" escapeXml="false"/>
                            </td>

                            <td>
                                <c:out value="${genetics.treatmentType}" escapeXml="false"/>
                            </td>
                            
                            <td>
                            <c:choose>
                              <c:when test="${not empty genetics.assayImages}">
                                  <c:forEach var="image" items="${genetics.assayImages}">
                                  <a href="nojavascript.jsp" onClick="popPathWin('assayImageDetails.do?key=${image.assayImagesKey}&amp;page=pathology', '${image.assayImagesKey}');return false;">
                                     <img width="150" src="${applicationScope.assayImageURL}/${applicationScope.assayImagePath}/${image.lowResName}" alt="X" border="0">
                                  </a>
                                   
                                    <br>&nbsp;<br>
                                  </c:forEach>
                                </c:when>
                            </c:choose>
                          </td>
                            
                            <td>
                                <a href="tumorSummary.do?tumorFrequencyKeys=${genetics.tumorFrequencyKey}">Tumor Summary</a> 
                            </td>
                            
                           
                        </tr>
            </c:forEach>


           
    </c:when>
    <c:otherwise>
        <!-- There are no tumor frequency records associated with this tumor. -->
    </c:otherwise>
    </c:choose>
<!--======================= End Frequency Records ==========================-->
<!--======================= End Detail Section =============================-->
<!--======================= End Main Section ===============================-->
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</body>
</html>

