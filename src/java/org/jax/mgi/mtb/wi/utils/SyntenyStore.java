/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.jax.mgi.mtb.wi.utils;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Scanner;

/**
 *
 * @author sbn
 */
public class SyntenyStore {
    
    
    public static final String human = "human";
    public static final String mouse = "mouse";
  
    
   public SyntenyStore(){
       if(m2hData .isEmpty())
       loadData();
   }
   
   private static HashMap<String,ArrayList<ArrayList<String>>>  m2hData = new HashMap<String,ArrayList<ArrayList<String>>>();
   private static HashMap<String,ArrayList<ArrayList<String>>>  h2mData = new HashMap<String,ArrayList<ArrayList<String>>>();
   
   
    public static void main(String[] args){
        
    SyntenyStore store = new SyntenyStore();
    
    store.showRegions(store.getRegions(SyntenyStore.mouse,"1", "10000000", "70000000"));
    }
    
    private void showRegions(ArrayList<ArrayList<String>> list){
    
        for(ArrayList<String> line : list){
            for(String chars :line){
            System.out.print(chars+"\t");
          }
           System.out.println("");
        }
        
    }
    
    public ArrayList<GViewerFeature> getRegionsAsFeatures(String source, String chr, String start, String end){
        
        ArrayList<GViewerFeature> features = new ArrayList<GViewerFeature>();
        
        ArrayList<ArrayList<String>> regions = getRegions(source, chr,start,end);
        String from ="", to = "";
        int startIndex =8, endIndex =9, chrIndex =7;
        if(source.equals(SyntenyStore.mouse)){
            from = "Mouse";
            to = "Human";
            startIndex = 8;
            endIndex = 9;
            chrIndex = 7;
            
        }
        if(source.equals(SyntenyStore.human)){
            from = "Human";
            to = "Mouse";
            
            startIndex =2;
            endIndex = 3;
            chrIndex = 1;
            
        }
        
        for(ArrayList<String> region :regions){
            
            GViewerFeature feature = new GViewerFeature();
            feature.setChromosome(region.get(chrIndex));
            feature.setStart(region.get(startIndex));
            feature.setEnd(region.get(endIndex));
            feature.setDescription(region.get(6));
            feature.setName(region.get(6));
            feature.setType(to+" syntenic region");
            feature.setGroup(from+" Chr:"+chr+" "+start+"-"+end);
            feature.setColor("blue");
            
            features.add(feature);
            
        }
        
        
        return features;
        
    }
  
    public ArrayList<ArrayList<String>> getRegions(String source, String chr, String startStr, String endStr){
        
        long startIn = new Long(startStr).longValue();
        long endIn = new Long(endStr).longValue();
        
        ArrayList<ArrayList<String>> regions = new ArrayList<ArrayList<String>>();
        
        ArrayList<ArrayList<String>> chromosomeList = null;
        int startIndex = 0;
        int endIndex = 0;
        
        if(source.equals(SyntenyStore.mouse)){
          chromosomeList = m2hData.get(chr.toUpperCase());
          startIndex =  2;
          endIndex = 3;
        }
        if(source.equals(SyntenyStore.human)){
            chromosomeList = h2mData.get(chr.toUpperCase());
            startIndex = 8;
            endIndex = 9;
        }
        loop: for(ArrayList<String> line : chromosomeList){
              //      0            1         2       3       4       5       6      7        8        9      10        11            
              //HomoloGene ID	Mouse Chr	Mm start	Mm end	Mm ori	Mm gene	Hs gene	Hs Chr	Hs start	Hs end	Hs ori	block_ID
            if(line.size()  >  5){
            long start = new Long(line.get(startIndex)).longValue();
            long end = new Long(line.get(endIndex)).longValue();
            
            // not inclusive only return regions entirely in  region
            if((start >= startIn ) && (end <= endIn))
                regions.add(line);
        //    if(start > endIn)break loop;
        }
        }
        return regions;
        
    }
    
    private void loadData(){
        String filePart1 = "C:/synteny/mm_chr";
        String filePart2="_BOB.txt";
        String[] chr = {"1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","X","Y"};
        
        for(String ch : chr){
         m2hData.put(ch,   loadFile(filePart1+ch+filePart2));
        }
        calcH2MData();
        
    }
    
    private void calcH2MData(){
        for(String chr  : m2hData.keySet()){
            ArrayList<ArrayList<String>> regions = m2hData.get(chr);
            for(ArrayList<String> line : regions){
                if(line.size()>5){
                if (h2mData.containsKey(line.get(7))){
                    ArrayList<ArrayList<String>> chrRegions = h2mData.get(line.get(7));
                            chrRegions.add(line);
                }else{
                    ArrayList<ArrayList<String>> chrRegions = new ArrayList<ArrayList<String>>();
                    chrRegions.add(line);
                    h2mData.put(line.get(7), chrRegions);
                }
               
                
            }
            }
            
        }        
        
        
    }
    
    private ArrayList<ArrayList<String>> loadFile(String fileName){
        
        ArrayList<ArrayList<String>> chromosomeList = new ArrayList<ArrayList<String>>();
        
        try{
            
         File file = new File(fileName);
         Scanner s = new Scanner(file);
         s.useDelimiter("\n");
         Scanner lineScanner = null;
         s.next(); // skip the header line
         
         while(s.hasNext()){
             lineScanner = new Scanner(s.nextLine());
             lineScanner.useDelimiter("\t");
             ArrayList<String> line = new ArrayList<String>();
             while(lineScanner.hasNext()){
                 
                 //HomoloGene ID	Mouse Chr	Mm start	Mm end	Mm ori	Mm gene	Hs gene	Hs Chr	Hs start	Hs end	Hs ori	block_ID
                 
                line.add(lineScanner.next());
                 
             }
             chromosomeList.add(line);
         }
         
        
        
        }catch(Exception e){
            e.printStackTrace();
        }
        return chromosomeList;
    }
    
}