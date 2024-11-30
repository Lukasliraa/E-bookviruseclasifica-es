local composer = require("composer")
local physics = require("physics") -- Para simular física
local audio = require("audio") -- Módulo de áudio do Corona

local scene = composer.newScene()

-- Configurações
local MARGIN = 90
local somAtivo -- Variável para armazenar o canal do som tocando, se necessário
local somAudio = audio.loadSound("audios/audio4.mp3")

local particles = {}  -- Lista de partículas virais
local cells = {}      -- Lista de células
local screenWidth = display.contentWidth
local screenHeight = display.contentHeight

physics.start()
physics.setGravity(0, 0)  -- Desativa a gravidade

-- Função para criar células em posições e tamanhos específicos
local function createCells(positions, size)
    for _, pos in ipairs(positions) do
        local cell = display.newImageRect("ELEMENTOS/celulasaudavel.png",40, 40,size.width, size.height)
        cell.x = pos.x
        cell.y = pos.y
        cell.isInfected = false
        physics.addBody(cell, "static", {radius = size.width / 2})
        cells[#cells + 1] = cell
    end
end

-- Função para criar partículas virais
local function createParticle(x, y)
    local particle = display.newImageRect("ELEMENTOS/virus.png", 35, 35)
    particle.x = 35
    particle.y = 750
    physics.addBody(particle, "dynamic", {radius = 10, bounce = 0.8})
    particle.isParticle = true
    particles[#particles + 1] = particle
end

-- Função de infecção
local function infectCell(cell)
    if cell and not cell.isInfected then
        local x, y = cell.x, cell.y
        if cell.removeSelf then
            cell:removeSelf()
        end
        cell = nil

        -- Criar uma célula infectada
        local newCell = display.newImageRect("ELEMENTOS/celulainfectada.png", 40, 30)
        newCell.x, newCell.y = x, y
        newCell.isInfected = true
        physics.addBody(newCell, "static", {radius = 20})
        cells[#cells + 1] = newCell

        -- Propagar a infecção
        for _ = 1, 3 do
            createParticle(newCell.x, newCell.y)
        end
    end
end

-- Função de colisão
local function onCollision(event)
    if event.phase == "began" then
        local obj1 = event.object1
        local obj2 = event.object2

        if obj1 and obj2 then
            if obj1.isParticle and not obj2.isParticle then
                infectCell(obj2)
            elseif obj2.isParticle and not obj1.isParticle then
                infectCell(obj1)
            end
        end
    end
end

-- Função de simulação com o mouse (ou acelerômetro em dispositivos móveis)
local function onTouch(event)
    local touchX, touchY = event.x, event.y

    for _, particle in ipairs(particles) do
        if particle and particle.x and particle.y then
            local dx = touchX - particle.x
            local dy = touchY - particle.y
            local distance = math.sqrt(dx * dx + dy * dy)

            if distance > 1 then
                local speed = 5
                particle.x = particle.x + dx / distance * speed
                particle.y = particle.y + dy / distance * speed
            end
        end
    end
end

-- Função para resetar a cena
local function resetScene()
    -- Limpa listas anteriores
    for _, cell in ipairs(cells) do
        if cell and cell.removeSelf then
            cell:removeSelf()
        end
    end
    cells = {}

    for _, particle in ipairs(particles) do
        if particle and particle.removeSelf then
            particle:removeSelf()
        end
    end
    particles = {}

    -- Configurar novas células
    local cellPositions = {
        {x = 610, y = 400},
        {x = 540, y = 400},
        {x = 580, y = 600},
        {x = 610, y = 260},
        {x = 630, y = 500}
    }
    local cellSize = {width = 50, height = 50}
    createCells(cellPositions, cellSize)

    -- Criar uma nova partícula
    createParticle(screenWidth / 2, screenHeight / 2)
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

    Runtime:addEventListener("collision", onCollision)
    Runtime:addEventListener("touch", onTouch)
end

function scene:show(event)
    local phase = event.phase
    if phase == "did" then
        resetScene() -- Reinicia a cena sempre que ela for exibida
    end
end

function scene:hide(event)
    local phase = event.phase
    if phase == "will" then
        -- Remove células e partículas ao sair da cena
        for _, cell in ipairs(cells) do
            if cell and cell.removeSelf then
                cell:removeSelf()
            end
        end
        cells = {}
        for _, particle in ipairs(particles) do
            if particle and particle.removeSelf then
                particle:removeSelf()
            end
        end
        particles = {}
        
        -- Parar o áudio ao sair da cena
        if somAtivo then
            audio.stop(somAtivo)
            somAtivo = nil
        end
    end
end

function scene:destroy(event)
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
