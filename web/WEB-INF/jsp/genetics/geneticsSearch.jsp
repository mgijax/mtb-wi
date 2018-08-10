<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Strain and Tumor Genetics Search Form" help="genetics">
	<jax:searchform action="geneticsSearchResults" sortby="Gene Symbol,Mutation Type,Chromosome">
	<c:import url="/search/genetics.jsp" />
	</jax:searchform>
</jax:mmhcpage>
