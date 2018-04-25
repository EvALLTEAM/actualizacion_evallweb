package es.uned.nlp.evall.evallweb.portlet.browserepository.controller;

import es.uned.nlp.evall.evallweb.portlet.browserepository.constants.BrowseRepositoryEvallWebConstants;
import es.uned.nlp.evall.evallweb.portlet.core.constant.EvallWebConstants;
import es.uned.nlp.evall.evallweb.portlet.core.controllers.BasePortletController;
import es.uned.nlp.evall.evallweb.portlet.core.model.BenchmarkBean;
import es.uned.nlp.evall.evallweb.portlet.core.model.MeasureBean;
import es.uned.nlp.evall.evallweb.portlet.core.model.OutputBean;
import es.uned.nlp.evall.evallweb.portlet.core.util.AjaxMessageUtil;
import es.uned.nlp.evall.evallweb.portlet.core.util.EvallCookieUtil;
import es.uned.nlp.evall.evallweb.portlet.core.util.EvallFileUtil;
import es.uned.nlp.evall.evallweb.portlet.core.util.EvallUserUtil;
import es.uned.nlp.evall.evallweb.portlet.core.util.ExcelUtil;
import es.uned.nlp.evall.evallweb.service.authorLocalServiceUtil;
import es.uned.nlp.evall.evallweb.service.author_relationLocalServiceUtil;
import es.uned.nlp.evall.evallweb.service.benchmarkLocalServiceUtil;
import es.uned.nlp.evall.evallweb.service.official_measureLocalServiceUtil;
import es.uned.nlp.evall.evallweb.service.outputLocalServiceUtil;
import es.uned.nlp.evall.evallweb.service.resultLocalServiceUtil;
import es.uned.nlp.evallToolkit.measures.EvallTasksEnum;
import es.uned.nlp.evallToolkit.measures.MeasuresEnum;
import es.uned.nlp.evall.evallweb.model.benchmark;
import es.uned.nlp.evall.evallweb.model.official_measure;
import es.uned.nlp.evall.evallweb.model.output;
import es.uned.nlp.evall.evallweb.portal.core.PortalConstants;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.json.JSONObject;
import com.liferay.portal.kernel.util.PropsUtil;
import com.liferay.portal.kernel.util.StringUtil;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.Serializable;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.SortedSet;
import javax.annotation.PostConstruct;
import javax.portlet.PortletException;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;
import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;
import javax.servlet.http.Cookie;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.util.IOUtils;
import org.apache.tika.config.TikaConfig;
import org.apache.tika.detect.Detector;
import org.apache.tika.io.TikaInputStream;
import org.apache.tika.metadata.Metadata;
import org.apache.tika.mime.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.portlet.bind.annotation.RenderMapping;
import org.springframework.web.portlet.bind.annotation.ResourceMapping;

/**
 * Controller class for Browse Repository EvallWeb portlet.
 * 
 * @author Mario Almagro
 * 
 */
@Controller()
@RequestMapping("VIEW")
public class BrowseRepositoryEvallWebController extends BasePortletController implements Serializable {

	private static final long serialVersionUID = 1L;

	/** Constant log. */
    private static final Log _log = LogFactory.getLog(BrowseRepositoryEvallWebController.class);

    /** Constant PORTLET_PAGE_URL. */
    private static final String PORTLET_PAGE_URL = EvallWebConstants.BROWSE_REPOSITORY_PORTLET;

    private String uploadFolder = PropsUtil.get(PortalConstants.UPLOAD_FOLDER);

    @PostConstruct
    public void init() {}

    @Override
    protected String portletBaseViewName() {
        return PORTLET_PAGE_URL;
    }

