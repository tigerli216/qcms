<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags"%> 

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
		<link rel="stylesheet" href="${basePath}/css/dataTables/dataTables.bootstrap.min.css"/>
		<link rel="stylesheet" href="${basePath}/css/dataTables/fixedColumns.bootstrap.min.css"/>
		<link rel="stylesheet" href="${basePath}/css/bootstrap-editable/bootstrap-editable.css"/>
		<link rel="stylesheet" href="${basePath}/css/datetimepicker/bootstrap-datetimepicker.min.css"/>
		<link rel="stylesheet" href="${basePath}/css/bootstrap-dialog/bootstrap-dialog.min.css"/>
		<link rel="stylesheet" href="${basePath}/css/select2/select2.min.css"/>
		<link rel="stylesheet" href="${basePath}/css/uniform/uniform.css"/>
		<link rel="stylesheet" href="${basePath}/css/animate.min.css"/>
		<link rel="stylesheet" href="${basePath}/css/webuploader/webuploader.css" />
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
                       	<a href="${basePath}/defect/list" class="btn btn-white btn-margin-right"><i class="fa fa-refresh"></i>&nbsp;刷新</a>
                       	<a id="frozenBtn" href="javascript:;" class="btn btn-white btn-margin-right"><i class="fa fa-table"></i>&nbsp;<span>已</span>冻结</a>
                       	<shiro:hasPermission name="defect:add">
                        	<a id="addRow" href="javascript:void(0);" class="btn btn-white btn-margin-right"><i class="fa fa-plus"></i>&nbsp;添加</a>
	                   		<a id="picker" href="javascript:void(0);" class="btn btn-white btn-margin-right"><i class="fa fa-upload"></i>&nbsp;导入Excel</a>
                        </shiro:hasPermission>
                        <shiro:hasPermission name="defect:del">
                        	<a id="delAll" href="javascript:void(0);" class="btn btn-white btn-margin-right"><i class="fa fa-remove"></i>&nbsp;批量删除</a>
                        </shiro:hasPermission>
                   		<a href="${basePath}/defect/export" class="btn btn-white"><i class="fa fa-download"></i>&nbsp;导出Excel</a>
                    </div>
                    <div class="ibox-content">
                        <table class="table table-striped table-bordered table-hover " id="editable">
                            <thead>
                                <tr>
                                	<th><input type="checkbox" class="checkable"/></th>
                                	<th>注释</th>
									<th>主题</th>
									<th>标题</th>
									<th>测试阶段</th>
									<th>发现人</th>
									<th>发现日期</th>
                                	<th>分配给</th>
									<th>估计修复时间</th>
									<th>关闭日期</th>
									<th>关闭于版本</th>
									<th>计划关闭版本</th>
									<th>计划修复日期</th>
                                	<th>检测于版本</th>
									<th>检测于发布</th>
									<th>检测于周期</th>
									<th>可重现</th>
									<th>描述</th>
									<th>目标发布</th>
                                	<th>目标周期</th>
									<th>取消或拒绝理由</th>
									<th>缺陷ID</th>
									<th>缺陷类别</th>
									<th>缺陷状态</th>
									<th>实际修复时间</th>
                                	<th>项目</th>
									<th>修改日期</th>
									<th>严重度</th>
									<th>优先级</th>
									<th>状态</th>
									<th>操作</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="${basePath}/js/jquery.min.js?v=2.1.4"></script>
    <script src="${basePath}/js/bootstrap.min.js?v=3.3.6"></script>
    <script src="${basePath}/js/json3.min.js"></script>
    <script src="${basePath}/js/dataTables/jquery.dataTables.min.js"></script>
    <script src="${basePath}/js/dataTables/dataTables.bootstrap.min.js"></script>
    <script src="${basePath}/js/dataTables/dataTables.extends.js"></script>
    <script src="${basePath}/js/dataTables/dataTables.fixedColumns.min.js"></script>
    <script src="${basePath}/js/bootstrap-editable/bootstrap-editable.min.js"></script>
    <script src="${basePath}/js/dataTables/dataTables.editable.js"></script>
    <script src="${basePath}/js/datetimepicker/bootstrap-datetimepicker.min.js"></script>
    <script src="${basePath}/js/datetimepicker/bootstrap-datetimepicker.zh-CN.js"></script>
    <script src="${basePath}/js/bootstrap-dialog/bootstrap-dialog.min.js"></script>
    <script src="${basePath}/js/select2/select2.full.min.js"></script>
    <script src="${basePath}/js/select2/zh-CN.js"></script>
    <script src="${basePath}/js/handlebars.js"></script>
    <script src="${basePath}/js/uniform/jquery.uniform.js"></script>
    <script src="${basePath}/js/webuploader/webuploader.min.js"></script>
    <script src="${basePath}/js/content.min.js?v=1.0.0"></script>
    <script src="${basePath}/js/common.js" charset="utf-8"></script>
    <!--定义HTML模板-->
	<script id="tpl" type="text/x-handlebars-template">
		<a href="#" id="{{this.data}}" data-type="{{this.type}}" data-pk="{{this.pk}}">{{this.text}}</a>
	</script>
    <script>
    	$(function(){
    		var editUrl = '${basePath}/defect/edit';
    		initDtSearch();//表格搜索框回车查询
    		var initEditable = function(tr, url){
    			var disabled = url!='';
    			$('a[data-type="text"]', tr).editable({disabled:disabled, url:url}).on('save', adjustColumn);
    			$('a[id="fxrq"]', tr).editable({
    				emptytext:'选择', disabled:disabled, url:url, placement: 'bottom',
    				clear:'清除', datetimepicker:{language:'zh-CN',minView:3}, format:'yyyy/mm/dd', viewformat:'yyyy/mm/dd'
    			});
    			$('a[id="gjxfsj"],a[id="gbrq"],a[id="jhxfrq"],a[id="sjxfsj"],a[id="xgrq"]', tr).editable({
    				emptytext:'选择', disabled:disabled, url:url, placement: 'bottom',
    				clear:'清除', datetimepicker:{language:'zh-CN',minView:0}, format:'yyyy/mm/dd hh:ii', viewformat:'yyyy/mm/dd hh:ii'
    			});
    			//验证
    			$('a[id="zt"]', tr).editable('option', 'validate', function(v) {
    			    if(!$.trim(v)) return '主题不能为空！';
    			});
    			$('a[id="bt"]', tr).editable('option', 'validate', function(v) {
    			    if(!$.trim(v)) return '标题不能为空！';
    			});
    			$('a[id="fxr"]', tr).editable('option', 'validate', function(v) {
    			    if(!$.trim(v)) return '发现人不能为空！';
    			});
    			if(disabled){
	    			$('input[type="checkbox"].checkable').uniform();
	    			initCheckbox();
	    			$('.table th input.checkable').prop('checked', false).parent('span').removeClass('checked');
    			}else{
    				afterAddRow(tr);
    			}
    		}
    		//预编译模板
	        var template = Handlebars.compile($('#tpl').html());//{data:'rowId'},
	        var columns = [{data:'id'},{data:'zs', type:'text'},{data:'zt', type:'text'},{data:'bt', type:'text'},
	                       {data:'csjd', type:'text'},{data:'fxr', type:'text'},{data:'fxrq', type:'datetime'},{data:'fpg', type:'text'},
	                       {data:'gjxfsj', type:'datetime'},{data:'gbrq', type:'datetime'},{data:'gbybb', type:'text'},{data:'jhgbbb', type:'text'},
	                       {data:'jhxfrq', type:'datetime'},{data:'jcybb', type:'text'},{data:'jcyfb', type:'text'},{data:'jcyzq', type:'text'},
	                       {data:'kcx', type:'text'},{data:'ms', type:'text'},{data:'mbfb', type:'text'},{data:'mbzq', type:'text'},
	                       {data:'qxhjjly', type:'text'},{data:'qxid', type:'text'},{data:'qxlb', type:'text'},{data:'qxzt', type:'text'},
	                       {data:'sjxfsj', type:'datetime'},{data:'xm', type:'text'},{data:'xgrq', type:'datetime'},{data:'yzd', type:'text'},
	                       {data:'yxj', type:'text'}, {data:'sjzt', type:'text'}];
    		var target=0, columnDefs = new Array();
    		$.each(columns, function(i, o){
    			if(i==0){
		    		columnDefs.push({targets:target++, className:'text-center', orderable:false, render:cbRender});//第一列不参与排序
		    		return true;
    			}
    			columnDefs.push({targets:target++, render:function(data, type, row, meta){
    				o.pk=row.id;
    				var id = o.data;
    				if(id=='fxrq'){
    					o.text = formatDate(data, 'yyyy/MM/dd');
    				}else if(id=='gjxfsj' || id=='gbrq' || id =='jhxfrq' || id=='sjxfsj' || id=='xgrq'){
    					o.text = formatDate(data);
    				}else{
    					o.text=data;
    				}
                	return template(o);
                }});
    		});
    		var isVisible = $('#addRow').length>0 || $('#delAll').length>0;//权限按钮
    		columnDefs.push({targets:target, className:'text-center', orderable:false, render:optRenderAuth, visible:isVisible});//操作列
			//表格初始化
			oTable = $('#editable').dataTable({//dom:dtDom
				scrollY: $('body').height()-260,
				scrollX: true, fixedColumns:{leftColumns: 4},
				columns:columns,
	            columnDefs:columnDefs,autoWidth:false,
				order:[[6, 'desc']],
				processing: true, serverSide: true,//pipeline pages 管道式分页加载数据，减少ajax请求
			    //ajax: $.fn.dataTable.pipeline({url:'${basePath}/customer/load', type:'POST', dataSrc:drawData, pages:5}),
			    ajax: {url:'${basePath}/defect/load', type:'POST', 
			    dataSrc:function(result){return drawData(result);}},//dataSrc表格数据渲染数据加工的方法
			    searchDelay: 300, deferRender: true,//当处理大数据时，延迟渲染数据，有效提高Datatables处理能力
	           	//initComplete: function(settings, json){},//初始化结束后的回调函数
	           	drawCallback: function(settings){//Datatables每次重绘后执行
	           		var tr = $('tbody tr:not(tr.newRow)');//编辑插件初始化
	           		initEditable(tr, editUrl);
	           		tr = $('tbody tr.newRow');//初始化新增行的编辑插件
	           		initEditable(tr, '');
	           		optTag=null;//重置操作标识
			    }
			});//返回JQuery对象，api()方法添加到jQuery对象,访问API.
			dbTable = oTable.api();//$('#editable').DataTable();//返回datatable的API实例,
			//dbTable.on('xhr.dt', function(e, settings, json, xhr){});//ajax事件-当datatable发送ajax请求完成时
		    dbTable.on('error.dt', function(e, settings, techNote, message){//出现异常时调用
		        console.log('An error has been reported by DataTables:', message);
		    }).on('order.dt search.dt length.dt page.dt', function(e, settings){//排序、搜索、分页长度和翻页改变时调用
		    	if(optTag==null)	loadNewRows();//加载新添加的行
		    });
	        //添加新行
	        $('#addRow').click(function(){
	        	optTag='add';
	        	loadNewRows();//加载新添加的行
	        	dbTable.draw(false);
	        });
	        //保存
	        $('#editable tbody').on('click', 'i.fa-save', function(){
				var $this = $(this);
				var tr = $this.parents('tr');
				var data = tr.find('a[id="zt"],a[id="bt"],a[id="fxr"]').editable('getValue');
				if($.trim(data.zt)==''){
					BootstrapDialog.alert({type:'type-default', message:'主题不能为空！'});
					return;
				}
				if($.trim(data.bt)==''){
					BootstrapDialog.alert({type:'type-default', message:'标题不能为空！'});
					return;
				}
				if($.trim(data.fxr)==''){
					BootstrapDialog.alert({type:'type-default', message:'发现人不能为空！'});
					return;
				}
				var element = tr.find('a.editable');
				var obj = element.editable('getValue');
				var dataJson = JSON.parse(JSON.stringify(obj));
				$.com.ajax({
			       	url: '${basePath}/defect/add', 
		           	data:dataJson,
			       	success: function(data) {
			           	if(data.flag) {
			           		var id = data.obj.id;
			           		tr.removeClass('newRow');
			           		//var checkbox = $('<input type="checkbox" class="checkable" value="'+id+'" />');
			           		//var first = tr.find('td:first').append(checkbox);//添加复选框
			           		//checkbox.uniform();//初始化复选框样式
			           		element.removeClass('editable-unsaved');//remove unsaved class
			           		element.editable('destroy');//销毁重新初始化
			           		element.attr('data-pk', id);
			           		initEditable(tr, editUrl);
			           	   	$this.removeClass('fa-save').addClass('fa-edit');
			           	   	tr.find('i.fa-remove').off('click').removeClass('i-remove');
			           	   	element.off('save');//解绑自动显示下一列编辑框事件
			           	 	dbTable.columns.adjust();//重新计算列宽
			           	}else{
			           		BootstrapDialog.alert({type:'type-danger', message:'保存失败，请刷新重试！'});
			           	}               
		       		}
				});
			});
	      	//初始化Web Uploader
    	    var uploader = WebUploader.create({
    	        auto: true,//选完文件后，是否自动上传。
    	        swf: '${basePath}/js/webuploader/Uploader.swf',//swf文件路径
    	        server: '${basePath}/defect/importData',// 文件接收服务端。
    	        pick:{id:'#picker', multiple:false},//multiple是否多选文件
    	        accept: {
    	            title: '选择Excel',//mimeTypes只允许选择excel文件。
    	            mimeTypes:'application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
    	        }
    	    });
    	 	//文件上传过程中创建进度条实时显示。
    	    uploader.on('uploadProgress', function(file, percentage){
    	    	$('.spiner-example').show();
    	    });
    	    //文件上传成功，给item添加成功class, 用样式标记上传成功。
    	    uploader.on('uploadSuccess', function(file, response){
    	    	var msg = response.msg;
    	    	if(response.flag){
	    	    	BootstrapDialog.alert({type:'type-default', message:'数据导入成功！', callback:function(){
	    	    		window.location.href='${basePath}/defect/list';//刷新页面
	        	    }});
    	    	}else{
    	    		BootstrapDialog.alert({type:'type-danger', message:msg, size:BootstrapDialog.SIZE_NORMAL});
    	    	}
    	    });
    	    //文件上传失败，显示上传出错。
    	    uploader.on('uploadError', function(file){
    	    	BootstrapDialog.alert({type:'type-danger', message:'文件上传失败，请刷新重试！'});
    	    });
    	    //完成上传完了，成功或者失败，先清除文件队列。
    	    uploader.on('uploadComplete', function(file){
    	    	$('.spiner-example').hide();
    	    	uploader.reset();
    	    });
    	    delBatch('${basePath}/defect/delBatch');//批量删除
	        initEvent(editUrl);
	        $('.spiner-example').hide();//移除遮罩层
	        /*dbTable.on('order.dt search.dt', function () {//客户端模式添加行号
				dbTable.column(1, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
		            cell.innerHTML = i+1;
		        });
		    }).draw(); */
		    /*dbTable.on('draw.dt',function() {//服务器模式下添加行号
		    	dbTable.column(0, {
	                search: 'applied',
	                order: 'applied'
	            }).nodes().each(function(cell, i) {
	                i += 1; //i 从0开始，所以这里先加1
	                var page = dbTable.page.info();//服务器模式下获取分页信息，使用 DT 提供的 API 直接获取分页信息
	                var pageno = page.page;//当前第几页，从0开始
	                var length = page.length;//每页数据
	                var columnIndex = (i+pageno*length);//行号等于 页数*每页数据长度+行号
	                cell.innerHTML = columnIndex;
	            });
	        }).draw();*/
		});
	</script>
</body>
</html>
