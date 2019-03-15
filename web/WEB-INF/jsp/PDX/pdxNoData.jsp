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
        <c:param name="pageTitle" value="No PDX Data"/>
    </c:import>




</head>



<c:import url="../../../body.jsp">
    <c:param name="pageTitle" value="No PDX Data"/>
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
                <!--======================= Start Form Header ==============================-->
                <table border="0" cellpadding=5 cellspacing=1 width="100%" >
                    <tr class="pageTitle">
                        <td colspan="11" width="100%">
                            <table width="100%" border=0 cellpadding=0 cellspacing=0>
                                <tr>
                                    <td width="20%" valign="middle" align="left">
                                        <a class="help" href="userHelp.jsp#pdxdetails"><img src="${applicationScope.urlImageDir}/help_large.png" border=0 width=32 height=32 style="vertical-align:middle" alt="Help">Help and Documentation</a>
                                    </td>
                                    <td width="60%" class="pageTitle">
                                        The PDX data is not currently available.
                                    </td>
                                    <td width="20%" valign="middle" align="center">&nbsp;</td>
                                </tr>
                            </table>
                        </td>
                    </tr>



                    <tr class="summary">
                        <td align="center" colspan="11">

                            <table>

                                <tr>
                                    <td align="center">
                                        The PDX data is not currently available, please try again soon.

                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
                                    
    </table>
</td>
</tr>
</table>
                </html> 

