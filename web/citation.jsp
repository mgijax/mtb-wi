<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html>
<head>
	<c:set var="pageTitle" scope="request" value="Citing the Mouse Tumor Biology Database"/>
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

<!-- ////  Start Citation  //// -->

<!-- \n -->

<!-- \n -->

Please use the following citation when referring to the Mouse Tumor Biology Database. 

<!-- \n -->

<!-- \n -->

<strong>Krupke DM; Begley DA; Sundberg JP; Bult CJ; Eppig JT, The Mouse Tumor Biology database., Nat Rev Cancer 2008 Jun;8(6):459-65.</strong>

<!-- \n -->

<!-- \n -->

If you wish to cite a specific area of MTB we suggest a format similar to the following example: 

<!-- \n -->

<!-- \n -->

<strong> Some tumor data for this paper were retrieved from the
Mouse Tumor Biology Database (MTB), Mouse Genome Informatics, The
Jackson Laboratory, Bar Harbor, Maine. World Wide Web (URL:
http://www.informatics.jax.org/). (October, 1998 i.e., the date you
retrieved the data cited). </strong>

<!-- ////  End Citation  //// -->

</section>
</div>
</body>
</html>
 

