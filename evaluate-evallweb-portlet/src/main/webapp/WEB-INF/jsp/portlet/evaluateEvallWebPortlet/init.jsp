<%@include file="../init.jsp" %>
<%@page import="es.uned.nlp.evall.evallweb.portal.core.PortalConstants"%>
<%@page import="es.uned.nlp.evall.evallweb.portlet.core.constant.EvallWebConstants"%>
<%@page import="es.uned.nlp.evall.evallweb.portlet.evaluate.constants.EvaluateEvallWebConstants"%>
<%@page import="es.uned.nlp.evallToolkit.configuration.Configuration"%>

<c:set var="maximumSizeMessage" scope="session" value="<%=PortalConstants.UPLOAD_MAX_SIZE_MESSAGE%>"/>
<c:set var="maximumNumberMessage" scope="session" value="<%=PortalConstants.UPLOAD_MAX_NUMBER_MESSAGE%>"/>
<c:set var="mimetypeMessage" scope="session" value="<%=PortalConstants.UPLOAD_MIMETYPE_MESSAGE%>"/>
<c:set var="csvMimetype" scope="session" value="<%=PortalConstants.CSV_MIMETYPE%>"/>
<c:set var="textMimetype" scope="session" value="<%=PortalConstants.TEXT_MIMETYPE%>"/>
<c:set var="maximumCharacterNumber" scope="session" value="<%=EvallWebConstants.MAX_CHARACTER_NUMBER%>"/>
<c:set var="maximumCharacterNumber" scope="session" value="<%=EvallWebConstants.MAX_CHARACTER_NUMBER%>"/>
<c:set var="uploadMaxLengthName" scope="session" value="<%=Configuration.MAX_LENGTH_OUTPUT_NAME%>"/>
<c:set var="uploadMaxKb" scope="session" value="<%=PortalConstants.UPLOAD_MAX_KB%>"/>
<c:set var="uploadMaxNumberPdf" scope="session" value="<%=PortalConstants.UPLOAD_MAX_NUMBER_PDF%>"/>
<c:set var="uploadMaxNumberTsv" scope="session" value="<%=PortalConstants.UPLOAD_MAX_NUMBER_TSV%>"/>
<c:set var="fileNumberPerPage" scope="session" value="<%=EvaluateEvallWebConstants.FILE_NUMBER_PER_PAGE%>"/>
<c:set var="systemNumberPerPage" scope="session" value="<%=EvaluateEvallWebConstants.SYSTEM_NUMBER_PER_PAGE%>"/>
<c:set var="outputNumberPerPage" scope="session" value="<%=EvaluateEvallWebConstants.OUTPUT_NUMBER_PER_PAGE%>"/>
<c:set var="themeImagePath" scope="session" value="<%=themeDisplay.getPathThemeImages()%>"/>
<c:set var="portletPath" scope="session" value="<%=request.getContextPath()%>"/>
<c:set var="liferayWindowState" scope="session" value="<%=LiferayWindowState.NORMAL.toString()%>"/>
<c:set var="liferayPortletId" scope="session" value="<%=themeDisplay.getPortletDisplay().getId()%>"/>
<c:set var="rowsPerPageBenchmark" scope="session" value="<%=EvaluateEvallWebConstants.ROWS_PER_PAGE_BENCHMARK%>"/>
<c:set var="rowsPerPageMetric" scope="session" value="<%=EvaluateEvallWebConstants.ROWS_PER_PAGE_METRIC%>"/>
<c:set var="columnsPerRowBenchmark" scope="session" value="<%=EvaluateEvallWebConstants.COLUMNS_PER_ROW_BENCHMARK%>"/>
<c:set var="columnsPerRowMetric" scope="session" value="<%=EvaluateEvallWebConstants.COLUMNS_PER_ROW_METRIC%>"/>
<c:set var="colorPerColumns" scope="session" value="<%=EvaluateEvallWebConstants.COLOR_PER_COLUMNS%>"/>
<c:set var="goldstandardType" scope="session" value="<%=EvaluateEvallWebConstants.GOLDSTANDARD_TYPE%>"/>
<c:set var="outputType" scope="session" value="<%=EvaluateEvallWebConstants.OUTPUT_TYPE%>"/>
<c:set var="benchmarkAllEvallTasks" scope="session" value="<%=EvaluateEvallWebConstants.BENCHMARK_ALL_EVALLTASKS%>"/>
<c:set var="benchmarkAllConferences" scope="session" value="<%=EvaluateEvallWebConstants.BENCHMARK_ALL_CONFERENCES%>"/>
<c:set var="benchmarkAllYears" scope="session" value="<%=EvaluateEvallWebConstants.BENCHMARK_ALL_YEARS%>"/>
<c:set var="benchmarkAllWorkshops" scope="session" value="<%=EvaluateEvallWebConstants.BENCHMARK_ALL_WORKSHOPS%>"/>
<c:set var="textSearchParameter" scope="session" value="<%=EvaluateEvallWebConstants.TEXT_SEARCH_PARAMETER%>"/>
<c:set var="benchmarkIdParameter" scope="session" value="<%=EvaluateEvallWebConstants.BENCHMARK_ID_PARAMETER%>"/>
<c:set var="benchmarksParameter" scope="session" value="<%=EvaluateEvallWebConstants.BENCHMARKS_PARAMETER%>"/>
<c:set var="benchmarkEvallTaskParameter" scope="session" value="<%=EvaluateEvallWebConstants.BENCHMARK_EVALLTASK_PARAMETER%>"/>
<c:set var="benchmarkConferenceParameter" scope="session" value="<%=EvaluateEvallWebConstants.BENCHMARK_CONFERENCE_PARAMETER%>"/>
<c:set var="benchmarkYearParameter" scope="session" value="<%=EvaluateEvallWebConstants.BENCHMARK_YEAR_PARAMETER%>"/>
<c:set var="benchmarkWorkshopParameter" scope="session" value="<%=EvaluateEvallWebConstants.BENCHMARK_WORKSHOP_PARAMETER%>"/>
<c:set var="benchmarkEvallTaskListParameter" scope="session" value="<%=EvaluateEvallWebConstants.BENCHMARK_EVALLTASK_LIST_PARAMETER%>"/>
<c:set var="benchmarkConferenceListParameter" scope="session" value="<%=EvaluateEvallWebConstants.BENCHMARK_CONFERENCE_LIST_PARAMETER%>"/>
<c:set var="benchmarkYearListParameter" scope="session" value="<%=EvaluateEvallWebConstants.BENCHMARK_YEAR_LIST_PARAMETER%>"/>
<c:set var="benchmarkWorkshopListParameter" scope="session" value="<%=EvaluateEvallWebConstants.BENCHMARK_WORKSHOP_LIST_PARAMETER%>"/>
<c:set var="benchmarkParameter" scope="session" value="<%=EvaluateEvallWebConstants.BENCHMARK_PARAMETER%>"/>
<c:set var="evaluationOptionParameter" scope="session" value="<%=EvaluateEvallWebConstants.EVALUATION_OPTION_PARAMETER%>"/>
<c:set var="metricsParameter" scope="session" value="<%=EvaluateEvallWebConstants.METRICS_PARAMETER%>"/>
<c:set var="hasMetricParametersListParameter" scope="session" value="<%=EvaluateEvallWebConstants.HAS_METRIC_PARAMETERS_LIST_PARAMETER%>"/>
<c:set var="metricIdParameter" scope="session" value="<%=EvaluateEvallWebConstants.METRIC_ID_PARAMETER%>"/>
<c:set var="metricParameterListParameter" scope="session" value="<%=EvaluateEvallWebConstants.METRIC_PARAMETER_LIST_PARAMETER%>"/>
<c:set var="metricNameParameter" scope="session" value="<%=EvaluateEvallWebConstants.METRIC_NAME_PARAMETER%>"/>
<c:set var="metricDescriptionParameter" scope="session" value="<%=EvaluateEvallWebConstants.METRIC_DESCRIPTION_PARAMETER%>"/>
<c:set var="metricOptionParameter" scope="session" value="<%=EvaluateEvallWebConstants.METRIC_OPTION_PARAMETER%>"/>
<c:set var="baselineOptionParameter" scope="session" value="<%=EvaluateEvallWebConstants.BASELINE_OPTION_PARAMETER%>"/>
<c:set var="systemIdParameter" scope="session" value="<%=EvaluateEvallWebConstants.SYSTEM_ID_PARAMETER%>"/>
<c:set var="systemNameParameter" scope="session" value="<%=EvaluateEvallWebConstants.SYSTEM_NAME_PARAMETER%>"/>
<c:set var="systemValueParameter" scope="session" value="<%=EvaluateEvallWebConstants.SYSTEM_VALUE_PARAMETER%>"/>
<c:set var="systemDateParameter" scope="session" value="<%=EvaluateEvallWebConstants.SYSTEM_DATE_PARAMETER%>"/>
<c:set var="systemPaginationParameter" scope="session" value="<%=EvaluateEvallWebConstants.SYSTEM_PAGINATION_PARAMETER%>"/>
<c:set var="systemPropertyParameter" scope="session" value="<%=EvaluateEvallWebConstants.SYSTEM_PROPERTY_PARAMETER%>"/>
<c:set var="systemOrderParameter" scope="session" value="<%=EvaluateEvallWebConstants.SYSTEM_ORDER_PARAMETER%>"/>
<c:set var="systemMeasureParameter" scope="session" value="<%=EvaluateEvallWebConstants.SYSTEM_MEASURE_PARAMETER%>"/>
<c:set var="systemResultNumberParameter" scope="session" value="<%=EvaluateEvallWebConstants.SYSTEM_RESULT_NUMBER_PARAMETER%>"/>
<c:set var="systemResultsParameter" scope="session" value="<%=EvaluateEvallWebConstants.SYSTEM_RESULTS_PARAMETER%>"/>
<c:set var="systemParameter" scope="session" value="<%=EvaluateEvallWebConstants.SYSTEM_PARAMETER%>"/>
<c:set var="systemBeginPaginationParameter" scope="session" value="<%=EvaluateEvallWebConstants.SYSTEM_BEGIN_PAGINATION_PARAMETER%>"/>
<c:set var="reportOptionGerateLatexParameter" scope="session" value="<%=EvaluateEvallWebConstants.REPORT_OPTION_GENERATE_LATEX_PARAMETER%>"/>
<c:set var="reportOptionGerateTsvParameter" scope="session" value="<%=EvaluateEvallWebConstants.REPORT_OPTION_GENERATE_TSV_PARAMETER%>"/>
<c:set var="reportOptionDescriptionsParameter" scope="session" value="<%=EvaluateEvallWebConstants.REPORT_OPTION_DESCRIPTIONS_PARAMETER%>"/>
<c:set var="reportOptionWarningsParameter" scope="session" value="<%=EvaluateEvallWebConstants.REPORT_OPTION_WARNINGS_PARAMETER%>"/>
<c:set var="uploadMaxNumberParameter" scope="session" value="<%=EvaluateEvallWebConstants.UPLOAD_MAXIMUM_NUMBER_PARAMETER%>"/>
<c:set var="uploadFilesValidationNameParameter" scope="session" value="<%=EvaluateEvallWebConstants.UPLOAD_FILES_VALIDATION_NAME_PARAMETER%>"/>
<c:set var="uploadFilesParameter" scope="session" value="<%=EvaluateEvallWebConstants.UPLOAD_FILES_PARAMETER%>"/>
<c:set var="uploadFileParameter" scope="session" value="<%=EvaluateEvallWebConstants.UPLOAD_FILE_PARAMETER%>"/>
<c:set var="resultErrorParameter" scope="session" value="<%=EvaluateEvallWebConstants.RESULT_ERROR_PARAMETER%>"/>
<c:set var="resultDownloadModeParameter" scope="session" value="<%=EvaluateEvallWebConstants.RESULT_DOWNLOAD_MODE_PARAMETER%>"/>
<c:set var="resultDownloadModeViewParameter" scope="session" value="<%=EvaluateEvallWebConstants.RESULT_DOWNLOAD_MODE_VIEW_PARAMETER%>"/>
<c:set var="resultIsEvaluatedParameter" scope="session" value="<%=EvaluateEvallWebConstants.RESULT_IS_EVALUATED_PARAMETER%>"/>
<c:set var="resultReportPathParameter" scope="session" value="<%=EvaluateEvallWebConstants.RESULT_REPORT_PATH_PARAMETER%>"/>
<c:set var="outputIsSavedParameter" scope="session" value="<%=EvaluateEvallWebConstants.OUTPUT_IS_SAVED_PARAMETER%>"/>
<c:set var="outputIdParameter" scope="session" value="<%=EvaluateEvallWebConstants.OUTPUT_ID_PARAMETER%>"/>
<c:set var="fileIdParameter" scope="session" value="<%=EvaluateEvallWebConstants.FILE_ID_PARAMETER%>"/>
<c:set var="fileNameParameter" scope="session" value="<%=EvaluateEvallWebConstants.FILE_NAME_PARAMETER%>"/>
<c:set var="outputDescriptionParameter" scope="session" value="<%=EvaluateEvallWebConstants.OUTPUT_DESCRIPTION_PARAMETER%>"/>
<c:set var="outputBibtexParameter" scope="session" value="<%=EvaluateEvallWebConstants.OUTPUT_BIBTEX_PARAMETER%>"/>
<c:set var="outputTitleParameter" scope="session" value="<%=EvaluateEvallWebConstants.OUTPUT_TITLE_PARAMETER%>"/>
<c:set var="outputUrlPaperParameter" scope="session" value="<%=EvaluateEvallWebConstants.OUTPUT_URL_PAPER_PARAMETER%>"/>
<c:set var="outputPublicationYearParameter" scope="session" value="<%=EvaluateEvallWebConstants.OUTPUT_PUBLICATION_YEAR_PARAMETER%>"/>
<c:set var="outputAuthorsParameter" scope="session" value="<%=EvaluateEvallWebConstants.OUTPUT_AUTHORS_PARAMETER%>"/>
<c:set var="fileParameter" scope="session" value="<%=EvaluateEvallWebConstants.FILE_PARAMETER%>"/>
<c:set var="fileTypeParameter" scope="session" value="<%=EvaluateEvallWebConstants.FILE_TYPE_PARAMETER%>"/>
<c:set var="view" scope="session" value="<%=EvaluateEvallWebConstants.VIEW%>"/>
<c:set var="benchmarkSearchView" scope="session" value="<%=EvaluateEvallWebConstants.BENCHMARK_SEARCH_VIEW%>"/>
<c:set var="benchmarkDescriptionView" scope="session" value="<%=EvaluateEvallWebConstants.BENCHMARK_DESCRIPTION_VIEW%>"/>
<c:set var="metricListView" scope="session" value="<%=EvaluateEvallWebConstants.METRIC_LIST_VIEW%>"/>
<c:set var="metricConfigView" scope="session" value="<%=EvaluateEvallWebConstants.METRIC_CONFIG_VIEW%>"/>
<c:set var="metricDetailView" scope="session" value="<%=EvaluateEvallWebConstants.METRIC_DETAIL_VIEW%>"/>
<c:set var="systemDescriptionView" scope="session" value="<%=EvaluateEvallWebConstants.SYSTEM_DESCRIPTION_VIEW%>"/>
<c:set var="systemListView" scope="session" value="<%=EvaluateEvallWebConstants.SYSTEM_LIST_VIEW%>"/>
<c:set var="defaultResultView" scope="session" value="<%=EvaluateEvallWebConstants.DEFAULT_RESULT_VIEW%>"/>
<c:set var="saveOutputView" scope="session" value="<%=EvaluateEvallWebConstants.SAVE_OUTPUT_VIEW%>"/>
<c:set var="saveOutputDetailView" scope="session" value="<%=EvaluateEvallWebConstants.SAVE_OUTPUT_DETAIL_VIEW%>"/>
<c:set var="uploadFileResource" scope="session" value="<%=EvaluateEvallWebConstants.UPLOAD_FILE_RESOURCE%>"/>
<c:set var="loadExampleFileResource" scope="session" value="<%=EvaluateEvallWebConstants.LOAD_EXAMPLE_FILE_RESOURCE%>"/>
<c:set var="renameFileResource" scope="session" value="<%=EvaluateEvallWebConstants.RENAME_FILE_RESOURCE%>"/>
<c:set var="uploadBibtexResource" scope="session" value="<%=EvaluateEvallWebConstants.UPLOAD_BIBTEX_RESOURCE%>"/>
<c:set var="deleteFileResource" scope="session" value="<%=EvaluateEvallWebConstants.DELETE_FILE_RESOURCE%>"/>
<c:set var="deleteAllFileResource" scope="session" value="<%=EvaluateEvallWebConstants.DELETE_ALL_FILE_RESOURCE%>"/>
<c:set var="downloadFileResource" scope="session" value="<%=EvaluateEvallWebConstants.DOWNLOAD_FILE_RESOURCE%>"/>
<c:set var="checkFileResource" scope="session" value="<%=EvaluateEvallWebConstants.CHECK_FILE_RESOURCE%>"/>
<c:set var="downloadPdfReportResource" scope="session" value="<%=EvaluateEvallWebConstants.DOWNLOAD_PDF_REPORT_RESOURCE%>"/>
<c:set var="downloadLatexReportResource" scope="session" value="<%=EvaluateEvallWebConstants.DOWNLOAD_LATEX_REPORT_RESOURCE%>"/>
<c:set var="downloadTsvReportResource" scope="session" value="<%=EvaluateEvallWebConstants.DOWNLOAD_TSV_REPORT_RESOURCE%>"/>
<c:set var="downloadOutputBbddResource" scope="session" value="<%=EvaluateEvallWebConstants.DOWNLOAD_OUTPUT_BBDD_RESOURCE%>"/>
<c:set var="downloadBenchmarkBibtexResource" scope="session" value="<%=EvaluateEvallWebConstants.DOWNLOAD_BENCHMARK_BIBTEX_RESOURCE%>"/>
<c:set var="downloadOutputBibtexResource" scope="session" value="<%=EvaluateEvallWebConstants.DOWNLOAD_OUTPUT_BIBTEX_RESOURCE%>"/>
<c:set var="downloadIconBenchmarkResource" scope="session" value="<%=EvaluateEvallWebConstants.DOWNLOAD_ICON_BENCHMARK_RESOURCE%>"/>
<c:set var="createCookieResource" scope="session" value="<%=EvaluateEvallWebConstants.CREATE_COOKIE_RESOURCE%>"/>
<c:set var="saveOutputResource" scope="session" value="<%=EvaluateEvallWebConstants.SAVE_OUTPUT_RESOURCE%>"/>
<c:set var="getBestSystemNameResource" scope="session" value="<%=EvaluateEvallWebConstants.GET_BEST_SYSTEM_NAME_RESOURCE%>"/>
<c:set var="checkExistOutputNameResource" scope="session" value="<%=EvaluateEvallWebConstants.CHECK_EXIST_OUTPUT_NAME_RESOURCE%>"/>
<c:set var="evaluateAction" scope="session" value="<%=EvaluateEvallWebConstants.EVALUATE_ACTION%>"/>

