/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.jax.mgi.mtb.wi.actions;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Set;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.jax.mgi.mtb.dao.custom.mtb.pdx.PDXMouse;
import org.jax.mgi.mtb.utils.LabelValueBean;
import org.jax.mgi.mtb.wi.forms.PDXForm;
import org.jax.mgi.mtb.wi.pdx.PDXMouseStore;
import org.jax.mgi.mtb.wi.utils.WIUtils;

/**
 * Two main tasks: Provide the vocab lists for the pdxComparison page And turn
 * the search criteria into an html display
 *
 * @author sbn
 */
public class PDXComparisonAction extends Action {

    public ActionForward execute(ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {

        String result = "display";

        PDXMouseStore pdxMouseStore = new PDXMouseStore();

        PDXForm pdxForm = (PDXForm) form;
        ArrayList<String> primarySites = (ArrayList<String>) WIUtils.arrayToCleanList(pdxForm.getPrimarySites());
        ArrayList<String> diagnoses = (ArrayList<String>) WIUtils.arrayToCleanList(pdxForm.getDiagnoses());

        // this list of genes contains a lot that have no expression or cnv data  (bad?)
        ArrayList<String> genes = (ArrayList<String>) WIUtils.arrayToCleanList(pdxForm.getGenes());
        String savedGenes = request.getParameter("savedGenesList");
        if (savedGenes != null && savedGenes.length() > 0) {
            genes = (ArrayList<String>) WIUtils.arrayToCleanList(savedGenes.split(","));
        }

        if (genes.isEmpty()) {

            // provide the data for the search for selections
            result = "searchForm";

            primarySites = pdxMouseStore.getPrimarySitesList();
            diagnoses = pdxMouseStore.getDiagnosesList();
            genes = pdxMouseStore.getCTPGenes();

            ArrayList<LabelValueBean<String, String>> diagnosesLVB = new ArrayList<LabelValueBean<String, String>>();
            ArrayList<LabelValueBean<String, String>> primarySitesLVB = new ArrayList<LabelValueBean<String, String>>();
            ArrayList<LabelValueBean<String, String>> genesLVB = new ArrayList<LabelValueBean<String, String>>();

            for (String tissue : primarySites) {
                LabelValueBean<String, String> lvb = new LabelValueBean(tissue, tissue);
                primarySitesLVB.add(lvb);
            }

            for (String diagnosis : diagnoses) {
                LabelValueBean lvb = new LabelValueBean(diagnosis, diagnosis);
                diagnosesLVB.add(lvb);
            }

            for (String gene : genes) {
                LabelValueBean lvb = new LabelValueBean(gene, gene);
                genesLVB.add(lvb);
            }

            request.setAttribute("diagnosesValues", diagnosesLVB);
            request.setAttribute("primarySitesValues", primarySitesLVB);
            request.setAttribute("genesValues", genesLVB);
        } else {
            try {

                // build a big ole html table for the data
                ArrayList<String> no = new ArrayList<String>();

                ArrayList<PDXMouse> mice = null;

                // this, right here, is a real peice of work...
                mice = pdxMouseStore.findMice("", primarySites, diagnoses, no, no, "", no, false, false, no, "",false, null,null);

                StringBuffer table = new StringBuffer("<table><tr><td></td>");

                if (mice.size() > 0) {
                    ArrayList<String> modelIDs = new ArrayList<String>();
                    ArrayList<String> modelNames = new ArrayList<String>();
                    HashMap<String, ArrayList<String>> clinicalPresenting = new HashMap<String, ArrayList<String>>(mice.size());
                    for (PDXMouse mouse : mice) {
                        modelIDs.add(mouse.getModelID());
                        modelNames.add(mouse.getPreviousID());
                        ArrayList<String> vals = new ArrayList<String>();
                        vals.add(mouse.getPreviousID());
                        vals.add(mouse.getAge());
                        vals.add(mouse.getEthnicity());
                        vals.add(mouse.getRace());
                        vals.add(mouse.getSex());
                        vals.add(mouse.getVariant());
                        vals.add(mouse.getCurrentSmoker());
                        vals.add(mouse.getFormerSmoker());
                        vals.add(mouse.getTreatmentNaive());
                        clinicalPresenting.put(mouse.getModelID(), vals);
                    }

                    HashMap<String, HashMap<String, ArrayList<String>>> data = pdxMouseStore.getComparisonData(modelIDs, genes);

                    Set<String> keySet = data.keySet();
                    ArrayList<String> genesList = new ArrayList<String>();
                    genesList.addAll(keySet);
                    Collections.sort(genesList);

                    // genesList can be empty so this may throw a NPE 
                    keySet = data.get(genesList.get(0)).keySet();
                    ArrayList<String> samplesList = new ArrayList<String>();
                    samplesList.addAll(keySet);
                    Collections.sort(samplesList);
                    // would be nice to sort on expression for a specific gene
                    // no idea how at this point

                    StringBuffer expr = new StringBuffer();
                    StringBuffer cnv = new StringBuffer();
                    StringBuffer mutation = new StringBuffer();

                    StringBuffer sex = new StringBuffer("\n<tr><td>Sex</td>");
                    StringBuffer age = new StringBuffer("\n<tr><td>Age</td>");
                    StringBuffer race = new StringBuffer("\n<tr><td>R/E</td>");
                    StringBuffer smoking = new StringBuffer("\n<tr><td>Smoking</td>");
                    StringBuffer treatment = new StringBuffer("\n<tr><td>T. Naive</td>");

                    for (String sample : samplesList) {
                        String[] modSamp = sample.split("-");
                        table.append("<td style=\"vertical-align:bottom; text-align:center;\">").append("<a href=\"pdxDetails.do?modelID=").append(modSamp[0]);
                        table.append("\"><img src=\"dynamicText?text=").append(sample).append("&amp;size=11\" alt=\"X\"></a></td>");
                        ArrayList<String> cp = clinicalPresenting.get(modSamp[0]);

                        if ("unspecified".equals(cp.get(1))) {
                            cp.set(1, "?");
                        }
                        if (cp.get(6).length() < 1) {
                            cp.set(6, "  ");
                        }
                        if (cp.get(7).length() < 1) {
                            cp.set(7, "  ");
                        }
                        if (cp.get(8).length() < 1) {
                            cp.set(8, "  ");
                        }

                        age.append("<td style=\"text-align:center;\">").append(cp.get(1)).append("</td>");
                        race.append("<td style=\"text-align:center;\">").append(cp.get(2)).append("/").append(cp.get(3)).append("</td>");
                        sex.append("<td style=\"text-align:center;\">").append(cp.get(4).charAt(0)).append("</td>");
                        smoking.append("<td style=\"text-align:center;\">").append(cp.get(6).charAt(0)).append("/").append(cp.get(7).charAt(0)).append("</td>");
                        treatment.append("<td style=\"text-align:center;\">").append(cp.get(8).charAt(0)).append("</td>");
                    }
                    table.append("</tr><tr><td></td><td style=\"text-align:center\" colspan=\"");
                    table.append(samplesList.size()).append("\">Gene Expression</td></tr><td></td>");

                    for (String gene : genesList) {
                        expr.append("\n<tr><td>").append(gene).append("</td>");
                        cnv.append("\n<tr><td>").append(gene).append("</td>");
                        mutation.append("\n<tr><td name=\"mtGene\" style=\"cursor:replace_me\" onclick=\"showMutations('" + gene + "');\">").append(gene).append("</td>");
                        HashMap<String, ArrayList<String>> sampleData = data.get(gene);
                        String mutationCursor = "auto";
                        for (String sample : samplesList) {
                            ArrayList<String> vals = sampleData.get(sample);
                            if (vals == null || vals.isEmpty()) {
                                // we have a problem
                                vals = new ArrayList<String>();
                                vals.add("noValue");
                                vals.add("noValue");
                                vals.add(" ");
                            }
                            expr.append("<td style=\"background-color:").append(expLevelToColor(vals.get(0))).append("\">").append(formatExpressionValue(vals.get(0))).append("</td>");
                            cnv.append("<td style=\"background-color:").append(ampDelToColor(vals.get(1))).append("\">&nbsp</td>");
                            if (vals.get(2) != null && vals.get(2).trim().length() > 0) {
                                mutation.append("<td style=\"background-color:#000000; text-decoration:none;\" onmouseover=\"return overlib('");
                                mutation.append(vals.get(2)).append("', CAPTION, '" + gene + " mutation');\" onmouseout=\"return nd();\" name=\"" + gene + "\" mutation=\"" + vals.get(2) + "\">&nbsp;</td>");
                                mutationCursor = "pointer";
                            } else {
                                mutation.append("<td>&nbsp</td>");
                            }
                        }

                        expr.append("</tr>");
                        cnv.append("</tr>");
                        mutation.append("</tr>");
                        mutation.replace(mutation.indexOf("replace_me"), mutation.indexOf("replace_me") + "replace_me".length(), mutationCursor);
                    }

                    table.append(expr);
                    table.append("<tr><td></td><td style=\"text-align:center\" colspan=\"");
                    table.append(samplesList.size()).append("\">Copy Number Variation</td></tr>");
                    table.append(cnv);

                    // don't include thie hide show feature if there are no mutations
                    if (mutation.indexOf("mutation") != -1) {
                        table.append("<tr><td onmouseover=\"return overlib('Click to show / hide all mutation details.',CAPTION, 'Show mutation details');\" onmouseout=\"return nd();\" style=\"font-size:25px; cursor:pointer;\" id=\"showAll\" onclick=\"showAllMutations();\" >+</td>");
                    } else {
                        table.append("<tr><td>&nbsp;</td>");
                    }
                    table.append("<td style=\"text-align:center\" colspan=\"");
                    table.append(samplesList.size()).append("\">Mutations</td></tr>");
                    table.append(mutation);

                    table.append("<tr><td></td><td style=\"text-align:center\" colspan=\"");
                    table.append(samplesList.size()).append("\">Patient Data</td></tr>");

                    table.append(age).append("</tr>");
                    //           table.append(race).append("</tr>");
                    table.append(sex).append("</tr>");
                    //            table.append(variant).append("</tr>");
                    table.append(smoking).append("<td>Current/Former</td></tr>");
                    table.append(treatment).append("</tr>");

                } else {
                    // no mice
                    table.append("<td>No PDX models match the search criteria</td></tr>");
                }

                table.append("</table>");

                request.setAttribute("table", table.toString());
                request.setAttribute("gradient", this.htmlGradient(MIN_RANK_Z, MAX_RANK_Z));
                request.setAttribute("primarySites", primarySites);
                request.setAttribute("diagnoses", diagnoses);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return mapping.findForward(result);
    }

    // hard coded min and max expected values for the rankZ expression
    private static final int MIN_RANK_Z = -15;
    private static final int MAX_RANK_Z = 15;
    private static final int HUE_LIMIT = 150; // 255 is max but beyond 150 it gets hard to tell them apart
    private static final String DELETION = "#0000FF";
    private static final String AMPLIFICATION = "#FFA500";
    private static final String NORMAL = "#808080";
    private static final String NOVALUE = "#FFFFFF";

    private String ampDelToColor(String ampDel) {
        String color = NOVALUE;
        if ("Amplification".equals(ampDel)) {
            color = AMPLIFICATION;
        }
        if ("Deletion".equals(ampDel)) {
            color = DELETION;
        }
        if ("Normal".equals(ampDel)) {
            color = NORMAL;
        }
        return color;
    }

    private String htmlGradient(int min, int max) {

        int realMax = max;
        if (Math.abs(min) > Math.abs(max)) {
            realMax = Math.abs(min);
        }
        int multiplier = HUE_LIMIT / realMax;
        max = realMax;
        min = realMax * -1;

        StringBuffer buf = new StringBuffer();
        buf.append("<table><tr>\n");
        for (int j = min; j <= max; j++) {
            int i = j * multiplier;

            buf.append("<td style=\"text-align:center;color:#FFFFFF;background-color:");

            if (i < 0) {
                buf.append("#00" + Integer.toHexString(255 - (i * -1)) + "00");
                buf.append("\">" + j + "</td>");
            }
            if (i > 0) {
                buf.append("#" + Integer.toHexString(255 - i) + "0000");
                buf.append("\">+" + j + "</td>");
            }
            if (i == 0) {
                buf.append(NORMAL);
                buf.append("\"> 0 </td>");
            }

        }
        buf.append("<td style=\"text-align:center;background-color:#FFFFFF\">No Value</td>\n");
        buf.append("</tr>\n</table>");

        return buf.toString();
    }

    /**
     * Expression levels range from -15 to +15 (min max) but currently hard
     * coded Turn that into a color range from green (lowest) to red with 0 as
     * white.
     *
     * @param min -15
     * @param max 15
     * @param levelStr the level to convert
     * @return Hex color string
     */
    private static String expLevelToColor(String levelStr) {

        String color = NOVALUE;
        try {
            double level = new Double(levelStr).doubleValue();

            int realMax = MAX_RANK_Z;
            if (Math.abs(MIN_RANK_Z) > Math.abs(MAX_RANK_Z)) {
                realMax = Math.abs(MIN_RANK_Z);
            }

            int multiplier = HUE_LIMIT / realMax;

            int adjValue = (int) Math.round(level * multiplier);

            // zero is GREY 
            // zero actually is no value
            //color = NORMAL;

            if (adjValue < 0) {
                color = "#00" + Integer.toHexString(255 - (adjValue * -1)) + "00";
            }
            if (adjValue > 0) {
                color = "#" + Integer.toHexString(255 - adjValue) + "0000";
            }
        } catch (NumberFormatException nfe) {
            // color will be white #FFFFFF
        }

        return color;
    }
    
    private String formatExpressionValue(String in){
        try{
            in = String.format("%.2f", new Double(in));
        }catch(Exception e){
            e.printStackTrace();
        }
        if("0.00".equals(in) || "noValue".equals(in))in ="";
        return in;
    }
}
