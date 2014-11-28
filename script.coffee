
# GLOBAL 
debug = (caller,sentence) ->
    console.info caller+' :: '+sentence

# ANGULAR

app = angular.module 'main',[]
inputControl = app.controller 'inputController', ->
    @value=''
    return
    
optionControl = app.controller 'optionController', ->
    @mode = 0
    
# FUNCTIONS
colorToHex = (rgb) ->
  rgb = rgb.match(/^rgba?[\s+]?\([\s+]?(\d+)[\s+]?,[\s+]?(\d+)[\s+]?,[\s+]?(\d+)[\s+]?/i)
  (if (rgb and rgb.length is 4) then "#" + ("0" + parseInt(rgb[1], 10).toString(16)).slice(-2) + ("0" + parseInt(rgb[2], 10).toString(16)).slice(-2) + ("0" + parseInt(rgb[3], 10).toString(16)).slice(-2) else "")
convertColor = (value) ->
    debug 'converting',value
    if `value.substr(0,1) == '#'`
        # hex
        debug 'colorMode','input = hex'
        console.dir Please.HEX_to_HSV(value)
        return Please.HEX_to_HSV(value)
    else if `value.substr(0,3) == 'rgb'`
        # rgb
        debug 'colorMode','input = rgb or rgba'
        processed = colorToHex value
        console.log processed
        console.dir Please.HEX_to_HSV(processed)
        return Please.HEX_to_HSV(processed)
    else if `value.substr(0,3) == 'hsv'`
        # hsv
        debug 'colorMode','input = hsv'
        return value
    
generate = (base,mode) ->
    debug 'base',base
    debug 'mode',mode
    if mode != 'none'
        return Please.make_scheme base,{'scheme_type':mode}
    else
        return Please.make_scheme base,{}

# Class
palette = (base,inmode) ->
    @mode = inmode
    @scheme = generate base,inmode
    return
    
# EFFECTS AND LOGIC
$(document).ready ->
    # GLOBAL VAR
    inputVal = ''
    schemeContainer = $('#schemeView ul.colors-display')
    
    # UI
    UI = 
        makeColorHtml: (name,bg,rgb,hsv,width) ->
            return '<li class="scheme-color" style="width:'+width+'%"> <div class="card" style="background:'+bg+'"> <span class="color-name">'+name+'</span> <ul class="color-values"> <li class="value-hex"><strong>HEX: </strong>'+bg+'</li> <li class="value-rgb"><strong>RGB: </strong>'+rgb+'</li> <li class="hsv"><strong>HSV: </strong>'+hsv+'</li> </ul> </div> </li> '
        showScheme: (scheme) ->
            schemeContainer.html('') #clear the container
            width = 100/scheme[0...4].length
            debug 'misc',width
            for color in scheme[0...4]
                match = ntc.name(color)
                console.log(match)
                rgbRAW = Please.HEX_to_RGB(color)
                hsvRAW = Please.HEX_to_HSV(color)
                rgb = 'rgb('+rgbRAW.r+','+rgbRAW.g+','+rgbRAW.b+')'
                hsv = 'hsv('+hsvRAW.h.toString().substring(0,3)+','+hsvRAW.s.toString().substring(0,4)+','+hsvRAW.v.toString().substring(0,4)+')'
                schemeContainer.append(UI.makeColorHtml match[1],color,rgb,hsv,width)
    
    # Functions
    hideview = (view) ->
        debug 'hideView','hided '+view
        $('#'+view+'View').css {
            'margin-top':'30px',
            'opacity':'0',
            'z-index':'-1'
        }
        return
    showview = (view) ->
        debug 'showView','shown '+view
        $('#'+view+'View').css {
            'margin-top':'0',
            'opacity':'1',
            'z-index':'1'
        }
        return
    getMode = ->
        options = $('#options ul li')
        selectedOption = 'none'
        for x in options
            if $(x).attr('class') == 'active'
                selectedOption = x.innerHTML.toLowerCase()
        return selectedOption
    colorSubmitted = ->
        if inputVal != '?'
            baseColor = convertColor inputVal
        else
            baseColor = convertColor Please.make_color()
        selectedMode = getMode()
        generated = new palette baseColor,selectedMode
        debug '.hidden.click','generated scheme: '+generated.scheme
        hideview 'input'
        showview 'scheme'
        return generated.scheme
    
    $('#input-wrap input').keyup ->
        debug 'input.keyup',"value entered: "+this.value
        inputVal = this.value
        $(this).css 'color',this.value 
    $('.hidden').click ->
        UI.showScheme(colorSubmitted())
        return
    # $('#schemeView').on 'click','.scheme-color div.card', ->
    #     $('#shadeView').css 
    #         'z-index': 800
    #         'opacity': 1
    #     $('#shadeView').css 'background', $(this).css 'background'
    #     return

    return




