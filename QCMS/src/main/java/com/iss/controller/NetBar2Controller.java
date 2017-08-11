package com.iss.controller;

import java.sql.Timestamp;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.iss.entity.AreasEntity;
import com.iss.entity.NetBar2Entity;
import com.iss.service.IAreasCodeService;
import com.iss.service.INetBar2Service;
import com.iss.util.CommonUtil;
import com.iss.util.DateUtil;
import com.iss.util.HttpClientUtil;
import com.iss.util.JsonUtil;
import com.iss.util.PropertiesUtil;
import com.iss.util.StringUtil;
import com.iss.vo.AjaxJson;
import com.iss.vo.DataParam;
import com.iss.vo.DataTables;


@Controller
@RequestMapping("/netbar2")
public class NetBar2Controller extends BaseController {
	
	private Logger log=LoggerFactory.getLogger(NetBar2Controller.class);
	@Autowired
	private INetBar2Service iNetBarService;
	@Autowired
	private IAreasCodeService iAreasCodeService;
	
	@RequestMapping("/regList")
	public String regList(Model model){
		List<AreasEntity> areasList = iAreasCodeService.getTwolevelAreas("410000");
		model.addAttribute("areasList", areasList);
		return "wh/netbar2_reg";
	}
	
	/**
	 * 加载列表数据
	 * @author liwh 
	 * @param param
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="/load", produces="application/json;charset=UTF-8")
	public String load(DataParam param){
		DataTables<NetBar2Entity> dt = iNetBarService.load(param);
		return JsonUtil.toJson(dt);
	}
	
	@ResponseBody
	@RequestMapping(value="/info/show", produces="application/json;charset=UTF-8")
	public String getBarInfo(DataParam param){
		String idStr=param.getSearch().get("id");
		if(CommonUtil.isEmpty(idStr)){
			return "";
		}
		NetBar2Entity bar= this.iNetBarService.getById(idStr);
		AreasEntity city= this.iAreasCodeService.getById(bar.getCity_code());
		if(city!=null)bar.setCity_code(city.getAreasname());
		
		AreasEntity district= this.iAreasCodeService.getById(bar.getDistrict_code());
		if(district!=null)bar.setDistrict_code(district.getAreasname());
		return JsonUtil.toJson(bar);
	}
	
	/**
	 * 添加数据
	 * @author yjdai 
	 * @param entity
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/add")
	public AjaxJson add(NetBar2Entity entity){
		AjaxJson json = new AjaxJson();
		String url = PropertiesUtil.getPropery("addBarUrl");
		if(StringUtil.isEmpty(entity.getId())){
			//判断网吧注册好事是否存在
			boolean flag = iNetBarService.existBusinessRegNo(entity.getApproval_num());
			if(flag){
				json.setFlag(false);
				json.setMsg("该工商注册号已被注册！");
				return json;
			}
		}else{
			url = PropertiesUtil.getPropery("updateBarUrl");
		}
		entity.setComputer_num(entity.getComputer_num()==null?0:entity.getComputer_num());
		//保存网吧信息
		entity.setIsdeleted(0);
		entity.setIsdeployed(0);
//		entity.setCreator(userEntity.getId());
		entity.setCreate_time(DateUtil.getDate(DateUtil.datetimeformat_str));
		NetBar2Entity fixed = iNetBarService.save(entity);
		//调用接口
		HttpClientUtil.netBarHttpPost(url+fixed.getId(),null);
		
		if(fixed != null){
			json.setFlag(true);
			json.setObj(fixed);
		}
		return json;
	}
	
	@ResponseBody
	@RequestMapping("/getAreas")
	public AjaxJson getCounty(String areasid){
		AjaxJson json = new AjaxJson();
		if(StringUtil.isNotEmpty(areasid)){
			List<AreasEntity> areasList = iAreasCodeService.getThreelevelAreas(areasid);
			if(areasList != null){
				json.setFlag(true);
				json.setObj(areasList);
			}
		}
		return json;
	}
	
	/**
	 * 更新数据
	 * @author yjdai 
	 * @param pk
	 * @param name
	 * @param value
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/del")
	public AjaxJson del(Long pk, String name, String value){
		AjaxJson json = new AjaxJson();
		boolean bool = iNetBarService.update(pk, name, value);
		//调用接口
		HttpClientUtil.netBarHttpPost(PropertiesUtil.getPropery("updateBarUrl")+pk,null);
		json.setFlag(bool);
		return json;
	}
	
	@ResponseBody
	@RequestMapping("/sync")//增量同步
	public AjaxJson syncFromWs(){
		AjaxJson json = new AjaxJson();
		try {
			this.iNetBarService.syncNetBarData(null);
			json.setFlag(true);
			json.setMsg("操作成功");
		} catch (Exception e) {
			// TODO: handle exception
			log.error("",e);
			json.setFlag(false);
			json.setMsg(e.getMessage());;
		}
		return json;
	}
	
	@ResponseBody
	@RequestMapping("/sync/all")//全量同步
	public AjaxJson syncAllFromWs(){
		AjaxJson json = new AjaxJson();
		try {
			this.iNetBarService.delAll();
			this.iNetBarService.syncNetBarData("all");
			json.setFlag(true);
			json.setMsg("操作成功");
		} catch (Exception e) {
			// TODO: handle exception
			log.error("",e);
			json.setFlag(false);
			json.setMsg(e.getMessage());;
		}
		return json;
	}
	
	
	/*@ResponseBody
	@RequestMapping("/deploy/print")
	public AjaxJson printDeploy(
			@RequestParam("barId")String barId
			){
		AjaxJson json = new AjaxJson();
		try {
			this.iNetBarService.printNetBar(barId);
			json.setFlag(true);
			json.setMsg("操作成功");
		} catch (Exception e) {
			// TODO: handle exception
			log.error("",e);
			json.setFlag(false);
			json.setMsg(e.getMessage());;
		}
		return json;
	}*/

}
