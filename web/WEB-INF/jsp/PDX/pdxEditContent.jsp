<%@ page language="java" contentType="text/html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %> 
<%@ taglib prefix="jax" tagdir="/WEB-INF/tags" %>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<html>
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
	<script type="text/javascript">
	Ext.onReady(function(){
		Ext.QuickTips.init();
		var piForm = new Ext.FormPanel({
			hidden:${hidePiForm},
			renderTo: 'pi-form',
			fileUpload: false,
			width: 500,
			frame: true,
			title: 'Edit Pathology Image',
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
				name:'caption',
				value:'${caption}'
			}
			,{ xtype:'textfield',
				id:'piDescription',
				fieldLabel:'Description',
				name:'piDescription',
				value:'${piDescription}'
			}
			,{ xtype:'textfield',
				id:'pathologist',
				fieldLabel:'Pathologist',
				name:'pathologist',
				value:'${pathologist}'
			}
			,{ xtype:'textfield',
				id:'source',
				fieldLabel:'Source',
				name:'source',
				value:'${source}'
			}
			,
			{ xtype: 'numberfield',
				id: 'piSort',
				fieldLabel: 'Sort order',
				name: 'graphicSort',
				value: "${piSort}"
			}
			,{ xtype: 'textfield',
				id: 'piFilePath',
				emptyText: 'Using existing image',
				fieldLabel: 'Image',
				name: 'piFilePath',
				disabled:true
			}],
			buttons: [{
				text: 'Edit',
				handler: function(){
					if(piForm.getForm().isValid()){
						piForm.getForm().submit({
							url: 'pdxEditContent.do?contentType=image&contentKey=${contentKey}&action=update',
							waitMsg: 'Editing the image ...',
							success: function(form, o){
								Ext.Msg.alert('Success', 'Edited image.', function(btn, text){
									window.location.replace("pdxDetails.do?modelID=${modelID}");
								});
							},
							failure: function(form,o){
								Ext.Msg.alert('Failure','Image edit failed.');
							}
						});
					}else{
						Ext.Msg.alert('','Please correct invalid fields.');
					}
				}
			},
			{
				text: 'Delete',
				handler: function(){
					piForm.getForm().submit({
						clientValidation:false,
						url: 'pdxEditContent.do?contentType=image&contentKey=${contentKey}&action=delete',
						waitMsg: 'Deleting your image ...',
						success: function(form, o){
							Ext.Msg.alert('Success', 'Deleted image.', function(btn, text){
								window.location.replace("pdxDetails.do?modelID=${modelID}");
							});
						},
						failure: function(form,o){
							Ext.Msg.alert('Failure','Image delete failed.');
						}
					});
				}
			}
			]
		});
		var linkForm = new Ext.FormPanel({
			hidden:${hideLinkForm},
			renderTo: 'link-form',
			fileUpload: false,
			width: 500,
			frame: true,
			title: 'Edit Link',
			autoHeight: true,
			bodyStyle: 'padding: 10px 10px 0 10px;',
			labelWidth: 90,
			fileCount:1,
			defaults: {
				anchor: '95%',
				allowBlank: true,
				msgTarget: 'side'
			},
			items: [{ xtype:'textfield',
				id:'linkDescription',
				fieldLabel:'Description',
				name:'linkDescription',
				value:'${linkDescription}'
			}
			,{ xtype:'textfield',
				id:'linkURL',
				fieldLabel:'Link URL',
				name:'linkURL',
				value:'${linkURL}'
			}
			,{ xtype:'textfield',
				id:'linkText',
				fieldLabel:'Link Text',
				name:'linkText',
				value:'${linkText}'
			},{ xtype:'textfield',
                                id:'pubMedID',
                                fieldLabel:'PubMed ID (if available)',
                                name:'pubMedID',
                                value:'${linkPubMedID}'
                        }],
			buttons: [{
				text: 'Edit',
				handler: function(){
					if(linkForm.getForm().isValid()){
						linkForm.getForm().submit({
							url: 'pdxEditContent.do?contentType=link&contentKey=${contentKey}&action=update',
							waitMsg: 'Editing your link ...',
							success: function(form, o){
								Ext.Msg.alert('Success', 'Edited link.', function(btn, text){
									window.location.replace("pdxDetails.do?modelID=${modelID}");
								});
							},
							failure: function(form,o){
								Ext.Msg.alert('Failure','Link edit failed.');
							}
						});
					}else{
						Ext.Msg.alert('','Please correct invalid fields.');
					}
				}
			},
			{
				text: 'Delete',
				handler: function(){
					linkForm.getForm().submit({
						clientValidation:false,
						url: 'pdxEditContent.do?contentType=link&contentKey=${contentKey}&action=delete',
						waitMsg: 'Deleting your link ...',
						success: function(form, o){
							Ext.Msg.alert('Success', 'Deleted link.', function(btn, text){
								window.location.replace("pdxDetails.do?modelID=${modelID}");
							});
						},
						failure: function(form,o){
							Ext.Msg.alert('Failure','Link delete failed.');
						}
					});
				}
			}
			]
		});
		var documentForm = new Ext.FormPanel({
			hidden:${hideDocumentForm},
			renderTo: 'document-form',
			fileUpload: false,
			width: 500,
			frame: true,
			title: 'Edit Document',
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
				name:'documentDescription',
				value:'${documentDescription}'
			}
			,{ xtype:'textfield',
				id:'documentLinkText',
				fieldLabel:'Link text',
				name:'documentLinkText',
				value:'${documentLinkText}'
			},
			{ xtype: 'textfield',
				id: 'documentPath',
				emptyText: 'Using existing document',
				fieldLabel: 'Document',
				name: '',
				disabled:true
			}],
			buttons: [{
				text: 'Edit',
				handler: function(){
					if(documentForm.getForm().isValid()){
						documentForm.getForm().submit({
							url: 'pdxEditContent.do?contentType=document&contentKey=${contentKey}&action=update',
							waitMsg: 'Editing your document ...',
							success: function(form, o){
								Ext.Msg.alert('Success', 'Edited document.', function(btn, text){
									window.location.replace("pdxDetails.do?modelID=${modelID}");
								});
							},
							failure: function(form,o){
								Ext.Msg.alert('Failure','Document edit failed.');
							}
						});
					}else{
						Ext.Msg.alert('','Please correct invalid fields.');
					}
				}
			},
			{
				text: 'Delete',
				handler: function(){
					documentForm.getForm().submit({
						clientValidation:false,
						url: 'pdxEditContent.do?contentType=document&contentKey=${contentKey}&action=delete',
						waitMsg: 'Deleting your document ...',
						success: function(form, o){
							Ext.Msg.alert('Success', 'Deleted document.', function(btn, text){
								window.location.replace("pdxDetails.do?modelID=${modelID}");
							});
						},
						failure: function(form,o){
							Ext.Msg.alert('Failure','Document delete failed.');
						}
					});
				}
			}
			]
		});
		var graphicForm = new Ext.FormPanel({
			hidden:${hideGraphicForm},
			renderTo: 'graphic-form',
			fileUpload: false,
			width: 500,
			frame: true,
			title: 'Edit Graphic',
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
				name:'graphicDescription',
				value:"${graphicDescription}"
			}
			,
			{ xtype: 'numberfield',
				id: 'graphicSort',
				fieldLabel: 'Sort order',
				name: 'graphicSort',
				value: "${graphicSort}"
			}
			,
			{ xtype: 'textfield',
				id: 'graphicPath',
				emptyText: 'Using existing graphic',
				fieldLabel: 'Graphic',
				name: 'graphicPath',
				disabled:true
			}],
			buttons: [{
				text: 'Edit',
				handler: function(){
					if(graphicForm.getForm().isValid()){
						graphicForm.getForm().submit({
							url: 'pdxEditContent.do?contentType=graphic&contentKey=${contentKey}&action=update',
							waitMsg: 'Editing your graphic ...',
							success: function(form, o){
								Ext.Msg.alert('Success', 'Edited graphic.', function(btn, text){
									window.location.replace("pdxDetails.do?modelID=${modelID}");
								});
							},
							failure: function(form,o){
								Ext.Msg.alert('Failure','Graphic edit failed.');
							}
						});
					}else{
						Ext.Msg.alert('','Please correct invalid fields.');
					}
				}
			},
			{
				text: 'Delete',
				handler: function(){
					graphicForm.getForm().submit({
						clientValidation:false,
						url: 'pdxEditContent.do?contentType=graphic&contentKey=${contentKey}&action=delete',
						waitMsg: 'Deleting your graphic ...',
						success: function(form, o){
							Ext.Msg.alert('Success', 'Deleted graphic.', function(btn, text){
								window.location.replace("pdxDetails.do?modelID=${modelID}");
							});
						},
						failure: function(form,o){
							Ext.Msg.alert('Failure','Graphic delete failed.');
						}
					});
				}
			}
			]
		});
		var commentForm = new Ext.FormPanel({
			hidden:${hideCommentForm},
			renderTo: 'comment-form',
			fileUpload: false,
			width: 500,
			frame: true,
			title: 'Edit Comment',
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
				name:'comment',
				value:'${comment}',
                                height:300
			}
			],
			buttons: [{
				text: 'Edit',
				handler: function(){
					if(commentForm.getForm().isValid()){
						commentForm.getForm().submit({
							url: 'pdxEditContent.do?contentType=comment&contentKey=${contentKey}&action=update',
							waitMsg: 'Editing your comment ...',
							success: function(form, o){
								Ext.Msg.alert('Success', 'Edited comment.', function(btn, text){
									window.location.replace("pdxDetails.do?modelID=${modelID}");
								});
							},
							failure: function(form,o){
								Ext.Msg.alert('Failure','Comment edit failed.');
							}
						});
					}else{
						Ext.Msg.alert('','Please correct invalid fields.');
					}
				}
			},
			{
				text: 'Delete',
				handler: function(){
					commentForm.getForm().submit({
						clientValidation:false,
						url: 'pdxEditContent.do?contentType=comment&contentKey=${contentKey}&action=delete',
						waitMsg: 'Deleting your comment ...',
						success: function(form, o){
							Ext.Msg.alert('Success', 'Deleted comment.', function(btn, text){
								window.location.replace("pdxDetails.do?modelID=${modelID}");
							});
						},
						failure: function(form,o){
							Ext.Msg.alert('Failure','Comment delete failed.');
						}
					});
				}
			}
			]
		});
		// end onReady
	});
</script>		
<body>
	
		<section id="pdx">
			<div>	
				<h2>Additional Content for ${modelID}</h2>
				<div id="pi-form"></div>
				<div id="link-form"></div>
				<div id="document-form"></div>
				<div id="graphic-form"></div>
				<div id="comment-form"></div>
			</div>
		</section>
	
</body>
</html>