<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib uri="http://tumor.informatics.jax.org/mtbwi/MTBWebUtils" prefix="wu" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">

<%@page contentType="text/html" pageEncoding="windows-1252"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
        <title>Add PDX Content</title>

        <link rel="stylesheet" type="text/css" href="${applicationScope.urlBase}/GViewer/javascript/fileUpload.css"/>
        <style type="text/css">
            .upload-icon {
                background: url('${applicationScope.urlBase}/extjs/resources/images/image_add.png') no-repeat 0 0 !important;
            }
            #fi-button-msg {
                border: 2px solid #ccc;
                padding: 5px 10px;
                background: #eee;
                margin: 5px;
                float: left;
            }
        </style>

    <c:import url="../../../meta.jsp">
        <c:param name="pageTitle" value="Add PDX Content"/>
    </c:import>

    <link rel="stylesheet" type="text/css" href="${applicationScope.urlBase}/extjs/resources/css/ext-all.css" />
    <script type="text/javascript" src="${applicationScope.urlBase}/extjs/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="${applicationScope.urlBase}/extjs/ext-all.js"></script>

    <script type="text/javascript" src="${applicationScope.urlBase}/GViewer/javascript/FileUploadField.js"></script>



</head>

<script language="javascript">
        
    Ext.onReady(function(){
        
        Ext.apply(Ext.form.VTypes, {
        
        'imagefile': function(){
                return function(v){
                    v = v.replace(/^\s|\s$/g, ""); //trims string
                           if (v.match(/([^\/\\]+)\.(bmp|gif|png|jpg|jpeg)$/i) )
                               return true;
                           else
                               return false;
                    }
                }(),
                'imagefileText' : 'Must be a valid image file: GIF, JPG, BMP, PNG'
        });

        Ext.QuickTips.init();

       
        var piForm = new Ext.FormPanel({
            hidden:${hidePImage},
            renderTo: 'piForm',
            fileUpload: true,
            width: 500,
            frame: true,
            title: 'Add Pathology Image',
            autoHeight: true,
            bodyStyle: 'padding: 10px 10px 0 10px;',
            labelWidth: 70,
            fileCount:1,
            defaults: {
                anchor: '95%',
                allowBlank: false,
                msgTarget: 'side'
            },
            items: [{ xtype:'textfield',
                    id:'caption',
                    fieldLabel:'Caption',
                    name:'caption'
                }
                ,{ xtype:'textfield',
                    id:'piDescription',
                    fieldLabel:'Description',
                    name:'piDescription'
                }
                ,{ xtype:'textfield',
                    id:'pathologist',
                    fieldLabel:'Pathologist',
                    name:'pathologist'
                }
                ,{ xtype:'textfield',
                    id:'source',
                    fieldLabel:'Source',
                    name:'source'
                }
                ,{ xtype: 'fileuploadfield',
                    id: 'piFilePath',
                    emptyText: 'Select an image',
                    fieldLabel: 'Image',
                    name: 'piFilePath',
                    vtype:'imagefile',
                    buttonText: '',
                    buttonCfg: {
                        iconCls: 'upload-icon'
                    }
                    
                }],
            buttons: [{
                    text: 'Upload',
                    handler: function(){
                        if(piForm.getForm().isValid()){
                            piForm.getForm().submit({
                                url: 'pdxAddContent.do?submitContent=pathImage&modelID=${modelID}&characterizationKey=${characterizationKey}',
                                waitMsg: 'Uploading your image ...',
                                success: function(form, o){
                                    Ext.Msg.alert('Success', 'Uploaded image.', function(btn, text){
                                                    window.location.replace("pdxDetails.do?modelID=${modelID}&characterization=${characterization}");
                                                });
                                },
                                failure: function(form,o){
                                    Ext.Msg.alert('Failure','Image upload failed.');
                                    
                                }
                            });
                         }else{
                         Ext.Msg.alert('','Please correct invalid fields.');
                        }
                    }
                },
                {
                    text: 'Reset',
                    handler: function(){
                        piForm.getForm().reset();
                    }
                }
            ]
        });
        
        
        
        
        
         var linkForm = new Ext.FormPanel({
            hidden:${hideLink},
            renderTo: 'linkForm',
            fileUpload: false,
            width: 500,
            frame: true,
            title: 'Add Link',
            autoHeight: true,
            bodyStyle: 'padding: 10px 10px 0 10px;',
            labelWidth: 70,
            fileCount:1,
            defaults: {
                anchor: '95%',
                allowBlank: false,
                msgTarget: 'side'
            },
            items: [{ xtype:'textfield',
                    id:'linkDescription',
                    fieldLabel:'Description',
                    name:'linkDescription'
                }
                ,{ xtype:'textfield',
                    id:'linkURL',
                    fieldLabel:'Link URL',
                    name:'linkURL',
                    vtype:'url'
                }
                ,{ xtype:'textfield',
                    id:'linkText',
                    fieldLabel:'Link Text',
                    name:'linkText'
                }],
            buttons: [{
                    text: 'Upload',
                    handler: function(){
                        if(linkForm.getForm().isValid()){
                            linkForm.getForm().submit({
                                url: 'pdxAddContent.do?submitContent=url&modelID=${modelID}&characterizationKey=${characterizationKey}',
                                waitMsg: 'Uploading your link ...',
                                success: function(form, o){
                                    Ext.Msg.alert('Success', 'Added link.', function(btn, text){
                                                    window.location.replace("pdxDetails.do?modelID=${modelID}&characterization=${characterization}");
                                                });
                                },
                                failure: function(form,o){
                                    Ext.Msg.alert('Failure','Link creation failed.');
                                    
                                }
                            });
                         }else{
                         Ext.Msg.alert('','Please correct invalid fields.');
                        }
                    }
                },
                {
                    text: 'Reset',
                    handler: function(){
                        linkForm.getForm().reset();
                    }
                }
            ]
        });
        
        
        
        
          var documentForm = new Ext.FormPanel({
            hidden:${hideDocument},
            renderTo: 'documentForm',
            fileUpload: true,
            width: 500,
            frame: true,
            title: 'Add Document',
            autoHeight: true,
            bodyStyle: 'padding: 10px 10px 0 10px;',
            labelWidth: 70,
            fileCount:1,
            defaults: {
                anchor: '95%',
                allowBlank: false,
                msgTarget: 'side'
            },
            items: [{ xtype:'textfield',
                    id:'documentDescription',
                    fieldLabel:'Description',
                    name:'documentDescription'
                }
                ,{ xtype:'textfield',
                    id:'documentLinkText',
                    fieldLabel:'Link text',
                    name:'documentLinkText'
                   
                },
                { xtype: 'fileuploadfield',
                    id: 'documentPath',
                    emptyText: 'Select a Document',
                    fieldLabel: 'Document',
                    name: 'documentFilePath',
                    buttonText: '',
                    buttonCfg: {
                        iconCls: 'upload-icon'
                    }
                }],
            buttons: [{
                    text: 'Upload',
                    handler: function(){
                        if(documentForm.getForm().isValid()){
                            documentForm.getForm().submit({
                                url: 'pdxAddContent.do?submitContent=document&modelID=${modelID}&characterizationKey=${characterizationKey}',
                                waitMsg: 'Uploading your document ...',
                                success: function(form, o){
                                    Ext.Msg.alert('Success', 'Uploaded document.', function(btn, text){
                                                    window.location.replace("pdxDetails.do?modelID=${modelID}&characterization=${characterization}");
                                                });
                                },
                                failure: function(form,o){
                                    Ext.Msg.alert('Failure','Document upload failed.');
                                    
                                }
                            });
                         }else{
                         Ext.Msg.alert('','Please correct invalid fields.');
                        }
                    }
                },
                {
                    text: 'Reset',
                    handler: function(){
                        documentForm.getForm().reset();
                    }
                }
            ]
        });
        
        
         var graphicForm = new Ext.FormPanel({
            hidden:${hideGraphic},
            renderTo: 'graphicForm',
            fileUpload: true,
            width: 500,
            frame: true,
            title: 'Add Graphic',
            autoHeight: true,
            bodyStyle: 'padding: 10px 10px 0 10px;',
            labelWidth: 70,
            fileCount:1,
            defaults: {
                anchor: '95%',
                allowBlank: false,
                msgTarget: 'side'
            },
            items: [{ xtype:'textfield',
                    id:'graphicDescription',
                    fieldLabel:'Description',
                    name:'graphicDescription'
                }
                ,
                { xtype: 'fileuploadfield',
                    id: 'graphicPath',
                    emptyText: 'Select a graphic',
                    fieldLabel: 'Graphic',
                    name: 'graphicFilePath',
                    buttonText: '',
                    vtype:'imagefile',
                    buttonCfg: {
                        iconCls: 'upload-icon'
                    }
                }],
            buttons: [{
                    text: 'Upload',
                    handler: function(){
                        if(graphicForm.getForm().isValid()){
                            graphicForm.getForm().submit({
                                url: 'pdxAddContent.do?submitContent=graphic&modelID=${modelID}&characterizationKey=${characterizationKey}',
                                waitMsg: 'Uploading your graphic ...',
                                success: function(form, o){
                                    Ext.Msg.alert('Success', 'Uploaded graphic.', function(btn, text){
                                                    window.location.replace("pdxDetails.do?modelID=${modelID}&characterization=${characterization}");
                                                });
                                },
                                failure: function(form,o){
                                    Ext.Msg.alert('Failure','Graphic upload failed.');
                                    
                                }
                            });
                         }else{
                         Ext.Msg.alert('','Please correct invalid fields.');
                        }
                    }
                },
                {
                    text: 'Reset',
                    handler: function(){
                        graphicForm.getForm().reset();
                    }
                }
            ]
        });

         var commentForm = new Ext.FormPanel({
            hidden:${hideComment},
            renderTo: 'commentForm',
            fileUpload: false,
            width: 500,
            frame: true,
            title: 'Add Comment',
            autoHeight: true,
            bodyStyle: 'padding: 10px 10px 0 10px;',
            labelWidth: 70,
            fileCount:1,
            defaults: {
                anchor: '95%',
                allowBlank: false,
                msgTarget: 'side'
            },
            items: [{ xtype:'textarea',
                    id:'comment',
                    fieldLabel:'Comment',
                    name:'comment'
                }
                ],
            buttons: [{
                    text: 'Upload',
                    handler: function(){
                        if(commentForm.getForm().isValid()){
                            commentForm.getForm().submit({
                                url: 'pdxAddContent.do?submitContent=comment&modelID=${modelID}&characterizationKey=${characterizationKey}',
                                waitMsg: 'Uploading your comment ...',
                                success: function(form, o){
                                    Ext.Msg.alert('Success', 'Added comment.', function(btn, text){
                                                    window.location.replace("pdxDetails.do?modelID=${modelID}&characterization=${characterization}");
                                                });
                                },
                                failure: function(form,o){
                                    Ext.Msg.alert('Failure','Comment creation failed.');
                                    
                                }
                            });
                         }else{
                         Ext.Msg.alert('','Please correct invalid fields.');
                        }
                    }
                },
                {
                    text: 'Reset',
                    handler: function(){
                        commentForm.getForm().reset();
                    }
                }
            ]
        });
        
        
        
        var test = '${documentLinkText}';
        if(true){
            documentForm.findField('documentFilePath').disabled=true;
        }


// end onReady

    });
    
    
    
    
    
       
   
        
        
        
        
