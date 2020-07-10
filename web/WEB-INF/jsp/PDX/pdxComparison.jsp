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
                var save = document.getElementById("savedGenes");
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
            var save = document.getElementById("savedGenes");
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
        
        function addGenesNew(){
            var sel = document.forms[1].gene.value;
            var save = document.getElementById("savedGenes");
            var opt = document.createElement("option");
            opt.value = sel;
            opt.text = sel;
            save.add(opt);

            
            doStorage();
        }
        

        function removeGenes() {
            var save = document.getElementById("savedGenes");
            for (var i = save.length-1; i >= 0; i--) {
                if (save.options[i].selected) {
                    save.remove(i);

                }
            }
            doStorage();
        }

        function clearGenes() {
            var save = document.getElementById("savedGenes");
            for (var i = save.length-1; i >= 0; i--) {
                save.remove(i);
            }
            doStorage();
        }

        function doStorage() {
            var geneList ="";
            var save = document.getElementById("savedGenes");
            for(var i = 0; i < save.length; i++) {
                geneList += save.options[i].text + ",";
            }
            if(typeof(Storage) !== "undefined") {
                localStorage.setItem("savedMTBPDXComparisonGenes", geneList);
            }
            document.getElementById("savedGenesList").value=geneList;
        }
        
          Ext.onReady(function(){
        
          var dataProxy = new Ext.data.HttpProxy({
                url: '/mtbwi/pdxHumanGenes.do'
            })
        
            var humanGenestore = new Ext.data.ArrayStore({
                id:'thestore',
     //           pageSize: 10, 
                root:'data',
                totalProperty: 'total',
                fields: [{name:'symbol'}, {name:'display'}],
                proxy: dataProxy,
                autoLoad:false
            });
            
            var combo = new Ext.form.ComboBox({
                store: humanGenestore,
                minChars:2,
                valueField:'symbol',
                displayField:'display',
                typeAhead: true,
                mode: 'remote',
                forceSelection: false,
                triggerAction: 'all',
                selectOnFocus:true,
                hideTrigger:true,
                hiddenName:'gene',
                width:260,
                listEmptyText:'no matching gene',
                renderTo: 'geneSelect'
        //        ,pageSize:10
            });
	
        });
        
         
    </script>
	</jsp:attribute>
	<jsp:body>
	
	<a href="pdxRequest.do" target="_blank">Request more information on the JAX PDX program.</a>
	
    <section>
        <div class="container">
            
	<jax:searchform action="pdxComparison">
	<fieldset>
		<legend>Limit models by primary cancer site</legend>
		<fieldset>
			<legend data-tip="Select one or more primary sites as search criteria">Primary Site</legend>
			<html:select property="primarySites" size="8" multiple="true">
			<html:option value="">ANY</html:option>
			<html:options collection="primarySitesValues" property="value" labelProperty="label"/>
			</html:select>
		</fieldset>
	</fieldset>
	<fieldset>
		<legend>Limit models by diagnosis</legend>
		<fieldset>
			<legend data-tip="Select a diagnosis or diagnoses as search criteria.">Diagnosis</legend>
			<html:select property="diagnoses" size="8" multiple="true">
			<html:option value="">ANY</html:option>
			<html:options collection="diagnosesValues" property="value" labelProperty="label"/>
			</html:select>
		</fieldset>
	</fieldset>
	<fieldset>
		<legend>Select genes for comparison</legend>
		<fieldset>
			<legend data-tip="Select one or more genes as display criteria">Gene</legend>
			<html:select property="genes" size="8"	styleId="genes" multiple="true" >
			<html:options collection="genesValues" property="value" labelProperty="label"/>
			</html:select>
		</fieldset>
		<input name="geneSave" type="button" value="Add" onclick="addGenes();"/>
		<fieldset>
			<legend data-tip="Create a list of saved genes for display criteria.&#10;The saved gene list will be used by default.">Saved Genes</legend>
			<select name="geneSave" id="saved-genes" multiple="multiple" size="8" style="width:100px">
			</select>
			<input name="geneSave" type="button" value="Remove" onclick="removeGenes();"/>
			<input name="geneSave" type="button" value="Clear" onclick="clearGenes();"/>
			<input type="hidden" name="savedGenesList" id="saved-genes-list" />
		</fieldset>
	</fieldset>
	</jax:searchform>
        </div>
    </section>
        
	</jsp:body>
</jax:mmhcpage>

