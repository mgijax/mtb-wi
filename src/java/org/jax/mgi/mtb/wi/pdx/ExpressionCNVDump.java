/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.jax.mgi.mtb.wi.pdx;


import java.io.BufferedReader;
import java.io.FileWriter;
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
import java.util.HashMap;
import org.apache.log4j.Logger;
import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;
import org.jax.mgi.mtb.dao.custom.mtb.MTBSynchronizationUtilDAO;
import org.jax.mgi.mtb.dao.custom.mtb.pdx.PDXMouse;

/**
 * For all public mice load all cnv data, then calculate if amp or del based on model pt sex, gene and cn value
 * Attach to matching gene/sample expression data and output in a LOAD DATA friendly manner.
 * For now if cnv data comes from a sample/gene with no expression data it is ignored.
 * Gets expression values for genes in the exome panel for all samples. 
 * Data is loaded into MTB pdxexpresssion table
 * the output format is for a MYSQL LOAD DATA INFILE command
 * LOAD DATA <LOCAL> INFILE 'C:/pdxInserts2.txt' into table mtb.pdxexpression FIELDS TERMINATED BY ',' ENCLOSED BY '`' LINES STARTING BY '?' TERMINATED BY ';'  (modelID, sampleName, gene, platform, expression, expressionZ, rank, rankZ, ampDel, cn, mutation)
 * 
 * mysql -u<> -p<> -Dmtb -h<> -e "LOAD DATA LOCAL INFILE 'C:/pdxexpression.txt' into table mtb.pdxexpression FIELDS TERMINATED BY ',' LINES STARTING BY '?' TERMINATED BY ';'  (modelID,sampleName, gene, platform, expression, expressionZ, rank, rankZ)"
 * 
 * create index expressionModel using btree on pdxexpression (modelID)
 * create index expressionGene using btree on pdxexpression (gene)
 * @author sbn
 */
public class ExpressionCNVDump {

    private static final HashMap<String, String> sexSpecificGenes = new HashMap<String, String>();
    private static final String expressionURI = "https://mmrdb.jax.org:8443/mmr/REST/pdx-expression/";
    private static final String expression = "expression-across-all-pdx-models.json";
    private static final String geneSummary = "gene-summary-expression-across-all-pdx-models.json";
    private static final String cnvURI = "https://mmrdb.jax.org:8443/mmr/REST/pdx-cnv/";    
    private static final String geneAmp = "cnv-pdx-models-with-gene-amplified.json";

