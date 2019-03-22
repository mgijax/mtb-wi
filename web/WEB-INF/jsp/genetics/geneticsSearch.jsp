<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <c:import url="../../../meta.jsp">
            <c:param name="pageTitle" value="Strain and Tumor Genetics Search Form"/>
        </c:import>
    </head>
    
    <c:import url="../../../body.jsp">
        <c:param name="pageTitle" value="Strain and Tumor Genetics Search Form"/>
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
                <html:form action="geneticsSearchResults" method="GET">
                <!--======================= Start Form Header ==============================-->
                <table border="0" cellpadding=5 cellspacing=1 width="100%" class="results">
                    <tr class="pageTitle">
                        <td colspan="2">
                            <table width="100%" border=0 cellpadding=0 cellspacing=0>
                                <tr>
                                    <td width="20%" valign="middle" align="left">
                                        <a class="help" href="userHelp.jsp#genetics"><img src="${applicationScope.urlImageDir}/help_large.png" border=0 width=32 height=32 style="vertical-align:middle" alt="Help">Help and Documentation</a>
                                    </td>
                                    <td width="60%" class="pageTitle">
                                        Strain and Tumor Genetics Search Form
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
                                        <html:radio property="sortBy" value="Gene Symbol">Gene Symbol</html:radio> &nbsp; 
                                        <html:radio property="sortBy" value="Mutation Type">Mutation Type</html:radio> &nbsp; 
                                        <html:radio property="sortBy" value="Chromosome">Chromosome</html:radio> &nbsp; 
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <font class="label">Max number of items returned:</font>
                                        <html:radio property="maxItems" value="25">25</html:radio> &nbsp; 
                                        <html:radio property="maxItems" value="100">100</html:radio> &nbsp; 
                                        <html:radio property="maxItems" value="500">500</html:radio> &nbsp; 
                                        <html:radio property="maxItems" value="No Limit">No Limit</html:radio>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    
                    <!--====================== Start Error Section =============================-->
<%--
<logic:messagesPresent message="true">
    <tr class="error">
        <td class="errorLabel">Errors</td>
        <td class="errorValue">
            <ul>
           <html:messages id="message" message="true">
               <li>${message}</li>
           </html:messages>
           </ul>
       </td>
   </tr>
</logic:messagesPresent>
--%>
<!--======================= End Error Section ==============================-->
                    <tr class="stripe1">
                        <td class="cat1">
                            Strain and Tumor Genetics:
                        </td>
                        <td class="data1">
                            <table border=0 cellspacing=5 width="100%">
                                
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="5">
                                            <tr>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                               
                                            </tr>
                                            <tr>
                                                <td align="right"><b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('This field offers a text based search against Marker Symbol, Name and Synonym records.<br><br>If a gene of interest is not found on the list please check the Mouse Genome Database to ensure that the gene symbol and name you are searching for is current.', CAPTION, 'Gene / Marker');" onmouseout="return nd();">Gene / Marker</a>:</b></td>
                                                <td>
                                                    <html:select property="markerNameComparison">
                                                        <html:option value="Contains"> Contains </html:option>
                                                        <html:option value="Begins"> Begins </html:option>
                                                        <html:option value="Equals"> Equals </html:option>
                                                    </html:select>
                                                </td>
                                                <td><html:text property="markerName" size="20" maxlength="50"/></td>
                                            </tr>
                                            <tr>
                                                <td align="right"><b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('If a gene of interest is not found on the list please check the Mouse Genome Database to ensure that the gene symbol and name you are searching for is current.', CAPTION, 'Allele');" onmouseout="return nd();">Allele</a>:</b></td>
                                                <td>
                                                    <html:select property="alleleNameComparison">
                                                        <html:option value="Contains"> Contains </html:option>
                                                        <html:option value="Begins"> Begins </html:option>
                                                        <html:option value="Equals"> Equals </html:option>
                                                    </html:select>
                                                </td>
                                                <td><html:text property="alleleName" size="20" maxlength="50"/></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="5">
                                            <tr>
                                                <td>
                                                    <b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('The type of mutation, chromosomal aberration, or other genetic change observed in the strain and/or in the tumor tissue.<br><br>The values for type of genetic change are selected from a controlled vocabulary list.', CAPTION, 'Mutations / Aberrations');" onmouseout="return nd();">Mutations / Aberrations</a>:</b>
                                                    <br>
                                                    <html:select property="alleleGroupType" size="8" multiple="true">
                                                        <html:option value="">ANY</html:option>
                                                        <html:options collection="alleleGroupTypeValues" property="value" labelProperty="label"/>
                                                    </html:select>
                                                    
                                                </td>
                                                
                                                
                                                <td>
                                                    <b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('Chromosome number an allele is found on.<br><br>This search is used to find allele records associated with a specific chromosome number using a pick list.', CAPTION, 'Chromosome');" onmouseout="return nd();">Chromosome</a>:</b>
                                                    <br>
                                                    <html:select property="chromosome" size="8" multiple="true">
                                                        <html:option value="">ANY</html:option>
                                                        <html:options collection="chromosomeValues" property="value" labelProperty="label"/>
                                                    </html:select>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2">
                                                  <b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('Some cytogenetic records include assay images selecting this check box will return only cytognetic records with assay images.', CAPTION, 'Assay Images');" onmouseout="return nd();">Assay Images</a>:</b>
                                                  <br>
                                                    <html:checkbox property="assayImages">Restrict search to entries with associated assay images. </html:checkbox>
                                                </td>
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
            </td>
        </tr>
    </table>
    </html:form>
    </body>
</html> 
