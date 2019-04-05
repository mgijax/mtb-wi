<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Tumor Search Form" help="tumors">
	<jax:searchform action="tumorSearchResults" sortby="Organ of tumor origin[organ],Strain of tumor origin[strain]">
	<c:import url="/search/tumor.jsp"/>
	<c:import url="/search/strain.jsp"/>
	<c:import url="/search/reference.jsp"/>
	</jax:searchform>			
</jax:mmhcpage>
