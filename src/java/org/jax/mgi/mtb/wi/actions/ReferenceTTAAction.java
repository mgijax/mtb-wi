/**
 * Header: $Header: /mgi/cvsroot/mgi/mtb/mtbwi/src/java/org/jax/mgi/mtb/wi/actions/ReferenceTTAAction.java,v 1.1 2013/10/30 19:58:46 sbn Exp $
 * Author: $Author: sbn $
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
import org.jax.mgi.mtb.dao.custom.mtb.MTBReferenceUtilDAO;
import org.jax.mgi.mtb.utils.LabelValueDataBean;

/**
 * Used to set the values for the Reference Search Form.
 *
 * @author $Author: sbn $
 * @date $Date: 2013/10/30 19:58:46 $
 * @version $Revision: 1.1 $
 * @cvsheader $Header: /mgi/cvsroot/mgi/mtb/mtbwi/src/java/org/jax/mgi/mtb/wi/actions/ReferenceTTAAction.java,v 1.1 2013/10/30 19:58:46 sbn Exp $
 * @see org.apache.struts.action.Action
 */
public class ReferenceTTAAction extends Action {

    // -------------------------------------------------------------- Constants
    // none
    // ----------------------------------------------------- Instance Variables
    private final static Logger log =
            Logger.getLogger(ReferenceTTAAction.class.getName());

    // ----------------------------------------------------------- Constructors
    // none
    // --------------------------------------------------------- Public Methods
    /**
     * Set the values for the Reference Search Form.
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

       
        String rKey = request.getParameter("referenceKey");

        // default target to success
        String strTarget = "success";

       MTBReferenceUtilDAO dao = MTBReferenceUtilDAO.getInstance();
       // this method might not really do what is needed
       //dependnig on which associations are suppresss and how the should be sorted a different new method might be better.
       ArrayList<LabelValueDataBean<String, String , Long>> tts = dao.getReferenceTumorTypes( new Long(rKey).longValue());
       
       // pull out the ones that are "curated" and change FMPro to "provisional" or some similar claptrap
       // value = currated exclude
       // value = FMPro convert to provisional
       // value = anything else (dmk dab) conver to indexed
       
       ArrayList<LabelValueDataBean<String, String , Long>> newTTs = new ArrayList<LabelValueDataBean<String, String , Long>>();
       boolean add = true;
       for(LabelValueDataBean<String, String , Long> lvb : tts){
               add = true;
               if(lvb.getValue().equals("Curated")){
                   add = false;
               }
                if(lvb.getValue().equals("FMPro")){
                    lvb.setValue("Provisional");  // these might need to be excluded as well?
                }else{
                    lvb.setValue("Indexed");
                } 
                if(add){
                    newTTs.add(lvb);
                }
                
            }
       // sort the tts alphabetically
       request.setAttribute("tumorTypes", newTTs); 

        // forward to the appropriate View
        return mapping.findForward(strTarget);
    }
    // ------------------------------------------------------ Protected Methods
    // none
    // -------------------------------------------------------- Private Methods
    // none
}
