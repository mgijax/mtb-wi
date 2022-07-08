/**
 * Header: $Header: /mgi/cvsroot/mgi/mtb/mtbwi/src/java/org/jax/mgi/mtb/wi/actions/SolrAction.java,v 1.1 2016/04/05 20:18:41 sbn Exp $
 * Author: $Author: sbn $
 */
package org.jax.mgi.mtb.wi.actions;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse; 
import org.apache.logging.log4j.Logger;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.jax.mgi.mtb.dao.custom.SearchResults;
import org.jax.mgi.mtb.dao.custom.mtb.MTBGeneticsUtilDAO;
import org.jax.mgi.mtb.dao.gen.mtb.AlleleDTO;
import org.jax.mgi.mtb.wi.WIConstants;

/**
 * Redirect requests to solr
 *
 * @author $Author: sbn $
 * @date $Date: 2016/04/05 20:18:41 $
 * @version $Revision: 1.1 $
 * @cvsheader $Header: /mgi/cvsroot/mgi/mtb/mtbwi/src/java/org/jax/mgi/mtb/wi/actions/SolrAction.java,v 1.1 2016/04/05 20:18:41 sbn Exp $
 * @see org.apache.struts.action.Action
 */
public class SolrAction extends Action {
    
    private final static String solrURL = WIConstants.getInstance().getSolrURL();

    private final static Logger log =
            org.apache.logging.log4j.LogManager.getLogger(SolrAction.class.getName());

    public ActionForward execute(ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {

        URL url = null;
        if(request.getQueryString()  != null){
          String query = request.getQueryString();
          if(query.contains("alleleID")){
              request.setAttribute("url",getAlleleIDURL(query));
              return mapping.findForward("pleaseWait");
          }else{
            url = new URL(solrURL + "?" + query);
          }
        }else{
           
            StringBuilder queryStr = new StringBuilder();
            queryStr.append("?");
            for(Object key :request.getParameterMap().keySet()){
                String[] values = request.getParameterValues(key.toString());
                for(int i=0; i < values.length; i++ ){
                queryStr.append(key).append("=").append(values[i]).append("&");
            }
           
            }
                 // drop the trailing &
            queryStr.deleteCharAt(queryStr.length()-1);
           
            url = new URL(solrURL+queryStr.toString().replaceAll(" ","%20"));
       
        }
 
        //log.debug(url);
        HttpURLConnection connection =
                (HttpURLConnection) url.openConnection();

        connection.setRequestMethod("GET");

        connection.setDoOutput(true);
        connection.setDoInput(true); 
        connection.setUseCaches(false);

        StringBuilder responseStr = new StringBuilder();
        String responseSingle;

        // Open a stream which can read the server response
        InputStream in = connection.getInputStream();
        try {
            BufferedReader rd = new BufferedReader(new InputStreamReader(in));
            while ((responseSingle = rd.readLine()) != null) {
                responseStr.append(responseSingle);
            }
            rd.close();

        } catch (IOException e) {
            log.error("failed getting response for solr query:"+url.toString(),e);
        } finally {
            if (in != null) {
                in.close();
                connection.disconnect();
                
            }
        }

        response.setContentType("text");

        response.getWriter().write(responseStr.toString());

        return null;
    }
    
    private String getAlleleIDURL(String query){
        StringBuilder url = new StringBuilder("/mtbwi/facetedSearch.do");
        try{
        String[] parts = query.split("=");
        if(parts[1].startsWith("MGI:")){
           
           SearchResults<AlleleDTO> results = MTBGeneticsUtilDAO.getInstance().searchAllele(parts[1],0,null,null,null,null,1);
           url.append("#fq=strainMarker%253A%2522");
           
           // replace any #'s with %2523
           String symbol = results.getList().get(0).getSymbol();
           symbol = symbol.replaceAll("#", "%2523");
           
           url.append(symbol).append("%2522");
        }
        }catch(Exception e){
            log.error("Unable to get allele symbol for "+query,e);
            url = new StringBuilder("/mtbwi/facetedSearch.do");
        }
        return url.toString();
    }
}
