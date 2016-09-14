<%@ page language="java" contentType="text/html charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!--================== Start Include Meta Information ======================-->
<c:choose>
<c:when test="${empty param.pageTitle}">
    <title>Mouse Tumor Biology Database Project</title>
</c:when>
<c:otherwise>
    <title><c:out value="${param.pageTitle}" escapeXml="false"/></title>
</c:otherwise>   
</c:choose>
 
<!-- META Tags -->
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="description" content="MTB has been designed to aid researchers in such areas as choosing experimental models, reviewing patterns of mutations in specific cancers, and identifying genes that are commonly mutated across a spectrum of cancers.">
<meta name="keywords" CONTENT="mtb, mouse, tumor, biology, jax, lab, laboratory, jackson, mgi, genome, informatics">
<meta name="revised" content="2010/10/30">
<meta name="robots" content="all">

<!-- CSS -->
<link href="${applicationScope.urlStyleSheet}" rel="stylesheet" type="text/css"/>

<!-- JavaScript -->
<script type="text/javascript" src="${applicationScope.urlJavaScript}"></script>
<script type="text/javascript" src="${applicationScope.urlBase}/js/overlib.js"></script>
<script type="text/javascript">
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m
)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', '${applicationScope.googleID}', 'auto');
  ga('send', 'pageview');

</script>


<!-- FavIcon -->
<link rel="icon" href="${applicationScope.urlImageDir}/favicon.ico" type="image/ico">
<link rel="SHORTCUT ICON" href="${applicationScope.urlImageDir}/favicon.ico">

<!--================== End Include Meta Information ========================-->

<c:if test="${not empty sessionScope.pdxUser}"> 
    <p class="pdxLink">Logged in as PDX user <b>${sessionScope.pdxUser}</b> <br> 
    <a href="pdxDashboard.do">Dashboard</a>&nbsp;&nbsp;<a href="pdxLogin.do?logout=true">Logout</a>
    </p>
</c:if>    