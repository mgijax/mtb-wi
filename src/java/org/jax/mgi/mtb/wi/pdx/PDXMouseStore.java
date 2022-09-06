/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.jax.mgi.mtb.wi.pdx;

import java.io.File;
import java.math.RoundingMode;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import org.apache.logging.log4j.Logger;
import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;
import org.jax.mgi.mtb.dao.custom.mtb.pdx.GenomicsLink;
import org.jax.mgi.mtb.dao.custom.mtb.pdx.PDXComment;
import org.jax.mgi.mtb.dao.custom.mtb.pdx.PDXDAO;
import org.jax.mgi.mtb.dao.custom.mtb.pdx.PDXDocument;
import org.jax.mgi.mtb.dao.custom.mtb.pdx.PDXGraphic;
import org.jax.mgi.mtb.dao.custom.mtb.pdx.PDXLink;
import org.jax.mgi.mtb.dao.custom.mtb.pdx.PDXMouse;
import org.jax.mgi.mtb.dao.utils.DAOUtils;
import org.jax.mgi.mtb.utils.LabelValueBean;
import org.jax.mgi.mtb.utils.StringUtils;
import org.jax.mgi.mtb.wi.JSONUtils;
import static org.jax.mgi.mtb.wi.JSONUtils.getJSON;
import org.jax.mgi.mtb.wi.WIConstants;

/**
 * Manages PDX data Initialized on startup; loads mice, reports and vocabularies
 * Gets data from web services, and through DAOs from both caTissue and MTB
 * databases
 *
 * @author sbn
 */
public class PDXMouseStore {

    private static final Logger log
            = org.apache.logging.log4j.LogManager.getLogger(PDXMouseStore.class.getName());
    private static ArrayList<PDXMouse> allMice;
    // use the numeric part of the model id as an index to the mouse object
    //  private static HashMap<Integer,PDXMouse> mouseMap = new HashMap<Integer,PDXMouse>();
    private static ArrayList<String> diagnosesList;
    private static ArrayList<String> primarySitesList;
    private static ArrayList<String> tagsList;
    private static ArrayList<String> tumorMarkersList;

    private static ArrayList<LabelValueBean<String, String>> diagnosesLVB = new ArrayList<>();
    private static ArrayList<LabelValueBean<String, String>> primarySitesLVB = new ArrayList<>();
    private static ArrayList<LabelValueBean<String, String>> tagsLVB = new ArrayList<>();
    private static ArrayList<LabelValueBean<String, String>> tumorMarkersLVB = new ArrayList<>();
    private static ArrayList<LabelValueBean<String, String>> fusionGenesLVB = new ArrayList<>();
    private static ArrayList<LabelValueBean<String, String>> recistDrugsLVB = new ArrayList<>();
    private static ArrayList<LabelValueBean<String, String>> recistResponsesLVB = new ArrayList<>();

    private static ArrayList<String> ctpGenes = new ArrayList<>();

    private static String idList;
    private static HashMap<String, ArrayList<String>> assocData = new HashMap<>();

    private static String JSON_PDX_STATUS = "Unable to load data from eLIMS";
    private static String JSON_PDX_INFO = "Unable to load data from eLIMS";

    private static String baseURL = WIConstants.getInstance().getPDXWebservice();

    private static final String MODEL_EXPRESSION = baseURL + "expression?all_ctp_genes=yes&keepnulls=yes&model=";

    private static final String GENE_EXPRESSION = baseURL + "expression?&keepnulls=yes&gene_symbol=";

    private static final String MODEL_CNV = baseURL + "cnv_gene?all_ctp_genes=yes&keepnulls=yes&model=";

    private static final String CNV_AMP = baseURL + "cnv_gene?min_lr_ploidy=0.5&gene_symbol=";
    private static final String CNV_DEL = baseURL + "cnv_gene?max_lr_ploidy=-0.5&gene_symbol=";

    private static final String VARIANTS = baseURL + "variants";

    private static final String FUSION_MODELS_BY_GENE = baseURL + "starfusion?ckb_class=relevant";

    private static final String FUSION_GENES = baseURL + "all_genes?datatype=fusions&ckb_class=relevant";

    private static final String VARIANTS_FOR_GENE = baseURL + "gene_variants?gene_symbol=";

    private static final String SAMPLE_PASSAGE = baseURL + "inventory?model=MODEL_ID&sample=SAMPLE_ID&reqitems=passage_num";

    private static final String TMB_URI = baseURL + "inventory?platform=CTP&reqitems=model_name,sample_name,passage_num,tmb_score,msi_score";
    
    private static final String linkOuts = baseURL + "public_archive_linkouts/";

    private static HashMap<String, String> fusionModelsMap = new HashMap<>();

    private static final String[] BUILD_38_AFFECTED_GENES = {"AKT3", "APOBEC3A", "B2M",
        "DAXX", "EHMT2", "EPHB6", "HLA-A",
        "HRAS", "ID3", "KCNQ2", "MUC4", "NOTCH4",
        "PIWIL1", "PTEN", "PTPRD", "RASA3", "SMARCB1"};

    private static final String RNA_SEQ = "RNA_Seq";
    private static final HashMap<String, String> AFFECTED_GENES = new HashMap<>();

    private static final String CKB_MOLPRO_PUBLIC = "https://ckb.jax.org/molecularProfile/show/";
    //   private static final String CKB_GENE_PUBLIC = "https://ckb.jax.org/gene/show?geneId=";

    private static final String CKB_MOLPRO_INTERNAL = "https://myckb.jax.org/molecularProfile/show/";
    //  private static final String CKB_GENE_INTERNAL = "https://myckb.jax.org/gene/show?geneId=";

    private static final String CKB_HOME = "https://ckbhome.jax.org/";

    public static final String BAYLOR = "Baylor College of Medicine";
    public static final String DANA_FARBER = "Dana-Farber Cancer Institute";

    public static double AMP = 0.5;
    public static double DEL = -0.5;

    private static final HashMap<String, ArrayList<ArrayList<String>>> cnvPlots = new HashMap<>();
    private static final HashMap<String, HashMap<String, Double>> tmbMap = new HashMap<>();

    private static Double minTMB = 1000.0;
    private static Double maxTMB = 0.0;

    private static int loadTries = 0;

    private static HashMap<String, PDXMouse> modelMap = new HashMap<>();

    public PDXMouseStore() {

        try {
            if (allMice == null || allMice.isEmpty()) {
                synchronized (PDXMouseStore.class) {
                    loadTries++;
                    if (loadTries < 3) {
                        loadData();
                    } else {
                        // this can happen over and over if the load fails and the model counts code runs....
                        log.error("Failed to load PDX data after 3 attempts.");
                    }
                }
            }
            if (AFFECTED_GENES.size() == 0) {
                for (String g : BUILD_38_AFFECTED_GENES) {
                    AFFECTED_GENES.put(g, g);
                }
            }
        } catch (Exception e) {
            log.error("Unable to initalize pdx mouse store", e);
            allMice = new ArrayList<>();

        }
    }