    @RenderMapping
    public String defaultView(RenderRequest request, RenderResponse response, Model model, @CookieValue(value=EvallWebConstants.COOKIE_NAME, defaultValue=EvallWebConstants.COOKIE_VOID) String configuration) throws PortletException, SystemException, PortalException, IOException {

    	_log.info("defaultView");

    	JSONObject cookie = EvallCookieUtil.getJsonFromCookieValue(configuration);

    	String sessionId = EvallUserUtil.getCurrentSessionId(request);

    	if(cookie.length() > 0 && cookie.has(BrowseRepositoryEvallWebConstants.SESSION_ID_PARAMETER)) {

    		EvallFileUtil.checkUserFolder(sessionId, cookie.getString(BrowseRepositoryEvallWebConstants.SESSION_ID_PARAMETER), uploadFolder);
    	}

    	List<benchmark> benchmarks = benchmarkLocalServiceUtil.getAllEvallTasks(100);

        if(benchmarks != null && !benchmarks.isEmpty()) {

        	SortedSet<String> evalltaks = benchmarkLocalServiceUtil.getTaskValues();
        	SortedSet<String> conferences = benchmarkLocalServiceUtil.getConferenceValues();
        	SortedSet<Integer> years = benchmarkLocalServiceUtil.getYearValues();
        	SortedSet<String> workshops = benchmarkLocalServiceUtil.getWorkshopValues();

        	model.addAttribute(BrowseRepositoryEvallWebConstants.BENCHMARKS_PARAMETER, benchmarks);
        	model.addAttribute(BrowseRepositoryEvallWebConstants.BENCHMARK_EVALLTASK_LIST_PARAMETER, evalltaks);
        	model.addAttribute(BrowseRepositoryEvallWebConstants.BENCHMARK_CONFERENCE_LIST_PARAMETER, conferences);
        	model.addAttribute(BrowseRepositoryEvallWebConstants.BENCHMARK_YEAR_LIST_PARAMETER, years);
        	model.addAttribute(BrowseRepositoryEvallWebConstants.BENCHMARK_WORKSHOP_LIST_PARAMETER, workshops);
        }

        if(cookie.length() > 0 && cookie.has(BrowseRepositoryEvallWebConstants.PORTLET_CONTEXT_PARAMETER) && cookie.getString(BrowseRepositoryEvallWebConstants.PORTLET_CONTEXT_PARAMETER).equals(request.getPortletSession().getPortletContext().getPortletContextName())) {

        	if((EvallUserUtil.isSignedIn(request) && cookie.has(BrowseRepositoryEvallWebConstants.IS_SIGN_IN_PARAMETER) && !cookie.getBoolean(BrowseRepositoryEvallWebConstants.IS_SIGN_IN_PARAMETER)) || 
        			(!EvallUserUtil.isSignedIn(request) && cookie.has(BrowseRepositoryEvallWebConstants.IS_SIGN_IN_PARAMETER) && cookie.getBoolean(BrowseRepositoryEvallWebConstants.IS_SIGN_IN_PARAMETER))) {

        		Iterator<String> it = cookie.keys();

        		while(it.hasNext()) {

        			String key = it.next();

        			model.addAttribute(key, cookie.getString(key));
        		}
        	}
        }

		return fullViewname(BrowseRepositoryEvallWebConstants.DEFAULT_VIEW);
    }

    @RenderMapping(params=BrowseRepositoryEvallWebConstants.VIEW + EvallWebConstants.EQUAL + BrowseRepositoryEvallWebConstants.BENCHMARK_SEARCH_VIEW)
    public String benchmarkSearchView(RenderRequest request, Model model) throws PortletException, SystemException, PortalException, IOException {

    	_log.info("benchmarkSearchView");

    	String textsearch = request.getParameter(BrowseRepositoryEvallWebConstants.TEXT_SEARCH_PARAMETER).trim();
    	String task = request.getParameter(BrowseRepositoryEvallWebConstants.BENCHMARK_EVALLTASK_PARAMETER).trim();
    	String conference = request.getParameter(BrowseRepositoryEvallWebConstants.BENCHMARK_CONFERENCE_PARAMETER).trim();
    	String year = request.getParameter(BrowseRepositoryEvallWebConstants.BENCHMARK_YEAR_PARAMETER).trim();
    	String workshop = request.getParameter(BrowseRepositoryEvallWebConstants.BENCHMARK_WORKSHOP_PARAMETER).trim();

    	if(task.equals(BrowseRepositoryEvallWebConstants.BENCHMARK_ALL_EVALLTASKS)) {

    		task = BrowseRepositoryEvallWebConstants.ALL_REGEX;
    	}

    	if(conference.equals(BrowseRepositoryEvallWebConstants.BENCHMARK_ALL_CONFERENCES)) {

    		conference = BrowseRepositoryEvallWebConstants.ALL_REGEX;
    	}

    	if(year.equals(BrowseRepositoryEvallWebConstants.BENCHMARK_ALL_YEARS)) {

    		year = BrowseRepositoryEvallWebConstants.ALL_REGEX;
    	}

    	if(workshop.equals(BrowseRepositoryEvallWebConstants.BENCHMARK_ALL_WORKSHOPS)) {

    		workshop = BrowseRepositoryEvallWebConstants.ALL_REGEX;
    	}

    	List<benchmark> benchmarks = benchmarkLocalServiceUtil.searchEvallTasks(textsearch, task, conference, year, workshop);

        if(benchmarks != null && !benchmarks.isEmpty()) {

        	model.addAttribute(BrowseRepositoryEvallWebConstants.BENCHMARKS_PARAMETER, benchmarks);
        }

		return fullViewname(BrowseRepositoryEvallWebConstants.DEFAULT_VIEW);
    }

