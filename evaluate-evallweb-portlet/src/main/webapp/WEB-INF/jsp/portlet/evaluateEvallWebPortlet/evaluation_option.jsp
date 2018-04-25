<c:set var="block" scope="session" value=""/>
<c:set var="arrowState2" scope="session" value="disabled2"/>
<c:if test="${not empty requestScope[benchmarkIdParameter]}">
	<c:set var="block" scope="session" value="disabled"/>
	<c:set var="arrowState2" scope="session" value=""/>
</c:if>

<c:set var="arrowState" scope="session" value="disabled"/>

<c:set var="default_evaluation_option_check" scope="session" value=""/>
<c:set var="default_evaluation_option_active" scope="session" value="notactive"/>
<c:if test="${not empty requestScope[evaluationOptionParameter] && requestScope[evaluationOptionParameter] eq 'default'}">
	<c:set var="default_evaluation_option_check" scope="session" value="checked='checked'"/>
	<c:set var="default_evaluation_option_active" scope="session" value="active"/>
	<c:set var="arrowState" scope="session" value=""/>
</c:if>

<c:set var="custom_evaluation_option_check" scope="session" value=""/>
<c:set var="custom_evaluation_option_active" scope="session" value="notactive"/>
<c:if test="${not empty requestScope[evaluationOptionParameter] && requestScope[evaluationOptionParameter] eq 'custom'}">
	<c:set var="custom_evaluation_option_check" scope="session" value="checked='checked'"/>
	<c:set var="custom_evaluation_option_active" scope="session" value="active"/>
	<c:set var="arrowState" scope="session" value=""/>
</c:if>

<div class="section dark background_gray evaluation" data-anchor="evaluation_option" title="Configuration" style="display: none;">
	<div class="frameSection">
		<div class="frameGeneric title_space arrow_space">
			<h1 class="title">${evaluation_option_title}</h1>
			<div class="frameSlide">
				<table class="noCells">
					<tbody>
						<tr class="content tr_1">
							<td class="void"></td>
			  				<td class="td2 content first ${default_evaluation_option_active}" target="1">
			  					<input id="evaluation_option_1" class="none dataEvaluate" type="checkbox" name="<portlet:namespace/>${evaluationOptionParameter}" value="default" ${default_evaluation_option_check}>
			  					<img class="" height="250" src="${themeImagePath}/custom/common/evaluate/default_evaluation.png" onclick="if(!$(this).closest('td.content').hasClass('active')){chooseOption(event, this, true, 12001);}" />
			  				</td>
			  				<td class="void middle"></td>
			  				<td class="td2 content first ${custom_evaluation_option_active}" target="2">
			  					<input id="evaluation_option_2" class="none dataEvaluate" type="checkbox" name="<portlet:namespace/>${evaluationOptionParameter}" value="custom" ${custom_evaluation_option_check}>
			  					<img class="" height="250" src="${themeImagePath}/custom/common/evaluate/not_default_evaluation.png" onclick="if(!$(this).closest('td.content').hasClass('active')){chooseOption(event, this, true, 12002);}" />
			  				</td>
			  				<td class="void"></td>
			  			</tr>
			  			<tr class="tr_2">
			  				<td class="void"></td>
			  				<td class="content middle ${default_evaluation_option_active}">
			  					<h2>Default</h2>
			  				</td>
			  				<td class="void middle"></td>
			  				<td class="content middle ${custom_evaluation_option_active}">
			  					<h2>Customized</h2>
			  				</td>
			  				<td class="void"></td>
			  			</tr>
			  			<tr class="tr_3">
			  				<td class="void"></td>
			  				<td class="content last ${default_evaluation_option_active}">
			  					<p>${metric_option_default_text}</p>
			  				</td>
			  				<td class="void middle"></td>
			  				<td class="content last ${custom_evaluation_option_active}">
			  					<p>${metric_option_custom_text}</p>
			  				</td>
			  				<td class="void"></td>
			  			</tr>
					</tbody>
				</table>
			</div>
			<div class="arrow ${arrowState} ${arrowState2}">
				<div class="blockArrow"></div>
		   		<div class="frameArrow">
					<a class="moveSectionDown" href="javascript:void(0)" onclick="choose_evaluation_option(event, this, 12000);">
						<div class="arrow_section"></div>
						<p class="titleNextSection">${next_step}</p>
					</a>
				</div>
			</div>
		</div>
	</div>
	<div class="section-block ${block}"></div>
</div>