    private void loadData() throws Exception {

        log.info("Loading eLIMS-PDX Data");
        boolean forPublic = WIConstants.getInstance().getPublicDeployment();

        PDXReports.getInstance();

        primarySitesLVB.clear();
        diagnosesLVB.clear();
        tagsLVB.clear();
        fusionGenesLVB.clear();
        recistDrugsLVB.clear();
        recistResponsesLVB.clear();

        //log.info("loading mice from eLIMS");
        //  ElimsUtil eu = new ElimsUtil();

        allMice = PDXDAO.getInstance().getModels(forPublic);
        log.info("loaded " + allMice.size() + " mice.");

        buildIDList();

        diagnosesList = PDXDAO.getInstance().getDiagnosisList(forPublic);
        primarySitesList = PDXDAO.getInstance().getPrimarySitesList(forPublic);
        tagsList = PDXDAO.getInstance().getTagsList(forPublic);

        for (String tissue : primarySitesList) {
            LabelValueBean<String, String> lvb = new LabelValueBean<>(tissue, tissue);
            primarySitesLVB.add(lvb);
        }

        for (String diagnosis : diagnosesList) {
            LabelValueBean<String, String> lvb = new LabelValueBean<>(diagnosis, diagnosis);
            diagnosesLVB.add(lvb);
        }

        for (String tag : tagsList) {
            LabelValueBean<String, String> lvb = new LabelValueBean<>(tag, tag);
            tagsLVB.add(lvb);
        }

        buildIDList();

        loadFusionGenes();
        
        loadFusionModels();

        loadTMBData();
        
        if(!forPublic)loadGenomicsLinks();
       // loadGenomicsLinks();

        ctpGenes = PDXDAO.getInstance().getCTPGenes();

        if (allMice != null && allMice.size() > 0) {

            HashMap<String, Integer> socGraphs = SOCLoader.loadSOCModels();

            ArrayList<String> recistResponses = SOCLoader.loadRECISTResponses();
            ArrayList<String> recistDrugs = SOCLoader.loadRECISTDrugs();

            for (String drug : recistDrugs) {
                recistDrugsLVB.add(new LabelValueBean<String, String>(drug, drug));
            }

            for (String response : recistResponses) {
                recistResponsesLVB.add(new LabelValueBean<String, String>(response, response));
            }

            assocData = PDXDAO.getInstance().getPDXAdditionalContent();
            for (PDXMouse mouse : allMice) {

                if (socGraphs.containsKey(mouse.getModelID())) {
                    mouse.setSocGraph(socGraphs.get(mouse.getModelID()));
                }
                mouse.setAssocData(assocData.get(mouse.getModelID()));
                String id = mouse.getModelID();

                if (fusionModelsMap.get(id) != null) {
                    mouse.setFusionGenes(fusionModelsMap.get(id));
                   
                }

                if (tmbMap.get(id) != null) {
                    //   System.out.println("set tmb for "+id);
                    mouse.setTMB(tmbMap.get(id));

                }

            }

            loadCNVPlots();
            log.info("Loaded cnv plots for " + cnvPlots.size() + " models.");

            // this preloads the PDXModlels for PDXLikeMe
            PDXLikeMe pgc = new PDXLikeMe();
            log.info("Preloaded data for PDX Like ME.");
        }
    }

    public int getModelCount() {
        return allMice.size();
    }

    // keep a cached copy of the PDXStatus JSON but use a new one if available
    // used by pdx dashboard (external to MTB)
    public String getJSONPDXStatus() {
        ElimsUtil eu = new ElimsUtil();
        String newData = eu.getJSONPDXStatusReport();
        if (newData != null && newData.trim().length() != 80) {
            this.JSON_PDX_STATUS = newData;
        } else {
            log.error("Unable to load JSON for PDX status.");
        }
        return this.JSON_PDX_STATUS;
    }

    /**
     * Return the mouse model with ID using cached mouse list Result will be a
     * single mouse or empty. ArrayList for consistency with other find methods
     *
     * @param ID String TM#####
     * @return ArrayList<PDXMouse>
     */
    public PDXMouse findStaticMouseByID(String iD) {
        return modelMap.get(iD);
    }

    /**
     * Return a list of PDXMice that match the search parameters
     *
     * @param modelID String
     * @param tissues ArrayList<String>
     * @param diagnoses ArrayList<String>
     * @param tumorTypes ArrayList<String>
     * @param genes ArrayList<String>
     * @param variants ArrayList<String>
     * @param dosingStudy boolean dosing study required
     * @param tumorGrowth boolean tumorGrowth data required
     * @param tags
     * @param fusionGenes String
     * @param treatmentNaive boolean
     * @param recistDrug String
     * @param recistResponse String
     * @param tmbGT Double tumor mutation burden greater than
     * @param tmbLT Double tumor mutation burder less than
     * @return ArrayList<PDXMouse> mice matching search parameters
     */
    public ArrayList<PDXMouse> findMice(String modelID, ArrayList<String> tissues,
            ArrayList<String> diagnoses,
            String gene, ArrayList<String> variants, boolean dosingStudy,
            boolean tumorGrowth, ArrayList<String> tags, String fusionGene,
            boolean treatmentNaive, String recistDrug, String recistResponse, Double tmbGT, Double tmbLT) {

        // may need to do 3 searches
        // findStaticMice
        // find by fusion gene
        // find by gene variant --> populate variants and consequence if variant is used
        ArrayList<PDXMouse> mice = new ArrayList<>();

       
        mice = findStaticMice(modelID, tissues, diagnoses,
                dosingStudy, tumorGrowth, tags, fusionGene, treatmentNaive, recistDrug, recistResponse, tmbGT, tmbLT);

        ArrayList<String> ids = new ArrayList<>();

        Collections.sort(ids);

        ArrayList<PDXMouse> mice2 = new ArrayList<>();

        if (ids.isEmpty()) {
            mice2.addAll(mice);
        } else {
            for (PDXMouse sMouse : mice) {
                // because search specific values will be set clone the static mouse
                PDXMouse mouse = sMouse.clone();
                for (String id : ids) {
                    if (compareIDs(mouse.getModelID(), id)) {
                        mice2.add(mouse);

                    }
                }
            }
        }

        if (gene != null && gene.length() > 0) {
            mice2 = getMiceByGeneVariant(mice2, gene, variants);
        }

        return mice2;
    }

    private boolean compareIDs(String display, String numeric) {

        if (true) {
            return display.equals(numeric);
        }

        boolean match = false;
        int numNum = -1;
        int displayNum = 0;
        try {
            numNum = new Integer(numeric).intValue();

        } catch (Exception e) {
            log.error("Cant parse " + numeric + " to compare to " + display);
        }
        try {

            if (display.startsWith("TM")) {
                display = display.substring(2);
                displayNum = new Integer(display).intValue();
            }
            if (display.startsWith("J")) {
                display = display.substring(1);
                displayNum = new Integer(display).intValue();
            }
        } catch (Exception e) {
            log.error("Cant parse " + display + " to compare to " + numeric);
        }
        if (displayNum == numNum) {
            match = true;
        }

        return match;
    }

    public ArrayList<PDXMouse> findStaticMiceByTissueOfOrigin(String toa) {
        ArrayList<PDXMouse> mice = new ArrayList<PDXMouse>();

        for (PDXMouse mouse : allMice) {
            if (mouse.getTissue().equals(toa)) {
                mice.add(mouse);
            }
        }
        return mice;
    }

