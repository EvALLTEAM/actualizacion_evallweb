//****************** FULLPAGE ******************//
var INITIAL_INDEX = 0;

$(document).ready(function() {
    $('#fullpage').fullpage({
        //Navigation
        menu: '#menu',
        lockAnchors: false,
        navigation: true,
        navigationPosition: 'right',
        navigationTooltips: $(".section").map(function(){return $(this).attr("title");}).get(),
        showActiveTooltip: true,
        slidesNavigation: false,
        slidesNavPosition: 'bottom',

        //Scrolling
        css3: true,
        scrollingSpeed: 750,
        autoScrolling: true,
        fitToSection: true,
        fitToSectionDelay: 1000,
        scrollBar: false,
        easing: 'easeInOutCubic',
        easingcss3: 'ease',
        loopBottom: false,
        loopTop: false,
        loopHorizontal: true,
        continuousVertical: false,
        normalScrollElements: '#screen-block, #signinmodal, .yui3-widget-mask',
        scrollOverflow: false,
        touchSensitivity: 15,
        normalScrollElementTouchThreshold: 1,

        //Accessibility
        keyboardScrolling: true,
        animateAnchor: true,
        recordHistory: true,

        //Design
        controlArrows: false,
        verticalCentered: true,
        resize : false,
        responsiveWidth: 0,
        responsiveHeight: 0,

        //Custom selectors
        sectionSelector: '.section',
        slideSelector: '.slide',

        //events
        onLeave: leaveSection,
        afterLoad: loadSection,
        afterRender: renderPage,
        afterResize: function(){},
        afterSlideLoad: function(anchorLink, index, slideAnchor, slideIndex){},
        onSlideLeave: leaveSlide
    });

    if($('.section[data-anchor="benchmark"] table tr.contentTr td.benchmark.selected').length == 0) {

    	$("#benchmarkInput").val('');
    }

    $('.section[data-anchor="benchmark"] .benchmarkSearchBar select').selectmenu({
    	  change: function(event, ui) {
    		  searchBenchmark(event, $('.section[data-anchor="benchmark"] .benchmarkSearchBar select'), $('#evall_benchmarks'), 10010);
    	  }
    });

    adjustTable($('#evall_benchmarks'), parseInt(ROWS_PER_PAGE_BENCHMARK));

    adjustFileTable($('#uploaded-files'), FILE_NUMBER_PER_PAGE);

    readjustUploadPagination($('#uploaded-files'));

    adjustFileTable($('#outputs-to-save'), OUTPUT_NUMBER_PER_PAGE);

//****************** UPLOAD ******************//

    INITIAL_INDEX = $("#uploaded-files tr.fileTr").length;

    $('#fileupload').fileupload({

        dataType: 'json',

        limitMultiFileUploads: UPLOAD_MAX_NUMBER_PDF,

        sequentialUploads: true,

        acceptFileTypes: /(\.|\/)(txt|csv|tsv)$/i,
 
        submit: function (e, data) {

        	if($('#dropzone_files').hasClass('disabled')) {

        		return false;
        	}

        	$('#popup_show').remove();

        	var maximum_file_number = UPLOAD_MAX_NUMBER_TSV;

        	if($('#reportOption1')[0].hasAttribute('checked')) {

        		maximum_file_number = UPLOAD_MAX_NUMBER_PDF;
        	}

        	var formData = {};

        	formData[BENCHMARK_ID_PARAMETER] = $('#benchmarkInput').val();

        	formData[SYSTEM_ORDER_PARAMETER] = INITIAL_INDEX;

        	formData[UPLOAD_MAX_NUMBER_PARAMETER] = maximum_file_number;

        	data.formData = formData;

        	if(!data.files[0].type.startsWith(TEXT_MIMETYPE) && !data.files[0].type.startsWith(CSV_MIMETYPE) && data.files[0].type.length > 0) {

        		show_info(e, 'warning uploading_file', 'Warning: It is not a text file', 'The file could not be uploaded because it\'s not a text file.');

        		ga('send', {
        			hitType: 'event',
        			eventCategory: OUTPUT_TYPE,
        			eventAction: 'beginUpload',
        			eventLabel: 'notTextType',
        			eventValue: 16001
        		});

        		return false;
        	}

        	var fileSize = Math.round(data.files[0].size / 1024);

        	var fileSizes = fileSize;

        	$.each($('#uploaded-files tr.fileTr'), function (i, fileTr) {

        		fileSizes += parseInt($(fileTr).find('td.size').text().replace(' Kb', ''));
        	});

        	if($("#uploaded-files tr.fileTr").length >= maximum_file_number || fileSizes > UPLOAD_MAX_KB) {

        		if($("#uploaded-files tr.fileTr").length >= maximum_file_number) {

        			show_info(e, 'warning uploading_file', 'Warning: exceeded maximum number of files', 'The file could not be uploaded because of maximun number of files has been reached.');

	        		ga('send', {
	        			hitType: 'event',
	        			eventCategory: OUTPUT_TYPE,
	        			eventAction: 'beginUpload',
	        			eventLabel: 'maxNumber',
	        			eventValue: 16001
	        		});

        		} else if(fileSizes > UPLOAD_MAX_KB) {

        			show_info(e, 'warning uploading_file', 'Warning: exceeded maximum size of files', 'The file could not be uploaded because of maximun size of files has been reached.');

        			ga('send', {
	        			hitType: 'event',
	        			eventCategory: OUTPUT_TYPE,
	        			eventAction: 'beginUpload',
	        			eventLabel: 'maxSize',
	        			eventValue: 16001
	        		});
        		}

        		readjustUploadPagination($('.section[data-anchor="upload_output"] #uploaded-files'));

        		readjustColorRow($('.section[data-anchor="upload_output"] #uploaded-files'));

        		$('#uploaded-files th.delete a').removeClass('hidden');

        		checkEvaluateButton(jQuery.Event(), $('#uploaded-files'));

        		return false;

        	} else {

	        	$('#uploaded-files tr.head').after(
	        			$('<tr class="fileTr uploading" ' + SYSTEM_ORDER_PARAMETER + '="' + INITIAL_INDEX + '"/>')
	        			.append($('<td class="voidTd"></td>'))
	                    .append($('<td class="name"/>').html('<span class="fileName">' + data.files[0].name + '</span>'))
	                    .append($('<td class="voidTd"></td>'))
	                    .append($('<td class="size"/>').text(fileSize + " kb"))
	                    .append($('<td class="voidTd"></td>'))
	                    .append($('<td class="progressBar"/>').html('<div class="containerBar"><div class="bar"><span class="percentage">0%</span><div class="infoIcon hidden" onclick="togglePopupDiv(event, this);"></div><div class="percentageBar"></div></div></div><div onclick="event.stopPropagation(); event.preventDefault();" class="popupDiv"><a class="copyClipboardIcon" href="javascript:void(0)" onclick="copyToClipboard(event, $(this).closest(\'.popupDiv\').find(\'.popupDivFrame\').text(), 16015);"></a><div class="popupDivFrame"></div></div>'))
	                    .append($('<td class="download"/>'))
	                    .append($('<td class="delete"/>').html('<a href="#"></a>'))
	                    .append($('<td class="voidTd"></td>'))
	        	);

	        	$("#uploaded-files tr.fileTr").first().height($("#uploaded-files tr.fileTr:not(.hidden), #uploaded-files tr.voidTr:not(.hidden)").last().height());

	        	var from = $("#uploaded-files tr.fileTr, #uploaded-files tr.voidTr").index($("#uploaded-files tr.fileTr:not(.hidden), #uploaded-files tr.voidTr:not(.hidden)").first());

				$("#uploaded-files tr.fileTr, #uploaded-files tr.voidTr").slice(0, from).filter('.hidden').last().removeClass('hidden');

				$("#uploaded-files tr.fileTr:not(.hidden), #uploaded-files tr.voidTr:not(.hidden)").last().addClass('hidden');

        		$("#uploaded-files tr.fileTr").first().find('td.delete a').on('click', function(e) {

        			data.submit().abort();

        			$(this).closest('tr.fileTr').remove();
        		});

        		INITIAL_INDEX++;

        		if(data.originalFiles.indexOf(data.files[0]) == data.originalFiles.length - 1) {

            		readjustUploadPagination($('.section[data-anchor="upload_output"] #uploaded-files'));

            		readjustColorRow($('.section[data-anchor="upload_output"] #uploaded-files'));

            		$('#uploaded-files th.delete a').removeClass('hidden');

            		checkEvaluateButton(jQuery.Event(), $('#uploaded-files'));
            	}

        		ga('send', {
        			hitType: 'event',
        			eventCategory: OUTPUT_TYPE,
        			eventAction: 'beginUpload',
        			eventLabel: data.files[0].name + ' | ' + fileSize,
        			eventValue: 16001
        		});
        	}
        },

        progress: function (e, data) {

        	var index = data.data.get(SYSTEM_ORDER_PARAMETER);

        	var tr = $('#uploaded-files tr.fileTr[' + SYSTEM_ORDER_PARAMETER + '="' + index + '"]');

            var progressBar = parseInt(data.loaded / data.total * 100, 10);

            tr.find('td.progressBar .containerBar .bar .percentageBar').css('width', progressBar + '%');

            if(data.loaded == data.total) {

            	tr.find('td.progressBar .containerBar .percentage').text('Saving...');

            } else {

            	tr.find('td.progressBar .containerBar .percentage').text(progressBar + '%');
            }
        },

        done: function (e, data) {

        	var index = data.data.get(SYSTEM_ORDER_PARAMETER);

        	var tr = $('#uploaded-files tr.fileTr[' + SYSTEM_ORDER_PARAMETER + '="' + index + '"]');

        	tr.removeClass('uploading');

        	if(data.result.status == -1) {

        		if(data.result.content.errors.indexOf(MAX_SIZE_MESSAGE) == 0) {

        			tr.remove();

        			$('#uploaded-files tr.fileTr.hidden, tr.voidTr.hidden').first().removeClass('hidden');

    				show_info(e, 'warning uploading_file', 'Warning: exceeded maximum size of files', 'The file could not be uploaded because of maximun size of files has been reached.');

	    			ga('send', {
	        			hitType: 'event',
	        			eventCategory: OUTPUT_TYPE,
	        			eventAction: 'load',
	        			eventLabel: 'maxNumber',
	        			eventValue: 16002
	        		});

        		} else if(data.result.content.errors.indexOf(MAX_NUMBER_MESSAGE) == 0) {

    				tr.remove();

    				$('#uploaded-files tr.fileTr.hidden, tr.voidTr.hidden').first().removeClass('hidden');

    				show_info(e, 'warning uploading_file', 'Warning: exceeded maximum number of files', 'The file could not be uploaded because of maximun number of files has been reached.');

	    			ga('send', {
	        			hitType: 'event',
	        			eventCategory: OUTPUT_TYPE,
	        			eventAction: 'load',
	        			eventLabel: 'maxNumber',
	        			eventValue: 16002
	        		});

    			} else if(data.result.content.errors.indexOf(MIMETYPE_MESSAGE) == 0) {

    				tr.remove();

    				$('#uploaded-files tr.fileTr.hidden, tr.voidTr.hidden').first().removeClass('hidden');

    				show_info(e, 'warning uploading_file', 'Warning: It is not a text file', 'The file could not be uploaded because it\'s not a text file.');

	    			ga('send', {
	        			hitType: 'event',
	        			eventCategory: OUTPUT_TYPE,
	        			eventAction: 'load',
	        			eventLabel: 'notTextType',
	        			eventValue: 16002
	        		});

    			} else {

        			tr.find('td.progressBar .containerBar .bar .percentageBar').css('width', 0 + '%');

            		tr.find('td.progressBar .containerBar .percentage').text('Upload failed');

            		tr.find('td.delete').html('<a href="javascript:void(0)" onclick="deleteErrorFile(' + tr + ');"></a>');

            		show_info(e, 'error uploading_file', 'Error: uploading file', 'The file could not be uploaded. Please, try it again.');

	            	ga('send', {
	        			hitType: 'event',
	        			eventCategory: OUTPUT_TYPE,
	        			eventAction: 'upload',
	        			eventLabel: 'failure',
	        			eventValue: 16002
	        		});
    			}

        		checkEvaluateButton(jQuery.Event(), $('#uploaded-files'));

        		readjustColorRow($('#uploaded-files'));

        	} else {

        		tr.attr('target', data.result.content.fileId);

        		tr.find('td.progressBar .containerBar .bar .percentageBar').css('width', 100 + '%');

            	var resourceURL = new Liferay.PortletURL.createResourceURL();
            	resourceURL.setWindowState(LIFERAY_WINDOW_STATE);
            	resourceURL.setParameter(FILE_ID_PARAMETER, data.result.content.fileId);
            	resourceURL.setParameter(FILE_TYPE_PARAMETER, OUTPUT_TYPE);
            	resourceURL.setPortletMode(LIFERAY_PORTLET_MODE);
            	resourceURL.setPortletId(LIFERAY_PORTLET_ID);
            	resourceURL.setResourceId(DOWNLOAD_FILE_RESOURCE);

            	tr.find('td.download').html('<a href="javascript:void(0)" onclick="openURL(event, this, OUTPUT_TYPE, \'download\', \'' + data.result.content.fileId + ' | ' + data.result.content.fileName + ' | ' + data.result.content.fileSize + '\', 16010);" target="' + resourceURL.toString() + '"></a>');

            	resourceURL.setResourceId(DELETE_FILE_RESOURCE);

            	tr.find('td.delete').html('<a href="javascript:void(0)" class="file_' + data.result.content.fileId + '" onclick="deleteFile(event, this, \'checkEvaluateButton\', OUTPUT_TYPE, \'' + data.result.content.fileId + ' | ' + data.result.content.fileName + ' | ' + data.result.content.fileSize + '\', 16011);" target="' + resourceURL.toString() + '"></a>');

            	tr.find('td.name .fileName').after('<div class="editNameIcon" id="renamefile_' + data.result.content.fileId + '" onclick="accessToRenameFile(event, this, ' + data.result.content.fileId + ', OUTPUT_TYPE, \'' + data.result.content.fileId + ' | ' + data.result.content.fileName + ' | ' + data.result.content.fileSize + '\', 16007);"></div>');

            	if(data.originalFiles.indexOf(data.files[0]) == data.originalFiles.length - 1) {

            		hide_info(e, 'uploading_file');

            		checkFileFormat(tr.closest('table'), tr.attr('target'), true, OUTPUT_TYPE, checkEvaluateButton, 16002);

            	} else {

            		checkFileFormat(tr.closest('table'), tr.attr('target'), false, OUTPUT_TYPE, function voidFunction(){}, 16002);
            	}

            	checkOptionChanges(false);

            	ga('send', {
        			hitType: 'event',
        			eventCategory: OUTPUT_TYPE,
        			eventAction: 'upload',
        			eventLabel: data.result.content.fileId + ' | ' + data.result.content.fileName + ' | ' + data.result.content.fileSize,
        			eventValue: 16002
        		});
        	}
        },

        dropZone: $('#dropzone_files')
    });

    $('#dropzone_files').bind('dragover', dragover);
});

