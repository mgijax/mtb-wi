/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.jax.mgi.mtb.wi.pdx;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import org.apache.log4j.Logger;
import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONObject;
import static org.jax.mgi.mtb.wi.JSONUtils.getJSON;
import org.jax.mgi.mtb.wi.WIConstants;

/**
 *
 * @author sbn Query the SOC sqllite database for a list of PDX models that have
 * SOC graphs.
 */
public class SOCLoader {

    private static final Logger log
            = Logger.getLogger(SOCLoader.class.getName());

    private static String baseURL = WIConstants.getInstance().getPDXWebservice();
    private static String termsURL = baseURL + "drugstudies/drugterms";
    private static String socSearchURL = baseURL + "drugstudies/find_models";
    private static String allModelsURL = baseURL + "drugstudies/available/all";

    public static HashMap<String, Integer> loadSOCModels() {

        HashMap<String, Integer> models = new HashMap<>();

        try {

            JSONObject job = new JSONObject(getJSON(allModelsURL));
            JSONArray jarray = job.getJSONArray("data");
            for (int i = 0; i < jarray.length(); i++) {
                JSONObject subjob = jarray.getJSONObject(i);
                String[] id = subjob.getString("study_id").split("_");
                if (models.containsKey(id[0])) {
                    int count = models.get(id[0]);
                    models.put(id[0], count++);
                } else {
                    models.put(id[0], 1);
                }
            }

        } catch (Exception e) {
            log.error("Unable to load SOC model counts", e);
        }

        return models;
    }

    /**
     * Drug + Response -> list of models
     *
     * @return
     */
    public static ArrayList<String> getRECISTModels(String drug, String response) {

        ArrayList<String> models = new ArrayList<>();
        StringBuilder query = new StringBuilder();
        try {
            if (drug != null && drug.trim().length()>0) {
                query.append("?drug_term=" + drug);
            }
            if (response != null && response.trim().length()>0) {
                if (query.length() > 0) {
                    query.append("&");
                }else{
                    query.append("?");
                }
                    
                query.append("recist_term=" + response);
            }

            JSONObject job = new JSONObject(getJSON(socSearchURL+query.toString()));
            JSONArray jarray = job.getJSONArray("data");
            for (int i = 0; i < jarray.length(); i++) {
                models.add(jarray.getString(i));
            }

        } catch (Exception e) {
            log.error("Unable to find model for "+drug+" with response"+response, e);
        }

        return models;
    }

    //('Complete Response', 'Partial Response', 'Progressive Disease', 'Stable Disease')
    public static ArrayList<String> loadRECISTResponses() {
        ArrayList<String> response = new ArrayList<>();
        response.add("Complete Response");
        response.add("Partial Response");
        response.add("Progressive Disease");
        response.add("Stable Disease");
        return response;

    }

    //http://pdxdata.jax.org/api/drugstudies/drugterms
    // with is_control = 0;
    public static ArrayList<String> loadRECISTDrugs() {

        ArrayList<String> treatments = new ArrayList<>();

        try {
            JSONObject job = new JSONObject(getJSON(termsURL));
            JSONArray jarray = job.getJSONArray("data");
            for (int i = 0; i < jarray.length(); i++) {
                job = jarray.getJSONObject(i);
                if (job.getInt("is_control") == 0) {
                    treatments.add(job.getString("drug_term"));
                }
            }

        } catch (Exception e) {
            log.error("Unable to load SOC recist drug data", e);
        }

        return treatments;
    }

}
