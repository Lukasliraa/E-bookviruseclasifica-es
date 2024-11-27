local composer = require( "composer" )
 
local scene = composer.newScene()
 
local MARGIN = 90
 
function scene:create( event )
    local sceneGroup = self.view

    local backgroud = display.newImageRect(sceneGroup, "FUNDOS/fundo2.png", 768, 1024)

    backgroud.x = display.contentCenterX
    backgroud.y = display.contentCenterY

    local botaoproximo = display.newImage(sceneGroup, "BOTOES/proximo.png")
    botaoproximo.x = display.contentWidth - botaoproximo.width/2 - MARGIN +44
    botaoproximo.y = display.contentHeight - botaoproximo.height/2 - MARGIN +10

    botaoproximo:addEventListener("tap", function (event)
        composer.gotoScene("tela3", {
            effect = "fade",
            time = 500
        });
        
    end)

    local botaoanterior = display.newImage(sceneGroup, "BOTOES/anterior.png")
    botaoanterior.x = display.contentWidth - botaoanterior.width/2 - MARGIN -525
    botaoanterior.y = display.contentHeight - botaoanterior.height/2 - MARGIN +10

    local som = display.newImage(sceneGroup, "BOTOES/somligado.png")
    som.x = display.contentWidth - som.width / 2 - MARGIN -470
    som.y = display.contentHeight - som.height / 2 - MARGIN -770

    botaoanterior:addEventListener("tap", function (event)
        composer.gotoScene("tela1", {
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
scene:addEventListener( "destroy", scene )

return scene
