<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <c:import url="../../../meta.jsp">
    <c:param name="pageTitle" value="Genetics Search Results"/>
  </c:import>
</head>

<c:import url="../../../body.jsp">
  <c:param name="pageTitle" value="Genetics Search Results"/>
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
                      <a class="help" href="userHelp.jsp#geneticsresults"><img src="${applicationScope.urlImageDir}/help_large.png" border=0 width=32 height=32 style="vertical-align:middle" alt="Help">Help and Documentation</a>
                    </td>
                    <td width="60%" class="pageTitle">
                      Genetics Search Results
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
                
                <c:if test="${not empty alleleName}">
                  <font class="label">Allele Name:</font> ${alleleNameComparison} "${alleleName}"<br>
                </c:if>
                
                <c:if test="${not empty markerName}">
                  <font class="label">Marker Name:</font> ${markerNameComparison} "${markerName}"<br>
                </c:if>
                
                <c:if test="${not empty chromosomes}">
                  <c:choose>
                    <c:when test="${chromosomes>'1'}">
                      <font class="label">Chromosomes:</font>
                    </c:when>
                    <c:otherwise>
                      <font class="label">Chromosome:</font>
                    </c:otherwise>
                  </c:choose>
                  
                  ${chromosomes}
                  <br>
                </c:if>
                
                
                <c:if test="${not empty mutations}">
                  <c:choose>
                    <c:when test="${mutations>'1'}">
                      <font class="label">Mutations / Aberrations:</font>
                    </c:when>
                    <c:otherwise>
                      <font class="label">Mutation / Aberration:</font>
                    </c:otherwise>
                  </c:choose>
                  
                  ${mutations}
                  <br>
                </c:if>
                
                <c:if test="${not empty assayImages}">
                  <font class="label">Restrict results to records that include assay images</font><br>
                </c:if>
                
                <font class="label">Sort By:</font> ${sortBy}<br>
                <font class="label">Display Limit:</font> ${maxItems} in each section
              </td>
            </tr>
            <tr class="summary">
              <td>
              <!--======================= Start Display Limit ============================-->
              <table border="0" cellspacing="0" cellpadding="0">
              <tr>
                
                <td>
                  <c:choose>
                    <c:when test="${numberOfResultsStrains != totalResultsStrains}">
                      ${numberOfResultsStrains} of ${totalResultsStrains} matching strains displayed.
                    </c:when>
                    <c:otherwise>
                      <c:out value="${numberOfResultsStrains}" default="0"/> matching strains displayed.
                    </c:otherwise>
                  </c:choose>
                </td>
              </tr>
              <tr>
                
                
                <td>
                  <c:choose>
                    <c:when test="${numberOfResultsTumors != totalResultsTumors}">
                      ${numberOfResultsTumors} of ${totalResultsTumors} matching markers analyzed in the tumor displayed.
                    </c:when>
                    <c:otherwise>
                      <c:out value="${numberOfResultsTumors}" default="0"/> matching markers analyzed in the tumor displayed.
                    </c:otherwise>
                  </c:choose>
                </td>
              </tr>
              
              
              <tr>
                <td>
                  <c:choose>
                    <c:when test="${numberOfCytoTumors != totalCytoTumors}">
                      ${numberOfCytoTumors} of ${totalCytoTumors} matching cytogenetic observations in tumors displayed.
                    </c:when>
                    <c:otherwise>
                      <c:out value="${numberOfCytoTumors}" default="0"/> matching cytogenetic observations in tumors displayed.
                    </c:otherwise>
                  </c:choose>
                </td>
              </tr>
              
              
              
              
              
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
    <c:choose>
    <c:when test="${not empty strainGenetics}">
    <a name="strainGenetics"></a>
    <c:if test="${not empty tumorGenetics}">
      <div align="right"><a href="#tumorGenetics"><img align="middle" src="${applicationScope.urlImageDir}/down_arrow.png" border="0" alt="Jump to Genetic Changes in Tumors">Jump to Genetic Changes in Tumors</a></div><br><br>
    </c:if>
    
    <c:if test="${not empty cytoGenetics}">
      <div align="right"><a href="#cytoGenetics"><img align="middle" src="${applicationScope.urlImageDir}/down_arrow.png" border="0" alt="Jump to Cytogenetic Changes in Tumors">Jump to Cytogenetic Changes in Tumors</a></div><br><br>
    </c:if>
    
    <table border="0" cellpadding=5 cellspacing=1 width="100%" class="results">
    <tr>
      <td class="resultsHeaderLeft" colspan="4"><font class="larger">Genes, Alleles and Transgenes carried by Strains</font></td>
    </tr>        
    <tr>
      
      <td class="resultsHeader">Mouse<br>Chrom.</td>
      <td class="resultsHeader">Symbol, Name</td>
      <td class="resultsHeader">Type</td>
      <td class="resultsHeader">Genotype<br><small>(number of associated strains)</small></td>
    </tr>
    
    <c:forEach var="rec" items="${strainGenetics}" varStatus="status">
    <c:choose>
      <c:when test="${status.index%2==0}">
        <tr class="stripe1">
      </c:when>
      <c:otherwise>
        <tr class="stripe2">
      </c:otherwise>
    </c:choose>
    
    <td valign="top"><c:out value="${rec.chromosome}" default="&nbsp;" escapeXml="false"/></td>
    <td valign="top">
      <c:choose>
        <c:when test="${empty rec.geneSymbol}">
          ${rec.geneName}
        </c:when>
        <c:otherwise>
          ${rec.geneSymbol}, ${rec.geneName}
        </c:otherwise>
      </c:choose>
      <c:if test="${rec.isTransgene==true}">
        (${rec.organism})
      </c:if>
      <c:forEach var="pe" items="${rec.promotersEnhancers}">
        
        <small style="font-size:90%"><br>${pe}</small>
      </c:forEach>
    </td>
    <td valign="top">${rec.alleleType}</td>
    <td valign="top">
      
      <c:choose>
        <c:when test="${not empty rec.allele2Symbol}">
          <c:choose>
            <c:when test="${rec.isTransgene==true}">
              ${rec.allele1Symbol}/${rec.allele2Symbol}
            </c:when>
            <c:otherwise>
              <i>${rec.allele1Symbol}/${rec.allele2Symbol}</i>
            </c:otherwise>
          </c:choose>
        </c:when>
        <c:otherwise>
          <c:choose>
            <c:when test="${rec.isTransgene==true}">
              ${rec.allele1Symbol}
            </c:when>
            <c:otherwise>
              <i>${rec.allele1Symbol}</i>
            </c:otherwise>
          </c:choose>
        </c:otherwise>
      </c:choose>
      
      <c:if test="${rec.allelePairCount>0}">
        (<a href="strainSearchResults.do?allelePairKey=${rec.allelePairKey}&amp;maxItems=No+Limit">${rec.allelePairCount}</a>)
      </c:if>
      
      <c:if test="${status.last != true}">
        <br>
      </c:if>
      
    </td>
  </tr>
  </c:forEach>
