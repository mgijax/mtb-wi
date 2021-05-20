<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Patient Derived Xenograft Comparison Form">
	<jsp:attribute name="head">
            
        <link rel="stylesheet" type="text/css" href="${applicationScope.urlBase}/extjs/resources/css/ext-all.css" /> 

	<script type="text/javascript" src="${applicationScope.urlBase}/extjs/adapter/ext/ext-base.js"></script>
	<script type="text/javascript" src="${applicationScope.urlBase}/extjs/ext-all.js"></script>
        
         <style>
            .trigger {
                display:initial;
                max-width: none;
                height:18px !important;
            }
        </style>
            
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
                document.getElementById("saved-genes-list").value=genes;
            }else{
                var hide = document.getElementsByName("geneSave");
                for (var i = 0; i < hide.length; i++) {
                    hide[i].style.display = "none";
                }
                document.getElementById("geneSaveTxt").innerText="";
            }
        }

        
        
        function addGeneNew(){
            var sel = document.getElementById("gene").value;
            var save = document.getElementById("saved-genes");
            var opt = document.createElement("option");
            opt.value = sel;
            opt.text = sel;
            save.add(opt);

            
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
            document.getElementById("saved-genes-list").value=geneList;
        }
        
          Ext.onReady(function(){
        
            var humanGeneProxy = new Ext.data.HttpProxy({
				url: '/mtbwi/pdxHumanGenes.do'
			})
                        
		
            var humanGeneStore = new Ext.data.ArrayStore({
                    id:'thestore',
//   		pageSize: 10, 
                    root:'data',
                    totalProperty: 'total',
                    fields: [{name:'symbol'}, {name:'display'}],
                    proxy: humanGeneProxy,
                    autoLoad:false
            });
            
            var combo = new Ext.form.ComboBox({
                store: humanGeneStore,
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
                height:30,
                listEmptyText:'no matching gene',
                renderTo: 'geneSelect'
        //        ,pageSize:10
            });
            
            
            // to clear value on reset. from sencha forum.
			Ext.form.ComboBox.prototype.initQuery = Ext.form.ComboBox.prototype.initQuery.createInterceptor(function(e)
			{
				var v = this.getRawValue();
				
				if (typeof v === 'undefined' || v === null || v === '')
					this.clearValue();
			});
			
  			var idStore = new Ext.data.ArrayStore({
							id: 0,
							fields: [
								'id',
								'display'
							],
							data:${modelIDs}
						})
			
 			var modelIDcombo = new Ext.form.ComboBox({
				store: idStore,
				minChars:1,
				valueField:'id',
				displayField:'display',
				typeAhead: true,
				lazyRender:true,
				mode: 'local',
				forceSelection: false,
				triggerAction: 'all',
				selectOnFocus:true,
				hideTrigger:false,
                                triggerClass: "trigger",
				hiddenName:'modelID',
				width:560,
				listEmptyText:'',
				renderTo: 'modelIDCombo'
		//		,pageSize:10
			});
            
	
        });
        
         
    </script>
	</jsp:attribute>
	<jsp:attribute name="subnav">
	<a href="pdxRequest.do">Request more information on the JAX PDX program</a>
	</jsp:attribute>
	<jsp:body>
	
	
    <section>
        <div class="container">
            
	<jax:searchform action="pdxComparison">
            
            <fieldset>
                <legend>Select a model ID</legend>
                <fieldset>
                    <legend data-tip="Select a specific model ID">Model ID</legend>
                    <div id="modelIDCombo"></div>
                </fieldset>
                
            </fieldset>    
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
                        <div id="geneSelect"></div>
		</fieldset>
		<input name="geneSave" type="button" value="Add" onclick="addGeneNew();"/>
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

