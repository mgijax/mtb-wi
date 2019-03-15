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
    <c:param name="pageTitle" value="Tumor Search Form"/>
</c:import>
</head>

<c:import url="../../../body.jsp">
     <c:param name="pageTitle" value="Tumor Search Form"/>
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
<html:form action="tumorSearchResults" method="GET">
<!--======================= Start Form Header ==============================-->
<table border="0" cellpadding=5 cellspacing=1 width="100%" class="results">
   <tr class="pageTitle">
       <td colspan="2">
           <table width="100%" border=0 cellpadding=0 cellspacing=0>
               <tr>
                   <td width="20%" valign="middle" align="left">
                       <a class="help" href="userHelp.jsp#tumors"><img src="${applicationScope.urlImageDir}/help_large.png" border=0 width=32 height=32 style="vertical-align:middle" alt="Help">Help and Documentation</a>
                   </td>
                   <td width="60%" class="pageTitle">
                       Tumor Search Form
                   </td>
                   <td width="20%" valign="middle" align="center">&nbsp;</td>
               </tr>
           </table>
       </td>
   </tr>
<!--======================= End Form Header ================================-->
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
                            <html:radio property="sortBy" value="organ">Organ of tumor origin</html:radio> &nbsp; 
                            <html:radio property="sortBy" value="strain">Strain of tumor origin</html:radio> &nbsp; 
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
<!--======================= Start Error Section =============================-->
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
            Associated Tumors
        </td>
        <td class="data1">
            <table border=0 cellspacing=5 width="100%">
                <tr>
                    <td>
                        <b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('The specific organ (or tissue) in which tumor cells originate.<br><br>The value for this field is selected from a list of controlled vocabulary terms.', CAPTION, 'Organ / Tissue of Origin');" onmouseout="return nd();">Organ/Tissue of Origin</a>:</b>
                        <br>
                        <html:select property="organTissueOrigin" size="8" multiple="true">
                            <html:option value="">ANY</html:option>
                            <html:options collection="organTissueValues" property="value" labelProperty="label"/>
                        </html:select>
                    </td>
                </tr>
                <tr>
                    <td>
                        <b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('The value for this field is selected from a list of controlled vocabulary terms.<br><br>This controlled vocabulary was developed using the animal pathology community tumor classification standards whenever possible.', CAPTION, 'Tumor Classification');" onmouseout="return nd();">Tumor Classification</a>:</b>
                        <br>
                        <html:select property="tumorClassification" size="8" multiple="true">
                            <html:option value="">ANY</html:option>
                            <html:options collection="tumorClassificationValues" property="value" labelProperty="label"/>
                        </html:select>
                    </td>
                </tr>
                <tr>
                    <td>
                        <b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('This is a combination of the value from the Organ/Tissue of Origin field and the value from the Tumor Classification field.<br><br>The default operator is CONTAINS.<br><br>Search for a text string in the tumor name box is conducted against tumor name and synonym records.', CAPTION, 'Tumor Name');" onmouseout="return nd();">Tumor Name</a>:</b>
                        <br>
                        contains <html:text property="tumorName" size="30" maxlength="255"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        <b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('This field is used to distinguish tumors that arose under particular treatment conditions from those that arose spontaneously.<br><br>Treatment type offers a means to search for tumors induced by agents falling under a shared classification (based on source/mechanism of action).<br><br>The value for this field is selected from a list of controlled vocabulary terms.', CAPTION, 'Treatment Type');" onmouseout="return nd();">Treatment Type</a>:</b>
                        <br>
                        <html:select property="agentType">
                            <html:option value="">ANY</html:option>
                            <html:options collection="agentTypes" property="value" labelProperty="label"/>
                        </html:select>
                    </td>
                </tr>
                <tr>
                    <td>
                        <b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('Agents are the specific chemicals, drugs, types of radiation, etc. which were given to the mice.<br><br>Examples of possible agents:<ul><li>1-methyl-1-nitrosourea (MNU)</li><li>12-O-tetradecanoylphorbol-13-acetate (TPA)</li><li>angiostatin</li><li>benzo[a]pyrene (BP) (BaP) (B[a]P)</li><li>estrogen</li><li>testosterone</li><li>gamma-radiation</li><li>MMTV (mouse mammary tumor virus)</li></ul>', CAPTION, 'Treatment Agent');" onmouseout="return nd();">Treatment Agent</a>:</b>
                        <br>
                        contains <html:text property="agent" size="30" maxlength="255"/>
                    </td>
                </tr>

                <tr>
                    <td>
                        <b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('Used to search for tumors that have been reported to metastasize to a particular organ.<br><br>First choose the <i>Restrict search to metastasis tumors only</i> then select an organ from the <i>Metastasizes to the</i> menu.', CAPTION, 'Metastasis');" onmouseout="return nd();">Metastasis</a>:</b>
                        <br>
                        <html:checkbox property="metastasisLimit"/> Restrict search to metastatic tumors only. 
                        <br>
                        <table border="0">
                            <tr>
                                <td align="right" valign="top" width="200">
                                    Metastasizes to the:
                                </td>
                                <td>
                                    <html:select property="organTissueAffected" size="8" multiple="true">
                                        <html:option value="">ANY</html:option>
                                        <html:options collection="organTissueValuesMets" property="value" labelProperty="label"/>
                                    </html:select>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('Pathology images (histology photomicrographs) of the tumor.<br><br>To search for tumor records associated with Pathology images, choose the box next to <i>Restrict search to entries with associated pathology images</i>.', CAPTION, 'Pathology Images');" onmouseout="return nd();">Pathology Images</a>:</b>
                        <br>
                        <html:checkbox property="mustHaveImages"/> Restrict search to entries with associated pathology images.
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
</html:form>
<!--======================== End Main Section ==============================-->
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</body>
</html> 
