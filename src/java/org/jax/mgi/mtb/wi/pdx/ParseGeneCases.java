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

/**
 *
 * @author sbn
 */
public class ParseGeneCases {

    private static String baseURI = "http://bhpdx01:8080/pdxqueryservices/REST";

    private static String variationURI = baseURI + "/pdx-variation/";

    private static final String allVariants = "all-variants.json";
    
    static PDXDAO pdxDAO = PDXDAO.getInstance();
    

    HashMap<String, ArrayList<String>> allMice = new HashMap();
    HashMap<String,String>  detailsMap = new HashMap();
    
    boolean html = true;

    public static void main(String[] args) {

            try{
            BufferedReader buf = new BufferedReader(new FileReader("C:/GeneCases.txt"));
            
            Scanner s = new Scanner(buf);
            s.useDelimiter("\n");
             ParseGeneCases pgc = new ParseGeneCases();
             System.out.println(pgc.parseCases(s,true));
            }catch(Exception e){
                e.printStackTrace();
            }

    }
    
    public String parseCases(Scanner s, boolean asHTML){
        this.html = asHTML;

        HashMap<String, ArrayList<String>> caseGenes = new HashMap();
        ArrayList<String> caseOrder = new ArrayList();
        try {
            String line = s.next();
            String caseNo = "";

            while (line != null) {
                if (line.trim().length() > 0) {
                    if (line.contains("CASE")) {
                        caseNo = line;
                        caseOrder.add(caseNo);
                        line = s.next();
                        ArrayList<String> list = new ArrayList();
                        while (line.trim().length() > 0) {
                            list.add(line);
                            if(s.hasNext()){
                                line = s.next();
                            }else{
                                break;
                            }
                        }
                        caseGenes.put(caseNo, list);
                    }

                }
                if(s.hasNext()){
                    line = s.next();
                }else{
                    line = null;
                }

            }

        } catch (Exception e) {
            //e.printStackTrace();
        }

       
        StringBuilder result = new StringBuilder();

        getModelDetails();

        int count =0;
        for (String key : caseOrder) {
            result.append(buildTable(key, caseGenes.get(key)));
            count++;
            if(count>5)break;
        }

       return result.toString();
    }

    



    private String buildTable(String caseNo, ArrayList<String> genes) {
        
        ArrayList<String> k = new ArrayList();
        ArrayList<String> u = new ArrayList();
        String[] vals = null;

        for (String gene : genes) {
            vals = gene.split(",");
            if(vals.length>2){
                if (vals[2].trim().equals("K")) {
                    k.add(vals[0].trim() + " " + vals[1].trim());
                } else if (vals[2].trim().equals("U")) {
                    u.add(vals[0] + " " + vals[1]);
                }else{
                    System.out.println(gene+" has incorrect format");
                } 
            }else{
                // no explicit K or U so default to Known
                k.add(vals[0].trim() + " " + vals[1].trim());
            }
        }
        Collections.sort(u);
        Collections.sort(k);
       
       return mouseMagic(caseNo, k, u);
            
        
       
    }

