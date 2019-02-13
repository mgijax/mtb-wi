<%@ page language="java" contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Mouse Models of Human Cancer Database">
	<div class="container">
		<div class="row">

			<div class="col-md-8" id="mc">		
				<div>
					${modelCounts}
				</div> 
			</div>
			
			<div class="col-xs-4" id="updates">
				<h2>What's new in MMHCdb?</h2>
				${whatsNewText}
				(<a href="whatsNew.jsp">View all...</a>)
			</div>	
					
			<div class="col-xs-12" id="all-mc" style="display: none">
				<div>
					${allModelCounts}
				</div>
			</div>

		</div>
	</div>
</jax:mmhcpage>

