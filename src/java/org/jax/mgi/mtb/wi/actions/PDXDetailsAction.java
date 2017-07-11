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
import org.jax.mgi.mtb.dao.custom.mtb.pdx.PDXComment;
import org.jax.mgi.mtb.dao.custom.mtb.pdx.PDXContent;
import org.jax.mgi.mtb.dao.custom.mtb.pdx.PDXDocument;
import org.jax.mgi.mtb.dao.custom.mtb.pdx.PDXGraphic;
import org.jax.mgi.mtb.dao.custom.mtb.pdx.PDXLink;
import org.jax.mgi.mtb.dao.custom.mtb.pdx.PDXMouse;
import org.jax.mgi.mtb.wi.WIConstants;
import org.jax.mgi.mtb.wi.pdx.PDXMouseStore;

/**
 * Collects data for PDX details page and sends it along
 *
 * @author sbn
 */
public class PDXDetailsAction extends Action {

    public ActionForward execute(ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {

        PDXMouseStore store = new PDXMouseStore();

        // allow for some users to be editors
        String pdxUser = (String) request.getSession().getAttribute("pdxUser");
        if (pdxUser != null && canEdit(pdxUser)) {
            request.getSession().setAttribute("pdxEditor", "true");
        } else {
            request.getSession().removeAttribute("pdxEditor");
        }

        String result = "success";

        String modelID = request.getParameter("modelID");

        if (request.getParameter("csvSummary") != null) {

            String filter = "FALSE";

            String header = "Model,Sample,Gene,Platform,Chromosome,Seq Position,Ref Allele,Alt Allele,"
                    + "Consequence,Amino Acid Change,RS Variants,Read Depth,Allele Frequency,Transcript ID,Filtered Rationale,"
                    + "Passage Num,Gene ID,CKB Evidence,Actionable Cancer Types,Drug Class,Count Human Reads,PCT Human Reads,"
                    + "Variant Num Trials,Variant NCT IDs\n";

            if (WIConstants.getInstance().getPublicDeployment()) {
                filter = "TRUE";
            }

            String variants = store.getVariationData(modelID, "-1", "0", "gene_symbol", "ASC", filter);
            variants = variants.substring(variants.indexOf("["));

            variants = variants.replaceAll("'", "").replaceAll("\\],\\[", "\n").replaceAll("\\[\\[", "").replaceAll("\\]\\]", "").replace(",],]}", "");

            response.setContentType("text/csv");
            response.setHeader("Content-disposition", "attachment; filename=" + modelID + "-Variant-Summary.csv");
            response.getWriter().write(header + variants);
            response.flushBuffer();

            return null;
        }

        String gene = (String) request.getParameter("gene");
        if ("null".equals(gene)) {
            gene = null;
        }
        String variant = request.getParameter("variant");
        if ("null".equals(variant)) {
            variant = null;
        }

        ArrayList<PDXMouse> mice = store.findStaticMouseByID(modelID);

        if (mice == null || mice.isEmpty()) {
            result = "noMatch";
            request.setAttribute("modelID", modelID);

        } else {
            PDXMouse mouse = mice.get(0);
            mouse.setGene(gene);
            mouse.setVariant(variant);

            // collections of additional data
            ArrayList<PDXGraphic> histology = new ArrayList<PDXGraphic>();
            ArrayList<PDXComment> tumorMarkers = new ArrayList<PDXComment>();
            ArrayList<PDXLink> geneExpressionLinks = new ArrayList<PDXLink>();
            ArrayList<PDXGraphic> geneExpressionImages = new ArrayList<PDXGraphic>();
            ArrayList<PDXLink> cnvLinks = new ArrayList<PDXLink>();
            ArrayList<PDXGraphic> cnvImages = new ArrayList<PDXGraphic>();
            ArrayList<PDXComment> mutationComments = new ArrayList<PDXComment>();
            ArrayList<PDXLink> mutationLinks = new ArrayList<PDXLink>();
            ArrayList<PDXGraphic> drugSensitivity = new ArrayList<PDXGraphic>();
            ArrayList<PDXDocument> drugSDoc = new ArrayList<PDXDocument>();
            ArrayList<PDXGraphic> additionalGraphic = new ArrayList<PDXGraphic>();
            ArrayList<PDXGraphic> tumorGrowthRate = new ArrayList<PDXGraphic>();
            PDXComment histologySummary = null;
            PDXComment pathologist = null;

            // split data types into characterizations
            for (PDXGraphic g : store.getGraphics(modelID)) {
                switch (g.getCharacterization()) {
                    case PDXContent.HISTOLOGY:
                        histology.add(g);
                        break;
                    case PDXContent.GENE_EXPRESSION:
                        geneExpressionImages.add(g);
                        break;
                    case PDXContent.CNV:
                        cnvImages.add(g);
                        break;
                    case PDXContent.DRUG_SENSITIVITY:
                        drugSensitivity.add(g);
                        break;
                    case PDXContent.ADDITIONAL_GRAPHIC:
                        additionalGraphic.add(g);
                        break;
                    case PDXContent.TUMOR_GROWTH_RATE:
                        tumorGrowthRate.add(g);
                        break;

                }
            }

            for (PDXComment c : store.getComments(modelID)) {
                switch (c.getCharacterization()) {
                    case PDXContent.TUMOR_MARKER:
                        tumorMarkers.add(c);
                        break;
                    case PDXContent.MUTATION:
                        mutationComments.add(c);
                        break;
                    case PDXContent.HISTOLOGY_SUMMARY:
                        histologySummary = c;
                        break;
                    case PDXContent.PATHOLOGIST:
                        pathologist = c;
                        break;
                }
            }

            for (PDXLink link : store.getLinks(modelID)) {
                switch (link.getCharacterization()) {
                    case PDXContent.GENE_EXPRESSION:
                        geneExpressionLinks.add(link);
                        break;
                    case PDXContent.CNV:
                        cnvLinks.add(link);
                        break;
                    case PDXContent.MUTATION:
                        mutationLinks.add(link);
                        break;
                }
            }

            for (PDXDocument doc : store.getDocuments(modelID)) {
                switch (doc.getCharacterization()) {
                    case PDXContent.DRUG_SENSITIVITY:
                        drugSDoc.add(doc);
                        break;
                }
            }

            if (histology.size() > 0) {
                request.setAttribute("histology", histology);
            }

            if (histologySummary != null) {
                request.setAttribute("histologySummary", histologySummary);
            }

            if (pathologist != null) {
                request.setAttribute("pathologist", pathologist);
            }

            if (tumorMarkers.size() > 0) {
                request.setAttribute("tumorMarkers", tumorMarkers);
            }

            if (geneExpressionLinks.size() > 0) {
                request.setAttribute("geneExpression", true);
                request.setAttribute("geneExpressionLinks", geneExpressionLinks);
            }

            if (geneExpressionImages.size() > 0) {
                request.setAttribute("geneExpression", true);
                request.setAttribute("geneExpressionImages", geneExpressionImages);
            }

            if (cnvLinks.size() > 0) {
                request.setAttribute("cnv", true);
                request.setAttribute("cnvLinks", cnvLinks);
            }

            if (cnvImages.size() > 0) {
                request.setAttribute("cnv", true);
                request.setAttribute("cnvImages", cnvImages);
            }

            if (mutationLinks.size() > 0) {
                request.setAttribute("mutation", true);
                request.setAttribute("mutationLinks", mutationLinks);
            }

            if (mutationComments.size() > 0) {
                request.setAttribute("mutation", true);
                request.setAttribute("mutationComments", mutationComments);
            }

            if(mouse.getSocGraph()==0){
                if (drugSensitivity.size() > 0) {
                    request.setAttribute("drugSensitivityGraphics", drugSensitivity);
                    request.setAttribute("drugSensitivity", "true");
                }

                if (drugSDoc.size() > 0) {
                    request.setAttribute("drugSensitivityDocs", drugSDoc);
                    request.setAttribute("drugSensitivity", "true");
                }
            }

            if (additionalGraphic.size() > 0) {
                request.setAttribute("additionalGraphic", additionalGraphic);
            }

            if (tumorGrowthRate.size() > 0) {
                request.setAttribute("tumorGrowthRate", tumorGrowthRate);
            }

            String expData = store.getModelExpression(modelID);

            int split = expData.indexOf("[");
            if (split > 0) {
                String platforms = expData.substring(0, split);
                expData = expData.substring(split);

                request.setAttribute("platforms", platforms);
            }

            request.setAttribute("geneExpressionData", expData);

            // 3500px is about right for the 350 or so genes in the exome panel
            // some models will have multiple samples 
            // adjust the 3500px as necessary 
            int pxPerBar = 15;
            int expChartSize = 100;
            int samples = expData.split("]").length;

            if (samples > 0) {

                expChartSize += (int) Math.floor(pxPerBar * samples);
            }

            request.setAttribute("expChartSize", expChartSize + "");

            String cnvData = store.getModelCNV(modelID);
            if (cnvData != null && cnvData.length() > 0) {
                String[] parts = cnvData.split("\\|");
                String ploidy = parts[0];
                ploidy = ploidy.substring(0, ploidy.length() - 1);
                if (ploidy.indexOf(",") == -1) {
                    String[] pieces = ploidy.split(":");
                    request.setAttribute("ploidy", pieces[1]);
                } else {
                    request.setAttribute("ploidy", "false");
                }
                request.setAttribute("samplePloidy", ploidy);
                cnvData = parts[1];

                //cnvData = cnvData.replaceAll("Amplification", "orange");
                //cnvData = cnvData.replaceAll("Deletion", "blue");
                //cnvData = cnvData.replaceAll("Normal", "grey");
                // cnvData = cnvData.replaceAll("Sample Ploidy", "Sample Ploidy");
                request.setAttribute("geneCNVData", cnvData);

                int cnvChartSize = 250;
                samples = cnvData.split("]").length;

                if (samples > 1) {

                    // there are multiple samples
                    cnvChartSize += (int) Math.floor(pxPerBar * samples);
                }

                request.setAttribute("cnvChartSize", cnvChartSize + "");
                // will need to set cnv data here
            }

            request.setAttribute("modelID", modelID);

            request.setAttribute("mouse", mouse);

            // check if no inventory remaining
            if (mouse.getModelStatus().indexOf("Inventory") != -1 || mouse.getModelStatus().indexOf("Data") != -1) {
                request.setAttribute("unavailable", "unavailable");
            }

        }//end of else for finding a model;

        return mapping.findForward(result);

    }

    private boolean canEdit(String pdxUser) {
        // if pdxUser is allowed to edit return true
        boolean canEdit = false;
        if (pdxUser.trim().length() > 0 && pdxUser.equals(WIConstants.getInstance().getPDXEditor())) {
            canEdit = true;
        }
        return canEdit;
    }
}
