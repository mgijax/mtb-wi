<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
           <link rel="stylesheet" type="text/css" href="${applicationScope.urlBase}/extjs/resources/css/ext-all.css" /> 
         <script type="text/javascript" src="${applicationScope.urlBase}/extjs/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="${applicationScope.urlBase}/extjs/ext-all.js"></script>
        
    <c:import url="../../../meta.jsp">
        <c:param name="pageTitle" value="Patient Derived Xenograft Comparison"/>
    </c:import>

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


    <c:import url="../../../body.jsp">
        <c:param name="pageTitle" value="Patient Derived Xenograft Comparison Form"/>
    </c:import>

    <table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
            <td width="200" valign="top">
        <c:import url="../../../pdxToolBar.jsp" />
    </td>
    <td class="separator">
        &nbsp;
    </td>
    <td valign="top">
        <table width="95%" align="center" border="0" cellspacing="1" cellpadding="4">
            <tr>
                <td>
                    <!--======================= Start Main Section =============================-->

                    <!--======================= Start Form Header ==============================-->
            <html:form action="pdxComparison" method="GET">

                <table border="0" cellpadding="5" cellspacing="1" width="100%" class="results">
                    <tr class="pageTitle">
                        <td colspan="2">
                            <table width="100%" border="0" cellpadding="4" cellspacing="0">
                                <tr>
                                    <td width="20%" valign="middle" align="left">
                                        <a class="help" href="userHelp.jsp#pdxcomparison">
                                            <img src="${applicationScope.urlImageDir}/help_large.png" border=0 width=32 height=32 alt="Help">
                                        </a>
                                    </td>
                                    <td width="60%" class="pageTitle">
                                        Patient Derived Xenograft Comparison Form
                                    </td>
                                    <td width="20%" valign="middle" align="right">
                                        <input type="button" value="Request more &#x00A; information on the &#x00A; JAX PDX program." 
                                               class="pdxRequestButton" onclick="window.location='pdxRequest.do'">
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <!--======================= End Form Header ================================-->
                    <tr class="pageInfo">
                    </tr>

                    <tr class="buttons">
                        <td colspan="2">
                            <table border=0 cellspacing=2 width="100%">
                                <tr>
                                    <td>
                                        <input type="submit" VALUE="Search">
                                        <input type="button" VALUE="Reset" onclick="resetForm()">
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>


                    <tr class="stripe2">
                        <td class="cat2">
                            Limit models by primary cancer site
                        </td>
                        <td class="data2">
                            <table>
                                <tr>
                                    <td>
                                        <b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" 
                                              onmouseover="return overlib('Select one or more primary sites as search criteria', CAPTION, 'Primary Site');" 
                                              onmouseout="return nd();">Primary Site</a>
                                        </b>
                                        <br>
                                <html:select property="primarySites" size="8" multiple="true">
                                    <html:option value="">ANY</html:option>
                                    <html:options collection="primarySitesValues" property="value" labelProperty="label"/>
                                </html:select>
                        </td>

                    </tr>
                </table>
                </td>
                </tr>
                <tr class="stripe1">
                    <td class="cat1">
                        Limit models by diagnosis
                    </td>
                    <td class="data1">
                        <table>
                            <tr>
                                <td>
                                    <b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" 
                                          onmouseover="return overlib('Select a diagnosis or diagnoses as search criteria.', CAPTION, 'Diagnosis');"
                                          onmouseout="return nd();">Diagnosis</a>
                                    </b>
                                    <br>
                            <html:select property="diagnoses" size="8" multiple="true">
                                <html:option value="">ANY</html:option>
                                <html:options collection="diagnosesValues" property="value" labelProperty="label"/>
                            </html:select>
                    </td>
                </tr>
        </table>
    </td>
</tr>


<tr class="stripe2">

    <td class="cat2">
        Select genes for comparison
    </td>

    <td class="data2">
        <table>

            <tr>
                <td>
                    <b><a href="javascript:void(0);" style="text-decoration: none; cursor:help;" 
                          onmouseover="return overlib('Select one or more genes as display criteria', CAPTION, 'Genes');" 
                          onmouseout="return nd();">Gene</a></b>
                    <br>
                    <%--  <html:select property="genes" size="8"  styleId="genes" multiple="true" >
                          <html:options collection="genesValues" property="value" labelProperty="label"/>
                      </html:select> --%>
          
          <div id="geneSelect"></div>
          
            
    </td>
    <td><br>
        <input name="geneSave" type="button" value="Add" onclick="addGenesNew();"/><br>
    </td>
    <td>
        <span name="geneSave" id="geneSaveTxt"><b>
                <a href="javascript:void(0);" style="text-decoration: none; cursor:help;"
                   onmouseover="return overlib('Create a list of saved genes for display criteria.<br> The saved gene list will be used by default.', CAPTION, 'Saved genes');"
                   onmouseout="return nd();">Saved Genes</a>
            </b>
        </span>
        <br>
        <select name="geneSave" id="savedGenes" multiple="multiple" size="8" style="width:100px">
        </select>
    </td>
    <td>
        <input name="geneSave" type="button" value="Remove" onclick="removeGenes();"/><br>
        <input name="geneSave" type="button" value="Clear" onclick="clearGenes();"/><br>
        <input type="hidden" name="savedGenesList" id="savedGenesList" />
    </td>
</table>
</td>
</tr>



<tr class="buttons">
    <td colspan="2">
        <table border=0 cellspacing=5 width="100%">
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
</td>
</tr>
</table>

</td>
</tr>
</table>

</body>
</html> 
