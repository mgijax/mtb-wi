<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html>
<head>
	<c:set var="pageTitle" scope="request" value="Warranty Disclaimer &amp; Copyright Notice"/>
	<c:import url="meta.jsp"/>
</head>

<body class="alt">
<div class="wrap">
<nav><c:import url="toolBar.jsp" /></nav>
<section class="main">

<header>
	<h1>${pageTitle}</h1>
	<a class="help" href="userHelp.jsp"></a>
</header>

<table class="results">

</table>

<!-- ////  Start Warranty and Disclaimer  //// -->

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

<!-- ////  End Warranty and Disclaimer  //// -->

</section>
</div>
</body>
</html>

