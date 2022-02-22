/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.jax.mgi.mtb.wi.utils;

import java.io.File;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Scanner;
import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONObject;
import static org.jax.mgi.mtb.wi.JSONUtils.getJSON;

/**
 * The list of genes and synonyms comes from HUGO's genenames
http://www.genenames.org/cgi-bin/download?col=gd_app_sym&col=gd_aliases&status=Approved&status_opt=2&where=&order_by=gd_app_sym_sort&format=text&limit=&hgnc_dbtag=on&submit=submit
*  w/ previous symbols
https://www.genenames.org/cgi-bin/download/custom?col=gd_app_sym&col=gd_prev_sym&col=gd_aliases&status=Approved&hgnc_dbtag=on&order_by=gd_app_sym_sort&format=text&submit=submit
 * @author sbn
 * 
 * 
 * Parse file
 *  figure out what to do with ambiguous symbols 
 *  what to do with non official jax symbols
 *  what to do with jax symbols not in fie at all
 * 
 *  identify ctp genes and synonyms
 *   
 *  create inserts
 * 
 */
public class HumanGeneSynonyms {
    //private static String hugoFile = "C:/humanGeneSynonyms.txt";
    private static String hugoFile = "C:/humanGenes2.txt";
    private static String allGenesURI = "http://pdxdata.jax.org/api/all_genes";
    
    private HashMap<String,ArrayList<String>> synonyms = new HashMap<>();
    private ArrayList<String> pdxGenes = new ArrayList<>();
    private ArrayList<String> ctpGenes = new ArrayList<>();
    private HashMap<String,String> officialNameForSynonyms = new HashMap<>();
    private ArrayList<String> hugoNames = new ArrayList<>();
    private ArrayList<String> inHugo = new ArrayList<>();
    HashMap<String,Integer> hugoCounts= new HashMap<>();
    
    int ctpCount=0,allPDXCount=0;
    
    public  HumanGeneSynonyms(){
        
    }
    
    
    public static void main(String[] args){
        HumanGeneSynonyms hgs = new HumanGeneSynonyms();
        
        hgs.test();
        
    }
    
    private void test(){
         
        
     loadHUGO();   
     loadCTPGenes();
     loadAllPDXGenes();
     loadSynonyms();
     
     getStats();
     
  //   if(true)System.exit(0);
     
     StringBuilder sb = new StringBuilder();
     // symbol, display, 'true', isCTP \n
    
     for(String gene : ctpGenes){
         
         if(!this.hugoNames.contains(gene)){
             if(this.officialNameForSynonyms.containsKey(gene)){
                 
                 sb.append(gene+","+this.officialNameForSynonyms.get(gene) +"(offical symbol for CTP gene "+gene+"),true,true\n");
               
             }
         }
         sb.append(gene+","+gene+",true,true\n");
         if(this.synonyms.containsKey(gene)){
            
             for(String syn : synonyms.get(gene)){
                 sb.append(gene+","+syn+",true,true\n");
                 
             }
         }
            
         this.pdxGenes.remove(gene);
     }
     
         
     for(String gene : pdxGenes){
         if(!this.hugoNames.contains(gene)){
             if(this.officialNameForSynonyms.containsKey(gene)  && this.officialNameForSynonyms.get(gene).indexOf(",")==-1){
                 
                 sb.append(gene+","+this.officialNameForSynonyms.get(gene) +"(offical symbol for PDX gene "+gene+"),true,false\n");
                  System.out.println(this.officialNameForSynonyms.get(gene) +"(offical symbol for PDX gene "+gene+")");
               
             }
         }
         sb.append(gene+","+gene+",true,false\n");
         if(this.synonyms.containsKey(gene)){
             for(String syn : synonyms.get(gene)){
                 sb.append(gene+","+syn+",true,false\n");
             }
         }
            
     }
         
 //    System.out.println(sb.toString());    
        
    }
    
   
    