    /**
     *
     * @param modelID String TM#####
     * @param tissues ArrayList<String>
     * @param diagnoses ArrayList<String>
     * @param tumorTypes ArrayList<String>
     * @param tumorMarkers ArrayList<String>
     * @return ArrayList<PDXMouse> matching mice
     */
    private ArrayList<PDXMouse> findStaticMice(String modelID, ArrayList<String> tissues,
            ArrayList<String> diagnoses,
            boolean dosingStudy, boolean tumorGrowth, ArrayList<String> tags,
            String fusionGene, boolean treatmentNaive,
            String recistDrug, String recistResponse, Double tmbGT, Double tmbLT) {

        ArrayList<PDXMouse> mice = new ArrayList<>();
        
        // need to validate values for ID, tissues,diagnosese tumortypes and tags match controled vocab from search
        // this will prevent any sql injection 
        validateSearchParams(tissues,diagnoses,tags);
        
        ArrayList<String> ids = PDXDAO.getInstance().findModels(modelID, tissues, diagnoses, tags, treatmentNaive, WIConstants.getInstance().getPublicDeployment());

        ArrayList<String> fusionModels = null;
        if (fusionGene != null && fusionGene.trim().length()>0) {
            fusionModels = getFusionModels(fusionGene);
        }
        
         ArrayList<String> socIDs = new ArrayList<>();
         boolean checkSOC = false;
        
        if (StringUtils.hasValue(recistDrug) || StringUtils.hasValue(recistResponse)) {
            checkSOC = true;
            socIDs = SOCLoader.getRECISTModels(recistDrug, recistResponse);
        }

        for (String id : ids) {
            boolean match = true;
            PDXMouse mouse = this.findStaticMouseByID(id);

            if (dosingStudy) {
                match = false;
                if (mouse.getSocGraph() != 0) {
                    match = true;
                }
            }
            if (tumorGrowth) {
                match = false;
                if (mouse.getAssocData() != null && mouse.getAssocData().contains("Tumor")) {
                    match = true;
                }
            }

            if (fusionModels != null) {
                match = false;
                if (fusionGene.equalsIgnoreCase("any")) {
                    if (fusionModelsMap.containsKey(mouse.getModelID())) {
                        match = true;
                    }
                } else {

                    match = fusionModels.contains(mouse.getModelID());
                }

            }

            if (checkSOC) {
                match = false;
                if (socIDs.contains(mouse.getModelID())) {
                    match = true;
                }
            }

            if (tmbGT != null && tmbLT != null) {
                match = false;
                if (mouse.tmbGreaterThan(tmbGT) && mouse.tmbLessThan(tmbLT)) {
                    match = true;
                }

            } else {

                if (tmbGT != null) {
                    match = false;
                    if (mouse.tmbGreaterThan(tmbGT)) {
                        match = true;
                    }
                }
                if (tmbLT != null) {
                    match = false;
                    if (mouse.tmbLessThan(tmbLT)) {
                        match = true;
                    }
                }
            }

            if (match) {
                mice.add(mouse);
            }
        }

        return mice;

    }

    public String getPDXReportWithNoName() {
        return new ElimsUtil().getPDXReportWithNoName(allMice);
    }

    public ArrayList<String> getDiagnosesList() {
        return (ArrayList<String>) diagnosesList.clone();
    }

    public ArrayList<String> getPrimarySitesList() {
        return (ArrayList<String>) primarySitesList.clone();
    }

    public ArrayList<String> getTumorMarkersList() {
        return (ArrayList<String>) tumorMarkersList.clone();
    }

    public ArrayList<String> getTagsList() {
        return tagsList;
    }

    public ArrayList<String> getCTPGenes() {
        return this.ctpGenes;
    }

    // why the redundant casting??????
    public ArrayList<LabelValueBean<String, String>> getDiagnosesLVB() {
        return diagnosesLVB;
    }

    public ArrayList<LabelValueBean<String, String>> getPrimarySitesLVB() {
        return primarySitesLVB;
    }

    public ArrayList<LabelValueBean<String, String>> getTumorMarkersLVB() {
        return tumorMarkersLVB;
    }

    public ArrayList<LabelValueBean<String, String>> getTagsLVB() {
        return tagsLVB;
    }

    public ArrayList<LabelValueBean<String, String>> getFusionGenesLVB() {
        return fusionGenesLVB;
    }

    public ArrayList<LabelValueBean<String, String>> getRECISTDrugsLVB() {
        return recistDrugsLVB;
    }

    public ArrayList<LabelValueBean<String, String>> getRECISTResponsesLVB() {
        return recistResponsesLVB;
    }

    // get, add, update and delete methods for additional content types
    // pdx curator methods
    public boolean addLink(PDXLink link) {
        boolean success = true;
        PDXDAO dao = PDXDAO.getInstance();
        try {
            dao.addLink(link);
        } catch (SQLException e) {
            log.error("Could not add link", e);
            success = false;
        }
        return success;
    }

    public boolean updateLink(PDXLink link) {
        PDXDAO dao = PDXDAO.getInstance();
        boolean success = true;
        try {
            dao.updateLink(link);
        } catch (SQLException e) {
            log.error("Could not update link", e);
            success = false;
        }
        return success;
    }

    public ArrayList<PDXLink> getLinks(String tumorID) {
        PDXDAO dao = PDXDAO.getInstance();
        return dao.getLinks(tumorID);
    }

    public PDXLink getLink(int key) {
        PDXDAO dao = PDXDAO.getInstance();
        return dao.getLink(key);
    }

    public void deleteLink(int contentKey) {
        PDXDAO dao = PDXDAO.getInstance();
        dao.deleteLink(contentKey);

    }

    public boolean addComment(PDXComment comment) {
        PDXDAO dao = PDXDAO.getInstance();
        boolean success = true;
        try {
            dao.addComment(comment);
        } catch (SQLException e) {
            log.error("Could not add comment", e);
            success = false;
        }
        return success;

    }

    public boolean updateComment(PDXComment comment) {
        PDXDAO dao = PDXDAO.getInstance();
        boolean success = true;
        try {
            dao.updateComment(comment);
        } catch (SQLException e) {
            log.error("Could not update comment", e);
            success = false;
        }
        return success;

    }

    public ArrayList<PDXComment> getComments(String tumorID) {
        PDXDAO dao = PDXDAO.getInstance();
        return dao.getComments(tumorID);
    }

    public PDXComment getComment(int key) {
        PDXDAO dao = PDXDAO.getInstance();
        return dao.getComment(key);
    }

    public void deleteComment(int contentKey) {
        PDXDAO dao = PDXDAO.getInstance();
        dao.deleteComment(contentKey);
    }

    public boolean addGraphic(PDXGraphic graphic) {
        PDXDAO dao = PDXDAO.getInstance();
        boolean success = true;
        try {
            dao.addGraphic(graphic);
        } catch (SQLException e) {
            log.error("Could not add graphic", e);
            success = false;
        }
        return success;

    }

    public boolean updateGraphic(PDXGraphic graphic) {
        PDXDAO dao = PDXDAO.getInstance();
        boolean success = true;
        try {
            dao.updateGraphic(graphic);
        } catch (SQLException e) {
            log.error("Could not update graphic", e);
            success = false;
        }
        return success;

    }

    public ArrayList<PDXGraphic> getGraphics(String tumorID) {
        PDXDAO dao = PDXDAO.getInstance();
        return dao.getGraphics(tumorID);
    }

    public PDXGraphic getGraphic(int key) {
        PDXDAO dao = PDXDAO.getInstance();
        return dao.getGraphic(key);
    }

    public void deleteGraphic(int contentKey) {
        PDXDAO dao = PDXDAO.getInstance();
        PDXGraphic g = getGraphic(contentKey);
        deleteFile(g.getFileName());
        dao.deleteGraphic(contentKey);

    }

    public boolean addDocument(PDXDocument doc) {
        PDXDAO dao = PDXDAO.getInstance();
        boolean success = true;
        try {
            dao.addDocument(doc);
        } catch (SQLException e) {
            log.error("Could not add document", e);
            success = false;
        }
        return success;

    }

    public boolean updateDocument(PDXDocument doc) {
        PDXDAO dao = PDXDAO.getInstance();
        boolean success = true;
        try {
            dao.updateDocument(doc);
        } catch (SQLException e) {
            log.error("Could not update document", e);
            success = false;
        }
        return success;

    }

    public ArrayList<PDXDocument> getDocuments(String tumorID) {
        PDXDAO dao = PDXDAO.getInstance();
        return dao.getDocuments(tumorID);
    }

    public PDXDocument getDocument(int key) {
        PDXDAO dao = PDXDAO.getInstance();
        return dao.getDocument(key);
    }

