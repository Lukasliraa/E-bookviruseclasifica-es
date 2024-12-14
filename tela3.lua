local composer = require("composer")
local scene = composer.newScene()
local audio = require("audio") -- Módulo de áudio do Corona

local MARGIN = 90
local somAtivo -- Variável para armazenar o canal do som tocando, se necessário
local somAudio = audio.loadSound("audios/audio3.mp3")

local images = {
    { path = "ELEMENTOS/dna.png", x = 200, y = 450 },  -- Posição da imagem 1
    { path = "ELEMENTOS/rna.png", x = 200, y = 450 },  -- Posição da imagem 
    { path = "ELEMENTOS/mutacao.png", x = 200, y = 450 },  -- Posição da imagem 3
    { path = "ELEMENTOS/bacteriofago.png", x = 200, y = 450 }  -- Posição da imagem 4
}

local currentImageIndex = 1
local conceptImage
local pinchDistance = 0
local pinchInProgress = false

function scene:create(event)
    local sceneGroup = self.view

    local background = display.newImageRect(sceneGroup, "FUNDOS/fundo3.png", 768, 1024)
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    -- Inicializar a imagem inicial com a nova posição
    conceptImage = display.newImageRect(sceneGroup, images[currentImageIndex].path, 300, 300)
    conceptImage.x = images[currentImageIndex].x
    conceptImage.y = images[currentImageIndex].y

    -- Botão próximo
    local botaoproximo = display.newImage(sceneGroup, "BOTOES/proximo.png")
    botaoproximo.x = display.contentWidth - botaoproximo.width / 2 - MARGIN + 44
    botaoproximo.y = display.contentHeight - botaoproximo.height / 2 - MARGIN + 10

    botaoproximo:addEventListener("tap", function(event)
        composer.gotoScene("tela4", { effect = "fade", time = 500 })
    end)

    -- Botão anterior
    local botaoanterior = display.newImage(sceneGroup, "BOTOES/anterior.png")
    botaoanterior.x = display.contentWidth - botaoanterior.width / 2 - MARGIN - 525
    botaoanterior.y = display.contentHeight - botaoanterior.height / 2 - MARGIN + 10

    botaoanterior:addEventListener("tap", function(event)
        composer.gotoScene("tela2", { effect = "fade", time = 500 })
    end)

    -- Botão som
    local som = display.newImage(sceneGroup, "BOTOES/somdesligado.png")
    som.x = display.contentWidth - som.width / 2 - MARGIN - 470
    som.y = display.contentHeight - som.height / 2 - MARGIN - 775

    local somLigado = false
    local function toggleSom(event)
        if somLigado then
            somLigado = false
            som.fill = { type = "image", filename = "BOTOES/somdesligado.png" }
            if somAtivo then
                audio.stop(somAtivo)
                somAtivo = nil
            end
        else
            somLigado = true
            som.fill = { type = "image", filename = "BOTOES/somligado.png" }
            somAtivo = audio.play(somAudio, { loops = 0 })
        end
        return true
    end

    som:addEventListener("tap", toggleSom)

    -- Ativar multitouch
    system.activate("multitouch")

    -- Configurar interação de multitoque
    local function onPinch(event)
        if event.phase == "began" then
            if event.numTouches == 2 then
                local dx = event.x - event.xStart
                local dy = event.y - event.yStart
                pinchDistance = math.sqrt(dx * dx + dy * dy)
                pinchInProgress = true
            end
        elseif event.phase == "moved" and pinchInProgress then
            local dx = event.x - event.xStart
            local dy = event.y - event.yStart
            local newDistance = math.sqrt(dx * dx + dy * dy)

            if newDistance < pinchDistance - 20 then
                -- Avançar para a próxima imagem
                currentImageIndex = currentImageIndex + 1
                if currentImageIndex > #images then
                    currentImageIndex = 1
                end
                conceptImage:removeSelf()
                conceptImage = display.newImageRect(sceneGroup, images[currentImageIndex].path, 300, 300)
                conceptImage.x = images[currentImageIndex].x
                conceptImage.y = images[currentImageIndex].y
                pinchInProgress = false
            elseif newDistance > pinchDistance + 20 then
                -- Voltar para a imagem anterior
                currentImageIndex = currentImageIndex - 1
                if currentImageIndex < 1 then
                    currentImageIndex = #images
                end
                conceptImage:removeSelf()
                conceptImage = display.newImageRect(sceneGroup, images[currentImageIndex].path, 300, 300)
                conceptImage.x = images[currentImageIndex].x
                conceptImage.y = images[currentImageIndex].y
                pinchInProgress = false
            end
        elseif event.phase == "ended" or event.phase == "cancelled" then
            pinchInProgress = false
        end
        return true
    end

    Runtime:addEventListener("touch", onPinch)

    -- Adicionar o listener de toque para o multitouch
    local function touchListener(event)
        print("Phase: " .. event.phase)
        print("Location: " .. tostring(event.x) .. "," .. tostring(event.y))
        print("Unique touch ID: " .. tostring(event.id))
        print("----------")
        return true
    end

    conceptImage:addEventListener("touch", touchListener)

    function scene:hide(event)
        if event.phase == "will" then
            Runtime:removeEventListener("touch", onPinch)
            -- Garantir que o áudio seja parado ao sair da cena
            if somAtivo then
                audio.stop(somAtivo)
                somAtivo = nil
            end
        end
    end

    function scene:show(event)
        if event.phase == "did" then
            -- Não iniciar o som automaticamente
            if somLigado then
                somAtivo = audio.play(somAudio, { loops = 0 })
            end
        end
    end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
