<%@include file="init.jsp"%>

<% pageContext.setAttribute("measureEnum", MeasuresEnum.accuracy, PageContext.PAGE_SCOPE); %>

<portlet:resourceURL var="DownloadOutputServiceURL" id="${downloadOutputBbddResource}">
	<portlet:param name="${outputIdParameter}" value="${requestScope[systemParameter].getId()}" />
</portlet:resourceURL>

<portlet:resourceURL var="DownloadBibtexServiceURL" id="${downloadOutputBibtexResource}">
	<portlet:param name="${outputIdParameter}" value="${requestScope[systemParameter].getId()}" />
</portlet:resourceURL>

<div class="frameSlide detail" id="system_description">
	<div class="back">
		<a href="javascript:void(0)" class="title blackLink" onClick="backSlide(event, 52100);">${back}</a>
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
					<p><span class="bold">${system_publication_date}: </span>${requestScope[systemParameter].getYear()}</p>
					<p><span class="bold">${system_upload_date}: </span>${requestScope[systemParameter].getUploadDateString()}</p>
				</td>
				<td class="authors">
					<p><c:forEach var="author" items="${requestScope[systemParameter].getAuthors()}" varStatus="loop2">${author}<c:if test="${loop2.index + 1 < fn:length(requestScope[systemParameter].getAuthors())}">, </c:if></c:forEach></p>
				</td>
				<td class="links">
					<p><a class="standardColor bold paper" href="javascript:void(0)" onclick="openURL(event, this, false, OUTPUT_TYPE, 'viewPaper', '${requestScope[systemParameter].getId()} | ${requestScope[systemParameter].getTitle()}', 52101);" target="${requestScope[systemParameter].getUrlPaper()}">${system_paper}</a></p>
					<p><a class="standardColor bold download" href="javascript:void(0)" onclick="openURL(event, this, false, OUTPUT_TYPE, 'download', '${requestScope[systemParameter].getId()} | ${requestScope[systemParameter].getTitle()}', 52102);" target="${DownloadOutputServiceURL}">${system_download}</a></p>
					<p><a class="standardColor bold bibtex" href="javascript:void(0)" onclick="openURL(event, this, false, OUTPUT_TYPE, 'downloadBibtex', '${requestScope[systemParameter].getId()} | ${requestScope[systemParameter].getTitle()}', 52103);" target="${DownloadBibtexServiceURL}">${benchmark_bibtex}</a></p>
				</td>
			</tr>
			<tr>
				<td class="measures" colspan="3">
					<img src="${themeImagePath}/custom/common/evaluate/measure-icon.png" />
					<p class="title">${system_measures}</p>
					<table>
						<tr>
							<td class="measureNames">
								<span class="bold">${measureEnum.valueOf(requestScope[systemParameter].getOfficialMeasure()).getAbbreviation()} (${system_measure})</span>
							</td>
							<c:forEach var="measure" items="${requestScope[systemParameter].getMeasures()}" varStatus="loop">
								<c:if test = "${measure.value != '-1'}">
									<td class="measureNames left">
										<span class="bold">${measureEnum.valueOf(measure.key).getAbbreviation()}</span>
									</td>
								</c:if>
		            		</c:forEach>
						</tr>
						<tr>
							<td class="measureValues">
								<span>${requestScope[systemParameter].getMeasures().get(requestScope[systemParameter].getOfficialMeasure())}</span>
							</td>
							<c:forEach var="measure" items="${requestScope[systemParameter].getMeasures()}" varStatus="loop">
								<c:if test = "${measure.value != '-1'}">
									<td class="measureValues left">
										<span>${measure.value}</span>
									</td>
								</c:if>
		            		</c:forEach>
						</tr>
					</table>
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