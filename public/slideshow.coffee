$(document).ready ->
	console.log 'foooo'

	$('ul.urlList a').click ( ev ) ->
		e = $(ev.currentTarget)
		href = e.attr 'data-url'
		$('iframe.slideshow').attr 'src', href

	diff = 57
	$('iframe.slideshow').height( $(document).height() - diff )

	$(window).resize ->
		$('iframe.slideshow').height( $(document).height() - diff )


