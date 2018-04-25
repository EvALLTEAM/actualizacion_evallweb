<%@ include file="init.jsp"%>

<div class="frameSlide list" id="outputs_to_save">

	<table id="outputs-to-save" class="fileTable">
        <tr>
        	<th class="leftUploadHeader"></th>
            <th class="name">
            	${upload_field_name}
            	<div class="sort" onclick="getFileOrder(event, this, 18007);" order="true"></div>
            </th>
            <th></th>
            <th class="size">
            	${upload_field_size}
            	<div class="sort" onclick="getFileOrder(event, this, 18008);" order="true"></div>
            </th>
            <th></th>
            <th class="download"></th>
            <th class="rightUploadHeader"></th>
        </tr>
        <c:choose>
			<c:when test="${!themeDisplay.isSignedIn() || empty requestScope[outputIsSavedParameter]}">
				<c:forEach begin="1" end="5" varStatus="loop">
					<tr class="fileTr valid <c:if test="${loop.index % 2 == 0}">odd</c:if>">
						<td class="voidTd"></td>
						<td class="name"><hr class="line"></hr></td>
						<td class="voidTd"></td>
						<td class="size"><hr class="line"></hr></td>
						<td class="voidTd"></td>
						<td class="download">
							<a href="#"></a>
						</td>
						<td class="voidTd"></td>
					</tr>
				</c:forEach>
				<c:forEach begin="1" end="${outputNumberPerPage - 5}" varStatus="loop">
					<tr class="voidTr">
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
					<td colspan="15"></td>
				</tr>
			</c:when>
			<c:otherwise>
		        <c:forEach var="file" items="${requestScope[uploadFilesParameter]}" varStatus="loop">
		        	<portlet:resourceURL var="DownloadServiceURL" id="${downloadOutputBbddResource}">
						<portlet:param name="${outputIdParameter}" value="${file.fileId}" />
					</portlet:resourceURL>
					<tr class="fileTr valid<c:if test="${loop.index % 2 == 0}"> odd</c:if><c:if test="${loop.index + 1 > outputNumberPerPage}"> hidden</c:if><c:if test="${requestScope[uploadFilesValidationNameParameter].get(file.fileId)}"> disabled</c:if>" <c:if test="${not requestScope[uploadFilesValidationNameParameter].get(file.fileId)}">onclick="goToOutputDetail(event, this, 18000);"</c:if> target="${file.fileId}">
						<td class="voidTd"></td>
	                  	<td class="name">
	                   		<span class="fileName">${file.fileName}</span>
	                   		<div class="editNameIcon" onclick="var td = $(this).closest('td'); accessToRenameFile(event, this, ${file.fileId}, OUTPUT_TYPE, '${file.fileId} | ${file.fileName}', 18002); var edit = td.find('.editNameAcceptIcon'); edit.attr('onclick', edit.attr('onclick') + ' checkExistFileName(event, this, ${file.fileId}, OUTPUT_TYPE, \'${file.fileId} | ${file.fileName}\', 18003);');"></div>
	                  	</td>
	                  	<td class="voidTd"></td>
	                  	<td class="size">${file.fileSize}</td>
	                  	<td class="voidTd"></td>
	                  	<td class="download">
	                  		<a href="javascript:void(0)" onclick="openURL(event, this, false, OUTPUT_TYPE, 'download', '${file.fileId} | ${file.fileName}', 18001);" target="${DownloadServiceURL}"></a>
	                  	</td>
	                  	<td class="voidTd"></td>
	            	</tr>
				</c:forEach>
				<c:if test="${fn:length(requestScope[uploadFilesParameter]) % outputNumberPerPage > 0}">
					<c:forEach begin="1" end="${outputNumberPerPage - fn:length(requestScope[uploadFilesParameter]) % outputNumberPerPage}" varStatus="loop">
						<tr class="voidTr<c:if test="${fn:length(requestScope[uploadFilesParameter]) > outputNumberPerPage}"> hidden</c:if>">
							<td class="voidTd"></td>
							<td class="voidTd"></td>
							<td class="voidTd"></td>
							<td class="voidTd"></td>
							<td class="voidTd"></td>
							<td class="voidTd"></td>
							<td class="voidTd"></td>
						</tr>
					</c:forEach>
				</c:if>
				<tr class="paginationRow">
					<td colspan="15">
						<c:if test="${fn:length(requestScope[uploadFilesParameter]) > outputNumberPerPage}">
							<div class="paginationDiv">
								<c:set var="init" value="${0}"/>
								<fmt:parseNumber var="numberPagination" integerOnly="true" type="number" value="${(fn:length(requestScope[uploadFilesParameter]) / outputNumberPerPage) + (1 - ((fn:length(requestScope[uploadFilesParameter]) / outputNumberPerPage) % 1)) % 1}" />
								<c:if test="${numberPagination > 4 && init > numberPagination - 5}">
									<c:set var="init" value="${numberPagination - 5}"/>
								</c:if>
								<div class="pages">
									<c:forEach begin="${init}" end="${init + 4}" varStatus="loopPagination">
										<c:if test="${loopPagination.index + 1 < numberPagination + 1}">
											<c:set var="disabled" value=""/>
											<c:if test="${0 eq loopPagination.index}">
												<c:set var="disabled" value="disabled"/>
											</c:if>
						               		<a class="paginationLink ${disabled}" href="javascript:void(0)" onclick="goToSaveOutput_(event, this, 18005);" target="${loopPagination.index + 1}">${loopPagination.index + 1}</a>
										</c:if>
									</c:forEach>
									<c:if test="${init + 6 < numberPagination + 1}">
										<a class="paginationLink" href="javascript:void(0)" onclick="goToSaveOutput_(event, this, 18006);" target="${init + 5}">${system_pagination_arrow_right}</a>
									</c:if>
								</div>
								<span>1 de ${numberPagination}</span>
							</div>
						</c:if>
					</td>
				</tr>
			</c:otherwise>
		</c:choose>
    </table>
</div>