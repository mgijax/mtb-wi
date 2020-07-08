/**
 * Header: $Header: /mgi/cvsroot/mgi/mtb/mtbwi/src/java/org/jax/mgi/mtb/wi/actions/SolrAction.java,v 1.1 2016/04/05 20:18:41 sbn Exp $
 * Author: $Author: sbn $
 */
package org.jax.mgi.mtb.wi.pdx;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.Arrays;
import org.apache.log4j.Logger;
import org.jax.mgi.mtb.dao.custom.mtb.pdx.PDXMouse;
import org.jax.mgi.mtb.wi.WIConstants;

/**
 * Get data and build data structure to generate the mouse models table.
 *
 * Soft tissue is an issue
 *
 * Need to add sort order for PDX query
 *
 */
public class ModelCounts {

    private final static Logger log
            = Logger.getLogger(ModelCounts.class.getName());

    public static final String HTISSUE = "&fq=humanTissue%3A";
    public static final String MUTANT = "&fq=mutant%3Atrue";
    public static final String NONMUTANT = "&fq=mutant%3Afalse";
    public static final String ANY = "";

    public static final String NUMFOUND = "numFound\":";

     String[] pdxTerms = {"Lung",
        "Blood,Bone marrow,Lymph node",
        "Anal,Appendix,Cecum,Colon,Duodenum,Rectum,ampulla of Vater",
        "Pancreas",
        "Breast",
        "Liver,Bile duct",
        "Prostate gland",
        "Brain",
        "Bladder",
        "Uterus,Endometrium",
        "Esophagus",
        "Kidney",
        "Ovary",
        "Skin",
        "Stomach",
        "Salivary gland,Tonsil",
        "Soft tissue,Pleural cavity",
        "--",
        "Adrenal gland",
        "Bone"};

    // for mouseover
    String[] labels = {"Lung, Bronchus, Larynx, Paranasal sinus, Trachea",
        "Leukemia, Lymphoma, Myeloma, Leukocyte, Blood, Bone marrow, Dendritic cell, Erythroblast, Erythrocyte, Hematopoietic stem cell, Lymph node, Lymphatic vessel, Lymphoid tissue, Peyer\\'s patch, Reticular cell, Reticulocyte, Spleen, Thymus",
        "Intestine, Small Intestine, Large Intestine, Duodenum, Jejunum, Ileum, Ileocecal Junction, Cecum, Colon, Rectum, Anus",
        "Pancreas",
        "Mammary gland",
        "Liver, Bile duct",
        "Prostate gland",
        "Brain, Meninges, Spinal cord, Nerve, Neuroblast, Neuroectoderm, Ganglion, Nerve sheath, Schwann cell",
        "Urinary bladder",
        "Uterus, Cervix",
        "Esophagus",
        "Kidney, Renal pelvis",
        "Ovary",
        "Skin, Skin gland",
        "Stomach, Forestomach (mouse-specific)",
        "Oral cavity, Pharynx, Gingiva, Mouth, Salivary gland, Tongue, Tooth",
        "Abdominal cavity, Abdominal wall, Adipose tissue, Connective tissue, Mediastinum, Mesodermal cell/mesoblast, Mesothelium, Muscle, Myoepithelial cell, Notochord, Pericardium, Pericyte, Periosteum, Perirenal tissue, Peritoneal cavity, Peritoneum, Pleura, Pleural cavity, Retroperitoneum, Thoracic cavity, Blood vessel, Heart",
        "Gallbladder",
        "Adrenal gland, Parathyroid gland, Pineal gland, Pituitary gland, Thyroid gland",
        "Bone, Cartilage, Ligament, Synovium, Tendon"};

    // display tissue, rank, fatalaties, solr term
    String[] tissues = {
        "Lung & other respiratory", "1", "147,510", "Lung",
        "Lymphohematopoietic", "2", "56,770", "Lymphohematopoietic",
        "Colon & other intestine", "3", "53,890", "Colon and other intestine",
        "Pancreas", "4", "45,750", "Pancreas",
        "Breast", "5", "42,260", "Breast",
        "Liver & bile duct", "6", "31,780", "Liver and bile duct",
        "Prostate", "7", "31,620", "Prostate",
        "Brain & other nervous system", "8", "17,760", "Brain and other nervous system",
        "Urinary bladder", "9", "17,670", "Urinary bladder",
        "Uterus & cervix", "10", "16,410", "Uterus and cervix",
        "Esophagus", "11", "16,080", "Esophagus",
        "Kidney & renal pelvis", "12", "14,770", "Kidney and renal pelvis",
        "Ovary", "13", "13,980", "Ovary",
        "Skin", "14", "11,650", "Skin",
        "Stomach", "15", "11,140", "Stomach",
        "Oral cavity & pharynx", "16", "10,860", "Oral cavity",
        "Soft tissue including heart", "17", "5,270", "Soft tissue including heart",
        "Gallbladder & other biliary", "18", "3,960", "Gallbladder",
        "Endocrine system", "19", "3,210", "Endocrine system",
        "Bones & joints", "20", "1,660", "Bone and joint"};

