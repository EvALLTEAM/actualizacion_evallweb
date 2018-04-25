<c:set var="block" scope="session" value=""/>
<c:set var="arrowState2" scope="session" value="disabled2"/>
<c:if test="${not empty requestScope[benchmarkIdParameter] && not empty requestScope[evaluationOptionParameter] && not empty requestScope[metricOptionParameter] && not empty requestScope[baselineOptionParameter]}">
	<c:set var="block" scope="session" value="disabled"/>
	<c:set var="arrowState2" scope="session" value=""/>
</c:if>

<c:set var="arrowState" scope="session" value="disabled"/>

<c:set var="report_option_generate_latex_check" scope="session" value=""/>
<c:set var="report_option_generate_latex_active" scope="session" value="notactive"/>
<c:set var="report_option_generate_latex_disabled" scope="session" value="disabled"/>
<c:if test="${not empty requestScope[reportOptionGerateLatexParameter]}">
	<c:set var="report_option_generate_latex_check" scope="session" value="checked='checked'"/>
	<c:set var="report_option_generate_latex_active" scope="session" value="active"/>
	<c:set var="report_option_generate_latex_disabled" scope="session" value=""/>
	<c:set var="arrowState" scope="session" value=""/>
</c:if>

<c:set var="report_option_generate_tsv__check" scope="session" value=""/>
<c:set var="report_option_generate_tsv__active" scope="session" value="notactive"/>
<c:if test="${not empty requestScope[reportOptionGerateTsvParameter]}">
	<c:set var="report_option_generate_tsv__check" scope="session" value="checked='checked'"/>
	<c:set var="report_option_generate_tsv__active" scope="session" value="active"/>
	<c:set var="arrowState" scope="session" value=""/>
</c:if>

<c:set var="report_option_descriptions_check" scope="session" value=""/>
<c:set var="report_option_descriptions_active" scope="session" value="notactive"/>
<c:if test="${not empty requestScope[reportOptionDescriptionsParameter]}">
	<c:set var="report_option_descriptions_check" scope="session" value="checked='checked'"/>
	<c:set var="report_option_descriptions_active" scope="session" value="active"/>
</c:if>

<c:set var="report_option_warnings_check" scope="session" value=""/>
<c:set var="report_option_warnings_active" scope="session" value="notactive"/>
<c:if test="${not empty requestScope[reportOptionWarningsParameter]}">
	<c:set var="report_option_warnings_check" scope="session" value="checked='checked'"/>
	<c:set var="report_option_warnings_active" scope="session" value="active"/>
</c:if>

<div class="section dark background_brown evaluation" data-anchor="report_option" title="Settings" style="display: none;">
	<div class="frameSection">
		<div class="frameGeneric title_space arrow_space">
			<h1 class="title">${report_option_title}</h1>
			<div class="frameSlide">
				<table class="noCells fourcols multiselect">
					<tbody>
						<tr class="content tr_1">
							<td class="void"></td>
			  				<td class="td2 content first ${report_option_generate_latex_active}">
			  					<input id="reportOption1" class="none dataEvaluate required" type="checkbox" name="<portlet:namespace/>${reportOptionGerateLatexParameter}" value="generate_pdf" ${report_option_generate_latex_check}>
			  					<img class="pointer" height="200" src="${themeImagePath}/custom/common/evaluate/generate_pdf.png" onclick="chooseMultipleOption(event, this, true, 15001); enableReportOptions(event, this); checkEvaluateButton(event, $('#uploaded-files'));" />
			  				</td>
			  				<td class="void middle"></td>
			  				<td class="td2 content first ${report_option_generate_tsv__active}">
			  					<input id="reportOption2" class="none dataEvaluate required" type="checkbox" name="<portlet:namespace/>${reportOptionGerateTsvParameter}" value="generate_tsv" ${report_option_generate_tsv__check}>
			  					<img class="pointer" height="200" src="${themeImagePath}/custom/common/evaluate/generate_tsv.png" onclick="chooseMultipleOption(event, this, true, 15002); checkEvaluateButton(event, $('#uploaded-files'));" />
			  				</td>
							<td class="void middle"></td>
			  				<td class="td2 content first ${report_option_descriptions_active} ${report_option_generate_latex_disabled}">
			  					<input id="reportOption3" class="none dataEvaluate" type="checkbox" name="<portlet:namespace/>${reportOptionDescriptionsParameter}" value="explanation_metric" ${report_option_descriptions_check}>
			  					<img class="pointer" height="200" src="${themeImagePath}/custom/common/evaluate/add_description_metrics.png" onclick="chooseMultipleOption(event, this, true, 15003);" />
			  				</td>
			  				<td class="void middle"></td>
			  				<td class="td2 content first ${report_option_warnings_active} ${report_option_generate_latex_disabled}">
			  					<input id="reportOption4" class="none dataEvaluate" type="checkbox" name="<portlet:namespace/>${reportOptionWarningsParameter}" value="verification_step" ${report_option_warnings_check}>
			  					<img class="pointer" height="200" src="${themeImagePath}/custom/common/evaluate/verification_inputs.png" onclick="chooseMultipleOption(event, this, true, 15004);" />
			  				</td>
			  				<td class="void"></td>
			  			</tr>
			  			<tr class="tr_2">
			  				<td class="void"></td>
			  				<td class="content middle ${report_option_generate_latex_active}">
			  					<h2>${report_option_pdf_title}</h2>
			  				</td>
			  				<td class="void middle"></td>
			  				<td class="content middle ${report_option_generate_tsv__active}">
			  					<h2>${report_option_tsv_title}</h2>
			  				</td>
			  				<td class="void middle"></td>
			  				<td class="content middle ${report_option_descriptions_active} ${report_option_generate_latex_disabled}">
			  					<h2>${report_option_descriptions_title}</h2>
			  				</td>
			  				<td class="void middle"></td>
			  				<td class="content middle ${report_option_warnings_active} ${report_option_generate_latex_disabled}">
			  					<h2>${report_option_warnings_title}</h2>
			  				</td>
			  				<td class="void"></td>
			  			</tr>
			  			<tr class="tr_3">
			  				<td class="void"></td>
			  				<td class="content last ${report_option_generate_latex_active}">
			  					<p>${report_option_pdf_text}</p>
			  				</td>
			  				<td class="void middle"></td>
			  				<td class="content last ${report_option_generate_tsv__active}">
			  					<p>${report_option_tsv_text}</p>
			  				</td>
			  				<td class="void middle"></td>
			  				<td class="content last ${report_option_descriptions_active} ${report_option_generate_latex_disabled}">
			  					<p>${report_option_descriptions_text}</p>
			  				</td>
			  				<td class="void middle"></td>
			  				<td class="content last ${report_option_warnings_active} ${report_option_generate_latex_disabled}">
			  					<p>${report_option_warnings_text}</p>
			  				</td>
			  				<td class="void"></td>
			  			</tr>
					</tbody>
				</table>
			</div>
			<div class="arrow ${arrowState} ${arrowState2}">
				<div class="blockArrow"></div>
		   		<div class="frameArrow">
					<a class="moveSectionDown" href="javascript:void(0)" onclick="unblockUpload(event, true, 15000);">
						<div class="arrow_section"></div>
						<p class="titleNextSection">${next_step}</p>
					</a>
				</div>
			</div>
		</div>
	</div>
	<div class="section-block ${block}"></div>
</div>