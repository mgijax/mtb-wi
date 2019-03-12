<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
    
<!--================= Start Include Navigation Menu ========================-->
<table width="95%" align="center" border="0" cellspacing="1" cellpadding="4" class="toolBar">      
    <tr>
        <td align="center">
           <a href="<c:url value='/index.do'/>"><img src="${applicationScope.urlImageDir}/mtb_logo_side.png" border=0 alt="Mouse Tumor Biology Database (MTB)"></a>
           <br clear="all">
           <a href="<c:url value='/index.do'/>">MTB Home</a>&nbsp;&nbsp;&nbsp;<a href="<c:url value='/userHelp.jsp'/>">Help</a>
        </td>
    </tr>
     
    <tr>
        <td>
            <table border="0" cellpadding=0 cellspacing=1 class="results" width="100%">
                <tr>
                    <td>
                        <html:form action="quickSearchResults" method="GET">
                        <table border=0 cellspacing=0 cellpadding=2 class="toolBarSearch">
                            <tr>
                                <td>
                                    <font class="toolBarSearchTitle">Search</font> for
                                </td>
                                <td valign="top" align="right">
                                    <a class="help" href="<c:url value='/userHelp.jsp#searchbox'/>"><img src="${applicationScope.urlImageDir}/help_small.png" height=16 width=16 border=0 alt="help"></a>
                                </td>
                            </tr>
                            <tr>
                                <td colspan=2>
                                    <input class="toolBarInput" name="quickSearchTerm" size=12>&nbsp;
                                    <input class="toolBarButton" type="submit" value="Go">
                                </td>
                            </tr>
                            <tr>
                                <td colspan=2>
                                   in these sections
                                </td>
                            </tr>
                            <tr>
                                <td colspan=2>
                                    <select name="quickSearchSections" class="toolBarSelect" size="5" multiple>
                                        <option value="all"> All Sections </option>
                                        <option value="tumorSearch" selected> Tumor </option>
                                        <option value="organSearch"> Organ </option>
                                        <option value="strainSearch"> Strain </option>
                                        <option value="geneticsSearch"> Genetics </option>
                                    </select>
                                </td>
                            </tr>
                        </table>
                        </html:form>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td>
            <div class="toolBarTitle">Search Forms</div>
            <a href="<c:url value='/tumorSearch.do'/>">Tumor</a>
            <br>
            <a href="<c:url value='/strainSearch.do'/>">Strain</a>
            <br>
            <a href="<c:url value='/geneticsSearch.do'/>">Genetics</a>
            <br>
            <a href="<c:url value='/pathologyImageSearch.do'/>">Pathology Images</a>
            <br>
            <a href="<c:url value='/referenceSearch.do'/>">Reference</a>
            <br>
            <span style="white-space:nowrap"><a href="<c:url value='/advancedSearch.do'/>">Advanced</a></span>
            <br>
            <a href="<c:url value='/orthologySearch.do'/>">Search MTB Using Human Genes</a>
            <br>
            <a href="<c:url value='/geneExpressionSearch.do'/>">Gene Expression Data Sets</a> 
            <br> 
            <center><hr width=90%></center>
            
        </td>
    </tr>
    <tr>
        <td>
            <div class="toolBarTitle">Additional Resources</div>
            
            
            <img src="${applicationScope.urlImageDir}/new.jpg" alt="new">
            <a href="<c:url value='/pdxLikeMe.do'/>">PDX Like Me</a> 
            <br>
            
            
            
            <a href="http://www.pdxfinder.org">PDX Finder</a> 
            <br>
            
              <a href="<c:url value='/pdxSearch.do'/>">PDX Model Search</a>
            <br>
            
            
            <a href="<c:url value='/facetedSearch.do'/>">Faceted Tumor Search</a> 
            <br>
            
             <c:if test="${applicationScope.publicDeployment == false}">
             <a href="<c:url value='/pdxComparison.do'/>">PDX Comparison</a>
              <br> 
           
             <a href="<c:url value='/pdxLogin.do'/>">PDX Login</a>
            <br>
            </c:if>      
           
            
             <span style="white-space:nowrap"><a href="<c:url value='/dynamicGrid.do'/>">Dynamic Tumor Frequency Grid</a></span> 
         
           
            <br>
            <a href="<c:url value='/cancerLinks.jsp'/>">Other Cancer Websites</a>
            <br>
            <a href="<c:url value='/immunohistochemistry.jsp'/>">Immunohistochemistry</a>
            <br>
            <a href="<c:url value='/lymphomaPathology.jsp'/>">Lymphoma Pathology</a>
            <center><hr width=90%></center>
        </td>
    </tr>
    <tr>
        <td>
            <center>
            <a href="http://www.informatics.jax.org"><img border=0 src="${applicationScope.urlImageDir}/logos/mgi_logo.gif" alt="Mouse Genome Informatics"></a><br>
            <a href="http://www.jax.org/"><img height=80 width=160 border=0 src="${applicationScope.urlImageDir}/JaxLogo.gif" alt="The Jackson Laboratory"></a>
            <hr width=90%>
            </center>
        </td>
    </tr>
    <tr>
        <td>
            <a href="<c:url value='/citation.jsp'/>">Citing These Resources</a>
            <br>
            <a href="<c:url value='/copyright.jsp'/>">Warranty Disclaimer <br>&amp; Copyright Notice</a>
            <br>
            Send Questions and <br>Comments to
            <a href="http://www.informatics.jax.org/mgihome/support/mgi_inbox.shtml">User Support</a>.
            <center>
            <hr width=90%>
            <div class="toolBarSmall">
            Last Database Update<br>
             <c:if test="${applicationScope.publicDeployment == true}">
            ${applicationScope.dbLastUpdateDate}<br>
             </c:if>
             <c:if test="${applicationScope.publicDeployment == false}">
                 Daily<br>
             </c:if>
            MTB ${applicationScope.wiVersion}
            </div>
            </center>
        </td>
    </tr>
</table>

<!--================== End Include Navigation Menu =========================-->
