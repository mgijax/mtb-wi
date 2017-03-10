/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.jax.mgi.mtb.wi.actions;

import java.util.ArrayList;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.jax.mgi.mtb.utils.LabelValueBean;
import org.jax.mgi.mtb.wi.WIConstants;
import org.jax.mgi.mtb.wi.forms.PDXForm;
import org.jax.mgi.mtb.wi.pdx.ElimsUtil;
import org.jax.mgi.mtb.wi.pdx.PDXMouseStore;

/**
 *
 * @author sbn
 */
public class PDXSearchAction extends Action {

    public ActionForward execute(ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {


        // fyi
        // the json result is used by Roger Liu via a cron job to populate some fields in his database

        if (request.getParameter("pdxStatusJSON") != null && !WIConstants.getInstance().getPublicDeployment()) {
            ElimsUtil eu = new ElimsUtil();
            response.setContentType("application/json");
            response.getWriter().write(eu.getJSONPDXStatusReport());
            response.flushBuffer();
            return null;
        }
        
         if ("gimme".equals(request.getParameter("pdxInfoJSON"))) {
            ElimsUtil eu = new ElimsUtil();
            response.setContentType("application/json");
            response.getWriter().write(eu.getPDXInfo());
            response.flushBuffer();
            return null;
        }

        PDXForm pdxForm = (PDXForm) form;

        String result = "success";

        PDXMouseStore pdxMouseStore = new PDXMouseStore();

        // click on update variants button
        ArrayList<LabelValueBean<String, String>> variantsLVB = new ArrayList<LabelValueBean<String, String>>();

        String geneStr = pdxForm.getGene();

        if (geneStr != null) {

            // this is very slow
            ArrayList<String> variants = pdxMouseStore.getVariants(geneStr);
            if (variants != null && variants.size() > 0) {

                for (String variant : variants) {
                    LabelValueBean lvb = new LabelValueBean(variant, variant);
                    variantsLVB.add(lvb);
                }
                request.setAttribute("variantsValues", variantsLVB);
            }
            request.setAttribute("gene", geneStr);
            request.setAttribute("update", "update");
        } else {
            request.setAttribute("gene", "");
        }

        request.setAttribute("diagnosesValues", pdxMouseStore.getDiagnosesLVB());
        request.setAttribute("primarySitesValues", pdxMouseStore.getPrimarySitesLVB());
        request.setAttribute("tagsValues", pdxMouseStore.getTagsLVB());

        request.setAttribute("genesArray", pdxMouseStore.getAllGenesWebFormat());
        request.setAttribute("fusionGenes", pdxMouseStore.getFusionGenesLVB());

        //  this is the list of genes used to populate MTB's pdxexpression table
        //   request.setAttribute("genesValues2", pdxMouseStore.getExomePanelGenesLVB());

        // request.setAttribute("genesValuesCNV",pdxMouseStore.getExomePanelGenesLVB());

        request.setAttribute("exomePanelGenes", pdxMouseStore.getExomePanelGenesWebFormat());

        Map mapChromosomes = WIConstants.getInstance().getChromosomes();

        // these are mouse chromosome we need human
        request.setAttribute("chrValuesCNV", mapChromosomes.values());

        return mapping.findForward(result);
    }
}
