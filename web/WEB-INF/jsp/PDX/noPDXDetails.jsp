<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="No matching PDX models">
<jsp:attribute name="subnav">
<a href="pdxRequest.do">Request more information on the JAX PDX program</a>
</jsp:attribute>
<jsp:body>	
<section class="container content">
	<h3>There is no available PDX model with ID <em>${modelID}</em></h3>
	<p><a href="pdxRequest.do">Request more information on the JAX PDX program</a></p>
</section>
</jsp:body>
</jax:mmhcpage>

