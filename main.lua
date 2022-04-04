require("window")
require("theme")
Wf = require("libraries.windfield")
Gravity = 1250
World = Wf.newWorld(0, Gravity)
Camera = { zoom = 1, playerZoom = { x=1,y=1 }, aspect = { w = 1280, h = 720 }, offset = { x = 0, y = 0, scrollSpeed = 250 } }

function ScreenToWorld(screenX, screenY)
    local worldX = (screenX / Camera.playerZoom.x) + Camera.offset.x
    local worldY = (screenY / Camera.playerZoom.y) + Camera.offset.y
    return worldX, worldY
end

function love.load()
    Ball = World:newCircleCollider(640, 240, 50)
    Ball:setRestitution(0.75)
    Ground = World:newRectangleCollider(0, 620, 100, 100)
    Ground:setType('static')
    love.graphics.setBackgroundColor(BgColor)
end

function love.update(dt)
    local w, h = love.graphics.getWidth() / Camera.aspect.w, love.graphics.getHeight() / Camera.aspect.h
    if w > h then
        Camera.zoom = w
    else
        Camera.zoom = h
    end
    dt = math.min(dt, 1/30)
    if love.keyboard.isDown('w') or love.keyboard.isDown('left') then
        Camera.offset.y = Camera.offset.y + ((Camera.offset.scrollSpeed/Camera.playerZoom.x) * dt)
    end
    if love.keyboard.isDown('a') or love.keyboard.isDown('left') then
        Camera.offset.x = Camera.offset.x + ((Camera.offset.scrollSpeed/Camera.playerZoom.x) * dt)
    end
    if love.keyboard.isDown('s') or love.keyboard.isDown('left') then
        Camera.offset.y = Camera.offset.y - ((Camera.offset.scrollSpeed/Camera.playerZoom.x) * dt)
    end
    if love.keyboard.isDown('d') or love.keyboard.isDown('left') then
        Camera.offset.x = Camera.offset.x - ((Camera.offset.scrollSpeed/Camera.playerZoom.x) * dt)
    end
    local bx, by = Ball:getPosition()
    Ground:setPosition(bx, 620)
    World:update(dt)
end

function love.wheelmoved(x, y)
    local beforeZX, beforeZY = ScreenToWorld(love.mouse.getX(), love.mouse.getY())
    if y > 0 then
        Camera.playerZoom.x = Camera.playerZoom.x * 1.101
        Camera.playerZoom.y = Camera.playerZoom.y * 1.101
    elseif y < 0 then
        Camera.playerZoom.x = Camera.playerZoom.x * 0.901
        Camera.playerZoom.y = Camera.playerZoom.y * 0.901
    end
    print(Camera.playerZoom.x)
    if Camera.playerZoom.x < 0.001 then
        Camera.playerZoom.x = 0.001
        Camera.playerZoom.y = 0.001
    elseif Camera.playerZoom.x > 1000000 then
        Camera.playerZoom.x = 1000000
        Camera.playerZoom.y = 1000000
    end
    local afterZX, afterZY = ScreenToWorld(love.mouse.getX(), love.mouse.getY())
    Camera.offset.x = Camera.offset.x - ((beforeZX - afterZX) / Camera.zoom)
    Camera.offset.y = Camera.offset.y - ((beforeZY - afterZY) / Camera.zoom)
end

function love.draw()
    love.graphics.scale(Camera.playerZoom.x, Camera.playerZoom.y)
    local bx, by = Ground:getPosition()
    love.graphics.setColor(BallColor)
    love.graphics.circle('fill', (Ball:getBody():getX()+Camera.offset.x)*Camera.zoom, (Ball:getBody():getY()+Camera.offset.y)*Camera.zoom, (Ball:getShape():getRadius())*Camera.zoom)
    love.graphics.setColor(GroundColor)
    love.graphics.rectangle('fill', 0, (570+Camera.offset.y)*Camera.zoom, (1280*Camera.zoom)/Camera.playerZoom.x, ((720*Camera.zoom)/Camera.playerZoom.y)-(570+Camera.offset.y)*Camera.zoom)
    --World:draw()
end

function love.keypressed(key)
    KeyManagement(key)
end
