require('jquery.cookie/jquery.cookie')

module.exports = class IntroVideo

  constructor: (container)->
    @loadApi()

    @container = $(container)
    @videoWrap = @container.find('.intro-video-wrap')
    @overlay = @container.find('.intro-video-overlay')
    @closeButton = @container.find('.intro-video-close')
    @cookieName = 'hide_intro_video'

    @initStructure()
    @bindEvents()

  loadApi: ->
    tag = document.createElement('script')
    tag.src = "https://www.youtube.com/iframe_api";
    firstScriptTag = document.getElementsByTagName('script')[0]
    firstScriptTag.parentNode.insertBefore(tag, firstScriptTag)

  initStructure: ->
    @trigger = $('<button type="button" id="intro-video-toggler">Play Video <span>Again</span></button>')
    @trigger.appendTo('body')

  bindEvents: ->
    @trigger.on 'click', (e)=>
      e.preventDefault()
      e.stopPropagation()

      @showVideo()

    @overlay.on 'click.introvideo', (e)=>
      @hideVideo()

    @closeButton.on 'click.introvideo', (e)=>
      @hideVideo()

    window.onYouTubeIframeAPIReady = =>
      @player = new YT.Player 'intro-player', {
        height: 1280
        width: 720
        videoId: 'W3d4gNLUJzE'
        events:
          onReady: @onPlayerReady
          onStateChange: @onPlayerStateChange
        playerVars:
          rel: 0
      }

  bindOnShow: ->
    $('body').on 'keydown.introvideo', (e)=>
      if e.which == 27 # Hitting escape
        @hideVideo()


  onPlayerStateChange: (event)=>
    if event.data == YT.PlayerState.ENDED
      @hideVideo()

  onPlayerReady: (event) =>
    return if @container.hasClass 'inactive'

    unless Modernizr.touchevents
      event.target.mute()
      event.target.playVideo()
    @bindOnShow()

  hideVideo: ->
    @container.addClass('inactive')
    $.cookie(@cookieName, 1, { expires: 28, path: '/' })
    @player.stopVideo()

    $('body').off('*.introvideo')

  showVideo: ->
    @container.removeClass('inactive')

    unless Modernizr.touchevents
      @player.playVideo() if @player.playVideo
    @bindOnShow()

