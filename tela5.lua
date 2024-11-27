local composer = require( "composer" )
 
local scene = composer.newScene()

local physics = require("physics")
local MARGIN = 90
local viruses = {}

physics.start()
physics.setGravity(0, 0) 

local function onVirusTap(event)
    local virus = event.target
    display.remove(virus) -- Remove o vírus ao toque
end

local function createVirus()
    local virus = display.newImageRect("ELEMENTOS/virus2.png", 50, 50)
    virus.x = math.random(50, display.contentWidth - 50)
    virus.y = math.random(50, display.contentHeight - 50)
    physics.addBody(virus, "dynamic", {radius = 25, bounce = 0.5})
    virus:setLinearVelocity(math.random(-50, 50), math.random(-50, 50)) -- Movimento aleatório
    virus.isVirus = true -- Identificador para colisão
    return virus
end

local function resetViruses(sceneGroup)
    -- Remove os vírus existentes
    for i = #viruses, 1, -1 do
        display.remove(viruses[i])
        table.remove(viruses, i)
    end

    -- Criar novos vírus
    for i = 1, 50 do -- Altere "50" para o número desejado de partículas
        local virus = createVirus()
        table.insert(viruses, virus)
        virus:addEventListener("tap", onVirusTap) -- Listener para toque
        sceneGroup:insert(virus) -- Adicionar o vírus ao grupo da cena
    end
end


local function onCollision(event)
    if event.phase == "began" then
        local obj1 = event.object1
        local obj2 = event.object2

        -- Verifica se um dos objetos é o vírus e o outro é a célula
        if (obj1.isVirus and obj2.isCell) or (obj2.isVirus and obj1.isCell) then
            local virus = obj1.isVirus and obj1 or obj2
            display.remove(virus) -- Remove o vírus
        end
    end
end

Runtime:addEventListener("collision", onCollision)

 
function scene:create( event )
    local sceneGroup = self.view

    local backgroud = display.newImageRect(sceneGroup, "FUNDOS/fundo5.png", 768, 1024)

    backgroud.x = display.contentCenterX
    backgroud.y = display.contentCenterY

        -- Célula (substitua "ELEMENTOS/celula.png")
    local nar = display.newImageRect(sceneGroup, "ELEMENTOS/nariz.png", 250, 200)
    nar.x = display.contentCenterX - nar.width / 2 - MARGIN +490
    nar.y = display.contentCenterY - nar.width / 2 - MARGIN -150
    physics.addBody(nar, "static", {radius = 75}) -- Corpo estático para colisão
    nar.isCell = true -- Identificador para colisão

    
    local botaoproximo = display.newImage(sceneGroup, "BOTOES/proximo.png")
    botaoproximo.x = display.contentWidth - botaoproximo.width/2 - MARGIN +44
    botaoproximo.y = display.contentHeight - botaoproximo.height/2 - MARGIN +10

    botaoproximo:addEventListener("tap", function (event)
        composer.gotoScene("contracapa", {
            effect = "fade",
            time = 500
        });
        
    end)

    local botaoanterior = display.newImage(sceneGroup, "BOTOES/anterior.png")
    botaoanterior.x = display.contentWidth - botaoanterior.width/2 - MARGIN -525
    botaoanterior.y = display.contentHeight - botaoanterior.height/2 - MARGIN +10

    botaoanterior:addEventListener("tap", function (event)
        composer.gotoScene("tela4", {
            effect = "fade",
            time = 500
        });
           
        end)

    local som = display.newImage(sceneGroup, "BOTOES/somligado.png")
    som.x = display.contentWidth - som.width / 2 - MARGIN -470
    som.y = display.contentHeight - som.height / 2 - MARGIN -770 

    resetViruses(sceneGroup)

     -- Gerar partículas de vírus
     for i = 1, 50 do -- Altere "10" para o número desejado de partículas
        local virus = createVirus()
        table.insert(viruses, virus)
        virus:addEventListener("tap", onVirusTap) -- Listener para toque
        sceneGroup:insert(virus) -- Adicionar o vírus ao grupo da cena
    end
end
 
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
    elseif ( phase == "did" ) then
        resetViruses(sceneGroup)

    end
end
 
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
    elseif ( phase == "did" ) then
        for i = #viruses, 1, -1 do
            display.remove(viruses[i])
            table.remove(viruses, i)
        end
    elseif (phase == "did") then
        -- Outras ações após a cena ser ocultada
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
