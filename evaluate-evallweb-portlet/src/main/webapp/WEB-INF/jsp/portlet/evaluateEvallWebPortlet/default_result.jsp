<c:set var="block" scope="session" value=""/>
<c:set var="arrowState2" scope="session" value="disabled2"/>
<c:if test="${not empty requestScope[benchmarkIdParameter] && not empty requestScope[evaluationOptionParameter] && not empty requestScope[metricOptionParameter] && not empty requestScope[baselineOptionParameter] && not empty requestScope[resultIsEvaluatedParameter]}">
	<c:set var="block" scope="session" value="disabled"/>
	<c:set var="arrowState2" scope="session" value=""/>
</c:if>

<c:set var="arrowState" scope="session" value="disabled"/>
<c:if test="${not empty requestScope[resultIsEvaluatedParameter]}">
	<c:set var="arrowState" scope="session" value=""/>
</c:if>

<div class="section background_gray evaluation" data-anchor="result" title="Results" style="display: none;">
	<div class="frameSection">
		<div class="frameGeneric title_space arrow_space">
			<%@include file="result.jsp"%>
		</div>
	</div>
	<div class="section-block ${block}"></div>
</div>