local composer = require( "composer" )
 
local scene = composer.newScene()
local audio = require("audio") 
 
local MARGIN = 90
local somAtivo 

local somAudio = audio.loadSound("audios/audiocapa.mp3")

function scene:create( event )
    local sceneGroup = self.view

    
    local backgroud = display.newImageRect(sceneGroup, "FUNDOS/Capa.png", 768, 1024)
    backgroud.x = display.contentCenterX
    backgroud.y = display.contentCenterY
    
   
    local botaoproximo = display.newImage(sceneGroup, "BOTOES/proximo.png")
    botaoproximo.x = display.contentWidth - botaoproximo.width / 2 - MARGIN + 44
    botaoproximo.y = display.contentHeight - botaoproximo.height / 2 - MARGIN + 10

  
    local somLigado = false -- O som começa desligado
    local som = display.newImage(sceneGroup, "BOTOES/somdesligado.png")
    som.x = display.contentWidth - som.width / 2 - MARGIN - 470
    som.y = display.contentHeight - som.height / 2 - MARGIN - 775

   
    local function toggleSom(event)
        if somLigado then
            somLigado = false
            som.fill = {type = "image", filename = "BOTOES/somdesligado.png"}
            som.x = display.contentWidth - som.width / 2 - MARGIN - 470
            som.y = display.contentHeight - som.height / 2 - MARGIN - 756

           
            if somAtivo then
                audio.stop(somAtivo)
                somAtivo = nil
            end
            print("Som desligado")
        else
            somLigado = true
            som.fill = {type = "image", filename = "BOTOES/somligado.png"}
            som.x = display.contentWidth - som.width / 2 - MARGIN - 470
            som.y = display.contentHeight - som.height / 2 - MARGIN - 770

      
            somAtivo = audio.play(somAudio, {loops = 0})
            print("Som ligado")
        end
        return true
    end

    som:addEventListener("tap", toggleSom)

    botaoproximo:addEventListener("tap", function(event)
        composer.gotoScene("tela1", {
            effect = "fade",
            time = 500
        })
    end)
end
 
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
 
    elseif ( phase == "did" ) then
    
    end
end
 
function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        if somAtivo then
            audio.stop(somAtivo)
            somAtivo = nil
        end
    elseif ( phase == "did" ) then
  
    end
end
 
function scene:destroy( event )
    local sceneGroup = self.view
    if somAudio then
        audio.dispose(somAudio)
        somAudio = nil
    end
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene
