<%@page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib uri="http://tumor.informatics.jax.org/mtbwi/MTBWebUtils" prefix="wu" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
  <html>
    <head>
      <c:import url="../../../meta.jsp">
        <c:param name="pageTitle" value="Gene Expression Data Set Search Results"/>
      </c:import>
    </head>
    
    <c:import url="../../../body.jsp">
      <c:param name="pageTitle" value="Gene Expression Data Set Search Results"/>
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
                <td colspan="5" width="100%">
                  <table width="100%" border=0 cellpadding=0 cellspacing=0>
                    <tr>
                      <td width="20%" valign="middle" align="left">
                        <a class="help" href="userHelp.jsp#geneexpression"><img src="${applicationScope.urlImageDir}/help_large.png" border=0 width=32 height=32 alt="Help"></a>
                      </td>
                      <td width="60%" class="pageTitle">
                        Gene Expression Data Set Search Results
                      </td>
                      <td width="20%" valign="middle" align="center">&nbsp;</td>
                    </tr>
                  </table>
                </td>
              </tr>
              <!--======================= End Form Header ================================-->
              <!--======================= Start Search Summary ===========================-->
              <tr class="summary">
                <td colspan="5">
                  <font class="label">Search Summary</font><br>
                  
                  
                  
                  <c:if test="${not empty organs}">
                    <c:choose>
                      <c:when test="${fn:length(organs)>1}">
                        <font class="label">Organs:</font>
                      </c:when>
                      <c:otherwise>  
                        <font class="label">Organ:</font>
                      </c:otherwise>
                    </c:choose>
                    
                    <c:forEach var="organ" items="${organs}" varStatus="status">
                      <c:choose>
                        <c:when test="${status.last != true}">
                          ${organ},
                        </c:when>
                        <c:otherwise>
                          ${organ}
                        </c:otherwise>
                      </c:choose>
                    </c:forEach>
                    <br>
                  </c:if>
                  
                  
                  <c:if test="${not empty tumorClassifications}">
                    <c:choose>
                      <c:when test="${fn:length(tumorClassifications)>1}">
                        <font class="label">Tumor Classifications:</font>
                      </c:when>
                      <c:otherwise>  
                        <font class="label">Tumor Classification:</font>
                      </c:otherwise>
                    </c:choose>
                    
                    <c:forEach var="classification" items="${tumorClassifications}" varStatus="status">
                      <c:choose>
                        <c:when test="${status.last != true}">
                          ${classification},
                        </c:when>
                        <c:otherwise>
                          ${classification}
                        </c:otherwise>
                      </c:choose>
                    </c:forEach>
                    <br>
                  </c:if>
                  
                  
                  
                  <c:if test="${not empty strainName}">
                    <font class="label">Strain:</font> ${strainName}<br>
                  </c:if>
                  
                  
                  
                  <c:if test="${not empty platforms}">
                    <c:choose>
                      <c:when test="${fn:length(platforms)>1}">
                        <font class="label">Platforms:</font>
                      </c:when>
                      <c:otherwise>  
                        <font class="label">Platform:</font>
                      </c:otherwise>
                    </c:choose>
                    
                    <c:forEach var="platform" items="${platforms}" varStatus="status">
                      <c:choose>
                        <c:when test="${status.last != true}">
                          ${platform},
                        </c:when>
                        <c:otherwise>
                          ${platform}
                        </c:otherwise>
                      </c:choose>
                    </c:forEach>
                    <br>
                  </c:if>
                  
                  
                  <c:choose>
                    <c:when test="${not empty samplesWOSeries || not empty seriesWSamples}">
                    
                      <c:choose>
                        <c:when test="${not empty seriesWSamples}">
                         <c:choose>
                          <c:when test="${seriesWSamples == '1'}">
                            <font class="label">${seriesWSamples} series has matching samples </font><br>
                          </c:when>
                          <c:otherwise>
                            <font class="label">${seriesWSamples} series have matching samples </font>&nbsp;
                                <c:forEach var="series" items="${results}" >
                                <c:choose>
                                  <c:when test="${not empty series.series.id}">
                                    <a href="#${series.series.id}">${series.series.id}</a>&nbsp;
                                  </c:when>
                                </c:choose>
                              </c:forEach>
                          </c:otherwise>
                        </c:choose>
                        </c:when>
                      </c:choose>
                      
                      <c:choose>
                        <c:when test="${not empty samplesWOSeries}">
                        <br>
                        <c:choose>
                           <c:when test="${samplesWOSeries == '1'}">
                            <font class="label">${samplesWOSeries} matching sample not associated with a series </font><br>
                          </c:when>
                          <c:otherwise>
                            <font class="label">${samplesWOSeries} matching samples not associated with any series </font><br>
                          </c:otherwise>
                        
                      </c:choose>
                        
                        </c:when>
                        
                      </c:choose>
                      
                    </c:when>
                    <c:otherwise>
                      <font class="label">All samples for ${seriesId} </font><br>
                    </c:otherwise>
                    
                  </c:choose>
                  
                  
                  
                </td>
              </tr>
              <tr class="summary">
                <td colspan="5">
                </td>
              </tr>
              <!--======================= End Search Summary =============================-->
              <!--======================= Start Results ==================================-->
              <c:choose>
              <c:when test="${not empty results}"> 
              <c:set var="lbl" value="1"/>
              
              
              <c:forEach var="series" items="${results}" >
              
              <c:choose>
                <c:when test="${not empty series.series.id}">
                 
                <tr class="results">
                  <td class="resultsHeader" colspan="1"><a name="${series.series.id}">Series ID</a></td>
                  <td class="resultsHeader" colspan="2">Title</td>
                  <td class="resultsHeader" colspan="2">Summary</td>

                </tr>
             

                <tr class="stripe1">
                  <td colspan="1" align="center"><a href="${series.siteURL}${series.series.id}"><c:out value="${series.series.id} " escapeXml="false"/></a><br><br>
                    <c:if test="${empty seriesId}">
                      <c:out value="${series.sampleCount} of " escapeXml="false"/>
                      <a href="geneExpressionSearchResults.do?seriesId=${series.series.id}"><c:out value="${series.totalSamples} samples" escapeXml="false"/></a><br>match the search criteria
                    </c:if>
                  </td>
                  <td colspan="2"><c:out value="${series.series.title}" escapeXml="false"/></td>
                  <td colspan="2"><c:out value="${series.series.summary}" escapeXml="false"/>
                    <c:if test="${fn:length(series.series.summary)>=499}">
                      <a href="${series.siteURL}${series.series.id}">...</a>
                    </c:if>
                  </td>

                </tr>
              </c:when>
              <c:otherwise>
                 <tr class="results">
                  <td class="resultsHeader" colspan="5">Matching samples not associated with any series</td>
                  

                </tr>
              </c:otherwise>
              </c:choose>
              
              <tr class="results">
                
                <td class="resultsHeader" colspan="1">Sample ID</td>
                <td class="resultsHeader" colspan="1">Title</td>
                <td class="resultsHeader" colspan="1">Summary</td>
                <td class="resultsHeader" colspan="1">Platform</td>
                <td class="resultsHeader" colspan="1">MTB Details</td>
                
              </tr>
              
              
              <c:forEach var="sample" items="${series.samples}" varStatus="status">
              
              <c:choose>
                <c:when test="${status.index%2==0}">
                  <tr class="stripe2">
                </c:when>
                <c:otherwise>
                  <tr class="stripe1">
                </c:otherwise>
              </c:choose>
              
              <c:choose>
                <c:when test="${empty sample.url}">
                  <td colspan="1"><c:out value="${sample.id}" escapeXml="false"/>
                </c:when>
                <c:otherwise>
                  <td colspan="1"><a href="${sample.url}"><c:out value="${sample.id}" escapeXml="false"/></a>
                </c:otherwise>
            </c:choose>
                <br>
                   <c:choose> 
                <c:when test="${sample.isControl}">
                  <br>Control sample
                </c:when>
               </c:choose>
              </td>
              <td colspan="1"><c:out value="${sample.title}" escapeXml="false"/></td>
              <td colspan="1"><c:out value="${sample.summary}" escapeXml="false"/></td>
              <td colspan="1"><c:out value="${sample.platform}" escapeXml="false"/></td>
             
              
              <td colspan="1"><a href="summaryByExample.do?tumorFrequencyKeys=${sample.dataBean['tfKey']}"><c:out value="${sample.dataBean['tfDetail']}" escapeXml="false"/></a></td>
              
            </tr>
            </c:forEach>
            
            </c:forEach>
           
            </c:when>
            <c:otherwise>
              <tr><td> No results found. </td></tr>
            </c:otherwise>
            </c:choose>   
            
            
            
            <!--======================= End Results ====================================-->
          </table>
          <!--======================== End Main Section ==============================-->
        </td>
      </tr>
    </table>
    </td>
    </tr>
    </table>
    </body>
  </html>
  


