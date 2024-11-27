local composer = require( "composer" )
 
local scene = composer.newScene()
 
local MARGIN = 75
 
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

    local som = display.newImage(sceneGroup, "BOTOES/somligado.png")
    som.x = display.contentWidth - som.width / 2 - MARGIN -480
    som.y = display.contentHeight - som.height / 2 - MARGIN -785 

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

    elseif ( phase == "did" ) then

    end
end
 
function scene:destroy( event )
 
    local sceneGroup = self.view

end
 
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene)

return scene
