/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.jax.mgi.mtb.wi.actions;

import java.io.InputStream;
import java.util.ArrayList;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.jax.mgi.mtb.wi.forms.QTLForm;
import org.jax.mgi.mtb.wi.utils.GViewerFeature;
import org.jax.mgi.mtb.wi.utils.QTLParser;
import org.apache.struts.upload.FormFile;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.Iterator;
import org.apache.log4j.Logger;
import org.apache.struts.actions.DispatchAction;
import org.jax.mgi.mtb.dao.custom.mtb.MTBSynchronizationUtilDAO;
import org.jax.mgi.mtb.wi.utils.BandingParser;
import org.jax.mgi.mtb.wi.utils.FeatureFormatUtils;
import org.jax.mgi.mtb.wi.utils.SyntenyStore;

public class ViewerAction extends DispatchAction {

    private final static Logger log =
            Logger.getLogger(ViewerAction.class.getName());

    public ActionForward export(ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {

        FeatureFormatUtils ffu = new FeatureFormatUtils();

        // export features as a file

        String xml = request.getParameter("exportXML");

        String gff = null;
        try {
            gff = ffu.parseXMLtoGFF(xml);
        } catch (Exception e) {
            gff = e.getMessage();
        }
        response.setHeader("Content-disposition", "attachment; filename=viewer_gff.txt");
        response.getWriter().write(gff);
        response.flushBuffer();
        return null;

    }

    public ActionForward getBands(ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {

        String bandingXML = null;
        String chr = request.getParameter("chromosome");
        if (chr != null) {
            bandingXML = BandingParser.getBands(chr);
        } else {
            bandingXML = BandingParser.getAllBands();
        }

        response.setContentType("text/xml");
        response.getWriter().write(bandingXML);

        response.flushBuffer();
        return null;
    }

    public ActionForward getHumanBands(ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {

        String bandingXML = null;

        bandingXML = BandingParser.getHumanBands();


        response.setContentType("text/xml");
        response.getWriter().write(bandingXML);

        response.flushBuffer();
        return null;
    }

    public ActionForward upload(ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {

        FeatureFormatUtils ffu = new FeatureFormatUtils();
        QTLForm qtlForm = (QTLForm) form;
        FormFile fFile = qtlForm.getFilePath();

        InputStream is = fFile.getInputStream();

        BufferedReader br = new BufferedReader(new InputStreamReader(is));
        StringBuffer data = new StringBuffer();
        String line = br.readLine();
        while (line != null) {
            data.append(line).append("\n");
            line = br.readLine();
        }
        String xml = "";
        String color = request.getParameter("color");
        String group = request.getParameter("group");
        if (group == null || group.trim().length() == 0) {
            group = "user defined";
        }
        String track = request.getParameter("track");
        String trackIndex = request.getParameter("trackIndex");
        if (color == null || color.length() < 3) {
            color = "green";
        }
        // track = track + trackIndex;
        try {

            xml = ffu.parseGFFToXML(data.toString(), color, group, track);


        } catch (Exception e) {
            log.error(e);
        }
        response.setContentType("text/xml");
        if (xml.length() > 0) {
            response.getWriter().write("<?xml version=\"1.0\" encoding=\"UTF-8\"?><message success=\"true\">" + xml + "</message>");
        } else {
            response.getWriter().write("<?xml version=\"1.0\" encoding=\"UTF-8\"?><message success=\"false\"></message>");
        }
        response.flushBuffer();
        return null;
    }

    public ActionForward getOrganGroups(ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {
        QTLParser parser = new QTLParser();
        response.setContentType("text/xml");
        response.getWriter().write(parser.getQTLTypesXML());
        response.flushBuffer();
        return null;
    }

    public ActionForward getQTLs(ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {


        FeatureFormatUtils ffu = new FeatureFormatUtils();
        QTLForm qtlForm = (QTLForm) form;
        String strTarget = "success";

        QTLParser qtlParser = new QTLParser();
        String[] selectedTypes = qtlForm.getSelectedQTLTypes();

        // load QTL from selected organ types
        // my be as features, tab delimited text or HTML


        ArrayList<GViewerFeature> features = qtlParser.getFeaturesForTypes(selectedTypes, QTLParser.SORT_FOR_LIST);

        if ("HTML".equals(request.getParameter("qtlList"))) {
            // display a list of the QTL data for the selected types
            strTarget = "qtlList";
            request.setAttribute("features", features);
            return mapping.findForward(strTarget);

        } else {
            String text = "";
            if ("tabbed".equals(request.getParameter("qtlList"))) {
                // display a list of the QTL data for the selected types
                response.setContentType("text/plain");

                text = buildTabbedList(features);

            } else {
                StringBuffer xml = new StringBuffer();
                xml.append("<features>");

                if (selectedTypes[0].equals("All")) {
                    xml.append(qtlParser.getXMLForAll());
                } else {
                    xml.append(qtlParser.getXMLForTypes(selectedTypes));
                }

                xml.append("</features>");
                String xmlStr = xml.toString();
                text = xmlStr.replaceAll("&", "and");

                response.setContentType("text/xml");
            }
            response.getWriter().write(text);
            response.flushBuffer();
            return null;
        }
    }

    public ActionForward getMGIFeatures(ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {

        String ch = request.getParameter("chromosome");
        // get features from mgi base on chromosome and start and end coordinates

        StringBuffer xmlSb = new StringBuffer();
        String start = request.getParameter("start");
        String end = request.getParameter("end");

        String pheno = request.getParameter("phenotype");

        String go_op = request.getParameter("go_op");
        String go_term = request.getParameter("go_term");

        String name = request.getParameter("gsmname_term");
        String nameOp = request.getParameter("gsmname_op");
        String sortBy = request.getParameter("sort");
        String[] ontology_keys = request.getParameterValues("ontology_key");
        if (ontology_keys != null) {
            for (int i = 0; i < ontology_keys.length; i++) {
                ontology_keys[i] = ontology_keys[i].replaceAll(" ", "+\n");
            }
        }
        String[] mcvs = request.getParameterValues("mcv");

        GViewerDetailsAction gvda = new GViewerDetailsAction();

        String url = gvda.buildURL(start, end, ch, name, nameOp, pheno, go_op, go_term, sortBy, ontology_keys, mcvs);

        if ("tab".equals(request.getParameter("display"))) {
            response.sendRedirect(response.encodeRedirectURL(url));
            return null;
        }

        ArrayList<GViewerFeature> features = gvda.parseMGIURL(url);
        QTLParser parser = new QTLParser();
        // features = parser.sort(features);
        if ("details".equals(request.getParameter("linkTo"))) {
            // features in viewer link to details page not MGI
            for (GViewerFeature feature : features) {
                //           feature.buildLink();
            }
        }

        xmlSb.append("<features>");


        String linkParams = "";
        Iterator it = features.iterator();
        while (it.hasNext()) {
            GViewerFeature feat = (GViewerFeature) it.next();
            xmlSb.append(feat.toXML(linkParams)).append("\n");
        }

        xmlSb.append("</features>");
        String xmlStr = xmlSb.toString();
        String text = xmlStr.replaceAll("&", "and");

        response.setContentType("text/xml");

        response.getWriter().write(text);
        response.flushBuffer();
        return null;

    }

    public ActionForward syntenyViewer(ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {

        return mapping.findForward("syntenyViewer");


    }

    public ActionForward getSyntenicFeatures(ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {
        try {
            String ch = request.getParameter("chromosome");
            // get features from mgi base on chromosome and start and end coordinates

            StringBuffer xmlSb = new StringBuffer();
            String source = request.getParameter("source");
            String start = request.getParameter("start");
            String end = request.getParameter("end");

            SyntenyStore sStore = new SyntenyStore();


            ArrayList<GViewerFeature> features = sStore.getRegionsAsFeatures(source, ch, start, end);

            xmlSb.append("<features>");


            String linkParams = "";
            Iterator it = features.iterator();
            while (it.hasNext()) {
                GViewerFeature feat = (GViewerFeature) it.next();
                xmlSb.append(feat.toXML(linkParams)).append("\n");
            }

            xmlSb.append("</features>");
            String xmlStr = xmlSb.toString();
            String text = xmlStr.replaceAll("&", "and");

            response.setContentType("text/xml");

            response.getWriter().write(text);
            response.flushBuffer();

        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }

        return null;
    }

    public ActionForward unspecified(ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {

        return mapping.findForward("success");

    }

    public ActionForward details(ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {


        QTLForm qtlForm = (QTLForm) form;

        String location = request.getParameter("location");

        // location is in the format <chromosome>:<start>..<end>
        String start = location.substring(location.indexOf(":") + 1, location.indexOf("."));
        String end = location.substring(location.indexOf(".") + 2);
        String chrom = location.substring(0, location.indexOf(":"));

        String mgiId = request.getParameter("id");
        String description = request.getParameter("description");
        String types = request.getParameter("types");
        String primeRef = request.getParameter("primeRef");
        String name = request.getParameter("name");

        if (name != null) {
            name = name.replace('+', ' ');
        }
        MTBSynchronizationUtilDAO syncDAO = MTBSynchronizationUtilDAO.getInstance();

        qtlForm.setLabel(name);
        qtlForm.setMgiId(mgiId);
        qtlForm.setQtlStart(start);
        qtlForm.setQtlEnd(end);
        qtlForm.setChrom(chrom);
        qtlForm.setPrimeRef(primeRef);
        qtlForm.setTypes(types);
        qtlForm.setQtlName(description);
        qtlForm.setSearchStart(start);
        qtlForm.setSearchEnd(end);
        qtlForm.setPrimeRefId(syncDAO.getIDForRef(primeRef));

        if (mgiId != null) {
            // get the strains from MGI based on the QTLs MGI id

            request.setAttribute("strains", syncDAO.getStrainsForQTL(mgiId));
        }
        return mapping.findForward("details");
    }

    private String buildTabbedList(ArrayList<GViewerFeature> features) {
        StringBuffer text = new StringBuffer();

        for (GViewerFeature feature : features) {
            text.append(feature.getMgiId());
            text.append("\t");
            text.append(feature.getDescription());
            text.append("\t");
            text.append(feature.getName());
            text.append("\t");
            text.append(feature.getOrgan());
            text.append("\t");
            text.append(feature.getChromosome());
            text.append(":");
            text.append(feature.getStart());
            text.append("..");
            text.append(feature.getEnd());
            text.append("\t");
            text.append(feature.getPrimeRef());
            text.append("\n");
        }

        return text.toString();

    }
}
