# jQuery.floatThead.utils - http://mkoryak.github.io/floatThead/ - Copyright (c) 2012 - 2014 Misha Koryak
# Licensed under CC BY-SA 4.0
#
# Data attribute support is not included in the lite version of the plugin!

SELECTOR = '[data-provide="floatThead"]'
BOUND_KEY = 'floatThead-dataAPI-bound'

dataDefaults =
  lazy: true

$.each($.floatThead.defaults, (key, val) ->
  dataDefaults[key.toLowerCase()] =
    key: key
    val: val
)

getOpts = ($el) ->
  ret = {}
  for key, val of $el.data()
    key = key.toLowerCase().substring("floatthead".length)
    ret[dataDefaults[key].key] = (val or dataDefaults[key]) if key of dataDefaults
  return ret

getInit = ($target) ->
  if $target.data(BOUND_KEY)
    return null

  opts = getOpts($target)
  if $target.is("table")
    $table = $target
  else
    $table = $target.find("table")
    opts = $.extend({}, opts, getOpts($table)) #allow 2 levels of options
    if opts.scrollContainer is true
      opts.scrollContainer = ->
        return $target
  fn =  ->
    $target.data(BOUND_KEY, true)
    $table.floatThead(opts)

  fn.opts = opts
  return fn

#bind lazy init
$(document).on("mouseover.floatTHead", SELECTOR + "[data-floatThead-lazy]", (e) ->
  getInit($(e.target))?()
)

#init any non-lazy data attribute driven tables
$(->
  $(SELECTOR).each(->
    init = getInit($(this))
    init()  unless not init or init.opts.lazy
  )
)