   private void getStats(){
       
       int pdxNotInHugo = 0;
       int pdxNotOfficialHugo = 0;
       
       int ctpNotInHugo = 0;
       int ctpNotOfficialHugo = 0;
       
       
       for(String gene : pdxGenes){
           if(!hugoNames.contains(gene)){
               if(!inHugo.contains(gene)){
          //         System.out.println(gene+" not in HUGO !!!! ");  // what do we do with these?
              
                     pdxNotInHugo++;
               }else{
                   if(officialNameForSynonyms.get(gene).contains(","))
                   System.out.println("Jax PDX gene "+gene+" synonym for offical "+officialNameForSynonyms.get(gene));
                   pdxNotOfficialHugo++;
               }
           }
       }
       
       for(String gene : ctpGenes){
           if(!hugoNames.contains(gene)){
               if(!inHugo.contains(gene)){
                   System.out.println("Jax CTP gene "+gene+" not in HUGO !!!! ");  // what do we do with these?
                     ctpNotInHugo++;
               }else{
                   System.out.println("Jax CTP gene "+gene+" synonym for offical "+officialNameForSynonyms.get(gene));
                   ctpNotOfficialHugo++;
               }
           }
           if(!pdxGenes.contains(gene)){
               System.out.println("CTP gene "+gene+" not in PDX whole exome gene list");
           }
       }
       
       System.out.println(pdxNotInHugo+" PDX genes Not In Hugo");
       System.out.println(pdxNotOfficialHugo+" PDX genes Not Official Hugo symbols");
       
       System.out.println(ctpNotInHugo+" CTP genes Not In Hugo");
       System.out.println(ctpNotOfficialHugo+" CTP genes Not Official Hugo symbols");
       
   }
    
    public ArrayList<String> getSynonym(String gene){
        return synonyms.get(gene);
    }
    
    
    
    
    
    
   private void loadHUGO(){
    
       
       try{
          File f = new File(hugoFile);
           Scanner sc  = new Scanner(f);
           sc.useDelimiter("\n");
           while(sc.hasNext()){
               String line = sc.next().trim();       
               String[] syns = line.split(" ");
               hugoNames.add(syns[0]);
               for(int i = 1; i < syns.length; i++){
                inHugo.add(syns[i]);
                
                if(officialNameForSynonyms.containsKey(syns[i])){
                    officialNameForSynonyms.put(syns[i], officialNameForSynonyms.get(syns[i])+", "+syns[0]);
                }else{
                    officialNameForSynonyms.put(syns[i], syns[0]);
                }
               }
           }
           
           System.out.println("Loaded "+hugoNames.size()+" offical HUGO names");
        }catch(Exception e){
            e.printStackTrace();
        }
       
   }
   
    
  
    
    private  void loadSynonyms(){
       int ambi=0;
      
       String gene = "";
        try{
          File f = new File(hugoFile);
           Scanner sc  = new Scanner(f);
           sc.useDelimiter("\n");
           while(sc.hasNext()){
               String line = sc.next();
               String[] syns = line.split(" ");
                gene = syns[0];
                
               if(syns.length>1 ){
               
               
                ArrayList<String> l = new ArrayList<String>();
                 for(int i =1; i< syns.length; i++){
                   String symbol = syns[i].trim();
                   if(!symbol.isEmpty() && !hugoNames.contains(symbol)){
                       l.add(symbol+"(synonym for "+gene+")");
                     

                   }else if(!symbol.isEmpty()){
        //               System.out.println("Not creating synonym "+symbol+" as it matches an offical name");
                       ambi++;
                   }
                 }
                 synonyms.put(gene, l);
               }
           }
              
           
           
        }catch(Exception e){
            e.printStackTrace();
        }
     
    }
    
    
    
    
    
    
    private void loadAllPDXGenes() {
        int unofficial = 0;
        try {
            JSONObject job = new JSONObject(getJSON(allGenesURI));

            JSONArray array = (JSONArray) job.get("data");

            for (int i = 0; i < array.length(); i++) {
                if (array.getString(i).trim().length() > 0) {
                    pdxGenes.add(array.getString(i));
                    
                   
                }
            }
            Collections.sort(pdxGenes);

        } catch (Exception e) {
            System.out.println("Error getting all genes");  e.printStackTrace();
        }
        
       
      

    }
    
     private void loadCTPGenes() {

        try {
            JSONObject job = new JSONObject(getJSON(allGenesURI+"?all_ctp_genes=yes"));;

            JSONArray array = (JSONArray) job.get("data");

            for (int i = 0; i < array.length(); i++) {
                if (array.getString(i).trim().length() > 0) {
                    ctpGenes.add(array.getString(i).trim());
                    
                }
            }
            Collections.sort(ctpGenes);

        } catch (Exception e) {
            System.out.println("Error getting CTP genes");  e.printStackTrace();
            
        }
        
     

    }


  

  
    
}
