<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
<c:import url="meta.jsp">
    <c:param name="pageTitle" value="Citing the Mouse Tumor Biology Database"/>
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
                       <a class="help" href="userHelp.jsp"><img src="${applicationScope.urlImageDir}/help_large.png" border=0 width=32 height=32 style="vertical-align:middle" alt="Help">Help and Documentation</a>
                   </td>
                   <td width="60%" class="pageTitle">
                       Citing the Mouse Tumor Biology Database
                   </td>
                   <td width="20%" valign="middle" align="center">&nbsp;</td>
               </tr>
           </table>
       </td>
   </tr>
</table>
<!--======================= End Form Header ================================-->

<!--======================= Start Citation =================================-->

<br><br>

Please use the following citation when referring to the Mouse Tumor Biology Database. 

<br><br>

<b>Debra M. Krupke, Dale A. Begley, John P. Sundberg, Joel E. Richardson, Steven B. Neuhauser and Carol J. Bult, The Mouse Tumor Biology Database: A Comprehensive Resource for Mouse Models of Human Cancer., Cancer Res October 31 2017 77 (21) e67-e70. </b>
<br><br>
If you wish to cite a specific area of MMHC we suggest a format similar to the following example: 

<br><br>

<b>Some tumor data for this paper were retrieved from the Mouse Models of Human Cancer Database (MMHC, formerly MTB), Mouse Genome Informatics, The Jackson Laboratory, Bar Harbor, Maine. World Wide Web (URL: http://tumor.informatics.jax.org/). (February, 2019 i.e., the date you retrieved the data cited).</b>



<!--======================== End Citation ==================================-->
    
<!--======================== End Main Section ==============================-->

            </td>
        </tr>
    </table>

    </body>
</html> 



