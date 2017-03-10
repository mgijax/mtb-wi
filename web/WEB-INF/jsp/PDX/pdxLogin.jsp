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
        <c:param name="pageTitle" value="PDX Login"/>
    </c:import>

</head>



<c:import url="../../../body.jsp">
    <c:param name="pageTitle" value="PDX Login"/>
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
                                        <a class="help" href="userHelp.jsp#pdxdetails"><img src="${applicationScope.urlImageDir}/help_large.png" border=0 width=32 height=32 alt="Help"></a>
                                    </td>
                                    <td width="60%" class="pageTitle">
                                        PDX Login
                                    </td>
                                    <td width="20%" valign="middle" align="center">&nbsp;</td>
                                </tr>
                            </table>
                        </td>
                    </tr>

                </table>
            </td>
        </tr>



        <tr class="summary">
            <td align="center" colspan="11">
                <table>
                    <tr>
                        <td align="center">
                            <input type="button" value="Open PDX Genomics Dashboard" onClick="window.open('http://pdx-dashboard.jax.org/v4/')">
                        </td>
                    </tr>
                    <tr>
                        <td align="center">
                            <input type="button" value="Open PDX Sample Name Checker" onClick="window.open('http://pdx-dashboard/elims/submission-lookup/')">
                        </td>
                    </tr>
                    
                      <tr>
                     <td align="center">
                            <input type="button" value="Open PDX Sample Sheet Generator" onClick="window.open('http://pdx-dashboard/elims/generate-sheet/')">
                        </td>
                    </tr>
                    <tr>

                    
                    <tr>
                        <td align="center">
                    <c:choose>
                        <c:when test="${not empty failure}">
                            <b>The User ID and Password pair you entered is not valid.<b>
                                    <br>
                                    <br>
                                    </c:when>
                                    </c:choose>
                                    Please enter your <b>User ID</b> and <b>Password</b> below.
                                    <br><br>

                                    <html:form action="pdxLogin">
                                        <table border="0" cellpadding=0 cellspacing=1 class="results">
                                            <tr>
                                                <td>
                                                    <table border=0 cellspacing=5 cellpadding=2 class="quickSearch">
                                                        <tr align="center">
                                                            <td>
                                                                <table border="0">
                                                                    <tr>
                                                                        <td>User ID</td>
                                                                        <td><html:text property="userID" size="30" maxlength="255"/></td>
                                                        </tr>
                                                        <tr>
                                                            <td>Password</td>
                                                            <td><html:password property="password" size="30" maxlength="255"/></td>
                                            </tr>
                                        </table>
                                        <div align="right">
                                            <input type="submit" VALUE="Login">
                                            <input type="reset"  VALUE="Reset">
                                        </div>
                                        </td>
                                        </tr>
                                        </table>
                                        </td>
                                        </tr>
                                        </table>
                                    </html:form>
                                    <br>

                                    </td>
                                    </tr>
                                    </table>
                                    </td>
                                    </tr>
                                    </table>

                                    </html> 