    ArrayList<ArrayList<String>> tissuesListList = new ArrayList<ArrayList<String>>();

    public static final String PDF_LINK ="https://www.cancer.org/content/dam/cancer-org/research/cancer-facts-and-statistics/annual-cancer-facts-and-figures/2019/cancer-facts-and-figures-2019.pdf";
    public static final String YEAR = "2019";
    private String solrURL;
    private String minFC = "&fq=minFC:[1%20TO%201]";
    private static String HTML = "";
    private static String HTMLALL = "";
    private static ArrayList<ArrayList<String>> dataObject = new ArrayList<>();

    public ModelCounts() {
        if (HTML.length() == 0) {
            solrURL = WIConstants.getInstance().getSolrURL() + "?q=*%3A*&&fq=minFC:[1%20TO%201]&wt=json";
            buildListList();
            HTML = buildHTML();
            // assume we will only use limited results in new WI for now
            dataObject = buildDataObject();

            tissuesListList = new ArrayList<>();
            solrURL = WIConstants.getInstance().getSolrURL() + "?q=*%3A*&&wt=json";
            minFC = "";
            buildListList();
            HTMLALL = buildHTML();
        }
        
       
    }

    public static void main(String[] args) {

        ModelCounts mc = new ModelCounts();

        System.out.println(mc.buildHTML());

    }
    
    public String getDataYear() {
	    return YEAR;
    }

    public String getHTML() {
        return HTML;
    }

    public String getHTMLAll() {
        return HTMLALL;
    }
    
    public ArrayList<ArrayList<String>> getDataObject(){
        return dataObject;
    }

    private void buildListList() {

        for (int i = 0; i < tissues.length;) {

            ArrayList<String> list = new ArrayList<String>();
            for (int j = 0; j < 4; j++) {
                list.add(tissues[i++]);
            }
            tissuesListList.add(list);
        }

        int cnt = 0;
        for (ArrayList<String> list : tissuesListList) {

            list.add(getCounts(list.get(3), ModelCounts.MUTANT));
            list.add(getCounts(list.get(3), ModelCounts.NONMUTANT));
            list.add(getCounts(list.get(3), ModelCounts.ANY));

            list.add(0, labels[cnt]);
            list.add(makePDXLink(pdxTerms[cnt]));
            list.add(getPDXCounts(pdxTerms[cnt]));

            cnt++;

        }

    }

    private String getPDXCounts(String terms) {

        PDXMouseStore store = new PDXMouseStore();
        String[] termsSplit = terms.split(",");

        String modelID = "";
        ArrayList<String> primarySites = new ArrayList<String>(Arrays.asList(termsSplit));
        ArrayList<String> diagnoses = new ArrayList<String>();
        ArrayList<String> tags = new ArrayList<String>();
        ArrayList<String> types = new ArrayList<String>();
        ArrayList<String> markers = new ArrayList<String>();

        String gene = "";
        ArrayList<String> variants = null;

        String fusionGenes = "";
        String recist = "";
        boolean drugResponse = false;
        boolean tumorGrowth = false;
        boolean treatmentNaive = false;

        ArrayList<PDXMouse> mice = store.findMice(modelID, primarySites, diagnoses,
                types, markers, gene, variants, drugResponse, tumorGrowth, tags,
                fusionGenes,treatmentNaive,recist,recist,null,null);

        return mice.size() + "";
    }

    private String makePDXLink(String tissue) {

        //gallbladder
        if (tissue.equals("--")) {
            return "";
        }

        String[] tissues = tissue.split(",");
        StringBuilder link = new StringBuilder("/mtbwi/pdxSearchResults.do?");

        for (String t : tissues) {
            link.append("primarySites=").append(t.replaceAll(" ", "+"));
            link.append("&");
        }

        return link.toString();
    }

    private String getCounts(String tissue, String mutant) {

        String count = "";
        try {

            String queryStr = HTISSUE + "\"" + tissue + "\"" + mutant;

            URL url = null;
            url = new URL(solrURL + queryStr.toString().replaceAll(" ", "%20"));

            String json = getJSON(url);

            count = json.substring(json.indexOf(NUMFOUND) + NUMFOUND.length());
            count = count.substring(0, count.indexOf(","));

        } catch (Exception e) {
            e.printStackTrace();
        }

        return count;
    }

