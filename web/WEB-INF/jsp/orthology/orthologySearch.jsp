<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
  <head>
    <c:import url="../../../meta.jsp">
      <c:param name="pageTitle" value="Human Gene Search"/>
    </c:import>
  </head>
  <body>
    <c:import url="../../../body.jsp">
      <c:param name="pageTitle" value="Human Gene Search Form"/>
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
                <html:form action="orthologySearch" method="GET" >
                  <!--======================= Start Form Header ==============================-->
                  <table border="0" cellpadding=5 cellspacing=1 width="100%" class="results">
                    <tr class="pageTitle">
                      <td colspan="2">
                        <table width="100%" border=0 cellpadding=0 cellspacing=0>
                          <tr>
                            <td width="20%" valign="middle" align="left">
                              <a class="help" href="userHelp.jsp#humangene"><img src="${applicationScope.urlImageDir}/help_large.png" border=0 width=32 height=32 alt="Help"></a>
                            </td>
                            <td width="60%" class="pageTitle">
                              Human Gene Search Form
                            </td>
                            <td width="20%" valign="middle" align="center">&nbsp;</td>
                          </tr>
                        </table>
                      </td>
                    </tr>
                    <!--======================= End Form Header ================================-->
                    <tr class="pageInfo">
                      
                    </tr>
                    <tr class="buttons">
                      <td colspan="2">
                        <table border=0 cellspacing=2 width="100%">
                          <tr>
                            <td>
                              
                              
                              <input type="submit" VALUE="Search">
                              <input type="reset" VALUE="Reset">
                            </td>
                          </tr>
                          <tr>
                            <td>
                              <font class="label">Sort By:</font>
                              <html:radio property="sortBy" value="HumanGS">Human Gene Symbol</html:radio> &nbsp; 
                              <html:radio property="sortBy" value="MouseGS">Mouse Gene Symbol</html:radio> &nbsp; 
                             
                            </td>
                          </tr>
                          
                        </table>
                      </td>
                    </tr>
                    
                    
                    <tr class="stripe1">
                      <td class="cat1">
                        Human Genes:
                      </td>
                      <td class="data1">
                        <table border=0 cellspacing=5 width="100%">
                          
                          <tr>
                            <td>
                              <table border="0" cellspacing="5">
                                <tr>
                                  <td align="top">
                                    <html:select property="compare">
                                      <html:option value="Contains"> Contains </html:option>
                                      <html:option value="Begins"> Begins with </html:option>
                                      <html:option value="Equals"> Equals </html:option>
                                      <html:option value="Ends"> Ends with </html:option>
                                    </html:select>
                                  </td><b>
                                   Entering human gene symbols, names or Entrez IDs returns a list of orthologous mouse symbols and associated data. <br>
                                   </b>Entrez ID searches must use 'equals'.
                                  <td><html:textarea property="humanGS" rows="3" cols="50"/></td>
                                </tr>
                                
                                
                              </table>
                            </td>
                          </tr>
                        </table>
                      </td>
                    </tr>
                    
                    <tr class="buttons">
                      <td colspan="2">
                        <table border=0 cellspacing=5 width="100%">
                          <tr>
                            <td>
                              <input type="submit" VALUE="Search">
                              <input type="reset" VALUE="Reset">
                            </td>
                          </tr>
                        </table>
                      </td>
                    </tr>
                  </table>
                  <!--======================== End Main Section ==============================-->
                </html:form>
              </td>
            </tr>
            <c:set var="url" value="/orthologySearch.do?sortBy=HumanGS&compare=Equals&reference=" />
            <c:set var="asList" value="&asList=true" />
            <tr>
              
              <td>    
                            
                <table width="100%">
                  <tr>
                    <td><h3><b>Sample references containing human cancer genes:</b></h3></td>
                  </tr>
                  <tr><td></td></tr>
                  
                  <c:forEach var="reference" items="${references}" >
                  <tr>
                    <td>${reference.authors}</td>
                    <td>
                      
                      <c:if test="${not empty reference.url}">
                        <a href="<c:url value='${reference.url}'/>">PubMed abstract</a>
                      </c:if>
                      
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <b>${reference.title}</b>,&nbsp;${reference.journal}&nbsp;${reference.year}
                      <c:if test="${not empty reference.volume}">
                        ;${reference.volume}
                      </c:if>
                      <c:if test="${not empty reference.issue}">
                        (${reference.issue})
                      </c:if>
                      <c:if test="${not empty reference.pages}">
                        :${reference.pages}
                      </c:if>
                    </td>
                   <td>
                      <a href="<c:url value='${url}${reference.referenceKey}'/>">Search MTB using human genes from this paper</a>
                    </td>
                    
                  </tr>
                  <tr>
                     <td>${reference.note}</td>
                    <td>
                      <a href="<c:url value='${url}${reference.referenceKey}${asList}'/>">List of human genes</a>
                    </td>
                  </tr>
                  <tr><td colspan="2"><hr></td></tr>
                  </c:forEach>

                   
                </table>
                
              </td>
              
              
            </tr>
            
          </table>
        </td>
      </tr>
      
    </table>
  </body>
</html> 