    public void deleteDocument(int contentKey) {
        PDXDAO dao = PDXDAO.getInstance();
        PDXDocument d = getDocument(contentKey);
        deleteFile(d.getFileName());
        dao.deleteDocument(contentKey);

    }

    private void deleteFile(String fileName) {
        File f = new File(WIConstants.getInstance().getPDXFilePath() + fileName);
        f.delete();

    }

    public String getModelExpression(String modelID, boolean useTPM) {

        String valueToGet = "z_score_percentile_rank";
        if (useTPM) {
            valueToGet = "tpm";
        }

        DecimalFormat df = new DecimalFormat("#.##");

        StringBuffer result = new StringBuffer();
        HashMap<String, String> sampleMap = new HashMap<>();
        HashMap<String, HashMap<String, String>> genes = new HashMap<>();
        HashMap<String, String> platformMap = new HashMap<>();
        HashMap<String, String> samplePlatformMap = new HashMap<>();

        String url = MODEL_EXPRESSION + modelID;

        try {
            JSONObject job = new JSONObject(JSONUtils.getJSON(url));
            JSONArray array = (JSONArray) job.get("data");
            for (int i = 0; i < array.length(); i++) {
                JSONObject data = array.getJSONObject(i);

                String sample = data.getString("sample_name") + " " + getField(data, "passage_num");

                String gene = data.getString("gene_symbol");
                String platform = data.getString("platform");
                Double value = data.getDouble(valueToGet);

                sample = sample + " " + platform;

                if (useTPM) {
                    value = (Math.log(value + 1) / Math.log(2));
                }

                String valueStr = df.format(value);

                platformMap.put(platform, platform);
                sampleMap.put(sample, sample);
                samplePlatformMap.put(sample, platform);

                if (genes.containsKey(gene)) {
                    genes.get(gene).put(sample, valueStr);
                } else {
                    HashMap<String, String> map = new HashMap<>();
                    map.put(sample, valueStr);
                    genes.put(gene, map);
                }

            }
            ArrayList<String> samples = new ArrayList<>();
            samples.addAll(sampleMap.keySet());

            Collections.sort(samples);

            ArrayList<String> platforms = new ArrayList<>();
            platforms.addAll(platformMap.keySet());

            Collections.sort(platforms);
            for (String pform : platforms) {
                if (result.length() > 0) {
                    result.append(", ");
                }
                result.append(pform);
            }
            // build the column definitions gene then one or more samples
            result.append("['Gene'");
            for (String sam : samples) {
                result.append(",'").append(sam).append("',{role:'certainty'}");
            }
            result.append("]");

            // group the expression values by gene across one or more samples
            ArrayList<String> geneList = new ArrayList<>();
            geneList.addAll(genes.keySet());
            Collections.sort(geneList);
            for (String g : geneList) {
                result.append(",['").append(g).append("'");
                HashMap<String, String> map = genes.get(g);
                for (String sam : samples) {
                    if (map.get(sam) != null) {
                        // affected genes are only for samples from platform RNA_Seq
                        if (AFFECTED_GENES.containsKey(g) && RNA_SEQ.equals(samplePlatformMap.get(sam))) {
                            result.append(",").append(map.get(sam)).append(",false");
                        } else {
                            result.append(",").append(map.get(sam)).append(",true");
                        }
                    } else {
                        result.append(",null,true");
                    }

                }

                result.append("]");

            }

            if (genes.size() == 0) {
                result.delete(0, result.length());
            }

        } catch (Exception e) {
            log.error(e);
        }

        return result.toString();

    }

    public String getModelCNV(String modelID) {

        DecimalFormat df = new DecimalFormat("##.####");

        StringBuffer result = new StringBuffer();

        HashMap<String, String> ploidyMap = new HashMap<>();
        HashMap<String, HashMap<String, String>> genes = new HashMap<>();
        try {

            String url = MODEL_CNV + modelID;

            JSONObject job = new JSONObject(getJSON(url));
            JSONArray array = (JSONArray) job.get("data");
            for (int i = 0; i < array.length(); i++) {
                JSONObject data = array.getJSONObject(i);

                String gene = data.getString("gene_symbol");
                String sample = data.getString("sample_name") + " " + getField(data, "passage_num");
                String cn = df.format(data.getDouble("logratio_ploidy"));
                String ploidy = df.format(data.getDouble("ploidy"));

                if (genes.containsKey(gene)) {
                    genes.get(gene).put(sample, cn);
                } else {
                    HashMap<String, String> map = new HashMap<>();
                    map.put(sample, cn);
                    genes.put(gene, map);
                }

                ploidyMap.put(sample, ploidy + "");

            }

            ArrayList<String> samples = new ArrayList<>();
            samples.addAll(ploidyMap.keySet());

            Collections.sort(samples);

            for (String key : ploidyMap.keySet()) {
                result.append(key + ":" + ploidyMap.get(key) + ",");
            }

            result.append("|");

            // build the column definitions gene then one or more samples
            result.append("['Gene'");
            for (String sam : samples) {
                result.append(",'").append(sam).append(" Sample Ploidy:").append(ploidyMap.get(sam)).append("'");
            }
            result.append("]");

            // group the expression values by gene across one or more samples
            ArrayList<String> geneList = new ArrayList<>();
            geneList.addAll(genes.keySet());
            Collections.sort(geneList);
            for (String g : geneList) {
                result.append(",['").append(g).append("'");
                HashMap<String, String> map = genes.get(g);
                for (String sam : samples) {
                    if (map.get(sam) != null) {
                        result.append(",").append(map.get(sam));
                    } else {
                        result.append(",null");
                    }
                }
                result.append("]");
            }

            if (genes.size() == 0) {
                result.delete(0, result.length());
            }

        } catch (Exception e) {
            log.error(e);
        }
        return result.toString();

    }

    private void buildIDList() {

        HashMap<String, String> idMap = new HashMap<>();
        for (PDXMouse mouse : allMice) {

            modelMap.put(mouse.getModelID(), mouse);

            idMap.put(mouse.getModelID() + " " + mouse.getPrimarySite() + " " + mouse.getInitialDiagnosis(), mouse.getModelID());

            // we want to be able to search on previous IDs as well
            String pid = mouse.getPreviousID();
            // for Baylor models we want to use MRN as previous ID
            String mrn = mouse.getMrn();
            if (mrn != null && mrn.startsWith("BCM")) {
                pid = mrn;
                mouse.setPreviousID(pid);
            }

            if (pid != null && pid.trim().length() > 0) {
                // oh the humanity, the ExtJS combobox won't work if IDs are duplicated so we need to pad these  with a space right here ---V
                idMap.put(pid + " (" + mouse.getModelID() + ") " + mouse.getPrimarySite() + " " + mouse.getInitialDiagnosis(), mouse.getModelID() + " ");
            }

            if (RelatedModels.getProxeId(mouse.getModelID()) != null) {
                idMap.put(RelatedModels.getProxeId(mouse.getModelID()) + " (" + mouse.getModelID() + ") " + mouse.getPrimarySite() + " " + mouse.getInitialDiagnosis(), mouse.getModelID() + "  ");
            }
        }

        String[] idArray = idMap.keySet().toArray(new String[idMap.size()]);
        // unfortunately this sorts by actual id not displayed id.... hrmph
        Arrays.sort(idArray);

        StringBuilder sb = new StringBuilder("[");
        for (String id : idArray) {
            sb.append("['").append(idMap.get(id)).append("','").append(id.replaceAll("'", "")).append("'],");
        }
        sb.replace(sb.length() - 1, sb.length(), "]");
        this.idList = sb.toString();

    }

    public String getIds() {
        return this.idList;
    }

