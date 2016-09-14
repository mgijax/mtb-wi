<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<c:import url="meta.jsp">
    <c:param name="pageTitle" value="Warranty Disclaimer &amp; Copyright Notice"/>
</c:import>
</head>
<body>
<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
<tr>
<td width="200" valign="top">
    <c:import url="toolBar.jsp" />
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
<table border="0" cellpadding=5 cellspacing=1 width="100%" class="results">
   <tr class="pageTitle">
       <td colspan="2" width="100%">
           <table width="100%" border=0 cellpadding=0 cellspacing=0>
               <tr>
                   <td width="20%" valign="middle" align="left">
                       <a class="help" href="userHelp.jsp"><img src="${applicationScope.urlImageDir}/help_large.png" border=0 width=32 height=32 alt="Help"></a>
                   </td>
                   <td width="60%" class="pageTitle">
                       Warranty Disclaimer &amp; Copyright Notice
                   </td>
                   <td width="20%" valign="middle" align="center">&nbsp;</td>
               </tr>
           </table>
       </td>
   </tr>
</table>
<!--======================= End Form Header ================================-->
<!--======================= Start Warranty and Disclaimer ==================-->

<pre>
Warranty Disclaimer and Copyright Notice

THE JACKSON LABORATORY MAKES NO REPRESENTATION ABOUT THE
SUITABILITY OR ACCURACY OF THIS SOFTWARE OR DATA FOR ANY PURPOSE, AND
MAKES NO WARRANTIES, EITHER EXPRESS OR IMPLIED, INCLUDING
MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE OR THAT THE USE OF
THIS SOFTWARE OR DATA WILL NOT INFRINGE ANY THIRD PARTY PATENTS,
COPYRIGHTS, TRADEMARKS, OR OTHER RIGHTS. THE SOFTWARE AND DATA ARE
PROVIDED "AS IS".

This software and data are provided to enhance knowledge and
encourage progress in the scientific community and are to be used only
for research and educational purposes. Any reproduction or use for
commercial purpose is prohibited without the prior express written
permission of the Jackson Laboratory.

Copyright &#169; 1998, 2001, 2004, 2007, 2010, 2012 by The Jackson Laboratory

All Rights Reserved
</pre>

<!--======================= End Warranty and Disclaimer ====================-->
<!--======================== End Main Section ==============================-->

            </td>
        </tr>
    </table>
    </body>
</html>

