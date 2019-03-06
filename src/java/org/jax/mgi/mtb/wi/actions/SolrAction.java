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
import org.apache.log4j.Logger;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
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
            Logger.getLogger(SolrAction.class.getName());

    public ActionForward execute(ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {

        URL url = null;
        if(request.getQueryString()  != null){
          url = new URL(solrURL + "?" + request.getQueryString());
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
 
        log.debug(url);
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
}
