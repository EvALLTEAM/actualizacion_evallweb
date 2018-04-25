<c:set var="block" scope="session" value=""/>
<c:if test="${not empty requestScope[benchmarkIdParameter] && not empty requestScope[evaluationOptionParameter] && not empty requestScope[metricOptionParameter] && not empty requestScope[baselineOptionParameter] && not empty isEvaluated && not empty requestScope[outputIsSavedParameter]}">
	<c:set var="block" scope="session" value="disabled"/>
</c:if>

<div class="section background_white evaluation" data-anchor="save" title="Save" style="display: none;">
	<div class="frameSection">
		<div class="frameGeneric title_space">
			<h1 class="title">${save_title}</h1>
			<div class="slide fp-auto-height dynamic" data-anchor="output_list">
				<div class="list frameSlide" id="outputsToSave">
					<%@include file="save_output.jsp"%>
				</div>
			</div>
			<div class="slide fp-auto-height dynamic" data-anchor="detail_output">
				<div class="detail frameSlide" id="outputDetail"></div>
			</div>
		</div>
	</div>
	<div class="section-block ${block}"></div>
</div>