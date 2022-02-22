/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.jax.mgi.mtb.wi;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import org.apache.log4j.Logger;

/**
 *
 * @author sbn
 */
public class JSONUtils {

    private static final Logger log = Logger.getLogger(JSONUtils.class.getName());

    private static String getFilterStr() {
        String filterStr = "filter=no";
        if (WIConstants.getInstance().getPublicDeployment()) {
            filterStr = "filter=yes";
        }
        return filterStr;
    }

    public static String getJSON(String uri) {
        return getJSON(uri, null);
    }

    public static String getJSON(String uri, String json) {

        if (uri.contains("?")) {
            uri = uri + "&" + getFilterStr();
        } else {
            uri = uri + "?" + getFilterStr();
        }

        uri = uri.replaceAll(" ", "+");

        boolean post = true;
        if (json == null || json.length() == 0) {
            post = false;
        } else {
            json = json.replaceAll(" ", "+");
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

                    log.error("Error writing to webservice " + uri, e);

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

                log.error("Error reading from webservice " + uri, e);

            } finally {
                if (in != null) {
                    in.close();
                }
            }
        } catch (IOException e) {
            log.error("Error connecting to webservice " + uri, e);
        } finally {
            if (connection != null) {
                connection.disconnect();
            }
        }

        return response.toString();

    }

}
