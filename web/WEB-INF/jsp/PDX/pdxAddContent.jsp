<%@ page language="java" contentType="text/html" pageEncoding="windows-1252"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<jax:mmhcpage title="Add PDX Content" help="pdxAddContent">
	<jsp:attribute name="head">
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
	<link rel="stylesheet" type="text/css" href="${applicationScope.urlBase}/extjs/resources/css/ext-all.css" />
	<script type="text/javascript" src="${applicationScope.urlBase}/extjs/adapter/ext/ext-base.js"></script>
	<script type="text/javascript" src="${applicationScope.urlBase}/extjs/ext-all.js"></script>
	<script type="text/javascript" src="${applicationScope.urlBase}/GViewer/javascript/FileUploadField.js"></script>
	<script type="text/javascript">
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
				renderTo: 'pi-form',
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
				,
				{ xtype: 'numberfield',
					id: 'piSort',
					fieldLabel: 'Sort order',
					name: 'piSort'
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
				renderTo: 'link-form',
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
					allowBlank: true,
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
					name:'linkURL'
				}
				,{ xtype:'textfield',
					id:'linkText',
					fieldLabel:'Link Text',
					name:'linkText'
				}],
				buttons: [{
					text: 'Add Link',
					handler: function(){
						if(linkForm.getForm().isValid()){
							linkForm.getForm().submit({
								url: 'pdxAddContent.do?submitContent=url&modelID=${modelID}&characterizationKey=${characterizationKey}',
								waitMsg: 'Adding your link ...',
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
				renderTo: 'document-form',
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
				renderTo: 'graphic-form',
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
				{ xtype: 'numberfield',
					id: 'graphicSort',
					fieldLabel: 'Sort order',
					name: 'graphicSort'
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
				renderTo: 'comment-form',
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
					text: 'Add Comment',
					handler: function(){
						if(commentForm.getForm().isValid()){
							commentForm.getForm().submit({
								url: 'pdxAddContent.do?submitContent=comment&modelID=${modelID}&characterizationKey=${characterizationKey}',
								waitMsg: 'Adding your comment ...',
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
	</jsp:attribute>
	<jsp:body>
	<section id="pdx-add">
		<h2>Additional ${characterization} content for ${modelID}</h2>

		<div id="pi-form"></div>

		<div id="link-form"></div>

		<div id="document-form"></div>

		<div id="graphic-form"></div>

		<div id="comment-form"></div>
		
	</section>
	</jsp:body>
</jax:mmhcpage>