    // this list should match the list in the PDXMouse store
    // so it should come from a single properties file.
   private static final String[] genes = {"A1CF", "ABL1", "ACVR1B", "ADAR", "ADARB1", "AFF2", "AICDA", "AKT1", "AKT2", "AKT3", "ALK", "APC", "APOBEC1", "APOBEC2", "APOBEC3A", "APOBEC3C", "APOBEC3D", "APOBEC3F", "APOBEC3G", "APOBEC4", "AR", "ARID1A", "ARID1B", "ARID2", "ASH1L", "ASXL1", "ATM", "ATN1", "ATP10B", "ATR", "ATRX", "AURKA", "AURKB", "AURKC", "AXIN1", "B2M", "BAP1", "BCL2", "BCOR", "BCR", "BID", "BRAF", "BRCA1", "BRCA2", "BRIP1", "BTK", "CARD11", "CARM1", "CASP8", "CBFB", "CBL", "CCND1", "CCNE1", "CCR2", "CDC73", "CDH1", "CDK12", "CDK4", "CDK6", "CDKN1B", "CDKN2A", "CDKN2C", "CEBPA,", "CHEK2", "CIC", "CIRBP", "COL18A1", "CREBBP", "CRLF2 (chrX)", "CRLF2 (chrY)", "CSF1R", "CSMD3", "CTCF", "CTNNB1", "CXCR4", "CYLD", "DALRD3", "DAXX", "DDIT4", "DDR2", "DICER1", "DNMT1", "DNMT3A", "DNMT3B", "DOT1L", "DROSHA", "DSPP", "EGFR", "EHMT2", "EIF2C1", "EIF2C2", "EIF2C3", "EIF2C4", "EP300", "EPHA10", "EPHA3", "EPHA5", "EPHB6", "ERBB2", "ERBB3", "ERBB4", "ESR1", "ETV6", "EZH1", "EZH2", "FAM123B", "FAM166A", "FAT4", "FBXO4", "FBXW7", "FER1L5", "FES", "FGFR1", "FGFR2", "FGFR3", "FGFR4", "FLT3", "FOXA1", "FOXL2", "FUBP1", "GATA1", "GATA2", "GATA3", "GLI1", "GLI2", "GLI3", "GLI4", "GNA11", "GNAQ", "GNAS", "GPR32", "GPRIN2", "GPS2", "GRIN2A", "H2AFX", "H3F3A", "HAUS5", "HCFC1R1", "HES1", "HES5", "HEY1", "HEY2", "HGF", "HIST1H1C", "HIST1H2BC", "HIST1H3B", "HLA-A", "HMCN1", "HNF1A", "HRAS", "HSBP1", "HSF1", "HSF2", "HSF4", "HSP90AA1", "ID1", "ID2", "ID3", "ID4", "IDH1", "IDH2", "IGF1R", "IKZF1", "INHBA", "INO80C", "ITPKB", "JAK1", "JAK2", "JAK3", "JMJD1C", "JMJD6", "KCNQ2", "KDM1A", "KDM1B", "KDM2A", "KDM2B", "KDM3A", "KDM3B", "KDM4A", "KDM4B", "KDM4C", "KDM4D", "KDM5A", "KDM5B", "KDM5C", "KDM5D", "KDM6A", "KDM6B", "KDR", "KEAP1", "KIT", "KLF4", "KLHL6", "KLRG2", "KRAS", "LATS1", "LATS2", "LLGL2", "LMO1", "LRFN4", "LRP1B", "LTK", "LYSMD3", "MAP2K1", "MAP2K2", "MAP2K4", "MAP2K7", "MAP3K1", "MAPK8", "MAPK9", "MDM2", "MDM4", "MED12", "MED23", "MEN1", "MET", "MLH1", "MLL2", "MLL3", "MLLT4", "MPL", "MSH2", "MSH6", "MST1", "MTOR", "MUC16", "MUC17", "MUC4", "MUC5B", "MYB", "MYC", "MYCL1", "MYCN", "MYD88", "MYT1L", "NCOA3", "NCOR1", "NEK10", "NF1", "NF2", "NFE2L2", "NKAIN4", "NKX2-1", "NOTCH1", "NOTCH2", "NOTCH3", "NOTCH4", "NPM1", "NRAS", "NSD1", "NTRK1", "NTRK2", "NTRK3", "PAK3", "PALB2", "PAX5", "PBRM1","PD", "PDGFA", "PDGFB", "PDGFRA", "PDGFRB", "PDL1","PGR", "PHF6", "PIK3CA", "PIK3R1", "PIP4K2C", "PIWIL1", "PLK1", "PMS1", "PMS2", "POLB", "POLI", "PPEF1", "PPP2R1A", "PQLC2", "PRDM1", "PRDM14", "PRDM2", "PRDM9", "PRKAA1", "PRKAA2", "PRMT1", "PRMT2", "PRMT3", "PRMT5", "PRMT6", "PRRX1", "PTCH1", "PTEN", "PTK2B", "PTPN11", "PTPRD", "PYCRL", "RAD50", "RAD51", "RAD51B", "RAD51C", "RAD51D", "RAD52", "RAD54B", "RAD54L", "RAD54L2", "RAF1", "RASA3", "RASGRF2", "RB1", "RET", "RNF43", "ROR2", "ROS1", "RPGR", "RUNX1", "SAAL1", "SCGB1C1", "SETBP1", "SETD2", "SETD7", "SF3B1", "SKP2", "SLC38A3", "SMAD2", "SMAD4", "SMARCA4", "SMARCB1", "SMO", "SMYD3", "SOCS1", "SOS1", "SOX9", "SPOP", "SRC", "SRSF2", "STAG2", "STK11", "STK3", "SUV39H1", "TARBP2", "TBL1XR1", "TBP", "TBX3", "TCF7L2", "TEAD1", "TEAD2", "TEAD4", "TET2", "TGFBR2", "TLE6", "TMEM82", "TNFAIP3", "TP53", "TP63", "TP73", "TRAF7", "TSC1", "TSHR", "TTC5", "TTN", "U2AF1", "UBC", "USH2A", "VHL", "WHSC1", "WHSC1L1", "WNT7A", "WT1", "WWTR1", "XRCC2", "XRCC3", "YAP1", "YES1", "ZFP36L1", "ZMYND19"};
   //private static final String[] genes = {"A1CF", "ABL1", "ACVR1B", "ADAR", "ADARB1", "AFF2", "AICDA"};
    private static final Logger log =
            Logger.getLogger(ExpressionCNVDump.class.getName());
 
    
    // initalize a map of genes on x,y or xy chromosomes
    static {

        sexSpecificGenes.put("AFF2", "X");
        sexSpecificGenes.put("AR", "X");
        sexSpecificGenes.put("ATRX", "X");
        sexSpecificGenes.put("BCOR", "X");
        sexSpecificGenes.put("BTK", "X");
        sexSpecificGenes.put("GATA1", "X");
        sexSpecificGenes.put("KDM5C", "X");
        sexSpecificGenes.put("KDM6A", "X");
        sexSpecificGenes.put("MED12", "X");
        sexSpecificGenes.put("PAK3", "X");
        sexSpecificGenes.put("PHF6", "X");
        sexSpecificGenes.put("PPEF1", "X");
        sexSpecificGenes.put("RPGR", "X");
        sexSpecificGenes.put("STAG2", "X");
        sexSpecificGenes.put("SUV39H1", "X");
        sexSpecificGenes.put("CRLF2", "XY");
        sexSpecificGenes.put("KDM5D", "Y");
        sexSpecificGenes.put("CRLF2 (chrX)","X");
        sexSpecificGenes.put("CRLF2 (chrY)","Y");        


    }
    
