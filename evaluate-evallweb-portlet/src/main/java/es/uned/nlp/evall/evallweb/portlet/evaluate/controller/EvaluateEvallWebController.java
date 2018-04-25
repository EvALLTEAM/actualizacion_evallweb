package es.uned.nlp.evall.evallweb.portlet.evaluate.controller;

import es.uned.nlp.evall.evallweb.portlet.core.constant.EvallWebConstants;
import es.uned.nlp.evall.evallweb.portlet.core.controllers.BasePortletController;
import es.uned.nlp.evall.evallweb.portlet.core.model.BenchmarkBean;
import es.uned.nlp.evall.evallweb.portlet.core.model.OutputBean;
import es.uned.nlp.evall.evallweb.portlet.core.model.ResultBean;
import es.uned.nlp.evall.evallweb.portlet.core.model.UploadMessage;
import es.uned.nlp.evall.evallweb.portlet.core.util.AjaxMessageUtil;
import es.uned.nlp.evall.evallweb.portlet.core.util.EvallCookieUtil;
import es.uned.nlp.evall.evallweb.portlet.core.util.EvallFileUtil;
import es.uned.nlp.evall.evallweb.portlet.core.util.EvallUserUtil;
import es.uned.nlp.evall.evallweb.model.author;
import es.uned.nlp.evall.evallweb.model.benchmark;
import es.uned.nlp.evall.evallweb.model.official_measure;
import es.uned.nlp.evall.evallweb.model.output;
import es.uned.nlp.evall.evallweb.model.result;
import es.uned.nlp.evall.evallweb.portal.core.PortalConstants;
import es.uned.nlp.evall.evallweb.portlet.evaluate.constants.EvaluateEvallWebConstants;
import es.uned.nlp.evall.evallweb.service.authorLocalServiceUtil;
import es.uned.nlp.evall.evallweb.service.author_relationLocalServiceUtil;
import es.uned.nlp.evall.evallweb.service.benchmarkLocalServiceUtil;
import es.uned.nlp.evall.evallweb.service.official_measureLocalServiceUtil;
import es.uned.nlp.evall.evallweb.service.outputLocalServiceUtil;
import es.uned.nlp.evall.evallweb.service.resultLocalServiceUtil;
import es.uned.nlp.evallToolkit.EvallToolkitAPI;
import es.uned.nlp.evallToolkit.configuration.Configuration;
import es.uned.nlp.evallToolkit.errors.EvallErrorAndWarningEnum;
import es.uned.nlp.evallToolkit.errors.EvallErrorAndWarnings;
import es.uned.nlp.evallToolkit.errors.EvallException;
import es.uned.nlp.evallToolkit.measures.EvallTasksEnum;
import es.uned.nlp.evallToolkit.measures.MeasuresEnum;
import es.uned.nlp.evallToolkit.measures.parameters.MeasureParameter;
import es.uned.nlp.evallToolkit.report.elements.DescriptionReport;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.json.JSONObject;
import com.liferay.portal.kernel.servlet.HttpHeaders;
import com.liferay.portal.kernel.upload.UploadPortletRequest;
import com.liferay.portal.kernel.util.PropsUtil;
import com.liferay.portal.util.PortalUtil;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.Serializable;
import java.sql.Blob;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.SortedSet;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.annotation.PostConstruct;
import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletException;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;
import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;
import javax.servlet.http.Cookie;
import javax.sql.rowset.serial.SerialBlob;
import org.apache.commons.codec.binary.Base64;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.poi.util.IOUtils;
import org.apache.tika.config.TikaConfig;
import org.apache.tika.detect.Detector;
import org.apache.tika.io.TikaInputStream;
import org.apache.tika.metadata.Metadata;
import org.apache.tika.mime.MediaType;
import org.apache.tika.mime.MimeTypes;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.portlet.bind.annotation.ActionMapping;
import org.springframework.web.portlet.bind.annotation.RenderMapping;
import org.springframework.web.portlet.bind.annotation.ResourceMapping;

/**
 * Controller class for Evaluate EvallWeb portlet.
 * 
 * @author Mario Almagro
 * 
 */
@Controller()
@RequestMapping("VIEW")
public class EvaluateEvallWebController extends BasePortletController implements Serializable {

	private static final long serialVersionUID = 1L;

	/** Constant log. */
    private static final Log _log = LogFactory.getLog(EvaluateEvallWebController.class);

    /** Constant PORTLET_PAGE_URL. */
    private static final String PORTLET_PAGE_URL = EvallWebConstants.EVALUATE_PORTLET;

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

    	if(cookie.length() > 0 && cookie.has(EvaluateEvallWebConstants.SESSION_ID_PARAMETER)) {

    		EvallFileUtil.checkUserFolder(sessionId, cookie.getString(EvaluateEvallWebConstants.SESSION_ID_PARAMETER), uploadFolder);
    	}

    	EvallFileUtil.includeFilesParameter(sessionId, uploadFolder, EvaluateEvallWebConstants.UPLOADED_FILES, model, EvaluateEvallWebConstants.UPLOAD_FILES_PARAMETER, PortalConstants.UPLOAD_MAX_NUMBER_TSV);

        List<benchmark> benchmarks = benchmarkLocalServiceUtil.getAllEvallTasks(100);

        if(benchmarks != null && !benchmarks.isEmpty()) {

        	SortedSet<String> evalltaks = benchmarkLocalServiceUtil.getTaskValues();
        	SortedSet<String> conferences = benchmarkLocalServiceUtil.getConferenceValues();
        	SortedSet<Integer> years = benchmarkLocalServiceUtil.getYearValues();
        	SortedSet<String> workshops = benchmarkLocalServiceUtil.getWorkshopValues();

        	model.addAttribute(EvaluateEvallWebConstants.BENCHMARKS_PARAMETER, benchmarks);
        	model.addAttribute(EvaluateEvallWebConstants.BENCHMARK_EVALLTASK_LIST_PARAMETER, evalltaks);
        	model.addAttribute(EvaluateEvallWebConstants.BENCHMARK_CONFERENCE_LIST_PARAMETER, conferences);
        	model.addAttribute(EvaluateEvallWebConstants.BENCHMARK_YEAR_LIST_PARAMETER, years);
        	model.addAttribute(EvaluateEvallWebConstants.BENCHMARK_WORKSHOP_LIST_PARAMETER, workshops);
        }

        if(cookie.length() > 0 && cookie.has(EvaluateEvallWebConstants.PORTLET_CONTEXT_PARAMETER) && cookie.getString(EvaluateEvallWebConstants.PORTLET_CONTEXT_PARAMETER).equals(request.getPortletSession().getPortletContext().getPortletContextName())) {

        	if((EvallUserUtil.isSignedIn(request) && cookie.has(EvaluateEvallWebConstants.IS_SIGN_IN_PARAMETER) && !cookie.getBoolean(EvaluateEvallWebConstants.IS_SIGN_IN_PARAMETER)) || 
        			(!EvallUserUtil.isSignedIn(request) && cookie.has(EvaluateEvallWebConstants.IS_SIGN_IN_PARAMETER) && cookie.getBoolean(EvaluateEvallWebConstants.IS_SIGN_IN_PARAMETER))) {

        		Iterator<String> it = cookie.keys();

        		while(it.hasNext()) {

        			String key = it.next();

        			model.addAttribute(key, cookie.getString(key));
        		}
        	}
        }

