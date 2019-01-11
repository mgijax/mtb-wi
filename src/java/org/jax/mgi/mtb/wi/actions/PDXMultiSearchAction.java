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
import org.jax.mgi.mtb.wi.pdx.ParseGeneCases;

/**
 * Validation indicate invalid genes, invalid syntax, better formatting of
 * results table
 *
 * @author sbn
 */
public class PDXMultiSearchAction extends Action {

    public ActionForward execute(ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {

        boolean asHTML = !"asCSV".equals(request.getParameter("asCSV"));
        boolean actionable = "actionable".equals(request.getParameter("actionable"));
       
        String cases = request.getParameter("cases");
        if (cases != null && cases.trim().length() > 0) {
            Scanner s = new Scanner(cases);
            s.useDelimiter("\n");
            ParseGeneCases pgc = new ParseGeneCases();
            if (asHTML) {
                request.setAttribute("table", pgc.parseCases(s, asHTML, actionable));
                request.setAttribute("cases", cases);
            } else {
                Date d = new Date(System.currentTimeMillis());
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                String date = sdf.format(d);
                response.setContentType("text/csv");
                response.setHeader("Content-disposition", "attachment; filename=PDXCaseReport-" + date + ".csv");
                response.getWriter().write(pgc.parseCases(s, asHTML, actionable));
                return null;
            }
        }

        return mapping.findForward("success");
    }
}
