<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Strain Search Form" help="strains">
	<jax:searchform action="strainSearchResults" sortby="Strain Name[name],Strain Type[type]">
	<c:import url="/search/strain.jsp"/>
	</jax:searchform>
</jax:mmhcpage>
