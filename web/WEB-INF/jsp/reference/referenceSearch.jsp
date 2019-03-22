<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<c:import url="../../../meta.jsp">
    <c:param name="pageTitle" value="Reference Search Form"/>
</c:import>
</head>

<c:import url="../../../body.jsp">
     <c:param name="pageTitle" value="Reference Search Form"/>
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
<html:form action="referenceSearchResults" method="GET">
<!--======================= Start Form Header ==============================-->
<table border="0" cellpadding=5 cellspacing=1 width="100%" class="results">
   <tr class="pageTitle">
       <td colspan="2">
           <table width="100%" border=0 cellpadding=0 cellspacing=0>
               <tr>
                   <td width="20%" valign="middle" align="left">
                       <a class="help" href="userHelp.jsp#references"><img src="${applicationScope.urlImageDir}/help_large.png" border=0 width=32 height=32 style="vertical-align:middle" alt="Help">Help and Documentation</a>
                   </td>
                   <td width="60%" class="pageTitle">
                       Reference Search Form
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
                            <html:radio property="sortBy" value="year desc">Year</html:radio> &nbsp; 
                            <html:radio property="sortBy" value="primaryAuthor">First Author</html:radio> &nbsp; 
                            <%--
                            <html:radio property="sortBy" value="numericPart">J Number</html:radio>
                            --%>
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

    
    <tr class="stripe1">
        <td class="cat1">
            Reference
        </td>
        <td class="data1">
            <table border=0 cellspacing=5 width="100%">
               
                <tr>
                    <td>
                        <b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('Conducts a text string search against first author names.', CAPTION, 'First Author');" onmouseout="return nd();">First Author</a>:</b>
                        <br>
                        <html:select property="firstAuthorComparison">
                            <html:option value="Contains"> Contains </html:option>
                            <html:option value="Begins"> Begins </html:option>
                            <html:option value="Equals"> Equals </html:option>
                        </html:select> &nbsp; 
                        <html:text property="firstAuthor" size="40" maxlength="255"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        <b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('Conducts a text string search against all author names.', CAPTION, 'Authors');" onmouseout="return nd();">Authors</a>:</b>
                        <br>
                        contains <html:text property="authors" size="40" maxlength="255"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        <b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('Text string search against the abbreviated name of the journal in which the published reference appears.', CAPTION, 'Journal');" onmouseout="return nd();">Journal</a>:</b>
                        <br>
                        <html:select property="journalComparison">
                            <html:option value="Contains"> Contains </html:option>
                            <html:option value="Begins"> Begins </html:option>
                            <html:option value="Equals"> Equals </html:option>
                        </html:select> &nbsp; 
                        <html:text property="journal" size="40" maxlength="255"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table border=0 cellpadding=0 cellspacing=0>
                            <tr>
                                <td>
                                    <b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('Conducts a text string search for publication year.', CAPTION, 'Year');" onmouseout="return nd();">Year</a>:</b>
                                    <br>
                                    <html:select property="yearComparison">
                                        <html:option value="="> Equals </html:option>
                                        <html:option value=">"> Greater Than </html:option>
                                        <html:option value="<"> Less Than </html:option>
                                    </html:select> &nbsp; 
                                    <html:text property="year" size="5" maxlength="4"/>
                                </td>
                                <td width="30">&nbsp;</td>
                                <td>
                                    <b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('Conducts a text string search for the volume of a journal in which an article was published.', CAPTION, 'Volume');" onmouseout="return nd();">Volume</a>:</b>
                                    <br>
                                   
                                    <html:text property="volume" size="10" maxlength="20"/>
                                </td>
                                <td width="30">&nbsp;</td>
                                <td>
                                    <b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('Conducts a text string search for the <i>BEGINNING</i> page number of a journal article.', CAPTION, 'Page');" onmouseout="return nd();">Page</a>:</b>
                                    <br>
                                    
                                    <html:text property="pages"  size="10" maxlength="20"/>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('Conducts a text string search for an article title.', CAPTION, 'Title');" onmouseout="return nd();">Title</a>:</b>
                        <br>
                        <html:select property="titleComparison">
                            <html:option value="Contains"> Contains </html:option>
                            <html:option value="Begins"> Begins </html:option>
                        </html:select> &nbsp; 
                        <html:text property="title" size="40" maxlength="255"/>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <!--
    <tr class="stripe2">
        <td class="cat2">
            Tumor Type
        </td>
        <td class="data1">
            <table border=0 cellspacing=5 width="100%">
                <tr>
                    <td>
                        <b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('The specific organ (or tissue) in which tumor cells originate.<br><br>The value for this field is selected from a list of controlled vocabulary terms.', CAPTION, 'Organ/Tissue of Origin');" onmouseout="return nd();">Organ/Tissue of Origin</a>:</b>
                        <br>
                        <html:select property="organTissue" size="5" >
                            <html:option value="">ANY</html:option>
                            <html:options collection="organTissueValues" property="value" labelProperty="label"/>
                        </html:select>
                    </td>
                </tr>
                <tr>
                    <td>
                        <b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('The value for this field is selected from a list of controlled vocabulary terms.<br><br>This controlled vocabulary was developed using the animal pathology community tumor classification standards whenever possible.', CAPTION, 'Tumor Classification');" onmouseout="return nd();">Tumor Classification</a>:</b>
                        <br>
                        <html:select property="tumorClassification" size="5" >
                            <html:option value="">ANY</html:option>
                            <html:options collection="tumorClassificationValues" property="value" labelProperty="label"/>
                        </html:select>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
               --> 
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



