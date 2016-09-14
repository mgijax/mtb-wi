/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package org.jax.mgi.mtb.wi.actions;

import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.jax.mgi.mtb.dao.custom.mtb.MTBSeriesSampleSearchDTO;
import org.jax.mgi.mtb.dao.custom.mtb.MTBSeriesSampleUtilDAO;
import org.jax.mgi.mtb.dao.gen.mtb.SampleDTO;
import org.jax.mgi.mtb.wi.forms.GeneExpressionForm;
import org.jax.mgi.mtb.wi.utils.WIUtils;

/**
 *
 * @author sbn
 */
public class GeneExpressionSearchResultsAction extends Action{

  
   private final static Logger log =
            Logger.getLogger(GeneExpressionSearchResultsAction.class.getName());
   
   
   
   
    public ActionForward execute(ActionMapping mapping,
                                 ActionForm form,
                                 HttpServletRequest request,
                                 HttpServletResponse response)
        throws Exception {
      
      GeneExpressionForm geForm = (GeneExpressionForm) form;
      
      List<String> organs = WIUtils.arrayToCleanList(geForm.getOrgan());
      List<String> platforms = WIUtils.arrayToCleanList(geForm.getPlatform());
      List<String> tumorClassifications = WIUtils.arrayToCleanList(geForm.getTumorClassification());
      
      String tfKey = geForm.getTfKey()+"";
      String seriesId = geForm.getSeriesId();
     
      String strainLikeClause = geForm.getLikeClause();
      String strainName = geForm.getStrainName();
      
      if(request.getParameter("tfKeys")!=null){
          tfKey = request.getParameter("tfKeys");
      }
     
      MTBSeriesSampleUtilDAO ssuDAO = MTBSeriesSampleUtilDAO.getInstance();
      
      ArrayList<MTBSeriesSampleSearchDTO> results = ssuDAO.searchSeries(tumorClassifications, organs ,platforms,strainName,strainLikeClause,tfKey, seriesId);
      String samplesWOSeries = null;
      String seriesWSamples = null;
      int resultsSize = results.size();
      if(resultsSize > 0 ){
        seriesWSamples = resultsSize+"";
        if (results.get(resultsSize-1).getTotalSamples() == 0){
          samplesWOSeries = results.get(resultsSize-1).getSampleCount()+"";  
          seriesWSamples = resultsSize-1+"";
        }
      }
      if(request.getParameter("asJSON") != null){
              
                response.setContentType("application/json");
                response.getWriter().write(resultsAsJSON(results));
                response.flushBuffer();
                return null;
      }
      
      
      request.setAttribute("seriesWSamples", seriesWSamples);
      request.setAttribute("samplesWOSeries", samplesWOSeries);
      request.setAttribute("results", results);
      request.setAttribute("organs",WIUtils.organKeysToLabel(organs));
      request.setAttribute("tumorClassifications", WIUtils.tumorclassificationKeysToLabel(tumorClassifications));
      request.setAttribute("platforms",platforms);
      
      if(seriesId != null && seriesId.length()>0){
        request.setAttribute("seriesId",seriesId);
      }
     
      if(strainName.length()>0){
        request.setAttribute("strainName",strainLikeClause+" "+ strainName);
      }
      
      String forward = "success";
      
      
      return mapping.findForward(forward);

      
    }
    
      private  String resultsAsJSON(ArrayList<MTBSeriesSampleSearchDTO> results){
        
      
        
        StringBuilder json = new StringBuilder("{\"expression\"\n:{\"series\":\n[");
        int i =0;
        for(MTBSeriesSampleSearchDTO dto :results){
            if(i++>0)json.append(",\n");
            json.append("{\"id\":\"").append(dto.getSeries().getId()).append("\",\n");
            json.append("\"title\":\"").append(dto.getSeries().getTitle()).append("\",\n");
            json.append("\"samples\":[\n");
            int j =0;
            for(SampleDTO sample : dto.getSamples()){
                if(j++>0)json.append(",\n");
                json.append("{\"id\":\"").append(sample.getId()).append("\",\n");
                json.append("\"is control\":\"").append(sample.getIsControl()).append("\",\n");
                json.append("\"platform\":\"").append(sample.getPlatform()).append("\",\n");
                json.append("\"title\":\"").append(sample.getTitle()).append("\",\n");
                json.append("\"tfKey\":\"").append(sample.getDataBean().get("tfKey")).append("\"}");
            }
            json.append("]}");
        }
        json.append("]}}");
        
        return json.toString();
        
    }
  
}
