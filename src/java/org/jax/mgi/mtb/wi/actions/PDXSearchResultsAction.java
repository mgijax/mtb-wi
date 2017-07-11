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
        ArrayList<String> markers = new ArrayList<String>();

        String gene = pdxForm.getGene();
        String genes2 = pdxForm.getGenes2();
        ArrayList<String> variants = (ArrayList<String>) WIUtils.arrayToCleanList(pdxForm.getVariants());

        String genesCNV = pdxForm.getGenesCNV();
        
        String fusionGenes = pdxForm.getFusionGenes();
        
        boolean dosingStudy = pdxForm.getDosingStudy();
        boolean tumorGrowth = pdxForm.getTumorGrowth();

        // include gene variant consequence in cvs
        boolean showGVC = false;

        ArrayList<String> genes = new ArrayList<>();

        String hideGene = "false";
        
        // don't show by default
        String hideFusionGenes = "true";

        if (gene != null && gene.trim().length() > 0) {
            genes.add(gene);
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
            mice = pdxMouseStore.findMice(modelID, primarySites, diagnoses, types, markers, genes, variants, dosingStudy, tumorGrowth, tags, fusionGenes);
        }

        request.setAttribute("modelID", modelID);
        request.setAttribute("primarySites", primarySites);
        request.setAttribute("diagnoses", diagnoses);
        request.setAttribute("types", types);
        request.setAttribute("tags", tags);
        request.setAttribute("fusionGenes",fusionGenes);
        
        if(fusionGenes != null && fusionGenes.trim().length() > 0){
            hideFusionGenes = "false";
        }

        if (dosingStudy) {
            request.setAttribute("dosingStudy", "true");
        }
        if (tumorGrowth) {
            request.setAttribute("tumorGrowth", "true");
        }

        // genes2 (right now always just 1 gene) is for expression results
        if (genes2 != null && genes2.trim().length() > 0) {

            if (mice.size() > 0) {
                String expr = pdxMouseStore.getExpression(genes2, mice);
                if (expr != null && expr.length() > 1) {
                    String data = "['Expression','Expression Level', 'Model Name']," + expr;
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

                String expr = pdxMouseStore.getCNVExpression(mice, genesCNV);
                if (expr != null && expr.length() > 1) {
                    String data = "['Expression','Expression Level', 'Model Name',{ role: 'style' }]," + expr;
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
                    request.setAttribute("message", "Orange bars indicate gene amplification (copy number > 2.5).<br>Blue bars indicate gene deletion (copy number < 1.5).<br>Grey bars indicate no significant copy number change.");
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
            if (request.getParameter("asCSV") != null) {

                response.setContentType("text/csv");
                response.setHeader("Content-disposition", "attachment; filename=PDXMice.csv");
                response.getWriter().write(miceToCSV(mice, showGVC));

                response.flushBuffer();
                return null;

            }
            String[] results = miceToArray(mice);
            request.setAttribute("mice", results[0]);

            request.setAttribute("unavailableModels", results[1]);

            request.setAttribute("genes", gene);
            request.setAttribute("hideGene", hideGene);
            request.setAttribute("hideFusionGenes", hideFusionGenes);

            request.setAttribute("variants", variants);

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
            buffer.append("'" + mouse.getFusionGenes()+ "'");

            buffer.append("]");
            if (mouse.getModelStatus() == null) {
                mouse.setModelStatus("");
            }
            if (mouse.getModelStatus().indexOf("Inventory") != -1 || mouse.getModelStatus().indexOf("Data") != -1) {
                unavailable.append(mouse.getModelID()).append(" ");
            }

        }

        buffer.append("]");

        String array = buffer.toString();
        // replace all non printing or white space chars with a space
        array = array.replaceAll("[\\p{C}\\p{Z}]", " ");

        return new String[]{array, unavailable.toString()};
    }

    private String miceToCSV(ArrayList<PDXMouse> mice, boolean showGVC) {
        StringBuilder buffer = new StringBuilder();

        buffer.append("Model Status,");
        buffer.append("Model ID,");
        buffer.append("Previous ID,");
        buffer.append("Tissue,");
        buffer.append("Initial Diagnosis,");
        buffer.append("Final Diagnosis,");
        buffer.append("Location,");
        buffer.append("Sample Type,");
        buffer.append("Tumor Type,");
        buffer.append("Primary Site,");
        buffer.append("Tumor Markers,");
        buffer.append("Sex,");
        buffer.append("Age,");
        buffer.append("Strain,");
        buffer.append("Associated Data");

        // search included a gene or gene+variant so show these 3 fields
        if (showGVC) {
            buffer.append(",Gene,");
            buffer.append("Variant,");
            buffer.append("Consequence");
        }
        buffer.append("\n");
        for (PDXMouse mouse : mice) {

            buffer.append(mouse.getModelStatus()).append(",");
            buffer.append(mouse.getModelID()).append(",");
            buffer.append(mouse.getPreviousID()).append(",");
            buffer.append(deComma(mouse.getTissue())).append(",");
            buffer.append(deComma(mouse.getInitialDiagnosis())).append(",");
            buffer.append(deComma(mouse.getClinicalDiagnosis())).append(",");
            buffer.append(deComma(mouse.getLocation())).append(",");
            buffer.append(deComma(mouse.getSampleType())).append(",");
            buffer.append(deComma(mouse.getTumorType())).append(",");
            buffer.append(deComma(mouse.getPrimarySite())).append(",");
            buffer.append(deComma(mouse.getTumorMarkers())).append(",");
            buffer.append(mouse.getSex()).append(",");
            buffer.append(mouse.getAge()).append(",");
            buffer.append(mouse.getStrain()).append(",");
            buffer.append(deComma(mouse.getAssocData()));
            if (showGVC) {
                buffer.append(",");
                buffer.append(deComma(mouse.getGene())).append(",");
                buffer.append(deComma(mouse.getVariant())).append(",");
                buffer.append(deComma(mouse.getConsequence()));
            }
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
