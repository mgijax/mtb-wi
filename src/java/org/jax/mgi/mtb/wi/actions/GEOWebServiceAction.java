package org.jax.mgi.mtb.wi.actions;

import java.util.ArrayList;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.jax.mgi.mtb.dao.custom.mtb.MTBSeriesSampleUtilDAO;

/**
 * @author sbn
 */
public class GEOWebServiceAction extends Action {
    
    public GEOWebServiceAction(){
        super();
    }

    @Override
    public ActionForward execute(ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {

        // geo id
        String gse = request.getParameter("gse");
        String gpl = request.getParameter("gpl");
        
        MTBSeriesSampleUtilDAO dao = MTBSeriesSampleUtilDAO.getInstance();
        ArrayList<ArrayList<String>> data = dao.getGEOTFData(gse,gpl);
        String results = processData(data);
        response.setContentType("application/json");
        response.getWriter().write(results);
        response.flushBuffer();

        return null;
    }
    
    private String processData(ArrayList<ArrayList<String>> data){
        StringBuffer json = new StringBuffer();
        ArrayList<String> columns = data.remove(0);
        String geo = null;
  
        for(ArrayList<String> row : data){
        
            if(geo == null){
                geo = row.get(0);
                json.append("{\""+geo+"\":{");
            }else{
                if(!geo.equals(row.get(0))){
                    json.deleteCharAt(json.length()-1);
                    geo = row.get(0);
                    json.append("},\""+geo+"\":{");
                }
            }
            json.append("\""+row.get(1)+"\":{");
            for(int i = 2; i < columns.size(); i++){
                json.append("\""+columns.get(i)+"\":");
                json.append("\""+row.get(i)+"\",");
            }
            json.deleteCharAt(json.length()-1); // remove the last comma
            json.append("},");
        }
          json.deleteCharAt(json.length()-1); // remove the last comma
        json.append("}}");
        
        return json.toString();
                
    }
}
