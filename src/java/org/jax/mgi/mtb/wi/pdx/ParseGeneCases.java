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
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Scanner;
import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;
import org.jax.mgi.mtb.dao.custom.mtb.pdx.PDXDAO;
import org.jax.mgi.mtb.dao.custom.mtb.pdx.PDXMouse;
import org.jax.mgi.mtb.wi.WIConstants;

/**
 *
 * @author sbn
 */
public class ParseGeneCases {

    //private  String baseURL = WIConstants.getInstance().getPDXWebservice();

     static final String baseURL = "http://pdxdata.jax.org:335/api/";
    private static final String VARIANTS = baseURL + "variants";

    private static final String CNV = baseURL + "cnv_gene";

    private static double AMP = 0.5;
    private static double DEL = -0.5;

    static PDXDAO pdxDAO = PDXDAO.getInstance();

    HashMap<String, ArrayList<String>> allMice = new HashMap();
    private static HashMap<String, String> detailsMap = new HashMap();

    boolean html = true;
    boolean includeActionable = false;

    public static void main(String[] args) {

        try {
            BufferedReader buf = new BufferedReader(new FileReader("C:/GeneCases.txt"));

            Scanner s = new Scanner(buf);
            s.useDelimiter("\n");
            ParseGeneCases pgc = new ParseGeneCases();
            System.out.println(pgc.parseCases(s, true, false));
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    public String parseCases(Scanner s, boolean asHTML, boolean includeActionable) {
        this.html = asHTML;
        this.includeActionable = includeActionable;
        
        StringBuilder result = new StringBuilder();

        HashMap<String, ArrayList<String>> caseGenes = new HashMap();
        ArrayList<String> caseOrder = new ArrayList();
        try {
            String line = s.next();
            String caseNo = "";

            while (line != null) {
                if (line.trim().length() > 0) {
                    if (line.contains("CASE")) {
                        caseNo = line.trim();
                        caseOrder.add(caseNo);
                        line = s.next();
                        ArrayList<String> list = new ArrayList();
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

            if(caseNo==""){
                result.append("ERORR:\nFist line must start with CASE");
            }
        } catch (Exception e) {
            //e.printStackTrace();
        }
        

        

        getModelDetails();

        for (String key : caseOrder) {
            result.append(buildTable(key, caseGenes.get(key)));

        }

        return result.toString();
    }

    private String buildTable(String caseNo, ArrayList<String> genes) {

        
        ArrayList<String> k = new ArrayList();
        ArrayList<String> u = new ArrayList();
        String[] vals = null;

        for (String gene : genes) {
            vals = gene.split(":");
            if (vals.length > 2) {
                if (vals[2].trim().equals("K")) {
                    k.add(vals[0].trim() + " " + vals[1].trim());
                } else if (vals[2].trim().equals("U")) {
                    u.add(vals[0] + " " + vals[1]);
                }
            }else if(vals.length == 2) {
                // no explicit K or U so default to Known
                k.add(vals[0].trim() + " " + vals[1].trim());
            }else{
                return caseNo+"\n"+gene+" is in the wrong format";
            }
        }
        Collections.sort(u);
        Collections.sort(k);

        return mouseMagic(caseNo, k, u);

    }

    private String mouseMagic(String caseNo, ArrayList<String> k, ArrayList<String> u) {
        HashMap<String, ModelRow> modelsMap = new HashMap();
        StringBuilder table = new StringBuilder();

        ArrayList<String> uk = new ArrayList();
        uk.addAll(u);
        uk.addAll(k);

        ArrayList<String> mice = null;
        String[] vals = null;

        if (html) {
            table.append("<b>").append(caseNo).append("</b><table border=\"1\" style=\"border-collapse:collapse\">");

            if (u.size() > 0) {
                table.append("<tr><th></th><th  style=\"text-align:center;padding:5px\"colspan=\"").append(k.size()).append("\">");
                table.append("Known Significance</th><th  style=\"text-align:center;padding:5px\" colspan=\"").append(u.size()).append("\">Unknown Significance</th></tr>");
            }
            table.append("<tr><td>Model ID</td>");
            for (String kGenes : k) {
                table.append("<td style=\"text-align:center;padding:5px\">").append(kGenes).append("</td>");
            }
            for (String uGenes : u) {
                table.append("<td style=\"text-align:center;padding:5px\">").append(uGenes).append("</td>");
            }
            // now the magic

        } else {

            table.append("Case,Model, PDX Diagnosis:Tissue,");
            for (String kGenes : k) {
                table.append(kGenes).append(",");
            }
            for (String uGenes : u) {
                table.append(uGenes).append(",");
            }
            table.append("\n");

        }

        for (String gene : uk) {

            vals = gene.split(" ");
            if(vals.length!=2){
                return "Error\n"+vals+" is not correctly formatted.";
            }
            mice = getMice(vals[0], vals[1]);
            if(mice == null){
                return "Error\n"+vals[0]+":"+vals[1]+" is not in the correct format.";
            }
            for (String id : mice) {
                if (modelsMap.containsKey(id)) {
                    modelsMap.get(id).genes.add(vals[0] + vals[1]);
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

        ArrayList<ModelRow> modelsList = new ArrayList();
        for (ModelRow mr : modelsMap.values()) {
            modelsList.add(mr);
        }
        Collections.sort(modelsList, new MRSort());

        if (html) {
            table.append("\n<tr>");
            for (ModelRow mr : modelsList) {
                if (detailsMap.containsKey(mr.id)) {
                    table.append("<td><a href=\"http://tumor.informatics.jax.org/mtbwi/pdxDetails.do?modelID=");
                    table.append(mr.id).append("\">").append(mr.id);
                    table.append("</a><br>").append(detailsMap.get(mr.id)).append("</td>");
                    for (String gene : k) {

                        vals = gene.split(" ");

                        table.append("<td style=\"text-align:center\">");
                        if (mr.genes.contains(vals[0] + vals[1])) {
                            table.append("<b>X</b>");
                        }
                        if (mr.actionable.containsKey(vals[0])) {
                            String s = "";
                            if(mr.actionable.get(vals[0]).size()>1){
                                s = "s";
                            }
                            table.append("<br>Clinically relevant " + vals[0] + " variant"+s+"<br>");
                            for (String variant : mr.actionable.get(vals[0]).keySet()) {
                                table.append(variant + " ");
                            }
                        }
                        table.append("</td>");
                    }
                    for (String gene : u) {
                        vals = gene.split(" ");
                        table.append("<td style=\"text-align:center\">");
                        if (mr.genes.contains(vals[0] + vals[1])) {
                            table.append("<b>X</b>");
                        }
                        if (mr.actionable.containsKey(vals[0])) {
                            table.append("<br>Actionable " + vals[0] + " variants<br>");

                            for (String variant : mr.actionable.get(vals[0]).keySet()) {
                                table.append(variant + " ");
                            }
                        }

                        table.append("</td>");

                    }
                }
                table.append("</tr>\n");

            }
            table.append("</table><br><br>");
        } else {
            for (ModelRow mr : modelsList) {
                if (detailsMap.containsKey(mr.id)) {
                    table.append(caseNo).append(",");
                    table.append("\"=HYPERLINK(\"\"http://tumor.informatics.jax.org/mtbwi/pdxDetails.do?modelID=");
                    table.append(mr.id).append("\"\",\"\"").append(mr.id).append("\"\")\",");
                    table.append(detailsMap.get(mr.id)).append(",");
                    for (String gene : k) {
                        vals = gene.split(" ");
                        if (mr.genes.contains(vals[0] + vals[1])) {
                            table.append("X ");
                        }
                        if (mr.actionable.containsKey(vals[0])) {
                            table.append("Actionable " + vals[0] + " variants ");
                            for (String variant : mr.actionable.get(vals[0]).keySet()) {
                                table.append(variant + " ");
                            }
                        }
                        table.append(",");
                    }
                    for (String gene : u) {
                        vals = gene.split(" ");
                        if (mr.genes.contains(vals[0] + vals[1])) {
                            table.append("X ");
                        }
                        if (mr.actionable.containsKey(vals[0])) {
                            table.append("Actionable " + vals[0] + " variants ");
                            for (String variant : mr.actionable.get(vals[0]).keySet()) {
                                table.append(variant + " ");
                            }
                        }
                        table.append(",");

                    }
                    table.append("\n");
                }

            }
        }
        return table.toString();
    }

    private ArrayList<String> getMice(String gene, String thing) {
        thing = thing.toLowerCase();
        
        // if we have done this for another case we are done
        if (allMice.containsKey(gene + thing)) {
            System.out.println("Pow " + gene + " " + thing);
            return allMice.get(gene + thing);
        }

        if (thing.startsWith("amp")) {
            ArrayList<String> mice = getAmplifiedModels(gene);
            allMice.put(gene + thing, mice);
            return mice;
        } else if (thing.startsWith("del")) {
            ArrayList<String> mice = getDeletedModels(gene);
            allMice.put(gene + thing, mice);
            return mice;
        } else if (thing.trim().startsWith("mut")) {

            thing = thing.replace("mut", "").replace("=", "");
            long start = System.currentTimeMillis();
            ArrayList<String> mice = getMiceByGeneVariant(gene, thing);
            System.out.println("Finding mice for " + gene + " " + thing + " took " + (System.currentTimeMillis() - start) / 1000);
            allMice.put(gene + thing, mice);
            return mice;
        } else {
            // there is a syntax problem
            return null;
        }

    }

    private HashMap<String, ArrayList<String>> getMiceByActionableVariants(String gene) {

        HashMap<String, ArrayList<String>> actionable = new HashMap();
        // look for any actionable variant

        StringBuilder params = new StringBuilder();

        params.append("?ckb_class=B&gene_symbol=").append(gene);

        try {

            JSONObject job = new JSONObject(getJSON(VARIANTS + params.toString(), ""));

            JSONArray jarray =  job.getJSONArray("data");
            for (int i = 0; i < jarray.length(); i++) {
                job = jarray.getJSONObject(i);
               
                String id = job.getString("model_name");
                String variant = job.getString("amino_acid_change");
                if (actionable.containsKey(id)) {
                    actionable.get(id).add(variant);
                } else {
                    ArrayList<String> variants = new ArrayList();
                    variants.add(variant);
                    actionable.put(id, variants);
                }

            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return actionable;
    }

    private ArrayList<String> getMiceByGeneVariant(String gene, String variant) {

        HashMap<String, String> ids = new HashMap();
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

        ArrayList<String> idList = new ArrayList();
        for (String key : ids.keySet()) {
            idList.add(key);
        }
        Collections.sort(idList);
        return idList;
    }

    private ArrayList<String> getAmplifiedModels(String gene) {

        ArrayList<String> mice = new ArrayList<>();
        StringBuilder params = new StringBuilder();
        params.append("?min_lr_ploidy="+AMP+"&gene_symbol=").append(gene);
        try {

            JSONObject job = new JSONObject(getJSON(CNV + params.toString(), ""));
            JSONArray jarray = job.getJSONArray("data");
            for (int i = 0; i < jarray.length(); i++) {
                job = jarray.getJSONObject(i);
                Double lrp = job.getDouble("logratio_ploidy");
                String id = job.getString("model_name");
                
                    mice.add(id);
                    System.out.println("AMP "+id+ " has lrp = "+lrp);
               
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return mice;
    }
    
    private ArrayList<String> getDeletedModels(String gene) {

        ArrayList<String> mice = new ArrayList<>();
        StringBuilder params = new StringBuilder();
        params.append("?max_lr_ploidy="+DEL+"&gene_symbol=").append(gene);
        
        try {

            JSONObject job = new JSONObject(getJSON(CNV + params.toString(), ""));
            JSONArray jarray = job.getJSONArray("data");
            for (int i = 0; i < jarray.length(); i++) {
                job = jarray.getJSONObject(i);
                Double lrp = job.getDouble("logratio_ploidy");
                String id = job.getString("model_name");
                
                
                    mice.add(id);
                    System.out.println("DEL "+id+ " has lrp = "+lrp);
                
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return mice;
    }

    private void getModelDetails() {
        if(detailsMap == null || detailsMap.size()==0){
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
                detailsMap.put(id, cDiag + ":" + site);

            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        }
    }

    private String getJSON(String uri, String json) {

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
                    e.printStackTrace();

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

                e.printStackTrace();

            } finally {
                if (in != null) {
                    in.close();
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (connection != null) {
                connection.disconnect();
            }
        }

        return response.toString();

    }

    private class ModelRow {

        String id;
        ArrayList<String> genes = new ArrayList();
        // gene -> list of actionable variants
        private HashMap<String, HashMap<String, String>> actionable = new HashMap();

        ModelRow(String id) {
            this.id = id;
        }

        public void addActionable(String gene, ArrayList<String> variants) {
            if (actionable.containsKey(gene)) {
                for (String v : variants) {
                    actionable.get(gene).put(v, v);
                }
            } else {
                HashMap<String, String> vars = new HashMap();
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
