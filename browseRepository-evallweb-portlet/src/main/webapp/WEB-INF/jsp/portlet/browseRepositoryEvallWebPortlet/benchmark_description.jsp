<%@ include file="init.jsp"%>

<portlet:resourceURL var="DownloadServiceURL" id="${downloadBenchmarkBibtexResource}">
	<portlet:param name="${benchmarkIdParameter}" value="${requestScope[benchmarkParameter].getId()}" />
</portlet:resourceURL>

<div class="description frameSlide" id="benchmark_description">
	<div class="back">
		<a href="javascript:void(0)" class="title blackLink" id="titleBenchmark" onClick="backSlide(event, 51100);" target="${requestScope[benchmarkParameter].getId()}">${back}</a>
	</div>
	<div class="description_zone subzone">
		<table class="table_description">
			<tr>
				<td colspan="3">
					<p class="title">${requestScope[benchmarkParameter].getName()} ${benchmark_text_for_title}</p>
				</td>
			</tr>
			<tr>
				<td class="details">
					<img src="${themeImagePath}/custom/common/evaluate/detail-icon.png" />
					<p class="title">${benchmark_details}</p>
				</td>
				<td class="authors">
					<img src="${themeImagePath}/custom/common/evaluate/author-icon.png" />
					<p class="title">${benchmark_authors}</p>
				</td>
				<td class="links">
					<img src="${themeImagePath}/custom/common/evaluate/link-icon.png" />
					<p class="title">${benchmark_links}</p>
				</td>
			</tr>
			<tr>
				<td class="details">
					<p><span class="bold">${benchmark_conference}: </span>${requestScope[benchmarkParameter].getConference()}</p>
					<p><span class="bold">${benchmark_workshop}: </span>${requestScope[benchmarkParameter].getWorkshop()}</p>
					<p><span class="bold">${benchmark_year}: </span>${requestScope[benchmarkParameter].getYear()}</p>
					<p><span class="bold">${benchmark_task}: </span>${requestScope[benchmarkParameter].getTask()}</p>
					<p><span class="bold">${benchmark_measure}: </span>${requestScope[benchmarkParameter].getOfficialMeasure()}</p>
					<c:if test="${fn:length(requestScope[benchmarkParameter].getOtherOfficialMeasure()) > 0}"><p><span class="bold">${benchmark_other_measure}: </span>${requestScope[benchmarkParameter].getOtherOfficialMeasure()}</p></c:if>
				</td>
				<td class="authors">
					<p><c:forEach var="author" items="${requestScope[benchmarkParameter].getAuthors()}" varStatus="loop2">${author}<c:if test="${loop2.index + 1 < fn:length(requestScope[benchmarkParameter].getAuthors())}">, </c:if></c:forEach></p>
				</td>
				<td class="links">
					<c:if test="${!empty requestScope[benchmarkParameter].getUrlPage()}"><p><a class="standardColor bold official_website" href="javascript:void(0)" onclick="openURL(event, this, false, 'benchmark', 'viewPage', '${requestScope[benchmarkParameter].getId()} | ${requestScope[benchmarkParameter].getName()}', 51101);" target="${requestScope[benchmarkParameter].getUrlPage()}">${benchmark_website}</a></p></c:if>
					<c:if test="${!empty requestScope[benchmarkParameter].getUrlPaper()}"><p><a class="standardColor bold paper" href="javascript:void(0)" onclick="openURL(event, this, false, 'benchmark', 'viewPaper', '${requestScope[benchmarkParameter].getId()} | ${requestScope[benchmarkParameter].getName()}', 51102);" target="${requestScope[benchmarkParameter].getUrlPaper()}">${benchmark_paper}</a></p></c:if>
					<c:if test="${requestScope[benchmarkParameter].isHasBibtex()}"><p><a class="standardColor bold bibtex" href="javascript:void(0)" onclick="openURL(event, this, false, 'benchmark', 'downloadBibtex', '${requestScope[benchmarkParameter].getId()} | ${requestScope[benchmarkParameter].getName()}', 51103);" target="${DownloadServiceURL}">${benchmark_bibtex}</a></p></c:if>
				</td>
			</tr>
			<tr>
				<td colspan="3">
					<img src="${themeImagePath}/custom/common/evaluate/description-icon.png" />
					<p class="title">${benchmark_description}</p>
				</td>
			</tr>
			<tr>
				<td colspan="3">
					<p>${requestScope[benchmarkParameter].getDescription()}</p>
				</td>
			</tr>
	 	</table>
 	</div>
</div>