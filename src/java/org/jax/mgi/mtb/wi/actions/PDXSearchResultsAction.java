/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.jax.mgi.mtb.wi.actions;

import java.util.ArrayList;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.jax.mgi.mtb.dao.custom.mtb.pdx.PDXMouse;
import org.jax.mgi.mtb.wi.WIConstants;
import org.jax.mgi.mtb.wi.forms.PDXForm;
import org.jax.mgi.mtb.wi.pdx.PDXMouseStore;
import org.jax.mgi.mtb.wi.utils.WIUtils;

/**
 * From the pdxSearch page get the search parameters, get a list of matching
 * mice then maybe get Expression or CNV data
 *
 * @author sbn
 */
public class PDXSearchResultsAction extends Action {
    
    public ActionForward execute(ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {
        String result = "success";

        PDXMouseStore pdxMouseStore = new PDXMouseStore();

        PDXForm pdxForm = (PDXForm) form;
        String modelID = pdxForm.getModelID();
        if(modelID != null){
            modelID = modelID.trim();
        }
        ArrayList<String> primarySites = (ArrayList<String>) WIUtils.arrayToCleanList(pdxForm.getPrimarySites());
        ArrayList<String> diagnoses = (ArrayList<String>) WIUtils.arrayToCleanList(pdxForm.getDiagnoses());
        ArrayList<String> tags = (ArrayList<String>) WIUtils.arrayToCleanList(pdxForm.getTags());
        ArrayList<String> types = (ArrayList<String>) WIUtils.arrayToCleanList(pdxForm.getTumorTypes());
      
        
        String gene = pdxForm.getGene();
        String genes2 = pdxForm.getGenes2();
        ArrayList<String> variants = (ArrayList<String>) WIUtils.arrayToCleanList(pdxForm.getVariants());

        String genesCNV = pdxForm.getGenesCNV();
        
        String fusionGene = pdxForm.getFusionGenes();
        
        boolean dosingStudy = pdxForm.getDosingStudy();
        
        // removed checkbox on 01-25-18, need to remove logic as well
        boolean tumorGrowth = false;
        boolean treatmentNaive = pdxForm.getTreatmentNaive();
        
        String recistDrug = pdxForm.getRecistDrugs();
        String recistResponse = pdxForm.getRecistResponses();
        
        Double tmbGT = null;
        Double tmbLT = null;
        try{
            tmbGT =  Double.parseDouble(pdxForm.getTMBGT());
        }catch(Exception e){
            //do nothing
        }
        
        try{
            tmbLT = Double.parseDouble(pdxForm.getTMBLT());
        }catch(Exception e){
            //do nothing
        }
        
        // include gene variant consequence in cvs
        boolean showGVC = false;

       

        String hideGene = "false";
        
        // don't show by default
        String hideFusionGenes = "true";

        if (gene != null && gene.trim().length() > 0) {
            showGVC = true;
        } else {
            hideGene = "true";
        }
        
       
        ArrayList<PDXMouse> mice = null;

        // this is just for the Active status report
        String toa = request.getParameter("tissueOfOrigin");
        if (toa != null) {
            mice = pdxMouseStore.findStaticMiceByTissueOfOrigin(toa);
            request.setAttribute("tissuseOfOrigin", toa);
        } else {
            mice = pdxMouseStore.findMice(modelID, primarySites, diagnoses, types,
                     gene, variants, dosingStudy, tumorGrowth, tags, 
                    fusionGene,treatmentNaive, recistDrug, recistResponse, tmbGT, tmbLT);
        }

        request.setAttribute("modelID", modelID);
        request.setAttribute("primarySites", primarySites);
        request.setAttribute("diagnoses", diagnoses);
        request.setAttribute("types", types);
        request.setAttribute("tags", tags);
        request.setAttribute("fusionGenes",fusionGene);
        
        if(fusionGene != null && fusionGene.trim().length() > 0){
            hideFusionGenes = "false";
        }

        if (dosingStudy) {
            request.setAttribute("dosingStudy", "true");
        }
        if (tumorGrowth) {
            request.setAttribute("tumorGrowth", "true");
        }
        if (treatmentNaive) {
            request.setAttribute("treatmentNaive", "true");
        }
        
        String hideTMB = "true";
        if(tmbLT != null && tmbGT != null){
                request.setAttribute("tmb", tmbGT+" < TMB < "+tmbLT);
                hideTMB = "false";
        }else if(tmbLT != null){
                request.setAttribute("tmb",  "TMB < " + tmbLT);
                hideTMB = "false";
        }else if(tmbGT != null){
            request.setAttribute("tmb", tmbGT + " < TMB");
            hideTMB = "false";
        }
        
        request.setAttribute("hideTMB", hideTMB);

        // genes2 (right now always just 1 gene) is for expression results
        if (genes2 != null && genes2.trim().length() > 0) {

            if (mice.size() > 0) {
                String expr = pdxMouseStore.getExpressionGraph(mice,genes2,false);
                if (expr != null && expr.length() > 1) {
                    
                    String data = "['Model:Sample','Diagnosis','Expression Level', 'Model Name']," + expr;
                    request.setAttribute("rank", data);
                    String[] lines = data.split("\\[");
                    int size = 50 + lines.length * 15;
                    request.setAttribute("chartSize", size + "");
                    size = size + 200;
                    request.setAttribute("divSize", size + "");
                } else {
                    // no expression
                    request.setAttribute("noResults", "There is no expression data for matching models.");
                }
            } else {
                //no models
                request.setAttribute("noResults", "No models matched the search criteria.");
            }
            request.setAttribute("gene2", genes2);

            if (variants != null && variants.size() > 0) {
                request.setAttribute("variant", variants.get(0));
            }

            result = "expression";

        } else if (genesCNV != null && genesCNV.trim().length() > 0) {
            if (mice.size() > 0) {

                
                String expr = pdxMouseStore.getExpressionGraph(mice, genesCNV, true);
                if (expr != null && expr.length() > 1) {
                   
                    
                    String data = "['Model:Sample','Diagnosis','Expression Level', 'Model Name',{ role: 'style' }]," + expr;
                    data = data.replaceAll("Amplification", "orange");
                    data = data.replaceAll("Deletion", "blue");
                    data = data.replaceAll("Normal", "grey");
                    request.setAttribute("rank", data);
                    
                    String[] lines = data.split("\\[");
                    int size = 50 + lines.length * 15;
                    request.setAttribute("chartSize", size + "");
                    size = size + 200;
                    request.setAttribute("gene2", genesCNV);
                    request.setAttribute("divSize", size + "");
                    request.setAttribute("message", "Orange bars indicate gene amplification (log2(cn raw/sample ploidy) > 0.5).<br>Blue bars indicate gene deletion (log2(cn raw/sample ploidy)< -0.5).<br>Grey bars indicate no significant copy number change.");
                } else {
                    // no expression
                    request.setAttribute("noResults", "There are no matching models.");
                }
            } else {
                //no models
                request.setAttribute("noResults", "No models matched the search criteria.");
            }
            

            result = "expression";

        } else {
            if (request.getParameter("asCSV") != null ) {

                response.setContentType("text/csv");
                response.setHeader("Content-disposition", "attachment; filename=PDXMice.csv");
                response.getWriter().write(miceToCSV(mice, showGVC, hideTMB.equals("false"), hideFusionGenes.equals("false")));

                response.flushBuffer();
                return null;

            }
            if (request.getParameter("asCSVPlus") != null && WIConstants.getInstance().getPublicDeployment() != true) {

                response.setContentType("text/csv");
                response.setHeader("Content-disposition", "attachment; filename=PDXMice.csv");
                response.getWriter().write(pdxMouseStore.getPDXReportWithNoName());

                response.flushBuffer();
                return null;

            }
            
            // requesting expression data as CSV
             if (request.getParameter("csv") != null) {
                 
                String csv = request.getParameter("csv"); 
                
                csv = csv.replaceAll("\\[", "").replaceAll("\\],", "\n").replaceAll("\\]", "");
                csv = csv.replaceAll("hodgkins lymphoma, nodular sclerosis","hodgkins lymphoma nodular sclerosis");
                
                if(csv.contains("{ role: 'style' }")){
                    csv = csv.replace("{ role: 'style' }","CNV").replaceAll("'","");
                    csv = csv.replaceAll("orange","Amplification" );
                    csv = csv.replaceAll("blue", "Deletion");
                    csv = csv.replaceAll("grey", "Normal");
                }
                
                response.setContentType("text/csv");
                response.setHeader("Content-disposition", "attachment; filename=PDXExpression.csv");
                response.getWriter().write(csv);

                response.flushBuffer();
                return null;

            }
            String[] results = miceToArray(mice);
            request.setAttribute("mice", results[0]);

            request.setAttribute("unavailableModels", results[1]);

            request.setAttribute("gene", gene);
            request.setAttribute("hideGene", hideGene);
            request.setAttribute("hideFusionGenes", hideFusionGenes);

            request.setAttribute("variants", variants);
            
            request.setAttribute("recistDrug", recistDrug);
            request.setAttribute("recistResponse", recistResponse);

            result = "table";
        }
        
        
        return mapping.findForward(result);
    }

    // the order of the fields here needs to correspond to the order of the arraystore fields in pdxSearchResults.jsp
    private String[] miceToArray(ArrayList<PDXMouse> mice) {
        StringBuilder buffer = new StringBuilder();
        StringBuilder unavailable = new StringBuilder();
        buffer.append("[");
        for (PDXMouse mouse : mice) {
            
        
            if (buffer.length() > 1) {
                buffer.append(",");
            }
            buffer.append("[");
            buffer.append("'" + mouse.getModelID() + "',");
            buffer.append("'" + mouse.getModelStatus() + "',");
            buffer.append("'" + mouse.getPreviousID() + "',");
            buffer.append("'" + mouse.getTissue() + "',");
            buffer.append("'" + mouse.getInitialDiagnosis().replaceAll("'", ""));
            buffer.append(" : " + mouse.getClinicalDiagnosis().replaceAll("'", ""));
            buffer.append("',");
            buffer.append("'" + mouse.getLocation() + "' ,");
            buffer.append("'" + mouse.getSampleType() + "' ,");
            buffer.append("'" + mouse.getTumorType() + "' ,");
            buffer.append("'" + mouse.getPrimarySite() + "' ,");
            buffer.append("'" + mouse.getTumorMarkers() + "' ,");
            buffer.append("'" + mouse.getSex() + "',");
            buffer.append("'" + mouse.getAge() + "',");
            buffer.append("'" + mouse.getStrain() + "',");
            buffer.append("'" + mouse.getAssocData() + "',");
            buffer.append("'" + mouse.getTag() + "',");
            buffer.append("'" + mouse.getGene() + "',");
            buffer.append("'" + mouse.getVariant() + "',");
            buffer.append("'" + mouse.getConsequence() + "',");
            buffer.append("'" + mouse.getFusionGenes()+ "',");
            buffer.append("'" + mouse.getTMBStr()+"'");

            buffer.append("]");
            if (mouse.getModelStatus() == null) {
                mouse.setModelStatus("");
            }
            if (mouse.getModelStatus().indexOf("Inventory") != -1 ) {
               
                    unavailable.append(mouse.getModelID()).append(" ");
              
            }

        }

        buffer.append("]");

        String array = buffer.toString();
        // replace all non printing or white space chars with a space
        array = array.replaceAll("[\\p{C}\\p{Z}]", " ");

        return new String[]{array, unavailable.toString()};
    }

    
    // this should match the search results exactly need to include the other hide/show booleans
    // TMB and whatnots
    private String miceToCSV(ArrayList<PDXMouse> mice, boolean showGVC, boolean tmb, boolean fusionGenes) {
        StringBuilder buffer = new StringBuilder();

       
        buffer.append("Model ID,");
        buffer.append("Previous ID,");
        buffer.append("Tissue,");
        buffer.append("Initial Diagnosis:Final Diagnosis,");
        buffer.append("Tumor Site,");
        buffer.append("Tumor Type,");
        if(tmb){
            buffer.append("TMB,");
        }
        if(fusionGenes){
            buffer.append("Fusion Genes,");
        }
         if (showGVC) {
            buffer.append(",Gene,");
            buffer.append("Variant,");
           
        }
        buffer.append("Sex,");
        buffer.append("Age,");
        buffer.append("Associated Data");
        buffer.append("\n");
        
        for (PDXMouse mouse : mice) {
            buffer.append(mouse.getModelID()).append(",");
            buffer.append(mouse.getPreviousID()).append(",");
            buffer.append(deComma(mouse.getTissue())).append(",");
            buffer.append(deComma(mouse.getInitialDiagnosis())).append(":");
            buffer.append(deComma(mouse.getClinicalDiagnosis())).append(",");
            buffer.append(deComma(mouse.getPrimarySite())).append(",");
            buffer.append(deComma(mouse.getTumorType())).append(",");
            if(tmb){
                buffer.append(deComma(mouse.getTMBStr())).append(",");
            }
            if(fusionGenes){
                buffer.append(deComma(mouse.getFusionGenes())).append(",");
            }
            if (showGVC) {
                buffer.append(",");
                buffer.append(deComma(mouse.getGene())).append(",");
                buffer.append(deComma(mouse.getVariant())).append(",");
               
            }
            buffer.append(mouse.getSex()).append(",");
            buffer.append(mouse.getAge()).append(",");
            buffer.append(deComma(mouse.getAssocData()));
            buffer.append("\n");
        }

        String csv = buffer.toString();

        return csv;
    }

    private String deComma(String val) {
        String ret = "";
        if (val != null) {
            ret = val.replaceAll(",", ";");
        }
        return ret;
    }
}