function examplefileload(event, element, type, origin) {

	$.fn.fullpage.setAllowScrolling(false);

	$.fn.fullpage.setKeyboardScrolling(false);

	var zIndex = $('#screen-block').css('zIndex');

	$('#screen-block').css('zIndex', '230');

	$('#screen-block').show().animate({opacity: '0.5'}, 750, function() {

		$('#loading').show();

		var max = 0;

		if($('#reportOption1').length > 0 && $('#reportOption1')[0].hasAttribute('checked')) {

			max = UPLOAD_MAX_NUMBER_PDF;

		} else if($('#reportOption2').length > 0 && $('#reportOption2')[0].hasAttribute('checked')) {

			max = UPLOAD_MAX_NUMBER_TSV;
		}

		var resourceURL = new Liferay.PortletURL.createResourceURL();
		resourceURL.setWindowState(LIFERAY_WINDOW_STATE);
		resourceURL.setPortletMode(LIFERAY_PORTLET_MODE);
		resourceURL.setPortletId(LIFERAY_PORTLET_ID);
		resourceURL.setParameter(FILE_TYPE_PARAMETER, type);
		resourceURL.setParameter(UPLOAD_MAX_NUMBER_PARAMETER, max);
		resourceURL.setResourceId(LOAD_EXAMPLE_FILE_RESOURCE);

		if($('#benchmarkInput').length > 0) {

			resourceURL.setParameter(BENCHMARK_ID_PARAMETER, $('#benchmarkInput').val());
		}

		if($('#taskInput').length > 0) {

			resourceURL.setParameter(TASK_PARAMETER, $('#taskInput').val());
		}

		$.ajax({

			url: resourceURL.toString(),

			dataType: "json",

			method: "POST",

			success: function(data) {

				hide_info(event, 'loading_example_file');

	        	$('#loading').hide();

				if(data.status == -1) {

					$('#screen-block').animate({opacity: '0'}, 750, function() {

						$(this).hide();

						$('#screen-block').css('zIndex', zIndex);

						$.fn.fullpage.setAllowScrolling(true);

						$.fn.fullpage.setKeyboardScrolling(true);

						if(data.content.errors.indexOf(MAX_SIZE_MESSAGE) == 0) {

							show_info(event, 'warning loading_example_file', 'Warning: exceeded maximum size of files', 'The example file could not be loaded because of maximun size of files has been reached.');

							ga('send', {
			        			hitType: 'event',
			        			eventCategory: type,
			        			eventAction: 'load',
			        			eventLabel: 'maxNumber',
			        			eventValue: origin
			        		});

						} else if(data.content.errors.indexOf(MAX_NUMBER_MESSAGE) == 0) {

							show_info(event, 'warning loading_example_file', 'Warning: exceeded maximum number of files', 'The example file could not be loaded because of maximun number of files has been reached.');

							ga('send', {
			        			hitType: 'event',
			        			eventCategory: type,
			        			eventAction: 'load',
			        			eventLabel: 'maxNumber',
			        			eventValue: origin
			        		});

						} else {

							show_info(event, 'error loading_example_file', 'Error: loading example file', 'The example file could not be load. Please, try it again.');

			            	ga('send', {
			        			hitType: 'event',
			        			eventCategory: type,
			        			eventAction: 'load',
			        			eventLabel: 'failure',
			        			eventValue: origin
			        		});
						}
					});

				} else {

					$('#uploaded-files > tbody > tr:not(.head)').first().before(
		        			$('<tr class="fileTr" ' + SYSTEM_ORDER_PARAMETER + '="' + INITIAL_INDEX + '" target="' + data.content.fileId + '"/>')
		        			.append($('<td class="voidTd"></td>'))
		                    .append($('<td class="name"/>').html('<span class="fileName">' + data.content.fileName + '</span>'))
		                    .append($('<td class="voidTd"></td>'))
		                    .append($('<td class="size"/>').text(data.content.fileSize))
		                    .append($('<td class="voidTd"></td>'))
		                    .append($('<td class="progressBar"/>').html('<div class="containerBar"><div class="bar"><span class="percentage">100%</span><div class="infoIcon hidden" onclick="togglePopupDiv(event, this);"></div><div class="percentageBar"></div></div></div><div onclick="event.stopPropagation(); event.preventDefault();" class="popupDiv"><a class="copyClipboardIcon" href="javascript:void(0)" onclick="copyToClipboard(event, $(this).closest(\'.popupDiv\').find(\'.popupDivFrame\').text(), ' + (origin + 5) + ');"></a><div class="popupDivFrame"></div></div>'))
		                    .append($('<td class="download"/>'))
		                    .append($('<td class="delete"/>').html('<a href="#"></a>'))
		                    .append($('<td class="voidTd"></td>'))
		        	);

		        	var tr = $("#uploaded-files tr.fileTr").first();

		        	tr.height($("#uploaded-files tr.fileTr:not(.hidden), #uploaded-files tr.voidTr:not(.hidden)").last().height());

		        	tr.find('td.progressBar .containerBar .bar .percentageBar').css('width', 100 + '%');

					var from = $("#uploaded-files tr.fileTr, #uploaded-files tr.voidTr").index($("#uploaded-files tr.fileTr:not(.hidden), #uploaded-files tr.voidTr:not(.hidden)").first());

					$("#uploaded-files tr.fileTr, #uploaded-files tr.voidTr").slice(0, from).filter('.hidden').last().removeClass('hidden');

					$("#uploaded-files tr.fileTr:not(.hidden), #uploaded-files tr.voidTr:not(.hidden)").last().addClass('hidden');

					readjustUploadPagination($('.section[data-anchor="upload_output"] #uploaded-files'));

					readjustColorRow($('.section[data-anchor="upload_output"] #uploaded-files'));

					$('#uploaded-files th.delete a').removeClass('hidden');

	            	var resourceURL = new Liferay.PortletURL.createResourceURL();
	            	resourceURL.setWindowState(LIFERAY_WINDOW_STATE);
	            	resourceURL.setParameter(FILE_ID_PARAMETER, data.content.fileId);
	            	resourceURL.setParameter(FILE_TYPE_PARAMETER, type);
	            	resourceURL.setPortletMode(LIFERAY_PORTLET_MODE);
	            	resourceURL.setPortletId(LIFERAY_PORTLET_ID);
	            	resourceURL.setResourceId(DOWNLOAD_FILE_RESOURCE);

	            	tr.find('td.download').html('<a href="javascript:void(0)" onclick="openURL(event, this, OUTPUT_TYPE, \'download\', \'' + data.content.fileId + ' | ' + data.content.fileName + ' | ' + data.content.fileSize + '\', ' + (origin - 2) + ');" target="' + resourceURL.toString() + '"></a>');

	            	resourceURL.setResourceId(DELETE_FILE_RESOURCE);

	            	tr.find('td.delete').html('<a href="javascript:void(0)" class="file_' + data.content.fileId + '" onclick="deleteFile(event, this, \'checkEvaluateButton\', OUTPUT_TYPE, \'' + data.content.fileId + ' | ' + data.content.fileName + ' | ' + data.content.fileSize + '\', ' + (origin - 1) + ');" target="' + resourceURL.toString() + '"></a>');

	            	tr.find('td.name .fileName').after('<div class="editNameIcon" id="renamefile_' + data.content.fileId + '" onclick="accessToRenameFile(event, this, ' + data.content.fileId + ', OUTPUT_TYPE, \'' + data.content.fileId + ' | ' + data.content.fileName + ' | ' + data.content.fileSize + '\', ' + (origin - 5) + ');"></div>');

	            	$('#screen-block').animate({opacity: '0'}, 750, function() {

						$(this).hide();

						$('#screen-block').css('zIndex', zIndex);

						$.fn.fullpage.setAllowScrolling(true);

						$.fn.fullpage.setKeyboardScrolling(true);

		            	checkFileFormat(tr.closest('table'), tr.attr('target'), true, OUTPUT_TYPE, checkEvaluateButton, origin);

		            	checkOptionChanges(false);

		            	INITIAL_INDEX++;

		            	ga('send', {
		        			hitType: 'event',
		        			eventCategory: type,
		        			eventAction: 'load',
		        			eventLabel: data.content.fileId + ' | ' + data.content.fileName + ' | ' + data.content.fileSize,
		        			eventValue: origin
		        		});
					});
				}
			},
			error: function() {

				$('#loading').hide();

				$('#screen-block').animate({opacity: '0'}, 750, function() {

					$(this).hide();

					$('#screen-block').css('zIndex', zIndex);

					$.fn.fullpage.moveTo("result");

					$.fn.fullpage.setAllowScrolling(true);

					$.fn.fullpage.setKeyboardScrolling(true);
				});

				show_info(event, 'error loading_example_file', 'Error: loading example file', 'The example file could not be load. Please, try it again.');

				ga('send', {
	    			hitType: 'event',
	    			eventCategory: type,
	    			eventAction: 'load',
	    			eventLabel: 'failure',
	    			eventValue: origin
	    		});
			}
		});
	});
}

