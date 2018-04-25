<c:set var="block" scope="session" value=""/>
<c:set var="arrowState2" scope="session" value="disabled2"/>
<c:if test="${not empty requestScope[benchmarkIdParameter] && not empty requestScope[evaluationOptionParameter]}">
	<c:set var="block" scope="session" value="disabled"/>
	<c:set var="arrowState2" scope="session" value=""/>
</c:if>

<c:set var="arrowState" scope="session" value="disabled"/>

<c:set var="official_metric_option_check" scope="session" value=""/>
<c:set var="official_metric_option_active" scope="session" value="notactive"/>
<c:if test="${not empty requestScope[metricOptionParameter] && requestScope[metricOptionParameter] eq 'official_metrics'}">
	<c:set var="official_metric_option_check" scope="session" value="checked='checked'"/>
	<c:set var="official_metric_option_active" scope="session" value="active"/>
	<c:set var="arrowState" scope="session" value=""/>
</c:if>

<c:set var="full_metric_option_check" scope="session" value=""/>
<c:set var="full_metric_option_active" scope="session" value="notactive"/>
<c:if test="${not empty requestScope[metricOptionParameter] && requestScope[metricOptionParameter] eq 'full_set_metrics'}">
	<c:set var="full_metric_option_check" scope="session" value="checked='checked'"/>
	<c:set var="full_metric_option_active" scope="session" value="active"/>
	<c:set var="arrowState" scope="session" value=""/>
</c:if>

<c:set var="personalized_metric_option_check" scope="session" value=""/>
<c:set var="personalized_metric_option_active" scope="session" value="notactive"/>
<c:set var="metric_value" scope="session" value=""/>
<c:set var="metric_parameter_value" scope="session" value=""/>
<c:if test="${not empty requestScope[metricOptionParameter] && requestScope[metricOptionParameter] eq 'personalized_set_metrics'}">
	<c:set var="personalized_metric_option_check" scope="session" value="checked='checked'"/>
	<c:set var="personalized_metric_option_active" scope="session" value="active"/>
	<c:if test="${not empty requestScope[metricsParameter]}">
		<c:set var="metric_value" scope="session" value="value='${requestScope[metricsParameter]}'"/>
		<c:set var="arrowState" scope="session" value=""/>
	</c:if>
	<c:if test="${not empty requestScope[metricParameterListParameter]}">
		<c:set var="metric_parameter_value" scope="session" value="value='${requestScope[metricParameterListParameter]}'"/>
	</c:if>
</c:if>

<div class="section dark background_blue evaluation" data-anchor="metric" title="Metrics" style="display: none;">
	<div class="frameSection">
		<div class="frameGeneric title_space arrow_space">
			<h1 class="title">${metric_option_title}</h1>
			<input id="metricInput" type="hidden" name="<portlet:namespace/>${metricsParameter}" class="dataEvaluate dynamicValue optionValue" checked="checked" ${metric_value}/>
			<input id="metricParametersInput" type="hidden" name="<portlet:namespace/>${metricParameterListParameter}" class="dataEvaluate dynamicValue" checked="checked" ${metric_parameter_value}/>
			<div class="slide fp-auto-height" data-anchor="metric_option">
				<div class="frameSlide">
					<table class="noCells">
						<tbody>
							<tr class="content tr_1">
								<td class="void"></td>
				  				<td class="td3 content first ${official_metric_option_active}">
				  					<input class="none dataEvaluate" type="radio" name="<portlet:namespace/>${metricOptionParameter}" value="official_metrics" ${official_metric_option_check}>
				  					<img id="official_metrics" height="200" src="${themeImagePath}/custom/common/evaluate/official_metrics.png" onclick="if(!$(this).closest('td.content').hasClass('active')){resetOption(event, this); chooseOption(event, this, true, 13001);}" />
				  				</td>
				  				<td class="void middle"></td>
				  				<td class="td3 content first ${full_metric_option_active}">
				  					<input class="none dataEvaluate" type="radio" name="<portlet:namespace/>${metricOptionParameter}" value="full_set_metrics" ${full_metric_option_check}>
				  					<img id="full_set_metrics" height="200" src="${themeImagePath}/custom/common/evaluate/all_metrics.png" onclick="if(!$(this).closest('td.content').hasClass('active')){resetOption(event, this); chooseOption(event, this, true, 13002);}" />
				  				</td>
				  				<td class="void middle"></td>
				  				<td class="td3 content first ${personalized_metric_option_active}">
				  					<input class="none dataEvaluate" type="radio" name="<portlet:namespace/>${metricOptionParameter}" value="personalized_set_metrics" ${personalized_metric_option_check}>
				  					<img id="personalized_set_metrics" height="200" class="pointer" src="${themeImagePath}/custom/common/evaluate/personalized_metrics.png" onclick="chooseOption(event, this, true, 13003); goToMetrics(event, this, 13004);" />
				  				</td>
				  				<td class="void"></td>
				  			</tr>
				  			<tr class="tr_2">
				  				<td class="void"></td>
				  				<td class="content middle ${official_metric_option_active}">
				  					<h2>${metric_option_official_title}</h2>
				  				</td>
				  				<td class="void middle"></td>
				  				<td class="content middle ${full_metric_option_active}">
				  					<h2>${metric_option_full_title}</h2>
				  				</td>
				  				<td class="void middle"></td>
				  				<td class="content middle ${personalized_metric_option_active}">
				  					<h2>${metric_option_custom_title}</h2>
				  				</td>
				  				<td class="void"></td>
				  			</tr>
				  			<tr class="tr_3">
				  				<td class="void"></td>
				  				<td class="content last ${official_metric_option_active}">
				  					<p>${metric_option_official_text}.</p>
				  				</td>
				  				<td class="void middle"></td>
				  				<td class="content last ${full_metric_option_active}">
				  					<p>${metric_option_full_text}</p>
				  				</td>
				  				<td class="void middle"></td>
				  				<td class="content last ${personalized_metric_option_active}">
				  					<p>${metric_option_custom_text}</p>
				  				</td>
				  				<td class="void"></td>
				  			</tr>
						</tbody>
					</table>
				</div>
			</div>
			<div class="slide fp-auto-height dynamic" data-anchor="metric_list">
				<div id="metricDiv" class="frameSlide list"></div>
			</div>
			<div class="slide fp-auto-height dynamic" data-anchor="metric_detail">
	   			<div class="detail frameSlide" id="detailDiv"></div>
	   		</div>
	   		<div class="arrow ${arrowState} ${arrowState2}">
				<div class="blockArrow"></div>
		   		<div class="frameArrow">
					<a class="moveSectionDown" href="javascript:void(0)" onclick="unblockBaseline(event, true, 13000);">
						<div class="arrow_section"></div>
						<p class="titleNextSection">${next_step}</p>
					</a>
				</div>
			</div>
		</div>
	</div>
	<div class="section-block ${block}"></div>
</div>