    public HashMap<String, HashMap<String, ArrayList<String>>> getComparisonData(ArrayList<String> models, ArrayList<String> genes) {

        HashMap<String, HashMap<String, ArrayList<String>>> results = new HashMap<>();

        StringBuffer query = new StringBuffer(GENE_EXPRESSION);

        query.append(DAOUtils.collectionToString(genes, ",", ""));

        // this seems ok with 400 or so models but may be problematic if that grows a lot?
        query.append("&model=").append(DAOUtils.collectionToString(models, ",", ""));

        DecimalFormat df = new DecimalFormat("###.##");
        try {

            /* build ampDel map
            for each gene in list query for amp gene -> amp samples
                                  query for del gene -> del samples
            get(gene).get(model)->amp or del
             */
            HashMap<String, HashMap<String, String>> ampDelMap = new HashMap<>();
            JSONObject job;
            for (String gene : genes) {
                job = new JSONObject(getJSON(CNV_AMP + gene));
                JSONArray array = (JSONArray) job.get("data");
                HashMap<String, String> ad = new HashMap<>();
                for (int i = 0; i < array.length(); i++) {
                    JSONObject data = array.getJSONObject(i);
                    ad.put(data.getString("sample_name"), "Amplification");
                }
                job = new JSONObject(getJSON(CNV_DEL + gene));
                array = (JSONArray) job.get("data");
                for (int i = 0; i < array.length(); i++) {
                    JSONObject data = array.getJSONObject(i);
                    ad.put(data.getString("sample_name"), "Deletion");
                }
                ampDelMap.put(gene, ad);
            }

            job = new JSONObject(getJSON(query.toString()));
            JSONArray array = (JSONArray) job.get("data");
            for (int i = 0; i < array.length(); i++) {
                JSONObject data = array.getJSONObject(i);
                String model = data.getString("model_name");
                String gene = data.getString("gene_symbol");
                String sample = data.getString("sample_name");
                String passage = getField(data, "passage_num");
                String platform = getField(data, "platform");

                // this will fail for baylor and dfci models wich should be used
                // to exclude them from the results.
                try {
                    String rankZ = df.format(data.getDouble("z_score_percentile_rank"));

                    String ampDel = null;
                    try {
                        ampDel = ampDelMap.get(gene).get(sample);
                    } catch (NullPointerException npe) {
                        // its normal or ?unknown?
                    }
                    if (ampDel == null) {
                        ampDel = "Unknown";
                    }

                    if (results.containsKey(gene)) {
                        HashMap<String, ArrayList<String>> samples = results.get(gene);
                        ArrayList<String> list = new ArrayList<>();
                        list.add(rankZ);
                        list.add(ampDel);
                        list.add("mutation");
                        samples.put(model + "-" + sample + " " + passage, list);
                    } else {
                        HashMap<String, ArrayList<String>> samples = new HashMap<>();
                        ArrayList<String> list = new ArrayList<>();
                        list.add(rankZ);
                        list.add(ampDel);
                        list.add("mutation");
                        samples.put(model + "-" + sample + " " + passage, list);
                        results.put(gene, samples);
                    }
                } catch (Exception e) {
                    // ok skipping Baylor or DFCI model
                    System.out.println("skipping model " + model + " with platform " + platform);
                }

            }
        } catch (JSONException e) {
            log.error(e);
        } finally {

        }

        return results;

    }

    public ArrayList<PDXMouse> getMiceByGeneVariant(ArrayList<PDXMouse> mice, String gene, ArrayList<String> variants) {

        ArrayList<PDXMouse> matchingMice = new ArrayList<>();
        StringBuilder ids = new StringBuilder();
        StringBuilder variantList = new StringBuilder();

        for (String variant : variants) {
            variantList.append(variant).append(",");
        }
        StringBuilder params = new StringBuilder();

        params.append("?gene_symbol=").append(gene);
        if (variants != null && variants.size() > 0) {
            params.append("&amino_acid_change=").append(variantList.toString());
        }

        HashMap<String, ArrayList<StringBuilder>> data = new HashMap<>();
        try {
            JSONObject job = new JSONObject(getJSON(VARIANTS + params.toString()));

            JSONArray jarray = job.getJSONArray("data");
            for (int i = 0; i < jarray.length(); i++) {

                String id = getField(jarray.getJSONObject(i), "model_name");
                String consequence = getField(jarray.getJSONObject(i), "consequence").replace("\"", "");
                String aaChange = getField(jarray.getJSONObject(i), "amino_acid_change");

                ArrayList<StringBuilder> list = data.get(id);
                if (list != null) {
                    // skip duplicates
                    if (list.get(0).indexOf(consequence) == -1) {
                        if (list.get(0).length() > 0) {
                            list.get(0).append(", ");
                        }

                        list.get(0).append(consequence);
                    }

                    // skip duplicates
                    if (list.get(1).indexOf(aaChange) == -1) {
                        if (list.get(1).length() > 0) {
                            list.get(1).append(", ");
                        }

                        list.get(1).append(aaChange);
                    }
                } else {
                    list = new ArrayList<>();
                    list.add(new StringBuilder(consequence));
                    list.add(new StringBuilder(aaChange));
                    data.put(id, list);
                }
            }

            // now for each id in the map get the mouse from mice
            // then add the appropriate conseqeunce and variant
            for (String id : data.keySet()) {
                for (PDXMouse mouse : mice) {
                    if (compareIDs(mouse.getModelID(), id)) {
                        mouse.setConsequence(data.get(id).get(0).toString());
                        mouse.setVariant(data.get(id).get(1).toString());
                        mouse.setGene(gene);
                        matchingMice.add(mouse);
                    }
                }
            }

        } catch (JSONException e) {
            log.error("Error getting mice by gene variants", e);

        }

        return matchingMice;
    }

    public ArrayList<String> getVariants(String gene) {

        String query = VARIANTS_FOR_GENE + gene;
        ArrayList<String> variants = new ArrayList<>();
        try {
            JSONObject job = new JSONObject(getJSON(query));

            JSONArray array = (JSONArray) job.get("data");

            for (int i = 0; i < array.length(); i++) {
                String variant = array.getJSONObject(i).getString("amino_acid_change");
                if (variant != null && !variant.equals("null")) {
                    variants.add(variant);
                }
            }
            Collections.sort(variants);

        } catch (Exception e) {
            log.error("Error getting variants for gene " + gene, e);
        }

        return variants;

    }

    public String getVariationData(String model, String limit, String start, String sort, String dir, String ctp) {

        StringBuffer result = new StringBuffer("{'total':");
        boolean ckbSort = false;
        try {
            ckbSort = sort.startsWith("ckb_");
        } catch (Exception e) {
            log.debug("'" + sort + "' cant be parsed as sort field");
        }

        String params = "?keepnulls=yes&model=" + model + "&skip=" + start + "&limit=" + limit + "&sort_by=" + sort + "&sort_dir=" + dir;

        if (ctp != null) {
            params = params + "&all_ctp_genes=yes";
        }

        try {

            JSONObject job = new JSONObject(getJSON(VARIANTS + params));

            String total = "0";
            try {
                total = ((Integer) job.get("total_rows")).toString();
            } catch (JSONException jse) {
                // will happen if there are no results
            }
            result.append(total);

            JSONArray array = (JSONArray) job.get("data");

            result.append(",'variation':[ ");

            result.append(getVariantFields(array, ckbSort));

            result.replace(result.length() - 1, result.length(), "]}");

        } catch (Exception e) {
            log.error("Error getting variants for " + model + " from " + VARIANTS + params, e);

            result.append("0,'variation':[ ]}");

        }

        String resultStr = result.toString().replaceAll("null", " ");

        return resultStr;
    }