//****************** BENCHMARK ******************//
function setBenchmark(event, element, origin) {

	event.stopPropagation();

	event.preventDefault();

	if($("#benchmarkInput").val().trim().localeCompare($(element).attr('target').trim()) != 0) {

		var url = $('#fileupload').attr('data-url').replace(new RegExp("\\&" + PORTLET_NAMESPACE + BENCHMARK_ID_PARAMETER + "=.*$","gm"), '');

		$("#benchmarkInput").val($(element).attr('target'));

		$('#fileupload').attr('data-url', url + '&' + PORTLET_NAMESPACE + BENCHMARK_ID_PARAMETER + '=' + $(element).attr('target'));

		resetAllSections(event, 'benchmark');

		$(".section[data-anchor!='benchmark'] .arrow").addClass('disabled2');

		$(".section .section-block").removeClass('disabled');

		$(".section[data-anchor='benchmark'] .arrow").removeClass('disabled');

		resetCookie(event);

		checkFileFormats($("#uploaded-files"), true, OUTPUT_TYPE, checkEvaluateButton, origin);

		resetSaveOutput(event, $('.section[data-anchor="save"] .frameGeneric .frameSlide.list'), origin);

		resetEvaluation(event, origin);

		if($('.section[data-anchor="upload_output"] .frameGeneric .frameSlide .fileTable th.delete a').length > 0) {

			deleteAllFiles(event, $('.section[data-anchor="upload_output"] .frameGeneric .frameSlide .fileTable th.delete a'), checkEvaluateButton, 16006);
		}

		setBestSystemName($('#benchmarkInput').val());

		ga('send', {
    		hitType: 'event',
    		eventCategory: 'benchmark',
    		eventAction: 'select',
    		eventLabel: $("#benchmarkInput").val(),
    		eventValue: origin
    	});

	} else {

		ga('send', {
    		hitType: 'event',
    		eventCategory: 'benchmark',
    		eventAction: 'alreadySelect',
    		eventLabel: $("#benchmarkInput").val(),
    		eventValue: origin
    	});
	}
}


