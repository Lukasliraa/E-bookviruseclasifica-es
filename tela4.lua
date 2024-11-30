local composer = require( "composer" )
 
local scene = composer.newScene()
local audio = require("audio") -- Módulo de áudio do Corona

local MARGIN = 90
local somAtivo -- Variável para armazenar o canal do som tocando, se necessário

local somAudio = audio.loadSound("audios/audio4.mp3")

 
function scene:create( event )
    local sceneGroup = self.view

    local backgroud = display.newImageRect(sceneGroup, "FUNDOS/fundo4.png", 768, 1024)

    backgroud.x = display.contentCenterX
    backgroud.y = display.contentCenterY

    local botaoproximo = display.newImage(sceneGroup, "BOTOES/proximo.png")
    botaoproximo.x = display.contentWidth - botaoproximo.width/2 - MARGIN +44
    botaoproximo.y = display.contentHeight - botaoproximo.height/2 - MARGIN +10

    botaoproximo:addEventListener("tap", function (event)
        composer.gotoScene("tela5", {
            effect = "fade",
            time = 500
        });
        
    end)

    local botaoanterior = display.newImage(sceneGroup, "BOTOES/anterior.png")
    botaoanterior.x = display.contentWidth - botaoanterior.width/2 - MARGIN -525
    botaoanterior.y = display.contentHeight - botaoanterior.height/2 - MARGIN +10

    botaoanterior:addEventListener("tap", function (event)
        composer.gotoScene("tela3", {
            effect = "fade",
            time = 500
        });

    end)
    local som = display.newImage(sceneGroup, "BOTOES/somdesligado.png")
    som.x = display.contentWidth - som.width / 2 - MARGIN - 470
    som.y = display.contentHeight - som.height / 2 - MARGIN - 775

-- Função para alternar som ligado/desligado
    local somLigado = false
    local function toggleSom(event)
        if somLigado then
            somLigado = false
            som.fill = {type = "image", filename = "BOTOES/somdesligado.png"}
            som.x = display.contentWidth - som.width / 2 - MARGIN - 470
            som.y = display.contentHeight - som.height / 2 - MARGIN - 756
        -- Parar o som
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
        
        
            somAtivo = audio.play(somAudio, {loops = 0}) -- loops = 0 garante que o som toque apenas uma vez
            print("Som ligado")
        end
        return true
    end
    som:addEventListener("tap", toggleSom)
    
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
