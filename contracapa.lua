local composer = require( "composer" )
 
local scene = composer.newScene()
local audio = require("audio") -- Módulo de áudio do Corona

local MARGIN = 75
local somAtivo -- Variável para armazenar o canal do som tocando, se necessário

local somAudio = audio.loadSound("audios/audiocontracapa.mp3")

function scene:create( event )
    local sceneGroup = self.view

    local background = display.newImageRect(sceneGroup, "FUNDOS/Contra.png", 768, 1024)

    background.x = display.contentCenterX
    background.y = display.contentCenterY

    local botaoanterior = display.newImage(sceneGroup, "BOTOES/anterior.png")
    botaoanterior.x = display.contentWidth - botaoanterior.width/2 - MARGIN - 540
    botaoanterior.y = display.contentHeight - botaoanterior.height/2 - MARGIN -10

    botaoanterior:addEventListener("tap", function (event)
        composer.gotoScene("tela5", {
            effect = "fade",
            time = 500
        });
        
    end)

    local voltartudo = display.newImage(sceneGroup, "BOTOES/inicio.png")
    voltartudo.x = display.contentWidth - voltartudo.width/2 - MARGIN +30
    voltartudo.y = display.contentHeight - voltartudo.height/2 - MARGIN +5

    -- Função para alternar som ligado/desligado
    local somLigado = false
    local som = display.newImage(sceneGroup, "BOTOES/somdesligado.png")
    som.x = display.contentWidth - som.width / 2 - MARGIN - 480
    som.y = display.contentHeight - som.height / 2 - MARGIN - 790

-- Função para alternar som ligado/desligado
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

            -- Tocar o som
            somAtivo = audio.play(somAudio, {loops = 0})
            print("Som ligado")
        end
        return true
    end

    som:addEventListener("tap", toggleSom)

    voltartudo:addEventListener("tap", function (event)
        composer.gotoScene("Capa", {
            effect = "fade",
            time = 500
        });
    
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
scene:addEventListener( "destroy", scene)

return scene
