#= require_tree ./lib
# require_tree ./lib_old

#= require _page
#= require _link
#= require _form

class Wiselinks
  constructor: ($target = $('body'), @options = {}) ->
    this._try_jquery()

    @options = $.extend(this._defaults(), @options)
    if this.enabled()
      if @options.disable_suid then History.options.disableSuid = true
      @page = new _Wiselinks.Page($target, @options)

  enabled: ->
    true

  load: (url, target, render = 'template') ->
    @page.load(url, target, render)

  reload: () ->
    @page.reload()

  _defaults: ->
    disable_suid: true
    target_missing: null
    assets_digest: $("meta[name='assets-digest']").attr("content")

  _try_jquery: ->
    throw new Error("[Wiselinks] jQuery is not loaded") unless window.jQuery?

window.Wiselinks = Wiselinks