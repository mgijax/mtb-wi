/**
 * Header: $Header$
 * Author: $Author$
 */
package org.jax.mgi.mtb.wi.actions;

import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.logging.log4j.Logger;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.jax.mgi.mtb.dao.custom.mtb.MTBTumorFrequencyDetailDTO;
import org.jax.mgi.mtb.dao.custom.mtb.MTBTumorUtilDAO;
import org.jax.mgi.mtb.dao.gen.mtb.StrainSynonymsDTO;
import org.jax.mgi.mtb.utils.StringUtils;
import org.jax.mgi.mtb.wi.utils.WIUtils;

/**
 * Retrieve the detail information about a tumor frequency record.
 *
 * @author $Author$
 * @date $Date$
 * @version $Revision$
 * @cvsheader $Header$
 * @see org.apache.struts.action.Action
 */
public class TumorFrequencyDetailsAction extends Action {

    // -------------------------------------------------------------- Constants
    // none

    // ----------------------------------------------------- Instance Variables
    
    private final static Logger log =
            org.apache.logging.log4j.LogManager.getLogger(TumorFrequencyDetailsAction.class.getName());

    // ----------------------------------------------------------- Constructors
    // none
    
    // --------------------------------------------------------- Public Methods
    
    /**
     * Retrieve the detail information about a tumor frequency record.
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
         
        String strKey = request.getParameter("key");
        String strPage = request.getParameter("page");
        
        if (StringUtils.hasValue(strPage)) {
            strTarget = strPage;
        }
      
        
                    
        // create a MTBStrainUtilDAO
        MTBTumorUtilDAO daoTumorUtil = MTBTumorUtilDAO.getInstance();
        
        
        // faceted search is trying to get cytogentics for a collection of TF records
        if("cytogenetics".equals(strPage) && strKey != null){
                ArrayList<MTBTumorFrequencyDetailDTO> dtoTFDetails = new ArrayList<MTBTumorFrequencyDetailDTO>();   
                String[] keys = strKey.split(",");
                try{
                    // this is insanely slow need to only check tf's that have cyto images
                    for (int i=0; i < keys.length; i++){
                        long lKey = Long.parseLong(keys[i]);
                        MTBTumorFrequencyDetailDTO dtoTFDetail = daoTumorUtil.getTumorFrequencyDetail(lKey);
                        if (dtoTFDetail != null){
                            dtoTFDetail.setTumorGenetics(null);
                            dtoTFDetails.add(dtoTFDetail);
                        }
                    }
                //tumorFrequencyDetailsGenetics.jsp doesn't expect an arraylist (yet)
                 request.setAttribute("tumorFreqs", dtoTFDetails);
                 
                }catch(Exception e){
                    log.error("error getting tf details for "+strKey,e);
                }
        }else{
            
            MTBTumorFrequencyDetailDTO dtoTFDetail = null;
            
            try {
                long lKey = Long.parseLong(strKey);

                dtoTFDetail = daoTumorUtil.getTumorFrequencyDetail(lKey);
            } catch (Exception e) {
                log.error("Error in  TF detail, key =" + strKey, e);
            }




            // set the target to failure if we could not retrieve the TF details
            if (dtoTFDetail == null) {
                strTarget = "error";
            } else {
                // put the tumor in the request
                List<StrainSynonymsDTO> synonyms = 
                        new ArrayList<>(dtoTFDetail.getStrainSynonyms());

                List<StrainSynonymsDTO> filteredSynonyms = 
                        WIUtils.filterStrainSynonyms(synonyms, dtoTFDetail.getStrainName());

                dtoTFDetail.setStrainSynonyms(filteredSynonyms);

                request.setAttribute("tumorFreq", dtoTFDetail);
            }
        }
       
        // forward to the appropriate View
        return mapping.findForward(strTarget);
    }
    
    // ------------------------------------------------------ Protected Methods
    // none
    
    // -------------------------------------------------------- Private Methods
    // none
}