    private String getJSON(URL url) throws Exception {

        //        System.out.println(url);
        HttpURLConnection connection
                = (HttpURLConnection) url.openConnection();

        connection.setRequestMethod("GET");

        connection.setDoOutput(true);
        connection.setDoInput(true);
        connection.setUseCaches(false);

        StringBuilder responseStr = new StringBuilder();
        String responseSingle;

        // Open a stream which can read the server response
        InputStream in = connection.getInputStream();
        try {
            BufferedReader rd = new BufferedReader(new InputStreamReader(in));
            while ((responseSingle = rd.readLine()) != null) {
                responseStr.append(responseSingle);
            }
            rd.close();

        } catch (IOException e) {
            log.error("failed getting response for solr query:" + url.toString(), e);
        } finally {
            if (in != null) {
                in.close();
                connection.disconnect();

            }
        }
        //     System.out.println(responseStr.toString());
        return responseStr.toString();

    }

    private String buildHTML() {

        StringBuilder html = new StringBuilder();
        html.append("<tbody>");

        for (ArrayList<String> vals : tissuesListList) {

            html.append("<tr>\n");
            html.append("<td data-tip=\"Corresponding mouse tissues in MMHCdb: " + vals.get(0) + "\">" + vals.get(1) + "</td>\n");

            html.append("<td>[" + vals.get(2) + "]</td>\n");
            html.append("<td>" + vals.get(3) + "</td>\n");

			String anchor = "<a target=\"_blank\" href=\"/mtbwi/facetedSearch.do?sort=hm&start=0" + minFC + "&fq=";
            String solrTissue = vals.get(4).replaceAll(" ", "+");

            if ("0".equals(vals.get(5))) {
                html.append("<td>" + vals.get(5) + "</td>\n");
            } else {
                html.append("<td>" + anchor + "mutant:true&fq=humanTissue%3A&quot;" + solrTissue + "&quot;\">" + vals.get(5) + "</a></td>\n");
            }

            if ("0".equals(vals.get(6))) {
                html.append("<td>" + vals.get(6) + "</td>\n");
            } else {
                html.append("<td>" + anchor + "mutant:false&fq=humanTissue%3A&quot;" + solrTissue + "&quot;\">" + vals.get(6) + "</a></td>\n");
            }

            if ("0".equals(vals.get(7))) {
                html.append("<td>" + vals.get(7) + "</td>\n");
            } else {
                html.append("<td>" + anchor + "humanTissue%3A&quot;" + solrTissue + "&quot;\">" + vals.get(7) + "</a></td>\n");
            }

            if ("0".equals(vals.get(9))) {
                html.append("<td>" + vals.get(9) + "</td>\n");
            } else {
                html.append("<td><a target=\"_blank\" href=\"" + vals.get(8) + "\">" + vals.get(9) + "</a></td>\n");
            }

            html.append("</tr>");
        }

        html.append("</tbody>");

        return html.toString();
    }
    
    
     private ArrayList<ArrayList<String>> buildDataObject() {

        ArrayList<ArrayList<String>> data = new ArrayList<>();
        // will need to incldue year and pdxLink as  

      
        for (ArrayList<String> vals : tissuesListList) {
            ArrayList<String> row = new ArrayList<>();
            
            row.add(vals.get(0));
            row.add(vals.get(1));
            row.add(vals.get(2));
            row.add(vals.get(3));
            
            String solrTissue = vals.get(4).replaceAll(" ", "+");
            String[] links = {
                "\"/mtbwi/facetedSearch.do?sort=hm&start=0" + minFC + "&fq=mutant:true&fq=humanTissue%3A&quot;" + solrTissue + "&quot;\"",
                "\"/mtbwi/facetedSearch.do?sort=hm&start=0" + minFC + "&fq=mutant:false&fq=humanTissue%3A&quot;" + solrTissue + "&quot;\"",
                "\"/mtbwi/facetedSearch.do?sort=hm&start=0" + minFC + "&fq=humanTissue%3A&quot;" + solrTissue + "&quot;\""
            };

            if ("0".equals(vals.get(5))) {
                row.add("");
            } else {
                row.add(links[0]);
            }
            
            row.add(vals.get(5));
            
            
            if ("0".equals(vals.get(6))) {
               row.add("");
            } else {
                row.add(links[1]);
            }
            
            row.add(vals.get(6));

            
            if ("0".equals(vals.get(7))) {
                row.add("");
            } else {
                row.add(links[2]);
            }
            row.add(vals.get(7));
            
            if ("0".equals(vals.get(9))) {
               row.add("");
            } else {
                row.add(vals.get(8));
            }
            
            row.add(vals.get(9));
            data.add(row);
        }
        return data;
    }

}
