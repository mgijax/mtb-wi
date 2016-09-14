<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
  <head>
    <c:import url="../../../meta.jsp">
      <c:param name="pageTitle" value="Gene Expression Data Set Search Form"/>
    </c:import>
  </head>
  
  <c:import url="../../../body.jsp">
    <c:param name="pageTitle" value="Gene Expression Data Set Search Form"/>
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
              <html:form action="geneExpressionSearchResults" method="GET">
                <!--======================= Start Form Header ==============================-->
                <table border="0" cellpadding=5 cellspacing=1 width="100%" class="results">
                <tr class="pageTitle">
                  <td colspan="2">
                    <table width="100%" border=0 cellpadding=0 cellspacing=0>
                      <tr>
                        <td width="20%" valign="middle" align="left">
                          <a class="help" href="userHelp.jsp#geneexpression"><img src="${applicationScope.urlImageDir}/help_large.png" border=0 width=32 height=32 alt="Help"></a>
                        </td>
                        <td width="60%" class="pageTitle">
                          Gene Expression Data Set Search Form
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
                      
                    </table>
                  </td>
                </tr>
                
                <tr class="stripe1">
                <td class="cat1">
                  Search Criteria
                </td>
                <td class="data1">
                <table border=0 cellspacing=5 width="100%">
                  
                  <tr>
                    <td>
                      <b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('Organ<br>The value for this field is selected from a list of controlled vocabulary terms.', CAPTION, 'Organ');" onmouseout="return nd();">Organ</a>:</b>
                      <br>
                      <html:select property="organ" size="8" multiple="true">
                        <html:option value="">ANY</html:option>
                        <html:options collection="organValues" property="value" labelProperty="label"/>
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
                      <b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('Strain names in MTB, where possible, follow the international nomenclature guidelines for the naming of laboratory mouse strains.', CAPTION, 'Strain Name');" onmouseout="return nd();">Strain Name:</a></b>
                      <br>
                      <html:select property="likeClause">
                        <html:option value="Contains"> Contains </html:option>
                        <html:option value="Begins"> Begins </html:option>
                        <html:option value="Equals"> Equals </html:option>
                      </html:select>&nbsp;
                      <html:text property="strainName" size="30" maxlength="255"/>
                      
                    </td>
                  </tr>
                  
                  <tr>
                    <td>
                      <b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('Platforms.', CAPTION, 'Platforms');" onmouseout="return nd();">Platform</a>:</b>
                      <br>
                      <html:select property="platform" size="8" multiple="true">
                        <html:option value="">ANY</html:option>
                        <html:options collection="platformValues" property="value" labelProperty="label"/>
                      </html:select>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <b>Note</b>: Searching with criteria from more than one category may produce zero results.
                    </td>
                  </tr>
                  
                </table>
                
                
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
                
              </html:form>
            </td>
          </tr>
        </table>
        <!--======================== End Main Section ==============================-->
      </td>
    </tr>
  </table>
  
  </body>
</html> 
