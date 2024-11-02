-- Manually reload config
function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end
myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()

-- Launch new iTerm window on current desktop
hs.hotkey.bind({"alt", "shift"}, "return", function()
  if hs.application.find("iTerm") then
    hs.applescript.applescript([[
      tell application "iTerm"
        create window with default profile
      end tell
    ]])
  else
    hs.application.open("iTerm")
  end
end)

