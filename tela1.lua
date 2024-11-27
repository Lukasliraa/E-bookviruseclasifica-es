local composer = require( "composer" )
 
local scene = composer.newScene()
 
local MARGIN = 90
 
function scene:create( event )
    local sceneGroup = self.view

    local backgroud = display.newImageRect(sceneGroup, "FUNDOS/fundo1.png", 768, 1024)

    backgroud.x = display.contentCenterX
    backgroud.y = display.contentCenterY

    local botaoproximo = display.newImage(sceneGroup, "BOTOES/proximo.png")
    botaoproximo.x = display.contentWidth - botaoproximo.width/2 - MARGIN +44

    botaoproximo.y = display.contentHeight - botaoproximo.height/2 - MARGIN +10

    botaoproximo:addEventListener("tap", function (event)
        composer.gotoScene("tela2", {
            effect = "fade",
            time = 500
        });
        
    end)

    local botaoanterior = display.newImage(sceneGroup, "BOTOES/anterior.png")
    botaoanterior.x = display.contentWidth - botaoanterior.width/2 - MARGIN -525

    botaoanterior.y = display.contentHeight - botaoanterior.height/2 - MARGIN +10
    botaoanterior:addEventListener("tap", function (event)
        composer.gotoScene("capa", {
            effect = "fade",
            time = 500
        });
    
    end) 

    local som = display.newImage(sceneGroup, "BOTOES/somligado.png")
    som.x = display.contentWidth - som.width / 2 - MARGIN -470
    som.y = display.contentHeight - som.height / 2 - MARGIN -770  

    local virus = display.newImageRect("ELEMENTOS/estruturavirus.png", 200, 150)
    virus.x, virus.y = 150, 420
    sceneGroup:insert(virus)

    local function onVirusTap()
        transition.to(virus, {time=3000, xScale=2, yScale=2, rotation=360, onComplete=function()
        transition.to(virus, {time=3000, xScale=1, yScale=1, rotation=0})   
        end})
    end
        virus:addEventListener("tap", onVirusTap)
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
