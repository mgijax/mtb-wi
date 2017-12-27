/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.jax.mgi.mtb.wi.actions;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.actions.DispatchAction;
import org.jax.mgi.mtb.dao.custom.mtb.pdx.PDXComment;
import org.jax.mgi.mtb.dao.custom.mtb.pdx.PDXDocument;
import org.jax.mgi.mtb.dao.custom.mtb.pdx.PDXGraphic;
import org.jax.mgi.mtb.dao.custom.mtb.pdx.PDXLink;

import org.jax.mgi.mtb.wi.pdx.PDXMouseStore;

/**
 *
 * @author sbn
 */
public class PDXEditContentAction extends DispatchAction {

    public ActionForward document(ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {

        PDXMouseStore store = new PDXMouseStore();
        String result = "edit";
        String modelID = request.getParameter("modelID");
        String action = request.getParameter("action");

        int contentKey = 0;
        try {
            contentKey = new Integer(request.getParameter("contentKey")).intValue();
        } catch (NumberFormatException nfe) {
            // not much we can do it came from the url
        }

        String user = validateUser(request);

        if (user == null) {

            result = action = "reject";

        }

        if ("delete".equals(action)) {

            store.deleteDocument(contentKey);

            returnSuccess(response);
            return null;
        }
        if ("update".equals(action)) {

            PDXDocument doc = new PDXDocument();
            doc.setContentKey(contentKey);
            doc.setDescription(request.getParameter("documentDescription"));
            doc.setLinkText(request.getParameter("documentLinkText"));
            doc.setUser(user);
            store.updateDocument(doc);

            returnSuccess(response);
            return null;
        }

        PDXDocument doc = store.getDocument(contentKey);

        request.setAttribute("documentDescription", doc.getDescription());
        request.setAttribute("documentLinkText", doc.getLinkText());

        request.setAttribute("contentKey", contentKey);
        request.setAttribute("modelID", modelID);
        request.setAttribute("hidePiForm", "true");
        request.setAttribute("hideDocumentForm", "false");
        request.setAttribute("hideGraphicForm", "true");
        request.setAttribute("hideLinkForm", "true");
        request.setAttribute("hideCommentForm", "true");

        return mapping.findForward(result);
    }

    public ActionForward graphic(ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {

        PDXMouseStore store = new PDXMouseStore();
        String result = "edit";
        String modelID = request.getParameter("modelID");
        String action = request.getParameter("action");

        int contentKey = 0;
        try {
            contentKey = new Integer(request.getParameter("contentKey")).intValue();
        } catch (NumberFormatException nfe) {
            // not much we can do it came from the url
        }
        String user = validateUser(request);
        if (user == null) {

            result = action = "reject";

        }

        if ("delete".equals(action)) {

            store.deleteGraphic(contentKey);

            returnSuccess(response);
            return null;
        }
        if ("update".equals(action)) {

            PDXGraphic graphic = new PDXGraphic();
            graphic.setContentKey(contentKey);
            graphic.setDescription(request.getParameter("graphicDescription").replace("'", "`").replaceAll("[\\p{C}\\p{Z}]", " "));
            try{    
                graphic.setSortOrder(new Double(request.getParameter("graphicSort")));
            }catch(Exception e){
                log.error("Unable to create sort order from "+request.getParameter("graphicSort"),e);
            }
            graphic.setUser(user);

            store.updateGraphic(graphic);

            returnSuccess(response);
            return null;
        }

        PDXGraphic graphic = store.getGraphic(contentKey);

        request.setAttribute("graphicDescription", graphic.getDescription().replace("'", "`"));
        request.setAttribute("graphicSort",graphic.getSortOrder());
        request.setAttribute("contentKey", contentKey);
        request.setAttribute("modelID", modelID);
        request.setAttribute("hidePiForm", "true");
        request.setAttribute("hideDocumentForm", "true");
        request.setAttribute("hideGraphicForm", "false");
        request.setAttribute("hideLinkForm", "true");
        request.setAttribute("hideCommentForm", "true");

        return mapping.findForward(result);
    }

    public ActionForward link(ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {

        PDXMouseStore store = new PDXMouseStore();

        String result = "edit";

        String modelID = request.getParameter("modelID");
        String action = request.getParameter("action");

        int contentKey = 0;
        try {
            contentKey = new Integer(request.getParameter("contentKey")).intValue();
        } catch (NumberFormatException nfe) {
            // not much we can do it came from the url
        }
        String user = validateUser(request);
        if (user == null) {

            result = action = "reject";

        }

        if ("delete".equals(action)) {

            store.deleteLink(contentKey);

            returnSuccess(response);
            return null;
        }
        if ("update".equals(action)) {

            PDXLink link = new PDXLink();
            link.setContentKey(contentKey);
            link.setLinkText(request.getParameter("linkText"));
            link.setDescription(request.getParameter("linkDescription"));
            link.setUrl(request.getParameter("linkURL"));
            link.setUser(user);
            store.updateLink(link);

            returnSuccess(response);
            return null;
        }

        PDXLink link = store.getLink(contentKey);

        request.setAttribute("linkDescription", link.getDescription());
        request.setAttribute("linkText", link.getLinkText());
        request.setAttribute("linkURL", link.getUrl());

        request.setAttribute("contentKey", contentKey);
        request.setAttribute("modelID", modelID);
        request.setAttribute("hidePiForm", "true");
        request.setAttribute("hideDocumentForm", "true");
        request.setAttribute("hideGraphicForm", "true");
        request.setAttribute("hideLinkForm", "false");
        request.setAttribute("hideCommentForm", "true");

        return mapping.findForward(result);
    }

    public ActionForward comment(ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {

        PDXMouseStore store = new PDXMouseStore();

        String result = "edit";

        String modelID = request.getParameter("modelID");
        String action = request.getParameter("action");

        int contentKey = 0;
        try {
            contentKey = new Integer(request.getParameter("contentKey")).intValue();
        } catch (NumberFormatException nfe) {
            // not much we can do it came from the url
        }
        String user = validateUser(request);
        if (user == null) {

            result = action = "reject";

        }

        if ("delete".equals(action)) {

            store.deleteComment(contentKey);

            returnSuccess(response);
            return null;

        }
        if ("update".equals(action)) {

            PDXComment comment = new PDXComment();
            comment.setContentKey(contentKey);
            comment.setComment(request.getParameter("comment").replace("'", "`").replaceAll("[\\p{C}\\p{Z}]", " "));
            comment.setUser(user);
            store.updateComment(comment);

            returnSuccess(response);
            return null;
        }

        PDXComment comment = store.getComment(contentKey);

        request.setAttribute("comment", comment.getComment().replaceAll("[\\p{C}\\p{Z}]", " "));

        request.setAttribute("contentKey", contentKey);
        request.setAttribute("modelID", modelID);
        request.setAttribute("hidePiForm", "true");
        request.setAttribute("hideDocumentForm", "true");
        request.setAttribute("hideGraphicForm", "true");
        request.setAttribute("hideLinkForm", "true");
        request.setAttribute("hideCommentForm", "false");

        return mapping.findForward(result);
    }

    private void returnSuccess(HttpServletResponse response) {

        try {
            response.setContentType("text/html");

            response.getWriter().write("{success:true}");

            response.flushBuffer();

            response.getWriter().close();

        } catch (Exception e) {
        }

    }

    private String validateUser(HttpServletRequest request) {

        String user = (String) request.getSession().getAttribute("pdxUser");

        return user;
    }

}
