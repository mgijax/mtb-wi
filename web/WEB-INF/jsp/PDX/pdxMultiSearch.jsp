<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>

        <link rel="stylesheet" type="text/css" href="${applicationScope.urlBase}/extjs/resources/css/ext-all.css" /> 



        <c:import url="../../../meta.jsp">
            <c:param name="pageTitle" value="Patient Derived Xenograft Multi Search Form"/>
        </c:import>

        <script type="text/javascript" src="${applicationScope.urlBase}/extjs/adapter/ext/ext-base.js"></script>
        <script type="text/javascript" src="${applicationScope.urlBase}/extjs/ext-all.js"></script>

        <script type="text/javascript">

            function clearForm() {
                document.forms[1].cases.value = "";
                document.forms[1].submit();
            }

        </script>



        <c:import url="../../../body.jsp">
            <c:param name="pageTitle" value="Patient Derived Xenograft Search Form"/>
        </c:import>
    </head>

    <table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
            <td width="200" valign="top">
                <c:import url="../../../pdxToolBar.jsp" />
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
                            <html:form action="pdxMultiSearch" method="GET">

                                <table border="0" cellpadding="5" cellspacing="1" width="100%" class="results">
                                    <tr class="pageTitle">
                                        <td colspan="3">
                                            <table width="100%" border="0" cellpadding="4" cellspacing="0">
                                                <tr>
                                                    <td width="20%" valign="middle" align="left">
                                                        <a class="help" href="userHelp.jsp#pdxsearch"><img src="${applicationScope.urlImageDir}/help_large.png" border=0 width=32 height=32 alt="Help"></a>
                                                    </td>
                                                    <td width="60%" class="pageTitle">
                                                        Patient Derived Xenograft Search Form
                                                    </td>
                                                    <td width="20%" valign="middle" align="right">
                                                        <input type="button" value="Request more &#x00A; information on the &#x00A; JAX PDX program." class="pdxRequestButton" onclick="window.location = 'pdxRequest.do'">
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <!--======================= End Form Header ================================-->
                                    <tr class="pageInfo">
                                        <td colspan="3">
                                            <table border=0 cellspacing=2 width="100%">
                                                <tr>
                                                    <td>
                                                        &nbsp;Patient Derived Xenograft (PDX) models for cancer research are created by the implantation of human cells and tumor tissue into immune compromised mouse hosts.  PDX models provide a platform for in vivo cancer biology studies and pre-clinical cancer drug efficacy testing.  The current state of the art mouse host is the "NOD-SCID-Gamma2" (NSG) mouse. NSG mice lack mature T and B cells, have no functional natural killer cells, and are deficient in both innate immunity and cytokine signaling.   
                                                        <br>
                                                        &nbsp;
                                                        <br>
                                                        <br>
                                                        <br>
                                                        <table class="miTable">
                                                            <tr><td border="5px">
                                                                    <p class="miTitle">PDX minimal information data standards are now public. Read about it in Cancer Research, <a href="https://www.ncbi.nlm.nih.gov/pubmed/29092942">Meehan et al., 2017</a></p>
                                                                    <ul>
                                                                        <li class="realList"><a href="${applicationScope.urlBase}/html/PDXMI_README.docx">PDX Minimal Information Read Me (doc)</a><br>
                                                                        <li class="realList"><a href="${applicationScope.urlBase}/html/PDXMIPublication.xlsx">PDX Minimal Information Specification (xls)</a><br>
                                                                        <li class="realList"><a href="http://www.informatics.jax.org/mgihome/support/mgi_inbox.shtml">PDX Minimal Information Feedback (web form)</a><br>
                                                                    </ul>
                                                                    <br>
                                                                </td></tr>
                                                        </table>
                                                    </td>

                                                    <td>
                                                        <img src="${applicationScope.urlImageDir}/NSG_lg.jpg" height="225" width="450" border=0 alt="NSG Mouse">
                                                    <td>
                                                </tr>

                                            </table>
                                        </td>

                                    </tr>
                                    <tr class="buttons">
                                        <td colspan="3" style="padding: 20px">
                                            The format for the input should be one or more cases as follows<br>
                                            CASE &lt;unique case identifier&gt;<br>
                                            Followed by one or more gene descriptions using a simplified Onco Query Language format.
                                            Gene descriptions can be of four types, one per line<br>
                                            &lt;Gene&gt;:MUT<br>
                                            &lt;Gene&gt;:MUT=&lt;VARIANT&gt;<br>
                                            &lt;Gene&gt;:Amp<br>
                                            &lt;Gene&gt;:Del<br>

                                            Example:<br><br>
                                            CASE 1<br>
                                            KRAS:Amp            (search for models with amplified KRAS)<br>
                                            TP53:MUT=A159V      (search for models with A159V variant of TP53)<br>
                                            ALB:Del             (search for models with deleted ALB)<br>
                                            <br>
                                            CASE 2<br>
                                            CDK4:Amp<br>
                                            ETNK1:Amp<br>
                                            KRAS:Del<br>
                                        </td>
                                    </tr>


                                    <tr class="buttons">
                                        <td colspan="3">
                                            <table border=0 cellspacing=2 width="100%">
                                                <tr>
                                                    <td>
                                                        <input type="submit" VALUE="Search">
                                                        <input type="button" VALUE="Reset" onclick="clearForm();">


                                                    </td>

                                                </tr>
                                            </table>
                                        </td>
                                    </tr>

                                    <tr class="stripe1">

                                        <td class="cat1">
                                            Enter Case information here:

                                        </td>

                                        <td class="data1">
                                            <input type="checkbox" name="asCSV" value="asCSV"/> Return results as a CSV file &nbsp;&nbsp;&nbsp;&nbsp; <input type="checkbox" name="actionable" value="actionable"/> Include models with clinically relevant variants for supplied genes
                                            <br>
                                            <textarea rows="20" cols="50" name="cases">${cases}</textarea>
                                        </td>
                                        <td class="data1">
                                            ${table}
                                        </td>
                                    </tr>




                                    <tr class="buttons">
                                        <td colspan="3">
                                            <table border=0 cellspacing=5 width="100%">
                                                <tr>
                                                    <td>
                                                        <input type="submit" VALUE="Search">
                                                        <input type="button" VALUE="Reset" onclick="clearForm();">
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </html:form>

                            </table>
                            <!--======================== End Main Section ==============================-->

                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <!-- If the page reloads to update variants don't go back to the top of the page -->
    <c:if test="${not empty update}">
        <script>
            document.location = "#variantsLocation"
        </script>
    </c:if>
</body>
</html> 