    private String mouseMagic(String caseNo,ArrayList<String> k, ArrayList<String> u) {
        HashMap<String, ModelRow> modelsMap = new HashMap();
        StringBuilder table = new StringBuilder();
        

        ArrayList<String> mice = null;
        String[] vals = null;


         /// all this should ge moved to MM
        if(html){
            table.append("<b>").append(caseNo).append( "</b><table border=\"1\" style=\"border-collapse:collapse\"><th></th><th colspan=\"");
            table.append(k.size()).append("\">Known Significance</th><th colspan=\"").append(u.size()).append("\">Unknown Significance</th><tr>");
            table.append("<td>Model ID</td>");
            for (String kGenes : k) {
                table.append("<td>").append(kGenes).append( "</td>");
            }
            for (String uGenes : u) {
                table.append("<td>").append(uGenes).append("</td>");
            }
            // now the magic
         
         
        }else{
            table.append(caseNo);
            table.append("\nModel Link, Model,");
            for (String kGenes : k) {
                table.append(kGenes).append(",");
            }
            for (String uGenes : u) {
                table.append(uGenes).append(",");
            }
            table.append("\n");
            // now the magic
         }


        for (String gene : k) {

            vals = gene.split(" ");
            mice = getMice(vals[0], vals[1]);
            for (String id : mice) {
                if (modelsMap.containsKey(id)) {
                    modelsMap.get(id).genes.add(vals[0] + vals[1]);
                } else {
                    ModelRow mr = new ModelRow(id);
                    mr.genes.add(vals[0] + vals[1]);
                    modelsMap.put(id, mr);
                }
            }

        }
        for (String gene : u) {

            vals = gene.split(" ");
            mice = getMice(vals[0], vals[1]);
            for (String id : mice) {
                if (modelsMap.containsKey(id)) {
                    modelsMap.get(id).genes.add(vals[0] + vals[1]);
                } else {
                    ModelRow mr = new ModelRow(id);
                    mr.genes.add(vals[0] + vals[1]);
                    modelsMap.put(id, mr);
                }
            }

        }
        ArrayList<ModelRow> modelsList = new ArrayList();
        for (ModelRow mr : modelsMap.values()) {
            modelsList.add(mr);
        }
        Collections.sort(modelsList, new MRSort());
       
        if(html){
            table.append("\n<tr>");
            for (ModelRow mr : modelsList) {
                table.append("<td><a href=\"http://tumor.informatics.jax.org/mtbwi/pdxDetails.do?modelID=");
                table.append(mr.id).append("\">").append(mr.id);
                table.append("</a><br>").append(detailsMap.get(mr.id)).append("</td>");
                for (String gene : k) {

                    vals = gene.split(" ");

                    table.append("<td style=\"text-align:center\">");
                    if (mr.genes.contains(vals[0] + vals[1])) {
                        table.append("<b>X</b>");
                    }
                    table.append("</td>");
                }
                for (String gene : u) {
                    vals = gene.split(" ");
                    table.append("<td style=\"text-align:center\">");
                    if (mr.genes.contains(vals[0] + vals[1])) {
                        table.append("<b>X</b>");
                    }
                    table.append("</td>");

                }
                table.append("</tr>\n");
               
            }
             table.append("</table><br><br>");
        }else{
            for (ModelRow mr : modelsList) {
                table.append("=HYPERLINK(\"http://tumor.informatics.jax.org/mtbwi/pdxDetails.do?modelID=");
                table.append(mr.id).append("\"),").append(mr.id);
                table.append(" ").append(detailsMap.get(mr.id)).append(",");
                for (String gene : k) {
                    vals = gene.split(" ");
                    if (mr.genes.contains(vals[0] + vals[1])) {
                        table.append("X");
                    }
                    table.append(",");
                }
                for (String gene : u) {
                    vals = gene.split(" ");
                    if (mr.genes.contains(vals[0] + vals[1])) {
                        table.append("X");
                    }
                    table.append(",");

                }
                table.append("\n");
            
            
            }
        }
        return table.toString();
    }
        

    private ArrayList<String> getMice(String gene, String thing) {
        if (allMice.containsKey(gene + thing)) {
            System.out.println("Pow " + gene + " " + thing);
            return allMice.get(gene + thing);
        }
        if (thing.equals("Amplified")) {
            ArrayList<String> mice = pdxDAO.getModelsByGeneAmp(gene);
            allMice.put(gene + thing, mice);
            return mice;
        } else if (thing.equals("Deleted")) {
            ArrayList<String> mice = pdxDAO.getModelsByGeneDel(gene);
            allMice.put(gene + thing, mice);
            return mice;
        } else {
            long start = System.currentTimeMillis();
            ArrayList<String> mice = getMiceByGeneVariant(gene, thing);
            System.out.println("Finding mice for " + gene + " " + thing + " took " + (System.currentTimeMillis() - start) / 1000);
            allMice.put(gene + thing, mice);
            return mice;
        }

    }

    private ArrayList<String> getMiceByGeneVariant(String gene, String variant) {

        HashMap<String, String> ids = new HashMap();
        StringBuilder params = new StringBuilder();
        params.append("{\"gene_symbol\":[\"").append(gene);
        params.append("\"],\"amino_acid_change\":[\"").append(variant);
        String filter = "FALSE";
        params.append("\"],\"skip\": \"0\", \"limit\": \"-1\", \"sort_by\": \"consequence\", \"sort_dir\": \"DESC\", \"filter\": \"");
        params.append(filter).append("\"}");

        // need to turn the json in to a map key of model id
        // values variants, consequences
        try {
            JSONObject job = new JSONObject("{\"data\":" + getJSON(variationURI + allVariants, params.toString()) + "}");

            JSONArray jarray = ((JSONObject) job.get("data")).getJSONArray("data");
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

    private void getModelDetails() {
        try {
            JSONObject job = new JSONObject(getJSON("http://tumor.informatics.jax.org/PDXInfo/JSONData.do?allModels=gimme", null));
            JSONArray models = job.getJSONArray("pdxInfo");
            for (int i = 0; i < models.length(); i++) {
                String id = models.getJSONObject(i).getString("Model ID");
                String site = models.getJSONObject(i).getString("Primary Site");
                String iDiag = models.getJSONObject(i).getString("Initial Diagnosis");
                String cDiag = models.getJSONObject(i).getString("Clinical Diagnosis");
                if(cDiag.trim().length()==0){
                    cDiag = iDiag;
                }
                detailsMap.put(id,cDiag+":"+site);

            }
        }catch(Exception e){
                   e.printStackTrace();
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

        ModelRow(String id) {
            this.id = id;
        }
    }

    class MRSort implements Comparator<ModelRow> {

        public int compare(ModelRow a, ModelRow b) {

            if (a.genes.size() > b.genes.size()) {
                return -1;
            }
            if (a.genes.size() < b.genes.size()) {
                return 1;
            }
            return a.id.compareTo(b.id);
        }
    }
}
