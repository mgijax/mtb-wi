/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.jax.mgi.mtb.wi.actions;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Scanner;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.jax.mgi.mtb.wi.pdx.PDXLikeMe;

/**
 * Validation indicate invalid genes, invalid syntax, better formatting of
 * results table
 *
 * @author sbn
 */
public class PDXLikeMeAction extends Action {

    public ActionForward execute(ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {

        String format = PDXLikeMe.FORMAT_HTML;
        if("asCSV".equals(request.getParameter("asCSV"))){
            format = PDXLikeMe.FORMAT_CSV;
        }
        
        
        
        boolean actionable = "actionable".equals(request.getParameter("actionable"));
        
        boolean showEXP = "EXP".equals(request.getParameter("EXP"));
        boolean showLRP = "LRP".equals(request.getParameter("LRP"));
        
        if("Visualize".equals(request.getParameter("viz"))){
            format = PDXLikeMe.FORMAT_VIS;
            showEXP = true;
            showLRP = true;
        }
       
        String cases = request.getParameter("cases");
        
        request.setAttribute("caseCount", 0);
        
        if (cases != null && cases.trim().length() > 0) {
            Scanner s = new Scanner(cases);
            s.useDelimiter("\n");
            PDXLikeMe pdxLM = new PDXLikeMe();
            if (format.equals(PDXLikeMe.FORMAT_HTML)) {
                String table = pdxLM.parseCases(s, format, actionable, showLRP, showEXP);
                
                request.setAttribute("table", table );
                request.setAttribute("cases", cases);
                int caseCount = cases.toLowerCase().split("case").length;
                request.setAttribute("caseCount", caseCount);
            } else if (format.equals(PDXLikeMe.FORMAT_CSV)) {
                Date d = new Date(System.currentTimeMillis());
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                String date = sdf.format(d);
                response.setContentType("text/csv");
                response.setHeader("Content-disposition", "attachment; filename=PDXCaseReport-" + date + ".csv");
                response.getWriter().write(pdxLM.parseCases(s, format, actionable, showLRP, showEXP));
                return null;
            } else if(format.equals(PDXLikeMe.FORMAT_VIS)){
                
                request.setAttribute("table",(pdxLM.parseCases(s, format, actionable, showLRP, showEXP)));
                
                int caseCount = cases.toLowerCase().split("case").length;
                request.setAttribute("caseCount", caseCount);
                return mapping.findForward("vis");
                
                
            }
            
            //if(!asHTML){
            //    request.setAttribute("csvChecked","checked");
            //}
            
            if(actionable){
                request.setAttribute("actionableChecked","checked");
            }
            if(showEXP){
                request.setAttribute("expChecked","checked");
            }
            if(showLRP){
                request.setAttribute("lrpChecked","checked");
            }
            
        }

        return mapping.findForward("success");
    }
}
