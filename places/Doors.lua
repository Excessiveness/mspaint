local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

-- Function to check if the game is loaded
local function onGameLoaded()
    print("Loaded") -- Print when the game is loaded
end

-- Function to check if the player is in the lobby
local function checkLobby()
    local IsLobby = (game.PlaceId == 6516141723 or game.PlaceId == 12308344607)
    
    if IsLobby then
        print("Join Game To Start The Script!") -- Print lobby message
    end
end

-- Wait for the game to load, then proceed
if not game:IsLoaded() then
    game.Loaded:Wait() -- Wait until the game is fully loaded
    onGameLoaded() -- Call the onGameLoaded function
end

-- Add a small wait time before checking if the player is in the lobby
task.wait(0.1)

-- Check if the player is in the game
local IsGame = (game.PlaceId == 6839171747)

-- If in game, you can add additional functionality here
if IsGame then
    print("You are in the game!")
else
    checkLobby() -- Call the checkLobby function if not in the game
end

-- Function to set HoldDuration of all ProximityPrompt objects to 0
local function SetAllPromptsToInstantInteract()
    for _, prompt in pairs(workspace.CurrentRooms:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") then
            -- Check and store the current HoldDuration if not already set
            if not prompt:GetAttribute("Hold") then 
                prompt:SetAttribute("Hold", prompt.HoldDuration) 
            end
            -- Set HoldDuration to 0 for instant interaction
            prompt.HoldDuration = 0
        end
    end
end

-- Wait for 30 seconds before removing the hold duration
task.wait(30)
SetAllPromptsToInstantInteract()

-- Wait for the Confirm button to load
local confirmButton = localPlayer.PlayerGui.MainUI.ItemShop:WaitForChild("Confirm")

-- Function to simulate mouse button signals
local function fireButtonSignals()
    -- Simulate MouseButton1Click
    firesignal(confirmButton.MouseButton1Click)
    firesignal(confirmButton.MouseButton1Down)
    firesignal(confirmButton.MouseButton1Up)
end

-- Call the function to fire the signals
fireButtonSignals()

-- Wait until the game is fully loaded
wait(1)

-- Reference to the ProximityPrompt
local function1 = workspace.CurrentRooms["0"].StarterElevator.Model.Model.SkipButton.SkipPrompt

-- Check if the ProximityPrompt exists
if function1:IsA("ProximityPrompt") then
    -- Fire the ProximityPrompt
    firesignal(function1.Triggered)
    print("Proximity Prompt fired successfully!")
else
    warn("The specified ProximityPrompt does not exist or is not a ProximityPrompt.")
end