    // need to paginate results in lots of 150000 so we dont crush the server.
    // only applies to a few models
    public String getCSVVariants(String model) {

        StringBuilder result = new StringBuilder("Model,Sample,Gene,Platform,Chromosome,Seq Position,Ref Allele,Alt Allele,");
        result.append("Consequence,Amino Acid Change,RS Variants,Read Depth,Allele Frequency,Transcript ID,Filtered Rationale,Filter,");
        result.append("Passage Num,CKB Molecular Profile Link, CKB Molecular Profile Name, CKB Gene Link,CKB Potential Treatment Appr,CKB Protein Effect,No. clinical annotations predicting sensitivity,");
        result.append("No. preclinical annotations predicting sensitivity,No. clinical annotations predicting resistance,No. preclinical annotations predicting resistance,");
        result.append("Count Human Reads,PCT Human Reads");

        int start = 0;
        int limit = 15000;
        JSONArray array;
        boolean done = false;

        try {

            do {

                String params = "?keepnulls=yes&model=" + model + "&skip=" + start + "&limit=" + limit;
                JSONObject job = new JSONObject(getJSON(VARIANTS + params));

                // from public logs this fails occasinally
                int total = (Integer) job.get("total_rows");

                done = (total < start);

                array = (JSONArray) job.get("data");

                result.append("\n ");

                result.append(getVariantFields(array, false).replaceAll("'", "").replaceAll("null", " ").replaceAll("\\[", "").replaceAll("\\],", "\n"));

                start += limit;

            } while (array.length() > 0 || !done);

        } catch (Exception e) {
            log.error("Error getting variants for " + model, e);

        }

        return result.toString();

    }

    private String getVariantFields(JSONArray array, boolean ckbSort) throws JSONException {

        // some ckb annotations are private if a ckb field is used to sort we want the private ones at the end
        // otherwise the sort has gaps where private values are hidden.
        // so stash the private results and append them at the end.
        // will have odd effect over pagination but better than nothing...
        StringBuilder finalResult = new StringBuilder();
        StringBuilder result = new StringBuilder();
        StringBuilder stashedResult = new StringBuilder();

        for (int i = 0; i < array.length(); i++) {
            boolean stash = false;
            result.append("['").append(getField(array.getJSONObject(i), "model_id")).append("',");
            result.append("'").append(getField(array.getJSONObject(i), "sample_name")).append("',");
            result.append("'").append(getField(array.getJSONObject(i), "gene_symbol")).append("',");
            result.append("'").append(getField(array.getJSONObject(i), "platform")).append("',");
            result.append("'").append(getField(array.getJSONObject(i), "chromosome")).append("',");
            result.append("'").append(getField(array.getJSONObject(i), "seq_position")).append("',");
            result.append("'").append(getField(array.getJSONObject(i), "ref_allele")).append("',");
            result.append("'").append(getField(array.getJSONObject(i), "alt_allele")).append("',");
            result.append("'").append(getField(array.getJSONObject(i), "consequence")).append("',");
            result.append("'").append(getField(array.getJSONObject(i), "amino_acid_change")).append("',");
            result.append("'").append(getField(array.getJSONObject(i), "rs_variants")).append("',");
            result.append("'").append(getField(array.getJSONObject(i), "read_depth")).append("',");
            result.append("'").append(getField(array.getJSONObject(i), "allele_frequency")).append("',");
            result.append("'").append(getField(array.getJSONObject(i), "transcript_id")).append("',");
            result.append("'").append(getField(array.getJSONObject(i), "filtered_rationale")).append("',");

            if (!WIConstants.getInstance().getPublicDeployment()) {
                result.append("'").append(getField(array.getJSONObject(i), "filter")).append("',");
            } else {
                result.append("'',");
            }

            result.append("'").append(getField(array.getJSONObject(i), "passage_num")).append("',");

            String ckbGeneID = getField(array.getJSONObject(i), "ckb_gene_id");
            String entrezGeneID = getField(array.getJSONObject(i), "entrez_gene_id");

            result.append("'").append(entrezGeneID).append("',");

            String ckbMolProID = getField(array.getJSONObject(i), "ckb_molpro_id");
            String ckbMolProName = getField(array.getJSONObject(i), "ckb_molpro_name");
            String ckbTreatment = getField(array.getJSONObject(i), "ckb_potential_treat_approach");
            boolean ckbPublic = "public".equals(getField(array.getJSONObject(i), "ckb_public_status"));

            if (WIConstants.getInstance().getPublicDeployment()) {

                if (ckbMolProName.length() > 0 && !ckbMolProName.equals("null")) {
                    if (ckbPublic) {
                        result.append("'").append(CKB_MOLPRO_PUBLIC).append(ckbMolProID).append("',");
                    } else {
                        result.append("'").append(CKB_HOME).append("',");
                    }
                } else {
                    result.append("'',");
                }

                result.append("'").append(ckbMolProName).append("',");

                if (ckbTreatment.trim().length() > 0 && !ckbTreatment.equals("null")) {
                    if (ckbPublic) {
                        result.append("'").append(CKB_MOLPRO_PUBLIC).append(ckbMolProID).append("',");
                    } else {
                        result.append("'").append(CKB_HOME).append("',");
                    }
                } else {
                    result.append("'',");
                }

                result.append("'").append(ckbTreatment).append("',");
                result.append("'").append(getField(array.getJSONObject(i), "ckb_protein_effect")).append("',");

            } else {
                //link to internal site
                if (ckbMolProName.length() > 0 && !ckbMolProName.equals("null")) {
                    result.append("'").append(CKB_MOLPRO_INTERNAL).append(ckbMolProID).append("',");
                    result.append("'").append(ckbMolProName).append("',");
                } else {
                    result.append("'',");
                    result.append("'',");

                }
                if (ckbTreatment.length() > 0 && !ckbTreatment.equals("null")) {
                    result.append("'").append(CKB_MOLPRO_INTERNAL).append(ckbMolProID).append("',");
                } else {
                    result.append("'',");
                }

                result.append("'").append(getField(array.getJSONObject(i), "ckb_potential_treat_approach")).append("',");
                result.append("'").append(getField(array.getJSONObject(i), "ckb_protein_effect")).append("',");

            }

            result.append("'").append(getField(array.getJSONObject(i), "ckb_nclinical_resist")).append("',");
            result.append("'").append(getField(array.getJSONObject(i), "ckb_nclinical_sens")).append("',");
            result.append("'").append(getField(array.getJSONObject(i), "ckb_npreclinical_resist")).append("',");
            result.append("'").append(getField(array.getJSONObject(i), "ckb_npreclinical_sens")).append("',");

            result.append("'").append(getField(array.getJSONObject(i), "count_human_reads")).append("',");
            result.append("'").append(getField(array.getJSONObject(i), "pct_human_reads")).append("'],");

            if (stash) {
                stashedResult.append(result);

            } else {
                finalResult.append(result);
            }
            result.delete(0, result.length());
        }

        finalResult.append(stashedResult);
        return finalResult.toString();
    }

    public Double getMinTMB() {
        return minTMB;
    }

    public Double getMaxTMB() {
        return maxTMB;
    }
    
    private void validateSearchParams(ArrayList<String> tissues, ArrayList<String> diagnoses,ArrayList<String> tags){
        
        ArrayList<String> ps = this.getPrimarySitesList();
        ArrayList<String> diags = this.getDiagnosesList();
        ArrayList<String> tgs = this.getTagsList();
        
        
        ArrayList<String> cleanTissues = new ArrayList<String>();
        for(String tissue : tissues){
        
            if(ps.contains(tissue)){
               cleanTissues.add(tissue);
            }
        }
        tissues = cleanTissues;
        
        ArrayList<String> cleanDiagnoses = new ArrayList<String>();
        for(String diagnosis : diagnoses){
            
            if(diags.contains(diagnosis)){
               cleanDiagnoses.add(diagnosis);
            }
        }
        diagnoses = cleanDiagnoses;
        
        ArrayList<String> cleanTags = new ArrayList<String>();
        for(String tag : tags){
            
            if(tgs.contains(tag)){
               cleanTags.add(tag);
            }
        }
        tags = cleanTags;
        
    }

