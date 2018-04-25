<%@include file="../init.jsp" %>
<%@page import="es.uned.nlp.evall.evallweb.portal.core.PortalConstants"%>
<%@page import="es.uned.nlp.evall.evallweb.portlet.core.constant.EvallWebConstants"%>
<%@page import="es.uned.nlp.evall.evallweb.portlet.browserepository.constants.BrowseRepositoryEvallWebConstants"%>
<%@page import="es.uned.nlp.evallToolkit.configuration.Configuration"%>
<%@page import="es.uned.nlp.evallToolkit.measures.MeasuresEnum"%>
<%@page import="es.uned.nlp.evall.evallweb.portlet.core.model.OutputBean"%>
<%@page import="es.uned.nlp.evall.evallweb.portlet.core.util.EvallUserUtil"%>

<c:set var="themeImagePath" scope="session" value="<%=themeDisplay.getPathThemeImages()%>"/>
<c:set var="portletPath" scope="session" value="<%=request.getContextPath()%>"/>
<c:set var="liferayWindowState" scope="session" value="<%=LiferayWindowState.NORMAL.toString()%>"/>
<c:set var="liferayPortletId" scope="session" value="<%=themeDisplay.getPortletDisplay().getId()%>"/>
<c:set var="createCookieResource" scope="session" value="<%=BrowseRepositoryEvallWebConstants.CREATE_COOKIE_RESOURCE%>"/>
<c:set var="systemNumberPerPage" scope="session" value="<%=BrowseRepositoryEvallWebConstants.SYSTEM_NUMBER_PER_PAGE%>"/>
<c:set var="systemNumberMeasures" scope="session" value="<%=BrowseRepositoryEvallWebConstants.SYSTEM_NUMBER_MEASURES%>"/>
<c:set var="rowsPerPageBenchmark" scope="session" value="<%=BrowseRepositoryEvallWebConstants.ROWS_PER_PAGE_BENCHMARK%>"/>
<c:set var="columnsPerRowBenchmark" scope="session" value="<%=BrowseRepositoryEvallWebConstants.COLUMNS_PER_ROW_BENCHMARK%>"/>
<c:set var="colorPerColumns" scope="session" value="<%=BrowseRepositoryEvallWebConstants.COLOR_PER_COLUMNS%>"/>
<c:set var="outputType" scope="session" value="<%=BrowseRepositoryEvallWebConstants.OUTPUT_TYPE%>"/>
<c:set var="benchmarkAllEvallTasks" scope="session" value="<%=BrowseRepositoryEvallWebConstants.BENCHMARK_ALL_EVALLTASKS%>"/>
<c:set var="benchmarkAllConferences" scope="session" value="<%=BrowseRepositoryEvallWebConstants.BENCHMARK_ALL_CONFERENCES%>"/>
<c:set var="benchmarkAllYears" scope="session" value="<%=BrowseRepositoryEvallWebConstants.BENCHMARK_ALL_YEARS%>"/>
<c:set var="benchmarkAllWorkshops" scope="session" value="<%=BrowseRepositoryEvallWebConstants.BENCHMARK_ALL_WORKSHOPS%>"/>
<c:set var="textSearchParameter" scope="session" value="<%=BrowseRepositoryEvallWebConstants.TEXT_SEARCH_PARAMETER%>"/>
<c:set var="benchmarkIdParameter" scope="session" value="<%=BrowseRepositoryEvallWebConstants.BENCHMARK_ID_PARAMETER%>"/>
<c:set var="benchmarksParameter" scope="session" value="<%=BrowseRepositoryEvallWebConstants.BENCHMARKS_PARAMETER%>"/>
<c:set var="benchmarkEvallTaskParameter" scope="session" value="<%=BrowseRepositoryEvallWebConstants.BENCHMARK_EVALLTASK_PARAMETER%>"/>
<c:set var="benchmarkConferenceParameter" scope="session" value="<%=BrowseRepositoryEvallWebConstants.BENCHMARK_CONFERENCE_PARAMETER%>"/>
<c:set var="benchmarkYearParameter" scope="session" value="<%=BrowseRepositoryEvallWebConstants.BENCHMARK_YEAR_PARAMETER%>"/>
<c:set var="benchmarkWorkshopParameter" scope="session" value="<%=BrowseRepositoryEvallWebConstants.BENCHMARK_WORKSHOP_PARAMETER%>"/>
<c:set var="benchmarkEvallTaskListParameter" scope="session" value="<%=BrowseRepositoryEvallWebConstants.BENCHMARK_EVALLTASK_LIST_PARAMETER%>"/>
<c:set var="benchmarkConferenceListParameter" scope="session" value="<%=BrowseRepositoryEvallWebConstants.BENCHMARK_CONFERENCE_LIST_PARAMETER%>"/>
<c:set var="benchmarkYearListParameter" scope="session" value="<%=BrowseRepositoryEvallWebConstants.BENCHMARK_YEAR_LIST_PARAMETER%>"/>
<c:set var="benchmarkWorkshopListParameter" scope="session" value="<%=BrowseRepositoryEvallWebConstants.BENCHMARK_WORKSHOP_LIST_PARAMETER%>"/>
<c:set var="benchmarkParameter" scope="session" value="<%=BrowseRepositoryEvallWebConstants.BENCHMARK_PARAMETER%>"/>
<c:set var="systemSelectedMeasureListParameter" scope="session" value="<%=BrowseRepositoryEvallWebConstants.SYSTEM_SELECTED_MEASURE_LIST_PARAMETER%>"/>
<c:set var="systemIdParameter" scope="session" value="<%=BrowseRepositoryEvallWebConstants.SYSTEM_ID_PARAMETER%>"/>
<c:set var="systemNameParameter" scope="session" value="<%=BrowseRepositoryEvallWebConstants.SYSTEM_NAME_PARAMETER%>"/>
<c:set var="systemValueParameter" scope="session" value="<%=BrowseRepositoryEvallWebConstants.SYSTEM_VALUE_PARAMETER%>"/>
<c:set var="systemDateParameter" scope="session" value="<%=BrowseRepositoryEvallWebConstants.SYSTEM_DATE_PARAMETER%>"/>
<c:set var="systemPaginationParameter" scope="session" value="<%=BrowseRepositoryEvallWebConstants.SYSTEM_PAGINATION_PARAMETER%>"/>
<c:set var="systemPropertyParameter" scope="session" value="<%=BrowseRepositoryEvallWebConstants.SYSTEM_PROPERTY_PARAMETER%>"/>
<c:set var="systemOrderParameter" scope="session" value="<%=BrowseRepositoryEvallWebConstants.SYSTEM_ORDER_PARAMETER%>"/>
<c:set var="systemMeasureListParameter" scope="session" value="<%=BrowseRepositoryEvallWebConstants.SYSTEM_MEASURE_LIST_PARAMETER%>"/>
<c:set var="systemResultNumberParameter" scope="session" value="<%=BrowseRepositoryEvallWebConstants.SYSTEM_RESULT_NUMBER_PARAMETER%>"/>
<c:set var="systemResultsParameter" scope="session" value="<%=BrowseRepositoryEvallWebConstants.SYSTEM_RESULTS_PARAMETER%>"/>
<c:set var="systemParameter" scope="session" value="<%=BrowseRepositoryEvallWebConstants.SYSTEM_PARAMETER%>"/>
<c:set var="systemBeginPaginationParameter" scope="session" value="<%=BrowseRepositoryEvallWebConstants.SYSTEM_BEGIN_PAGINATION_PARAMETER%>"/>
<c:set var="systemOrderPaginationParameter" scope="session" value="<%=BrowseRepositoryEvallWebConstants.SYSTEM_ORDER_PAGINATION_PARAMETER%>" />
<c:set var="fileParameter" scope="session" value="<%=BrowseRepositoryEvallWebConstants.FILE_PARAMETER%>"/>
<c:set var="fileTypeParameter" scope="session" value="<%=BrowseRepositoryEvallWebConstants.FILE_TYPE_PARAMETER%>"/>
<c:set var="outputIdParameter" scope="session" value="<%=BrowseRepositoryEvallWebConstants.OUTPUT_ID_PARAMETER%>"/>
<c:set var="view" scope="session" value="<%=BrowseRepositoryEvallWebConstants.VIEW%>"/>
<c:set var="benchmarkSearchView" scope="session" value="<%=BrowseRepositoryEvallWebConstants.BENCHMARK_SEARCH_VIEW%>"/>
<c:set var="benchmarkDescriptionView" scope="session" value="<%=BrowseRepositoryEvallWebConstants.BENCHMARK_DESCRIPTION_VIEW%>"/>
<c:set var="systemDescriptionView" scope="session" value="<%=BrowseRepositoryEvallWebConstants.SYSTEM_DESCRIPTION_VIEW%>"/>
<c:set var="systemListView" scope="session" value="<%=BrowseRepositoryEvallWebConstants.SYSTEM_LIST_VIEW%>"/>
<c:set var="downloadFileResource" scope="session" value="<%=BrowseRepositoryEvallWebConstants.DOWNLOAD_FILE_RESOURCE%>"/>
<c:set var="downloadIconBenchmarkResource" scope="session" value="<%=BrowseRepositoryEvallWebConstants.DOWNLOAD_ICON_BENCHMARK_RESOURCE%>"/>
<c:set var="downloadOutputBbddResource" scope="session" value="<%=BrowseRepositoryEvallWebConstants.DOWNLOAD_OUTPUT_BBDD_RESOURCE%>"/>
<c:set var="downloadBenchmarkBibtexResource" scope="session" value="<%=BrowseRepositoryEvallWebConstants.DOWNLOAD_BENCHMARK_BIBTEX_RESOURCE%>"/>
<c:set var="downloadOutputBibtexResource" scope="session" value="<%=BrowseRepositoryEvallWebConstants.DOWNLOAD_OUTPUT_BIBTEX_RESOURCE%>"/>
<c:set var="downloadExcelResource" scope="session" value="<%=BrowseRepositoryEvallWebConstants.DOWNLOAD_EXCEL_RESOURCE%>"/>
<c:set var="deleteFileResource" scope="session" value="<%=BrowseRepositoryEvallWebConstants.DELETE_FILE_RESOURCE%>"/>
<c:set var="createCookieResource" scope="session" value="<%=BrowseRepositoryEvallWebConstants.CREATE_COOKIE_RESOURCE%>"/>

