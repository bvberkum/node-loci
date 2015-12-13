
# TODO: add list' input field in header, keep list sessions active until closed
# TODO: add flag to reload URL on display, or keep iframe location by setting. not design like now.
# XXX: maybe use custom urlspec for urls with settings

# XXX: cannot read iframe location probably. 

# TODO: add proper slideshow automation, and controls, autostart setting, etc


lists = []
sites = {}

# list input
# main element
main = null

$(document).ready ->

	console.log "Loci static client starting"

	main = $('#slideshow_main')

	$('ul.urlList a').click ( ev ) ->
		e = $(ev.currentTarget)
		href = e.attr 'data-url'
		$('a#url').val href
		$('a#url').text href
		$('iframe.slideshow').attr 'src', href
		#if (!_.contains( sites, href ))
		#   XXX: add iframes that request unique session
		#toggle_iframe(href)

	diff = 57
	$('iframe.slideshow').height( $(document).height() - diff )

	$(window).resize ->
		$('iframe.slideshow').height( $(document).height() - diff )