    @RenderMapping(params=BrowseRepositoryEvallWebConstants.VIEW + EvallWebConstants.EQUAL + BrowseRepositoryEvallWebConstants.BENCHMARK_DESCRIPTION_VIEW)
    public String benchmarkDescriptionView(RenderRequest request, Model model) throws PortletException, SystemException, PortalException {

    	_log.info("benchmarkDescriptionView");

    	long benchmarkId = Long.valueOf(request.getParameter(BrowseRepositoryEvallWebConstants.BENCHMARK_ID_PARAMETER).trim());

    	benchmark benchmark = benchmarkLocalServiceUtil.getbenchmark(Long.valueOf(benchmarkId));

        if(benchmark != null) {

        	BenchmarkBean bean = getBenchmarkBean(benchmark);

        	model.addAttribute(BrowseRepositoryEvallWebConstants.BENCHMARK_PARAMETER, bean);
        }

		return fullViewname(BrowseRepositoryEvallWebConstants.BENCHMARK_DESCRIPTION_VIEW);
    }

    @RenderMapping(params=BrowseRepositoryEvallWebConstants.VIEW + EvallWebConstants.EQUAL + BrowseRepositoryEvallWebConstants.SYSTEM_LIST_VIEW)
    public String systemListView(RenderRequest request, Model model) throws PortletException, SystemException, PortalException, IOException, ParseException {

    	_log.info("systemListView");

    	List<OutputBean> outputs = new ArrayList<OutputBean>();

    	int begin = 0;
    	boolean order = false;

    	String benchmarkId = request.getParameter(BrowseRepositoryEvallWebConstants.BENCHMARK_ID_PARAMETER);
    	String pagination = request.getParameter(BrowseRepositoryEvallWebConstants.SYSTEM_PAGINATION_PARAMETER);
    	String field = request.getParameter(BrowseRepositoryEvallWebConstants.SYSTEM_PROPERTY_PARAMETER);
    	String asc = request.getParameter(BrowseRepositoryEvallWebConstants.SYSTEM_ORDER_PARAMETER);
    	String selectedMeasureList = request.getParameter(BrowseRepositoryEvallWebConstants.SYSTEM_SELECTED_MEASURE_LIST_PARAMETER);

    	if(asc != null && !asc.trim().equals(EvallWebConstants.VOID)) {

    		order = Boolean.valueOf(asc);
    	}

    	if(pagination != null && !pagination.trim().equals(EvallWebConstants.VOID)) {

    		try {

    			begin = Integer.parseInt(pagination);

    			begin *= BrowseRepositoryEvallWebConstants.SYSTEM_NUMBER_PER_PAGE;

    		} catch(NumberFormatException e){}
    	}

    	benchmark benchmark = benchmarkLocalServiceUtil.findById(Long.valueOf(benchmarkId));

    	if(benchmark != null) {

    		if(field == null || field.equals(EvallWebConstants.VOID)) {

    			field = benchmark.getOfficialMeasure();
    		}

    		if(selectedMeasureList == null || selectedMeasureList.equals(EvallWebConstants.VOID)) {

    			selectedMeasureList = benchmark.getOfficialMeasure() + ";";

    		} else {

    			selectedMeasureList = selectedMeasureList.replaceAll("(^([^;]+;){" + BrowseRepositoryEvallWebConstants.SYSTEM_NUMBER_MEASURES + "})(.*)", "$1");
    		}

    		Map<String, Double> measures = resultLocalServiceUtil.findMeasuresByBenchmarkId(benchmark.getId());

    		List<String> officialMeasures = getOfficialMeasureIds(benchmark.getId());

    		List<MeasureBean> measureBeanList = new ArrayList<MeasureBean>();

    		for(Map.Entry<String, Double> measure : measures.entrySet()) {

    			MeasuresEnum m = getMeasureEnum(measure.getKey());

    			if(m != null) {

    				MeasureBean measureBean = new MeasureBean(m.name(), m.getName(), m.getAbbreviation(), m.name().equals(benchmark.getOfficialMeasure()), officialMeasures.contains(m.name()), measure.getValue());

    				if(selectedMeasureList.contains(measureBean.getId() + ";")) {

    					measureBean.setSelected(true);
    				}

    				measureBeanList.add(measureBean);
    			}
    		}

    		int totalResult = outputLocalServiceUtil.countAllOutputs(benchmark.getId());

    		model.addAttribute(BrowseRepositoryEvallWebConstants.SYSTEM_RESULT_NUMBER_PARAMETER, totalResult);

    		if(begin > 0 && begin >= totalResult) {

    			begin = (((totalResult + BrowseRepositoryEvallWebConstants.SYSTEM_NUMBER_PER_PAGE - 1) / BrowseRepositoryEvallWebConstants.SYSTEM_NUMBER_PER_PAGE) - 1) * BrowseRepositoryEvallWebConstants.SYSTEM_NUMBER_PER_PAGE;
    		}

    		List<Map<String,Object>> outputs_ = resultLocalServiceUtil.findAllOutputs(benchmark.getId(), begin, BrowseRepositoryEvallWebConstants.SYSTEM_NUMBER_PER_PAGE, field, order);

    		for(Map<String,Object> m : outputs_) {

    			outputs.add(OutputBean.fromObject(m));
    		}

    		model.addAttribute(BrowseRepositoryEvallWebConstants.SYSTEM_PROPERTY_PARAMETER, field);
    		model.addAttribute(BrowseRepositoryEvallWebConstants.BENCHMARK_ID_PARAMETER, benchmarkId);
	    	model.addAttribute(BrowseRepositoryEvallWebConstants.SYSTEM_RESULTS_PARAMETER, outputs);
	    	model.addAttribute(BrowseRepositoryEvallWebConstants.SYSTEM_BEGIN_PAGINATION_PARAMETER, begin);
	    	model.addAttribute(BrowseRepositoryEvallWebConstants.SYSTEM_MEASURE_LIST_PARAMETER, measureBeanList);
	    	model.addAttribute(BrowseRepositoryEvallWebConstants.SYSTEM_SELECTED_MEASURE_LIST_PARAMETER, selectedMeasureList);
    		model.addAttribute(field, !order);
    		model.addAttribute(BrowseRepositoryEvallWebConstants.SYSTEM_ORDER_PAGINATION_PARAMETER, order);
    	}

		return fullViewname(BrowseRepositoryEvallWebConstants.SYSTEM_LIST_VIEW);
    }

