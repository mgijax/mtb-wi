/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.jax.mgi.mtb.wi.actions;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONObject;

/**
 *
 * @author sbn
 */
public class PivotAction extends Action {

    String accessToken;
    String refreshToken;
    
    public ActionForward execute(ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {
        
        tasks = new ArrayList<>();
        workspaceNames = new HashMap<>();
        
        String code = request.getParameter("code");
        String endpoint = request.getParameter("endpoint");
        if(endpoint == null || endpoint.isEmpty()){
            endpoint = "tasks?types=Todo,FileRequest,Approval";
            // for now just todos
            endpoint = "tasks?types=Todo";
        }
        
        if(accessToken == null){
         JSONObject job = new JSONObject(getToken(code,false));
         accessToken = job.getString("access_token");
         refreshToken = job.getString("refresh_token");
        }
        
         String apiResponse = getJSON(endpoint,accessToken);
         JSONObject joe = new JSONObject(apiResponse);
         
         if(endpoint.contains("tasks?")){
            JSONArray tasks = joe.getJSONArray("tasks");
            for(int i = 0;  i < tasks.length(); i++){
                buildTask(tasks.getJSONObject(i));
            }
         }
    //     System.out.println(joe);
    
    ArrayList<Task> workspace1 = new ArrayList<>();
    ArrayList<Task> workspace2 = new ArrayList<>();
         for(Task task : tasks){
             System.out.println(task.toString());
             System.out.println();
             if("PIVOT Workspace 2".equals(task.workspace)){
                 workspace2.add(task);
             }else{
                 workspace1.add(task);
             }
         }
         for(String workspace : workspaceNames.values()){
             System.out.println(workspace);
         }
         request.setAttribute("apiResponse",apiResponse);
         request.setAttribute("workspace1",workspace1);
         request.setAttribute("workspace2",workspace2);
        return  mapping.findForward("pivot");
    }
    
    public class Task{
        String title;
        String description;
        String type;
        String status;
        ArrayList<String> assignees = new ArrayList<>();
        Date createDate;
        Date updateDate;
        String owner;
        String completedBy;
        String link;
        int workspaceID;
        String workspace;
        
        public String toString(){
           StringBuilder sb = new StringBuilder();
           sb.append("Title:"+title).append("\n");
           sb.append("Desc:"+description).append("\n");
           sb.append("Type:"+type).append("\n");
           sb.append("Status:"+status).append("\n");
           sb.append("Owner:"+owner).append("\n");
           sb.append("Workspace:"+workspace).append("\n");
           sb.append("Assignees:");
           boolean comma = false;
           for(String assignee : assignees){
               if(comma){
                   sb.append(",");
               }
               comma = true;
               sb.append(assignee);
            }
           
            return sb.toString();
            
        }
        
        public String getDisplay(){
            StringBuilder sb = new StringBuilder();
            sb.append("<a href=\"").append(link).append("\" target=\"_blank\">");
           sb.append(title).append("</a><br>");
          // sb.append("Desc:"+description).append("\n");
           sb.append("Type:"+type).append("<br>");
           sb.append("Status:"+status).append("<br>");
           sb.append("Owner:"+owner).append("<br>");
         //  sb.append("Workspace:"+workspace).append("\n");
           sb.append("Assignees:");
           boolean comma = false;
           for(String assignee : assignees){
               if(comma){
                   sb.append(",");
               }
               comma = true;
               sb.append(assignee);
            }
           
            return sb.toString();
        }
        
        public String getColor(){
            if(status == null || status.isEmpty()) return "";
            if(status.startsWith("In")) return "yellow";
            if(status.startsWith("Not")) return "grey";
            if(status.startsWith("Com")) return "green";
            
            return "";
        }
        
        public String getWorkspace(){
            return workspace;
        }
        
        public String getLink(){
            return link;
        }
    }
    
    ArrayList<Task> tasks = new ArrayList<>();
    HashMap<Integer, String> workspaceNames = new HashMap<>();
    
    private void buildTask(JSONObject taskData){
        try{
            Task task = new Task();
            task.title = taskData.getString("title");
            task.description = taskData.getString("description");
            task.type = taskData.getString("type");
            task.status = taskData.getString("status");
            JSONArray actors =  taskData.getJSONArray("actors");
            for(int i =0; i < actors.length(); i++){
                JSONObject actor = actors.getJSONObject(i);
                if("owner".equals(actor.getString("rel"))){
                    task.owner = actor.getString("name");
                }
            }
            // find any assingees
            JSONArray links = taskData.getJSONArray("links");
            for(int i =0; i < links.length(); i++){
                JSONObject link = links.getJSONObject(i);
                if("assignments".equals(link.getString("rel"))){
                    if(link.getInt("count")>0){
                        task.assignees = getAssignees(link.getString("href"));
                    }
                }
                if("parent".equals(link.getString("rel"))){
                    task.workspaceID = new Integer(link.getString("href").substring(34));
               
                    if(workspaceNames.containsKey(task.workspaceID)){
                        task.workspace = workspaceNames.get(task.workspaceID);
                    }else{
                        task.workspace = getWorkspaceName(task.workspaceID);
                    }
                }
                if("alternate".equals(link.getString("rel"))){
                    task.link = link.getString("href");
                }
            }
            tasks.add(task);
            
        
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    
    private String getWorkspaceName(Integer id) throws Exception{
        String apiResponse = getJSON("workspaces/"+id,accessToken);
        JSONObject joe = new JSONObject(apiResponse);
        String title = joe.getString("title");
        workspaceNames.put(id, title);
        return title;
        
    }
    
    
    private ArrayList<String> getAssignees(String link)throws Exception{
      ArrayList<String> assignees = new ArrayList<>();
      
        String apiResponse = getJSON(link,accessToken);
        JSONObject joe = new JSONObject(apiResponse);
        JSONArray asses = joe.getJSONArray("assignments");
        for(int j=0; j< asses.length(); j++){
            JSONObject ass = asses.getJSONObject(j);
            JSONArray actors = ass.getJSONArray("actors");
            for(int i = 0; i < actors.length(); i++ ){
                JSONObject actor = actors.getJSONObject(i);
                if("assignee".equals(actor.getString("rel"))){
                    assignees.add(actor.getString("name"));
                }
            }
        }
        return assignees;
        
    }
    
    
    private String getToken(String code,boolean refresh){
        
        String uri = "https://login.huddle.net/token";
        String responseSingle;
        StringBuilder response = new StringBuilder();
    
     HttpURLConnection connection = null;
        try {
            URL url = new URL(uri);
            connection
                    = (HttpURLConnection) url.openConnection();
            
            connection.setRequestMethod("POST");
            connection.setDoOutput(true); // sending stuff
            

            connection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
            connection.setRequestProperty("Accept", "application/json");
            connection.setDoInput(true); //we want a response
            connection.setUseCaches(false);

            
            OutputStream out = connection.getOutputStream();
               

            OutputStreamWriter wr = new OutputStreamWriter(out);
            if(!refresh){
                wr.write("grant_type=authorization_code&client_id=JacksonLab_PIVOT_Dashboard&redirect_uri=http://wlg-bh0990:8080/pivotDashboard/auth.do&code="+code);
            }else{
                wr.write("grant_type=refresh_token&&client_id=JacksonLab_PIVOT_Dashboard&refresh_token="+code);
            }
            wr.flush();
            wr.close();
            out.close();

            // Open a stream which can read the server response
            InputStream in = connection.getInputStream();
            try {
                BufferedReader rd = new BufferedReader(new InputStreamReader(in));
                while ((responseSingle = rd.readLine()) != null) {
                    response.append(responseSingle);
                }
                rd.close(); //close the reader

            } catch (Exception e) {

                System.out.println("Error reading from webservice " + uri);
                e.printStackTrace();
            } finally {
                if (in != null) {
                    in.close();
                }
            }
        } catch (IOException e) {
            System.out.println("Error connecting to webservice " + uri);
            e.printStackTrace();
        } finally {
            if (connection != null) {
                connection.disconnect();
            }
        }

        return response.toString();

    }
    
    
    
    private String getJSON(String apiCall, String token) {

        String apiBase = "https://api.huddle.net/";
        
        if(apiCall.startsWith("http")){
            apiBase = "";
        }

        String responseSingle = "";
        StringBuffer response = new StringBuffer();

        HttpURLConnection connection = null;
        try {
            URL url = new URL(apiBase+apiCall);
            connection = (HttpURLConnection) url.openConnection();
            
            connection.setRequestMethod("GET");
            

            connection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
            connection.setRequestProperty("Accept", "application/json");
            connection.setRequestProperty("Authorization","Bearer "+token);

            connection.setDoInput(true); //we want a response
            connection.setUseCaches(false);

           
            // Open a stream which can read the server response
            InputStream in = connection.getInputStream();
            try {
                BufferedReader rd = new BufferedReader(new InputStreamReader(in));
                while ((responseSingle = rd.readLine()) != null) {
                    response.append(responseSingle);
                }
                rd.close(); //close the reader

            } catch (IOException e) {

                System.out.println("Error reading from webservice ");
                e.printStackTrace();
                
                this.accessToken = null;
                

            } finally {
                if (in != null) {
                    in.close();
                }
            }
        } catch (IOException e) {
             System.out.println("Error reading from webservice ");
                e.printStackTrace();

        } finally {
            if (connection != null) {
                connection.disconnect();
            }
        }

        return response.toString();

    }
    
    
}
