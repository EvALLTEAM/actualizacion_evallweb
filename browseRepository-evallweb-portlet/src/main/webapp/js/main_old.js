//****************** FULLPAGE ******************//
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

    $('.section[data-anchor="benchmark"] .benchmarkSearchBar select').selectmenu({
  	  change: function(event, ui) {
  		  searchBenchmark(event, $('.section[data-anchor="benchmark"] .benchmarkSearchBar select'), $('#evall_benchmarks'), 50010);
  	  }
    });

    adjustTable($('#evall_benchmarks'), parseInt(ROWS_PER_PAGE_BENCHMARK));

    adjustFileTable($('#best-files'), SYSTEM_NUMBER_PER_PAGE);
});

function setBenchmark(event, element, origin) {

	event.stopPropagation();

	event.preventDefault();

	if($("#benchmarkInput").val().trim().localeCompare($(element).attr('target').trim()) != 0) {

		$("#benchmarkInput").val($(element).attr('target'));

		var renderURL = new Liferay.PortletURL.createRenderURL();
		renderURL.setWindowState(LIFERAY_WINDOW_STATE);
		renderURL.setParameter(VIEW, SYSTEM_LIST_VIEW);
		renderURL.setPortletMode(LIFERAY_PORTLET_MODE);
		renderURL.setPortletId(LIFERAY_PORTLET_ID);
		renderURL.setParameter(BENCHMARK_ID_PARAMETER, $('#benchmarkInput').val());

		$.ajax({

			url: renderURL.toString(),

			dataType: "html",

			method: "POST",

			success: function(data) {

				hide_info(event, 'system_list');

				var slide = $('.section[data-anchor="output"] .slide[data-anchor="output_list"] .frameSlide');

				slide.html($(data).find('.slide[data-anchor="output_list"] .frameSlide').html());

				$('.section[data-anchor="output"] #selected_measure_list').val($(data).find('#selected_measure_list').val());

				adjustFileTable($('.section[data-anchor="output"] .slide[data-anchor="output_list"] table.fileTable'), SYSTEM_NUMBER_PER_PAGE);

				slide.find('table tr.paginationRow .paginationDiv').append('<div class="circle"></div><div class="arrow_circle"></div>');

				$(".section .section-block").addClass('disabled');

				$(".section[data-anchor='benchmark'] .arrow").removeClass('disabled');

				ga('send', {
		    		hitType: 'event',
		    		eventCategory: 'benchmark',
		    		eventAction: 'select',
		    		eventLabel: $("#benchmarkInput").val(),
		    		eventValue: origin
		    	});
			},
			error: function() {

				show_info(event, 'error system_list', 'Error: loading system list', 'The system list could not be loaded. Please reload the page and try again.');

				ga('send', {
		    		hitType: 'event',
		    		eventCategory: 'benchmark',
		    		eventAction: 'errorSelect',
		    		eventLabel: $("#benchmarkInput").val(),
		    		eventValue: origin
		    	});
			}
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

function showSavePopup(event, element, origin) {

	event.preventDefault();

	event.stopPropagation();

	$('#pop input.action').attr('idOutput', $(element).attr('idOutput'));

	$('#pop input.action').attr('name', $(element).attr('name'));

	$('#pop input.action').attr('target', $(element).attr('target'));

	$('#pop .warning').text('The output ' + $(element).attr('name') + ' will be definitely removed from EvAll. Are you sure that you want to proceed?');

	setTimeout("$('#pop').fadeIn('slow');", 300);

	ga('send', {
		hitType: 'event',
		eventCategory: 'browse',
		eventAction: 'showPopup',
		eventLabel: '',
		eventValue: origin
	});
}

function deleteFile_(event, element, origin) {

	event.preventDefault();

	event.stopPropagation();

	$.ajax({

		url: $(element).attr('target').toString(),

		dataType: "json",

		method: "POST",

		success: function(data) {

			hide_info(event, 'deleting_file');

			refreshBrowse(event);

			ga('send', {
				hitType: 'event',
				eventCategory: 'refreshBrowse',
				eventAction: 'delete',
				eventLabel: $(element).attr('idOutput') + ' | ' + $(element).attr('name'),
				eventValue: origin
			});
		},
		error: function() {

			show_info(event, 'error deleting_file', 'Error: deleting file', 'The file ' + $(element).attr('name') + ' could not be deleted. Please, try again.');

			ga('send', {
				hitType: 'event',
				eventCategory: 'refreshBrowse',
				eventAction: 'delete',
				eventLabel: 'error',
				eventValue: origin
			});
		}
	});
}

function refreshBrowse(event) {

	goToSystems_(event, $('.section[data-anchor="output"] .frameSection .slide[data-anchor="output_list"] .frameSlide .paginationRow #selfPagination')[0], 52005);
}

function selectMeasure(event, element, origin) {

	event.stopPropagation();

	event.preventDefault();

	var table = $(element).closest('.frameSlide').find('.fileTable');

	table.addClass('loading');

	table.css('opacity', '0.7');

	if($(element).hasClass('selected')) {

		$(element).removeClass('selected')

		setTimeout(function() {

			table.find('th.measure.' + $(element).attr('target') + ',td.measure.' + $(element).attr('target') + ',th.voidTh.' + $(element).attr('target') + ',td.voidTd.' + $(element).attr('target')).addClass('hidden');

			table.find('th.measure.voidMeasure.hidden').last().removeClass('hidden');

			table.find('th.voidTh.hidden').last().removeClass('hidden');

			table.find('tr.fileTr').each(function(i, entry) {

				$(entry).find('td.measure.voidMeasure.hidden').last().removeClass('hidden');

				$(entry).find('td.voidTd.hidden').last().removeClass('hidden');
			});

			table.removeClass('loading');

			table.css('opacity', '1');

		}, 200);

		$('#selected_measure_list').val($('#selected_measure_list').val().replace($(element).attr('target') + ';', ''));

		ga('send', {
    		hitType: 'event',
    		eventCategory: 'measure',
    		eventAction: 'unselect',
    		eventLabel: $(element).attr('target') + ' | ' + $("#benchmarkInput").val(),
    		eventValue: origin
    	});

	} else if($(element).closest('.systemMetricBar').find('.measure.selected').length < SYSTEM_NUMBER_MEASURES) {

		$(element).addClass('selected')

		setTimeout(function() {

			table.find('th.measure.' + $(element).attr('target') + ',td.measure.' + $(element).attr('target') + ',th.voidTh.' + $(element).attr('target') + ',td.voidTd.' + $(element).attr('target')).removeClass('hidden');

			table.find('th.measure.voidMeasure:not(.hidden)').last().addClass('hidden');

			table.find('th.voidTh:not(.hidden)').last().addClass('hidden');

			table.find('tr.fileTr').each(function(i, entry) {

				$(entry).find('td.measure.voidMeasure:not(.hidden)').last().addClass('hidden');

				$(entry).find('td.voidTd:not(.hidden)').last().addClass('hidden');
			});

			table.removeClass('loading');

			table.css('opacity', '1');

		}, 200);

		$('#selected_measure_list').val($('#selected_measure_list').val().concat($(element).attr('target') + ';'));

		ga('send', {
    		hitType: 'event',
    		eventCategory: 'measure',
    		eventAction: 'select',
    		eventLabel: $(element).attr('target') + ' | ' + $("#benchmarkInput").val(),
    		eventValue: origin
    	});
	}

	formatMeasures($(element).closest('.systemMetricBar'), origin);
}

function formatMeasures(element, origin) {

	if($(element).find('.measure.selected').length >= SYSTEM_NUMBER_MEASURES) {

		$(element).find('.measure:not(.selected)').addClass('disabled');

	} else {

		$(element).find('.measure').removeClass('disabled');
	}
}

function adjustFileTable(table, numberPerPage) {

	table.find('select').selectmenu({
  	  	change: function(event, ui) {

  	  		event.preventDefault();

  	  		changeMeasure($(this).val());
  	  	}
    });

	var c = parseInt(numberPerPage) + 1;

	var headHeight = table.find('tr.head').height();

	var totalHeight = table.height() - headHeight;

	var height = totalHeight / c;

	var trContent = $(table).find('tr:not(.head)');

	for (var i = 0; i < trContent.length; ++i) {

		$(trContent[i]).height(height);
    }

	if(!table.find('tr.paginationRow .paginationDiv').hasClass('hidden')) {

		table.find('tr.paginationRow .paginationDiv .circle').remove();

		table.find('tr.paginationRow .paginationDiv .arrow_circle').remove();
	}

	readjustColorRow(table);
}

AUI().use('aui-base','liferay-portlet-url','aui-node', function(A) {

	resetCookie(jQuery.Event());
});