    @RenderMapping(params=BrowseRepositoryEvallWebConstants.VIEW + EvallWebConstants.EQUAL + BrowseRepositoryEvallWebConstants.SYSTEM_DESCRIPTION_VIEW)
    public String systemDescriptionView(RenderRequest request, Model model) throws PortletException, SystemException, PortalException, IOException, ParseException {

    	_log.info("systemDescriptionView");

    	String outputID = request.getParameter(BrowseRepositoryEvallWebConstants.SYSTEM_ID_PARAMETER);
    	String benchmarkID = request.getParameter(BrowseRepositoryEvallWebConstants.BENCHMARK_ID_PARAMETER);

    	OutputBean outputBean = OutputBean.fromObject(resultLocalServiceUtil.findOutput(Long.valueOf(outputID), Long.valueOf(benchmarkID)));

    	if(outputBean != null) {

    		model.addAttribute(BrowseRepositoryEvallWebConstants.SYSTEM_PARAMETER, outputBean);
    	}

		return fullViewname(BrowseRepositoryEvallWebConstants.SYSTEM_DESCRIPTION_VIEW);
    }

    @ResourceMapping(value=BrowseRepositoryEvallWebConstants.CREATE_COOKIE_RESOURCE)
	public void createCookie(ResourceRequest request, ResourceResponse response, @CookieValue(value=EvallWebConstants.COOKIE_NAME, defaultValue=EvallWebConstants.COOKIE_VOID) String configuration) throws PortletException, SystemException, PortalException, IOException {

    	_log.info("createCookie...");

    	JSONObject json = EvallCookieUtil.getJsonFromCookieValue(configuration);

		json.put(BrowseRepositoryEvallWebConstants.SESSION_ID_PARAMETER, request.getRequestedSessionId());
		json.put(BrowseRepositoryEvallWebConstants.IS_SIGN_IN_PARAMETER, EvallUserUtil.isSignedIn(request));
		json.put(BrowseRepositoryEvallWebConstants.PORTLET_CONTEXT_PARAMETER, request.getPortletSession().getPortletContext().getPortletContextName());

		for(String key : request.getParameterMap().keySet()) {

			if(request.getParameter(key).equals(EvallWebConstants.VOID)) {

				json.remove(key);

			} else {

				json.put(key, request.getParameter(key));
			}
		}

		configuration = EvallCookieUtil.getCookieValueFromJson(json);

    	Cookie cookie = new Cookie(EvallWebConstants.COOKIE_NAME, configuration);
    	cookie.setVersion(0);
    	cookie.setMaxAge(1200);
    	cookie.setSecure(false);
    	cookie.setPath(BrowseRepositoryEvallWebConstants.BACKSLASH);

    	response.addProperty(cookie);
    }

