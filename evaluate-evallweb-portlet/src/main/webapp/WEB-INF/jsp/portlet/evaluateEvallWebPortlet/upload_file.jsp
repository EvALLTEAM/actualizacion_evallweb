<c:set var="block" scope="session" value=""/>
<c:set var="arrowState2" scope="session" value="disabled2"/>
<c:if test="${not empty requestScope[benchmarkIdParameter] && not empty requestScope[evaluationOptionParameter] && not empty requestScope[metricOptionParameter] && not empty requestScope[baselineOptionParameter]}">
	<c:set var="block" scope="session" value="disabled"/>
	<c:set var="arrowState2" scope="session" value=""/>
</c:if>

<portlet:resourceURL var="UploadServiceURL" id="${uploadFileResource}">
	<portlet:param name="${fileTypeParameter}" value="${outputType}" />
</portlet:resourceURL>
<portlet:actionURL name="${evaluateAction}" var="evaluateURL" />

<div class="section dark background_blue evaluation" data-anchor="upload_output" title="Upload" style="display: none;">
	<div class="frameSection">
		<div class="frameGeneric title_space arrow_space">
			<h1 class="title">${upload_title}</h1>
			<div class="frameSlide">
			    <table id="uploaded-files" class="fileTable">
			        <tr class="head">
			        	<th class="leftUploadHeader"></th>
			            <th class="name">
			            	${upload_field_name}
			            	<div class="sort" onclick="getFileOrder(event, this, 16004);" ${systemOrderParameter}="true"></div>
			            </th>
			            <th></th>
			            <th class="size">
			            	${upload_field_size}
			            	<div class="sort" onclick="getFileOrder(event, this, 16005);" ${systemOrderParameter}="true"></div>
			            </th>
			            <th></th>
			            <th class="progressBar">${upload_field_progress}</th>
			            <th class="download"></th>
			            <portlet:resourceURL var="DeleteAllServiceURL" id="${deleteAllFileResource}">
			            	<portlet:param name="${fileTypeParameter}" value="${outputType}" />
			            </portlet:resourceURL>
			            <th class="delete">
			            	<a class="<c:if test="${fn:length(requestScope[uploadFilesParameter]) == 0}">hidden</c:if>" href="javascript:void(0)" onclick="deleteAllFiles(event, this, checkEvaluateButton, 16006);" target="${DeleteAllServiceURL}"></a>
			            </th>
			            <th class="rightUploadHeader"></th>
			        </tr>
			        <c:forEach var="file" items="${requestScope[uploadFilesParameter]}" varStatus="loop">
						<tr class="fileTr valid<c:if test="${loop.index % 2 == 0}"> odd</c:if><c:if test="${loop.index >= fileNumberPerPage}"> hidden</c:if>" ${systemOrderParameter}="${loop.index}" target="${file.fileId}">
							<portlet:resourceURL var="DownloadServiceURL" id="${downloadFileResource}">
								<portlet:param name="${fileTypeParameter}" value="${outputType}" />
								<portlet:param name="${fileIdParameter}" value="${file.fileId}" />
							</portlet:resourceURL>
							<portlet:resourceURL var="DeleteServiceURL" id="${deleteFileResource}">
								<portlet:param name="${fileTypeParameter}" value="${outputType}" />
								<portlet:param name="${fileIdParameter}" value="${file.fileId}" />
							</portlet:resourceURL>
							<portlet:resourceURL var="RenameServiceURL" id="${renameFileResource}">
								<portlet:param name="${fileTypeParameter}" value="${outputType}" />
								<portlet:param name="${fileIdParameter}" value="${file.fileId}" />
							</portlet:resourceURL>
							<td class="voidTd"></td>
	                    	<td class="name">
	                    		<span class="fileName">${file.fileName}</span>
	                    		<div class="editNameIcon" onclick="accessToRenameFile(event, this, ${file.fileId}, OUTPUT_TYPE, '${file.fileId} | ${file.fileName} | ${file.fileSize}', 16007);"></div>
	                    	</td>
	                    	<td class="voidTd"></td>
	                    	<td class="size">${file.fileSize}</td>
	                    	<td class="voidTd"></td>
	                    	<td class="progressBar">
	                    		<div class="containerBar">
	                    			<div class="bar" style="width: 100%;">
	                    				<span class="percentage">100%</span>
	                    				<div class="infoIcon hidden" onclick="togglePopupDiv(event, this);"></div>
	                    				<div class="percentageBar"></div>
	                    			</div>
	                    		</div>
	                    		<div onclick="event.stopPropagation(); event.preventDefault();" class="popupDiv">
	                    			<a class="copyClipboardIcon" href="javascript:void(0)" onclick="copyToClipboard(event, $(this).closest('.popupDiv').find('.popupDivFrame').text(), 16015);"></a>
	                    			<div class="popupDivFrame"></div>
	                    		</div>
	                    	</td>
	                    	<td class="download">
	                    		<a href="javascript:void(0)" onclick="openURL(event, this, false, OUTPUT_TYPE, 'download', '${file.fileId} | ${file.fileName} | ${file.fileSize}', 16010);" target="${DownloadServiceURL}"></a>
	                    	</td>
	                    	<td class="delete">
	                    		<a href="javascript:void(0)" class="file_${file.fileId}" onclick="deleteFile(event, this, 'checkEvaluateButton', OUTPUT_TYPE, '${file.fileId} | ${file.fileName} | ${file.fileSize}', 16011);" target="${DeleteServiceURL}"></a>
	                    	</td>
	                    	<td class="voidTd"></td>
	                    </tr>
					</c:forEach>
					<c:forEach begin="1" end="${fileNumberPerPage}" varStatus="loop">
						<tr class="voidTr<c:if test="${loop.index > fileNumberPerPage - fn:length(requestScope[uploadFilesParameter])}"> hidden</c:if>">
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
						<td colspan="10">
							<div class="paginationDiv hidden firstTime">
								<div class="pages">
									<a class="paginationLink left disabled hidden" href="javascript:void(0)" onclick="showNFiles(event, this, 16011);">${system_pagination_arrow_left}</a>
									<a class="paginationLink disabled" href="javascript:void(0)" onclick="showNFiles(event, this, 16012);">1</a>
									<a class="paginationLink" href="javascript:void(0)" onclick="showNFiles(event, this, 16013);" target="2">2</a>
									<a class="paginationLink hidden" href="javascript:void(0)" onclick="showNFiles(event, this, 16014);" target="3">3</a>
									<a class="paginationLink right disabled hidden" href="javascript:void(0)" onclick="showNFiles(event, this, 16015);">${system_pagination_arrow_right}</a>
								</div>
								<span>1 de 2</span>
							</div>
						</td>
					</tr>
			    </table>
			    <div class="dropzone" id="dropzone_files">
					<div class="dragAndDropZone">
						<div class="buttonForm">
							<h1 class="dragAndDropTitle">${upload_drag_drop}</h1>
							<input class="applyButton" name="${fileParameter}" id="fileupload" type="file" data-url="${UploadServiceURL}" multiple/>
							<div class="upload_zone">
								<div class="divUpload">
									<span></span>
									<label class="applyButtonLabel" id="fileuploadLabel" for="fileupload">${upload_browse}</label>
									<span>
										<p>${upload_browse_or_load}</p>
									</span>
									<label class="applyButtonLabel" id="exampleFileLoadLabel" onclick="if(!$(this).hasClass('disabled')){examplefileload(event, this, OUTPUT_TYPE, 16016);}">${upload_load_example}</label>
									<span></span>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		    <div class="arrow ${arrowState2}">
				<div class="blockArrow"></div>
		   		<div class="frameArrow">
					<a class="moveSectionDown" href="javascript:void(0)" onclick="evaluateSystem(event, this, 16000);" target="${evaluateURL}">
						<div class="arrow_section"></div>
						<p class="titleNextSection">${upload_evaluate}</p>
					</a>
				</div>
			</div>
		</div>
	</div>
	<div class="section-block ${block}"></div>
</div>