</table>
</c:when>
<c:otherwise>
  <!-- No strain results found. //-->
</c:otherwise>
</c:choose>
<!--======================= End Strain Genetics Results List ===============-->
<br><br>
<!--======================= Start Tumor Genetics Results List ==============-->
<c:choose>
<c:when test="${not empty tumorGenetics}">
<a name="tumorGenetics"></a>
<c:if test="${not empty strainGenetics}">
  <div align="right"><a href="#strainGenetics"><img align="middle" src="${applicationScope.urlImageDir}/up_arrow.png" border="0" alt="Jump to Genes, Alleles and Transgenes in Strains">Jump to Genes, Alleles and Transgenes in Strains</a></div><br><br>
</c:if>
<table border="0" cellpadding=5 cellspacing=1 width="100%" class="results">
<tr>
  <td class="resultsHeaderLeft" colspan="3"><font class="larger">Genetic Markers analyzed in the Tumor</font></td>
</tr>        
<tr>
  <td class="resultsHeader">Mouse<br>Chrom.</td>
  <td class="resultsHeader">Gene Symbol, Name</td>
  <td class="resultsHeader">Marker Type Observed<br><small>(Number of Observations)</small></td>
</tr>

<c:forEach var="rec" items="${tumorGenetics}" varStatus="status">
  <c:choose>
    <c:when test="${status.index%2==0}">
      <tr class="stripe1">
    </c:when>
    <c:otherwise>
      <tr class="stripe2">
    </c:otherwise>
  </c:choose>
  
  <td valign="top"><c:out value="${rec.chromosome}" default="&nbsp;" escapeXml="false"/></td>
  <td valign="top">
    <c:choose>
      <c:when test="${fn:containsIgnoreCase(rec.geneName, 'placeholder')}">
        &nbsp;
      </c:when>
      <c:otherwise>
        ${rec.geneSymbol}, ${rec.geneName}
      </c:otherwise>
    </c:choose>
  </td>
  <td valign="top">
    <c:out value="${rec.alleleType}" escapeXml="true"/>
    <c:if test="${rec.count>0}">
      (<a href="geneticsSummary.do?alleleTypeKey=${rec.alleleTypeKey}&amp;markerKey=${rec.markerKey}">${rec.count}</a>)
    </c:if>
  </td>
  </tr>
