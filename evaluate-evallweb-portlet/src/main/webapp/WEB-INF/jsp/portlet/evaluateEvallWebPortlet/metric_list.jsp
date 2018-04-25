<%@ include file="init.jsp"%>

<c:set var="colors" value="${fn:split(colorPerColumns, ',')}" scope="session" />
<c:set var="delta" value="${0}"/>

<div class="frameSlide list" id="metricTable">
	<div class="back">
		<a href="javascript:void(0)" class="title blackLink" id="titleMetrics" onClick="backSlide(event, 13100);">${back}</a>
	</div>
	<div class="metric_zone subzone background_white black_border">
		<div class="subarea" id="evall_metrics">
			<table class="table-main dark removeBorders">
				<tbody>
					<tr class="void thVoid">
						<th class=""></th>
						<th class="void"></th>
						<th class=""></th>
						<th class="void"></th>
						<th class=""></th>
					</tr>
					<c:forEach var="metric" items="${requestScope[metricsParameter]}" varStatus="loop">
						<c:set var="index" value="${loop.index + 1}"/>
						<c:if test="${(index - 1) % columnsPerRowMetric == 0}">
							<fmt:parseNumber var="i" integerOnly="true" type="number" value="${(index / columnsPerRowMetric) + 1}" />
							<c:if test="${index != 1}">
								<c:set var="delta" value="${delta + 1}"/>
								<tr class="void">
									<td class="void"></td>
									<td class="void"></td>
									<td class="void"></td>
									<td class="void"></td>
									<td class="void"></td>
								</tr>
							</c:if>
							<tr class="visible contentTr tr_${i}">
						</c:if>
						<c:set var="position" scope="session" value="${colors[(index - delta) % columnsPerRowMetric]}"/>
						<td class="metric content multiselection ${position}" onClick="multiselect(event, this); setOptionValue(event, this, 13101);" target="${metric.name()}">
							<div class="col_label">
								<div class="col_label_content">
									<p class="name">${metric.getName()}</p>
									<c:if test="${requestScope[hasMetricParametersListParameter].get(index - 1) == true}">
										<div class="config configButton" onClick="goToMetricConfig(event, this, 13102);"></div>
									</c:if>
									<div class="detail moreButton disabled" onClick="if(!$(this).hasClass('disabled')){goToMetricDetail(event, this, 13103);}"></div>
								</div>
							</div>
						</td>
						<c:choose>
							<c:when test="${index % columnsPerRowMetric == 0}">
								</tr>
							</c:when>
							<c:otherwise>
								<td class="void"></td>
							</c:otherwise>
						</c:choose>
					</c:forEach>
					<c:set var="rest" scope="session" value="${fn:length(requestScope[metricsParameter]) % columnsPerRowMetric}"/>
					<c:if test="${rest != 0}">
						<c:forEach begin="1" end="${columnsPerRowMetric - rest}" varStatus="loop">
							<td class="void"></td>
							<c:choose>
								<c:when test="${loop.index == (columnsPerRowMetric - rest)}">
									</tr>
								</c:when>
								<c:otherwise>
									<td class="void"></td>
								</c:otherwise>
							</c:choose>
						</c:forEach>
					</c:if>
					<tr class="void">
						<td class="void"></td>
						<td class="void"></td>
						<td class="void"></td>
						<td class="void"></td>
						<td class="void"></td>
					</tr>
				</tbody>
			</table>
		</div>
		<c:if test="${fn:length(requestScope[metricsParameter]) > rowsPerPageMetric * columnsPerRowMetric}">
			<div class="moveMetric moveRows">
				<div class="up upContent2 disable" onClick="upContent(event, this, ${rowsPerPageMetric}, true, 13104);"></div>
				<div class="up upContent disable" onClick="upContent(event, this, ${rowsPerPageMetric}, false, 13105);"></div>
				<div class="down downContent" onClick="downContent(event, this, ${rowsPerPageMetric}, false, 13106);"></div>
				<div class="down downContent2" onClick="downContent(event, this, ${rowsPerPageMetric}, true, 13107);"></div>
			</div>
		</c:if>
	</div>
</div>