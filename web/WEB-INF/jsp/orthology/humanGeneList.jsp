<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <c:import url="../../../meta.jsp">
    <c:param name="pageTitle" value="Human Gene List"/>
  </c:import>
</head>

<c:import url="../../../body.jsp">
  <c:param name="pageTitle" value="Human Gene List"/>
</c:import>

<a name="top"></a>

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
              <td width="100%">
                <table width="100%" border=0 cellpadding=0 cellspacing=0>
                  <tr>
                    
                    <td width="100%" class="pageTitle">
                      Human Gene List
                    </td>
                    <td width="20%" valign="middle" align="center">&nbsp;</td>
                  </tr>
                </table>
              </td>
            </tr>
            <!--======================= End Form Header ================================-->
        </td>
      </tr>
    </table>
    <!--======================= End Search Summary =============================-->
    <br>
    <!--======================= Start Results ==================================-->
    <!--======================= Start Strain Genetics Results List =============-->
   
    
    <table border="0" cellpadding=5 cellspacing=1 width="100%" class="results">
    <tr>
      <td class="resultsHeaderLeft" colspan="6"><font class="larger"></font></td>
    </tr>        
    <tr>
      <td class="resultsHeader">Entrez Gene ID</td>
      <td class="resultsHeader">Human Gene Symbol</td>
      <td class="resultsHeader">Gene Name</td>
    </tr>
    
    <c:forEach var="rec" items="${symbols}" varStatus="status">
    
    <c:choose>
      <c:when test="${status.index%2==0}">
        <tr class="stripe1">
      </c:when>
      <c:otherwise>
        <tr class="stripe2">
      </c:otherwise>
    </c:choose>
    
    
    <td valign="top"><c:out value="GeneID:${rec.value}" default="&nbsp;" escapeXml="false"/>
    </td>
    <td valign="top">${rec.label}</td>
    <td valign="top">${rec.data}</td>
   </tr>
  </c:forEach>
  <tr class="buttons" ><td colspan="3">
  <a href="<c:url value='/orthologySearch.do?sortBy=HumanGS&compare=Equals&reference=${reference}'/>"><input type="button" value="Search MTB"></a>
</td></tr>
</table>
</table>


<!--======================= End Results ====================================-->
</table>
<!--======================== End Main Section ==============================-->
</td>
</tr>
</table>
</body>
</html> 
