#= require _request_manager

class Page
  constructor: (@$target, @options) ->
    self = this

    @template_id = new Date().getTime()
    @request_manager = new _Wiselinks.RequestManager(@options)

    selector = @$target
    @$target = self._wrap(@$target)

    self._try_target(@$target, selector)

    # Handle browser back/forward navigation
    $(window).on 'popstate', (event) ->
      self._onStateChange()

    $(document).on(
      'click', 'a[data-push], a[data-replace]'
      (event) ->
        if (link = new _Wiselinks.Link(self, $(this))).allows_process(event)
          event.preventDefault()
          link.process()

          return false
    )

    $(document).on(
      'submit', 'form[data-push], form[data-replace]'
      (event) ->
        if (form = new _Wiselinks.Form(self, $(this)))
          event.preventDefault()
          form.process()

          return false
    )

  load: (url, target, render = 'template') ->
    @template_id = new Date().getTime() if render != 'partial'

    selector = if target?
      $target = this._wrap(target)
      this._try_target($target, target)
      $target.selector || target

    history.pushState({
      timestamp: (new Date().getTime()),
      template_id: @template_id,
      render: render,
      target: selector,
      referer: window.location.href
    }, document.title, url )

    this._onStateChange()

  reload: () ->
    history.replaceState({
      timestamp: (new Date().getTime()),
      template_id: @template_id,
      render: 'template',
      referer: window.location.href
    }, document.title, window.location.href )

    this._onStateChange()

  _onStateChange: ->
    state = this._getState()

    if this._template_id_changed(state)
      this._call(this._reset_state(state))
    else
      this._call(state)

  _getState: ->
    {
      url: window.location.href,
      data: history.state || {}
    }

  _call: (state) ->
    $target = if state.data.target? then $(state.data.target) else @$target
    this.request_manager.call($target, state)

  _template_id_changed: (state) ->
    !state.data.template_id? || state.data.template_id != @template_id

  _make_state: (url, target, render = 'template', referer) ->
    {
      url: url
      data:
        target: target
        render: render
        referer: referer
    }

  _reset_state: (state) ->
    state.data = {} unless state.data?
    state.data.target = null
    state.data.render = 'template'
    state

  _try_target: ($target, selector) ->
    if $target.length == 0  && @options.target_missing == 'exception'
      throw new Error("[Wiselinks] Target missing: `#{$target.selector || selector}`")

  _wrap: (object) ->
    $(object)


window._Wiselinks = {} if window._Wiselinks == undefined
window._Wiselinks.Page = Page