//****************** METRICS ******************//
function setMetricParameter(event, element, origin) {

	event.preventDefault();

	var values = $("#metricParametersInput").val();

	var elements = $(element).closest("#detailDiv").find('.config_zone .parameters table tr')

	elements.each(function(index, entry) {

		var id = $(entry).attr('target');

		var changed = $(entry).find('td.content.value input.change').val();

		var val = $(entry).find('td.content.value input.val').val();

		if(changed.localeCompare("1") == 0) {

			values = values.replace(new RegExp("(^|(;))" + id + "=([^;]*);","gm"), '$1').concat(id + "=" + val + ";");
		}
	});

	$("#metricParametersInput").val(values);

	var data = {};

	data[$("#metricParametersInput").attr('name')] = $("#metricParametersInput").val();

	addToCookie(event, data);

	checkOptionChanges(true);

	ga('send', {
		hitType: 'event',
		eventCategory: 'flow',
		eventAction: 'setMetricParameter',
		eventLabel: values,
		eventValue: origin
	});
}


//****************** TYPE OF EVALL ******************//
function goToDefaultEvaluation(event, origin) {

	goToUploadOutputs(event, origin);
}

function goToCustomEvaluation(event, origin) {

	goToTypeOfMetrics(event, origin);
}

function goToTypeOfMetrics(event, origin) {

	unblockTypeOfMetrics(event, true, origin);
}

