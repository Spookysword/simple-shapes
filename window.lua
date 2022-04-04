function ToggleFullscreen()
    love.window.setFullscreen(not love.window.getFullscreen())
end

function KeyManagement(key)
    if key == "f11" then
        ToggleFullscreen()
    end
end
