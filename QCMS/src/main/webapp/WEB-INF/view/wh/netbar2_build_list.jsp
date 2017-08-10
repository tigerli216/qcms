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
                    			<input type="button" id="finishbtn" value="施工完成" onclick="loadDataFromSession('finish')">&nbsp;&nbsp;&nbsp;&nbsp;
                    			<input type="button" id="unfinishbtn" value="施工未完成" onclick="loadDataFromSession('unfinish')">
		                        <table class="table table-striped table-bordered table-hover " id="editable">
		                        	
		                            <thead>
		                                <tr>
		                                	<!-- <th style="width:0px;"></th> -->
		                                    <th>网吧名称</th>
											<th>终端总数/(个)</th>
											<th>在线/(个)</th>
											<th>不在线/(个)</th>
											<th>已安装终端/(个)</th>
											<th>未安装终端/(个)</th>
											<th>在线率</th>
											<th>安装率</th>
		                                </tr>
		                            </thead>
		                            <tbody id="tbody_stat">
		                            	<c:forEach var="stat" items="${statList}">
		                            		<tr>
		                            			<%-- <td style="width:0px;">${stat.barId}</td> --%>
												<td>${stat.barName}</td>
												<td>${stat.online}</td>
												<td>${stat.offline}</td>
												<td>${stat.pcTotal}</td>
												<td>${stat.areaName}</td>
												<td>${stat.online}</td>
												<td>${stat.offline}</td>
												<td>${stat.pcTotal}</td>
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
    <script>
    var editableNm="editable";
    var url = '${basePath}/netbarList/build/list/query';
    	$(document).ready(function(){
    		var id = "";
    		var parentId = "";
    		var areaName = "";
    		var areaCode="";
    		var districtCode="";
    		initDtSearch();
    		console.log("--session---${DEPLOY_NETBARS_STATISTICS.total}===${DEPLOY_NETBARS_STATISTICS.deployNum}");
    		var onClick = function(event, treeId, treeNode, clickFlag) {
				id = treeNode.id;
				parentId = treeNode.pId;
				areaName = treeNode.name;
				 
				var columns = [/* {data:'barId'}, */{data:'barName'},{data:'zdzs'},{data:'onLineCount'},{data:'offLineCount'},{data:'installNum'}
				,{data:'unInstallNum'},{data:'onLineRate'},{data:'installRate'}];//,{data:'login'}
				
				//再次查询时先删除editable，如果少了以下语句每次只能查询一次，第二次点击查询就不执行。
				var table = $('#'+editableNm).dataTable();
				if(table){
					table.fnClearTable();
					table.fnDestroy();
				}
    			//获取dataTable的第一行所有单元格
    			var cells = table[0].rows[0].cells;
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
        		console.log(editableNm);
        		//省级表格初始化
        		$('#editable').dataTable({
        			 "bSort": false,
        			columns: columns,
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
    			    	data: {"search":{"value":id,"areaCode":areaCode,"districtCode":districtCode,"querytype":"code"}},
    			    	type: 'POST', 
    			    	dataSrc: function(result){
    			    		 
    			    		/* $.each(result.data,function(index,value){
    			    			 
    			    			
    			    		}); */
    			    		setButtonValue('all');
    			    		return drawData(result);
   			    		}
   			    	},//dataSrc表格数据渲染数据加工的方法
    			    searchDelay: 300,
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
    			table.fnClearTable();
    			table.fnDestroy();
    		} 
    		var columns = [/* {data:'barId'}, */{data:'barName'},{data:'zdzs'},{data:'onLineCount'},{data:'offLineCount'},{data:'installNum'}
			,{data:'unInstallNum'},{data:'onLineRate'},{data:'installRate'}];//,{data:'login'}
			
        	$.com.ajax({
            		url: url,
    		       	data: {"search":{"keyword":val,"querytype":"keywords"}},
    		       	success: function(result){
    		       		 
    		    		var str= drawData(result);
    		    		console.log("++"+JSON.stringify(str));
    		       		$('#'+editableNm).dataTable({
        					paging:false,
        					 "bSort": false,
    						"data": str ,
    				        "columns":columns
    		   			});
    		       		setButtonValue('all');
    	       		},
                  	error:function(){
                  		BootstrapDialog.alert({type:'type-danger', message:'操作失败，请刷新重试！'});
                    }
    			});
			 
			
    	}
    	
    	function setButtonValue(querytype){  
    		$.com.ajax({
        		url: "${basePath}/netbarList/build/statistics",
		       	data: {"search":{"querytype":querytype}},
		       	success: function(result){
		       		$("#allbtn").val("全部("+result.total+")");
		    		$("#finishbtn").val("施工完成("+result.deployNum+")");
		    		$("#unfinishbtn").val("施工未完成("+result.undeployNum+")");
		    		var str= drawData(result);
	       		},
              	error:function(){
              		BootstrapDialog.alert({type:'type-danger', message:'操作失败，请刷新重试！'});
                }
			});
    		
    	}
    	
    	function loadDataFromSession(querytype){
    		var table = $('#'+editableNm).dataTable();
    		if(table){
    			table.fnClearTable();
    			table.fnDestroy();
    		} 
    		var columns = [/* {data:'barId'}, */{data:'barName'},{data:'zdzs'},{data:'onLineCount'},{data:'offLineCount'},{data:'installNum'}
			,{data:'unInstallNum'},{data:'onLineRate'},{data:'installRate'}];//,{data:'login'}
        	$.com.ajax({
            		url: "${basePath}/netbarList/build/session/query",
    		       	data: {"search":{"querytype":querytype}},
    		       	success: function(result){
    		    		var str= drawData(result);
    		    		console.log(str.length+"++"+JSON.stringify(str));
    		       		$('#'+editableNm).dataTable({
        					paging:false,
        					 "bSort": false,
    						"data": str ,
    				        "columns":columns
    		   			});
    		       		setButtonValue('all');
    	       		},
                  	error:function(){
                  		BootstrapDialog.alert({type:'type-danger', message:'操作失败，请刷新重试！'});
                    }
    			});
    	}
    	
    	
    	var hideColumn=function(val){
			$("#t_head").css("display",val); 
		//	$("#t_body").attr("display",val); 
			$("td.t_body_").css("display",val); 
			
			$("#t_foot").css("display",val); 
		}
	</script>
</body>
</html>