    @ResourceMapping(value=BrowseRepositoryEvallWebConstants.DOWNLOAD_ICON_BENCHMARK_RESOURCE)
	public void viewIconBenchmark(ResourceRequest request, ResourceResponse response) throws PortletException, SystemException, PortalException, IOException {

    	_log.info("viewIconBenchmark...");

    	String benchmarkId = request.getParameter(BrowseRepositoryEvallWebConstants.BENCHMARK_ID_PARAMETER);

    	benchmark benchmark = benchmarkLocalServiceUtil.findById(Long.valueOf(benchmarkId));

    	if(benchmark != null) {

    		try {

    			InputStream inputStream1 = benchmark.getIcon().getBinaryStream();

    			TikaConfig config = TikaConfig.getDefaultConfig();
    	        Detector detector = config.getDetector();
    	        TikaInputStream streamp = TikaInputStream.get(inputStream1);
    	        Metadata metadata = new Metadata();
    	        metadata.add(Metadata.RESOURCE_NAME_KEY, benchmark.getConference());
    	        MediaType mediaType = detector.detect(streamp, metadata);

    	        InputStream inputStream2 = benchmark.getIcon().getBinaryStream();

    			byte[] fileByte = IOUtils.toByteArray(inputStream2);

    			streamp.close();
    			inputStream1.close();
    			inputStream2.close();

    			response.setContentType(mediaType.toString());
    			response.setProperty("Content-Disposition", "attachment; filename=" + benchmark.getConference());
    			OutputStream outStream = response.getPortletOutputStream();
    			outStream.write(fileByte);
    	        outStream.flush();
    	        outStream.close();

    		} catch(Exception e) {

	    		_log.info("error...");
	    	}

    	} else {

			_log.info("not exists...");
		}
    }

    @ResourceMapping(value=BrowseRepositoryEvallWebConstants.DOWNLOAD_OUTPUT_BBDD_RESOURCE)
	public void downloadFromBBDDFile(ResourceRequest request, ResourceResponse response) throws PortletException, SystemException, PortalException, IOException {

    	_log.info("downloadFromBBDD...");

    	String outputId = request.getParameter(BrowseRepositoryEvallWebConstants.OUTPUT_ID_PARAMETER);

    	output output = outputLocalServiceUtil.findById(Long.valueOf(outputId));

    	if(output != null) {

    		try {

    			InputStream inputStream1 = output.getOutput().getBinaryStream();

    			TikaConfig config = TikaConfig.getDefaultConfig();
    	        Detector detector = config.getDetector();
    	        TikaInputStream streamp = TikaInputStream.get(inputStream1);
    	        Metadata metadata = new Metadata();
    	        metadata.add(Metadata.RESOURCE_NAME_KEY, output.getName());
    	        MediaType mediaType = detector.detect(streamp, metadata);

    	        InputStream inputStream2 = output.getOutput().getBinaryStream();

    			byte[] fileByte = IOUtils.toByteArray(inputStream2);

    			streamp.close();
    			inputStream1.close();
    			inputStream2.close();

    			response.setContentType(mediaType.toString());
    			response.setProperty("Content-Disposition", "attachment; filename=" + output.getName());
    			OutputStream outStream = response.getPortletOutputStream();
    			outStream.write(fileByte);
    	        outStream.flush();
    	        outStream.close();

    		} catch(Exception e) {

	    		_log.info("error...");
	    	}

    	} else {

			_log.info("not exists...");
		}
    }

