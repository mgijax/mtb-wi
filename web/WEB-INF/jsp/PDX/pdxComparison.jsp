<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Patient Derived Xenograft Comparison Form" help="pdxcomparison">
	<jsp:attribute name="head">
	<script type="text/javascript">
		function resetForm(){
			document.forms[1].reset();
			document.getElementById("genes").selectedIndex = -1;
		}
		window.onload = function() {
			if (typeof(Storage) !== "undefined") {
				var save = document.getElementById("saved-genes");
				var genes = localStorage.getItem("savedMTBPDXComparisonGenes");
				if (genes !== null && genes.length > 0) {
					var gList = genes.split(",");
					gList.sort();
					for (var i = 0; i < gList.length; i++) {
						if (gList[i].length > 0){
							var opt = document.createElement("option");
							opt.value = gList[i];
							opt.text = gList[i];
							save.add(opt);
						}
					}
				}
				document.getElementById("savedGenesList").value=genes;
			}else{
				var hide = document.getElementsByName("geneSave");
				for (var i = 0; i < hide.length; i++) {
					hide[i].style.display = "none";
				}
				document.getElementById("geneSaveTxt").innerText="";
			}
		}
		function addGenes(){
			var sel = document.getElementById("genes");
			var save = document.getElementById("saved-genes");
			for (var i = 0; i < sel.length; i++) {
				if (sel.options[i].selected) {
					var opt = document.createElement("option");
					opt.value = sel.options[i].value;
					opt.text = sel.options[i].text;
					save.add(opt);
				}
			}
			doStorage();
		}
		function removeGenes() {
			var save = document.getElementById("saved-genes");
			for (var i = save.length-1; i >= 0; i--) {
				if (save.options[i].selected) {
					save.remove(i);
				}
			}
			doStorage();
		}
		function clearGenes() {
			var save = document.getElementById("saved-genes");
			for (var i = save.length-1; i >= 0; i--) {
				save.remove(i);
			}
			doStorage();
		}
		function doStorage() {
			var geneList ="";
			var save = document.getElementById("saved-genes");
			for(var i = 0; i < save.length; i++) {
				geneList += save.options[i].text + ",";
			}
			if(typeof(Storage) !== "undefined") {
				localStorage.setItem("savedMTBPDXComparisonGenes", geneList);
			}
			document.getElementById("savedGenesList").value=geneList;
		}
	</script>
	</jsp:attribute>
	<jsp:body>
	<html:form action="pdxComparison" method="GET">
	<input type="button" value="Request more &#x00A; information on the &#x00A; JAX PDX program." 
	class="pdx-request-button" onclick="window.location='pdxRequest.do'">
	<table class="results">
		<tr class="page-info">
		</tr>
		<tr class="buttons">
			<td colspan="2">
				<table>
					<tr>
						<td>
							<input type="submit" VALUE="Search">
							<input type="button" VALUE="Reset" onclick="resetForm()">
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td class="cat-2">
				Limit models by primary cancer site
			</td>
			<td class="data-2">
				<table>
					<tr>
						<td>
							<strong><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" 
								onmouseover="return overlib('Select one or more primary sites as search criteria', CAPTION, 'Primary Site');" 
							onmouseout="return nd();">Primary Site</a>
						</strong>
						<!-- \n -->
						<html:select property="primarySites" size="8" multiple="true">
						<html:option value="">ANY</html:option>
						<html:options collection="primarySitesValues" property="value" labelProperty="label"/>
						</html:select>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class="cat-1">
			Limit models by diagnosis
		</td>
		<td class="data-1">
			<table>
				<tr>
					<td>
						<strong><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" 
							onmouseover="return overlib('Select a diagnosis or diagnoses as search criteria.', CAPTION, 'Diagnosis');"
						onmouseout="return nd();">Diagnosis</a>
					</strong>
					<!-- \n -->
					<html:select property="diagnoses" size="8" multiple="true">
					<html:option value="">ANY</html:option>
					<html:options collection="diagnosesValues" property="value" labelProperty="label"/>
					</html:select>
				</td>
			</tr>
		</table>
	</td>
</tr>
<tr>
	<td class="cat-2">
		Select genes for comparison
	</td>
	<td class="data-2">
		<table>
			<tr>
				<td>
					<strong><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" 
						onmouseover="return overlib('Select one or more genes as display criteria', CAPTION, 'Genes');" 
				onmouseout="return nd();">Gene</a></strong>
				<!-- \n -->
				<html:select property="genes" size="8"	styleId="genes" multiple="true" >
				<html:options collection="genesValues" property="value" labelProperty="label"/>
				</html:select>
			</td>
			<td>
				<input name="geneSave" type="button" value="Add" onclick="addGenes();"/>
				<!-- \n -->
			</td>
			<td>
				<span name="geneSave" id="gene-save-txt"><strong>
						<a href="javascript:void(0);" style="text-decoration: none; cursor:help;"
						onmouseover="return overlib('Create a list of saved genes for display criteria.
						<!-- \n -->
						The saved gene list will be used by default.', CAPTION, 'Saved genes');"
					onmouseout="return nd();">Saved Genes</a>
				</strong>
			</span>
			<!-- \n -->
			<select name="geneSave" id="saved-genes" multiple="multiple" size="8" style="width:100px">
			</select>
		</td>
		<td>
			<input name="geneSave" type="button" value="Remove" onclick="removeGenes();"/>
			<!-- \n -->
			<input name="geneSave" type="button" value="Clear" onclick="clearGenes();"/>
			<!-- \n -->
			<input type="hidden" name="savedGenesList" id="saved-genes-list" />
		</td>
	</tr>
</table>
</td>
</tr>
<tr class="buttons">
	<td colspan="2">
		<table>
			<tr>
				<td>
					<input type="submit" VALUE="Search">
					<input type="button" VALUE="Reset" onclick="resetForm()">
				</td>
			</tr>
		</table>
	</td>
</tr>
</table>
</html:form>
</jsp:body>
</jax:mmhcpage>

