<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="News and Events" help="#">

	<jsp:body>	
		<section class="container">

			<ul>
				<c:import url="/live/www/html/whatsNew.html"/>
			</ul>

		</section>
	</jsp:body>
	
</jax:mmhcpage>
