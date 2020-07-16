<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="PDX Image Detail">
<jsp:attribute name="head">
<link rel="stylesheet" type="text/css" href="./live/www/css/results.css"/>
</jsp:attribute>

<jsp:body>
<section id="image-detail">
	<img height=800 width=800 src="${applicationScope.pdxFileURL}${fileName}">
</section>
<section id="summary">
	<div class="container">
		<table>
			<tbody>
				<jax:sumrow dt="Description" dd="${description}" />
			</tbody>
		</table>
	</div>
</section>
</jsp:body>
</jax:mmhcpage>