function goToUploadOutputs(event, origin) {

	event.preventDefault();

	resetSection(event, $(".section[data-anchor='metric']"));

	resetSection(event, $(".section[data-anchor='baseline']"));

	resetSection(event, $(".section[data-anchor='report_option']"));

	chooseOption(event, $("#full_set_metrics"), false);

	chooseOption(event, $("#baselineOption1"), false);

	chooseMultipleOption(event, $("#reportOption1"), false);

	chooseMultipleOption(event, $("#reportOption2"), false);

	enableReportOptions(event, $("#reportOption1"));

	chooseMultipleOption(event, $("#reportOption3"), false);

	chooseMultipleOption(event, $("#reportOption4"), false);

	$(".section[data-anchor='metric'] .section-block").addClass('disabled');

	$(".section[data-anchor='baseline'] .section-block").addClass('disabled');

	$(".section[data-anchor='report_option'] .section-block").addClass('disabled');

	$(".section[data-anchor='metric'] .arrow").removeClass('disabled2');

	$(".section[data-anchor='baseline'] .arrow").removeClass('disabled2');

	$(".section[data-anchor='report_option'] .arrow").removeClass('disabled2');

	$(".section .section-block").removeClass(function (index, className) {
		return (className.match(/enabled(_[0-9]+)?/g) || []).join(' ');
	});

	$(".section .arrow").removeClass(function (index, className) {
		return (className.match(/disabled_[0-9]+/g) || []).join(' ');
	});

	unblockUpload(event, true, origin);

	checkFileNames($('#uploaded-files'), true);

	var data = {};

	var input = $('#full_set_metrics').closest('td.first').find('input');

	data[input.attr('name')] = input.val();

	data[$('#baselineOption1').attr('name')] = $('#baselineOption1').val();

	data[$('#reportOption1').attr('name')] = $('#reportOption1').val();

	data[$('#reportOption2').attr('name')] = $('#reportOption2').val();

	data[$('#reportOption3').attr('name')] = $('#reportOption3').val();

	data[$('#reportOption4').attr('name')] = $('#reportOption4').val();

	addToCookie(event, data);
}

