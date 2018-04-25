<%@ include file="init.jsp"%>

<script>
var MAX_SIZE_MESSAGE = '<c:out value="${maximumSizeMessage}"/>';
var MAX_NUMBER_MESSAGE = '<c:out value="${maximumNumberMessage}"/>';
var MIMETYPE_MESSAGE = '<c:out value="${mimetypeMessage}"/>';
var TEXT_MIMETYPE = '<c:out value="${textMimetype}"/>';
var CSV_MIMETYPE = '<c:out value="${csvMimetype}"/>';
var MAX_CHARACTER_NUMBER = '<c:out value="${maximumCharacterNumber}"/>';
var UPLOAD_MAX_LENGTH_NAME = '<c:out value="${uploadMaxLengthName}"/>';
var UPLOAD_MAX_KB = '<c:out value="${uploadMaxKb}"/>';
var UPLOAD_MAX_NUMBER_PDF = '<c:out value="${uploadMaxNumberPdf}"/>';
var UPLOAD_MAX_NUMBER_TSV = '<c:out value="${uploadMaxNumberTsv}"/>';
var FILE_NUMBER_PER_PAGE = '<c:out value="${fileNumberPerPage}"/>';
var SYSTEM_NUMBER_PER_PAGE = '<c:out value="${systemNumberPerPage}"/>';
var OUTPUT_NUMBER_PER_PAGE = '<c:out value="${outputNumberPerPage}"/>';
var PORTLET_IMAGE_PATH = '<c:out value="${portletPath}"/>/img/';
var PORTLET_NAMESPACE = '<portlet:namespace/>';
var LIFERAY_WINDOW_STATE = '<c:out value="${liferayWindowState}"/>';
var LIFERAY_PORTLET_ID = '<c:out value="${liferayPortletId}"/>';
var LIFERAY_PORTLET_MODE = 'VIEW';
var ROWS_PER_PAGE_BENCHMARK = '<c:out value="${rowsPerPageBenchmark}"/>';
var ROWS_PER_PAGE_METRIC = '<c:out value="${rowsPerPageMetric}"/>';
var COLUMNS_PER_ROW_BENCHMARK = '<c:out value="${columnsPerRowBenchmark}"/>';
var COLUMNS_PER_ROW_METRIC = '<c:out value="${columnsPerRowMetric}"/>';
var TEXT_SEARCH_PARAMETER = '<c:out value="${textSearchParameter}"/>';
var BENCHMARK_PARAMETER = '<c:out value="${benchmarkParameter}"/>';
var BENCHMARK_ID_PARAMETER = '<c:out value="${benchmarkIdParameter}"/>';
var BENCHMARK_EVALLTASK_PARAMETER = '<c:out value="${benchmarkEvallTaskParameter}"/>';
var BENCHMARK_CONFERENCE_PARAMETER = '<c:out value="${benchmarkConferenceParameter}"/>';
var BENCHMARK_YEAR_PARAMETER = '<c:out value="${benchmarkYearParameter}"/>';
var BENCHMARK_WORKSHOP_PARAMETER = '<c:out value="${benchmarkWorkshopParameter}"/>';
var BENCHMARKS_PARAMETER = '<c:out value="${benchmarksParameter}"/>';
var METRIC_ID_PARAMETER = '<c:out value="${metricIdParameter}"/>';
var METRIC_PARAMETER_LIST_PARAMETER = '<c:out value="${metricParameterListParameter}"/>';
var SYSTEM_ID_PARAMETER = '<c:out value="${systemIdParameter}"/>';
var SYSTEM_PAGINATION_PARAMETER = '<c:out value="${systemPaginationParameter}"/>';
var SYSTEM_PROPERTY_PARAMETER = '<c:out value="${systemPropertyParameter}"/>';
var SYSTEM_ORDER_PARAMETER = '<c:out value="${systemOrderParameter}"/>';
var RESULT_ERROR_PARAMETER = '<c:out value="${resultErrorParameter}"/>';
var UPLOAD_MAX_NUMBER_PARAMETER = '<c:out value="${uploadMaxNumberParameter}"/>';
var OUTPUT_ID_PARAMETER = '<c:out value="${outputIdParameter}"/>';
var FILE_ID_PARAMETER = '<c:out value="${fileIdParameter}"/>';
var FILE_NAME_PARAMETER = '<c:out value="${fileNameParameter}"/>';
var OUTPUT_IS_SAVED_PARAMETER = '<c:out value="${outputIsSavedParameter}"/>';
var FILE_TYPE_PARAMETER = '<c:out value="${fileTypeParameter}"/>';
var GOLDSTANDARD_TYPE = '<c:out value="${goldstandardType}"/>';
var OUTPUT_TYPE = '<c:out value="${outputType}"/>';
var VIEW = '<c:out value="${view}"/>';
var BENCHMARK_SEARCH_VIEW = '<c:out value="${benchmarkSearchView}"/>';
var BENCHMARK_DESCRIPTION_VIEW = '<c:out value="${benchmarkDescriptionView}"/>';
var METRIC_LIST_VIEW = '<c:out value="${metricListView}"/>';
var METRIC_CONFIG_VIEW = '<c:out value="${metricConfigView}"/>';
var METRIC_DETAIL_VIEW = '<c:out value="${metricDetailView}"/>';
var SYSTEM_DESCRIPTION_VIEW = '<c:out value="${systemDescriptionView}"/>';
var SYSTEM_LIST_VIEW = '<c:out value="${systemListView}"/>';
var DEFAULT_RESULT_VIEW = '<c:out value="${defaultResultView}"/>';
var SAVE_OUTPUT_VIEW = '<c:out value="${saveOutputView}"/>';
var SAVE_OUTPUT_DETAIL_VIEW = '<c:out value="${saveOutputDetailView}"/>';
var DELETE_FILE_RESOURCE = '<c:out value="${deleteFileResource}"/>';
var DOWNLOAD_FILE_RESOURCE = '<c:out value="${downloadFileResource}"/>';
var RENAME_FILE_RESOURCE = '<c:out value="${renameFileResource}"/>';
var CHECK_FILE_RESOURCE = '<c:out value="${checkFileResource}"/>';
var SAVE_OUTPUT_RESOURCE = '<c:out value="${saveOutputResource}"/>';
var CREATE_COOKIE_RESOURCE = '<c:out value="${createCookieResource}"/>';
var GET_BEST_SYSTEM_NAME_RESOURCE = '<c:out value="${getBestSystemNameResource}"/>';
var CHECK_EXIST_OUTPUT_NAME_RESOURCE = '<c:out value="${checkExistOutputNameResource}"/>';
var LOAD_EXAMPLE_FILE_RESOURCE = '<c:out value="${loadExampleFileResource}"/>';
var COOKIE_ERROR_MESSAGE = '<c:out value="${cookie_error_message}"/>';
var SAVE_ERROR_MESSAGE = '<c:out value="${save_error_message}"/>';
var SAVE_SUCCESS_MESSAGE = '<c:out value="${save_success_message}"/>';
var SAVE_AUTHOR_CHARACTER_MESSAGE1 = '<c:out value="${save_author_character_message1}"/>';
var SAVE_AUTHOR_CHARACTER_MESSAGE2 = '<c:out value="${save_author_character_message2}"/>';
var SAVE_AUTHOR_DUPLICATE_MESSAGE1 = '<c:out value="${save_author_duplicate_message1}"/>';
var SAVE_AUTHOR_DUPLICATE_MESSAGE2 = '<c:out value="${save_author_duplicate_message2}"/>';
</script>

<%@include file="benchmark_list.jsp"%>
<%@include file="evaluation_option.jsp"%>
<%@include file="metric_option.jsp"%>
<%@include file="baseline.jsp"%>
<%@include file="report_option.jsp"%>
<%@include file="upload_file.jsp"%>
<%@include file="default_result.jsp"%>
<%@include file="save_output_frame.jsp"%>