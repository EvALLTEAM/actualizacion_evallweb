<%@ include file="init.jsp"%>

<div class="frameSlide detail" id="metric_detail">
	<div class="back backFromMetricDetail">
		<a href="javascript:void(0)" class="title blackLink" id="titleMetric" onClick="backSlide(event, 13300);">${back}</a>
	</div>
	<div class="detail_zone subzone">
		<div class="evall_image">
			<p>${requestScope[metricNameParameter]}</p>
	 	</div>
	 	<div class="evall_description">
	 		<p>${requestScope[metricDescriptionParameter]}</p>
	 	</div>
 	</div>
</div>