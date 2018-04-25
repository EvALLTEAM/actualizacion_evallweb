<%@ include file="init.jsp"%>

<script>
var PORTLET_IMAGE_PATH = '<c:out value="${portletPath}"/>/img/';
var PORTLET_NAMESPACE = '<portlet:namespace/>';
var LIFERAY_WINDOW_STATE = '<c:out value="${liferayWindowState}"/>';
var LIFERAY_PORTLET_ID = '<c:out value="${liferayPortletId}"/>';
var LIFERAY_PORTLET_MODE = 'VIEW';
var DOWNLOAD_FILE_RESOURCE = '<c:out value="${downloadFileResource}"/>';
var DELETE_FILE_RESOURCE = '<c:out value="${deleteFileResource}"/>';
var SYSTEM_NUMBER_PER_PAGE = '<c:out value="${systemNumberPerPage}"/>';
var SYSTEM_NUMBER_MEASURES = '<c:out value="${systemNumberMeasures}"/>';
var VIEW = '<c:out value="${view}"/>';
var OUTPUT_TYPE = '<c:out value="${outputType}"/>';
var FILE_TYPE_PARAMETER = '<c:out value="${fileTypeParameter}"/>';
var SYSTEM_SELECTED_MEASURE_LIST_PARAMETER = '<c:out value="${systemSelectedMeasureListParameter}"/>';
var SYSTEM_ID_PARAMETER = '<c:out value="${systemIdParameter}"/>';
var SYSTEM_PAGINATION_PARAMETER = '<c:out value="${systemPaginationParameter}"/>';
var SYSTEM_PROPERTY_PARAMETER = '<c:out value="${systemPropertyParameter}"/>';
var SYSTEM_ORDER_PARAMETER = '<c:out value="${systemOrderParameter}"/>';
var BENCHMARK_PARAMETER = '<c:out value="${benchmarkParameter}"/>';
var BENCHMARK_ID_PARAMETER = '<c:out value="${benchmarkIdParameter}"/>';
var BENCHMARK_EVALLTASK_PARAMETER = '<c:out value="${benchmarkEvallTaskParameter}"/>';
var BENCHMARK_CONFERENCE_PARAMETER = '<c:out value="${benchmarkConferenceParameter}"/>';
var BENCHMARK_YEAR_PARAMETER = '<c:out value="${benchmarkYearParameter}"/>';
var BENCHMARK_WORKSHOP_PARAMETER = '<c:out value="${benchmarkWorkshopParameter}"/>';
var BENCHMARKS_PARAMETER = '<c:out value="${benchmarksParameter}"/>';
var ROWS_PER_PAGE_BENCHMARK = '<c:out value="${rowsPerPageBenchmark}"/>';
var COLUMNS_PER_ROW_BENCHMARK = '<c:out value="${columnsPerRowBenchmark}"/>';
var TEXT_SEARCH_PARAMETER = '<c:out value="${textSearchParameter}"/>';
var OUTPUT_ID_PARAMETER = '<c:out value="${outputIdParameter}"/>';
var SYSTEM_DESCRIPTION_VIEW = '<c:out value="${systemDescriptionView}"/>';
var SYSTEM_LIST_VIEW = '<c:out value="${systemListView}"/>';
var BENCHMARK_SEARCH_VIEW = '<c:out value="${benchmarkSearchView}"/>';
var BENCHMARK_DESCRIPTION_VIEW = '<c:out value="${benchmarkDescriptionView}"/>';
var COOKIE_ERROR_MESSAGE = '<c:out value="${cookie_error_message}"/>';
var CREATE_COOKIE_RESOURCE = '<c:out value="${createCookieResource}"/>';
</script>

<%@include file="benchmark_list.jsp"%>
<%@include file="system_list.jsp"%>