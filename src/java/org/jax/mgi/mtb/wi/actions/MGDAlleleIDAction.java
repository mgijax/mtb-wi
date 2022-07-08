/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.jax.mgi.mtb.wi.actions;

import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.logging.log4j.Logger;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.jax.mgi.mtb.dao.custom.mtb.MTBGeneticsUtilDAO;

/**
 *
 * @author sbn
 */
public class MGDAlleleIDAction extends Action {

 
    /**
     * Provide a list of Alleles for MMHCdb strains so MGI knows if they should create a link to us
     *
     * @param mapping the action mapping that determines where we need to go
     * @param form the form bean
     * @param request standard servlet request
     * @param response standard servlet response
     * @return the ActionForward object that indicates where to go
     * @throws Exception if the application business logic throws an exception
     * @see org.apache.struts.action.ActionMapping
     * @see org.apache.struts.action.ActionForm
     * @see javax.servlet.http.HttpServletRequest
     * @see javax.servlet.http.HttpServletResponse
     */
    public ActionForward execute(ActionMapping mapping,
                                 ActionForm form,
                                 HttpServletRequest request,
                                 HttpServletResponse response)
        throws Exception {
    
        response.setContentType("text");
        StringBuilder ids = new StringBuilder();
         List<String> results = MTBGeneticsUtilDAO.getInstance().getStrainAlleleIDs();
         for(String id :results){
              ids.append(id).append("\n");
             }
        

        response.getWriter().write(ids.toString());
        return null;
        
    }
    
    
    
}