    @ResourceMapping(value=BrowseRepositoryEvallWebConstants.DOWNLOAD_BENCHMARK_BIBTEX_RESOURCE)
	public void downloadBenchmarkBibtex(ResourceRequest request, ResourceResponse response) throws PortletException, SystemException, PortalException, IOException {

    	_log.info("downloadBenchmarkBibtex...");

    	String outputId = request.getParameter(BrowseRepositoryEvallWebConstants.BENCHMARK_ID_PARAMETER);

    	benchmark benchmark = benchmarkLocalServiceUtil.findById(Long.valueOf(outputId));

    	if(benchmark != null) {

    		try {

    			InputStream inputStream1 = benchmark.getBibtex().getBinaryStream();

    			TikaConfig config = TikaConfig.getDefaultConfig();
    	        Detector detector = config.getDetector();
    	        TikaInputStream streamp = TikaInputStream.get(inputStream1);
    	        Metadata metadata = new Metadata();
    	        metadata.add(Metadata.RESOURCE_NAME_KEY, BrowseRepositoryEvallWebConstants.SYSTEM_BIBTEX_PARAMETER);
    	        MediaType mediaType = detector.detect(streamp, metadata);

    	        InputStream inputStream2 = benchmark.getBibtex().getBinaryStream();

    			byte[] fileByte = IOUtils.toByteArray(inputStream2);

    			streamp.close();
    			inputStream1.close();
    			inputStream2.close();

    			response.setContentType(mediaType.toString());
    			response.setProperty("Content-Disposition", "attachment; filename=" + "bibtex.bib");
    			OutputStream outStream = response.getPortletOutputStream();
    			outStream.write(fileByte);
    	        outStream.flush();
    	        outStream.close();

    		} catch(Exception e) {

	    		_log.info("error...");
	    	}

    	} else {

			_log.info("not exists...");
		}
    }

    @ResourceMapping(value=BrowseRepositoryEvallWebConstants.DOWNLOAD_OUTPUT_BIBTEX_RESOURCE)
	public void downloadOutputBibtex(ResourceRequest request, ResourceResponse response) throws PortletException, SystemException, PortalException, IOException {

    	_log.info("downloadOutputBibtex...");

    	String outputId = request.getParameter(BrowseRepositoryEvallWebConstants.OUTPUT_ID_PARAMETER);

    	output output = outputLocalServiceUtil.findById(Long.valueOf(outputId));

    	if(output != null) {

    		try {

    			InputStream inputStream1 = output.getBibtex().getBinaryStream();

    			TikaConfig config = TikaConfig.getDefaultConfig();
    	        Detector detector = config.getDetector();
    	        TikaInputStream streamp = TikaInputStream.get(inputStream1);
    	        Metadata metadata = new Metadata();
    	        metadata.add(Metadata.RESOURCE_NAME_KEY, BrowseRepositoryEvallWebConstants.SYSTEM_BIBTEX_PARAMETER);
    	        MediaType mediaType = detector.detect(streamp, metadata);

    	        InputStream inputStream2 = output.getBibtex().getBinaryStream();

    			byte[] fileByte = IOUtils.toByteArray(inputStream2);

    			streamp.close();
    			inputStream1.close();
    			inputStream2.close();

    			response.setContentType(mediaType.toString());
    			response.setProperty("Content-Disposition", "attachment; filename=" + "bibtex.bib");
    			OutputStream outStream = response.getPortletOutputStream();
    			outStream.write(fileByte);
    	        outStream.flush();
    	        outStream.close();

    		} catch(Exception e) {

	    		_log.info("error...");
	    	}

    	} else {

			_log.info("not exists...");
		}
    }

