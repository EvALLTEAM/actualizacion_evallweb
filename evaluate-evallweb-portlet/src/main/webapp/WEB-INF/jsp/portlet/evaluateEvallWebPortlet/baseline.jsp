<c:set var="block" scope="session" value=""/>
<c:set var="arrowState2" scope="session" value="disabled2"/>
<c:if test="${not empty requestScope[benchmarkIdParameter] && not empty requestScope[evaluationOptionParameter] && not empty requestScope[metricOptionParameter]}">
	<c:set var="block" scope="session" value="disabled"/>
	<c:set var="arrowState2" scope="session" value=""/>
</c:if>

<c:set var="arrowState" scope="session" value="disabled"/>

<c:set var="baseline_option_1_check" scope="session" value=""/>
<c:set var="baseline_option_1_active" scope="session" value="notactive"/>
<c:if test="${not empty requestScope[baselineOptionParameter] && requestScope[baselineOptionParameter] eq 'best_database'}">
	<c:set var="baseline_option_1_check" scope="session" value="checked='checked'"/>
	<c:set var="baseline_option_1_active" scope="session" value="active"/>
	<c:set var="arrowState" scope="session" value=""/>
</c:if>

<c:set var="baseline_option_2_check" scope="session" value=""/>
<c:set var="baseline_option_2_active" scope="session" value="notactive"/>
<c:set var="valueSystem" scope="session" value=""/>
<c:set var="valueMetricParameters" scope="session" value=""/>
<c:if test="${not empty requestScope[baselineOptionParameter] && requestScope[baselineOptionParameter] eq 'personalized_selection'}">
	<c:set var="baseline_option_2_check" scope="session" value="checked='checked'"/>
	<c:set var="baseline_option_2_active" scope="session" value="active"/>
	<c:if test="${not empty requestScope[systemIdParameter]}">
		<c:set var="valueSystem" scope="session" value="value='${requestScope[systemIdParameter]}'"/>
		<c:set var="arrowState" scope="session" value=""/>
	</c:if>
</c:if>

<div class="section background_white evaluation" data-anchor="baseline" title="Baselines" style="display: none;">
	<div class="frameSection">
		<div class="frameGeneric title_space arrow_space">
			<h1 class="title">${baseline_option_title}</h1>
			<input id="systemInput" type="hidden" name="<portlet:namespace/>${systemIdParameter}" class="dataEvaluate dynamicValue optionValue" checked="checked" ${valueSystem}/>
			<input id="bestSystemName" type="hidden"/>
			<div class="slide fp-auto-height" data-anchor="baseline_option">
				<div class="frameSlide">
					<table class="noCells">
						<tbody>
							<tr class="content tr_1">
								<td class="void"></td>
				  				<td class="td2 content first ${baseline_option_1_active}">
				  					<input id="baselineOption1" class="none dataEvaluate" type="checkbox" name="<portlet:namespace/>${baselineOptionParameter}" value="best_database" ${baseline_option_1_check}>
				  					<img class="" height="200" src="${themeImagePath}/custom/common/evaluate/first_system.png" onclick="if(!$(this).closest('td.content').hasClass('active')){resetOption(event, this); chooseOption(event, this, true, 14001); checkFileNames($('#uploaded-files'), true);}" />
				  				</td>
				  				<td class="void middle"></td>
				  				<td class="td2 content first ${baseline_option_2_active}">
				  					<input id="baselineOption2" class="none dataEvaluate" type="checkbox" name="<portlet:namespace/>${baselineOptionParameter}" value="personalized_selection" ${baseline_option_2_check}>
				  					<img class="pointer" height="200" src="${themeImagePath}/custom/common/evaluate/select_system.png" onclick="if(!$(this).closest('td.content').hasClass('active')){chooseOption(event, this, true, 14002);} goToSystems(event, this, 14003);" />
				  				</td>
				  				<td class="void"></td>
				  			</tr>
				  			<tr class="tr_2">
				  				<td class="void"></td>
				  				<td class="content middle ${baseline_option_1_active}">
				  					<h2>${baseline_option_best_title}</h2>
				  				</td>
				  				<td class="void middle"></td>
				  				<td class="content middle ${baseline_option_2_active}">
				  					<h2>${baseline_option_select_title}</h2>
				  				</td>
				  				<td class="void"></td>
				  			</tr>
				  			<tr class="tr_3">
				  				<td class="void"></td>
				  				<td class="content last ${baseline_option_1_active}">
				  					<p>${baseline_option_best_text}</p>
				  				</td>
				  				<td class="void middle"></td>
				  				<td class="content last ${baseline_option_2_active}">
				  					<p>${baseline_option_select_text}</p>
				  				</td>
				  				<td class="void"></td>
				  			</tr>
						</tbody>
					</table>
				</div>
			</div>
			<div class="slide fp-auto-height dynamic" data-anchor="systems">
				<div id="systemsDiv" class="frameSlide list"></div>
			</div>
			<div class="slide fp-auto-height dynamic" data-anchor="description">
	   			<div class="detail frameSlide" id="descriptionDiv"></div>
	   		</div>
			<div class="arrow ${arrowState} ${arrowState2}">
				<div class="blockArrow"></div>
		   		<div class="frameArrow">
					<a class="moveSectionDown" href="javascript:void(0)" onclick="unblockTypeOfReport(event, true, 13000);">
						<div class="arrow_section"></div>
						<p class="titleNextSection">${next_step}</p>
					</a>
				</div>
			</div>
		</div>
	</div>
	<div class="section-block ${block}"></div>
</div>