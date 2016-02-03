class ComponentBase
  components = []
  @attr_value = null
  constructor: (el) ->
    if !@name
      new Error("#{typeof this} does not have #name")
    @$el = $(el)
    @el = el
    @attr_value = @$el.attr("data-#{@name}")
    components.push(@$el)
    @$el

  initializeComponent: (klass) ->
    @$el.find("[data-#{klass::name}]").map (_, el) ->
      new klass(el)

  initializeComponents: () ->
    @initializeComponent(MapInput)
    @initializeComponent(S3Uploader)
    @initializeComponent(Slate)

window.ComponentBase = ComponentBase