</c:forEach>
</table>
</c:when>
<c:otherwise>
  <!-- No tumor results found. //-->
</c:otherwise>
</c:choose>
<!--======================= End Tumor Genetics Results List ================-->



<c:choose>
<c:when test="${not empty cytoGenetics}">
<a name="cytoGenetics"></a>
<c:if test="${not empty tumorGenetics}">
  <div align="right"><a href="#strainGenetics"><img align="middle" src="${applicationScope.urlImageDir}/up_arrow.png" border="0" alt="Jump to Genes, Alleles and Transgenes in Strains">Jump to Genes, Alleles and Transgenes in Strains</a></div><br><br>
</c:if>
<table border="0" cellpadding=5 cellspacing=1 width="100%" class="results">
<tr>
  <td class="resultsHeaderLeft" colspan="4"><font class="larger">Cytogenetic observations in the Tumor</font></td>
</tr>        
<tr>
  <td class="resultsHeader">Mouse<br>Chroms.</td>
  
  <td class="resultsHeader">Type</td>
  
  
</tr>

<c:forEach var="rec" items="${cytoGenetics}" varStatus="status">
  <c:choose>
    <c:when test="${status.index%2==0}">
      <tr class="stripe1">
    </c:when>
    <c:otherwise>
      <tr class="stripe2">
    </c:otherwise>
  </c:choose>
  
  <td valign="top">
    
    
    ${rec.displayChromosomes}
  </td>
  
  
  <td valign="top">
    ${rec.alleleTypeName}
    (<a href="tumorSummary.do?tumorChangeKeys=${rec.keys}">${rec.size}</a>)   
    
    <c:choose>  
      <c:when test="${rec.hasImages==true}">
        <img src="${applicationScope.urlImageDir}/pic.gif" alt="Records include assay images" border="0" title="Records include assay images">
      </c:when>
      
      <c:otherwise>
        &nbsp;
      </c:otherwise>
      
    </c:choose>
  </td>
  
  </tr>
</c:forEach>
</table>
</c:when> 
<c:otherwise>
  <!--   No tumor results found.  -->
  <p>
</c:otherwise>
</c:choose>





<!--======================= End Results ====================================-->
</table>
<!--======================== End Main Section ==============================-->
</td>
</tr>
</table>
</body>
</html> 