<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.save" var="save_text"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.save.output" var="save_output_text"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.back" var="back"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.next.step" var="next_step"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.benchmark.list.title" var="benchmark_list_title"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.benchmark.clear.search" var="benchmark_clear_search"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.evaluation.option.title" var="evaluation_option_title"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.evaluation.option.default" var="metric_option_default_text"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.evaluation.option.custom" var="metric_option_custom_text"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.metric.option.title" var="metric_option_title"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.metric.option.official.title" var="metric_option_official_title"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.metric.option.full.title" var="metric_option_full_title"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.metric.option.custom.title" var="metric_option_custom_title"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.metric.option.official.text" var="metric_option_official_text"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.metric.option.full.text" var="metric_option_full_text"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.metric.option.custom.text" var="metric_option_custom_text"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.baseline.option.title" var="baseline_option_title"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.baseline.option.best.title" var="baseline_option_best_title"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.baseline.option.select.title" var="baseline_option_select_title"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.baseline.option.best.text" var="baseline_option_best_text"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.baseline.option.select.text" var="baseline_option_select_text"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.system.field.name" var="system_field_name"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.system.field.title" var="system_field_title"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.system.field.description" var="system_field_description"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.system.field.author" var="system_field_author"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.system.field.paper" var="system_field_paper"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.system.field.date" var="system_field_date"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.pagination.arrow.right" var="system_pagination_arrow_right"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.pagination.arrow.left" var="system_pagination_arrow_left"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.report.option.title" var="report_option_title"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.report.option.pdf.title" var="report_option_pdf_title"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.report.option.tsv.title" var="report_option_tsv_title"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.report.option.descriptions.title" var="report_option_descriptions_title"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.report.option.warnings.title" var="report_option_warnings_title"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.report.option.pdf.text" var="report_option_pdf_text"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.report.option.tsv.text" var="report_option_tsv_text"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.report.option.descriptions.text" var="report_option_descriptions_text"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.report.option.warnings.text" var="report_option_warnings_text"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.upload.title" var="upload_title"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.upload.field.name" var="upload_field_name"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.upload.field.size" var="upload_field_size"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.upload.browse" var="upload_browse"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.upload.browse.bibtex" var="upload_browse_bibtex"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.upload.load.example" var="upload_load_example"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.upload.or" var="upload_browse_or_load"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.upload.dragAndDrop" var="upload_drag_drop"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.upload.evaluate" var="upload_evaluate"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.result.title" var="result_title"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.result.report" var="result_report"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.result.latex" var="result_latex"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.result.tsv" var="result_tsv"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.save.title" var="save_title"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.benchmark.text.for.title" var="benchmark_text_for_title"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.benchmark.details" var="benchmark_details"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.benchmark.authors" var="benchmark_authors"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.benchmark.links" var="benchmark_links"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.benchmark.conference" var="benchmark_conference"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.benchmark.workshop" var="benchmark_workshop"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.benchmark.year" var="benchmark_year"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.benchmark.task" var="benchmark_task"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.benchmark.measure" var="benchmark_measure"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.benchmark.other.measure" var="benchmark_other_measure"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.benchmark.website" var="benchmark_website"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.benchmark.paper" var="benchmark_paper"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.benchmark.bibtex" var="benchmark_bibtex"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.benchmark.description" var="benchmark_description"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.system.details" var="system_details"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.system.authors" var="system_authors"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.system.authors.title" var="system_authors_title"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.system.publication.title" var="system_publication_title"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.system.links" var="system_links"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.system.benchmark" var="system_benchmark"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.system.task" var="system_task"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.system.measure" var="system_measure"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.system.value" var="system_value"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.system.date" var="system_date"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.system.paper" var="system_paper"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.system.bibtex" var="system_bibtex"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.system.title" var="system_title"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.system.download" var="system_download"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.system.description" var="system_description"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.save.delete.author" var="save_delete_author"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.save.author.name" var="save_author_name"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.save.author.surname" var="save_author_surname"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.save.uploading.bibtex" var="save_uploading_bibtex"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.cookie.error.message" var="cookie_error_message"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.save.error.message" var="save_error_message"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.save.success.message" var="save_success_message"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.save.author.character.message1" var="save_author_character_message1"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.save.author.character.message2" var="save_author_character_message2"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.save.author.duplicate.message1" var="save_author_duplicate_message1"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.save.author.duplicate.message2" var="save_author_duplicate_message2"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.evaluate.noviewer" var="no_viewer"/>