		return fullViewname(EvaluateEvallWebConstants.DEFAULT_VIEW);
    }

    @RenderMapping(params=EvaluateEvallWebConstants.VIEW + EvallWebConstants.EQUAL + EvaluateEvallWebConstants.BENCHMARK_SEARCH_VIEW)
    public String benchmarkSearchView(RenderRequest request, Model model) throws PortletException, SystemException, PortalException, IOException {

    	_log.info("benchmarkSearchView");

    	String textsearch = request.getParameter(EvaluateEvallWebConstants.TEXT_SEARCH_PARAMETER).trim();
    	String task = request.getParameter(EvaluateEvallWebConstants.BENCHMARK_EVALLTASK_PARAMETER).trim();
    	String conference = request.getParameter(EvaluateEvallWebConstants.BENCHMARK_CONFERENCE_PARAMETER).trim();
    	String year = request.getParameter(EvaluateEvallWebConstants.BENCHMARK_YEAR_PARAMETER).trim();
    	String workshop = request.getParameter(EvaluateEvallWebConstants.BENCHMARK_WORKSHOP_PARAMETER).trim();

    	if(task.equals(EvaluateEvallWebConstants.BENCHMARK_ALL_EVALLTASKS)) {

    		task = EvaluateEvallWebConstants.ALL_REGEX;
    	}

    	if(conference.equals(EvaluateEvallWebConstants.BENCHMARK_ALL_CONFERENCES)) {

    		conference = EvaluateEvallWebConstants.ALL_REGEX;
    	}

    	if(year.equals(EvaluateEvallWebConstants.BENCHMARK_ALL_YEARS)) {

    		year = EvaluateEvallWebConstants.ALL_REGEX;
    	}

    	if(workshop.equals(EvaluateEvallWebConstants.BENCHMARK_ALL_WORKSHOPS)) {

    		workshop = EvaluateEvallWebConstants.ALL_REGEX;
    	}

    	List<benchmark> benchmarks = benchmarkLocalServiceUtil.searchEvallTasks(textsearch, task, conference, year, workshop);

        if(benchmarks != null && !benchmarks.isEmpty()) {

        	model.addAttribute(EvaluateEvallWebConstants.BENCHMARKS_PARAMETER, benchmarks);
        }

		return fullViewname(EvaluateEvallWebConstants.DEFAULT_VIEW);
    }

    @RenderMapping(params=EvaluateEvallWebConstants.VIEW + EvallWebConstants.EQUAL + EvaluateEvallWebConstants.BENCHMARK_DESCRIPTION_VIEW)
    public String benchmarkDescriptionView(RenderRequest request, Model model) throws PortletException, SystemException, PortalException {

    	_log.info("benchmarkDescriptionView");

    	long benchmarkId = Long.valueOf(request.getParameter(EvaluateEvallWebConstants.BENCHMARK_ID_PARAMETER).trim());

    	benchmark benchmark = benchmarkLocalServiceUtil.getbenchmark(Long.valueOf(benchmarkId));

        if(benchmark != null) {

        	BenchmarkBean bean = getBenchmarkBean(benchmark);

        	model.addAttribute(EvaluateEvallWebConstants.BENCHMARK_PARAMETER, bean);
        }

		return fullViewname(EvaluateEvallWebConstants.BENCHMARK_DESCRIPTION_VIEW);
    }

    @RenderMapping(params=EvaluateEvallWebConstants.VIEW + EvallWebConstants.EQUAL + EvaluateEvallWebConstants.METRIC_LIST_VIEW)
    public String metricView(RenderRequest request, Model model) throws PortletException, SystemException, PortalException {

    	_log.info("metricView");

    	String benchmarkId = request.getParameter(EvaluateEvallWebConstants.BENCHMARK_ID_PARAMETER);

    	benchmark benchmark = benchmarkLocalServiceUtil.findById(Long.valueOf(benchmarkId));

    	if(benchmark != null) {

    		List<Boolean> hasParameterList = new ArrayList<Boolean>();

    		Configuration conf = new Configuration(EvallTasksEnum.valueOf(benchmark.getEvallTasks()));

    		Map<String, MeasureParameter> parameters = conf.getMeasureParameters();

    		for(MeasuresEnum measure : conf.getLstPersonalizedMeasures()) {

    			boolean hasParameter = false;

    			for(MeasureParameter parameter : parameters.values()) {

    				if(parameter.getMeasure().compareTo(measure) == 0) {

    					hasParameter = true;
    				}
    			}

    			if(hasParameter) {

    				hasParameterList.add(true);

    			} else {

    				hasParameterList.add(false);
    			}
    		}

    		model.addAttribute(EvaluateEvallWebConstants.METRICS_PARAMETER, conf.getLstPersonalizedMeasures());
    		model.addAttribute(EvaluateEvallWebConstants.HAS_METRIC_PARAMETERS_LIST_PARAMETER, hasParameterList);
    	}

		return fullViewname(EvaluateEvallWebConstants.METRIC_LIST_VIEW);
    }

    @RenderMapping(params=EvaluateEvallWebConstants.VIEW + EvallWebConstants.EQUAL + EvaluateEvallWebConstants.METRIC_CONFIG_VIEW)
    public String metricCconfigurationView(RenderRequest request, Model model) throws PortletException, SystemException, PortalException {

    	_log.info("metricConfigurationView");

    	String benchmarkId = request.getParameter(EvaluateEvallWebConstants.BENCHMARK_ID_PARAMETER).trim();
    	String metricId = request.getParameter(EvaluateEvallWebConstants.METRIC_ID_PARAMETER).trim();
    	String params = request.getParameter(EvaluateEvallWebConstants.METRIC_PARAMETER_LIST_PARAMETER).trim();

    	List<MeasureParameter> measureParameters = new ArrayList<MeasureParameter>();

    	benchmark benchmark = benchmarkLocalServiceUtil.findById(Long.valueOf(benchmarkId));

    	if(benchmark != null) {

    		Configuration conf = new Configuration(EvallTasksEnum.valueOf(benchmark.getEvallTasks()));

    		Map<String, MeasureParameter> parameters = conf.getMeasureParameters();

    		for(MeasureParameter parameter : parameters.values()) {

    			if(metricId.equals(parameter.getMeasure().name())) {

    				String pattern = new StringBuilder("(^|;)").append(parameter.getId()).append("=([^;]*);").toString();
    				Pattern r = Pattern.compile(pattern);
    				Matcher m = r.matcher(params);

    				if(m.find()) {

    					parameter.setValue(Double.valueOf(m.group(2)));
    				}

    				measureParameters.add(parameter);
    			}
    		}
    	}

        if(!measureParameters.isEmpty()) {

        	model.addAttribute(EvaluateEvallWebConstants.METRIC_PARAMETER_LIST_PARAMETER, measureParameters);
        }

		return fullViewname(EvaluateEvallWebConstants.METRIC_CONFIG_VIEW);
    }

    @RenderMapping(params=EvaluateEvallWebConstants.VIEW + EvallWebConstants.EQUAL + EvaluateEvallWebConstants.METRIC_DETAIL_VIEW)
    public String metricDetailView(RenderRequest request, Model model) throws PortletException, SystemException, PortalException {

    	_log.info("metricDetailView");

    	String metricId = request.getParameter(EvaluateEvallWebConstants.METRIC_ID_PARAMETER).trim();

    	MeasuresEnum measure = getMeasureEnum(metricId);

        if(measure != null) {

        	model.addAttribute(EvaluateEvallWebConstants.METRIC_NAME_PARAMETER, measure.getName());
        	model.addAttribute(EvaluateEvallWebConstants.METRIC_DESCRIPTION_PARAMETER, "Description: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.");
        }

		return fullViewname(EvaluateEvallWebConstants.METRIC_DETAIL_VIEW);
    }

    @RenderMapping(params=EvaluateEvallWebConstants.VIEW + EvallWebConstants.EQUAL + EvaluateEvallWebConstants.SYSTEM_LIST_VIEW)
    public String systemListView(RenderRequest request, Model model) throws PortletException, SystemException, PortalException, IOException, ParseException {

    	_log.info("systemListView");

    	List<ResultBean> resultBeanList = new ArrayList<ResultBean>();

    	int begin = 0;
    	int totalResult = 0;
    	String field = EvaluateEvallWebConstants.SYSTEM_VALUE_PARAMETER;
    	boolean order = false;

    	String benchmarkId = request.getParameter(EvaluateEvallWebConstants.BENCHMARK_ID_PARAMETER);
    	String pagination = request.getParameter(EvaluateEvallWebConstants.SYSTEM_PAGINATION_PARAMETER);
    	String property = request.getParameter(EvaluateEvallWebConstants.SYSTEM_PROPERTY_PARAMETER);
    	String asc = request.getParameter(EvaluateEvallWebConstants.SYSTEM_ORDER_PARAMETER);

    	if(property != null && !property.trim().equals(EvallWebConstants.VOID) && asc != null && !asc.trim().equals(EvallWebConstants.VOID)) {

    		field = property;
    		order = Boolean.valueOf(asc);
    	}

    	if(pagination != null && !pagination.trim().equals(EvallWebConstants.VOID)) {

    		try {

    			begin = Integer.parseInt(pagination);

    			begin *= EvaluateEvallWebConstants.SYSTEM_NUMBER_PER_PAGE;

    		} catch(NumberFormatException e){}
    	}

    	benchmark benchmark = benchmarkLocalServiceUtil.findById(Long.valueOf(benchmarkId));

    	if(benchmark != null) {

    		MeasuresEnum measure = getMeasureEnum(benchmark.getOfficialMeasure());

    		model.addAttribute(EvaluateEvallWebConstants.SYSTEM_MEASURE_PARAMETER, (measure == null? "-" : measure.getName()));

    		totalResult = resultLocalServiceUtil.countByBenchmarkIdAndMeasure(benchmark.getId(), benchmark.getOfficialMeasure());

    		model.addAttribute(EvaluateEvallWebConstants.SYSTEM_RESULT_NUMBER_PARAMETER, totalResult);

    		resultBeanList = resultLocalServiceUtil.findByBenchmarkIdAndMeasure(benchmark.getId(), benchmark.getOfficialMeasure(), begin, EvaluateEvallWebConstants.SYSTEM_NUMBER_PER_PAGE, field, order);
        }

    	model.addAttribute(field, !order);
		model.addAttribute(EvaluateEvallWebConstants.SYSTEM_PROPERTY_PARAMETER, field);
    	model.addAttribute(EvaluateEvallWebConstants.SYSTEM_RESULTS_PARAMETER, resultBeanList);
    	model.addAttribute(EvaluateEvallWebConstants.SYSTEM_BEGIN_PAGINATION_PARAMETER, begin);

		return fullViewname(EvaluateEvallWebConstants.SYSTEM_LIST_VIEW);
    }

    @RenderMapping(params=EvaluateEvallWebConstants.VIEW + EvallWebConstants.EQUAL + EvaluateEvallWebConstants.SYSTEM_DESCRIPTION_VIEW)
    public String systemDescriptionView(RenderRequest request, Model model) throws PortletException, SystemException, PortalException, IOException, ParseException {

    	_log.info("systemDescriptionView");

    	String resultId = request.getParameter(EvaluateEvallWebConstants.SYSTEM_ID_PARAMETER);

    	List<ResultBean> resultBeanList = resultLocalServiceUtil.findBeanById(Long.valueOf(resultId));

    	if(!resultBeanList.isEmpty()) {

    		model.addAttribute(EvaluateEvallWebConstants.SYSTEM_PARAMETER, resultBeanList.get(0));
    	}

		return fullViewname(EvaluateEvallWebConstants.SYSTEM_DESCRIPTION_VIEW);
    }

    @RenderMapping(params=EvaluateEvallWebConstants.VIEW + EvallWebConstants.EQUAL + EvaluateEvallWebConstants.RESULT_VIEW)
    public String resultView(RenderRequest request, Model model) throws PortletException, SystemException, PortalException, IOException {

    	_log.info("resultView");

    	if(request.getParameter(EvaluateEvallWebConstants.RESULT_ERROR_PARAMETER) == null && request.getParameter(EvaluateEvallWebConstants.RESULT_REPORT_PATH_PARAMETER) != null) {

    		model.addAttribute(EvaluateEvallWebConstants.RESULT_IS_EVALUATED_PARAMETER, true);
    		model.addAttribute(EvaluateEvallWebConstants.RESULT_REPORT_PATH_PARAMETER, request.getParameter(EvaluateEvallWebConstants.RESULT_REPORT_PATH_PARAMETER));
    		request.removeAttribute(EvaluateEvallWebConstants.RESULT_REPORT_PATH_PARAMETER);

    	} else {

    		model.addAttribute(EvaluateEvallWebConstants.RESULT_ERROR_PARAMETER, request.getParameter(EvaluateEvallWebConstants.RESULT_ERROR_PARAMETER));
    	}

		model.addAttribute(EvaluateEvallWebConstants.BENCHMARK_ID_PARAMETER, request.getParameter(EvaluateEvallWebConstants.BENCHMARK_ID_PARAMETER));

		return fullViewname(EvaluateEvallWebConstants.RESULT_VIEW);
    }

    @RenderMapping(params=EvaluateEvallWebConstants.VIEW + EvallWebConstants.EQUAL + EvaluateEvallWebConstants.DEFAULT_RESULT_VIEW)
    public String defaultResultView(RenderRequest request, Model model) throws PortletException, SystemException, PortalException, IOException {

    	_log.info("defaultResultView");

		return fullViewname(EvaluateEvallWebConstants.RESULT_VIEW);
    }

    @RenderMapping(params=EvaluateEvallWebConstants.VIEW + EvallWebConstants.EQUAL + EvaluateEvallWebConstants.SAVE_OUTPUT_VIEW)
    public String saveOutputView(RenderRequest request, Model model) throws PortletException, SystemException, PortalException, IOException, ParseException {

    	_log.info("saveOutputView");

    	String benchmarkId = request.getParameter(EvaluateEvallWebConstants.BENCHMARK_ID_PARAMETER);

    	String isSaved = request.getParameter(EvaluateEvallWebConstants.OUTPUT_IS_SAVED_PARAMETER);

    	String sessionId = EvallUserUtil.getCurrentSessionId(request);

    	EvallFileUtil.includeFilesParameter(sessionId, uploadFolder, EvaluateEvallWebConstants.UPLOADED_FILES, model, EvaluateEvallWebConstants.UPLOAD_FILES_PARAMETER, PortalConstants.UPLOAD_MAX_NUMBER_TSV);

    	areExistFileNames(sessionId, uploadFolder, EvaluateEvallWebConstants.UPLOADED_FILES, Long.valueOf(benchmarkId), model, EvaluateEvallWebConstants.UPLOAD_FILES_VALIDATION_NAME_PARAMETER);

    	if(isSaved == null || Boolean.valueOf(isSaved)) {

    		model.addAttribute(EvaluateEvallWebConstants.OUTPUT_IS_SAVED_PARAMETER, true);
    	}

    	return fullViewname(EvaluateEvallWebConstants.SAVE_OUTPUT_VIEW);
    }

    @RenderMapping(params=EvaluateEvallWebConstants.VIEW + EvallWebConstants.EQUAL + EvaluateEvallWebConstants.SAVE_OUTPUT_DETAIL_VIEW)
    public String outputDetailView(RenderRequest request, Model model) throws PortletException, SystemException, PortalException, IOException, ParseException {

    	_log.info("outputDetailView");

    	String sessionId = EvallUserUtil.getCurrentSessionId(request);

    	String tempId = request.getParameter(EvaluateEvallWebConstants.OUTPUT_ID_PARAMETER).trim();

    	EvallFileUtil.includeFileParameter(sessionId, tempId, uploadFolder, EvaluateEvallWebConstants.UPLOADED_FILES, model, EvaluateEvallWebConstants.UPLOAD_FILE_PARAMETER);

    	String folderName = new StringBuilder(uploadFolder).append(File.separatorChar).append(sessionId)
    			.append(File.separatorChar).append(EvaluateEvallWebConstants.UPLOADED_FILES).toString();

    	boolean alreadySaved = EvallFileUtil.isDb(folderName, tempId);

    	if(alreadySaved) {

    		try {

    			long dbId = EvallFileUtil.getDbId(folderName, tempId);

    			output output = outputLocalServiceUtil.findById(dbId);

				model.addAttribute(EvaluateEvallWebConstants.OUTPUT_DESCRIPTION_PARAMETER, output.getDescription());
				model.addAttribute(EvaluateEvallWebConstants.OUTPUT_TITLE_PARAMETER, output.getTitle());
				model.addAttribute(EvaluateEvallWebConstants.OUTPUT_URL_PAPER_PARAMETER, output.getUrlPaper());
				model.addAttribute(EvaluateEvallWebConstants.OUTPUT_PUBLICATION_YEAR_PARAMETER, output.getYearPublication());
				model.addAttribute(EvaluateEvallWebConstants.OUTPUT_BIBTEX_PARAMETER, EvaluateEvallWebConstants.OUTPUT_BIBTEX_SAVED_PARAMETER);
				model.addAttribute(EvaluateEvallWebConstants.OUTPUT_AUTHORS_PARAMETER, authorLocalServiceUtil.findByDocId(EvallWebConstants.AUTHOR_DOCTYPE_OUTPUT, dbId));

    		} catch(Exception e) {}
    	}

    	return fullViewname(EvaluateEvallWebConstants.SAVE_OUTPUT_DETAIL_VIEW);
    }

    @ResourceMapping(value=EvaluateEvallWebConstants.LOAD_EXAMPLE_FILE_RESOURCE)
	public void loadExampleFile(ResourceRequest request, ResourceResponse response) throws PortletException, SystemException, PortalException, IOException, IllegalArgumentException, IllegalAccessException {

    	_log.info("loading example file...");

    	UploadMessage uploadMessage = new UploadMessage();

    	String sessionId = EvallUserUtil.getCurrentSessionId(request);

    	String folderName = new StringBuilder(uploadFolder).append(File.separatorChar).append(sessionId)
    			.append(File.separatorChar).append(EvaluateEvallWebConstants.UPLOADED_FILES).toString();

    	File folder = new File(folderName);

    	folder.mkdirs();

    	int lastId = EvallFileUtil.getIncrementedId(folderName);

    	String benchmarkId = request.getParameter(EvaluateEvallWebConstants.BENCHMARK_ID_PARAMETER);

    	String maximumNumber = request.getParameter(EvaluateEvallWebConstants.UPLOAD_MAXIMUM_NUMBER_PARAMETER);

    	if(maximumNumber != null && folder.listFiles().length < Integer.valueOf(maximumNumber)) {

	    	if(benchmarkId != null) {

	    		try {

	    			OutputBean outputBean = OutputBean.fromObject(outputLocalServiceUtil.findRandom(Long.valueOf(benchmarkId)));

					if(outputBean != null) {

						InputStream is = new ByteArrayInputStream(outputBean.getOutput());

						long size =  outputBean.getOutput().length;

    					uploadMessage.setFileId(String.valueOf(lastId));
    					uploadMessage.setFileName(outputBean.getName());
    					uploadMessage.setFileSize(size / 1024 + " Kb");

    					TikaInputStream tikaIS = TikaInputStream.get(is);
						Metadata metadata = new Metadata();
						uploadMessage.setFileType(MimeTypes.getDefaultMimeTypes().detect(tikaIS, metadata).toString());

						long totalSize = size;

						for(File f : folder.listFiles()) {

    						totalSize += f.length();
    					}

						if(totalSize < PortalConstants.UPLOAD_MAX_KB * 1024) {

							new File(new StringBuilder(folderName).append(File.separatorChar).append(lastId).toString()).mkdir();

							String originalName = new StringBuilder(folderName).append(File.separatorChar).append(lastId).append(File.separatorChar).append(outputBean.getName()).toString();

							OutputStream outputStream = new FileOutputStream(new File(originalName));

							if(is != null) {

								IOUtils.copy(is, outputStream);

    							is.close();
    						}

							outputStream.flush();
							outputStream.close();

						} else {

							uploadMessage.addError(PortalConstants.UPLOAD_MAX_SIZE_MESSAGE);
						}
					}

				} catch (IllegalArgumentException e) {
	
					uploadMessage.addError(PortalConstants.UPLOAD_ERROR_CREATING_MESSAGE);
	
					e.printStackTrace();
				}
	    	}
    	} else {

    		uploadMessage.addError(PortalConstants.UPLOAD_MAX_NUMBER_MESSAGE);
    	}

		JSONObject responseMessage = null;

		if(uploadMessage.hasErrors()) {

			responseMessage = AjaxMessageUtil.createMessageError("error", uploadMessage.toJson());

		} else if(uploadMessage.hasWarnings()) {

			responseMessage = AjaxMessageUtil.createMessageWarning("warning", uploadMessage.toJson());

		} else {

			responseMessage = AjaxMessageUtil.createMessageOk(uploadMessage.toJson());
		}

		OutputStream outStream = response.getPortletOutputStream();
		outStream.write(responseMessage.toString().getBytes());
		outStream.flush();
		outStream.close();
    }

    @ResourceMapping(value=EvaluateEvallWebConstants.UPLOAD_FILE_RESOURCE)
	public void upload(ResourceRequest request, ResourceResponse response) throws PortletException, SystemException, PortalException, IOException, IllegalArgumentException, IllegalAccessException {

    	_log.info("uploading...");

    	UploadMessage uploadMessage = new UploadMessage();

    	String sessionId = EvallUserUtil.getCurrentSessionId(request);

    	String folderName = new StringBuilder(uploadFolder).append(File.separatorChar).append(sessionId)
    			.append(File.separatorChar).append(EvaluateEvallWebConstants.UPLOADED_FILES).toString();

    	File folder = new File(folderName);

    	folder.mkdirs();

    	int lastId = EvallFileUtil.getIncrementedId(folderName);

    	UploadPortletRequest uploadReq = PortalUtil.getUploadPortletRequest(request);

    	String name = uploadReq.getFullFileName(EvaluateEvallWebConstants.FILE_PARAMETER);

    	File file = uploadReq.getFile(EvaluateEvallWebConstants.FILE_PARAMETER);

    	String maximumNumber = uploadReq.getParameter(EvaluateEvallWebConstants.UPLOAD_MAXIMUM_NUMBER_PARAMETER);

    	String mimeType = uploadReq.getContentType(EvaluateEvallWebConstants.FILE_PARAMETER);

    	if(name != null && file != null) {

    		if(maximumNumber != null && folder.listFiles().length < Integer.valueOf(maximumNumber)) {

    			if(mimeType.startsWith(PortalConstants.TEXT_MIMETYPE) || mimeType.startsWith(PortalConstants.CSV_MIMETYPE) || mimeType.startsWith(PortalConstants.NO_MIMETYPE)) {

    				try {

	    				InputStream stream = uploadReq.getFileAsStream(EvaluateEvallWebConstants.FILE_PARAMETER, true);
	    				long size = uploadReq.getSize(EvaluateEvallWebConstants.FILE_PARAMETER);

		    	    	uploadMessage.setFileId(String.valueOf(lastId));
		    	    	uploadMessage.setFileName(name);
		    	    	uploadMessage.setFileSize(size / 1024 + " Kb");
		    	    	uploadMessage.setFileType(mimeType);

		    	    	long totalSize = size;

		    	    	for(File f : folder.listFiles()) {

		    	    		totalSize += f.length();
		    	    	}

		    	    	if(totalSize < PortalConstants.UPLOAD_MAX_KB * 1024) {

							new File(new StringBuilder(folderName).append(File.separatorChar).append(lastId).toString()).mkdir();

		    	    		String originalName = new StringBuilder(folderName).append(File.separatorChar).append(lastId).append(File.separatorChar).append(name).toString();

		    	    		OutputStream outputStream = new FileOutputStream(new File(originalName));

		    	    		if(stream != null) {

		    	    			IOUtils.copy(stream, outputStream);

		    	    			stream.close();
		    	    		}

		    	    		outputStream.flush();
		    	    		outputStream.close();

		    	    	} else {

		    	    		uploadMessage.addError(PortalConstants.UPLOAD_MAX_SIZE_MESSAGE);
		    	    	}

    				} catch (IllegalArgumentException e) {

    					uploadMessage.addError(PortalConstants.UPLOAD_ERROR_CREATING_MESSAGE);

    					e.printStackTrace();
    				}

    			} else {

    				uploadMessage.addError(PortalConstants.UPLOAD_MIMETYPE_MESSAGE);
    			}

    		} else {

    			uploadMessage.addError(PortalConstants.UPLOAD_MAX_NUMBER_MESSAGE);
    		}

    		JSONObject responseMessage = null;

    		if(uploadMessage.hasErrors()) {

    			responseMessage = AjaxMessageUtil.createMessageError("error", uploadMessage.toJson());

    		} else if(uploadMessage.hasWarnings()) {

    			responseMessage = AjaxMessageUtil.createMessageWarning("warning", uploadMessage.toJson());

    		} else {

    			responseMessage = AjaxMessageUtil.createMessageOk(uploadMessage.toJson());
    		}

    		OutputStream outStream = response.getPortletOutputStream();
    		outStream.write(responseMessage.toString().getBytes());
    		outStream.flush();
    		outStream.close();
    	}
    }

    @ResourceMapping(value=EvaluateEvallWebConstants.UPLOAD_BIBTEX_RESOURCE)
	public void uploadBibtex(ResourceRequest request, ResourceResponse response) throws PortletException, SystemException, PortalException, IOException, IllegalArgumentException, IllegalAccessException {

    	_log.info("uploadBibtex...");

    	String sessionId = EvallUserUtil.getCurrentSessionId(request);

    	String outputFolderName = new StringBuilder(uploadFolder).append(File.separatorChar).append(sessionId)
    			.append(File.separatorChar).append(EvaluateEvallWebConstants.UPLOADED_FILES).toString();

    	String bibtexFolderName = new StringBuilder(uploadFolder).append(File.separatorChar).append(sessionId)
    			.append(File.separatorChar).append(EvaluateEvallWebConstants.UPLOADED_BIBTEX).toString();

    	new File(bibtexFolderName).mkdirs();

    	UploadMessage fileMeta = null;

    	JSONObject message = JSONFactoryUtil.createJSONObject();

    	UploadPortletRequest uploadReq = PortalUtil.getUploadPortletRequest(request);

    	String outputId = request.getParameter(EvaluateEvallWebConstants.OUTPUT_ID_PARAMETER);

    	File output = EvallFileUtil.getFileById(outputFolderName, outputId);

    	File bibtexFile = uploadReq.getFile(EvaluateEvallWebConstants.OUTPUT_BIBTEX_PARAMETER);

    	if(output != null && output.exists() && bibtexFile != null && bibtexFile.exists()) {

    		String name = output.getName();

    		try {

    			String mimeType = uploadReq.getContentType(EvaluateEvallWebConstants.OUTPUT_BIBTEX_PARAMETER);

    	    	InputStream stream = uploadReq.getFileAsStream(EvaluateEvallWebConstants.OUTPUT_BIBTEX_PARAMETER, true);

    			fileMeta = new UploadMessage("1", name, "", mimeType);

    			String originalName = new StringBuilder(bibtexFolderName).append(File.separatorChar).append(output.getParentFile().getName()).append(File.separatorChar).append(name).toString();

				new File(new StringBuilder(bibtexFolderName).append(File.separatorChar).append(output.getParentFile().getName()).toString()).mkdir();

    			File finalFile = new File(originalName);

    			if(finalFile.exists()) {

    				finalFile.delete();
    			}

    			OutputStream outputStream = new FileOutputStream(finalFile);

    			if(stream != null) {

    				IOUtils.copy(stream, outputStream);

    				stream.close();
    			}

    			outputStream.flush();
    			outputStream.close();

    			message = AjaxMessageUtil.createMessageOk(fileMeta.toJson());

    		} catch (IllegalArgumentException | IllegalAccessException e) {

    			message = AjaxMessageUtil.createMessageError(PortalConstants.UPLOAD_ERROR_CREATING_MESSAGE, fileMeta.toJson());

    			e.printStackTrace();
    		}

    		OutputStream outStream = response.getPortletOutputStream();
    		outStream.write(message.toString().getBytes());
    		outStream.flush();
    		outStream.close();
    	}
   }

    @ResourceMapping(value=EvaluateEvallWebConstants.DELETE_FILE_RESOURCE)
    public void delete(ResourceRequest request, ResourceResponse response) throws PortletException, SystemException, PortalException, IOException {

    	_log.info("deleting...");

    	JSONObject message = null;

    	String sessionId = EvallUserUtil.getCurrentSessionId(request);

    	String fileId = request.getParameter(EvaluateEvallWebConstants.FILE_ID_PARAMETER);

    	String folderName = new StringBuilder(uploadFolder).append(File.separatorChar).append(sessionId).append(File.separatorChar).append(EvaluateEvallWebConstants.UPLOADED_FILES).toString();

    	File file = EvallFileUtil.getFolderById(folderName, fileId);

    	if(file != null && EvallFileUtil.deleteAllFiles(file.getPath(), true)) {

    		message = AjaxMessageUtil.createMessageOk(JSONFactoryUtil.createJSONObject());

    	} else {

    		message = AjaxMessageUtil.createMessageError("Not exist", JSONFactoryUtil.createJSONObject());
    	}

    	OutputStream outStream = response.getPortletOutputStream();
        outStream.write(message.toString().getBytes());
        outStream.flush();
        outStream.close();
    }

    @ResourceMapping(value=EvaluateEvallWebConstants.DELETE_ALL_FILE_RESOURCE)
    public void deleteAll(ResourceRequest request, ResourceResponse response) throws PortletException, SystemException, PortalException, IOException {

    	_log.info("deleting all...");

    	JSONObject message = null;

    	String sessionId = EvallUserUtil.getCurrentSessionId(request);

    	String folderName = new StringBuilder(uploadFolder).append(File.separatorChar).append(sessionId)
    			.append(File.separatorChar).append(EvaluateEvallWebConstants.UPLOADED_FILES).toString();

    	if(EvallFileUtil.deleteAllFiles(folderName, false)) {

    		message = AjaxMessageUtil.createMessageOk(JSONFactoryUtil.createJSONObject());

    	} else {

    		message = AjaxMessageUtil.createMessageError("Not exists", JSONFactoryUtil.createJSONObject());
    	}

    	OutputStream outStream = response.getPortletOutputStream();
        outStream.write(message.toString().getBytes());
        outStream.flush();
        outStream.close();
    }

    @ResourceMapping(value=EvaluateEvallWebConstants.DOWNLOAD_FILE_RESOURCE)
	public void downloadFile(ResourceRequest request, ResourceResponse response) throws PortletException, SystemException, PortalException, IOException {

    	_log.info("download...");

    	String sessionId = EvallUserUtil.getCurrentSessionId(request);

    	String fileId = request.getParameter(EvaluateEvallWebConstants.FILE_ID_PARAMETER);

    	String folderName = new StringBuilder(uploadFolder).append(File.separatorChar).append(sessionId)
    			.append(File.separatorChar).append(EvaluateEvallWebConstants.UPLOADED_FILES).toString();

    	File file = EvallFileUtil.getFileById(folderName, fileId);

    	if(file != null) {

    		try {

    			InputStream is1 = new FileInputStream(file);

    			TikaConfig config = TikaConfig.getDefaultConfig();
    	        Detector detector = config.getDetector();
    	        TikaInputStream streamp = TikaInputStream.get(is1);
    	        Metadata metadata = new Metadata();
    	        metadata.add(Metadata.RESOURCE_NAME_KEY, file.getName());
    	        MediaType mediaType = detector.detect(streamp, metadata);

    	        InputStream is2 = new FileInputStream(file);

    			byte[] fileByte = IOUtils.toByteArray(is2);

    			streamp.close();
    			is1.close();
    			is2.close();

    			response.setContentType(mediaType.toString());
    			response.setProperty(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + file.getName() + "\"");
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

    @ResourceMapping(value=EvaluateEvallWebConstants.RENAME_FILE_RESOURCE)
	public void renameFile(ResourceRequest request, ResourceResponse response) throws PortletException, SystemException, PortalException, IOException, IllegalArgumentException, IllegalAccessException {

    	_log.info("renameFile...");

    	JSONObject message = AjaxMessageUtil.createMessageError("Not exist", JSONFactoryUtil.createJSONObject());;

    	String sessionId = EvallUserUtil.getCurrentSessionId(request);

    	String fileId = request.getParameter(EvaluateEvallWebConstants.FILE_ID_PARAMETER);

    	String outputName = request.getParameter(EvaluateEvallWebConstants.FILE_NAME_PARAMETER);

    	String folderName = new StringBuilder(uploadFolder).append(File.separatorChar).append(sessionId)
    			.append(File.separatorChar).append(EvaluateEvallWebConstants.UPLOADED_FILES).toString();

    	File file = EvallFileUtil.getFileById(folderName, fileId);

    	if(file != null) {

    		try {

    			if(file.getParentFile().listFiles().length > 1) {

    				message = AjaxMessageUtil.createMessageError("Duplicate", JSONFactoryUtil.createJSONObject());

    			} else {

    				file.renameTo(new File(file.getParentFile().getPath() + File.separator + outputName));

    				message = AjaxMessageUtil.createMessageOk(JSONFactoryUtil.createJSONObject());
    			}

    		} catch (IllegalArgumentException e) {

    			message = AjaxMessageUtil.createMessageError("Error by renaming file", JSONFactoryUtil.createJSONObject());

    			e.printStackTrace();
    		}
    	}

    	OutputStream outStream = response.getPortletOutputStream();
        outStream.write(message.toString().getBytes());
        outStream.flush();
        outStream.close();
   }

    @ResourceMapping(value=EvaluateEvallWebConstants.CHECK_FILE_RESOURCE)
	public void checkFile(ResourceRequest request, ResourceResponse response) throws PortletException, SystemException, PortalException, IOException, IllegalArgumentException, IllegalAccessException {

    	_log.info("checkFile...");

    	UploadMessage uploadMessage = new UploadMessage();

    	String sessionId = EvallUserUtil.getCurrentSessionId(request);

    	String fileId = request.getParameter(EvaluateEvallWebConstants.FILE_ID_PARAMETER);

    	String benchmarkId = request.getParameter(EvaluateEvallWebConstants.BENCHMARK_ID_PARAMETER).trim();

    	String folderName = new StringBuilder(uploadFolder).append(File.separatorChar).append(sessionId)
    			.append(File.separatorChar).append(EvaluateEvallWebConstants.UPLOADED_FILES).toString();

    	File file = EvallFileUtil.getFileById(folderName, fileId);

    	if(file != null) {

    		try {

    			benchmark benchmark = benchmarkLocalServiceUtil.findById(Long.valueOf(benchmarkId));

    	    	EvallTasksEnum evallTask = null;

    	    	if(benchmark != null) {

    	    		evallTask = EvallTasksEnum.valueOf(benchmark.getEvallTasks());
    	    	}

    	    	if(evallTask == null) {

    	    		uploadMessage.addError("Benchmark is not found");
    	    	}

    	    	uploadMessage.setFileId(fileId);
    	    	uploadMessage.setFileName(EvallWebConstants.VOID);
    	    	uploadMessage.setFileSize(EvallWebConstants.VOID);
    	    	uploadMessage.setFileType(EvallWebConstants.VOID);

    			ArrayList<EvallErrorAndWarnings> formatErrors = getFormatErrors(file.getName(), file, evallTask);

    			for(EvallErrorAndWarnings evallErrorAndWarnings : formatErrors) {

    				if(evallErrorAndWarnings.getType().compareTo(EvallErrorAndWarningEnum.ERROR) == 0) {

    					uploadMessage.addError(evallErrorAndWarnings.getText().replaceAll(EvallWebConstants.FORMAT_ERROR, EvallWebConstants.FORMAT_SPAN).trim());

    				} else {

    					uploadMessage.addWarning(evallErrorAndWarnings.getText().replaceAll(EvallWebConstants.FORMAT_WARNING, EvallWebConstants.FORMAT_SPAN).trim());
    				}
    			}

    		} catch (Exception e) {

    			uploadMessage.addError("File can't be checked");

    			e.printStackTrace();
    		}

    		JSONObject responseMessage = null;

    		if(uploadMessage.hasErrors()) {

    			responseMessage = AjaxMessageUtil.createMessageError("error", uploadMessage.toJson());

    		} else if(uploadMessage.hasWarnings()) {

    			responseMessage = AjaxMessageUtil.createMessageWarning("warning", uploadMessage.toJson());

    		} else {

    			responseMessage = AjaxMessageUtil.createMessageOk(uploadMessage.toJson());
    		}

    		OutputStream outStream = response.getPortletOutputStream();
    		outStream.write(responseMessage.toString().getBytes());
    		outStream.flush();
    		outStream.close();
    	}
   }

    @ResourceMapping(value=EvaluateEvallWebConstants.DOWNLOAD_PDF_REPORT_RESOURCE)
	public void downloadReport(ResourceRequest request, ResourceResponse response) throws PortletException, SystemException, PortalException, IOException {

    	_log.info("downloadResult_report...");

    	String encodedpath = request.getParameter(EvaluateEvallWebConstants.RESULT_REPORT_PATH_PARAMETER);
    	String mode = request.getParameter(EvaluateEvallWebConstants.RESULT_DOWNLOAD_MODE_PARAMETER);

    	String folderTarget = new String(Base64.decodeBase64(encodedpath));

    	String sessionId = EvallUserUtil.getCurrentSessionId(request);

    	String pathTarget = new StringBuilder(uploadFolder).append(File.separatorChar)
    			.append(sessionId).append(File.separatorChar).append(folderTarget)
    			.append(PortalConstants.EVALL_LATEX).append(PortalConstants.EVALL_REPORT).toString();

		File file = new File(pathTarget);

		if(file.exists()) {

			InputStream is1 = new FileInputStream(file);

			TikaConfig config = TikaConfig.getDefaultConfig();
	        Detector detector = config.getDetector();
	        TikaInputStream streamp = TikaInputStream.get(is1);
	        Metadata metadata = new Metadata();
	        metadata.add(Metadata.RESOURCE_NAME_KEY, file.getName());
	        MediaType mediaType = detector.detect(streamp, metadata);

	        InputStream is2 = new FileInputStream(file);

			byte[] fileByte = IOUtils.toByteArray(is2);

			streamp.close();
			is1.close();
			is2.close();

			response.setContentType(mediaType.toString());

			if(mode == null || !mode.equals(EvaluateEvallWebConstants.RESULT_DOWNLOAD_MODE_VIEW_PARAMETER)) {

				response.setProperty(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + PortalConstants.EVALL_REPORT_NAME + "\"");
				response.setContentType("application/pdf");
			}

			OutputStream outStream = response.getPortletOutputStream();
			outStream.write(fileByte);
	        outStream.flush();
	        outStream.close();
		}
    }

    @ResourceMapping(value=EvaluateEvallWebConstants.DOWNLOAD_LATEX_REPORT_RESOURCE)
	public void downloadLatexReport(ResourceRequest request, ResourceResponse response) throws PortletException, SystemException, PortalException, IOException {

    	_log.info("downloadResult_latexReport...");

    	String encodedpath = request.getParameter(EvaluateEvallWebConstants.RESULT_REPORT_PATH_PARAMETER);

    	String sessionId = EvallUserUtil.getCurrentSessionId(request);

    	String userFolder = new StringBuilder(uploadFolder).append(File.separatorChar).append(sessionId).append(File.separatorChar).toString();

    	String folderTarget = new String(Base64.decodeBase64(encodedpath));

    	String pathTarget = new StringBuilder(userFolder).append(folderTarget).append(PortalConstants.EVALL_LATEX).toString();

		File directory = new File(pathTarget);

		if(directory.exists() && directory.isDirectory()) {

			String fileCompressName = new StringBuilder(directory.getParent()).append(File.separatorChar).append("LaTeX").append(".zip").toString();

			if(!new File(fileCompressName).exists()) {

				byte[] buffer = new byte[1024];

				FileOutputStream fos = new FileOutputStream(fileCompressName);
		    	ZipOutputStream zos = new ZipOutputStream(fos);

		    	for(File f : directory.listFiles()) {

					ZipEntry ze = new ZipEntry(f.getName());
					zos.putNextEntry(ze);
					FileInputStream in = new FileInputStream(f);
					int len;

		        	while ((len = in.read(buffer)) > 0) {
		        		zos.write(buffer, 0, len);
		        	}

		        	in.close();
		    	}

		    	zos.closeEntry();
		    	zos.close();
				fos.close();
			}

			File fileCompress = new File(fileCompressName);
			InputStream compressStream = new FileInputStream(fileCompress);

			byte[] fileByte = IOUtils.toByteArray(compressStream);

			compressStream.close();

			response.setContentType("application/zip");
			response.setProperty(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + PortalConstants.EVALL_LATEX_NAME + "\"");
			OutputStream outStream = response.getPortletOutputStream();
			outStream.write(fileByte);
	        outStream.flush();
	        outStream.close();
		}
    }

    @ResourceMapping(value=EvaluateEvallWebConstants.DOWNLOAD_TSV_REPORT_RESOURCE)
	public void downloadTSV(ResourceRequest request, ResourceResponse response) throws PortletException, SystemException, PortalException, IOException {

    	_log.info("downloadResult_tsv...");

    	String encodedpath = request.getParameter(EvaluateEvallWebConstants.RESULT_REPORT_PATH_PARAMETER);

    	String sessionId = EvallUserUtil.getCurrentSessionId(request);

    	String userFolder = new StringBuilder(uploadFolder).append(File.separatorChar).append(sessionId).append(File.separatorChar).toString();

    	String folderTarget = new String(Base64.decodeBase64(encodedpath));

    	String pathTarget = new StringBuilder(userFolder).append(folderTarget).append(PortalConstants.EVALL_TSV).toString();

		File directory = new File(pathTarget);

		if(directory.exists() && directory.isDirectory()) {

			String fileCompressName = new StringBuilder(directory.getParent()).append(File.separatorChar).append("TSV").append(".zip").toString();

			if(!new File(fileCompressName).exists()) {

				byte[] buffer = new byte[1024];

				FileOutputStream fos = new FileOutputStream(fileCompressName);
		    	ZipOutputStream zos = new ZipOutputStream(fos);

		    	for(File f : directory.listFiles()) {

					ZipEntry ze = new ZipEntry(f.getName());
					zos.putNextEntry(ze);
					FileInputStream in = new FileInputStream(f);

					int len;

		        	while ((len = in.read(buffer)) > 0) {

		        		zos.write(buffer, 0, len);
		        	}

		        	in.close();
		    	}

		    	zos.closeEntry();
		    	zos.close();
				fos.close();
			}

			File fileCompress = new File(fileCompressName);
			InputStream compressStream = new FileInputStream(fileCompress);

			byte[] fileByte = IOUtils.toByteArray(compressStream);

			compressStream.close();

			response.setContentType("application/zip");
			response.setProperty(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + PortalConstants.EVALL_TSV_NAME + "\"");
			OutputStream outStream = response.getPortletOutputStream();
			outStream.write(fileByte);
	        outStream.flush();
	        outStream.close();
		}
    }

    @ResourceMapping(value=EvaluateEvallWebConstants.DOWNLOAD_OUTPUT_BBDD_RESOURCE)
	public void downloadFromBBDDFile(ResourceRequest request, ResourceResponse response) throws PortletException, SystemException, PortalException, IOException {

    	_log.info("downloadFromBBDD...");

    	String outputId = request.getParameter(EvaluateEvallWebConstants.OUTPUT_ID_PARAMETER);

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
    			response.setProperty(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + output.getName() + "\"");
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

    @ResourceMapping(value=EvaluateEvallWebConstants.DOWNLOAD_BENCHMARK_BIBTEX_RESOURCE)
	public void downloadBenchmarkBibtex(ResourceRequest request, ResourceResponse response) throws PortletException, SystemException, PortalException, IOException {

    	_log.info("downloadBenchmarkBibtex...");

    	String outputId = request.getParameter(EvaluateEvallWebConstants.BENCHMARK_ID_PARAMETER);

    	benchmark benchmark = benchmarkLocalServiceUtil.findById(Long.valueOf(outputId));

    	if(benchmark != null) {

    		try {

    			InputStream inputStream1 = benchmark.getBibtex().getBinaryStream();

    			TikaConfig config = TikaConfig.getDefaultConfig();
    	        Detector detector = config.getDetector();
    	        TikaInputStream streamp = TikaInputStream.get(inputStream1);
    	        Metadata metadata = new Metadata();
    	        metadata.add(Metadata.RESOURCE_NAME_KEY, EvaluateEvallWebConstants.OUTPUT_BIBTEX_PARAMETER);
    	        MediaType mediaType = detector.detect(streamp, metadata);

    	        InputStream inputStream2 = benchmark.getBibtex().getBinaryStream();

    			byte[] fileByte = IOUtils.toByteArray(inputStream2);

    			streamp.close();
    			inputStream1.close();
    			inputStream2.close();

    			response.setContentType(mediaType.toString());
    			response.setProperty(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + "bibtex" + "\"");
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

    @ResourceMapping(value=EvaluateEvallWebConstants.DOWNLOAD_OUTPUT_BIBTEX_RESOURCE)
	public void downloadOutputBibtex(ResourceRequest request, ResourceResponse response) throws PortletException, SystemException, PortalException, IOException {

    	_log.info("downloadOutputBibtex...");

    	String outputId = request.getParameter(EvaluateEvallWebConstants.OUTPUT_ID_PARAMETER);

    	output output = outputLocalServiceUtil.findById(Long.valueOf(outputId));

    	if(output != null) {

    		try {

    			InputStream inputStream1 = output.getBibtex().getBinaryStream();

    			TikaConfig config = TikaConfig.getDefaultConfig();
    	        Detector detector = config.getDetector();
    	        TikaInputStream streamp = TikaInputStream.get(inputStream1);
    	        Metadata metadata = new Metadata();
    	        metadata.add(Metadata.RESOURCE_NAME_KEY, EvaluateEvallWebConstants.OUTPUT_BIBTEX_PARAMETER);
    	        MediaType mediaType = detector.detect(streamp, metadata);

    	        InputStream inputStream2 = output.getBibtex().getBinaryStream();

    			byte[] fileByte = IOUtils.toByteArray(inputStream2);

    			streamp.close();
    			inputStream1.close();
    			inputStream2.close();

    			response.setContentType(mediaType.toString());
    			response.setProperty(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + "bibtex" + "\"");
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

    @ResourceMapping(value=EvaluateEvallWebConstants.DOWNLOAD_ICON_BENCHMARK_RESOURCE)
	public void viewIconBenchmark(ResourceRequest request, ResourceResponse response) throws PortletException, SystemException, PortalException, IOException {

    	_log.info("viewIconBenchmark...");

    	String benchmarkId = request.getParameter(EvaluateEvallWebConstants.BENCHMARK_ID_PARAMETER);

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
    			response.setProperty(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + benchmark.getConference() + "\"");
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

    @ResourceMapping(value=EvaluateEvallWebConstants.CREATE_COOKIE_RESOURCE)
	public void createCookie(ResourceRequest request, ResourceResponse response, @CookieValue(value=EvallWebConstants.COOKIE_NAME, defaultValue=EvallWebConstants.COOKIE_VOID) String configuration) throws PortletException, SystemException, PortalException, IOException {

    	_log.info("createCookie...");

    	JSONObject json = EvallCookieUtil.getJsonFromCookieValue(configuration);

		json.put(EvaluateEvallWebConstants.SESSION_ID_PARAMETER, request.getRequestedSessionId());
		json.put(EvaluateEvallWebConstants.IS_SIGN_IN_PARAMETER, EvallUserUtil.isSignedIn(request));
		json.put(EvaluateEvallWebConstants.PORTLET_CONTEXT_PARAMETER, request.getPortletSession().getPortletContext().getPortletContextName());

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
    	cookie.setPath(EvaluateEvallWebConstants.BACKSLASH);

    	response.addProperty(cookie);
    }

    @ActionMapping(value=EvaluateEvallWebConstants.EVALUATE_ACTION)
    public void evaluate(ActionRequest request, ActionResponse response) {

    	_log.info("evaluate");

    	String nameBetterOutput = EvallWebConstants.VOID;
    	InputStream betterOutput = null;

    	try {

    		String sessionId = EvallUserUtil.getCurrentSessionId(request);

    		String folderName = new StringBuilder(uploadFolder).append(File.separatorChar).append(sessionId).append(File.separatorChar)
    				.append(EvaluateEvallWebConstants.UPLOADED_FILES).append(File.separatorChar).toString();

    		File fileFolder = new File(folderName);

    		ArrayList<String> outputPaths = new ArrayList<String>();

    		if(fileFolder.listFiles() != null) {

    			for(File f : fileFolder.listFiles()) {

    				if(f.isDirectory()) {

    					outputPaths.add(f.listFiles()[0].getPath());
    				}
    			}
    		}

    		String benchmarkId = request.getParameter(EvaluateEvallWebConstants.BENCHMARK_ID_PARAMETER);
    		String metrics = request.getParameter(EvaluateEvallWebConstants.METRICS_PARAMETER).trim();
	    	String metricOption = request.getParameter(EvaluateEvallWebConstants.METRIC_OPTION_PARAMETER);
	    	String metricParameterOption = request.getParameter(EvaluateEvallWebConstants.METRIC_PARAMETER_LIST_PARAMETER);
	    	String systemId = request.getParameter(EvaluateEvallWebConstants.SYSTEM_ID_PARAMETER);
	    	boolean baselineOption1 = (request.getParameter(EvaluateEvallWebConstants.BASELINE_OPTION_PARAMETER) != null? request.getParameter(EvaluateEvallWebConstants.BASELINE_OPTION_PARAMETER).trim().equalsIgnoreCase("best_database") : false);
	    	boolean baselineOption2 = (request.getParameter(EvaluateEvallWebConstants.BASELINE_OPTION_PARAMETER) != null? request.getParameter(EvaluateEvallWebConstants.BASELINE_OPTION_PARAMETER).trim().equalsIgnoreCase("personalized_selection") : false);
	    	boolean generateTSVReport = (request.getParameter(EvaluateEvallWebConstants.REPORT_OPTION_GENERATE_TSV_PARAMETER) != null? request.getParameter(EvaluateEvallWebConstants.REPORT_OPTION_GENERATE_TSV_PARAMETER).trim().equalsIgnoreCase("generate_tsv") : false);
	    	boolean generateLatexReport = (request.getParameter(EvaluateEvallWebConstants.REPORT_OPTION_GENERATE_LATEX_PARAMETER) != null? request.getParameter(EvaluateEvallWebConstants.REPORT_OPTION_GENERATE_LATEX_PARAMETER).trim().equalsIgnoreCase("generate_pdf") : false);
	    	boolean descriptionsInReport = (request.getParameter(EvaluateEvallWebConstants.REPORT_OPTION_DESCRIPTIONS_PARAMETER) != null? request.getParameter(EvaluateEvallWebConstants.REPORT_OPTION_DESCRIPTIONS_PARAMETER).trim().equalsIgnoreCase("explanation_metric") : false);
	    	boolean descriptionsAndWarningsOutputs = (request.getParameter(EvaluateEvallWebConstants.REPORT_OPTION_WARNINGS_PARAMETER) != null? request.getParameter(EvaluateEvallWebConstants.REPORT_OPTION_WARNINGS_PARAMETER).trim().equalsIgnoreCase("verification_step") : false);

	    	benchmark benchmark = benchmarkLocalServiceUtil.findById(Long.valueOf(benchmarkId));

	    	Configuration conf = new Configuration(EvallTasksEnum.valueOf(benchmark.getEvallTasks()));

	    	if(benchmark != null) {

	    		result result = null;

	    		boolean validId = false;

	    		long idOutput = 0L;

	    		if(benchmark.getBibtex().length() > 0) {

	    			conf.setBibTexBenchmark(benchmark.getBibtex().getBinaryStream());
	    		}

	    		if(baselineOption1 && !baselineOption2) {

	    			result = resultLocalServiceUtil.findBestByBenchmarkIdAndMeasure(benchmark.getId(), benchmark.getOfficialMeasure());

	    			conf.setHasSelectedBestSystemInComparativeReport(false);

	    		} else if(baselineOption2 && !baselineOption1 && systemId != null && !EvallWebConstants.VOID.equals(systemId)) {

	    			result = resultLocalServiceUtil.findById(Long.valueOf(systemId));

	    			conf.setHasSelectedBestSystemInComparativeReport(true);
	        	}

	    		if(result != null) {

    				idOutput = result.getOutputID();
    				validId = true;
    			}

	    		if(validId) {

	    			output output = outputLocalServiceUtil.findById(idOutput);

	    			if(output != null) {

	    				betterOutput = output.getOutput().getBinaryStream();

	    				nameBetterOutput = output.getName();

	    				if(output.getBibtex().length() > 0) {

	    					conf.setBibTexBestSystem(output.getBibtex().getBinaryStream());
	    				}
	    			}
	    		}
	        }

	    	if(metricOption.equals("personalized_set_metrics")) {

	    		ArrayList<MeasuresEnum> lstPersonalizedMeasures = new ArrayList<MeasuresEnum>();

	    		HashMap<String, String> parameters = new HashMap<String, String>();

	    		HashMap<String, MeasureParameter> measureParameters = conf.getMeasureParameters();

	    		for(String m : metrics.split(";")) {
	
	    			MeasuresEnum measureEnum = getMeasureEnum(m);

	    			if(measureEnum != null) {

	    				lstPersonalizedMeasures.add(measureEnum);
	    			}
		    	}

	    		conf.setLstPersonalizedMeasures(lstPersonalizedMeasures);

	    		for(String parameter : metricParameterOption.split(";")) {

	    			String[] p_value = parameter.split("=");

	    			if(p_value.length == 2) {

	    				parameters.put(p_value[0], p_value[1]);
	    			}
	    		}

	    		if(parameters.size() > 0) {

	    			for(HashMap.Entry<String, MeasureParameter> mp : measureParameters.entrySet()) {

	    				if(parameters.containsKey(mp.getKey())) {

	    					MeasureParameter measureParameter = mp.getValue();

	    					measureParameter.setValue(Double.valueOf(parameters.get(mp.getKey())));

	    					mp.setValue(measureParameter);
	    				}
	    			}

	    			conf.setMeasureParameters(measureParameters);
	    		}

	    	} else if(metricOption.equals("official_metrics")) {

	    		if(benchmark != null) {

	    			ArrayList<MeasuresEnum> lstPersonalizedMeasures = new ArrayList<MeasuresEnum>();

	    			MeasuresEnum officialMeasureEnum = getMeasureEnum(benchmark.getOfficialMeasure());

	    			if(officialMeasureEnum != null) {

	    				lstPersonalizedMeasures.add(officialMeasureEnum);
	    			}

	    			List<official_measure> officialMeasures = official_measureLocalServiceUtil.findByBenchmarkID(benchmark.getId());

	    			if(officialMeasures != null && !officialMeasures.isEmpty()) {

	    				for(official_measure officialMeasure : officialMeasures) {
		
	    					MeasuresEnum otherMeasureEnum = getMeasureEnum(officialMeasure.getMeasure());

	    					if(otherMeasureEnum != null) {

	    						lstPersonalizedMeasures.add(MeasuresEnum.valueOf(officialMeasure.getMeasure()));
	    					}
	    				}
	    			}

		    		conf.setLstPersonalizedMeasures(lstPersonalizedMeasures);
	    		}
	    	}

	    	DescriptionReport descriptionReport = new DescriptionReport();
	    	descriptionReport.setTitle(new StringBuilder(benchmark.getYearDate()).append(EvallWebConstants.SPACE).append(benchmark.getConference())
	    			.append(EvallWebConstants.SPACE).append(benchmark.getWorkshop()).append(EvallWebConstants.SPACE).append(benchmark.getName()).toString());
	    	descriptionReport.setDescription(benchmark.getDescription());

	    	EvallToolkitAPI evallToolkitApi = new EvallToolkitAPI();
	    	conf.setTmpFolderForReport(fileFolder.getParent() + File.separatorChar);
	    	conf.setBenchmark(descriptionReport);
	    	conf.setTypeOfReport(Configuration.COMPARATIVE_REPORT);
	    	conf.setGenerateTSVReport(generateTSVReport);
	    	conf.setGenerateLatexReport(generateLatexReport);
	    	conf.setDescriptionsInReport(descriptionsInReport);
	    	conf.setDescriptionsAndWarningsOutputs(descriptionsAndWarningsOutputs);

	    	evallToolkitApi.evaluateWithInputStream(outputPaths, betterOutput, nameBetterOutput, benchmark.getGoldstandard().getBinaryStream(), "goldstandar.csv", conf);

	    	betterOutput.close();

	    	String path = conf.getTmpFolderForReportWithUID();

	    	if(path != null && !EvallWebConstants.VOID.equals(path)) {

	    		String uid = path.replace(fileFolder.getParent() + File.separatorChar, EvallWebConstants.VOID).replaceAll(EvaluateEvallWebConstants.BACKSLASH, EvallWebConstants.VOID);

	    		byte[] encodedPath = Base64.encodeBase64(uid.getBytes());

	    		response.setRenderParameter(EvaluateEvallWebConstants.RESULT_REPORT_PATH_PARAMETER,  new String(encodedPath));

	    	} else {

	    		response.setRenderParameter(EvaluateEvallWebConstants.RESULT_ERROR_PARAMETER, "The evaluation could not be executed. Please try again.");
	    	}

			response.setRenderParameter(EvaluateEvallWebConstants.BENCHMARK_ID_PARAMETER,  benchmarkId);

    	} catch (Exception e) {

    		String error = EvallWebConstants.VOID;

    		if(betterOutput != null) {

    			try {

					betterOutput.close();

				} catch (IOException e1) {

					e1.printStackTrace();
				}
    		}

    		if(e.getMessage() != null) {

    			error = e.getMessage();

    		} else {

    			error = "The evaluation could not be executed. Please try again.";
    		}

			response.setRenderParameter(EvaluateEvallWebConstants.RESULT_ERROR_PARAMETER,  error);

			e.printStackTrace();
		}

    	response.setRenderParameter(EvaluateEvallWebConstants.VIEW, EvaluateEvallWebConstants.RESULT_VIEW);

    	return;
    }

    @ResourceMapping(value=EvaluateEvallWebConstants.SAVE_OUTPUT_RESOURCE)
	public void saveOutputDetail(ResourceRequest request, ResourceResponse response) throws PortletException, SystemException, PortalException, IOException {

    	_log.info("saveOutputDetail...");

    	JSONObject message = null;

    	String userId = EvallUserUtil.getCurrentUserId(request);
    	String sessionId = EvallUserUtil.getCurrentSessionId(request);
    	String tempId = request.getParameter(EvaluateEvallWebConstants.OUTPUT_ID_PARAMETER);
    	String title = request.getParameter(EvaluateEvallWebConstants.OUTPUT_TITLE_PARAMETER);
    	String paperUrl = request.getParameter(EvaluateEvallWebConstants.OUTPUT_URL_PAPER_PARAMETER);
    	String publicationYear = request.getParameter(EvaluateEvallWebConstants.OUTPUT_PUBLICATION_YEAR_PARAMETER);
    	String authorList = request.getParameter(EvaluateEvallWebConstants.OUTPUT_AUTHORS_PARAMETER);
    	String description = request.getParameter(EvaluateEvallWebConstants.OUTPUT_DESCRIPTION_PARAMETER);
    	String benchmarkId = request.getParameter(EvaluateEvallWebConstants.BENCHMARK_ID_PARAMETER);

    	boolean nameInUsed = existFileName(sessionId, uploadFolder, EvaluateEvallWebConstants.UPLOADED_FILES, Long.valueOf(benchmarkId), tempId);

    	if(tempId == null || benchmarkId == null || title == null || paperUrl == null || publicationYear == null || authorList == null || description == null) {

    		message = AjaxMessageUtil.createMessageError("File has been deleted.", JSONFactoryUtil.createJSONObject());

    	} else if(nameInUsed) {

    		message = AjaxMessageUtil.createMessageError("File name is reserved.", JSONFactoryUtil.createJSONObject());

    	} else {

        	String contentFolderName = new StringBuilder(uploadFolder).append(File.separatorChar).append(sessionId)
        			.append(File.separatorChar).append(EvaluateEvallWebConstants.UPLOADED_FILES).toString();

        	File contentFile = EvallFileUtil.getFileById(contentFolderName, tempId);

        	String bibtexFolderName = new StringBuilder(uploadFolder).append(File.separatorChar).append(sessionId)
        			.append(File.separatorChar).append(EvaluateEvallWebConstants.UPLOADED_BIBTEX).toString();

        	File bibtexFile = EvallFileUtil.getFileById(bibtexFolderName, tempId);

        	if(contentFile != null && contentFile.exists() && bibtexFile != null && bibtexFile.exists()) {

        		try {

        			benchmark benchmark = benchmarkLocalServiceUtil.findById(Long.valueOf(benchmarkId));

        			int order = 0;
        			long outputId = 0L;

        			boolean alreadySaved = contentFile.getParentFile().getName().matches(tempId + EvallWebConstants.DB_REGEX);

        			InputStream isBibtex = new FileInputStream(bibtexFile);

    				byte[] contentBibtex = IOUtils.toByteArray(isBibtex);

    				isBibtex.close();

    				Blob blobBibtex = new SerialBlob(contentBibtex);

        			if(alreadySaved) {

        				String dbId = contentFile.getParentFile().getName().replaceAll(tempId + EvallWebConstants.DB, EvallWebConstants.VOID);

        				outputId = Long.valueOf(dbId);

        				outputLocalServiceUtil.updateOutput(outputId, contentFile.getName(), title, description, paperUrl, Integer.valueOf(publicationYear), Long.valueOf(benchmarkId), blobBibtex);

        			} else {

        				InputStream is = new FileInputStream(contentFile);

        				byte[] content = IOUtils.toByteArray(is);

        				is.close();

        				Blob blobContent = new SerialBlob(content);

        				Date date = new Date();

        				Calendar cal = Calendar.getInstance();

        		        cal.setTime(date);

        				outputId = outputLocalServiceUtil.addOutput(contentFile.getName(), title, description, paperUrl, Long.valueOf(benchmarkId), Long.valueOf(userId), date, Integer.valueOf(publicationYear), blobBibtex, blobContent);

        				EvallToolkitAPI evallToolkitApi = new EvallToolkitAPI();

        				HashMap<MeasuresEnum, Double> results = evallToolkitApi.getAllResultsDefaultParamsInputStream(contentFile.getAbsolutePath(), benchmark.getGoldstandard().getBinaryStream(), "goldstandar.csv", EvallTasksEnum.valueOf(benchmark.getEvallTasks()));

        				for(Map.Entry<MeasuresEnum, Double> result : results.entrySet()) {

                			resultLocalServiceUtil.addResult(benchmark.getId(), outputId, result.getKey().name(), result.getValue());
                		}

        				contentFile.getParentFile().renameTo(new File(contentFile.getParentFile().getPath() + EvallWebConstants.DB + outputId));

        				bibtexFile.getParentFile().renameTo(new File(bibtexFile.getParentFile().getPath() + EvallWebConstants.DB + outputId));
        			}

        			author_relationLocalServiceUtil.deleteByDocId(EvallWebConstants.AUTHOR_DOCTYPE_OUTPUT, outputId);
        			authorLocalServiceUtil.deleteUnusedAuthors();

            		for(String author_ : authorList.split(";")) {

            			long authorId = 0L;

            			String[] author = author_.split(",");
            			String authorName = author[1].trim();
            			String authorSurname = author[0].trim();

            			List<author> authors = authorLocalServiceUtil.findByName(authorName, authorSurname);

            			if(authors == null || authors.isEmpty()) {

            				authorId = authorLocalServiceUtil.addAuthor(authorName, authorSurname);

            			} else {

            				authorId = authors.get(0).getId();
            			}

            			author_relationLocalServiceUtil.addRelation(authorId, EvallWebConstants.AUTHOR_DOCTYPE_OUTPUT, outputId, order++);
            		}

        	    	message = AjaxMessageUtil.createMessageOk(JSONFactoryUtil.createJSONObject());

        		} catch(Exception e) {

        			message = AjaxMessageUtil.createMessageError("Fail to read file.", JSONFactoryUtil.createJSONObject());
    	    	}

        	} else {

    			message = AjaxMessageUtil.createMessageError("File has been deleted.", JSONFactoryUtil.createJSONObject());
    		}
    	}

    	OutputStream outStream = response.getPortletOutputStream();
        outStream.write(message.toString().getBytes());
        outStream.flush();
        outStream.close();
    }

    @ResourceMapping(value=EvaluateEvallWebConstants.CHECK_EXIST_OUTPUT_NAME_RESOURCE)
	public void checkExistOutputName(ResourceRequest request, ResourceResponse response) throws PortletException, SystemException, PortalException, IOException, IllegalArgumentException, IllegalAccessException {

    	_log.info("check exist output name...");

    	JSONObject message = null;

    	String benchmarkId = request.getParameter(EvaluateEvallWebConstants.BENCHMARK_ID_PARAMETER);

    	String fileId = request.getParameter(EvaluateEvallWebConstants.FILE_ID_PARAMETER);

    	String sessionId = EvallUserUtil.getCurrentSessionId(request);

    	message = AjaxMessageUtil.createMessageOk(JSONFactoryUtil.createJSONObject().put(EvaluateEvallWebConstants.FILE_NAME_PARAMETER, existFileName(sessionId, uploadFolder, EvaluateEvallWebConstants.UPLOADED_FILES, Long.valueOf(benchmarkId),fileId)));

    	OutputStream outStream = response.getPortletOutputStream();
        outStream.write(message.toString().getBytes());
        outStream.flush();
        outStream.close();
   }

    @ResourceMapping(value=EvaluateEvallWebConstants.GET_BEST_SYSTEM_NAME_RESOURCE)
	public void getBestSystemName(ResourceRequest request, ResourceResponse response) throws PortletException, SystemException, PortalException, IOException, IllegalArgumentException, IllegalAccessException {

    	_log.info("getting best system name...");

    	String benchmarkId = request.getParameter(EvaluateEvallWebConstants.BENCHMARK_ID_PARAMETER), name = EvallWebConstants.VOID;

    	benchmark benchmark = benchmarkLocalServiceUtil.findById(Long.valueOf(benchmarkId));

    	if(benchmark != null) {

    		result result = resultLocalServiceUtil.findBestByBenchmarkIdAndMeasure(benchmark.getId(), benchmark.getOfficialMeasure());

    		if(result != null) {

    			output output = outputLocalServiceUtil.findById(result.getOutputID());

    			if(output != null) {

    				name = output.getName();
    			}
    		}
        }

    	OutputStream outStream = response.getPortletOutputStream();
        outStream.write(name.toString().getBytes());
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

    				MeasuresEnum m = getMeasureEnum(officialMeasure.getMeasure());

    				if(m != null) {

						sb.append(m.getName()).append(", ");
    				}
    			}

    			sb.delete(sb.length() - 2, sb.length());
    		}

		} catch (SystemException e) {

			e.printStackTrace();
		}

    	return sb.toString();
    }

    private BenchmarkBean getBenchmarkBean(benchmark benchmark) {

    	List<String> authors = getAuthors(EvallWebConstants.AUTHOR_DOCTYPE_BENCHMARK, benchmark.getId());

    	String otherOfficialMeasures = getOfficialMeasures(benchmark.getId());

    	MeasuresEnum officialM = getMeasureEnum(benchmark.getOfficialMeasure());

    	return new BenchmarkBean(benchmark.getId(), benchmark.getName(), EvallTasksEnum.valueOf(benchmark.getEvallTasks()).getName(), benchmark.getDescription(),
    			benchmark.getConference(), benchmark.getUrlPaper(), benchmark.getUrlPage(), (officialM == null? "-" : officialM.getName()), otherOfficialMeasures, authors, String.valueOf(benchmark.getYearDate()),
    			benchmark.getWorkshop(), benchmark.getUserID(), benchmark.getIcon() != null, benchmark.getGoldstandard() != null, benchmark.getBibtex() != null);
    }

    private ArrayList<EvallErrorAndWarnings> getFormatErrors(String name, File file, EvallTasksEnum evallTask) throws EvallException, IOException {

    	ArrayList<EvallErrorAndWarnings> formatErrors = null;

    	EvallToolkitAPI evallToolkitAPI = new EvallToolkitAPI();

    	Configuration conf = new Configuration(evallTask);

    	FileInputStream is = new FileInputStream(file);

    	formatErrors = evallToolkitAPI.checkFileWithInputStream(false, is, name, false, conf);

    	is.close();

    	return formatErrors;
    }

    private MeasuresEnum getMeasureEnum(String id) {

    	MeasuresEnum measureEnum = null;

    	try {

    		measureEnum = MeasuresEnum.valueOf(id);

		} catch(Exception e) {}

    	return measureEnum;
    }

    public static void areExistFileNames(String userId, String uploadFolder, String fileFolderName, long benchmarkID, Model model, String parameter) throws IOException, SystemException {

    	String folderName = new StringBuilder(uploadFolder).append(File.separatorChar).append(userId)
    			.append(File.separatorChar).append(fileFolderName).toString();

    	File folder = new File(folderName);

    	folder.setWritable(true);
    	folder.setExecutable(true);
    	folder.mkdirs();

    	Map<String, Boolean> correspondences = new HashMap<String,Boolean>();

    	Map<String, String> files = new HashMap<String,String>();

        List<String> fileNames = new ArrayList<String>();

        if(folder.listFiles() != null && folder.listFiles().length > 0) {

        	for(int i = 0; i < folder.listFiles().length; i++) {

        		File fileFolder = folder.listFiles()[i];

        		if(fileFolder.isDirectory()) {

    				File file = fileFolder.listFiles()[0];

    				String id_ = fileFolder.getName().replaceAll(EvallWebConstants.DB_REGEX, EvallWebConstants.VOID);

    				files.put(id_, file.getName());

    				fileNames.add(file.getName());
        		}
        	}

        	Map<String, Boolean> validations = outputLocalServiceUtil.checkOutputNames(benchmarkID, fileNames);

        	for(Map.Entry<String, String> file : files.entrySet()) {

        		correspondences.put(file.getKey(), validations.get(file.getValue()));
        	}
        }

    	model.addAttribute(parameter, correspondences);
    }

    public boolean existFileName(String userId, String uploadFolder, String fileFolderName, long benchmarkID, String fileId) throws IOException, SystemException {

    	String folderName = new StringBuilder(uploadFolder).append(File.separatorChar).append(userId)
    			.append(File.separatorChar).append(fileFolderName).toString();

    	File folder = new File(folderName);

    	folder.setWritable(true);
    	folder.setExecutable(true);
    	folder.mkdirs();

        if(folder.listFiles() != null && folder.listFiles().length > 0) {

        	for(int i = 0; i < folder.listFiles().length; i++) {

        		File fileFolder = folder.listFiles()[i];

        		if(fileFolder.isDirectory() && fileFolder.getName().replaceAll(EvallWebConstants.DB_REGEX, EvallWebConstants.VOID).equals(fileId)) {

    				final File file = fileFolder.listFiles()[0];

    				Map<String, Boolean> validations = outputLocalServiceUtil.checkOutputNames(benchmarkID, new ArrayList<String>(){{add(file.getName());}});

    				return validations.get(file.getName());
        		}
        	}
        }

    	return false;
    }
}