<spring:message code="es.uned.nlp.evall.evallweb.portlet.browseRepository.back" var="back"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.browseRepository.next.step" var="next_step"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.browseRepository.benchmark.list.title" var="benchmark_list_title"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.browseRepository.benchmark.clear.search" var="benchmark_clear_search"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.browseRepository.system.field.name" var="system_field_name"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.browseRepository.system.field.title" var="system_field_title"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.browseRepository.system.field.description" var="system_field_description"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.browseRepository.system.field.author" var="system_field_author"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.browseRepository.system.field.paper" var="system_field_paper"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.browseRepository.pagination.arrow.right" var="system_pagination_arrow_right"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.browseRepository.pagination.arrow.left" var="system_pagination_arrow_left"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.browseRepository.benchmark.text.for.title" var="benchmark_text_for_title"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.browseRepository.benchmark.details" var="benchmark_details"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.browseRepository.benchmark.authors" var="benchmark_authors"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.browseRepository.benchmark.links" var="benchmark_links"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.browseRepository.benchmark.conference" var="benchmark_conference"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.browseRepository.benchmark.workshop" var="benchmark_workshop"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.browseRepository.benchmark.year" var="benchmark_year"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.browseRepository.benchmark.task" var="benchmark_task"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.browseRepository.benchmark.measure" var="benchmark_measure"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.browseRepository.benchmark.other.measure" var="benchmark_other_measure"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.browseRepository.benchmark.website" var="benchmark_website"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.browseRepository.benchmark.paper" var="benchmark_paper"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.browseRepository.benchmark.bibtex" var="benchmark_bibtex"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.browseRepository.benchmark.description" var="benchmark_description"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.browseRepository.system.list.title" var="system_list_title"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.browseRepository.system.details" var="system_details"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.browseRepository.system.authors" var="system_authors"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.browseRepository.system.links" var="system_links"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.browseRepository.system.measures" var="system_measures"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.browseRepository.system.benchmark" var="system_benchmark"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.browseRepository.system.task" var="system_task"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.browseRepository.system.measure" var="system_measure"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.browseRepository.system.value" var="system_value"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.browseRepository.system.publicationDate" var="system_publication_date"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.browseRepository.system.uploadDate" var="system_upload_date"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.browseRepository.system.paper" var="system_paper"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.browseRepository.system.bibtex" var="system_bibtex"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.browseRepository.system.title" var="system_title"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.browseRepository.system.download" var="system_download"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.browseRepository.system.excel.export" var="excel_export"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.browseRepository.system.description" var="system_description"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.browseRepository.system.select.measures" var="select_measures"/>
<spring:message code="es.uned.nlp.evall.evallweb.portlet.browseRepository.cookie.error.message" var="cookie_error_message"/>