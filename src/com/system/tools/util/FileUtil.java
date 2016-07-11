package com.system.tools.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.lang.reflect.Field;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.FileUploadBase.SizeLimitExceededException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import com.system.tools.pojo.ExcelHeadinfo;
import com.system.tools.pojo.ExcelSheetinfo;
import com.system.tools.pojo.Fileinfo;


public class FileUtil {
	/**
	 * 根据excel模板文件导出
	 * @param request
	 * @param response
	 * @param temps 需要导出的数据集合
	 * @param templatePath 模板文件路径
	 * @param expName 导出
	 * @param iLine 内容开始行
	 * @throws IOException
	 * @throws IllegalArgumentException
	 * @throws IllegalAccessException
	 */
	public static void expExcel(HttpServletRequest request, HttpServletResponse response,ArrayList<?> temps,String templatePath,String expName,int iLine) throws Exception{
		if(templatePath.endsWith(".xls")){
			expExcel2003(request, response, temps, templatePath, expName, iLine);
		}else if(templatePath.endsWith(".xlsx")){
			expExcel2007(request, response, temps, templatePath, expName, iLine);
		}
	}
	public static void expExcel2003(HttpServletRequest request, HttpServletResponse response,ArrayList<?> temps,String templatePath,String expName,int iLine) throws Exception{
		String filePath = request.getServletContext().getRealPath("/")
				+ templatePath;
		InputStream fis = new FileInputStream(filePath);
		HSSFWorkbook hwb = new HSSFWorkbook(fis);
		HSSFSheet sheet = hwb.getSheetAt(0);
		HSSFRow row;
		HSSFCell cell;
		for (int k = 0; k < temps.size(); k++) {
			Object obj = temps.get(k);
			Field[] fields = obj.getClass().getDeclaredFields();
			row = sheet.createRow(iLine);
			int iRow = 0;// 写入每条记录对应Excel中的一列
			for (int j = 0; j < fields.length; j++) {
				Field field = fields[j];
				field.setAccessible(true);// 忽略访问权限，私有的也可以访问
				cell = row.createCell(iRow);
				cell.setCellType(HSSFCell.CELL_TYPE_STRING);
				Object cellvalue = field.get(obj);
				if (CommonUtil.isNotEmpty(cellvalue)) {
					cell.setCellValue(String.valueOf(cellvalue));
				}
				iRow++;
			}
			iLine++;
		}
		response.reset();
		response.addHeader("Content-Disposition", "attachment;filename=\""
				+ new String((expName + ".xls").getBytes("GBK"), "ISO8859_1")
				+ "\"");
		response.setContentType("application/download");
		OutputStream out = response.getOutputStream();
		hwb.write(out);
		out.flush();
		out.close();
	}
	public static void expExcel2007(HttpServletRequest request, HttpServletResponse response,ArrayList<?> temps,String templatePath,String expName,int iLine) throws Exception{
		String filePath = request.getServletContext().getRealPath("/")
				+ templatePath;
		InputStream fis = new FileInputStream(filePath);
		XSSFWorkbook hwb = new XSSFWorkbook(fis);
		XSSFSheet sheet = hwb.getSheetAt(0);
		XSSFRow row;
		XSSFCell cell;
		for (int k = 0; k < temps.size(); k++) {
			Object obj = temps.get(k);
			Field[] fields = obj.getClass().getDeclaredFields();
			row = sheet.createRow(iLine);
			int iRow = 0;// 写入每条记录对应Excel中的一列
			for (int j = 0; j < fields.length; j++) {
				Field field = fields[j];
				field.setAccessible(true);// 忽略访问权限，私有的也可以访问
				cell = row.createCell(iRow);
				cell.setCellType(XSSFCell.CELL_TYPE_STRING);
				Object cellvalue = field.get(obj);
				if (CommonUtil.isNotEmpty(cellvalue)) {
					cell.setCellValue(String.valueOf(cellvalue));
				}
				iRow++;
			}
			iLine++;
		}
		response.reset();
		response.addHeader("Content-Disposition", "attachment;filename=\""
				+ new String((expName + ".xlsx").getBytes("GBK"), "ISO8859_1")
				+ "\"");
		response.setContentType("application/download");
		OutputStream out = response.getOutputStream();
		hwb.write(out);
		out.flush();
		out.close();
	}
	/**
	 * 解析ArrayList<?>成excel2003，然后导出
	 * @param response
	 * @param temps
	 * @param heads
	 * @param discard
	 * @param name
	 * @throws Exception
	 */
	public static void expExcel(HttpServletResponse response, ArrayList<?> temps, String[] heads,
			 String[] discard, String name) throws Exception {
		response.reset();
		response.addHeader("Content-Disposition", "attachment;filename=\""
				+ new String((name+".xls").getBytes("GBK"), "ISO8859_1") + "\"");
		response.setContentType("application/download");
		OutputStream out = response.getOutputStream();
		HSSFWorkbook workbook = new HSSFWorkbook();
		//在Excel工作薄中建一张工作表  
		HSSFSheet sheet = workbook.createSheet("Sheet1");  
		//设置单元格格式(文本)  
		//HSSFCellStyle cellStyle = book.createCellStyle();  

		HSSFRow row = sheet.createRow(0);
		HSSFCell cell;
		// 写入列名称
		for (int i = 0; i < heads.length; i++) {
			cell = row.createCell(i);
			cell.setCellType(HSSFCell.CELL_TYPE_STRING);
			cell.setCellValue(heads[i]);
		}
		int iLine = 1;// 写入各条记录，每条记录对应Excel中的一行
		for (int k = 0; k < temps.size(); k++) {
			Object obj = temps.get(k);
			Field[] fields = obj.getClass().getDeclaredFields();
			row = sheet.createRow(iLine);
			int iRow = 0;// 写入每条记录对应Excel中的一列
			for (int j = 0; j < fields.length; j++) {
				Field field = fields[j];
				field.setAccessible(true);// 忽略访问权限，私有的也可以访问
				boolean discardflag = true;
				if(CommonUtil.isNotEmpty(discard)){
					for (int p = 0; p < discard.length; p++) {
						if (field.getName().equals(discard[p])) {
							discardflag = false;
							break;
						}
					}
				}
				if (discardflag) {
					cell = row.createCell(iRow);
					cell.setCellType(HSSFCell.CELL_TYPE_STRING);
					cell.setCellValue(TypeUtil.objToString(field.get(obj)));
					iRow++;
				}
			}
			iLine++;
		}
		workbook.write(out);
		out.flush();
		out.close();
	}
	/**
	 * 解析ArrayList<?>成excel2003，然后导出
	 * @param response
	 * @param temps
	 * @param heads
	 * @param discard
	 * @param name
	 * @throws Exception
	 */
	public static void expExcel(HttpServletResponse response, ArrayList<?> temps, String[] heads,
			 String name) throws Exception {
		response.reset();
		response.addHeader("Content-Disposition", "attachment;filename=\""
				+ new String((name+".xls").getBytes("GBK"), "ISO8859_1") + "\"");
		response.setContentType("application/download");
		OutputStream out = response.getOutputStream();
		HSSFWorkbook workbook = new HSSFWorkbook();
		//在Excel工作薄中建一张工作表  
		HSSFSheet sheet = workbook.createSheet("Sheet1");  
		//设置单元格格式(文本)  
		//HSSFCellStyle cellStyle = book.createCellStyle();  

		HSSFRow row = sheet.createRow(0);
		HSSFCell cell;
		// 写入列名称
		for (int i = 0; i < heads.length; i++) {
			cell = row.createCell(i);
			cell.setCellType(HSSFCell.CELL_TYPE_STRING);
			cell.setCellValue(heads[i]);
		}
		int iLine = 1;// 写入各条记录，每条记录对应Excel中的一行
		for (int k = 0; k < temps.size(); k++) {
			Object obj = temps.get(k);
			Field[] fields = obj.getClass().getDeclaredFields();
			row = sheet.createRow(iLine);
			int iRow = 0;// 写入每条记录对应Excel中的一列
			for (int j = 0; j < fields.length; j++) {
				Field field = fields[j];
				field.setAccessible(true);// 忽略访问权限，私有的也可以访问
				cell = row.createCell(iRow);
				cell.setCellType(HSSFCell.CELL_TYPE_STRING);
				cell.setCellValue(TypeUtil.objToString(field.get(obj)));
				iRow++;
			}
			iLine++;
		}
		workbook.write(out);
		out.flush();
		out.close();
	}
	/**
	 * 解析List<String[]>成excel2003，然后导出
	 * @param response
	 * @param temps
	 * @param heads
	 * @param discard
	 * @param name
	 * @throws Exception
	 */
	public static void expExcel(HttpServletResponse response, List<String[]> temps, String[] heads,
			String[] discard, String name) throws Exception {
		response.reset();
		response.addHeader("Content-Disposition", "attachment;filename=\""
				+ new String((name+".xls").getBytes("GBK"), "ISO8859_1") + "\"");
		response.setContentType("application/download");
		OutputStream out = response.getOutputStream();
		HSSFWorkbook workbook = new HSSFWorkbook();
		//在Excel工作薄中建一张工作表  
		HSSFSheet sheet = workbook.createSheet("Sheet1");  
		//设置单元格格式(文本)  
		//HSSFCellStyle cellStyle = book.createCellStyle();  

		HSSFRow row = sheet.createRow(0);
		HSSFCell cell;
		// 写入列名称
		for (int i = 0; i < heads.length; i++) {
			cell = row.createCell(i);
			cell.setCellType(HSSFCell.CELL_TYPE_STRING);
			cell.setCellValue(heads[i]);
		}
		int iLine = 1;// 写入各条记录，每条记录对应Excel中的一行
		for (int k = 0; k < temps.size(); k++) {
			String[] values = temps.get(k);
			row = sheet.createRow(iLine);
			int iRow = 0;// 写入每条记录对应Excel中的一列
			for (int j = 0; j < values.length; j++) {
				cell = row.createCell(iRow);
				cell.setCellType(HSSFCell.CELL_TYPE_STRING);
				cell.setCellValue(values[j]);
				iRow++;
			}
			iLine++;
		}
		workbook.write(out);
		out.flush();
		out.close();
		/*
		 * FileOutputStream fOut = new FileOutputStream(xlsName);
		 * workbook.write(fOut); fOut.flush(); fOut.close();
		 * JOptionPane.showMessageDialog(null,"成功导出数据到D盘！");
		 */
	}
	/**
	 * 解析ResultSet成excel，然后导出
	 * @param response
	 * @param rs
	 * @param heads
	 * @param discard
	 * @param name
	 * @throws Exception
	 */
	public static void expExcel(HttpServletResponse response, ResultSet rs, String[] heads,
			String[] discard, String name) throws Exception {
		response.reset();
		response.addHeader("Content-Disposition", "attachment;filename=\""
				+ new String((name+".xls").getBytes("GBK"), "ISO8859_1") + "\"");
		response.setContentType("application/download");
		OutputStream out = response.getOutputStream();
		HSSFWorkbook workbook = new HSSFWorkbook();
		//在Excel工作薄中建一张工作表  
		HSSFSheet sheet = workbook.createSheet("Sheet1");  
		//设置单元格格式(文本)  
		//HSSFCellStyle cellStyle = book.createCellStyle();  
		HSSFRow row = sheet.createRow(0);
		HSSFCell cell;
		ResultSetMetaData md = rs.getMetaData();
		int nColumn = md.getColumnCount();
		// 写入列名称
		for (int i = 0; i < heads.length; i++) {
			cell = row.createCell(i);
			cell.setCellType(HSSFCell.CELL_TYPE_STRING);
			cell.setCellValue(heads[i]);
		}
		int iLine = 1;
		// 写入各条记录，每条记录对应Excel中的一行
		while (rs.next()) {
			row = sheet.createRow(iLine);
			int iRow = 0;// 写入每条记录对应Excel中的一列
			for (int j = 1; j <= nColumn; j++) {
				boolean flag = true;
				for (int p = 0; p < discard.length; p++) {
					if (md.getColumnName(j).toLowerCase().equals(discard[p])) {
						flag = false;
						break;
					}
				}
				if (flag) {
					cell = row.createCell(iRow);
					cell.setCellType(HSSFCell.CELL_TYPE_STRING);
					Object cellvalue = rs.getObject(j);
					if (cellvalue == null) {
						cell.setCellValue("");
					} else {
						cell.setCellValue(String.valueOf(rs.getObject(j)));
					}
					iRow++;
				}
			}
			iLine++;
		}
		workbook.write(out);
		out.flush();
		out.close();
		/*
		 * FileOutputStream fOut = new FileOutputStream(xlsName);
		 * workbook.write(fOut); fOut.flush(); fOut.close();
		 * JOptionPane.showMessageDialog(null,"成功导出数据到D盘！");
		 */
	}
	/**
	 * 上传接口
	 * @param request
	 * @param MAX_SIZE
	 * @param allowedExt
	 * @param name
	 * @param contents
	 * @return
	 */
	public static Fileinfo upload(HttpServletRequest request,long MAX_SIZE,String[] allowedExt,String name,String contents) {
		String fullname = "";
		if(contents==null||"".equals(contents)){
			contents = "";  
		}else{
			contents +="/";
		}
		String type = "";
		String fileurl = "";
		long size = 0;
		if(MAX_SIZE==0){
			MAX_SIZE = 30 * 1024 * 1024;// 设置上传文件最大为 30M  
		}
        // 允许上传的文件格式的列表  
        //final String[] allowedExt = new String[] { "jpg", "jpeg", "gif", "bmp",  "png" };  
        //String newfilepath = System.getProperty("catalina.home");//tomcat地址
        // 实例化一个硬盘文件工厂,用来配置上传组件ServletFileUpload  
        DiskFileItemFactory dfif = new DiskFileItemFactory();  
        dfif.setSizeThreshold(4096);// 设置上传文件时用于临时存放文件的内存大小,这里是4K.多于的部分将临时存在硬盘  
        dfif.setRepository(new File(request.getRealPath("")));// 设置存放临时文件的目录,web根目录下的ImagesUploadTemp目录  
  
        // 用以上工厂实例化上传组件  
        ServletFileUpload sfu = new ServletFileUpload(dfif);  
        // 设置最大上传尺寸  
        sfu.setSizeMax(MAX_SIZE);  
  
        // 从request得到 所有 上传域的列表  
        List fileList = null;  
        try {  
            fileList = sfu.parseRequest(request);  
        } catch (FileUploadException e) {// 处理文件尺寸过大异常  
            if (e instanceof SizeLimitExceededException) {  
                System.out.println("文件尺寸超过规定大小:" + MAX_SIZE + "字节<p />");  
                return null;  
            }  
            e.printStackTrace();  
        }  
        // 没有文件上传  
        if (fileList == null || fileList.size() == 0) {  
            return null;  
        }  
        // 得到所有上传的文件  
        Iterator fileItr = fileList.iterator();  
        // 循环处理所有文件  
        while (fileItr.hasNext()) {  
            FileItem fileItem = null;  
            String path = null;  
            // 得到当前文件  
            fileItem = (FileItem) fileItr.next();  
            // 忽略简单form字段而不是上传域的文件域(<input type="text" />等)  
            if (fileItem == null || fileItem.isFormField()) {  
                continue;  
            }  
            size = 0;  
            // 得到文件的完整路径  
            path = fileItem.getName();  
            // 得到文件的大小  
            size = fileItem.getSize();  
            if ("".equals(path) || size == 0) {  
                return null;  
            }  
  
            // 得到去除路径的文件名  
            String t_name = path.substring(path.lastIndexOf("\\") + 1);  
            // 得到文件的扩展名(无扩展名时将得到全名)  
            if(CommonUtil.isNotEmpty(name)){
    			name = name + t_name.substring(0,t_name.lastIndexOf(".")) + CommonUtil.getNewId();  
    		}else{
    			name = t_name.substring(0,t_name.lastIndexOf(".")) + CommonUtil.getNewId();  
    		}
            type = t_name.substring(t_name.lastIndexOf(".") + 1);
            // 拒绝接受规定文件格式之外的文件类型  
            if(allowedExt==null||allowedExt.length==0){
            }else{
            	int allowFlag = 0;  
 	            int allowedExtCount = allowedExt.length;  
 	            for (; allowFlag < allowedExtCount; allowFlag++) {  
 	                if (allowedExt[allowFlag].equals(type))  
 	                    break;  
 	            }  
 	            if (allowFlag == allowedExtCount) {  
 	                System.out.println("请上传文件类型不在规定范围内！");  
 	                return null;  
 	            }
            }
            fullname = name + "." + type;
	            // 保存的最终文件完整路径,保存在web根目录下的uploaded目录下  
	        fileurl = request.getRealPath("/")+ contents + fullname; 
			/*String u_name = catalinaHome + "/Uploaded/"  
                    + prefix + "." + type; */ 
	        try {
				fileItem.write(new File(fileurl));
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			System.out.println("文件上传成功. 已保存为: " + fullname 
                        + " &nbsp;&nbsp;文件大小: " + size + "字节<p />");  
	 }
        Fileinfo fileinfo = new Fileinfo(contents + fullname,name,type,fileurl,size);
		return fileinfo;
	}
	/**
	 * POI:根据表头信息解析Excel文件中的数据并把每行数据封装成json
	 * @param inputfile
	 * @param excelSheetinfos
	 * @param discardcols
	 * @return
	 */
	public static String impExcel(String inputfile,ArrayList<ExcelSheetinfo> excelSheetinfos,String[] discardcols) {
		if (inputfile.endsWith(".xls"))
			return impExcel2003(inputfile,excelSheetinfos,discardcols);
        else if (inputfile.endsWith(".xlsx"))
        	return impExcel2007(inputfile,excelSheetinfos,discardcols);
		return null;
	}
	public static String impExcel2007(String inputfile,ArrayList<ExcelSheetinfo> excelSheetinfos,String[] discardcols) {
		String json = "[";
		try {
			InputStream fis = new FileInputStream(inputfile); 
			//创建Excel工作薄
			XSSFWorkbook hwb = new XSSFWorkbook(fis);
			//得到第一个工作表
			XSSFSheet sheet = hwb.getSheetAt(0);
			XSSFRow row = null;
			//遍历页签
			for(ExcelSheetinfo excelSheetinfo:excelSheetinfos){
				sheet = hwb.getSheetAt(excelSheetinfo.getXlssheetno() - 1);
				//遍历数据开始行到数据结束行
				for(int j = excelSheetinfo.getHeadstartrow()-1; j < excelSheetinfo.getHeadendrow(); j++) {
					row = sheet.getRow(j);
					json += "{";
					//遍历表头
					for(ExcelHeadinfo excelHeadinfo:excelSheetinfo.getExcelHeadinfos()){
						int p = excelHeadinfo.getTableheadcolno();
						p = p - 1;
						if(p==-1) continue;
						String fieldname = excelHeadinfo.getTableheadfieldname().toLowerCase();
						//***********避开不读取的列开始，参数为列名**********
						if(discardcols !=null){
							boolean isdiscard = false;
							for(int m=0;m<discardcols.length;m++){
								if(fieldname.equals(discardcols[m].toLowerCase())){
									isdiscard = true;
								}
							}
							if(isdiscard) continue;
						}
						//************避开不读取的列结束************
						//读取单元格值
						String cellValue = getCellValue(row.getCell(p));
						if(CommonUtil.isNotEmpty(cellValue))
							json += "'" + fieldname + "':'" + cellValue + "',";
					}
					json = json.substring(0,json.length()-1) + "},";
				}
			}
			json = json.substring(0,json.length()-1) + "]";
			fis.close();  
		} catch (Exception e) {
			e.printStackTrace();
		}
		return json;
	}
	public static String impExcel2003(String inputfile,ArrayList<ExcelSheetinfo> excelSheetinfos,String[] discardcols) {
		String json = "[";
		try {
			InputStream fis = new FileInputStream(inputfile); 
			//创建Excel工作薄
			HSSFWorkbook hwb = new HSSFWorkbook(fis);
			//得到第一个工作表
			HSSFSheet sheet = hwb.getSheetAt(0);
			HSSFRow row = null;
			//遍历页签
			for(ExcelSheetinfo excelSheetinfo:excelSheetinfos){
				sheet = hwb.getSheetAt(excelSheetinfo.getXlssheetno() - 1);
				//遍历数据开始行到数据结束行
				for(int j = excelSheetinfo.getHeadstartrow()-1; j < excelSheetinfo.getHeadendrow(); j++) {
					row = sheet.getRow(j);
					json += "{";
					//遍历表头
					for(ExcelHeadinfo excelHeadinfo:excelSheetinfo.getExcelHeadinfos()){
						int p = excelHeadinfo.getTableheadcolno();
						p = p - 1;
						if(p==-1) continue;
						String fieldname = excelHeadinfo.getTableheadfieldname().toLowerCase();
						//***********避开不读取的列开始，参数为列名**********
						if(discardcols !=null){
							boolean isdiscard = false;
							for(int m=0;m<discardcols.length;m++){
								if(fieldname.equals(discardcols[m].toLowerCase())){
									isdiscard = true;
								}
							}
							if(isdiscard) continue;
						}
						//************避开不读取的列结束************
						//读取单元格值
						String cellValue = getCellValue(row.getCell(p));
						if(CommonUtil.isNotEmpty(cellValue))
							json += "'" + fieldname + "':'" + cellValue + "',";
					}
					json = json.substring(0,json.length()-1) + "},";
				}
			}
			json = json.substring(0,json.length()-1) + "]";
			fis.close();  
		} catch (Exception e) {
			e.printStackTrace();
		}
		return json;
	}
	/**
	 * POI:解析Excel2003文件中的全部数据与heads封装成json
	 * @param inputfile
	 * @param heads
	 * @return 
	 */
	public static String impExcel(String inputfile, String[] heads) {
		if (inputfile.endsWith(".xls"))
			return impExcel2003(inputfile, heads);
        else if (inputfile.endsWith(".xlsx"))
        	return impExcel2007(inputfile, heads);
		return null;
	}
	public static String impExcel2003(String inputfile, String[] heads) {
		String json = "[";
		try {
			InputStream fis = new FileInputStream(inputfile);
			// 创建Excel工作薄
			HSSFWorkbook hwb = new HSSFWorkbook(fis);
			// 得到第一个工作表
			HSSFSheet sheet = hwb.getSheetAt(0);
			HSSFRow row = null;
			// 遍历该表格中所有的工作表，i表示工作表的数量 getNumberOfSheets表示工作表的总数
			for (int i = 0; i < hwb.getNumberOfSheets(); i++) {
				sheet = hwb.getSheetAt(i);
				// 遍历该行所有的行,j表示行数 getPhysicalNumberOfRows行的总数
				for (int j = 1; j < sheet.getPhysicalNumberOfRows(); j++) {
					row = sheet.getRow(j);
					json = json + "{";
					for (int p = 0; p < heads.length; p++) {
						String cellValue = getCellValue(row.getCell(p));
						if(CommonUtil.isNotEmpty(cellValue))
							json += "'" + heads[p] + "':'" + cellValue + "',";
					}
					json = json.substring(0, json.length() - 1) + "},";
				}
				json = json.substring(0, json.length() - 1) + "]";
			}
			fis.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return json;
	}
	public static String impExcel2007(String inputfile, String[] heads) {
		String json = "[";
		try {
			InputStream fis = new FileInputStream(inputfile);
			// 创建Excel工作薄
			XSSFWorkbook hwb = new XSSFWorkbook(fis);
			// 得到第一个工作表
			XSSFSheet sheet = hwb.getSheetAt(0);
			XSSFRow row = null;
			// 遍历该表格中所有的工作表，i表示工作表的数量 getNumberOfSheets表示工作表的总数
			for (int i = 0; i < hwb.getNumberOfSheets(); i++) {
				sheet = hwb.getSheetAt(i);
				// 遍历该行所有的行,j表示行数 getPhysicalNumberOfRows行的总数
				for (int j = 1; j < sheet.getPhysicalNumberOfRows(); j++) {
					row = sheet.getRow(j);
					json = json + "{";
					for (int p = 0; p < heads.length; p++) {
						String cellValue = getCellValue(row.getCell(p));
						if(CommonUtil.isNotEmpty(cellValue))
							json += "'" + heads[p] + "':'" + cellValue + "',";
					}
					json = json.substring(0, json.length() - 1) + "},";
				}
				json = json.substring(0, json.length() - 1) + "]";
			}
			fis.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return json;
	}
	//判断从2003Excel文件中解析出来数据的格式
	public static String getCellValue(HSSFCell cell){
       String value = "";
       //简单的查检列类型
       if (cell != null) {
	       switch(cell.getCellType())
	       {
	           case HSSFCell.CELL_TYPE_STRING://字符串
	        	   value = cell.getRichStringCellValue().getString().trim();
	               break;
	           case HSSFCell.CELL_TYPE_NUMERIC://数字
	        	   if(HSSFDateUtil.isCellDateFormatted(cell)) {//日期格式
	        		   java.util.Date d = cell.getDateCellValue();  
	        		   DateFormat formater = new SimpleDateFormat("yyyy-MM-dd");  
	        		   value = formater.format(d);
	        	   }else if(cell.getCellStyle().getDataFormatString().indexOf("%") != -1) {
	        		   value = cell.getNumericCellValue()+"";
	        	   }else{
		               cell.setCellType(HSSFCell.CELL_TYPE_STRING);  
		               String temp = cell.getStringCellValue();  
		               //判断是否包含小数点，如果不含小数点，则以字符串读取，如果含小数点，则转换为Double类型的字符串  
		               if(temp.indexOf(".")>-1){  
		            	   value = String.valueOf(new Double(temp)).trim();  
		               }else{  
		            	   value = temp.trim();  
		               }  
	        	   }
	               break;
	           case HSSFCell.CELL_TYPE_BLANK://空
	               value = "";
	               break;
	           case HSSFCell.CELL_TYPE_FORMULA://函数
	               //value = String.valueOf(cell.getCellFormula());
	        	   cell.setCellType(XSSFCell.CELL_TYPE_STRING);
	        	   value = cell.getRichStringCellValue().getString();
	               break;
	           case HSSFCell.CELL_TYPE_BOOLEAN://boolean型值
	               value = String.valueOf(cell.getBooleanCellValue());
	               break;
	           case HSSFCell.CELL_TYPE_ERROR:
	               value = String.valueOf(cell.getErrorCellValue());
	               break;
	           default:
	        	   System.out.println("未知类型");
	               break;
	       }
       }
       return value;
	}
	//判断从2007Excel文件中解析出来数据的格式
	public static String getCellValue(XSSFCell cell){
       String value = "";
       //简单的查检列类型
       if (cell != null) {
	       switch(cell.getCellType())
	       {
	           case XSSFCell.CELL_TYPE_STRING://字符串
	               value = cell.getRichStringCellValue().getString().trim();
	               break;
	           case XSSFCell.CELL_TYPE_NUMERIC://数字
	        	   if(HSSFDateUtil.isCellDateFormatted(cell)) {//日期格式
	        		   java.util.Date d = cell.getDateCellValue();  
	        		   DateFormat formater = new SimpleDateFormat("yyyy-MM-dd");  
	        		   value = formater.format(d);
	        	   }else if(cell.getCellStyle().getDataFormatString().indexOf("%") != -1) {
	        		   value = cell.getNumericCellValue()+"";
	        	   }else{
		               cell.setCellType(HSSFCell.CELL_TYPE_STRING);  
		               String temp = cell.getStringCellValue();  
		               //判断是否包含小数点，如果不含小数点，则以字符串读取，如果含小数点，则转换为Double类型的字符串  
		               if(temp.indexOf(".")>-1){  
		            	   value = String.valueOf(new Double(temp)).trim();  
		               }else{  
		            	   value = temp.trim();  
		               }  
	        	   }
	               break;
	           case XSSFCell.CELL_TYPE_BLANK://空
	               value = "";
	               break;   
	           case XSSFCell.CELL_TYPE_FORMULA://函数
	        	 //value = String.valueOf(cell.getCellFormula());
	        	   cell.setCellType(XSSFCell.CELL_TYPE_STRING);
	        	   value = cell.getRichStringCellValue().getString();
	               break;
	           case XSSFCell.CELL_TYPE_BOOLEAN://boolean型值
	               value = String.valueOf(cell.getBooleanCellValue());
	               break;
	           case XSSFCell.CELL_TYPE_ERROR:
	               value = String.valueOf(cell.getErrorCellValue());
	               break;
	           default:
	        	   System.out.println("未知类型");
	               break;
	       }
       }
       return value;
	}
}
