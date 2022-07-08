/**
 * Header: $Header$
 * Author: $Author$
 */
package org.jax.mgi.mtb.wi.actions;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Set;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.logging.log4j.Logger;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.jax.mgi.mtb.dao.custom.mtb.MTBGeneticsUtilDAO;
import org.jax.mgi.mtb.dao.custom.mtb.MTBTumorFrequencySummaryDTO;
import org.jax.mgi.mtb.dao.custom.mtb.MTBTumorSummaryDTO;
import org.jax.mgi.mtb.dao.custom.mtb.MTBTumorUtilDAO;
import org.jax.mgi.mtb.dao.custom.mtb.MTBTumorGeneticChangesDTO;
import org.jax.mgi.mtb.dao.gen.mtb.StrainSynonymsDTO;
import org.jax.mgi.mtb.dao.gen.mtb.StrainTypeDTO;
import org.jax.mgi.mtb.utils.StringUtils;
import org.jax.mgi.mtb.wi.WIConstants;
import org.jax.mgi.mtb.wi.utils.WIUtils;

/**
 * Retreives the tumor summary.
 *
 * @author $Author$
 * @date $Date$
 * @version $Revision$
 * @cvsheader $Header$
 * @see org.apache.struts.action.Action
 */
public class TumorSummaryAction extends Action {

    // -------------------------------------------------------------- Constants
    // none
    // ----------------------------------------------------- Instance Variables
    private final static Logger log =
            org.apache.logging.log4j.LogManager.getLogger(TumorSummaryAction.class.getName());

