<%@ include file="init.jsp"%>

<div class="frameSlide detail" id="metric_detail">
	<div class="back backFromMetricConfig">
		<a href="javascript:void(0)" class="title blackLink" id="titleMetric" onClick="backSlide(event, 13200);">${back}</a>
	</div>
	<div class="config_zone subzone">
		<div class="parameters">
			<c:if test="${fn:length(requestScope[metricParameterListParameter]) > 0}">
				<table class="table-main">
					<tbody>
			</c:if>	
			<c:forEach var="parameter" items="${requestScope[metricParameterListParameter]}" varStatus="loop">
				<c:set var="index" value="${loop.index + 1}"/>
				<tr class="contentTr tr_${index}" target="${parameter.getId()}">
					<td class="content name">
						<p>${parameter.getName()}</p>
					</td>
					<td class="content decription">
						<p>${parameter.getDescription()}</p>
					</td>
					<td class="content value">
						<input id="measureParameter_${parameter.getId()}_change" type="hidden" class="change" value="0"/>
						<input id="measureParameter_${parameter.getId()}" type="text" value="${parameter.getValue()}" class="val" onChange="activateChangeParameter(event, this, 13202);"/>
					</td>
				</tr>
			</c:forEach>
			<c:if test="${fn:length(requestScope[metricParameterListParameter]) > 0}">
					</tbody>
				</table>
				<input type="button" id="saveParameters" value="${save_text}" onClick="setMetricParameter(event, this, 13201);" />
			</c:if>	
	 	</div>
 	</div>
</div>