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


           PDXMouseStore pdxMouseStore = new PDXMouseStore();

         // steve grub uses this to populate data on the pdx dashboard
        if (request.getParameter("pdxStatusJSON") != null && !WIConstants.getInstance().getPublicDeployment()) {
           
            response.setContentType("application/json");
            response.getWriter().write(pdxMouseStore.getJSONPDXStatus());
            response.flushBuffer();
            return null;
        }

        PDXForm pdxForm = (PDXForm) form;

        String result = "success";

        // click on update variants button
        ArrayList<LabelValueBean<String, String>> variantsLVB = new ArrayList<>();

        String geneStr = pdxForm.getGene();

        if (geneStr != null && geneStr.trim().length()>0) {

            
            ArrayList<String> variants = pdxMouseStore.getVariants(geneStr);
            if (variants != null && variants.size() > 0) {

                for (String variant : variants) {
                    LabelValueBean<String,String> lvb = new LabelValueBean(variant, variant);
                    variantsLVB.add(lvb);
                }
                request.setAttribute("variantsValues", variantsLVB);
            }
            request.setAttribute("gene", geneStr);
            request.setAttribute("update", "update");
        }

        request.setAttribute("diagnosesValues", pdxMouseStore.getDiagnosesLVB());
        request.setAttribute("primarySitesValues", pdxMouseStore.getPrimarySitesLVB());
        request.setAttribute("tagsValues", pdxMouseStore.getTagsLVB());

      
        request.setAttribute("fusionGenes", pdxMouseStore.getFusionGenesLVB());
        
        request.setAttribute("recistDrugs", pdxMouseStore.getRECISTDrugsLVB());
        request.setAttribute("recistResponses", pdxMouseStore.getRECISTResponsesLVB());

        Map mapChromosomes = WIConstants.getInstance().getChromosomes();

        // these are mouse chromosome we need human
        request.setAttribute("chrValuesCNV", mapChromosomes.values());
        
        request.setAttribute("modelIDs", pdxMouseStore.getIds());
        
        request.setAttribute("minTMB", pdxMouseStore.getMinTMB());
        request.setAttribute("maxTMB", pdxMouseStore.getMaxTMB());

        return mapping.findForward(result);
    }
}
