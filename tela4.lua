local composer = require("composer")
local audio = require("audio")
local scene = composer.newScene()

-- Configurações
local MARGIN = 90
local somAtivo -- Variável para armazenar o canal do som tocando, se necessário
local somAudio = audio.loadSound("audios/audio4.mp3")

local virus1, virus2, virus3, virus4
local smallViruses = {} -- Tabela para armazenar os vírus pequenos

-- Função para mover os vírus para uma posição mais próxima da célula
local function moveVirusesCloser()
    -- Remover os vírus antigos
    if virus1 then virus1:removeSelf() end
    if virus2 then virus2:removeSelf() end
    if virus3 then virus3:removeSelf() end
    if virus4 then virus4:removeSelf() end

    -- Adiciona novos vírus mais próximos
    virus1 = display.newImageRect("ELEMENTOS/virusinfect.png", 150, 80)
    virus1.x, virus1.y = 550, 400
    scene.view:insert(virus1)

    virus2 = display.newImageRect("ELEMENTOS/virusinfect.png", 150, 80)
    virus2.x, virus2.y = 650, 520
    scene.view:insert(virus2)

    virus3 = display.newImageRect("ELEMENTOS/virusinfect.png", 150, 80)
    virus3.x, virus3.y = 550, 520
    scene.view:insert(virus3)

    virus4 = display.newImageRect("ELEMENTOS/virusinfect.png", 150, 80)
    virus4.x, virus4.y = 650, 400
    scene.view:insert(virus4)

    -- Chama a função para adicionar os vírus pequenos após mover os outros
    createSmallViruses()
end

-- Função para criar vírus pequenos no centro da célula
local function createSmallViruses()
    -- Apaga os vírus pequenos se já existirem
    for i = 1, #smallViruses do
        smallViruses[i]:removeSelf()
    end
    smallViruses = {} -- Limpa a tabela

    -- Adiciona 5 vírus pequenos no centro da célula
    for i = 1, 5 do
        local smallVirus = display.newImageRect("ELEMENTOS/virusbact.png", 50, 30)  -- Tamanho menor
        smallVirus.x = 600 + math.random(-50, 50)  -- Posições aleatórias ao redor do centro
        smallVirus.y = 420 + math.random(-50, 50)
        scene.view:insert(smallVirus)
        table.insert(smallViruses, smallVirus)
    end
end

-- Função que detecta a aceleração do dispositivo
local function onAccelerate(event)
    local shakeThreshold = 15  -- Aumentado para um movimento mais "forte"
    if math.abs(event.x) > shakeThreshold or math.abs(event.y) > shakeThreshold or math.abs(event.z) > shakeThreshold then
        -- Se o dispositivo foi "balançado", executa a ação desejada (ex: mover vírus)
        moveVirusesCloser()
    end
end

function scene:create(event)
    local sceneGroup = self.view

    -- Fundo da cena
    local background = display.newImageRect(sceneGroup, "FUNDOS/fundo4.png", 768, 1024)
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    -- Botões de navegação
    local botaoproximo = display.newImage(sceneGroup, "BOTOES/proximo.png")
    botaoproximo.x = display.contentWidth - botaoproximo.width / 2 - MARGIN + 44
    botaoproximo.y = display.contentHeight - botaoproximo.height / 2 - MARGIN + 10
    botaoproximo:addEventListener("tap", function()
        composer.gotoScene("tela5", {effect = "fade", time = 500})
    end)

    local botaoanterior = display.newImage(sceneGroup, "BOTOES/anterior.png")
    botaoanterior.x = display.contentWidth - botaoanterior.width / 2 - MARGIN - 525
    botaoanterior.y = display.contentHeight - botaoanterior.height / 2 - MARGIN + 10
    botaoanterior:addEventListener("tap", function()
        composer.gotoScene("tela3", {effect = "fade", time = 500})
    end)

    -- Botão de som
    local som = display.newImage(sceneGroup, "BOTOES/somdesligado.png")
    som.x = display.contentWidth - som.width / 2 - MARGIN - 470
    som.y = display.contentHeight - som.height / 2 - MARGIN - 775

    local somLigado = false
    local function toggleSom()
        if somLigado then
            somLigado = false
            som.fill = {type = "image", filename = "BOTOES/somdesligado.png"}
            if somAtivo then
                audio.stop(somAtivo)
                somAtivo = nil
            end
        else
            somLigado = true
            som.fill = {type = "image", filename = "BOTOES/somligado.png"}
            somAtivo = audio.play(somAudio, {loops = 0})
        end
        return true
    end
    som:addEventListener("tap", toggleSom)

    -- Imagem da célula
    local virus = display.newImageRect("ELEMENTOS/celulainfct.png", 600, 350)
    virus.x, virus.y = 600, 420
    sceneGroup:insert(virus)

    -- Adicionando os 4 vírus ao redor da célula
    virus1 = display.newImageRect("ELEMENTOS/virusbact.png", 150, 80)
    virus1.x, virus1.y = 500, 320
    sceneGroup:insert(virus1)

    virus2 = display.newImageRect("ELEMENTOS/virusbact.png", 150, 80)
    virus2.x, virus2.y = 700, 620
    sceneGroup:insert(virus2)

    virus3 = display.newImageRect("ELEMENTOS/virusbact.png", 150, 80)
    virus3.x, virus3.y = 500, 620
    sceneGroup:insert(virus3)

    virus4 = display.newImageRect("ELEMENTOS/virusbact.png", 150, 80)
    virus4.x, virus4.y = 700, 320
    sceneGroup:insert(virus4)
end

function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "did") then
        -- Habilitar o acelerômetro somente se estiver disponível
        if system.hasEventSource("accelerometer") then
            Runtime:addEventListener("accelerate", onAccelerate)
        else
            print("Acelerômetro não disponível nesta plataforma.")
        end
    end
end

function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Remover o ouvinte do acelerômetro quando a cena for ocultada
        Runtime:removeEventListener("accelerate", onAccelerate)
    end
end

function scene:destroy(event)
    local sceneGroup = self.view
    -- Código para limpar recursos, se necessário
    if somAtivo then
        audio.stop(somAtivo)
        somAtivo = nil
    end
    if somAudio then
        audio.dispose(somAudio)
        somAudio = nil
    end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
