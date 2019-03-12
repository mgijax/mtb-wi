<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>



        <c:import url="../../../meta.jsp">
            <c:param name="pageTitle" value="Patient Derived Xenograft PDX Like Me Search"/>
        </c:import>

       

        <script type="text/javascript">

            function clearForm() {
                document.forms[1].cases.value = "";
                document.forms[1].submit();
            }

        </script>



        <c:import url="../../../body.jsp">
            <c:param name="pageTitle" value="Patient Derived Xenograft PDX Like Me Search"/>
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
                            <html:form action="pdxLikeMe" method="POST">

                                <table border="0" cellpadding="5" cellspacing="1" width="100%" class="results">
                                    <tr class="pageTitle">
                                        <td colspan="3">
                                            <table width="100%" border="0" cellpadding="4" cellspacing="0">
                                                <tr>
                                                    <td width="20%" valign="middle" align="left">
                                                        <a class="help" href="userHelp.jsp#pdxsearch"><img src="${applicationScope.urlImageDir}/help_large.png" border=0 width=32 height=32 alt="Help"></a>
                                                    </td>
                                                    <td width="60%" class="pageTitle">
                                                        Patient Derived Xenograft PDX Like Me Search
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
                                                        
                                                    </td>

                                                    <td>
                                                        <img src="${applicationScope.urlImageDir}/NSG_lg.jpg" height="225" width="450" border=0 alt="NSG Mouse">
                                                    <td>
                                                </tr>
                                               

                                            </table>
                                        </td>

                                    </tr>
                                   
                                     <tr class="pageInfo">
                                        <td colspan="3">
                                            <h4>Search for PDX models whose tumor samples meet multiple genomic criteria</h4>
                                            
                                            <a href="${applicationScope.urlBase}/html/PDXLikeMeHelp.html" target="_blank">Learn how to use PDX Like Me </a>
                                            <br>
                                            <table>
                                                <tr><td>Example:</td><td></td></tr>
                                                <tr><td>CASE 1</td>
                                                <tr><td>KRAS:Amp</td></tr>
                                                <tr><td>TP53:MUT=A159V</td></tr>
                                                <tr><td>ALB:Del</td></tr>
                                                <tr><td>KIT:EXP>1.5</td></tr>

                                            </table>


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
                                            Output options:
                                            <br><br><br><br>
                                            Enter Case information here:

                                        </td>

                                        <td class="data1" width="35%">
                                            <input type="checkbox" name="asCSV" value="asCSV" ${csvChecked}/> Return results as a CSV file<br>
                                            <input type="checkbox" name="actionable" value="actionable" ${actionableChecked}/> Include models with clinically relevant variants for supplied genes
                                            <br>
                                            <input type="checkbox" name="LRP" value="LRP" ${lrpChecked}> If searching by CNV display log ratio ploidy values <br>
                                            <input type="checkbox" name="EXP" value="EXP" ${expChecked}> If searching by expression level display Z score percentile rank values
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
