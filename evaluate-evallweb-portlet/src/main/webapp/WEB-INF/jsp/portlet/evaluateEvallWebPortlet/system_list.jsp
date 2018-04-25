<%@ include file="init.jsp"%>

<c:set var="name" value="${requestScope[systemNameParameter]}"/>
<c:set var="value" value="${requestScope[systemValueParameter]}"/>
<c:set var="date" value="${requestScope[systemDateParameter]}"/>

<c:if test="${!requestScope[systemNameParameter]}">
	<c:set var="name" value="false"/>
</c:if>
<c:if test="${!requestScope[systemValueParameter]}">
	<c:set var="value" value="false"/>
</c:if>
<c:if test="${!requestScope[systemDateParameter]}">
	<c:set var="date" value="false"/>
</c:if>

<div class="frameSlide list" id="systemsTable">
	<div class="back">
		<a href="javascript:void(0)" class="title blackLink" id="titleBaseline" onClick="backSlide(event, 14100);">${back}</a>
	</div>
	<table id="best-files" class="fileTable">
        <tr class="head">
        	<th class="leftUploadHeader"></th>
            <th class="name">
            	${system_field_name}
            	<div class="sort" onclick="goToSystems_(event, this, 14107);" ${systemPropertyParameter}="${systemNameParameter}" ${systemOrderParameter}="${name}"></div>
            </th>
            <th></th>
            <th class="title">
            	${system_field_title}
            </th>
            <th></th>
            <th class="description">
            	${system_field_description}
            </th>
            <th></th>
            <th class="author">
            	${system_field_author}
            </th>
            <th></th>
            <th class="measure">
            	${requestScope[systemMeasureParameter]}
            	<div class="sort" onclick="goToSystems_(event, this, 14108);" ${systemPropertyParameter}="${systemValueParameter}" ${systemOrderParameter}="${value}"></div>
            </th>
            <th></th>
            <th class="date">
            	${system_field_date}
            	<div class="sort" onclick="goToSystems_(event, this, 14109);" ${systemPropertyParameter}="${systemDateParameter}" ${systemOrderParameter}="${date}"></div>
            </th>
            <th class="download"></th>
            <th class="systemDetail"></th>
            <th class="rightUploadHeader"></th>
        </tr>
        <c:forEach var="result" items="${requestScope[systemResultsParameter]}" varStatus="loop">
			<tr class="fileTr <c:if test="${loop.index % 2 == 0}">odd</c:if>" onclick="if(!$(this).hasClass('selected')){selectFile(event, this, 14101); checkFileNames($('#uploaded-files'), true);}" target="${result.getId()}">
				<portlet:resourceURL var="DownloadServiceURL" id="${downloadOutputBbddResource}">
					<portlet:param name="${outputIdParameter}" value="${result.getOutputId()}" />
				</portlet:resourceURL>
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
               			<c:when test="${result.getName().length() < 20}"><span class="fileName">${result.getName()}</span></c:when>
               			<c:otherwise><span class="fileName">${result.getName().substring(0, 20)}...</span><div onclick="event.stopPropagation(); event.preventDefault();" class="popupDiv">${result.getName()}</div></c:otherwise>
            		</c:choose>
               	</td>
               	<td class="voidTd"></td>
               	<td class="title" onmouseover="showPopupDiv(event, this);" onmouseout="hidePopupDiv(event, this);">
               		<c:choose>
               			<c:when test="${result.getTitle() == null || result.getTitle().length() == 0}"><span class="fileName">-</span></c:when>
               			<c:when test="${result.getTitle().length() < 20}"><span class="fileName">${result.getTitle()}</span></c:when>
               			<c:otherwise><span class="fileName">${result.getTitle().substring(0, 20)}...</span><div onclick="event.stopPropagation(); event.preventDefault();" class="popupDiv">${result.getTitle()}</div></c:otherwise>
            		</c:choose>
               	</td>
               	<td class="voidTd"></td>
               	<td class="size" onmouseover="showPopupDiv(event, this);" onmouseout="hidePopupDiv(event, this);">
               		<c:choose>
               			<c:when test="${result.getDescription().length() < 20}">${result.getDescription()}</c:when>
               			<c:otherwise>${result.getDescription().substring(0, 20)}...<div onclick="event.stopPropagation(); event.preventDefault();" class="popupDiv">${result.getDescription()}</div></c:otherwise>
            		</c:choose>
               	</td>
               	<td class="voidTd"></td>
               	<td class="author" onmouseover="showPopupDiv(event, this);" onmouseout="hidePopupDiv(event, this);">
               		<c:if test="${areThereAuthors}">${result.getAuthors().get(0)}<c:if test="${moreAuthors}"></c:if>...
               			<div onclick="event.stopPropagation(); event.preventDefault();" class="popupDiv"><c:forEach var="author" items="${result.getAuthors()}" varStatus="loop2">${author}<c:if test="${loop2.index + 1 < fn:length(result.getAuthors())}">, </c:if></c:forEach></div>
               		</c:if>
               	</td>
               	<td class="voidTd"></td>
               	<td class="measure">${result.getValue()}</td>
               	<td class="voidTd"></td>
               	<td class="date">${result.getYearPublication()}</td>
               	<td class="download">
               		<a href="javascript:void(0)" onclick="openURL(event, this, false, OUTPUT_TYPE, 'download', '${result.getOutputId()} | ${result.getName()}', 14102);" target="${DownloadServiceURL}"></a>
               	</td>
               	<td class="systemDetail">
               		<div class="detail moreButton black" onClick="goToSystemDetail(event, this, 14103);"></div>
               	</td>
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
               	<td class="voidTd"></td>
             	<td class="voidTd"></td>
             	<td class="voidTd"></td>
				<td class="voidTd"></td>
              	<td class="voidTd"></td>
        	</tr>
		</c:forEach>
		<tr class="paginationRow">
			<td colspan="15">
			<c:if test="${requestScope[systemResultNumberParameter] > systemNumberPerPage}">
				<div class="paginationDiv">
					<fmt:parseNumber var="currentPage" integerOnly="true" type="number" value="${(requestScope[systemBeginPaginationParameter] / systemNumberPerPage) - ((requestScope[systemBeginPaginationParameter] / systemNumberPerPage) % 1)}" />
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
							<a class="paginationLink" href="javascript:void(0)" onclick="goToSystems_(event, this, 14104);" ${systemPaginationParameter}="${init - 1}">${system_pagination_arrow_left}</a>
						</c:if>
						<c:forEach begin="${init}" end="${init + 4}" varStatus="loopPagination">
							<c:if test="${loopPagination.index + 1 < numberPagination + 1}">
								<c:choose>
			               			<c:when test="${currentPage eq loopPagination.index}">
										<a class="paginationLink disabled" href="#">${loopPagination.index + 1}</a>
									</c:when>
			               			<c:otherwise>
			               				<a class="paginationLink" href="javascript:void(0)" onclick="goToSystems_(event, this, 14105);" ${systemPaginationParameter}="${loopPagination.index}" <c:if test="${!empty requestScope[systemPropertyParameter]}">property="${requestScope[systemPropertyParameter]}" order="${requestScope[property]}"</c:if>>${loopPagination.index + 1}</a>
									</c:otherwise>
			            		</c:choose>
							</c:if>
						</c:forEach>
						<c:if test="${init + 6 < numberPagination + 1}">
							<a class="paginationLink" href="javascript:void(0)" onclick="goToSystems_(event, this, 14106);" ${systemPaginationParameter}="${init + 5}">${system_pagination_arrow_right}</a>
						</c:if>
					</div>
					<span>${currentPage + 1} de ${numberPagination}</span>
				</div>
			</c:if>
			</td>
		</tr>
    </table>
</div>