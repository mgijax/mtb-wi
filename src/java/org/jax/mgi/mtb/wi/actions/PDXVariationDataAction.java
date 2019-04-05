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
import org.jax.mgi.mtb.wi.WIConstants;
import org.jax.mgi.mtb.wi.pdx.PDXMouseStore;

/**
 * Provides data for paginated variation display 
 * @author sbn
 */
public class PDXVariationDataAction extends Action {

    public ActionForward execute(ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {
        
        PDXMouseStore store = new PDXMouseStore();

        String modelID = request.getParameter("modelID");
        
      
        
        //TM##### to int to string
        modelID = new Integer(modelID.substring(2)).toString();

       String limit = request.getParameter("limit");
       String start = request.getParameter("start");
        
        if(start == null || start.trim().length()==0){
            start = "0";
        }
        
        if(limit == null || limit.trim().length()==0){
            limit = "-1";
        }
        
       String sort = request.getParameter("sort");
       String dir = request.getParameter("dir");
       
       String ctp = request.getParameter("all_ctp_genes");
      
       
       if(dir != null){
           dir = dir.toLowerCase();
       }
    
       
       
        
        
        response.setContentType("application/json");
        
       
        response.getWriter().write(store.getVariationData(modelID, limit, start, sort, dir, ctp));
        
        response.flushBuffer();


        return null;
    }

    
}