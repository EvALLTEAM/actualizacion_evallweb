<%@ include file="init.jsp"%>

<portlet:resourceURL var="UploadServiceURL" id="${uploadBibtexResource}">
	<portlet:param name="${outputIdParameter}" value="${requestScope[uploadFileParameter].getFileId()}" />
</portlet:resourceURL>

<c:set var="authorInput" value=""/>
<c:forEach var="author" items="${requestScope[outputAuthorsParameter]}" varStatus="loop">
	<c:set var="authorInput" value="${authorInput}${author.getSurname()},${author.getName()};"/>
</c:forEach>

<div class="frameSlide detail lastSection" id="output_detail">
	<div class="back">
		<a href="javascript:void(0)" class="title blackLink" id="titleSaveOutput" onClick="backSlide(event, 18100);">${back}</a>
	</div>
	<div class="outputDetails_zone subzone">
		<input id="authorListInput" type="hidden" name="<portlet:namespace/>${outputAuthorsParameter}" class="dataAuthor dynamicValue" checked="checked" value="${authorInput}" />
		<div id="pop">
	    	<div id="popFrame">
	    		<p class="title">Attention</p>
	    		<p class="warning">All results will be saved with a default configuration. Are you sure that you want to proceed?</p>
	    		<input type="button" class="action" onclick="$(this).closest('#pop').fadeOut('slow'); saveOutputDetail(event, this, 18020);" value="Yes" />
			   	<input type="button" onclick="$(this).closest('#pop').fadeOut('slow');" value="No" />
		   </div>
		</div>
		<table class="table_outputDetails" target='${requestScope[uploadFileParameter].getFileId()}'>
			<tr>
				<th class="outputDetails"></th>
				<th class="outputAuthorsInput"></th>
				<th class="outputAuthorsViewer"></th>
			</tr>
			<tr class="outputName">
				<td colspan="3">
					<p class="title">${requestScope[uploadFileParameter].getFileName()}</p>
				</td>
			</tr>
			<tr class="viewer_space">
				<td class="output_details">
					<img src="${themeImagePath}/custom/common/evaluate/detail-icon.png" />
					<p class="title">${system_details}</p>
				</td>
				<td class="output_authors">
					<img src="${themeImagePath}/custom/common/evaluate/author-icon.png" />
					<p class="title">${system_authors}</p>
				</td>
				<td class="output_authors_viewer" rowspan="2">
					<span class="titleInput">${system_authors_title}</span>
					<div class="authorsViewer">
						<c:forEach var="author" items="${requestScope[outputAuthorsParameter]}" varStatus="loop">
							<p class="author">
								<span class="authorName">${author.getName()} ${author.getSurname()}</span>
								<a href="javascript:void(0)" class="removeAuthor" onclick="removeUser(event, this, 18105);" target="${author.getSurname()},${author.getName()};">${save_delete_author}</a>
							</p>
						</c:forEach>
					</div>
				</td>
			</tr>
			<tr class="viewer_space">
				<td class="output_details">
					<div class="detail_container">
						<span class="titleInput">${system_title}</span>
						<span class="titleInput">${system_paper}</span>
						<input id="outputTitle" name="<portlet:namespace/>${outputTitleParameter}" type="text" value="${requestScope[outputTitleParameter]}" onkeyup="checkAuthorForm(event, $(this).closest('.table_outputDetails'));" class="dataAuthor dynamicValue" checked="checked" />
						<input id="outputPaperUrl" name="<portlet:namespace/>${outputUrlPaperParameter}" type="text" value="${requestScope[outputUrlPaperParameter]}" onkeyup="checkAuthorForm(event, $(this).closest('.table_outputDetails'));" class="dataAuthor dynamicValue" checked="checked" />
					</div>
					<div class="detail_container">
						<span class="titleInput">${system_publication_title}</span>
						<span class="titleInput">&nbsp;</span>
						<select id="outputPublicationYear" name="<portlet:namespace/>${outputPublicationYearParameter}" class="dataAuthor dynamicValue" checked="checked">
						  	<c:set var="year" scope="session" value="<%=Calendar.getInstance().get(Calendar.YEAR)%>"/>
						  	<c:forEach begin="1950" end="${year - 1}" varStatus="loop">
								<c:set var="selected" scope="session" value="${1}"/>
							</c:forEach>
							<option value="${year}" <c:if test="${selected != 1}"> selected</c:if>>${year}</option>
						  	<c:forEach begin="0" end="${year - 1 - 1950}" varStatus="loop">
						  		<c:set var="curentYear" scope="session" value="${year - 1 - loop.index}"/>
								<option value="${curentYear}" <c:if test="${curentYear == requestScope[outputPublicationYearParameter]}"><c:set var="selected" scope="session" value="${1}"/>selected</c:if>>${curentYear}</option>
							</c:forEach>
						</select>
					</div>
					<div class="detail_container bottom">
						<span class="titleInput">${system_bibtex}</span>
						<input name="bibtexFileName" value="${requestScope[outputBibtexParameter]}"  id="bibtexFileName" type="hidden" />
						<input class="applyButton" name="${outputBibtexParameter}" id="outputBibtex" type="file" data-url="${UploadServiceURL}" />
						<div class="detail_container">
							<label class="applyButtonLabel" id="outputBibtexLabel" for="outputBibtex">${upload_browse_bibtex}</label>
						</div>
						<span class="bibtexMessage"></span>
					</div>
				</td>
				<td class="output_authors">
					<span class="titleInput">${save_author_name}</span>
					<span class="titleInput">${save_author_surname}</span>
					<div class="spaceTitleInput"></div>
					<input id="outputAuthorName" type="text" value="" />
					<input id="outputAuthorSurname" type="text" value="" />
					<span>
						<a href="javascript:void(0)" class="addNewUser" onclick="addNewUser(event, this, 18104);"></a>
					</span>
					<p class="addUserError"></p>
				</td>
			</tr>
			<tr>
				<td colspan="3">
					<img src="${themeImagePath}/custom/common/evaluate/description-icon.png" />
					<p class="title">${system_description}</p>
				</td>
			</tr>
			<tr>
				<td colspan="3">
					<textarea id="outputDescription" name="<portlet:namespace/>${outputDescriptionParameter}" rows="4" cols="50" onkeyup="updateCountCharacters(event, this); checkAuthorForm(event, $(this).closest('.table_outputDetails'));" onkeydown="updateCountCharacters(event, this);" class="dataAuthor dynamicValue" checked="checked">${requestScope[outputDescriptionParameter]}</textarea>
					<span class="characterCounter">
						<span class="currentCharacterNumber">0</span>
						<span> / </span>
						<span class="maximumCharacterNumber">${maximumCharacterNumber}</span>
					</span>
				</td>
			</tr>
			<tr>
				<td colspan="3">
					<input class="applyButton" name="outputSave" id="outputSave" type="submit" onclick="showSavePopup(event, this, 18019);" />
					<div class="divSave">
						<label class="applyButtonLabel disabled" id="outputSaveLabel" for="outputSave">${save_output_text}</label>
					</div>
				</td>
			</tr>
	 	</table>
	 	<script>
	 		$(document).ready(function() {

	 			$('#outputBibtex').fileupload({

			        dataType: 'json',

			        maxFileSize: 5000000,// 5 MB

			        acceptFileTypes: /(\.|\/)(txt|csv|tsv)$/i,

			        submit: function (e, data) {

			        	if(!data.files[0].type.startsWith(TEXT_MIMETYPE) && !data.files[0].type.startsWith(CSV_MIMETYPE) && data.files[0].type.length > 0) {

			        		show_info(e, 'warning uploading_file', 'Warning: It is not a BibTeX file', 'The file could not be uploaded because it\'s not a BibTeX file.');

			        		ga('send', {
			        			hitType: 'event',
			        			eventCategory: 'bibtex',
			        			eventAction: 'beginUpload',
			        			eventLabel: 'notBibTeXType',
			        			eventValue: 18101
			        		});

			        		return false;
			        	}

			        	var fileSize = Math.round(data.files[0].size / 1024);

			        	if(fileSize > UPLOAD_MAX_KB) {

			        		show_info(e, 'warning uploading_file', 'Warning: exceeded maximum size of BibTeX file', 'The file could not be uploaded because of maximun size of BibTeX file has been reached.');

		        			ga('send', {
			        			hitType: 'event',
			        			eventCategory: 'bibtex',
			        			eventAction: 'beginUpload',
			        			eventLabel: 'maxSize',
			        			eventValue: 18101
			        		});

			        		return false;
			        	}

			        	$('#fullpage .section[data-anchor="save"] .table_outputDetails .bibtexMessage').text('${save_uploading_bibtex}');

			        	ga('send', {
		        			hitType: 'event',
		        			eventCategory: 'bibtex',
		        			eventAction: 'beginUpload',
		        			eventLabel: data.files[0].name + ' | ' + Math.round(data.files[0].size / 1024),
		        			eventValue: 18101
		        		});
			        },

			        done: function (e, data) {

			        	hide_info(e, 'uploading_file');

			        	var name = String(data.files[0].name);

			        	$('#fullpage .section[data-anchor="save"] .table_outputDetails .bibtexMessage').text(name);

			        	$('#fullpage .section[data-anchor="save"] .table_outputDetails #bibtexFileName').val('saved');

			        	checkAuthorForm(event, $('#fullpage .section[data-anchor="save"] .table_outputDetails'));

			        	ga('send', {
		        			hitType: 'event',
		        			eventCategory: 'bibtex',
		        			eventAction: 'upload',
		        			eventLabel: data.files[0].name,
		        			eventValue: 18102
		        		});
			        }
			    });
	 		});
	 	</script>
 	</div>
</div>