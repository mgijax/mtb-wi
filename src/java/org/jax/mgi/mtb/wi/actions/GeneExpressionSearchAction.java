/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package org.jax.mgi.mtb.wi.actions;

import java.util.ArrayList;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.jax.mgi.mtb.dao.custom.mtb.MTBSeriesSampleUtilDAO;
import org.jax.mgi.mtb.utils.LabelValueBean;

/**
 *
 * @author sbn
 */
public class GeneExpressionSearchAction extends Action {
    
    // -------------------------------------------------------------- Constants
    // none

    // ----------------------------------------------------- Instance Variables
    
    private final static Logger log =
            Logger.getLogger(GeneExpressionSearchAction.class.getName());

    // ----------------------------------------------------------- Constructors
    // none
    
    // --------------------------------------------------------- Public Methods

    /**
     * 
     *
     * @param mapping the action mapping that determines where we need to go
     * @param form the form bean
     * @param request standard servlet request
     * @param response standard servlet response
     * @return the ActionForward object that indicates where to go
     * @throws Exception if the application business logic throws an exception.
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
      
        // default target to success
        String strTarget = "success";
       
      
        // create a ReferenceUtilDAO
      
        MTBSeriesSampleUtilDAO ssuDAO = MTBSeriesSampleUtilDAO.getInstance();
        ArrayList<LabelValueBean<String,Long>> organs = ssuDAO.getOrgans();
        ArrayList<LabelValueBean<String,Long>> tumorClassifications = ssuDAO.getTumorClassifications();
        ArrayList<LabelValueBean<String,String>> platforms = ssuDAO.getPlatforms();
        
       
        
       
      
        // put all the variables in the request
        request.setAttribute("organValues", organs);
        request.setAttribute("tumorClassificationValues",tumorClassifications);
        request.setAttribute("platformValues", platforms);
        
        // forward to the appropriate View
        return mapping.findForward(strTarget);
    }
    
}