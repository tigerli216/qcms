/**
 * 
 */
package com.iss.entity;

import java.io.Serializable;

import javax.persistence.Transient;

import org.jeecgframework.poi.excel.annotation.Excel;
import org.jeecgframework.poi.handler.inter.IExcelModel;

/**
 * @author gxie
 *
 */
public class AreasBarEntity implements Serializable, IExcelModel{
	/**
	 * @Fields serialVersionUID : long  
	 */
	private static final long serialVersionUID = 1L;
	private Long rowId;//序号
	private String errorMsg;//错误消息
	
	private String barId;
	@Excel(name = "网吧名称", orderNum = "1")
	private String barName;
	
	private String approvalNum;
	private Integer computerNum;
	private Integer isdeployed;
	private Integer isOnline;
	private Integer installedNum;

	@Excel(name = "在线终端数", orderNum = "2")
	private Long online;
	@Excel(name = "离线终端数", orderNum = "3")
	private Long offline;
	@Excel(name = "今日累计在线", orderNum = "4")
	private Long onlineNumToday;
	@Excel(name = "昨天累计在线", orderNum = "5")
	private Long onlineNumYsday;
	
	/*@Excel(name = "有效终端数", orderNum = "4")
	private Long valid;
	@Excel(name = "服务端版本号", orderNum = "5")
	private String serverVersion;*/

	public String getBarId() {
		return barId;
	}

	public void setBarId(String barId) {
		this.barId = barId;
	}

	public String getBarName() {
		return barName;
	}

	public void setBarName(String barName) {
		this.barName = barName;
	}

	public Long getOffline() {
		return offline;
	}

	public void setOffline(Long offline) {
		this.offline = offline;
	}

	public Long getOnline() {
		return online;
	}

	public void setOnline(Long online) {
		this.online = online;
	}

	/*public String getServerVersion() {
		return serverVersion;
	}

	public void setServerVersion(String serverVersion) {
		this.serverVersion = serverVersion;
	}

	public Long getValid() {
		return valid;
	}

	public void setValid(Long valid) {
		this.valid = valid;
	}*/
	
	@Transient
	public Long getRowId() {
		return rowId;
	}
	public void setRowId(Long rowId) {
		this.rowId = rowId;
	}
	@Override
	@Transient
	public String getErrorMsg() {
		return errorMsg;
	}
	@Override
	public void setErrorMsg(String errorMsg) {
		this.errorMsg = errorMsg;
	}

	public Long getOnlineNumToday() {
		return onlineNumToday;
	}

	public void setOnlineNumToday(Long onlineNumToday) {
		this.onlineNumToday = onlineNumToday;
	}

	public Long getOnlineNumYsday() {
		return onlineNumYsday;
	}

	public void setOnlineNumYsday(Long onlineNumYsday) {
		this.onlineNumYsday = onlineNumYsday;
	}

	public String getApprovalNum() {
		return approvalNum;
	}

	public void setApprovalNum(String approvalNum) {
		this.approvalNum = approvalNum;
	}

	public Integer getComputerNum() {
		return computerNum;
	}

	public void setComputerNum(Integer computerNum) {
		this.computerNum = computerNum;
	}

	public Integer getIsdeployed() {
		return isdeployed;
	}

	public void setIsdeployed(Integer isdeployed) {
		this.isdeployed = isdeployed;
	}

	public Integer getIsOnline() {
		return isOnline;
	}

	public void setIsOnline(Integer isOnline) {
		this.isOnline = isOnline;
	}

	public Integer getInstalledNum() {
		return installedNum;
	}

	public void setInstalledNum(Integer installedNum) {
		this.installedNum = installedNum;
	}
	

}
