local composer = require("composer")

local scene = composer.newScene()
local audio = require("audio") -- Módulo de áudio do Corona


local MARGIN = 90
local somAtivo -- Variável para armazenar o canal do som tocando, se necessário

local somAudio = audio.loadSound("audios/audio2.mp3")

-- Variáveis para armazenar os objetos interativos
local capsideo
local envelope
local message
local celulaPronta

function scene:create(event)
    local sceneGroup = self.view

    local background = display.newImageRect(sceneGroup, "FUNDOS/fundo2.png", 768, 1024)
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    local botaoproximo = display.newImage(sceneGroup, "BOTOES/proximo.png")
    botaoproximo.x = display.contentWidth - botaoproximo.width / 2 - MARGIN + 44
    botaoproximo.y = display.contentHeight - botaoproximo.height / 2 - MARGIN + 10

    botaoproximo:addEventListener("tap", function(event)
        composer.gotoScene("tela3", {
            effect = "fade",
            time = 500
        })
    end)

    local botaoanterior = display.newImage(sceneGroup, "BOTOES/anterior.png")
    botaoanterior.x = display.contentWidth - botaoanterior.width / 2 - MARGIN - 525
    botaoanterior.y = display.contentHeight - botaoanterior.height / 2 - MARGIN + 10

    botaoanterior:addEventListener("tap", function(event)
        composer.gotoScene("tela1", {
            effect = "fade",
            time = 500
        })
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

-- Função para recriar os objetos interativos
local function criarObjetosInterativos(sceneGroup)
    -- Criar Cápsideo
    capsideo = display.newImageRect(sceneGroup, "ELEMENTOS/capsideo.png", 250, 120)
    capsideo.x = display.contentCenterX + 230
    capsideo.y = display.contentCenterY - 410

    -- Criar Envelope
    envelope = display.newImageRect(sceneGroup, "ELEMENTOS/envelope.png", 220, 120)
    envelope.x = display.contentCenterX + 230
    envelope.y = display.contentCenterY + 150

    -- Função para verificar colisão
    local function verificarColisao(obj1, obj2)
        local dx = obj1.x - obj2.x
        local dy = obj1.y - obj2.y
        local distancia = math.sqrt(dx * dx + dy * dy)

        return distancia < (obj1.width / 2 + obj2.width / 2)
    end

    -- Função para arrastar os objetos
    local function arrastarObjeto(event)
        local target = event.target

        if event.phase == "began" then
            display.getCurrentStage():setFocus(target)
            target.isFocus = true
        elseif event.phase == "moved" and target.isFocus then
            target.x = event.x
            target.y = event.y
        elseif event.phase == "ended" or event.phase == "cancelled" then
            if target.isFocus then
                display.getCurrentStage():setFocus(nil)
                target.isFocus = false
            end

            -- Verifica se houve colisão entre os objetos
            if verificarColisao(capsideo, envelope) then
                -- Garante que a célula será criada apenas uma vez
                if capsideo and envelope then
                    -- Exibe a célula pronta
                    celulaPronta = display.newImageRect(sceneGroup, "ELEMENTOS/celula.png", 500, 300)
                    celulaPronta.x = display.contentCenterX + 270
                    celulaPronta.y = display.contentCenterY - 85

                    -- Remove os objetos arrastáveis após a fusão
                    capsideo:removeSelf()
                    capsideo = nil
                    envelope:removeSelf()
                    envelope = nil

                    -- Atualiza a mensagem de instrução
                    if message then
                        message.text = "Cápsideo e Envelope unidos com sucesso!"
                    end
                end
            end
        end
        return true
    end

    -- Adicionar listeners de toque para arrastar os objetos
    capsideo:addEventListener("touch", arrastarObjeto)
    envelope:addEventListener("touch", arrastarObjeto)
end

function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "did") then
        -- Recriar objetos interativos ao voltar para esta tela
        criarObjetosInterativos(sceneGroup)
    end
end

function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        if somAtivo then
            audio.stop(somAtivo)
            somAtivo = nil
        end
        -- Remover os objetos interativos antes de sair da tela
        if capsideo then
            capsideo:removeSelf()
            capsideo = nil
        end
        if envelope then
            envelope:removeSelf()
            envelope = nil
        end
        if message then
            message:removeSelf()
            message = nil
        end
        if celulaPronta then
            celulaPronta:removeSelf()
            celulaPronta = nil
        end
    end
end

function scene:destroy(event)
    local sceneGroup = self.view
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
