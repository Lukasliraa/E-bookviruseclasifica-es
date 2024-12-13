local composer = require("composer")
local scene = composer.newScene()
local audio = require("audio") -- Módulo de áudio do Corona
local physics = require("physics")
local MARGIN = 90
local somAtivo -- Variável para armazenar o canal do som tocando, se necessário
local somAudio = audio.loadSound("audios/audio5.mp3")
local espirroAudio = audio.loadSound("audios/espiro1.mp3") -- Som de espirro
local viruses = {}

physics.start()
physics.setGravity(0, 0)

local function onVirusTouch(event)
    local virus = event.target

    if event.phase == "began" then
        -- Marca a posição inicial do toque
        display.currentStage:setFocus(virus)
        virus.touchOffsetX = event.x - virus.x
        virus.touchOffsetY = event.y - virus.y
    elseif event.phase == "moved" then
        -- Atualiza a posição do vírus enquanto o dedo se move
        virus.x = event.x - virus.touchOffsetX
        virus.y = event.y - virus.touchOffsetY
    elseif event.phase == "ended" or event.phase == "cancelled" then
        -- Remove o foco após o toque ser liberado
        display.currentStage:setFocus(nil)
    end
    return true
end

local function onVirusTap(event)
    local virus = event.target

    -- Alterar a imagem do vírus para 'virusama' e alterar a cor antes de desaparecer
    virus.fill = { type = "image", filename = "ELEMENTOS/virus.png" }

    -- Animação de transição para mostrar a mudança de cor
    transition.to(virus, {
        time = 500,
        alpha = 0, -- Faz o vírus desaparecer após a animação
        onComplete = function()
            display.remove(virus) -- Remove o vírus após a animação
        end
    })
end

local function createVirus()
    local virus = display.newImageRect("ELEMENTOS/virus2.png", 50, 50)
    virus.x = math.random(50, display.contentWidth - 50)
    virus.y = math.random(50, display.contentHeight - 50)
    physics.addBody(virus, "dynamic", {radius = 25, bounce = 0.5})
    virus:setLinearVelocity(math.random(-50, 50), math.random(-50, 50)) -- Movimento aleatório
    virus.isVirus = true -- Identificador para colisão

    -- Adiciona o listener de toque para permitir o arrasto
    virus:addEventListener("touch", onVirusTouch)
    return virus
end

local function resetViruses(sceneGroup)
    -- Remove os vírus existentes
    for i = #viruses, 1, -1 do
        display.remove(viruses[i])
        table.remove(viruses, i)
    end

    -- Criar novos vírus
    for i = 1, 30 do -- Altere "75" para o número desejado de partículas
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
            local cell = obj1.isCell and obj1 or obj2

            -- Se for a célula, muda a imagem para 'nariz2.png'
            if cell.isCell then
                cell.fill = { type = "image", filename = "ELEMENTOS/nariz2.png" }
                audio.play(espirroAudio) -- Toca o som de espirro
                -- Animação para voltar à imagem original após um segundo
                timer.performWithDelay(1000, function()
                    if cell.isCell then
                        cell.fill = { type = "image", filename = "ELEMENTOS/nariz.png" }
                    end
                end)
            end

            -- Remove o vírus após a colisão
            display.remove(virus)
            for i, v in ipairs(viruses) do
                if v == virus then
                    table.remove(viruses, i)
                    break
                end
            end
        end
    end
end

Runtime:addEventListener("collision", onCollision)

function scene:create(event)
    local sceneGroup = self.view

    local backgroud = display.newImageRect(sceneGroup, "FUNDOS/fundo5.png", 768, 1024)
    backgroud.x = display.contentCenterX
    backgroud.y = display.contentCenterY

    -- Célula (substitua "ELEMENTOS/celula.png")
    local nar = display.newImageRect(sceneGroup, "ELEMENTOS/nariz.png", 250, 200)
    nar.x = display.contentCenterX - nar.width / 2 - MARGIN + 490
    nar.y = display.contentCenterY - nar.width / 2 - MARGIN - 150
    physics.addBody(nar, "static", {radius = 75}) -- Corpo estático para colisão
    nar.isCell = true -- Identificador para colisão

    local botaoproximo = display.newImage(sceneGroup, "BOTOES/proximo.png")
    botaoproximo.x = display.contentWidth - botaoproximo.width / 2 - MARGIN + 44
    botaoproximo.y = display.contentHeight - botaoproximo.height / 2 - MARGIN + 10

    botaoproximo:addEventListener("tap", function(event)
        composer.gotoScene("contracapa", {
            effect = "fade",
            time = 500
        })
    end)

    local botaoanterior = display.newImage(sceneGroup, "BOTOES/anterior.png")
    botaoanterior.x = display.contentWidth - botaoanterior.width / 2 - MARGIN - 525
    botaoanterior.y = display.contentHeight - botaoanterior.height / 2 - MARGIN + 10

    botaoanterior:addEventListener("tap", function(event)
        composer.gotoScene("tela4", {
            effect = "fade",
            time = 500
        })
    end)

    local somLigado = false
    local som = display.newImage(sceneGroup, "BOTOES/somdesligado.png")
    som.x = display.contentWidth - som.width / 2 - MARGIN - 470
    som.y = display.contentHeight - som.height / 2 - MARGIN - 775

    -- Função para alternar som ligado/desligado
    local function toggleSom(event)
        if somLigado then
            somLigado = false
            som.fill = { type = "image", filename = "BOTOES/somdesligado.png" }
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
            som.fill = { type = "image", filename = "BOTOES/somligado.png" }
            som.x = display.contentWidth - som.width / 2 - MARGIN - 470
            som.y = display.contentHeight - som.height / 2 - MARGIN - 770
            somAtivo = audio.play(somAudio, { loops = 0 }) -- loops = 0 garante que o som toque apenas uma vez
            print("Som ligado")
        end
        return true
    end

    som:addEventListener("tap", toggleSom)

    resetViruses(sceneGroup)

    -- Gerar partículas de vírus
    for i = 1, 50 do -- Altere "50" para o número desejado de partículas
        local virus = createVirus()
        table.insert(viruses, virus)
        virus:addEventListener("tap", onVirusTap) -- Listener para toque
        sceneGroup:insert(virus) -- Adicionar o vírus ao grupo da cena
    end
end

function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
    elseif (phase == "did") then
        resetViruses(sceneGroup)
    end
end

function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
    elseif (phase == "did") then
        if somAtivo then
            audio.stop(somAtivo)
            somAtivo = nil
        end
        for i = #viruses, 1, -1 do
            display.remove(viruses[i])
            table.remove(viruses, i)
        end
    end
end

function scene:destroy(event)
    local sceneGroup = self.view
    if somAudio then
        audio.dispose(somAudio)
        somAudio = nil
    end
    if espirroAudio then
        audio.dispose(espirroAudio)
        espirroAudio = nil
    end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