    // ----------------------------------------------------------- Constructors
    // none
    // --------------------------------------------------------- Public Methods
    /**
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

        

        // retrieve the parameters
        String strStrainKey = request.getParameter("strainKey");
        String strOrganOfOriginKey = request.getParameter("organOfOriginKey");
        String strTFKeys = request.getParameter("tumorFrequencyKeys");
        String strTCKeys = request.getParameter("tumorChangeKeys");


        // dto to hold the tumor summary data
        MTBTumorSummaryDTO dtoTumorSummary = null;

        try {

           

            MTBTumorUtilDAO daoTumorUtil = MTBTumorUtilDAO.getInstance();
            long arrnTFKeys[] = parseKeys(strTFKeys);

            if (strStrainKey != null && strOrganOfOriginKey != null) {

                long nStrainKey = Long.parseLong(strStrainKey);
                long nOrganOriginKey = Long.parseLong(strOrganOfOriginKey);

                dtoTumorSummary =
                        daoTumorUtil.getTumorSummary(nStrainKey,
                        nOrganOriginKey,
                        arrnTFKeys);

                // set the target to failure if we could not retrieve tumor summary
                if (dtoTumorSummary == null) {
                    strTarget = "error";
                } else {

                    if (request.getParameter("asJSON") != null) {

                        response.setContentType("application/json");
                        response.getWriter().write(resultsAsJSON(dtoTumorSummary));
                        response.flushBuffer();
                        return null;
                    }
                    // strip the duplicate strain synonyms for display purposes
                    ArrayList<StrainSynonymsDTO> arrSynonyms =
                            new ArrayList<>(dtoTumorSummary.getStrainSynonyms());

                    List<StrainSynonymsDTO> filteredSynonyms =
                            WIUtils.filterStrainSynonyms(arrSynonyms,
                            dtoTumorSummary.getStrainName());

                    dtoTumorSummary.setStrainSynonyms(filteredSynonyms);

                    // put the tumor summary in the request
                    request.setAttribute("tumor", dtoTumorSummary);
                }
            } else if (arrnTFKeys != null && arrnTFKeys.length != 0) {




                dtoTumorSummary = daoTumorUtil.getTumorSumary(arrnTFKeys);
                request.setAttribute("tumor", dtoTumorSummary);

                if (request.getParameter("asJSON") != null) {

                    response.setContentType("application/json");
                    response.getWriter().write(resultsAsJSON(dtoTumorSummary));
                    response.flushBuffer();
                    return null;
                }

            } else {
                strTarget = "cyto";
                long[] tcKeys = parseKeys(strTCKeys);
                MTBGeneticsUtilDAO dao = MTBGeneticsUtilDAO.getInstance();
                List<MTBTumorGeneticChangesDTO> results =
                        dao.searchTumorCytoGenetics(new ArrayList(), new ArrayList(), tcKeys, -1, "", false).getList();

                request.setAttribute("tumor", results);

            }
         

        } catch (Exception e) {
            log.error("Error in tumor summary", e);
            StringBuffer sb = new StringBuffer();
            sb.append("strain key = ").append(strStrainKey).append(WIConstants.EOL);
            sb.append("organ of origin key = ").append(strOrganOfOriginKey).append(WIConstants.EOL);
            sb.append("tumor frequency key = ").append(strTFKeys).append(WIConstants.EOL);
            log.error(sb.toString());
        }

       

        // forward to the appropriate View
        return mapping.findForward(strTarget);
    }

    // ------------------------------------------------------ Protected Methods
    // none
    // -------------------------------------------------------- Private Methods
    /**
     * Parse a String of tumor frequency keys into an array of longs.
     *
     * @param strTFKeys the comma separated tumor frequency key string
     * @return an array of longs representing tumor frequency keys
     */
    private long[] parseKeys(String strTFKeys) {
        long[] arrnTFKeys = null;

        if (StringUtils.hasValue(strTFKeys)) {
            // split the comma seperated string into an array
            String[] arrStrings = StringUtils.separateString(strTFKeys, ",");

            if (arrStrings.length > 0) {
                arrnTFKeys = new long[arrStrings.length];

                // loop through the strings and convert them to long
                for (int i = 0; i < arrStrings.length; i++) {
                    arrnTFKeys[i] = Long.parseLong(arrStrings[i]);
                }
            }
        }

        return arrnTFKeys;
    }
   // at this point this is just for OMF's Shann-Chin
    private String resultsAsJSON(MTBTumorSummaryDTO result) {
        StringBuilder json = new StringBuilder();
        json.append("{\"tumor summary\":{");
        json.append("\"tumor name\":\"").append(result.getTumorName()).append("\",\n");
        json.append("\"treatment type\":\"").append(result.getTreatmentType()).append("\",\n");
        json.append("\"tumor synonyms\":[\n");
        Set<String> tSynonyms = (Set<String>) result.getTumorSynonyms().keySet();
        int i = 0;
        for (String syn : tSynonyms) {
            if (i++ > 0) {
                json.append(",\n");
            }
            json.append("{\"tumor synonym\":\"").append(syn).append("\"}");
        }
         json.append("],\n");
         
         json.append("\"strain name\":\"").append(result.getStrainName()).append("\",\n");
        json.append("\"strain types\":[\n");
        
        Collection<StrainTypeDTO> sTypes = (Collection<StrainTypeDTO>) result.getStrainTypes();
        i = 0;
        for (StrainTypeDTO dto : sTypes) {
            if (i++ > 0) {
                json.append(",\n");
            }
            json.append("{\"strain type\":\"").append(dto.getType()).append("\"}");
        }
         json.append("],\n");
        
        json.append("\"strain note\":\"").append(result.getStrainNote().replaceAll("\"", "'")).append("\"},\n");

         json.append("\"strain synonyms\":[\n");
        Collection<StrainSynonymsDTO> sSynonyms = (Collection<StrainSynonymsDTO>) result.getStrainSynonyms();
        i = 0;
        for (StrainSynonymsDTO syn : sSynonyms) {
            if (i++ > 0) {
                json.append(",\n");
            }
            json.append("{\"strain synonym\":\"").append(syn.getName()).append("\"}");
        }
         json.append("],\n");

        json.append("\"tumor frequencies\":[");
        i = 0;
        Collection<MTBTumorFrequencySummaryDTO> recs = (Collection<MTBTumorFrequencySummaryDTO>) result.getFrequencyRecs();

        for (MTBTumorFrequencySummaryDTO summary : recs) {

            if (i++ > 0) {
                json.append(",\n");
            }
            json.append("{\"tfKey\":\"").append(summary.getTumorFrequencyKey()).append("\",\n");
            json.append("\"mets from\":\"");
            if (summary.getTumorFrequencyKey() != summary.getParentFrequencyKey()) {
                json.append(summary.getParentFrequencyKey());
            }
            json.append("\",\n");
            json.append("\"organAffected\":\"").append(summary.getOrganAffected()).append("\",\n");
            json.append("\"treatment type\":\"").append(result.getTreatmentType()).append("\",\n");
            json.append("\"agents\":[\n");
            int j = 0;
            Collection<String> agents = (Collection<String>) summary.getSortedAgents();
            for (String agent : agents) {
                if (j++ > 0) {
                    json.append(",\n");
                }
                json.append("{\"agent\":\"").append(agent).append("\"}");

            }
            json.append("],\n");
            json.append("\"sex\":\"").append(summary.getStrainSex()).append("\",\n");
            json.append("\"reproductive status\":\"").append(summary.getReproductiveStatus()).append("\",\n");
            json.append("\"infection status\":\"").append(summary.getInfectionStatus()).append("\",\n");
            json.append("\"frequency\":\"").append(summary.getFrequencyString()).append("\",\n");
            json.append("\"num mice affected\":\"").append(summary.getNumMiceAffected()).append("\",\n");
            json.append("\"colonysize\":\"").append(summary.getColonySize()).append("\",\n");
            json.append("\"age onset\":\"").append(summary.getAgeOnset()).append("\",\n");
            json.append("\"age detection\":\"").append(summary.getAgeDetection()).append("\"}\n");

        }
        json.append("]}");



        return json.toString();
    }
}
