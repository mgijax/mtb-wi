/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.jax.mgi.mtb.wi.actions;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.jax.mgi.mtb.dao.custom.mtb.pdx.PDXDAO;
import org.jax.mgi.mtb.wi.WIConstants;
import org.jax.mgi.mtb.wi.pdx.PDXMouseStore;

/**
 * Provides data for paginated variation display
 *
 * @author sbn
 */
public class HumanGeneAction extends Action {

    public ActionForward execute(ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {

        boolean ctpOnly = false;
        String query = request.getParameter("query");
       
        if("ctpOnly".equals(request.getParameter("ctpOnly"))){
            ctpOnly = true;
        }

       

        response.setContentType("application/json");

        String json = PDXDAO.getInstance().getHumanGenes(query, ctpOnly);

        response.getWriter().write(json);
        response.flushBuffer();

        return null;
    }

}
