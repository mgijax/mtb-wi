<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib uri="http://tumor.informatics.jax.org/mtbwi/MTBWebUtils" prefix="wu" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
  <head>
    <c:import url="../../../meta.jsp">
      <c:param name="pageTitle" value="List of Selected QTLs"/>
    </c:import>

    <c:import url="../../../body.jsp">
      <c:param name="pageTitle" value="Assay Image Detail"/>
    </c:import>


  </head>


  <table width="100%" align="center" border="0" cellspacing="1" cellpadding="4">
    <tr>
      <td><!--======================= Start Main Section =============================-->
    <!--======================= Start Form Header ==============================-->
        <table border="0" cellpadding=5 cellspacing=1" width="100%" class="results">
          <tr class="pageTitle">
            <td colspan="2">
              <table width="100%" border="0" cellpadding="0" cellspacing="0">
                <tr>
                  <td width="20%" valign="middle" align="left">
                    <a class="help" href="userHelp.jsp#QTLList"><img src="${applicationScope.urlImageDir}/help_large.png" border=0 width=32 height=32 style="vertical-align:middle" alt="Help">Help and Documentation</a>
                  </td>
                  <td width="60%" class="pageTitle">
                    List of Selected Cancer QTLs
                  </td>
                  <td width="20%" valign="middle" align="center">&nbsp;</td>
                </tr>
              </table>
            </td>
          </tr>
          <!--======================= End Form Header ================================-->
<!--======================= Start Detail Section ===========================-->
          <tr class="stripe1">
          <td colspan="2">

          <c:choose>
            <c:when test="${not empty features}">
              <tr>
                <td colspan="2">
                  <table border="0" cellpadding=5 cellspacing=1" width="100%" class="results">
                    <tr>
                      <td class="resultsHeader">MGI ID</td>
                      <td class="resultsHeader">QTL</td>
                      <td class="resultsHeader">Name</td>
                      <td class="resultsHeader">Organ</td>
                      <td class="resultsHeader">Chromosome:Start..End</td>
                      <td class="resultsHeader">Earliest Reference</td>
                      
                    </tr>

                      <c:forEach var="feature" items="${features}">
                        <c:set var="num" value="${num == 1 ? 2 : 1}"/>
                        <tr class="stripe${num}">
                          <td>${feature.mgiId}</td>
                          <td><a href="gViewer.do?id=${feature.mgiId}&name=${feature.chromosome}:${feature.start}..${feature.end}&label=${feature.label}&primeRef=${feature.primeRef}&qtlName=${feature.name}" >${feature.label}</a></td>
                          <td>${feature.name}</td>
                          <td>${feature.organ}</td>
                          <td>${feature.chromosome}:${feature.start}..${feature.end}</td>
                          <td>${feature.primeRef}</td>
                  
                        </tr>
                      </c:forEach>

                  </table>
                </td>
              </tr>
            </c:when>
          </c:choose>
        </table>
      </td>
    </tr>
  </table>
</html> 
