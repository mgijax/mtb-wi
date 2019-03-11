<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">
<%--
<t:TimerTag title="Index">
--%>

<html>

    <head>

        <c:import url="../../meta.jsp">
            <c:param name="pageTitle" value="Mouse Tumor Biology System (MTB)"/>
        </c:import>

        <script language="javascript">
            var mc = false;
            function toggle() {
                if (mc) {
                    document.getElementById("mc").style.display = 'block';
                    document.getElementById("allMc").style.display = 'none';
                    mc = false;
                } else {
                    document.getElementById("mc").style.display = 'none';
                    document.getElementById("allMc").style.display = 'block';
                    mc = true;
                }
            }
        </script>
    </head>

    <c:import url="../../body.jsp">
        <c:param name="pageTitle" value="Mouse Tumor Biology System (MTB)"/>
    </c:import>

    <table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
            <td width="200" valign="top">
                <c:import url="../../toolBar.jsp"/>
            </td>
            <td class="separator">
                &nbsp;
            </td>
            <td valign="top">
                <table width="95%" align="center" border="0" cellspacing="1" cellpadding="4">
                    <tr>
                        <td>

                            <!--======================= Start Form Header ==============================-->
                            <table border="0" cellpadding=5 cellspacing=1 width="100%" class="results">
                                <tr class="pageTitle">
                                    <td width="100%" colspan="2">
                                        <table width="100%" border=0 cellpadding=0 cellspacing=0>
                                            <tr>
                                                <td class="indexTitle">
                                                    Welcome to the Mouse Tumor Biology (MTB) Database
                                                </td>
                                            </tr>


                                        </table>
                                    </td>
                                </tr>
                            </table>

                            <!--======================= Start Main Section =============================-->

                            <p> The Mouse Tumor Biology (MTB) Database supports the use of the mouse as a model system of human cancers by providing access to information on and data for:
                            <ul>
                                <li>spontaneous and induced tumors in mice,
                                <li>genetically defined mice (inbred, hybrid, mutant, and genetically engineered strains of mice) in which tumors arise,
                                <li>genetic factors associated with tumor susceptibility in mice,
                                <li>somatic genetic-mutations observed in tumors,
                                <li>Patient Derived Xenograft (PDX) models
                            </ul>
                            <p>Examples of the data accessible from MTB include:
                            <ul>
                                <li>tumor frequency & latency data,
                                <li>tumor genomic data,
                                <li>tumor pathology reports and images,
                                <li>associations of models to the scientific literature,
                                <li>links additional on-line cancer resources
                            </ul>
                            <p>
                           

                            <hr width="100%">
                            <p>
                                <%--
                                    <center>
                                    <html:form action="tumorSearchResults" method="GET">
                                    <html:hidden property="maxItems" value="No Limit"/>
                                    <table border="0" cellpadding=0 cellspacing=1 class="results">
                                        <tr>
                                            <td>
                                                <table border=0 cellspacing=5 cellpadding=2 class="quickSearch">
                                                    <tr>
                                                        <td>
                                                            <h4>Quick <a href="javascript:void(0);" style="text-decoration: none; cursor:help;" onmouseover="return overlib('The specific organ (or tissue) in which tumor cells originate.<br><br>The value for this field is selected from a list of controlled vocabulary terms.', CAPTION, 'Organ / Tissue of Origin');" onmouseout="return nd();">Organ/Tissue</a> Search</i></h4>
                                                        </td>
                                                        <td valign="top" align="right">
                                                            <a class="help" href="userHelp.jsp#quickorgan"><img src="${applicationScope.urlImageDir}/help_small.png" height=16 width=16 border=0 alt="help"></a>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan=2>
                                                            <html:select property="organTissueOrigin" size="8" multiple="true">
                                                                <html:option value="">ANY</html:option>
                                                                <html:options collection="organTissueValues" property="value" labelProperty="label"/>
                                                            </html:select>
                                                            <br>
                                                            <INPUT TYPE="submit" NAME="find" VALUE="Search">
                                                            <INPUT TYPE="reset" VALUE="Reset">
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                       
                                    </table>
                                    </html:form>
                                    </center>--%>
                            <p>
                            <div id="mc">    
                                <center>
                                    ${modelCounts}
                                </center> 
                            </div>
                            <div id="allMc" style="display: none">
                                <center>
                                    ${allModelCounts}
                                </center>
                            </div>
                            <p>
                            <hr width="100%">
                            <p>




                                <font class="toolBarTitle">What's new in MTB?</font>
                                    ${whatsNewText}
                                <br>
                                (<a href="whatsNew.jsp">View all...</a>)

                            <p>
                            <hr width="100%">
                            <p>
                                <!--======================== End Main Section ==============================-->
                               

                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>


</body>
</html> 

