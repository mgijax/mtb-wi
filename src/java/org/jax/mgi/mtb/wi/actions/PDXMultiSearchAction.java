/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.jax.mgi.mtb.wi.actions;

import java.util.Scanner;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.jax.mgi.mtb.wi.pdx.ParseGeneCases;

/**
 *
 * @author sbn
 */
public class PDXMultiSearchAction extends Action {

    public ActionForward execute(ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {

        String cases = request.getParameter("cases");
        if(cases != null && cases.trim().length()>0){
            Scanner s = new Scanner(cases);
            s.useDelimiter("\n");
            ParseGeneCases pgc = new ParseGeneCases();
            
            request.setAttribute("table", pgc.parseCases(s,true));
        }

        return mapping.findForward("success");
    }
}