    public boolean dump(String fileName){
        
        boolean success = false;
        try{
        ArrayList<ArrayList<String>> vals = getCNV(genes);
        HashMap<String, ArrayList<String>> map = new HashMap<String, ArrayList<String>>();
        
        
        for (ArrayList<String> val : vals) {
            map.put(val.get(1) + val.get(4), val);
        }
        
        getAminoAcidChanges();

       ArrayList<String> data = getExpression(map);
       if(data != null && data.size()> 50000){
      
            FileWriter fw = new FileWriter(fileName);
            for (String datum : data) {
                //log.error(datum);
                fw.write(datum);
                fw.write("\n");
                
            }
            fw.close();
            success = true;
            log.info("Wrote "+data.size()+" pdxexpression records to file "+fileName);
                    
       }
        }catch(Exception e){
            log.error(e);
        }
        
      return success;
    }
    
    private static final String summaries = "variant-summaries.json";
    private static String variationURI = "https://mmrdb.jax.org:8443/mmr/REST/pdx-variation/";
   // private static String variationURI = "http://cga-test.jax.org:8080/mmr/REST/pdx-variation/";
    private static HashMap<String, String> aacMap = new HashMap<String, String>();
    
    
    private  void getAminoAcidChanges(){
        int count =0;
   
          for(PDXMouse mouse :allMice){
        ArrayList<String> ids = new ArrayList<String>();
      
            ids.add(new Integer(mouse.getModelID().substring(2)).toString());
        
         
          JSONArray jIDs = new JSONArray(ids);
        count++;
       System.out.println(count+" of "+allMice.size()+" -->  "+mouse.getModelID());
               
        try {
             // the following line is failing
            JSONObject job = new JSONObject("{\"data\":" + getJSON(variationURI ,summaries, jIDs.toString())+"}");
            JSONArray jarray = (JSONArray) job.get("data");
            for (int i = 0; i < jarray.length(); i++) {
                JSONObject obj = jarray.getJSONObject(i);
                int modelInt = ((Integer) obj.get("model_id")).intValue();
                String modelStr = ("TM" + String.format("%05d", modelInt));
                JSONArray samples = (JSONArray) obj.get("samples");
                for (int j = 0; j < samples.length(); j++) {
                    JSONObject sampObj = samples.getJSONObject(j);
                    String sampleStr = (String) sampObj.get("sample_name");
                    JSONArray genes = (JSONArray) sampObj.get("genes");
                    for (int g = 0; g < genes.length(); g++) {
                        JSONObject gene = genes.getJSONObject(g);
                        String geneStr = (String) gene.get("gene_symbol");
                        JSONArray variants = gene.getJSONArray("variants");
                        String mutation = "";
                        for (int v = 0; v < variants.length(); v++) {
                            JSONObject variant = variants.getJSONObject(v);
                            if(v>0 || !mutation.equals(variant.get("amino_acid_change"))){
            //                    System.out.println(mutation+" "+variant.get("amino_acid_change"));
                            }
                            mutation =(String)variant.get("amino_acid_change");
                            aacMap.put(sampleStr+geneStr, mutation);
                    }
                }

            }
            }
        } catch (JSONException e) {
            log.error("Error with variant summary", e);
        }
      
    }

    }