    @ResourceMapping(value=BrowseRepositoryEvallWebConstants.DOWNLOAD_EXCEL_RESOURCE)
	public void downloadExcel(ResourceRequest request, ResourceResponse response) throws PortletException, SystemException, PortalException, IOException {

    	_log.info("downloadExcel...");

    	String benchmarkId = request.getParameter(BrowseRepositoryEvallWebConstants.BENCHMARK_ID_PARAMETER);

    	final benchmark benchmark = benchmarkLocalServiceUtil.findById(Long.valueOf(benchmarkId));

    	if(benchmark != null) {

    		final List<OutputBean> outputs = new ArrayList<OutputBean>();

    		final Map<Integer, Integer> boldCells = new HashMap<Integer, Integer>();

    		List<Map<String,Object>> outputs_ = resultLocalServiceUtil.findAllOutputs(benchmark.getId(), 0, 1000, benchmark.getOfficialMeasure(), false);

    		for(Map<String,Object> m : outputs_) {

    			outputs.add(OutputBean.fromObject(m));
    		}

    		final Map<String, Double> measures = resultLocalServiceUtil.findMeasuresByBenchmarkId(benchmark.getId());

    		final List<String> officialMeasures = getOfficialMeasureIds(benchmark.getId());

    		if(outputs.size() > 0) {

    			List<List<String>> data = new ArrayList<List<String>>(){
    				{
    					add(
    							new ArrayList<String>(){
    								{
    									add("Name");
    									add("Title");
    									add("Description");
    									add("Authors");

    									MeasuresEnum officialBenchmarkM = getMeasureEnum(benchmark.getOfficialMeasure());

    									add((officialBenchmarkM == null? "-" : officialBenchmarkM.getName()));

    									for(String officialMeasure : officialMeasures) {

    										if(measures.containsKey(officialMeasure)) {

    											MeasuresEnum officialM = getMeasureEnum(officialMeasure);

    											if(officialM != null) {

    												add(officialM.getAbbreviation() + " (" + officialM.getName() + ")");
    											}
    										}
    									}

    									for(Map.Entry<String, Double> measure : measures.entrySet()) {

    										if(!officialMeasures.contains(measure.getKey()) && !measure.getKey().equals(benchmark.getOfficialMeasure())) {

    											MeasuresEnum officialM = getMeasureEnum(measure.getKey());

    											if(officialM != null) {

    												add(officialM.getAbbreviation() + " (" + officialM.getName() + ")");
    											}
    										}
    									}

    									add("Paper");
    									add("Year");
    								}
    							}
    					);
    				}
    			};

    			for(int i = 0; i < outputs.size(); i++) {

    				final int o = i;

    				data.add(
    						new  ArrayList<String>(){
    							{

    								int j = 5;

    								add(outputs.get(o).getName());
    								add(outputs.get(o).getTitle());
    								add(outputs.get(o).getDescription());
    								add(StringUtil.merge(outputs.get(o).getAuthors(), ","));
    								add(String.valueOf(outputs.get(o).getMeasures().get(benchmark.getOfficialMeasure())));

    								if(String.valueOf(outputs.get(o).getMeasures().get(benchmark.getOfficialMeasure())).equals(String.valueOf(measures.get(benchmark.getOfficialMeasure())))) {

										boldCells.put(4, o + 1);
									}

    								for(String officialMeasure : officialMeasures) {

    									if(measures.containsKey(officialMeasure)) {

    										if(outputs.get(o).getMeasures().containsKey(officialMeasure) && !outputs.get(o).getMeasures().get(officialMeasure).equals("-1")) {

    											add(outputs.get(o).getMeasures().get(officialMeasure));

    											if(outputs.get(o).getMeasures().get(officialMeasure).equals(String.valueOf(measures.get(officialMeasure)))) {

    												boldCells.put(j, o + 1);
    											}

    										} else {

    											add("-");
    										}

    										j++;
    									}
									}

									for(Map.Entry<String, Double> measure : measures.entrySet()) {

										if(!officialMeasures.contains(measure.getKey()) && !measure.getKey().equals(benchmark.getOfficialMeasure())) {

											if(outputs.get(o).getMeasures().containsKey(measure.getKey()) && !outputs.get(o).getMeasures().get(measure.getKey()).equals("-1")) {

												add(outputs.get(o).getMeasures().get(measure.getKey()));

												if(outputs.get(o).getMeasures().get(measure.getKey()).equals(String.valueOf(measures.get(measure.getKey())))) {

    												boldCells.put(j, o + 1);
    											}

											} else {

												add("-");
											}

											j++;
										}
									}

									add(outputs.get(o).getUrlPaper());
									add(outputs.get(o).getYear());
    							}
    						}
    				);
    			}

    			Workbook wb = ExcelUtil.createExcelDocument(benchmark.getName(), data, boldCells);

    			response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml");
    			response.setProperty("Content-Disposition", "attachment; filename=" + benchmark.getName() + ".xlsx");
    			OutputStream outStream = response.getPortletOutputStream();
    			wb.write(outStream);
    	        outStream.flush();
    	        outStream.close();
    		}
    	}
    }

