/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.jax.mgi.mtb.wi.pdx;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Scanner;
import org.apache.log4j.Logger;
import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;
import org.jax.mgi.mtb.dao.custom.mtb.pdx.PDXDAO;
import org.jax.mgi.mtb.wi.WIConstants;
import org.jax.mgi.mtb.wi.actions.PDXComparisonAction;

/**
 * Parse the PDX Like Me queries, get the results, and convert to HTML or CSV
 *
 * @author sbn
 */
public class PDXLikeMe {

    private static final Logger log
            = Logger.getLogger(PDXLikeMe.class.getName());

    private static final String baseURL = WIConstants.getInstance().getPDXWebservice();
    //static final String baseURL = "http://pdxdata.jax.org/api/";
    private static final String VARIANTS = baseURL + "variants";

    private static final String CNV = baseURL + "cnv_gene";

    private static final String EXP_MIN = baseURL + "expression?keepnulls=yes&gene_symbol=@&min_rankz=";
    private static final String EXP_MAX = baseURL + "expression?keepnulls=yes&gene_symbol=@&max_rankz=";

    //ckb_protein_effect for LOF/GOF/UNK/NONE
    private static final String CKB_EFFECT = VARIANTS + "?ckb_class=b&gene_symbol=";

    private static final String PDX_DETAILS_LINK = "pdxDetails.do?modelID=";

    private static double AMP = 0.5;
    private static double DEL = -0.5;

    public static final String FORMAT_HTML = "HTML";
    public static final String FORMAT_CSV = "CSV";
    public static final String FORMAT_VIS = "VIS";
    public static final String CASE_DELIMITER = "~";
    
    private static final String DELETION = "#0000FF";
    private static final String AMPLIFICATION = "#FFA500";
    private static final String NORMAL = "#808080";
    private static final String NOVALUE = "#FFFFFF";
    
    private static final int MAX_MODELS_FOR_VIS = 150;

    static PDXDAO pdxDAO = PDXDAO.getInstance();

    HashMap<String, ArrayList<String>> allMice = new HashMap<>();
    private static HashMap<String, String> detailsMap = new HashMap<>();
    private static ArrayList<String> ctpGenes = new ArrayList<>();
    private HashMap<String, String> expMap = new HashMap<>();
    private HashMap<String, String> lrpMap = new HashMap<>();

    String format;
    boolean includeActionable = false;

    boolean showLRP = false;
    boolean showEXP = false;

    private int caseCount = 1;

    private DecimalFormat df = new DecimalFormat("###.##");

