<%@ include file="init.jsp"%>

<portlet:resourceURL var="DownloadOutputServiceURL" id="${downloadOutputBbddResource}">
	<portlet:param name="${outputIdParameter}" value="${requestScope[systemParameter].getOutputId()}" />
</portlet:resourceURL>

<portlet:resourceURL var="DownloadBibtexServiceURL" id="${downloadBenchmarkBibtexResource}">
	<portlet:param name="${benchmarkIdParameter}" value="${requestScope[benchmarkParameter].getId()}" />
</portlet:resourceURL>

<div class="frameSlide detail" id="system_description">
	<div class="back">
		<a href="javascript:void(0)" class="title blackLink" onClick="backSlide(event, 14200);">${back}</a>
		<p class="title hidden" id="idSystem">${requestScope[systemParameter].getId()}</p>
	</div>
	<div class="description_zone subzone">
		<table class="table_description">
			<tr>
				<td colspan="3">
					<p class="title">${requestScope[systemParameter].getTitle()}</p>
				</td>
			</tr>
			<tr>
				<td class="details">
					<img src="${themeImagePath}/custom/common/evaluate/detail-icon.png" />
					<p class="title">${system_details}</p>
				</td>
				<td class="authors">
					<img src="${themeImagePath}/custom/common/evaluate/author-icon.png" />
					<p class="title">${system_authors}</p>
				</td>
				<td class="links">
					<img src="${themeImagePath}/custom/common/evaluate/link-icon.png" />
					<p class="title">${system_links}</p>
				</td>
			</tr>
			<tr>
				<td class="details">
					<p><span class="bold">${system_benchmark}: </span>${requestScope[systemParameter].getBenchmark()}</p>
					<p><span class="bold">${system_measure}: </span>${requestScope[systemParameter].getMeasure()}</p>
					<p><span class="bold">${system_value}: </span>${requestScope[systemParameter].getValue()}</p>
					<p><span class="bold">${system_date}: </span>${requestScope[systemParameter].getDate()}</p>
				</td>
				<td class="authors">
					<p><c:forEach var="author" items="${requestScope[systemParameter].getAuthors()}" varStatus="loop2">${author}<c:if test="${loop2.index + 1 < fn:length(requestScope[systemParameter].getAuthors())}">, </c:if></c:forEach></p>
				</td>
				<td class="links">
					<p><a class="standardColor bold paper" href="javascript:void(0)" onclick="openURL(event, this, false, OUTPUT_TYPE, 'viewPaper', '${requestScope[systemParameter].getId()} | ${requestScope[systemParameter].getTitle()}', 14201);" target="${requestScope[systemParameter].getUrlPaper()}">${system_paper}</a></p>
					<p><a class="standardColor bold download" href="javascript:void(0)" onclick="openURL(event, this, false, OUTPUT_TYPE, 'download', '${requestScope[systemParameter].getId()} | ${requestScope[systemParameter].getTitle()}', 14202);" target="${DownloadOutputServiceURL}">${system_download}</a></p>
					<p><a class="standardColor bold bibtex" href="javascript:void(0)" onclick="openURL(event, this, false, OUTPUT_TYPE, 'downloadBibtex', '${requestScope[systemParameter].getId()} | ${requestScope[systemParameter].getTitle()}', 14203);" target="${DownloadBibtexServiceURL}">${benchmark_bibtex}</a></p>
				</td>
			</tr>
			<tr>
				<td colspan="3">
					<img src="${themeImagePath}/custom/common/evaluate/description-icon.png" />
					<p class="title">${system_description}</p>
				</td>
			</tr>
			<tr>
				<td colspan="3">
					<p>${requestScope[systemParameter].getDescription()}</p>
				</td>
			</tr>
	 	</table>
 	</div>
</div>