function getOtherName(fileTr) {

	if($('#baselineOption2').is('[checked="checked"]')) {

		return $('.section[data-anchor="baseline"] #best-files tr.fileTr.selected .name .fileName').text();

	} else if($('#baselineOption1').is('[checked="checked"]')) {

		return $('#bestSystemName').val();

	} else {

		return '';
	}
}

function setBestSystemName(id) {

	if(id.length) {

		var resourceURL = new Liferay.PortletURL.createResourceURL();
		resourceURL.setWindowState(LIFERAY_WINDOW_STATE);
		resourceURL.setPortletMode(LIFERAY_PORTLET_MODE);
		resourceURL.setPortletId(LIFERAY_PORTLET_ID);
		resourceURL.setParameter(BENCHMARK_ID_PARAMETER, id);
		resourceURL.setResourceId(GET_BEST_SYSTEM_NAME_RESOURCE);

		return $.ajax({

			url: resourceURL.toString(),

			dataType: "text",

			method: "POST",

			success: function(data) {

				$('#bestSystemName').val(data);
			}
		});
	}
}

function showSavePopup(event, element, origin) {

	event.preventDefault();

	event.stopPropagation();

	setTimeout("$('#pop').fadeIn('slow');", 300);

	ga('send', {
		hitType: 'event',
		eventCategory: 'evaluate',
		eventAction: 'showPopup',
		eventLabel: '',
		eventValue: origin
	});
}

AUI().use('aui-base','liferay-portlet-url','aui-node', function(A) {

	if($('#isSaved').length > 0) {

		if($('#isSaved').val().localeCompare('true') == 0) {

			$('.section[data-anchor="save"] .section-block').addClass('disabled');

			$.fn.fullpage.moveTo('save');
		}

		$('#isSaved').val('');
	}

	resetCookie(jQuery.Event());

	adjustViewer($("#fullpage .section[data-anchor='result'] .frameGeneric .frameView"));

	setBestSystemName($('#benchmarkInput').val());

	checkFileFormats($('#uploaded-files'), $('#benchmarkInput').val().trim(), OUTPUT_TYPE, checkEvaluateButton, 10000);

	checkFileNames($('#uploaded-files'), OUTPUT_TYPE, 10001);
});