    private ArrayList<String> getExpression(HashMap<String, ArrayList<String>> map) throws Exception {

        DecimalFormat df = new DecimalFormat("##.#####");
        ArrayList<String> data = new ArrayList<String>();
        for (int i = 0; i < genes.length; i++) {

            HashMap<String, Double> expSummary = getGeneExpressionSummary(genes[i]);

            String mean = "mean";
            String stdDev = "stdDev";

            String meanRank = "meanRank";
            String stdDevRank = "stdDevRank";
            
            String mutation;

            String params = "{\"gene_symbol\": \"" + genes[i] + "\"}";
          
                ArrayList<String> cnv = null;
                JSONObject job = new JSONObject("{\"data\":" + getJSON(expressionURI, expression, params) + "}");

                JSONArray jarray = (JSONArray) job.get("data");
                for (int j = 0; j < jarray.length(); j++) {
                    JSONObject obj = jarray.getJSONObject(j);
                    int modelInt = ((Integer) obj.get("model_id")).intValue();
                    String modelStr = ("TM" + String.format("%05d", modelInt));

                    JSONArray samples = (JSONArray) obj.get("samples");
                    for (int k = 0; k < samples.length(); k++) {
                        JSONObject sampObj = samples.getJSONObject(k);
                        String sampleName = (String) sampObj.get("sample_name");
                        JSONArray genes2 = (JSONArray) sampObj.get("genes");
                        for (int g = 0; g < genes2.length(); g++) {
                            JSONObject geneObj = genes2.getJSONObject(g);
                            String geneStr = (String) geneObj.get("gene_symbol");
                            String platform = (String) geneObj.get("platform");
                            Double expValue = ((Double) geneObj.get("normalized_expression"));
                            Double zScore = (expValue - expSummary.get(platform + "-" + mean)) / expSummary.get(platform + "-" + stdDev);
                            Double expRank = ((Double) geneObj.get("percentile_expression"));
                            Double zRank = (expRank - expSummary.get(platform + "-" + meanRank)) / expSummary.get(platform + "-" + stdDevRank);

                            cnv = map.get(sampleName + geneStr);
                            map.remove(sampleName + geneStr);
                            String ampDel = "noValue";
                            Double cn_raw = 0.0;
                            if (cnv != null) {
                                ampDel = cnv.get(2);
                                cn_raw = new Double(cnv.get(3));
                            } else {
                                //  log.error("no cnv data for "+modelStr+" "+sampleName+" "+geneStr);
                            }
                           mutation = aacMap.get(sampleName+geneStr);
                           if (mutation == null){
                               mutation = "";
                           }
                            data.add("?`" + modelStr + "`,`" + sampleName + "`,`" + geneStr + "`,`" + platform + "`,`" + df.format(expValue) + "`,`" + df.format(zScore)
                                    + "`,`" + df.format(expRank) + "`,`" + df.format(zRank) + "`,`" + ampDel + "`,`" + df.format(cn_raw) +"`,`"+mutation+ "`;");
                            if (data.size() % 1000 == 0) {
                                log.info(data.size() + " records loaded");
                            }
                        }
                    }
                }

          

        }

        Collections.sort(data);
        
        return data;
       
    }

    private HashMap<String, Double> getGeneExpressionSummary(String gene) throws Exception{

        HashMap<String, Double> result = new HashMap<String, Double>();
        String params = "{\"gene_symbol\": \"" + gene + "\"}";
       
            JSONObject job = new JSONObject("{\"data\":" + getJSON(expressionURI, geneSummary, params) + "}");
            JSONArray jarray = job.getJSONArray("data");

            for (int i = 0; i < jarray.length(); i++) {
                job = jarray.getJSONObject(i);
                String platform = job.getString("platform");
                result.put(platform + "-mean", job.getDouble("mean_expression"));
                result.put(platform + "-median", job.getDouble("median_expression"));
                result.put(platform + "-stdDev", job.getDouble("std_dev_expression"));
                result.put(platform + "-meanRank", job.getDouble("mean_rank_percentile"));
                result.put(platform + "-medianRank", job.getDouble("median_rank_percentile"));
                result.put(platform + "-stdDevRank", job.getDouble("std_dev_rank_percentile"));

            }

       

        return result;
    }
    
    static ArrayList<PDXMouse> allMice;

