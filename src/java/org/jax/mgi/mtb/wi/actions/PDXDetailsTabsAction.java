/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.jax.mgi.mtb.wi.actions;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import org.jax.mgi.mtb.dao.custom.mtb.pdx.PDXGraphic;

import org.jax.mgi.mtb.wi.pdx.PDXMouseStore;

/**
 * Loads PDX image details
 * @author sbn
 */
public class PDXDetailsTabsAction extends Action {

    public ActionForward execute(ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {

        String tab = request.getParameter("tab");
        String modelID = request.getParameter("modelID");
     
        int contentKey = 0;
        try{
            contentKey = new Integer(request.getParameter("contentKey")).intValue();
        }catch(NumberFormatException nfe){
            // not much we can do it came from the url
        }
       

        request.setAttribute("modelID", modelID);

        PDXMouseStore pdxMouseStore = new PDXMouseStore();

       

       if("graphicDetails".equals(tab)){
            
   
        PDXGraphic graphic = pdxMouseStore.getGraphic(contentKey);
        request.setAttribute("fileName",graphic.getFileName());
        request.setAttribute("description", graphic.getDescription());

        
        
    }

        return mapping.findForward(tab);
    }
    
    
  
}

