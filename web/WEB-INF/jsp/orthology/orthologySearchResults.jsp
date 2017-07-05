<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <c:import url="../../../meta.jsp">
    <c:param name="pageTitle" value="Orthology Search Results"/>
  </c:import>
</head>

<c:import url="../../../body.jsp">
  <c:param name="pageTitle" value="Orthology Search Results"/>
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
                    <td width="20%" valign="middle" align="left">
                      <a class="help" href="userHelp.jsp#humangeneresults"><img src="${applicationScope.urlImageDir}/help_large.png" border=0 width=32 height=32 alt="Help"></a>
                    </td>
                    <td width="60%" class="pageTitle">
                      Orthology Search Results
                    </td>
                    <td width="20%" valign="middle" align="center">&nbsp;</td>
                  </tr>
                </table>
              </td>
            </tr>
            <!--======================= End Form Header ================================-->
<!--======================= Start Search Summary ===========================-->
            <tr class="summary">
              <td>
                <font class="label">Search Summary</font><br>
                
              </td> 
            </tr>
            <tr class="summary">
              <td>
              <!--======================= Start Display Limit ============================-->
              <table border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td><b>Gene Identifier(s):</b>
                <td>
                 ${humanGS}
                </td>
              </tr>
            </tr>
            <tr>
                <td><b>Sort By:</b>
                <td>
                 ${sortBy}
                </td>
              </tr>
           
          </table>
          <!--======================= End Display Limit ==============================-->            
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
      <td class="resultsHeader">Human Gene Symbol</td>
      <td class="resultsHeader">Mouse Gene Symbol</td>
      <td class="resultsHeader">Name</td>
      <td class="resultsHeader">Alleles/Transgenes in Strains</td>
      <td class="resultsHeader">Classes of Tumor Specific Alterations</td>
    </tr>
    
    <c:forEach var="rec" items="${orthos}" varStatus="status">
    
    <c:choose>
      <c:when test="${status.index%2==0}">
        <tr class="stripe1">
      </c:when>
      <c:otherwise>
        <tr class="stripe2">
      </c:otherwise>
    </c:choose>
    
    
    <td valign="top"><c:out value="${rec.humanGS}" default="&nbsp;" escapeXml="false"/></td>
    <td valign="top"><a href="http://www.informatics.jax.org/marker/key/${rec.mgiGSKey}">${rec.mouseGS}</a></td>
    <td valign="top">${rec.symbol}</td>
    <c:choose>
    <c:when test="${rec.strains!='0'}">
    <td valign="top"><a href="geneticsSearchResults.do?sortBy=Gene+Symbol&markerNameComparison=Equals&markerName=${rec.mouseGS}">${rec.strains}</a></td>
    </c:when>
    <c:otherwise>
      <td valign="top">${rec.strains}</td>
    </c:otherwise>
  </c:choose>
    <c:choose>
    <c:when test="${rec.tumors!='0'}">
     <td valign="top"><a href="geneticsSearchResults.do?sortBy=Gene+Symbol&markerNameComparison=Equals&markerName=${rec.mouseGS}#tumorGenetics">${rec.tumors}</a></td>
    </c:when>
    <c:otherwise>
      <td valign="top">${rec.tumors}</td>
    </c:otherwise>
  </c:choose>
  </tr>
  </c:forEach>
  <html:form action="orthologySearch" method="GET">
  <tr class="buttons"><td colspan="6"><input type="submit" value="Search Again"/></td></tr>
</html:form>
  
</table>


<!--======================= End Results ====================================-->
</table>
<!--======================== End Main Section ==============================-->
</td>
</tr>
</table>
</body>
</html> 
