<%@ include file="init.jsp"%>

<c:set var="block" scope="session" value=""/>
<c:if test="${not empty requestScope[benchmarkIdParameter]}">
	<c:set var="block" scope="session" value="disabled"/>
</c:if>

<c:set var="name" value="${requestScope[systemNameParameter]}"/>
<c:set var="date" value="${requestScope[systemDateParameter]}"/>
<c:set var="property" value="${requestScope[systemPropertyParameter]}"/>

<c:if test="${!requestScope[systemNameParameter]}">
	<c:set var="name" value="false"/>
</c:if>
<c:if test="${!requestScope[systemDateParameter]}">
	<c:set var="date" value="false"/>
</c:if>

<div class="section background_white evaluation" data-anchor="output" title="Output" style="display: none;">
	<div class="frameSection">
		<div class="frameGeneric title_space">
			<h1 class="title">${system_list_title}</h1>
			<input id="selected_measure_list" type="hidden" name="<portlet:namespace/>${systemSelectedMeasureListParameter}" class="dataEvaluate dynamicValue" checked="checked" value="${requestScope[systemSelectedMeasureListParameter]}"/>
			<div id="pop">
		    	<div id="popFrame">
		    		<p class="title">Attention</p>
		    		<p class="warning">The output $0 will be definitely removed from the EvAll. Are you sure that you want to proceed?</p>
		    		<input type="button" class="action" onclick="$(this).closest('#pop').fadeOut('slow'); deleteFile_(event, this, 52006);" value="Yes" />
				   	<input type="button" onclick="$(this).closest('#pop').fadeOut('slow');" value="No" />
			   </div>
			</div>
			<div class="slide fp-auto-height" data-anchor="output_list">
				<div class="list frameSlide" id="listDiv">
					<table id="best-files" class="fileTable">
				        <tr class="head">
				        	<th class="leftUploadHeader"></th>
				            <th class="name">
				            	${system_field_name}
				            	<div class="sort" onclick="goToSystems_(event, this, 52004);" ${systemPropertyParameter}="${systemNameParameter}" ${systemOrderParameter}="${name}"></div>
				            </th>
				            <th class="voidTh"></th>
				            <th class="title">
				            	${system_field_title}
				            </th>
				            <th class="voidTh"></th>
				            <th class="author">
				            	${system_field_author}
				            </th>
				            <th class="voidTh"></th>
				            <c:set var="selected" value="${1}"/>
		            		<c:forEach var="measure" items="${requestScope[systemMeasureListParameter]}" varStatus="loop">
				            	<th class="measure ${measure.getId()}<c:if test="${!measure.isSelected()}"> hidden</c:if>">
				            		<c:if test="${measure.isSelected()}">
										<c:set var="selected" value="${selected + 1}"/>
									</c:if>
				            		<c:set var="order" value="false"/>
						            <c:if test="${requestScope[systemPropertyParameter] eq measure.getId()}">
										<c:set var="order" value="${requestScope[property]}"/>
									</c:if>
						            ${measure.getAbbreviation()}<c:if test="${measure.isOfficial()}"> (Official)</c:if>
					            	<div class="sort" onclick="goToSystems_(event, this, 52006);" ${systemPropertyParameter}="${measure.getId()}" ${systemOrderParameter}="${order}"></div>
					            </th>
					            <th class="voidTh ${measure.getId()}<c:if test="${!measure.isSelected()}"> hidden</c:if>"></th>
				            </c:forEach>
				            <th class="date">
				            	${system_publication_date}
				            	<div class="sort" onclick="goToSystems_(event, this, 52008);" ${systemPropertyParameter}="${systemDateParameter}" ${systemOrderParameter}="${date}"></div>
				            </th>
				            <th class="voidTh"></th>
				            <c:set var="selected2" value="${selected}"/>
				            <c:forEach begin="1" end="${systemNumberMeasures}" varStatus="loop">
								<th class="measure voidMeasure<c:if test="${selected2 > systemNumberMeasures}"> hidden</c:if>"></th>
					            <th class="voidTh<c:if test="${selected2 > systemNumberMeasures}"> hidden</c:if>"></th>
					            <c:set var="selected2" value="${selected2 + 1}"/>
							</c:forEach>
							<th class="voidTh"></th>
							<th class="delete"></th>
				            <th class="rightUploadHeader"></th>
				        </tr>
				        <c:forEach var="result" items="${requestScope[systemResultsParameter]}" varStatus="loop">
							<tr class="fileTr <c:if test="${loop.index % 2 == 0}">odd</c:if>" onclick="goToSystemDetail(event, $(this), 52001);" target="${result.getId()}">
								<c:set var="areThereAuthors" value="false"/>
								<c:set var="moreAuthors" value="false"/>
								<c:if test="${fn:length(result.getAuthors()) > 0}">
									<c:set var="areThereAuthors" value="true"/>
								</c:if>
								<c:if test="${fn:length(result.getAuthors()) > 1}">
									<c:set var="moreAuthors" value="true"/>
								</c:if>
								<td class="voidTd"></td>
				               	<td class="name" onmouseover="showPopupDiv(event, this);" onmouseout="hidePopupDiv(event, this);">
				               		<c:choose>
				               			<c:when test="${result.getName().length() < 15}"><span class="fileName">${result.getName()}</span></c:when>
				               			<c:otherwise><span class="fileName">${result.getName().substring(0, 15)}...</span><div onclick="event.stopPropagation(); event.preventDefault();" class="popupDiv">${result.getName()}</div></c:otherwise>
				            		</c:choose>
				               	</td>
				               	<td class="voidTd"></td>
				               	<td class="title" onmouseover="showPopupDiv(event, this);" onmouseout="hidePopupDiv(event, this);">
				               		<c:choose>
				               			<c:when test="${result.getTitle() == null || result.getTitle().length() == 0}"><span class="fileName">-</span></c:when>
				               			<c:when test="${result.getTitle().length() < 15}"><span class="fileName">${result.getTitle()}</span></c:when>
				               			<c:otherwise><span class="fileName">${result.getTitle().substring(0, 15)}...</span><div onclick="event.stopPropagation(); event.preventDefault();" class="popupDiv">${result.getTitle()}</div></c:otherwise>
				            		</c:choose>
				               	</td>
				               	<td class="voidTd"></td>
				               	<td class="author" onmouseover="showPopupDiv(event, this);" onmouseout="hidePopupDiv(event, this);">
				               		<c:if test="${areThereAuthors}">${result.getAuthors().get(0)}<c:if test="${moreAuthors}"></c:if>...
				               			<div onclick="event.stopPropagation(); event.preventDefault();" class="popupDiv"><c:forEach var="author" items="${result.getAuthors()}" varStatus="loop2">${author}<c:if test="${loop2.index + 1 < fn:length(result.getAuthors())}">, </c:if></c:forEach></div>
				               		</c:if>
				               	</td>
				               	<td class="voidTd"></td>
				               	<c:forEach var="measure" items="${requestScope[systemMeasureListParameter]}" varStatus="loop">
				               		<td class="measure ${measure.getId()}<c:if test="${!measure.isSelected()}"> hidden</c:if><c:if test="${result.getMeasures().containsKey(measure.getId()) && result.getMeasures().get(measure.getId()) == measure.getValue()}"> bold</c:if>"><c:choose><c:when test="${!result.getMeasures().containsKey(measure.getId()) || result.getMeasures().get(measure.getId()) == '-1'}">-</c:when><c:otherwise>${result.getMeasures().get(measure.getId())}</c:otherwise></c:choose></td>
				               		<td class="voidTd ${measure.getId()}<c:if test="${!measure.isSelected()}"> hidden</c:if>"></td>
				               	</c:forEach>
				               	<td class="date">${result.getYear()}</td>
				               	<td class="voidTd"></td>
				               	<c:set var="selected2" value="${selected}"/>
				               	<c:forEach begin="1" end="${systemNumberMeasures}" varStatus="loop">
									<td class="measure voidMeasure<c:if test="${selected2 > systemNumberMeasures}"> hidden</c:if>"></td>
						            <td class="voidTd<c:if test="${selected2 > systemNumberMeasures}"> hidden</c:if>"></td>
									<c:set var="selected2" value="${selected2 + 1}"/>
								</c:forEach>
				               	<td class="voidTd"></td>
				               	<%if(((OutputBean)pageContext.getAttribute("result")).isUser(Long.valueOf(themeDisplay.getUser().getUserId()))) {

				               		%>
				               		<portlet:resourceURL var="DeleteServiceURL" id="${deleteFileResource}">
										<portlet:param name="${outputIdParameter}" value="${result.getId()}" />
									</portlet:resourceURL>
				               		<td class="delete">
			                    		<a href="javascript:void(0)" class="file_${result.getId()}" onclick="showSavePopup(event, this, 52019);" name="${result.getName()}" idOutput="${result.getId()}" target="${DeleteServiceURL}"></a>
			                    	</td>
				               		<%

				               	} else {

				               		%><td class="voidTd"></td><%
				               	}
				               	%>
				               	<td class="voidTd"></td>
				        	</tr>
						</c:forEach>
						<c:forEach begin="1" end="${systemNumberPerPage - fn:length(requestScope[systemResultsParameter])}" varStatus="loop">
							<tr class="voidTr">
								<td class="voidTd"></td>
				               	<td class="voidTd"></td>
				               	<td class="voidTd"></td>
				               	<td class="voidTd"></td>
				               	<td class="voidTd"></td>
				               	<td class="voidTd"></td>
				               	<td class="voidTd"></td>
				               	<td class="voidTd"></td>
				               	<td class="voidTd"></td>
				               	<td class="voidTd"></td>
				               	<c:forEach begin="1" end="${systemNumberMeasures}" varStatus="loop">
									<td class="voidTd"></td>
				               		<td class="voidTd"></td>
								</c:forEach>
								<td class="voidTd"></td>
								<td class="voidTd"></td>
				        	</tr>
						</c:forEach>
						<tr class="paginationRow">
							<td colspan="${systemNumberMeasures * 2 + 12}">
							<fmt:parseNumber var="currentPage" integerOnly="true" type="number" value="${(requestScope[systemBeginPaginationParameter] / systemNumberPerPage) - ((requestScope[systemBeginPaginationParameter] / systemNumberPerPage) % 1)}" />
							<a id="selfPagination" class="paginationLink hidden" href="javascript:void(0)" onclick="goToSystems_(event, this, 52005);" ${systemPaginationParameter}="${currentPage}" <c:if test="${!empty requestScope[systemPropertyParameter]}">${systemPropertyParameter}="${requestScope[systemPropertyParameter]}" ${systemOrderParameter}="${requestScope[systemOrderPaginationParameter]}"</c:if>></a>
							<c:if test="${requestScope[systemResultNumberParameter] > systemNumberPerPage}">
								<div class="paginationDiv">
									<c:set var="init" value="${currentPage - 2}"/>
									<fmt:parseNumber var="numberPagination" integerOnly="true" type="number" value="${(requestScope[systemResultNumberParameter] / systemNumberPerPage) + (1 - ((requestScope[systemResultNumberParameter] / systemNumberPerPage) % 1)) % 1}" />
									<c:if test="${init < 0}">
										<c:set var="init" value="0"/>
									</c:if>
									<c:if test="${numberPagination > 4 && init > numberPagination - 5}">
										<c:set var="init" value="${numberPagination - 5}"/>
									</c:if>
									<div class="pages">
										<c:if test="${init > 0}">
											<a class="paginationLink" href="javascript:void(0)" onclick="goToSystems_(event, this, 52002);" ${systemPaginationParameter}="${init - 1}" ${systemPropertyParameter}="${requestScope[systemPropertyParameter]}" ${systemOrderParameter}="${requestScope[systemOrderPaginationParameter]}">${system_pagination_arrow_left}</a>
										</c:if>
										<c:forEach begin="${init}" end="${init + 4}" varStatus="loopPagination">
											<c:if test="${loopPagination.index + 1 < numberPagination + 1}">
												<c:choose>
							               			<c:when test="${currentPage eq loopPagination.index}">
														<a class="paginationLink disabled" href="#" ${systemPaginationParameter}="${loopPagination.index}" <c:if test="${!empty requestScope[systemPropertyParameter]}">${systemPropertyParameter}="${requestScope[systemPropertyParameter]}" ${systemOrderParameter}="${requestScope[systemOrderPaginationParameter]}"</c:if>>${loopPagination.index + 1}</a>
													</c:when>
							               			<c:otherwise>
							               				<a class="paginationLink" href="javascript:void(0)" onclick="goToSystems_(event, this, 52003);" ${systemPaginationParameter}="${loopPagination.index}" <c:if test="${!empty requestScope[systemPropertyParameter]}">${systemPropertyParameter}="${requestScope[systemPropertyParameter]}" ${systemOrderParameter}="${requestScope[systemOrderPaginationParameter]}"</c:if>>${loopPagination.index + 1}</a>
													</c:otherwise>
							            		</c:choose>
											</c:if>
										</c:forEach>
										<c:if test="${init + 6 < numberPagination + 1}">
											<a class="paginationLink" href="javascript:void(0)" onclick="goToSystems_(event, this, 52004);" ${systemPaginationParameter}="${init + 5}" ${systemPropertyParameter}="${requestScope[systemPropertyParameter]}" ${systemOrderParameter}="${requestScope[systemOrderPaginationParameter]}">${system_pagination_arrow_right}</a>
										</c:if>
									</div>
									<span>${currentPage + 1} de ${numberPagination}</span>
								</div>
							</c:if>
							</td>
						</tr>
				    </table>

					<c:if test="${not empty requestScope[benchmarkIdParameter]}">

						<portlet:resourceURL var="DownloadExcelServiceURL" id="${downloadExcelResource}">
							<portlet:param name="${benchmarkIdParameter}" value="${requestScope[benchmarkIdParameter]}" />
						</portlet:resourceURL>

						<a class="standardColor bold download excel_export" href="javascript:void(0)" onclick="openURL(event, this, false, 'benchmark', 'exportExcel', '${requestScope[benchmarkIdParameter]} | ${benchmark_list_title}', 52000);" target="${DownloadExcelServiceURL}">${excel_export}</a>

					</c:if>

					<h2 class="seclectMeasureTitle">${select_measures}</h2>
					<div class="systemMetricBarZone">
						<div class="systemMetricBar">
							<c:forEach var="measure" items="${requestScope[systemMeasureListParameter]}" varStatus="loop">
								<div class="measure<c:if test="${measure.isSelected()}"> selected</c:if>" target="${measure.getId()}" onclick="if(!$(this).hasClass('disabled')){selectMeasure(event, this, 52010);}"><span>${measure.getAbbreviation()}</span></div>
		            		</c:forEach>
						</div>
					</div>
			    </div>
			</div>
			<div class="slide fp-auto-height dynamic" data-anchor="description">
	   			<div class="detail frameSlide" id="descriptionDiv"></div>
	   		</div>
	   	</div>
	</div>
	<div class="section-block ${block}"></div>
</div>