    @ResourceMapping(value=BrowseRepositoryEvallWebConstants.DELETE_FILE_RESOURCE)
    public void delete(ResourceRequest request, ResourceResponse response) throws PortletException, SystemException, PortalException, IOException {

    	_log.info("deleting...");

    	JSONObject message = null;

    	String outputId_ = request.getParameter(BrowseRepositoryEvallWebConstants.OUTPUT_ID_PARAMETER);

    	long outputId = Long.valueOf(outputId_);

    	output o = outputLocalServiceUtil.findById(outputId);

    	message = AjaxMessageUtil.createMessageError("Access denied", JSONFactoryUtil.createJSONObject());

    	if(o != null && EvallUserUtil.getCurrentUserId(request).equals(String.valueOf(o.getUserID()))) {

    		try{

    			author_relationLocalServiceUtil.deleteByDocId(EvallWebConstants.AUTHOR_DOCTYPE_OUTPUT, outputId);

    			authorLocalServiceUtil.deleteUnusedAuthors();

    			outputLocalServiceUtil.deleteoutput(o);

    			message = AjaxMessageUtil.createMessageOk(JSONFactoryUtil.createJSONObject());

    		} catch(Exception e) {

    			message = AjaxMessageUtil.createMessageError("Error", JSONFactoryUtil.createJSONObject());
    		}
    	}

    	OutputStream outStream = response.getPortletOutputStream();
        outStream.write(message.toString().getBytes());
        outStream.flush();
        outStream.close();
    }

    private List<String> getAuthors(int typeDoc, long docID) {

    	List<String> authors = new ArrayList<String>();

    	try {

    		List<String> authors_ = authorLocalServiceUtil.findFullNameByDocId(typeDoc, docID, EvallWebConstants.SPACE, true);

    		if(authors_ != null && !authors_.isEmpty()) {

    			authors.addAll(authors_);
    		}

		} catch (SystemException e) {

			e.printStackTrace();
		}

    	return authors;
    }

    private String getOfficialMeasures(long benchmarkID) {

    	StringBuilder sb = new StringBuilder();

    	try {

    		List<official_measure> officialMeasures = official_measureLocalServiceUtil.findByBenchmarkID(benchmarkID);;

    		if(officialMeasures != null && !officialMeasures.isEmpty()) {

    			for(official_measure officialMeasure : officialMeasures) {

    				MeasuresEnum officialM = getMeasureEnum(officialMeasure.getMeasure());

					if(officialM != null) {

						sb.append(officialM.getName()).append(", ");
					}
    			}

    			sb.delete(sb.length() - 2, sb.length());
    		}

		} catch (SystemException e) {

			e.printStackTrace();
		}

    	return sb.toString();
    }

    private List<String> getOfficialMeasureIds(long benchmarkID) {

    	List<String> ids = new ArrayList<String>();

    	try {

    		List<official_measure> officialMeasures = official_measureLocalServiceUtil.findByBenchmarkID(benchmarkID);;

    		if(officialMeasures != null && !officialMeasures.isEmpty()) {

    			for(official_measure officialMeasure : officialMeasures) {

    				ids.add(officialMeasure.getMeasure());
    			}
    		}

		} catch (SystemException e) {

			e.printStackTrace();
		}

    	return ids;
    }

    private BenchmarkBean getBenchmarkBean(benchmark benchmark) {

    	List<String> authors = getAuthors(EvallWebConstants.AUTHOR_DOCTYPE_BENCHMARK, benchmark.getId());

    	String otherOfficialMeasures = getOfficialMeasures(benchmark.getId());

    	EvallTasksEnum task = getEvallTasksEnum(benchmark.getEvallTasks());

    	MeasuresEnum officialM = getMeasureEnum(benchmark.getOfficialMeasure());

    	return new BenchmarkBean(benchmark.getId(), benchmark.getName(), (task == null? "-" : task.getName()), benchmark.getDescription(),
    			benchmark.getConference(), benchmark.getUrlPaper(), benchmark.getUrlPage(), (officialM == null? "-" : officialM.getName()), otherOfficialMeasures, authors, String.valueOf(benchmark.getYearDate()),
    			benchmark.getWorkshop(), benchmark.getUserID(), benchmark.getIcon() != null, benchmark.getGoldstandard() != null, benchmark.getBibtex() != null);
    }

    private MeasuresEnum getMeasureEnum(String id) {

    	MeasuresEnum measureEnum = null;

    	try {

    		measureEnum = MeasuresEnum.valueOf(id);

		} catch(Exception e) {}

    	return measureEnum;
    }

    private EvallTasksEnum getEvallTasksEnum(String id) {

    	EvallTasksEnum evallTaskEnum = null;

    	try {

    		evallTaskEnum = EvallTasksEnum.valueOf(id);

		} catch(Exception e) {}

    	return evallTaskEnum;
    }
}
