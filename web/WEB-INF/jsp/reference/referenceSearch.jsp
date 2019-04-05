<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Reference Search Form" help="references">
	<jax:searchform action="referenceSearchResults" sortby="Year[year desc],First Author[primaryAuthor]">
	<c:import url="/search/reference.jsp"/>	
	</jax:searchform>
</jax:mmhcpage>