    public static void main(String[] args) {

        try {
            BufferedReader buf = new BufferedReader(new FileReader("C:/GeneCases.txt"));

            Scanner s = new Scanner(buf);
            s.useDelimiter("\n");
            PDXLikeMe pgc = new PDXLikeMe();
            System.out.println(pgc.parseCases(s, FORMAT_HTML, false, true, true));
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    public PDXLikeMe() {
        this.getModelDetails();
        this.ctpGenes = new PDXMouseStore().getCTPGenes();

    }

    public String parseCases(Scanner s, String format, boolean includeActionable, boolean showLRP, boolean showEXP) {
        
        this.includeActionable = includeActionable;
        this.showLRP = showLRP;
        this.showEXP = showEXP;
        
        this.format = format;

        StringBuilder result = new StringBuilder();

        HashMap<String, ArrayList<String>> caseGenes = new HashMap<>();
        ArrayList<String> caseOrder = new ArrayList<>();
        try {
            String line = s.next();
            String caseNo = "";

            while (line != null) {
                if (line.trim().length() > 0) {
                    if (line.toUpperCase().contains("CASE")) {
                        caseNo = line.trim();
                        caseOrder.add(caseNo);

                        line = s.next();
                        ArrayList<String> list = new ArrayList<>();
                        while (line.trim().length() > 0) {
                            list.add(line);
                            if (s.hasNext()) {
                                line = s.next();
                            } else {
                                break;
                            }
                        }
                        caseGenes.put(caseNo, list);
                    }

                }
                if (s.hasNext()) {
                    line = s.next();
                } else {
                    line = null;
                }

            }

            if (caseNo == "") {
                result.append("ERORR:\nFist line must start with CASE");
                return result.toString();
            }
        } catch (Exception e) {
            //e.printStackTrace();
        }

        getModelDetails();

        StringBuilder caseList = new StringBuilder();
        for (String key : caseOrder) {
            result.append(buildTable(key, caseGenes.get(key)));
            caseList.append(key+",");
            

        }
        if(this.format.equals(FORMAT_VIS)){

            return caseList.toString()+CASE_DELIMITER+result.toString();
        }
        else return result.toString();
                
    }

    private String buildTable(String caseNo, ArrayList<String> genes) {

        ArrayList<String> k = new ArrayList<>();
        ArrayList<String> u = new ArrayList<>();
        String[] vals = null;

        for (String gene : genes) {
            vals = gene.split(":");
            if (vals.length > 2) {
                if (vals[2].trim().equals("K")) {
                    k.add(vals[0].trim() + " " + vals[1].trim());
                } else if (vals[2].trim().equals("U")) {
                    u.add(vals[0] + " " + vals[1]);
                }
            } else if (vals.length == 2) {
                // no explicit K or U so default to Known
                k.add(vals[0].trim() + " " + vals[1].trim());
            } else {
                return caseNo + "\n" + gene + " is in the wrong format";
            }
        }
        //   Collections.sort(u);
        //   Collections.sort(k);

        return mouseMagic(caseNo, k, u);

    }
    
    /*
    Should? create 1 data object and then have 2 front end ways of displaying
    and one function (here) that converts the object to CSV/Excell format
    */

    private String mouseMagic(String caseNo, ArrayList<String> k, ArrayList<String> u) {
        HashMap<String, ModelRow> modelsMap = new HashMap<>();
        StringBuilder table = new StringBuilder();

        ArrayList<String> ku = new ArrayList<>();
        ku.addAll(k);
        ku.addAll(u);

        ArrayList<String> mice = null;
        String[] vals = null;

        for (String gene : ku) {

            vals = gene.split(" ");
            if (vals.length != 2) {
                return "Error\n" + gene + " is not in the correct format.";
            }
            mice = getMice(vals[0], vals[1]);
            if (mice == null) {
                return "Error\n" + vals[0] + ":" + vals[1] + " is not in the correct format.";
            }
            for (String id : mice) {
                if (modelsMap.containsKey(id)) {
                    if (!modelsMap.get(id).genes.contains(vals[0] + vals[1])) {
                        modelsMap.get(id).genes.add(vals[0] + vals[1]);
                    }
                } else {
                    ModelRow mr = new ModelRow(id);
                    mr.genes.add(vals[0] + vals[1]);
                    modelsMap.put(id, mr);
                }
            }

            if (includeActionable) {
                HashMap<String, ArrayList<String>> aMice = getMiceByActionableVariants(vals[0]);
                for (String id : aMice.keySet()) {
                    if (modelsMap.containsKey(id)) {
                        modelsMap.get(id).addActionable(vals[0], aMice.get(id));
                    } else {
                        ModelRow mr = new ModelRow(id);
                        mr.addActionable(vals[0], aMice.get(id));
                        modelsMap.put(id, mr);
                    }
                }
            }

        }

        if (format.equals(FORMAT_HTML)) {
            table.append("<b>").append(caseNo).append("</b><table width=\"100%\" id=\"results").append(caseCount++).append("\" border=\"1\" style=\"border-collapse:collapse\"><thead>");

            if (u.size() > 0) {
                table.append("<tr><th></th><th  style=\"text-align:center;padding:5px\"colspan=\"").append(k.size()).append("\">");
                table.append("Known Significance</th><th  style=\"text-align:center;padding:5px\" colspan=\"").append(u.size()).append("\">Unknown Significance</th></tr>");
            }
            table.append("<tr><th>Model ID</th>");
            for (String kGene : k) {
                table.append("<th style=\"text-align:center;padding:5px\">").append(kGene);
                if (!ctpGenes.contains(kGene.toUpperCase().split(" ")[0])) {
                    table.append("<br>Not in CTP");
                }
                table.append("</th>");

            }
            for (String uGene : u) {
                table.append("<th style=\"text-align:center;padding:5px\">").append(uGene);
                if (!ctpGenes.contains(uGene.toUpperCase().split(" ")[0])) {
                    table.append("<br>Not in CTP");
                }
                table.append("</th>");
            }
            table.append("</thead><tbody>");

        } else {
            // for both csv and vis formatting
            table.append("Case,Model, PDX Diagnosis:Tissue,");
            String thing = "", gene = "";
            for (String kGene : k) {

                gene = kGene.split(" ")[0].toUpperCase();
                thing = kGene.split(" ")[1].toUpperCase();

                table.append(kGene);
                
                if (!ctpGenes.contains(kGene.toUpperCase().split(" ")[0])) {
                    table.append("\nNot in CTP");
                }
                
                table.append(",");

                if (showLRP && (thing.contains("AMP")
                        || thing.contains("DEL")
                        || thing.contains("NOCNV"))) {
                    table.append(gene + " Log ratio ploidy,");
                }
                if (showEXP && (thing.contains(">") || thing.contains("<"))) {
                    table.append(gene + " Z score percentile rank,");
                }

            }
            for (String uGene : u) {
                gene = uGene.split(" ")[0].toUpperCase();
                thing = uGene.split(" ")[1].toUpperCase();

                table.append(uGene);
                
                if (!ctpGenes.contains(uGene.toUpperCase().split(" ")[0])) {
                    table.append("\nNot in CTP");
                }        
                        
                table.append(",");

                if (showLRP && (thing.contains("AMP")
                        || thing.contains("DEL")
                        || thing.contains("NOCNV"))) {
                    table.append(gene + " Log ratio ploidy,");
                }
                if (showEXP && (thing.contains(">") || thing.contains("<"))) {
                    table.append(gene + " Z score percentile rank,");
                }

            }
            table.append("\n");

        }

        ArrayList<ModelRow> modelsList = new ArrayList<>();
       
        for (ModelRow mr : modelsMap.values()) {
            
            // this will kick out dana farber models with no genomcis
            if(detailsMap.containsKey(mr.id)){    
                modelsList.add(mr);
            }
                
        }
        Collections.sort(modelsList, new MRSort());
       
        
        if (format.equals(FORMAT_HTML)) {
            table.append("\n<tr>");
            for (ModelRow mr : modelsList) {
                if (detailsMap.containsKey(mr.id)) {
                    table.append("<td><a href=\"" + PDX_DETAILS_LINK);
                    table.append(mr.id).append("\">").append(mr.id);
                    table.append("</a><br>").append(detailsMap.get(mr.id)).append("</td>");
                    for (String gene : ku) {

                        vals = gene.split(" ");

                        table.append("<td style=\"text-align:center\">");
                        if (mr.genes.contains(vals[0] + vals[1])) {
                            table.append("<b>X</b>");
                        }

                        String key = (mr.id + vals[0] + vals[1]).toUpperCase();
                        if (showLRP) {
                            if (lrpMap.containsKey(key)) {
                                table.append("<br>Log ratio ploidy = " + lrpMap.get(key));
                            }
                        }
                        if (showEXP) {
                            if (expMap.containsKey(key)) {
                                table.append("<br>Z score percentile rank = " + expMap.get(key));
                            }
                        }

                        if (mr.actionable.containsKey(vals[0])) {
                            String s = "";
                            if (mr.actionable.get(vals[0]).size() > 1) {
                                s = "s";
                            }
                            table.append("<br>Clinically relevant " + vals[0] + " variant" + s + "<br>");
                            for (String variant : mr.actionable.get(vals[0]).keySet()) {
                                table.append(variant + "<br> ");
                            }
                        }
                        table.append("</td>");
                    }

                }
                table.append("</tr>\n");

            }
            table.append("</tbody></table><br><br>");

        } else if (format.equals(FORMAT_CSV)) {
            for (ModelRow mr : modelsList) {
                if (detailsMap.containsKey(mr.id)) {
                    table.append(caseNo).append(",");
                    table.append("\"=HYPERLINK(\"\"http://tumor.informatics.jax.org/mtbwi/pdxDetails.do?modelID=");
                    table.append(mr.id).append("\"\",\"\"").append(mr.id).append("\"\")\",");
                    table.append("\"" + detailsMap.get(mr.id)).append("\",");
                    for (String gene : ku) {
                        vals = gene.split(" ");
                        if (mr.genes.contains(vals[0] + vals[1])) {
                            table.append("X ");
                        }

                        if (mr.actionable.containsKey(vals[0])) {
                            String s = " ";
                            if (mr.actionable.get(vals[0]).size() > 1) {
                                s = "s ";
                            }
                            table.append(" Clinically relevant " + vals[0] + " variant" + s);
                            for (String variant : mr.actionable.get(vals[0]).keySet()) {
                                table.append(variant.replace("<br>", " ").replace(",", "") + " ");
                            }
                        }

                        // figure out how to put these in their own columns for sorting etc.
                        String key = (mr.id + vals[0] + vals[1]).toUpperCase();
                        if (showLRP && (vals[1].toUpperCase().contains("AMP")
                                || vals[1].toUpperCase().contains("DEL")
                                || vals[1].toUpperCase().contains("NOCNV"))) {
                            table.append(",");
                            if (lrpMap.containsKey(key)) {
                                table.append(lrpMap.get(key));
                            }

                        }
                        if (showEXP && (vals[1].contains(">")
                                || vals[1].contains("<"))) {
                            table.append(",");
                            if (expMap.containsKey(key)) {
                                table.append(expMap.get(key));
                            }

                        }

                        table.append(",");
                    }

                    table.append("\n");
                }

            }
        } else if (format.equals(FORMAT_VIS)) {
          
           // need to switch axis and show models as columns
           // then convert to HTML ???? really???
           //    y x 
           String[][] box = new String[modelsList.size()+1][ku.size()+2];
           
           // create the headers
           box[0][0] = "model";
           box[0][1] = "diagnosis";
           int geneIndex = 2;
           for(String gene : ku){
            box[0][geneIndex++]=gene.replace(" ", "<br>");
           }
           
            int y = 1;
            
            //put the values into a 2d array
            for (ModelRow mr : modelsList) {
                if (detailsMap.containsKey(mr.id)) {
                    int x = 0;
                   
                    box[y][x++] = mr.id;
                    box[y][x++] = detailsMap.get(mr.id);
                    for (String gene : ku) {
                        vals = gene.split(" ");
                        String key = (mr.id + vals[0] + vals[1]).toUpperCase();
                        if (mr.genes.contains(vals[0] + vals[1])) {
                           
                           String color = NOVALUE;
                           
                           if (vals[1].toUpperCase().contains("AMP")) color = AMPLIFICATION;
                           if (vals[1].toUpperCase().contains("DEL")) color = DELETION;
                           if (vals[1].toUpperCase().contains("NOCNV")) color = NORMAL;

                           if (lrpMap.containsKey(key)) {
                            box[y][x] += "color:"+color+";";
                           }
                        

                           
                           if ((vals[1].contains(">") || vals[1].contains("<"))) {
                               if (expMap.containsKey(key)) {
                                   box[y][x]+="color:" + expToColor(expMap.get(key))+";";
                               }

                           }
                        
                            
                            
                            // brown for all matches that don't correspond to some other color
                            // should have colors for GOF,LOF,UNK,NONE
                            if(box[y][x]==null || box[y][x].trim().length()==0)box[y][x]="color:black;";
                        }
                        
                        
                        if (mr.actionable.containsKey(vals[0])) {
                                String s = " ";
                                if (mr.actionable.get(vals[0]).size() > 1) {
                                    s = "s ";
                                }
                                box[y][x]+=(";Clinically relevant " + vals[0] + " variant" + s);
                                for (String variant : mr.actionable.get(vals[0]).keySet()) {
                                    box[y][x] += " "+ (variant);
                                }
                                // for debuging cells in context of model ids
                                //box[y][x]+="</br>"+mr.id;
                            }

                        x++;
                        
                    }

                    y++;
                }else{
                    System.out.println(mr.id +" not in details map");
                }
              
            }
            

            StringBuilder html = new StringBuilder();
           
             html.append(" <div id=\"tabs-").append(caseCount).append("\"><br>&nbsp;<br>&nbsp;<br><table id=\"comparisonTable").append(caseCount++).append("\" style=\"width:100%\" class=\"cell-border compact\" >");
             html.append("<thead><tr><th style=\"vertical-align:bottom; text-align:center; height:250px; width:15px\">").append(caseNo).append("</th>");

             // limit the resutls so page loads in reasonable time
             
             int columnsToShow = modelsList.size()+1;
             if(columnsToShow > MAX_MODELS_FOR_VIS){
                 columnsToShow = MAX_MODELS_FOR_VIS;
             }
         
            for( y =1; y < columnsToShow;y++){
               
                   String model = box[y][0];
                   String diagnosis = box[y][1];
                   
                   html.append("<th style=\"vertical-align:bottom; text-align:center; height:250px; width:15px; padding: 2px 2px 5px 0px;\">").append("<a href=\"pdxDetails.do?modelID=").append(model);
                        html.append("\"><img src=\"dynamicText?text=").append(diagnosis).append(" (").append(model).append(")&amp;size=12\" alt=\"X\" ");
                        html.append("></a></th>");
                    
            }
            
            html.append("</tr></thead><tbody>");
            for(int x =2; x < ku.size()+2; x++){
                html.append("<tr>");
                for( y =0; y < columnsToShow;y++){
                    StringBuilder  style = new StringBuilder(" text-align:center; ");
                    StringBuilder mouseOver = new StringBuilder();
                    
                    if(box[y][x] == null) box[y][x] = "";
                    String cellText = box[y][x];
                    if(box[y][x].contains("color:") && y>0){
                           
                           style.append(" background-color:").append(box[y][x].substring(box[y][x].indexOf(":")+1,box[y][x].indexOf(";")+1));
                           cellText = "";
                           if(box[y][x].contains("black")){
                                style.append(" color:white;");
                            }
                    }
                          
                    if(box[y][x].contains("Clinically relevant")){
                        style.append(" font-size:8px");
                        String muts = box[y][x].substring(box[y][x].indexOf("Clinically"));
                        mouseOver.append(" onmouseover=\"return overlib('").append(muts).append("',CAPTION,'").append("Clinically relevant mutation(s)").append("')\"");
                        mouseOver.append(" onmouseout=\"return nd()\"");
                        cellText ="X";
                    }else{
                        style.append(" overflow:hidden; font-size:12px");
                    }
                    html.append("<td style=\" padding: 0px 0px 5px 0px; ").append(style).append("\"").append(mouseOver).append(">").append(cellText).append("</td>");
                }
                html.append("</tr>\n");
            }
            html.append("</tbody></table><br><br></div>\n");
           
            table = html;
        }
            
        return table.toString();
    }

    private ArrayList<String> getMice(String gene, String thing) {
        thing = thing.toLowerCase();

        String geneAndThing = gene + thing;

        // if we have done this for another case we are done
        if (allMice.containsKey(geneAndThing)) {

            return allMice.get(geneAndThing);
        }

        if (thing.startsWith("amp")) {
            ArrayList<String> mice = getAmplifiedModels(gene, geneAndThing);
            allMice.put(geneAndThing, mice);
            return mice;
        } else if (thing.startsWith("del")) {
            ArrayList<String> mice = getDeletedModels(gene, geneAndThing);
            allMice.put(geneAndThing, mice);
            return mice;

        } else if (thing.startsWith("nocnv")) {
            ArrayList<String> mice = getNoCNVModels(gene);
            allMice.put(geneAndThing, mice);
            return mice;

        } else if (thing.startsWith("lof")) {
            ArrayList<String> mice = getByProteinEffect(gene, "loss");
            allMice.put(geneAndThing, mice);
            return mice;

        } else if (thing.startsWith("gof")) {
            ArrayList<String> mice = getByProteinEffect(gene, "gain");
            allMice.put(geneAndThing, mice);
            return mice;

        } else if (thing.startsWith("unk")) {
            ArrayList<String> mice = getByProteinEffect(gene, "unknown");
            allMice.put(geneAndThing, mice);
            return mice;

        } else if (thing.startsWith("none")) {
            ArrayList<String> mice = getByProteinEffect(gene, "no effect");
            allMice.put(geneAndThing, mice);
            return mice;

        } else if (thing.trim().startsWith("mut")) {
            thing = thing.replace("mut", "").replace("=", "");
            ArrayList<String> mice = getMiceByGeneVariant(gene, thing);
            allMice.put(geneAndThing, mice);
            return mice;
        } else if (thing.trim().startsWith("exp")) {
            if (thing.contains("<")) {
                thing = thing.substring(4);
                String url = EXP_MAX.replace("@", gene) + thing;
                ArrayList<String> mice = getExpressionModels(url, geneAndThing);
                allMice.put(geneAndThing, mice);
                return mice;
            } else if (thing.contains(">")) {
                thing = thing.substring(4);
                String url = EXP_MIN.replace("@", gene) + thing;
                ArrayList<String> mice = getExpressionModels(url, geneAndThing);
                allMice.put(geneAndThing, mice);
                return mice;
            }

        }
        // there is a syntax problem
        return null;

    }

    private HashMap<String, ArrayList<String>> getMiceByActionableVariants(String gene) {

        HashMap<String, ArrayList<String>> actionable = new HashMap<>();
        // look for any actionable variant

        StringBuilder params = new StringBuilder();

        params.append("?ckb_class=B&gene_symbol=").append(gene);

        try {

            JSONObject job = new JSONObject(getJSON(VARIANTS + params.toString(), ""));

            JSONArray jarray = job.getJSONArray("data");
            for (int i = 0; i < jarray.length(); i++) {
                job = jarray.getJSONObject(i);

                String id = job.getString("model_name");
                String variant = job.getString("amino_acid_change");
                try {
                    variant = variant + "<br>Effect: " + job.getString("ckb_protein_effect");
                } catch (Exception e) {
                }

                try {
                    variant = variant + "<br>Treatment Approach: " + job.getString("ckb_potential_treat_approach");//.replaceAll(",", ", "); this has funky layout effects
                } catch (Exception e) {
                }

                if (actionable.containsKey(id)) {
                    actionable.get(id).add(variant);
                } else {
                    ArrayList<String> variants = new ArrayList<>();
                    variants.add(variant);
                    actionable.put(id, variants);
                }

            }
        } catch (Exception e) {
            log.error(e);
        }
        return actionable;
    }

    private ArrayList<String> getMiceByGeneVariant(String gene, String variant) {

        HashMap<String, String> ids = new HashMap<>();
        StringBuilder params = new StringBuilder();

        params.append("?&gene_symbol=").append(gene);

        if (variant != null && !variant.isEmpty()) {
            params.append("&amino_acid_change=").append(variant);
        }

        try {

            JSONObject job = new JSONObject(getJSON(VARIANTS + params.toString(), ""));

            JSONArray jarray = (JSONArray) job.get("data");
            for (int i = 0; i < jarray.length(); i++) {
                String id = jarray.getJSONObject(i).getString("model_name");
                ids.put(id, id);
            }

        } catch (JSONException e) {

        }

        ArrayList<String> idList = new ArrayList<>();
        for (String key : ids.keySet()) {
            idList.add(key);
        }
        Collections.sort(idList);
        return idList;
    }

    private ArrayList<String> getAmplifiedModels(String gene, String geneAndThing) {

        ArrayList<String> mice = new ArrayList<>();
        StringBuilder params = new StringBuilder();
        params.append("?min_lr_ploidy=" + AMP + "&gene_symbol=").append(gene);
        try {

            JSONObject job = new JSONObject(getJSON(CNV + params.toString(), ""));
            JSONArray jarray = job.getJSONArray("data");
            for (int i = 0; i < jarray.length(); i++) {
                job = jarray.getJSONObject(i);
                String lrp = df.format(job.getDouble("logratio_ploidy"));
                String id = job.getString("model_name");

                mice.add(id);
                String key = (id + geneAndThing).toUpperCase();
                lrpMap.put(key, lrp);
            }
        } catch (Exception e) {
            log.error(e);
        }
        return mice;
    }

    private ArrayList<String> getDeletedModels(String gene, String geneAndThing) {

        ArrayList<String> mice = new ArrayList<>();
        StringBuilder params = new StringBuilder();
        params.append("?max_lr_ploidy=" + DEL + "&gene_symbol=").append(gene);

        try {

            JSONObject job = new JSONObject(getJSON(CNV + params.toString(), ""));
            JSONArray jarray = job.getJSONArray("data");
            for (int i = 0; i < jarray.length(); i++) {
                job = jarray.getJSONObject(i);
                String lrp = df.format(job.getDouble("logratio_ploidy"));
                String id = job.getString("model_name");

                mice.add(id);
                String key = (id + geneAndThing).toUpperCase();
                lrpMap.put(key, lrp);

            }
        } catch (Exception e) {
            log.error(e);
        }
        return mice;

    }

    // models where LRP is "normal" less than AMP and more that DEL
    private ArrayList<String> getNoCNVModels(String gene) {

        ArrayList<String> mice = new ArrayList<>();

        StringBuilder params = new StringBuilder();
        params.append("?max_lr_ploidy=" + AMP + "&gene_symbol=").append(gene);

        try {

            JSONObject job = new JSONObject(getJSON(CNV + params.toString(), ""));
            JSONArray jarray = job.getJSONArray("data");
            for (int i = 0; i < jarray.length(); i++) {

                job = jarray.getJSONObject(i);
                Double lrp = job.getDouble("logratio_ploidy");
                String id = job.getString("model_name");
                if (lrp > DEL) {
                    mice.add(id);

                }
                String key = (id + gene + "NOCNV").toUpperCase();
                lrpMap.put(key, df.format(lrp));

            }
        } catch (Exception e) {
            log.error(e);
        }

        return mice;

    }

    private ArrayList<String> getExpressionModels(String url, String geneAndThing) {

        ArrayList<String> mice = new ArrayList<>();
        JSONObject job = null;
        try {

            job = new JSONObject(getJSON(url, ""));
            JSONArray jarray = job.getJSONArray("data");
            for (int i = 0; i < jarray.length(); i++) {
                job = jarray.getJSONObject(i);
                String zpr = df.format(job.getDouble("z_score_percentile_rank"));
                String id = job.getString("model_name");

                mice.add(id);

                String key = (id + geneAndThing).toUpperCase();
                expMap.put(key, zpr);
            }
        } catch (Exception e) {
            log.error(job, e);
        }
        return mice;

    }

    private ArrayList<String> getByProteinEffect(String gene, String effectWord) {

        ArrayList<String> mice = new ArrayList<>();
        JSONObject job = null;
        String effect = null;
        try {

            job = new JSONObject(getJSON(CKB_EFFECT + gene, ""));
            JSONArray jarray = job.getJSONArray("data");
            for (int i = 0; i < jarray.length(); i++) {
                job = jarray.getJSONObject(i);
                effect = null;
                if (job.has("ckb_protein_effect")) {
                    effect = job.getString("ckb_protein_effect");
                    String id = job.getString("model_name");

                    if (effect != null && effect.toLowerCase().contains(effectWord)) {
                        mice.add(id);
                    }
                }

            }
        } catch (Exception e) {
            log.error(job, e);
        }
        return mice;

    }

    private void getModelDetails() {
        if (detailsMap == null || detailsMap.size() == 0) {
            try {
                JSONObject job = new JSONObject(getJSON("http://tumor.informatics.jax.org/PDXInfo/JSONData.do?allModels=gimme", null));
                JSONArray models = job.getJSONArray("pdxInfo");
                for (int i = 0; i < models.length(); i++) {
                    String id = models.getJSONObject(i).getString("Model ID");
                    String site = models.getJSONObject(i).getString("Primary Site");
                    String iDiag = models.getJSONObject(i).getString("Initial Diagnosis");
                    String cDiag = models.getJSONObject(i).getString("Clinical Diagnosis");
                    if (cDiag.trim().length() == 0) {
                        cDiag = iDiag;
                    }
                    String firstLetter = cDiag.charAt(0)+"";
                    firstLetter = firstLetter.toUpperCase();
                    cDiag = firstLetter+cDiag.substring(1);
                    
                    detailsMap.put(id, cDiag + ":" + site);

                }
            } catch (Exception e) {
                log.error("Error getting pdx like me model details", e);
            }
        }
    }
    
    private String expToColor(String exp){
        String color = "purple";
        try{
            Float ex = new Float(exp);
            
            
             color = "#007300";
            if(ex > - 2)        
             color = "#009b00";
            if(ex > - .5)           
             color = "#00d700";
            if(ex > - .01)           
             color = "#00f500";     
            if(ex > -.01 && ex < .01)				
		color = "#808080";
            if(ex > .01)           
		color = "#f50000";
            if(ex > .5)				   
                color = "#d70000";
            if(ex > 2)           
                color =  "#9b0000";
            if(ex > 10)          
                color = "#730000";
        }catch(Exception e){
            e.printStackTrace();
        }
        
        System.out.println(exp+" "+color);
             return color;   
            
    }

   

    private String getJSON(String uri, String json) {

        // use filtering to exclude PT samples
        String filterStr = "filter=yes";

        if (uri.contains("?")) {
            uri = uri + "&" + filterStr;
        } else {
            uri = uri + "?" + filterStr;
        }

        boolean post = true;
        if (json == null || json.length() == 0) {
            post = false;
        }

        String responseSingle = "";
        StringBuffer response = new StringBuffer();

        HttpURLConnection connection = null;
        try {
            URL url = new URL(uri);
            connection
                    = (HttpURLConnection) url.openConnection();
            if (post) {
                connection.setRequestMethod("POST");
                connection.setDoOutput(true); // sending stuff
            } else {
                connection.setRequestMethod("GET");
            }

            connection.setRequestProperty("Content-Type", "application/json");
            connection.setRequestProperty("Accept", "application/json");

            connection.setDoInput(true); //we want a response
            connection.setUseCaches(false);

            if (post) {
                OutputStream out = connection.getOutputStream();
                try {

                    OutputStreamWriter wr = new OutputStreamWriter(out);
                    wr.write(json.toString());
                    wr.flush();
                    wr.close();
                } catch (IOException e) {
                    log.error(e);

                } finally {
                    if (out != null) {
                        out.close();
                    }
                }
            }

            // Open a stream which can read the server response
            InputStream in = connection.getInputStream();
            try {
                BufferedReader rd = new BufferedReader(new InputStreamReader(in));
                while ((responseSingle = rd.readLine()) != null) {
                    response.append(responseSingle);
                }
                rd.close(); //close the reader

            } catch (IOException e) {

                log.error(e);

            } finally {
                if (in != null) {
                    in.close();
                }
            }
        } catch (IOException e) {
            log.error(e);
        } finally {
            if (connection != null) {
                connection.disconnect();
            }
        }

        return response.toString();


}

    private class ModelRow {

    // "gene" is "gene" "criteria"
    String id;
    ArrayList<String> genes = new ArrayList<>();
    // gene -> list of actionable variants
    private HashMap<String, HashMap<String, String>> actionable = new HashMap<>();

    ModelRow(String id) {
        this.id = id;
    }

    public void addActionable(String gene, ArrayList<String> variants) {
        if (actionable.containsKey(gene)) {
            for (String v : variants) {
                actionable.get(gene).put(v, v);
            }
        } else {
            HashMap<String, String> vars = new HashMap<>();
            for (String v : variants) {
                vars.put(v, v);
            }
            actionable.put(gene, vars);
        }
    }

    public int getSize() {
        return (2 * this.genes.size()) + this.actionable.size();
    }
    
}
    
    

class MRSort implements Comparator<ModelRow> {

    public int compare(ModelRow a, ModelRow b) {

        if (a.getSize() > b.getSize()) {
            return -1;
        }
        if (a.getSize() < b.getSize()) {
            return 1;
        }
        return a.id.compareTo(b.id);
    }
}


}
