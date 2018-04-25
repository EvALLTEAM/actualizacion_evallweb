<c:set var="colors" value="${fn:split(colorPerColumns, ',')}" scope="session" />
<c:set var="delta" value="${0}"/>

<c:set var="benchmarkValue" scope="session" value=""/>
<c:set var="arrowState" scope="session" value="disabled"/>
<c:if test="${not empty requestScope[benchmarkIdParameter]}">
	<c:set var="benchmarkValue" scope="session" value="value='${requestScope[benchmarkIdParameter]}'"/>
	<c:set var="arrowState" scope="session" value=""/>
</c:if>

<div class="section background_white evaluation" data-anchor="benchmark" title="Benchmark" style="display: none;">
	<div class="frameSection">
		<div class="frameGeneric title_space arrow_space">
			<h1 class="title">${benchmark_list_title}</h1>
			<input id="benchmarkInput" type="hidden" name="<portlet:namespace/>${benchmarkIdParameter}" class="dataEvaluate dynamicValue" checked="checked" ${benchmarkValue}/>
			<div class="slide fp-auto-height" data-anchor="benchmark_list">
				<div class="frameSlide">
					<div class="benchmarkSearchBarZone">
						<div class="benchmarkSearchBar">
							<div class="benchmark_clear_search" onclick="clearSearchBenchmark(event, this, 51009);">
								<span class="benchmark_clear_search_text">
									<span>${benchmark_clear_search}</span>
								</span>
								<div class="benchmark_clear_search_icon"></div>
							</div>
							<div class="voidSelect"></div>
							<select class="evallTasks" name="evallTasks">
								<option selected value="${benchmarkAllEvallTasks}">${benchmarkAllEvallTasks}</option>
								<c:forEach var="evallTask" items="${requestScope[benchmarkEvallTaskListParameter]}" varStatus="loop">
									<option value="${evallTask}">${evallTask}</option>
								</c:forEach>
							</select>
							<div class="voidSelect"></div>
							<select class="conference" name="conference">
								<option selected value="${benchmarkAllConferences}">${benchmarkAllConferences}</option>
								<c:forEach var="conference" items="${requestScope[benchmarkConferenceListParameter]}" varStatus="loop">
									<option value="${conference}">${conference}</option>
								</c:forEach>
							</select>
							<div class="voidSelect"></div>
							<select class="year" name="year">
								<option selected value="${benchmarkAllYears}">${benchmarkAllYears}</option>
								<c:forEach var="year" items="${requestScope[benchmarkYearListParameter]}" varStatus="loop">
									<option value="${year}">${year}</option>
								</c:forEach>
							</select>
							<div class="voidSelect"></div>
							<select class="workshop" name="workshop">
								<option selected value="${benchmarkAllWorkshops}">${benchmarkAllWorkshops}</option>
								<c:forEach var="workshop" items="${requestScope[benchmarkWorkshopListParameter]}" varStatus="loop">
									<option value="${workshop}">${workshop}</option>
								</c:forEach>
							</select>
							<div class="voidSelect"></div>
							<div class="benchmark_search">
								<input type="search" name="benchmarkSearch1" class="text_benchmark_search_1">
								<input type="hidden" name="benchmarkSearch2" class="text_benchmark_search_2">
								<input type="submit" class="button_benchmark_search" onclick="copyBenchmarkSearchText(this); searchBenchmark(event, this, $('#evall_benchmarks'), 51008);" value="">
							</div>
						</div>
					</div>
					<div class="benchmark_zone subzone">
						<div class="subarea" id="evall_benchmarks">
							<table class="table-main dark removeBorders">
								<tbody>
									<tr class="void thVoid">
										<th class=""></th>
										<c:forEach begin="2" end="${columnsPerRowBenchmark}" varStatus="loop">
											<th class="void"></th>
											<th class=""></th>
										</c:forEach>
									</tr>
									<c:forEach var="benchmark" items="${requestScope[benchmarksParameter]}" varStatus="loop">
										<c:set var="index" value="${loop.index + 1}"/>
										<c:set var="isSelected" scope="session" value=""/>
										<c:set var="currentId" scope="session" value="${benchmark.getId()}"/>
										<c:if test="${not empty requestScope[benchmarkIdParameter] && requestScope[benchmarkIdParameter] eq currentId}">
											<c:set var="isSelected" scope="session" value="selected"/>
										</c:if>
										<portlet:resourceURL var="iconUrl" id="${downloadIconBenchmarkResource}">
											<portlet:param name="${benchmarkIdParameter}" value="${benchmark.getId()}" />
										</portlet:resourceURL>
										<c:if test="${(index - 1) % columnsPerRowBenchmark == 0}">
											<fmt:parseNumber var="i" integerOnly="true" type="number" value="${(index / columnsPerRowBenchmark) + 1}" />
											<c:if test="${index != 1}">
												<c:set var="delta" value="${delta + 1}"/>
												<tr class="void">
													<c:forEach begin="1" end="${columnsPerRowBenchmark * 2 - 1}" varStatus="loop">
														<td class="void"></td>
													</c:forEach>
												</tr>
											</c:if>
											<tr class="visible contentTr tr_${i}">
										</c:if>
										<c:set var="position" scope="session" value="${colors[(index - delta) % columnsPerRowBenchmark]}"/>
										<td class="benchmark content selection ${position} ${isSelected}" onClick="if(!$(this).hasClass('selected')){select(event, this); setBenchmark(event, this, 51001);}" target="${benchmark.getId()}">
											<div class="col_label">
												<div class="col_label_content">
													<p class="conference">${benchmark.getConference()} ${benchmark.getYearDate()}</p>
													<c:choose>
														<c:when test="${benchmark.getWorkshop().length() > 36}">
															<div onmouseover="showPopupDiv(event, this);" onmouseout="hidePopupDiv(event, this);">
																<p class="workshop">${benchmark.getWorkshop().substring(0, 35)}...</p>
																<div onclick="event.stopPropagation(); event.preventDefault();" class="popupDiv"><p>${benchmark.getWorkshop()}</p></div>
															</div>
														</c:when>
														<c:otherwise>
															<p class="workshop">${benchmark.getWorkshop()}</p>
														</c:otherwise>
													</c:choose>
													<p class="name">${benchmark.getName()}</p>
													<img src="${iconUrl}" />
													<div class="detail moreButton" onClick="goToDescription(event, this, 51002);"></div>
												</div>
											</div>
										</td>
										<c:choose>
											<c:when test="${index % columnsPerRowBenchmark == 0}">
												</tr>
											</c:when>
											<c:otherwise>
												<td class="void"></td>
											</c:otherwise>
										</c:choose>
									</c:forEach>
									<c:set var="rest" scope="session" value="${fn:length(requestScope[benchmarksParameter]) % columnsPerRowBenchmark}"/>
									<c:if test="${rest != 0}">
										<c:forEach begin="1" end="${columnsPerRowBenchmark - rest}" varStatus="loop">
											<td class="void"></td>
											<c:choose>
												<c:when test="${loop.index == (columnsPerRowBenchmark - rest)}">
													</tr>
												</c:when>
												<c:otherwise>
													<td class="void"></td>
												</c:otherwise>
											</c:choose>
										</c:forEach>
									</c:if>
									<tr class="void">
										<c:forEach begin="1" end="${columnsPerRowBenchmark * 2 - 1}" varStatus="loop">
											<td class="void"></td>
										</c:forEach>
									</tr>
								</tbody>
							</table>
						</div>
						<c:if test="${fn:length(requestScope[benchmarksParameter]) > rowsPerPageBenchmark * columnsPerRowBenchmark}">
							<div class="moveBenchmarkView moveRows">
								<div class="up upContent2 disable" onClick="upContent(event, this, ${rowsPerPageBenchmark}, true, 51003);"></div>
								<div class="up upContent disable" onClick="upContent(event, this, ${rowsPerPageBenchmark}, false, 51004);"></div>
								<div class="down downContent" onClick="downContent(event, this, ${rowsPerPageBenchmark}, false, 51005);"></div>
								<div class="down downContent2" onClick="downContent(event, this, ${rowsPerPageBenchmark}, true, 51006);"></div>
							</div>
						</c:if>
					</div>
		   		</div>
	   		</div>
	   		<div class="slide fp-auto-height dynamic" data-anchor="description">
	   			<div class="description frameSlide" id="descriptionDiv"></div>
	   		</div>
	   		<div class="arrow ${arrowState}">
				<div class="blockArrow"></div>
		   		<div class="frameArrow">
					<a class="moveSectionDown" href="javascript:void(0)" onclick="moveSectionDown(event, 51000);">
						<div class="arrow_section"></div>
						<p class="titleNextSection">${next_step}</p>
					</a>
				</div>
			</div>
		</div>
	</div>
</div>