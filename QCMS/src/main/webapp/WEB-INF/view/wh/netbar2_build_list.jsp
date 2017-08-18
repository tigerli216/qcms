<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
	<head>
		<title><s:message code="sys.title" /></title>
		<meta charset="utf-8">
       	<meta name="viewport" content="width=device-width,initial-scale=1.0">
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta name="renderer" content="webkit">
		<link rel="stylesheet" href="${basePath}/css/bootstrap.min.css">
		<link rel="stylesheet" href="${basePath}/css/font-awesome.min.css"/>
		<link rel="stylesheet" href="${basePath}/css/dataTables/dataTables.bootstrap.css"/>
		<link rel="stylesheet" href="${basePath}/css/bootstrap-editable/bootstrap-editable.css"/>
		<link rel="stylesheet" href="${basePath}/css/bootstrap-dialog/bootstrap-dialog.min.css"/>
		<link rel="stylesheet" href="${basePath}/css/animate.min.css"/>
		<link rel="stylesheet" href="${basePath}/css/ztree/ztree.css"/>
		<link rel="stylesheet" href="${basePath}/css/style.min.css"/>
	</head>

	<body class="gray-bg">
	<div class="spiner-example">
       <div class="sk-spinner sk-spinner-three-bounce">
            <div class="sk-bounce1"></div>
            <div class="sk-bounce2"></div>
            <div class="sk-bounce3"></div>
        </div>
    </div>
    <div class="wrapper wrapper-content animated fadeInRight">
        <div class="row">
            <div class="col-sm-12">
                <div class="ibox float-e-margins">
                    <div class="ibox-title">
                       	<a href="${basePath}/netbarList/build/list" class="btn btn-white btn-margin-right"><i class="fa fa-refresh"></i>&nbsp;刷新</a>
                       	<a id="export" href="javascript:void(0);" class="btn btn-white"><i class="fa fa-download"></i>&nbsp;导出Excel</a>
                       	<input id="zNodes" type="hidden" value='${areasTree}'>
                       	<input id="defineKey" type="hidden" value=''>
                    </div>
                    <div class="ibox-content">
                    	<div class="row">
                    		<div class="col-sm-3">
                    			<ul id="nodeTree" class="ztree" style="padding-left: 20%;"></ul>
                    		</div>
                    		<div id="barlist_div" class="col-sm-9">
                    			<input type="button" id="allbtn" value="全部" onclick="loadDataFromSession('all')">&nbsp;&nbsp;&nbsp;&nbsp;
                    			<input type="button" style="display: none;" id="finishbtn" value="施工完成" onclick="loadDataFromSession('finish')">&nbsp;&nbsp;&nbsp;&nbsp;
                    			<input type="button" style="display: none;" id="unfinishbtn" value="施工未完成" onclick="loadDataFromSession('unfinish')">
		                        <table class="table table-striped table-bordered table-hover " id="editable">
		                        	
		                            <thead>
		                                <tr>
		                                	<th>状态</th>
		                                    <th>网吧名称</th>
											<th>终端总数/(个)</th>
											<th>今日累计在线/(个)</th>
											<th>今日未上线/(个)</th>
											<th>已安装终端/(个)</th>
											<th>未安装终端/(个)</th>
											<th>在线率</th>
											<th>安装率</th>
											<!-- <th style="display:none;">1</th> -->
		                                </tr>
		                            </thead>
		                            <tbody id="tbody_stat">
		                            	<c:forEach var="stat" items="${statList}">
		                            		<tr>
		                            			<td>${stat.barId}</td>
												<td>${stat.barName}</a></td>
												<td>${stat.online}</td>
												<td>${stat.offline}</td>
												<td>${stat.pcTotal}</td>
												<td>${stat.areaName}</td>
												<td>${stat.online}</td>
												<td>${stat.offline}</td>
												<td>${stat.pcTotal}</td>
												<%-- <td class="hid" style="display:none;">${stat.barId}</td> --%>
											</tr>
		                            	</c:forEach>
		                            </tbody>
		                            <%-- <tfoot>
			                            <tr>
			                            	<!-- <th></th> -->
			                            	<th>河南省  总计</th>
											<th></th>
											<th></th>
											<th></th>
											<th></th>
											<th></th>
											<th></th>
											<th></th>
										</tr>
										<tr>
		                                    <th colspan="10" style="text-align:right;">
		                                    	<span id="showChart">历史曲线图</span>
		                                    </th>
		                                </tr>
	                                </tfoot> --%>
		                        </table>
                    		</div>
                    		 
                   		</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="${basePath}/js/jquery.min.js?v=2.1.4"></script>
    <script src="${basePath}/js/bootstrap.min.js?v=3.3.6"></script>
    <script src="${basePath}/js/dataTables/jquery.dataTables.min.js"></script>
    <script src="${basePath}/js/dataTables/dataTables.bootstrap.min.js"></script>
    <script src="${basePath}/js/dataTables/dataTables.extends.js"></script>
    <script src="${basePath}/js/bootstrap-editable/bootstrap-editable.min.js"></script>
    <script src="${basePath}/js/dataTables/dataTables.editable.js"></script>
    <script src="${basePath}/js/bootstrap-dialog/bootstrap-dialog.min.js"></script>
    <script src="${basePath}/js/handlebars.js"></script>
    <script src="${basePath}/js/Chart/Chart.js"></script>
	<script src="${basePath}/js/Chart/Chart.min.js"></script>
    <script src="${basePath}/js/ztree/jquery.ztree.min.js"></script>
    <script src="${basePath}/js/content.min.js?v=1.0.0"></script>
    <script src="${basePath}/js/common.js" charset="utf-8"></script>
    <script id="tpl" type="text/x-handlebars-template">
    	<div id="chartDiv" class="tabs-container">
			<div id="chart_line_legend"></div>
    		<canvas id="myChart" width="800" height="300"></canvas>
    	</div>
    </script>
     <!--定义HTML模板-->
	<script id="info_temp" type="text/x-handlebars-template">
		<div class="tabs-container">
             <ul class="nav nav-tabs">
                 <li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true">详细信息</a></li>
             </ul>
             <div class="tab-content">
                 <div id="tab-1" class="tab-pane active">
                     <div class="panel-body">
						<form class="form-horizontal" id="dataForm">
                        <input type="hidden" id="id" name="id" value="{{this.id}}">
		    			<div class="row m-b">
			    	    	<div class="col-sm-2 text-nowrap l-h"><span class="red">*</span>网吧名称：</div>
					    	<div class="col-sm-5"><input type="text" id="netbar_name" name="netbar_name" value="{{this.netbar_name}}" class="form-control" readonly="readonly"></div>
					    </div>
						<div class="row m-b">
			    	    	<div class="col-sm-2 text-nowrap l-h"><span class="red">*</span>许可证号：</div>
					    	<div class="col-sm-5"><input type="text" id="approval_num" name="approval_num" value="{{this.approval_num}}" class="form-control" readonly="readonly"></div>
					    </div>
					    <div class="row m-b">	
			            	<div class="col-sm-2 text-nowrap l-h"><span class="red">*</span>区划地址：</div>
					    	<div class="col-sm-5">
								<input type="hidden" id="reg_address" name="reg_address" value="{{this.reg_address}}">
								<input type="text" id="city_code" name="city_code" value="{{this.city_code}}" class="form-control" readonly="readonly" >
								<input type="text" id="district_code" name="district_code" value="{{this.district_code}}" class="form-control" readonly="readonly" >						
							</div>
						</div>
 						<div class="row m-b">	
			            	<div class="col-sm-2 text-nowrap l-h"> 详细地址：</div>
					    	<div class="col-sm-5"><input type="text" id="reg_address_detail" name="reg_address_detail" value="{{this.reg_address_detail}}" class="form-control" readonly="readonly" ></div>
			            </div>
			            <div class="row m-b">	
			            	<div class="col-sm-2 text-nowrap l-h"> 联系人姓名：</div>
					    	<div class="col-sm-5"><input type="text" id="contact_name" name="contact_name" value="{{this.contact_name}}" class="form-control" readonly="readonly" ></div>
			            </div>
			            <div class="row m-b">	
			            	<div class="col-sm-2 text-nowrap l-h"> 联系人手机号：</div>
					    	<div class="col-sm-5"><input type="text" id="contact_tel" name="contact_tel" value="{{this.contact_tel}}" class="form-control" readonly="readonly" ></div>
			            </div>
						<div class="row m-b">	
			            	<div class="col-sm-2 text-nowrap l-h"><span class="red">*</span>核定终端台数：</div>
					    	<div class="col-sm-5"><input type="text" id="computer_num" name="computer_num" value="{{this.computer_num}}" class="form-control" readonly="readonly"></div>
			            </div>
						
                     </div>
                 </div>
             </div>
        </div>
	</script>
    <script>
    var editableNm="editable";
    var columns = [{data:'isOnline'},{data:'barName'},{data:'zdzs'},{data:'onLineCount'},{data:'offLineCount'},{data:'installNum'}
	,{data:'unInstallNum'},{data:'onLineRate'},{data:'installRate'}/* ,{data:'barId'} */];//,{data:'login'}
	var columnDefs = new Array();
	columnDefs.push({targets:0, className:'text-center', orderable:false, render:function(value,type,row,meta){
		if(value==1)return "<font style='color:red;'>在线</font>";
		else if(value==0)return "离线";
	}});//操作列
	// columnDefs.push({targets:1, className:'text-center', orderable:false, render:optRenderAuth, visible:isVisible});//操作列
	columnDefs.push({targets:1, className:'text-center', orderable:false, render:function(value, type, row, meta){
		 console.log(value+"=="+row.barName+"=="+row+"=="+meta);
		return "<a onclick='showBarInfo(\""+row.barName+"\")' style='color: blue;''>"+value+"</a>";
	}});//操作列
	 
    var url = '${basePath}/netbarList/build/list/query';
    	$(document).ready(function(){
    		var id = "";
    		var parentId = "";
    		var areaName = "";
    		var areaCode="";
    		var districtCode="";
    		initDtSearch();
    		
    		var onClick = function(event, treeId, treeNode, clickFlag) {
				id = treeNode.id;
				parentId = treeNode.pId;
				areaName = treeNode.name;
				
				//再次查询时先删除editable，如果少了以下语句每次只能查询一次，第二次点击查询就不执行。
				var table = $('#'+editableNm).dataTable();
				if(table){
					// table.fnClearTable();
					table.fnDestroy();
				}
    			console.log("---"+treeNode.pId+" id:"+id+"===parentId:"+parentId+"==areaName:"+areaName);
				if(treeNode.pId == 0){
					areaCode="";
					districtCode="";
	        	}else if(treeNode.pId == 410000){
	        		areaCode=treeNode.id;
	        		districtCode="";
	        		
	        	}else{
	        		areaCode=treeNode.pId;
	        		districtCode=treeNode.id;
	        	}
        		//省级表格初始化
        		$('#editable').dataTable({
        			"bSort": false,
        			columns: columns,
        			columnDefs: columnDefs,
        			/* columnDefs:[{
        				targets:0, 
        				orderable:true
        			}], */
    				/* order: [[0, 'asc']], */  //定义列表的初始排序设定
    				paging:false,
    				processing: true, //控制是否在数据加载时出现”Processing”的提示
    				serverSide: true,//pipeline pages 管道式分页加载数据，减少ajax请求
   				 	ajax: {
    			    	url: url, 
    			    	data: {"search":{"value":id,"areaCode":areaCode,"districtCode":districtCode,"querytype":"code1"}},
    			    	type: 'POST', 
    			    	dataSrc: function(result){
    			    		setButtonValue('all');
    			    		var datastr= drawData(result);
    			    		hideTd();
    			    		return datastr;
   			    		}
   			    	},//dataSrc表格数据渲染数据加工的方法
    			    searchDelay: 500,
    			    deferRender: true,//当处理大数据时，延迟渲染数据，有效提高Datatables处理能力
    	           	drawCallback: function(settings){//Datatables每次重绘后执行
    	           		var tr = $('tbody tr.newRow');//初始化新增行的编辑插件
    	           		afterAddRow(tr);
    	           		optTag = null;//重置操作标识
    	           		
    			     }
        		});//返回JQuery对象，api()方法添加到jQuery对象,访问API. 
        		/* $('.dataTables_filter').css('display','none'); */
        		
    		}
    		
    		
    		
    		var setting = {
   				view:{selectedMulti: false},
   				data:{simpleData:{enable:true, idKey:'id', pidKey:'pId', rootPId:0}},
   				callback: {onClick: onClick}
   			};
    		
    		var treeObj = $.fn.zTree.init($('#nodeTree'), setting, parseJSON($('#zNodes').val()));
    		$('#zNodes').remove();

    		//initDtSearch();//表格搜索框回车查询
    		//表格初始化
			oTable = $('#editable').dataTable({
				 "bSort": false,
				/* order:[[0, 'asc']], */  //scrollX:true,
				/* columnDefs:[{targets:0, orderable:true}], */
				/*  ajax: {url:'${basePath}/netbarList/loadAreasBar', type:'POST'}, */
				paging:false
			});//返回JQuery对象，api()方法添加到jQuery对象,访问API.
			dbTable = oTable.api();//返回datatable的API实例,
			$('#export').click(function(){
				window.location.href="${basePath}/netbarList/export?id="+id+"&parentId="+parentId+"&areaName="+areaName;
			});
			
	        $('.spiner-example').remove();//移除遮罩层
	        
    	});
    	function searchByKey(val){
        	console.log("searchByKey==>"+val);
        	var table = $('#'+editableNm).dataTable();
    		if(table){
    			// table.fnClearTable();
    			table.fnDestroy();
    		}  
    	//	var columns = [/* {data:'barId'}, */{data:'barName'},{data:'zdzs'},{data:'onLineCount'},{data:'offLineCount'},{data:'installNum'}
		//	,{data:'unInstallNum'},{data:'onLineRate'},{data:'installRate'}];//,{data:'login'}
			
        	$.com.ajax({
            		url: url,
    		       	data: {"search":{"keyword":val,"querytype":"keywords"}},
    		       	success: function(result){
    		    		var str= drawData(result);
    		    		console.log("++"+JSON.stringify(str));
    		       		$('#'+editableNm).dataTable({
        					paging:false,
        					 "bSort": false,
        					 processing: true,
    						"data": str ,
    				        "columns":columns,
    				        columnDefs: columnDefs
    		   			});
    		       		setButtonValue('all');
    		       		hideTd();
    	       		},
                  	error:function(){
                  		BootstrapDialog.alert({type:'type-danger', message:'操作失败，请刷新重试！'});
                    }
    			});
			 
			
    	}
    	
    	function getStrBetween(str,start,end){
    		return str.substring(str.indexOf(start)+1,str.indexOf(end))
    	}
    	
    	function setButtonValue(querytype){  
   		  $.com.ajax({
        		url: "${basePath}/netbarList/build/statistics",
		       	data: {"search":{"querytype":querytype}},
		       	success: function(result){
		       		console.log("result===>"+result);
		       		 
		       			$("#allbtn").val("全部("+result.total+")");
			    		$("#finishbtn").val("施工完成("+result.deployNum+")");
			    		$("#unfinishbtn").val("施工未完成("+result.undeployNum+")");
		       		 
		       		
	       		},
              	error:function(){
              		BootstrapDialog.alert({type:'type-danger', message:'操作失败，请刷新重试。。'});
                }
			});
    		
    	}
    	
    	function hideTd(){
    		var tds = $("td[class='hid']");
    		for(i = 0; i < tds.length; i++){
    			tds[i].style.display = "none"; //
    		}
    	}
    	
    	 //预编译模板
        var template = Handlebars.compile($('#info_temp').html());
        var dataDialog = function(dataJson){
        	var $this = $(this);
        	var title = ''; //, dataJson = {}
        	/* if($this.is('i.fa-edit')){
        		title = '注册信息';
				var tr = $this.parents('tr');
				dataJson = dbTable.row(tr).data();
        	} */
        	var $div = $(template(dataJson));
        	BootstrapDialog.show({type:'type-default', size:'size-wide', message:$div, title:title, closable:true,
	       		 buttons: [ {
	            	 icon:'fa fa-close', label: '取消',
	                 action: function(dialog){
	                	 dialog.close();
	                 }
             	}],
        		onshown: function(dialog){
        			 
        			
           		}
        	});
        }
    	
    	function loadDataFromSession(querytype){
    		var table = $('#'+editableNm).dataTable();
    		if(table){
    		//	table.fnClearTable();
    			table.fnDestroy();
    		}  
    		
        	$.com.ajax({
            		url: "${basePath}/netbarList/build/session/query",
    		       	data: {"search":{"querytype":querytype}},
    		       	success: function(result){
    		    		var str= drawData(result);
    		    	// 	console.log(str.length+"++"+JSON.stringify(str));
    		       		$('#'+editableNm).dataTable({
        					paging:false,
        					 "bSort": false,
    						"data": str ,
    				        "columns":columns,
    				        columnDefs: columnDefs
    		   			});
    		       		setButtonValue('all');
    		       		hideTd();
    	       		},
                  	error:function(){
                  		BootstrapDialog.alert({type:'type-danger', message:'操作失败，请刷新重试！！'});
                    }
    			});
    	}
    	var showBarInfo=function(barName){
    	//	console.log("show info ===>"+barName);
    		var barId=barName.substring(barName.indexOf("(")+1,barName.indexOf(")"));
    		console.log("barId=====>"+barId);
    		$.com.ajax({
        		url: "${basePath}/netbar2/info/show",
		       	data: {"search":{"id":barId}},
		       	success: function(result){
		       		dataDialog(result);
	       		},
              	error:function(){
              		BootstrapDialog.alert({type:'type-danger', message:'加载数据失败，请刷新重试！！'});
                }
			});
    		
    	}
    	 var goDeploy=function(barName){
    	     	console.log("start deploy ===>"+barName);
    	     	var barId=barName.substring(barName.indexOf("(")+1,barName.indexOf(")"));
    	     	window.open("${basePath}/netbarList/goDeployPrint?barId="+barId,"打印", "height=600, width=1000,top=30,left=50, toolbar =no, menubar=no,scrollbars=no, resizable=no, location=no, status=no");
    	     };
    	 
	</script>
</body>
</html>