    private String getField(JSONObject job, String field) {
        String val = "";
        try {

            val = job.get(field).toString();
            val = val.replaceAll(",", ";");
            val = val.replaceAll("'", "");

        } catch (Exception e) {
            // if the field value is null it may not be included as a field in the json so skip it
            //  log.error("Unable to get value for " + field + " from json object");
        }

        return val;
    }

    private ArrayList<String> getFusionModels(String fusionGenes) {
        ArrayList<String> models = new ArrayList<>();
        HashMap<String, String> modelsMap = new HashMap<>();
        try {
            String url = FUSION_MODELS_BY_GENE +"&gene="+ fusionGenes;
            JSONObject job = new JSONObject(getJSON(url));
            JSONArray jarray = (JSONArray) job.get("data");
            for (int i = 0; i < jarray.length(); i++) {
                modelsMap.put(jarray.getJSONObject(i).getString("model_name"), jarray.getJSONObject(i).getString("model_name"));
            }

        } catch (Exception e) {
            log.error("Unable to load fusion modles for " + fusionGenes, e);
        }
        models.addAll(modelsMap.keySet());
        return models;
    }

    private void loadFusionGenes() {
      //  StringBuilder fusionGeneList = new StringBuilder();
        try {
            JSONObject job = new JSONObject(getJSON(FUSION_GENES));
            JSONArray jarray = (JSONArray) job.get("data");
            for (int i = 0; i < jarray.length(); i++) {
                LabelValueBean<String, String> bean = new LabelValueBean<>();
                bean.setLabel(jarray.getString(i).trim());
                bean.setValue(jarray.getString(i).trim());

                fusionGenesLVB.add(bean);
               // fusionGeneList.append(jarray.getString(i).trim()).append(",");
            }

        } catch (Exception e) {
            log.error("Unable to load fusion genes", e);
        }
       
    }

    private void loadFusionModels() {

        // models have samples, samples have variants 
        HashMap<String, HashMap<String, HashMap<String, String>>> map = new HashMap<>();

        try {

            JSONObject job = new JSONObject(getJSON(FUSION_MODELS_BY_GENE));
            JSONArray jarray = (JSONArray) job.get("data");
            for (int i = 0; i < jarray.length(); i++) {
                try {
                    String model = jarray.getJSONObject(i).getString("model_name");

                    String sample = jarray.getJSONObject(i).getString("sample_name");
                    String variant = jarray.getJSONObject(i).getString("fusion_name");

                    if (map.containsKey(model)) {
                        if (map.get(model).containsKey(sample)) {
                            map.get(model).get(sample).put(variant, variant);
                        } else {
                            HashMap<String, String> variants = new HashMap<>();
                            variants.put(variant, variant);
                            map.get(model).put(sample, variants);
                        }
                    } else {
                        HashMap<String, HashMap<String, String>> sampleMap = new HashMap<>();
                        HashMap<String, String> variants = new HashMap<>();
                        variants.put(variant, variant);
                        sampleMap.put(sample, variants);
                        map.put(model, sampleMap);
                    }
                } catch (Exception e) {
                    // some data objects don't have ckb_varaint
                }
            }
            for (String model : map.keySet()) {
                StringBuilder display = new StringBuilder();
                for (String sample : map.get(model).keySet()) {
                    display.append("Sample ").append(sample).append(" has fusion gene");

                    if (map.get(model).get(sample).keySet().size() > 1) {
                        display.append("s");
                    }
                    for (String variant : map.get(model).get(sample).keySet()) {

                        display.append(" ").append(variant).append(",");
                    }
                    // remove trailing comma
                    display.replace(display.length() - 1, display.length(), "");
                    if (map.get(model).size() > 1) {
                        display.append("<br>");
                    }
                    
                  
                }

                fusionModelsMap.put(model, display.toString());
            }
        } catch (Exception e) {
            log.error("Unable to load fusion models from" + FUSION_MODELS_BY_GENE + e);
        }
    }

    // need to get passage number using sample name and display it with each plot
    private void loadCNVPlots() {

        cnvPlots.clear();

        try {
            String path = WIConstants.getInstance().getCNVPlotsPath();
            File cnvFile = new File(path);
            for (File file : cnvFile.listFiles()) {
                try {
                    String name = file.getName();

                    String model = file.getName().split("_")[0];
                    String sample = file.getName().split("_")[1];
                    String passage = file.getName().split("_")[2];
                    // String passage = getSamplePassage(model,sample);

                    StringBuilder label = new StringBuilder();
                    label.append("Model:").append(model);
                    label.append(" Sample:").append(sample);
                    if (passage.length() > 1) {
                        label.append(" Passage:").append(passage);
                    }

                    // no patient plots for public
                    if (WIConstants.getInstance().getPublicDeployment() && "PT".equals(passage.toUpperCase())) {
                        continue;
                    }

                    ArrayList<String> details = new ArrayList<>();
                    details.add(label.toString());
                    details.add(name);

                    if (cnvPlots.containsKey(model)) {
                        ArrayList<ArrayList<String>> files = cnvPlots.get(model);
                        if ("PT".equals(passage)) {
                            files.add(0, details);
                        } else {
                            String lastDetails = files.get(files.size() - 1).get(0);
                            String lastPassage = lastDetails.substring(lastDetails.length() - 3);
                            if (lastPassage.compareTo(passage) < 0) {
                                files.add(files.size() - 1, details);
                            } else {
                                files.add(details);
                            }

                        }
                    } else {
                        ArrayList<ArrayList<String>> files = new ArrayList<>();
                        files.add(details);
                        cnvPlots.put(model, files);

                    }
                } catch (Exception e) {
                    log.error("unable to parse cnvPlot file" + file.getName());
                }
            }

            // sort PT first then P0,P1,...
            Compy compy = new Compy();
            for (ArrayList<ArrayList<String>> s : cnvPlots.values()) {
                Collections.sort(s, compy);

            }
        } catch (Exception e) {
            log.error("Unable to load cnv plots", e);
        }

    }

    // returns an array list of plot URLs
    public ArrayList<ArrayList<String>> getCNVPlotsForModel(String modelID) {

//        if("J000112064".equals(modelID) || "J000111644".equals(modelID)){
//            log.warn("hiding CNV plots for model "+modelID);
//            return null;
//        }
        return cnvPlots.get(modelID);
    }

    private String getSamplePassage(String model, String sample) {
        String passage = "";
        String query = PDXMouseStore.SAMPLE_PASSAGE;
        query = query.replace("MODEL_ID", model).replace("SAMPLE_ID", sample);

        try {
            JSONObject job = new JSONObject(getJSON(query));
            JSONArray jarray = job.getJSONArray("data");
            passage = jarray.getJSONObject(0).getString("passage_num");

        } catch (Exception e) {
            log.error("unable to get passage for model:" + model + " and sample:" + sample);
        }
        return passage;

    }

