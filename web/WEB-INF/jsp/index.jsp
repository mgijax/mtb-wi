<%@ page language="java" contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Mouse Models of Human Cancer Database">
	<jsp:attribute name="head">
		<link rel="stylesheet" type="text/css" href="./live/www/css/home.css"/>
	</jsp:attribute>
	<jsp:body>	
	<div class="container">
		<div>

			<div id="mc">		
				<div>
					${modelCounts}
				</div> 
			</div>
			
			<div id="updates">
				<h2>What's new in MMHCdb?</h2>
				${whatsNewText}
				(<a href="whatsNew.jsp">View all...</a>)
			</div>	
					
			<div id="all-mc" style="display: none">
				<div>
					${allModelCounts}
				</div>
			</div>

		</div>
	</div>
	</jsp:body>
</jax:mmhcpage>
