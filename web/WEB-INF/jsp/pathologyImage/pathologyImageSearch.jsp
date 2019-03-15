<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<c:import url="../../../meta.jsp">
    <c:param name="pageTitle" value="Pathology Image Search Form"/>
</c:import>
</head>

<c:import url="../../../body.jsp">
     <c:param name="pageTitle" value="Pathology Image Search Form"/>
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
<html:form action="pathologyImageSearchResults" method="GET">
<!--======================= Start Form Header ==============================-->
<table border="0" cellpadding=5 cellspacing=1 width="100%" class="results">
   <tr class="pageTitle">
       <td colspan="2">
           <table width="100%" border=0 cellpadding=0 cellspacing=0>
               <tr>
                   <td width="20%" valign="middle" align="left">
                       <a class="help" href="userHelp.jsp#pathology"><img src="${applicationScope.urlImageDir}/help_large.png" border=0 width=32 height=32 style="vertical-align:middle" alt="Help">Help and Documentation</a>
                   </td>
                   <td width="60%" class="pageTitle">
                       Pathology Image Search Form
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
                            <html:radio property="sortBy" value="organ">Organ of origin</html:radio> &nbsp; 
                            <html:radio property="sortBy" value="strain">Strain of origin</html:radio> &nbsp; 
                            <html:radio property="sortBy" value="method">Method</html:radio> &nbsp; 
                            <html:radio property="sortBy" value="antibody">Antibody</html:radio>
                    </td>
                </tr>
                <tr>
                    <td>
                        <font class="label">Max number of pathology reports returned:</font>
                            <html:radio property="maxItems" value="5">5</html:radio> &nbsp; 
                            <html:radio property="maxItems" value="10">10</html:radio> &nbsp; 
                            <html:radio property="maxItems" value="100">100</html:radio> &nbsp; 
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
            Tumors
        </td>
        <td class="data1">
            <table border=0 cellspacing=5 width="100%">
                <tr>
                    <td>
                        <b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('The specific organ (or tissue) in which tumor cells originate.<br><br>The value for this field is selected from a list of controlled vocabulary terms.', CAPTION, 'Organ/Tissue of Origin');" onmouseout="return nd();">Organ/Tissue of Origin</a>:</b>
                        <br>
                        <html:select property="organTissueOrigin" size="8" multiple="true">
                            <html:option value="">ANY</html:option>
                            <html:options collection="organsOfOrigin" property="value" labelProperty="label"/>
                        </html:select>
                    </td>
                </tr>
                <tr>
                    <td>
                        <b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('The value for this field is selected from a list of controlled vocabulary terms.<br><br>This controlled vocabulary was developed using the animal pathology community tumor classification standards whenever possible.', CAPTION, 'Tumor Classification');" onmouseout="return nd();">Tumor Classification</a>:</b>
                        <br>
                        <html:select property="tumorClassification" size="8" multiple="true">
                            <html:option value="">ANY</html:option>
                            <html:options collection="tumorClassifications" property="value" labelProperty="label"/>
                        </html:select>
                    </td>
                </tr>
                <tr>
                    <td>
                        <b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('The organ (or tissue) in which tumor cells are found.<br><br>The organ/tissue affected by a tumor can be different than the organ/tissue of tumor origin when there is a metastatic event or if the original tumor is transplanted into a different mouse.<br><br>The value for this field is selected from a list of controlled vocabulary terms.', CAPTION, 'Organ/Tissue Affected');" onmouseout="return nd();">Organ/Tissue Affected</a>:</b>
                        <br>
                        <html:select property="organTissueAffected" size="8" multiple="false">
                            <html:option value="">ANY</html:option>
                            <html:options collection="organsAffected" property="value" labelProperty="label"/>
                        </html:select>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr class="stripe2">
        <td class="cat2">
            Image
        </td>
        <td class="data2">
            <table border=0 cellspacing=5 width="100%">
                <%--
                <tr>
                    <td>
                        <b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('This field offers a text based search against the diagnosis and description fields associated with a Pathological record.', CAPTION, 'Diagnosis or Description');" onmouseout="return nd();">Diagnosis or Description</a>:</b>
                        <br>
                        contains &nbsp;
                        <html:text property="diagnosisDescription" size="40" maxlength="50"/>
                    </td>
                </tr>
                --%>
                <tr>
                    <td>
                        <b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('This field searches for specific histological procedures from a select list of procedures.', CAPTION, 'Stain / Method');" onmouseout="return nd();">Stain / Method</a>:</b>
                        <br>
                        <html:select property="method">
                            <html:option value="">ANY</html:option>
                            <html:options collection="methods" property="value" labelProperty="label"/>
                        </html:select>
                    </td>
                </tr>
                <tr>
                    <td>
                        <b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('This field searches for antibodies used in staining procedures.<br><br>Searches are conducted from a list of antibody names which include clone numbers, when available.', CAPTION, 'Antibody');" onmouseout="return nd();">Antibody</a>:</b>
                        <br>
                        <html:select property="antibody" size="8" multiple="true">
                            <html:option value="">ANY</html:option>
                            <html:options collection="antibodies" property="value" labelProperty="label"/>
                        </html:select>
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