</script>    






<c:import url="../../../body.jsp">
    <c:param name="pageTitle" value="PDX Login"/>
</c:import>


<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr>
        <td width="200" valign="top">
    <c:import url="../../../toolBar.jsp" />
</td>
<td class="separator">
    &nbsp;
</td>
<td valign="top">
    <table width="95%" align="center" border="0" cellspacing="1" cellpadding="4">
        <tr>
            <td>
                <!--======================= Start Main Section =============================-->
                <!--======================= Start Form Header ==============================-->
                <table border="0" cellpadding=5 cellspacing=1 width="100%" >
                    <tr class="pageTitle">
                        <td colspan="11" width="100%">
                            <table width="100%" border=0 cellpadding=0 cellspacing=0>
                                <tr>
                                    <td width="20%" valign="middle" align="left">
                                        <a class="help" href="userHelp.jsp#pdxAddContent"><img src="${applicationScope.urlImageDir}/help_large.png" border=0 width=32 height=32 alt="Help"></a>
                                    </td>
                                    <td width="60%" class="pageTitle">
                                        PDX Add Content
                                    </td>
                                    <td width="20%" valign="middle" align="center">&nbsp;</td>
                                </tr>
                            </table>
                        </td>
                    </tr>


                    <!--======================= End Form Header ================================-->
                    <!--======================= Start Search Summary ===========================-->
                    <tr class="summary">
                        <td align="center" colspan="11">

                            <table>
                                <tr><td>
                                        <h1 align="center">Additional ${characterization} content for ${modelID}</h1>
                                        <h1>&nbsp;</h1>
                                        <div id="piForm"></div>
                                        <h1>&nbsp;</h1>
                                        <div id="linkForm"></div>
                                        <h1>&nbsp;</h1>
                                        <div id="documentForm"></div>
                                        <h1>&nbsp;</h1>
                                        <div id="graphicForm"></div>
                                         <h1>&nbsp;</h1>
                                        <div id="commentForm"></div>
                            </table>
                        </td>
                    </tr>
                </table>
                <br>
            </td>
        </tr>
    </table>
</td>
</tr>
</table>

</html> 

