<%@ include file="init.jsp"%>

<c:choose>
	<c:when test="${not empty requestScope[resultErrorParameter]}">
		<div id="error_evaluation">${requestScope[resultErrorParameter]}</div>
	</c:when>
	<c:otherwise>

		<c:if test="${not empty requestScope[outputIsSavedParameter]}">

			<script>
				var url = window.location.href;

				if(url.indexOf('#') == -1) {

					window.location.href = url + '#save'; 

				} else {

					window.location.href = url.replace(/#.+/g, '#save');
				}
			</script>
		</c:if>

		<portlet:resourceURL var="viewResult_report" id="${downloadPdfReportResource}">
			<portlet:param name="${resultDownloadModeParameter}" value="${resultDownloadModeViewParameter}" />
			<portlet:param name="${resultReportPathParameter}" value="${requestScope[resultReportPathParameter]}" />
		</portlet:resourceURL>

		<portlet:resourceURL var="downloadResult_report" id="${downloadPdfReportResource}">
			<portlet:param name="${resultReportPathParameter}" value="${requestScope[resultReportPathParameter]}" />
		</portlet:resourceURL>

		<portlet:resourceURL var="downloadResult_latexReport" id="${downloadLatexReportResource}">
			<portlet:param name="${resultReportPathParameter}" value="${requestScope[resultReportPathParameter]}" />
		</portlet:resourceURL>

		<portlet:resourceURL var="downloadResult_tsv" id="${downloadTsvReportResource}">
			<portlet:param name="${resultReportPathParameter}" value="${requestScope[resultReportPathParameter]}" />
		</portlet:resourceURL>

		<portlet:renderURL var="saveOutput" >
			<portlet:param name="${view}" value="${saveOutputView}" />
			<portlet:param name="${benchmarkIdParameter}" value="${requestScope[benchmarkIdParameter]}" />
		</portlet:renderURL>

		<c:set var="viewResult_report" value="${viewResult_report}#view=FitH"/>
		<c:set var="loading" value=""/>
		<c:set var="isPdf" value="application/pdf"/>
		<c:set var="saveURL" value="${saveOutput}"/>

		<c:if test="${empty requestScope[resultIsEvaluatedParameter]}">
		   <c:set var="viewResult_report" value=""/>
		   <c:set var="isPdf" value=""/>
		   <c:set var="downloadResult_report" value=""/>
		   <c:set var="downloadResult_latexReport" value=""/>
		   <c:set var="downloadResult_tsv" value=""/>
		</c:if>

		<c:if test="${!themeDisplay.isSignedIn()}">

			<c:set var="saveURL" value="${themeDisplay.getURLSignIn()}"/>

			<aui:script>
			AUI().ready('liferay-hudcrumbs', 'liferay-navigation-interaction', 'liferay-sign-in-modal' , function(){
	
				var signIn = AUI().one('#save_outputs');
	
				if (signIn) {

					signIn.plug(Liferay.SignInModal);
				}
			});
			</aui:script>
		</c:if>

		<c:if test="${not empty requestScope[resultIsEvaluatedParameter]}">
			<div id="fileResults">
			<c:set var="loading" value="loading"/>
			<input id="isSaved" type="hidden" name="<portlet:namespace/>${outputIsSavedParameter}" class="dataEvaluate dynamicValue" checked="checked" value="${requestScope[outputIsSavedParameter]}" />
			<input id="isEvaluated" type="hidden" name="<portlet:namespace/>${resultIsEvaluatedParameter}" class="dataEvaluate dynamicValue" checked="checked" value="true" />
			<input id="pathFiles" type="hidden" name="<portlet:namespace/>${resultReportPathParameter}" class="dataEvaluate dynamicValue" checked="checked" value="${requestScope[resultReportPathParameter]}" />
		</c:if>

		<h1 class="title">${result_title}</h1>
		<div class="frameSlide row">
			<div class="frameView" onmouseover="event.preventDefault(); $.fn.fullpage.setAllowScrolling(false); $.fn.fullpage.setKeyboardScrolling(false);" onmouseout="event.preventDefault(); $.fn.fullpage.setAllowScrolling(true); $.fn.fullpage.setKeyboardScrolling(true);">
				<object class="viewResult ${loading}" data="${viewResult_report}" type="${isPdf}" width="100%" height="100%" title="asfasdfasdf" name="ls">
					<embed class="viewResult loading" src="${viewResult_report}" width="100%" height="100%" title="fdfffffffddd" name="ls">
				</object>
				<div class="noview hidden">
					<p>${no_viewer}</p>
				</div>
			</div>
			<div class="downloads">
				<div class="frameDownloads">
					<table class="noCells">
						<tbody>
							<tr class="content tr_1">
								<td class="void"></td>
				  				<td class="td3 content first notactive reportOption1">
				  					<img height="150" src="${themeImagePath}/custom/common/evaluate/download_pdf-icon.png" href="javascript:void(0)" onclick="openURL(event, this, false, 'evaluation', 'downloadPdf', '${requestScope[resultReportPathParameter]}', 17001);" target="${downloadResult_report}" />
				  				</td>
				  				<td class="void reportOption1 middle"></td>
				  				<td class="td3 content first notactive reportOption1">
				  					<img height="150" src="${themeImagePath}/custom/common/evaluate/download_latex-icon.png" href="javascript:void(0)" onclick="openURL(event, this, false, 'evaluation', 'downloadlatex', '${requestScope[resultReportPathParameter]}', 17002);" target="${downloadResult_latexReport}" />
				  				</td>
				  				<td class="void reportOption1 reportOption2 middle"></td>
				  				<td class="td3 content first notactive reportOption2">
				  					<img height="150" src="${themeImagePath}/custom/common/evaluate/download_tsv-icon.png" href="javascript:void(0)" onclick="openURL(event, this, false, 'evaluation', 'downloadTsv', '${requestScope[resultReportPathParameter]}', 17003);" target="${downloadResult_tsv}" />
				  				</td>
				  				<td class="void"></td>
				  			</tr>
				  			<tr class="tr_2">
				  				<td class="void"></td>
				  				<td class="content last notactive reportOption1">
				  					<h2>${result_report}</h2>
				  				</td>
				  				<td class="void reportOption1 middle"></td>
				  				<td class="content last notactive reportOption1">
				  					<h2>${result_latex}</h2>
				  				</td>
				  				<td class="void reportOption1 reportOption2 middle"></td>
				  				<td class="content last notactive reportOption2">
				  					<h2>${result_tsv}</h2>
				  				</td>
				  				<td class="void"></td>
				  			</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
		<div class="arrow  ${arrowState} ${arrowState2}">
			<div class="blockArrow"></div>
	   		<div class="frameArrow">
	   			<a id="save_outputs" class="moveSectionDown" href="${saveURL}" onclick="goToSaveOutput(event, this, 17000);">
					<div class="arrow_section"></div>
					<p class="titleNextSection">${save_output_text}</p>
				</a>
			</div>
		</div>

		<c:if test="${not empty requestScope[resultIsEvaluatedParameter]}">
			</div>
		</c:if>

	</c:otherwise>
</c:choose>