    private void loadTMBData() {

        DecimalFormat df = new DecimalFormat("###.##");
        df.setRoundingMode(RoundingMode.CEILING);

        try {
            JSONObject job = new JSONObject(getJSON(TMB_URI));

            JSONArray jarray = job.getJSONArray("data");
            for (int i = 0; i < jarray.length(); i++) {
                try {
                    job = jarray.getJSONObject(i);
                    String model = job.getString("model_name");
                    String sample = job.getString("sample_name");
                    String passage = job.getString("passage_num");

                    // no patient data for public
                    if (WIConstants.getInstance().getPublicDeployment() && "PT".equals(passage.toUpperCase())) {
                        continue;
                    }

                    if (passage != null && !passage.equals("null")) {
                        sample += " from passage " + passage;
                    }

                    Double tmb = new Double(df.format(job.getDouble("tmb_score")));

                    if (tmb > maxTMB) {
                        maxTMB = tmb;
                    }
                    if (tmb < minTMB) {
                        minTMB = tmb;
                    }

                    if (tmbMap.containsKey(model)) {
                        tmbMap.get(model).put(sample, tmb);
                    } else {
                        HashMap<String, Double> map = new HashMap<>();
                        map.put(sample, tmb);
                        tmbMap.put(model, map);
                    }
                    try {
                        Double msi = job.getDouble("msi_score");
                        String msiStr = "MSI-S";
                        if (msi > 20) {
                            msiStr = "MSI-H";
                        }

                        MSIModels.addMSI(model, "Sample:" + sample + " &nbsp; &nbsp; Score:" + msiStr);

                    } catch (Exception e) {
                        //not sure what to log
                    }

                } catch (Exception e) {
                    // may happen if tmb is null;
                }
            }

        } catch (Exception e) {
            log.error("Unable to load TMB data", e);
        }

    }
    
    private void loadGenomicsLinks(){
        
        for(PDXMouse mouse : allMice){
            try{
                 ArrayList<GenomicsLink> cnv = new ArrayList<>();
                 ArrayList<GenomicsLink> expression = new ArrayList<>();
                 ArrayList<GenomicsLink> variation = new ArrayList<>();
                
                JSONArray jArray = new JSONArray(getJSON(linkOuts+mouse.getModelID()));
                for(int i = 0; i < jArray.length(); i++){
                   
                    JSONObject job = jArray.getJSONObject(i);
                    String type = job.getString("datatype");
                    GenomicsLink link = new GenomicsLink();
                    link.setDerivedLink(job.getString("derived_data_url"));
                    link.setPassage(job.getString("passage_num"));
                    link.setPlatform(job.getString("platform"));
                    link.setSample(job.getString("sample_name"));
                    JSONArray rawLinks = job.getJSONArray("raw_data_urls");
                    for(int j=0; j < rawLinks.length(); j++){
                        link.addRawLinks(rawLinks.getString(j));
                    }
                    if("expression".equalsIgnoreCase(type)){
                        expression.add(link);
                        continue;
                    }
                    if("variation".equalsIgnoreCase(type)){
                        variation.add(link);
                        continue;
                    }
                    if("cnv".equalsIgnoreCase(type)){
                        cnv.add(link);
                    }
                    
                }
                mouse.setExpressionLinks(expression);
                mouse.setCnvLinks(cnv);
                mouse.setVariationLinks(variation);
                
            }catch(Exception e){
                log.error("error getting linkouts",e);
            }
            
        }
        
    }
    

    /**
     *
     * @param gene String gene name
     * @param mice ArrayList<PDXMouse> all mice from query results
     * @return String to graph expression of gene across all mice
     */
    public String getExpressionGraph(ArrayList<PDXMouse> mice, String gene, boolean cnv) {

        HashMap<String, String> ampDel = new HashMap<>();
        if (cnv) {
            ampDel = getAmpDel(gene);
        }

        DecimalFormat df = new DecimalFormat("#.##");

        StringBuffer result = new StringBuffer();

        //batch query at 100 mice
        int i = 0;
        String model, sample, passage, ampDelStr;
        Double rankZ;
        HashMap<String, String> modelDiagnosis = new HashMap();

        while (i < mice.size()) {

            StringBuffer mouseIDs = new StringBuffer();
            for (int j = 0; (j < 100) && (i < mice.size()); j++) {
                if (!DANA_FARBER.equals(mice.get(i).getInstitution()) && !BAYLOR.equals(mice.get(i).getInstitution())) {
                    mouseIDs.append(mice.get(i).getModelID()).append(",");

                    modelDiagnosis.put(mice.get(i).getModelID(), mice.get(i).getClinicalDiagnosis().replaceAll("'", "").toLowerCase());
                }
                i++;
            }

            if(mouseIDs.length()>0){
                mouseIDs.deleteCharAt(mouseIDs.length() - 1);

                StringBuffer query = new StringBuffer(GENE_EXPRESSION).append(gene);
                query.append("&model=").append(mouseIDs);

                try {

                    JSONObject job = new JSONObject(getJSON(query.toString()));

                    JSONArray jarray = job.getJSONArray("data");

                    for (int k = 0; k < jarray.length(); k++) {
                        model = jarray.getJSONObject(k).getString("model_name");
                        sample = jarray.getJSONObject(k).getString("sample_name");
                        passage = getField(jarray.getJSONObject(k), "passage_num");
                        rankZ = jarray.getJSONObject(k).getDouble("z_score_percentile_rank");

                        if (cnv) {
                            ampDelStr = "Normal";
                            if (ampDel.containsKey(model)) {
                                ampDelStr = ampDel.get(model);
                            }
                            result.append("['" + model + " : " + sample + "','" + modelDiagnosis.get(model) + "'," + df.format(rankZ) + ",'" + model + "','" + ampDelStr + "'],");
                        } else {
                            result.append("['").append(model).append(" : ").append(sample);
                            result.append(" ").append(passage).append("',");
                            result.append("'").append(modelDiagnosis.get(model)).append("',");
                            result.append(df.format(rankZ)).append(",'").append(model).append("'],");
                        }
                    }

                } catch (JSONException e) {
                    log.error(e);
                }
            }
        }
        if (result.length() > 0) {
            result.deleteCharAt(result.length() - 1);
        }

        return result.toString();

    }

    public int getPDXFinderModelCount() {
        int count = 0;
        try {
            JSONObject json = new JSONObject(getJSON("https://www.pdxfinder.org/data/graphdata"));
            JSONArray providers = json.getJSONArray("providers");
            for (int i = 0; i < providers.length(); i++) {
                count += providers.getJSONObject(i).getInt("number");
            }

        } catch (JSONException jse) {
            log.error("Can not get PDXFinder model count.", jse);

        }
        return count;
    }

    private HashMap<String, String> getAmpDel(String gene) {
        //Amplification, Deletion, Normal

        HashMap<String, String> ampDel = new HashMap<>();

        try {

            JSONObject job = new JSONObject(getJSON(CNV_AMP + gene));

            JSONArray jarray = job.getJSONArray("data");

            for (int i = 0; i < jarray.length(); i++) {

                ampDel.put(jarray.getJSONObject(i).getString("model_name"), "Amplification");
            }

            job = new JSONObject(getJSON(CNV_DEL + gene));

            jarray = job.getJSONArray("data");

            for (int i = 0; i < jarray.length(); i++) {

                ampDel.put(jarray.getJSONObject(i).getString("model_name"), "Deletion");
            }

        } catch (JSONException e) {
            log.error(e);
        }
        return ampDel;
    }

    

   

    private class Compy implements Comparator<ArrayList<String>> {

        public int compare(ArrayList<String> a, ArrayList<String> b) {

            String sampleA = a.get(1).split("_")[1];
            String passageA = a.get(1).split("_")[2];

            String sampleB = b.get(1).split("_")[1];
            String passageB = b.get(1).split("_")[2];

            if (sampleA.equals(sampleB)) {

                if ("PT".equals(passageA)) {
                    return 1;
                } else {
                    return passageA.compareTo(passageB);

                }

            } else if (sampleA.length() == sampleB.length()) {
                return sampleA.compareTo(sampleB);
            } else {
                return (sampleA.length() > sampleB.length()) ? 1 : -1;
            }

        }
    }
}