    public ArrayList<ArrayList<String>> getCNV(String[] genesCNV) throws Exception {

       
        // get all publicly available mice
       
             ElimsUtil eu = new ElimsUtil();
              PDXMouseSearchData searchData =eu.getPDXMouseSearchData();
            allMice = searchData.getMice();
        
        ArrayList<ArrayList<String>> matchingSamples = new ArrayList<ArrayList<String>>();

        ArrayList<ArrayList<String>> cnv = getGeneAmplification(genesCNV);



        for (PDXMouse mouse : allMice) {
            for (ArrayList<String> vals : cnv) {
                String id = ("TM" + String.format("%05d", new Integer(vals.get(0))));

                if (mouse.getModelID().equals(id)) {  
                    vals.set(2, calcAmpDel(mouse.getSex(), vals.get(3), vals.get(4), mouse.getModelID()));
                    matchingSamples.add(vals);

                }
            }
        }

        return matchingSamples;

    }

    private  ArrayList<ArrayList<String>> getGeneAmplification(String[] genes) throws Exception {
        ArrayList<ArrayList<String>> mice = new ArrayList<ArrayList<String>>();


        for (String gene : genes) {

           
            // bring em all back, sort them out later
           String min_cn = "0.0";

            String params = "{\"gene_symbol\": \"" + gene + "\",\"min_cn\" : \"" + min_cn + "\"}";
           
                JSONObject job = new JSONObject("{\"data\":" + getJSON(cnvURI, geneAmp, params) + "}");
                JSONArray jarray = job.getJSONArray("data");

                for (int i = 0; i < jarray.length(); i++) {
                    job = jarray.getJSONObject(i);
                    String model = job.getString("model_id");
                    String sample = job.getString("sample_name");
                    Double cn = job.getDouble("cn_raw");
                    ArrayList<String> vals = new ArrayList<String>();
                    vals.add(model);
                    vals.add(sample);
                    vals.add("Not Calculated");
                    vals.add(cn.toString());
                    vals.add(gene);
                    mice.add(vals);
                }

          
        }


        return mice;
    }

    private  String calcAmpDel(String sex, String cn, String gene, String id) {

        String result = "Normal"; // "Amplification, Deletion, Normal

        Double cNum = new Double(cn);
        String geneChr = sexSpecificGenes.get(gene);

        //default also be applied to any model where sex is unspecified
        if (cNum > 2.5) {
            result = "Amplification";
        }
        if (cNum < 1.5) {
            result = "Deletion";
        }

        test:
        {
            if ("X".equalsIgnoreCase(geneChr)) {
                if ("Male".equalsIgnoreCase(sex)) {
                    if (cNum > 1.5) {
                        result = "Amplification";
                    }
                    if (cNum < 0.5) {
                        result = "Deletion";
                    }
                    break test;
                }
            }

            if ("Y".equalsIgnoreCase(geneChr)) {
                if ("Male".equalsIgnoreCase(sex)) {
                    if (cNum > 1.5) {
                        result = "Amplification";
                    }
                    if (cNum < 0.5) {
                        result = "Deletion";
                    }
                    break test;
                }
                if ("Female".equalsIgnoreCase(sex)) {
                    if (cNum > 0.5) {
                        result = "Amplification";
                        log.info("Female PT with Y chr! Gene:"+gene+", Model ID:"+id);
                    }
                }
            }


        }// end of test block

        return result;
    }
    
    
    // for a while inital calls to webservice were failing but second attempts worked, give it 3 tries.
    private String getJSON(String uri, String op, String json){
        int tries  = 0;
        int maxTries =3;
        String jsonResult = null;
        while((tries < maxTries)&& (jsonResult == null || jsonResult == "")){
            jsonResult = callWebService(uri,op,json);
        }
        
        return jsonResult;
        
        
    }

    private  String callWebService(String uri, String op, String json) {

        boolean post = true;
        if (json == null || json.length() == 0) {
            post = false;
        }

        String responseSingle = "";
        StringBuffer response = new StringBuffer();
        String urlStr = uri + op;

        HttpURLConnection connection = null;
        try {
            URL url = new URL(urlStr);
            connection =
                    (HttpURLConnection) url.openConnection();
            if (post) {
                connection.setRequestMethod("POST");
                connection.setDoOutput(true); //sending stuff
            } else {
                connection.setRequestMethod("GET");
            }

            connection.setRequestProperty("Content-Type", "application/json");
            connection.setRequestProperty("Accept", "application/json");

            connection.setDoInput(true); // want feedback
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
     //               System.out.append(responseSingle);
                    response.append( responseSingle);
                }
                rd.close();

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
}
