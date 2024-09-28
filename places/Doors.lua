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

-- Function to set HoldDuration of all ProximityPrompt objects to 0
local function SetAllPromptsToInstantInteract()
    local promptsFound = false
    for _, prompt in pairs(workspace.CurrentRooms:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") then
            promptsFound = true
            -- Check and store the current HoldDuration if not already set
            if not prompt:GetAttribute("Hold") then 
                prompt:SetAttribute("Hold", prompt.HoldDuration) 
            end
            -- Set HoldDuration to 0 for instant interaction
            prompt.HoldDuration = 0
        end
    end

    if promptsFound then
        print("All ProximityPrompts set to instant interact.")
    else
        print("No ProximityPrompts found.")
    end
end

-- Function to activate the script when Confirm UI element is loaded
local function waitForConfirmUI()
    -- Wait for the Confirm button to be available in the PlayerGui
    local confirmButton = Players.Phynomie.PlayerGui.MainUI.ItemShop:WaitForChild("Confirm", 60) -- Wait for Confirm button with a timeout of 60 seconds
    print("Confirm UI element loaded.")
    
    -- Now proceed with the rest of the script after the Confirm button is loaded.
    
    -- Wait for the game to load, then proceed
    if not game:IsLoaded() then
        game.Loaded:Wait() -- Wait until the game is fully loaded
        onGameLoaded() -- Call the onGameLoaded function
    end

    -- Add a small wait time before checking if the player is in the lobby
    task.wait(0.1)

    -- Check if the player is in the game
    local IsGame = (game.PlaceId == 6839171747)

    -- If in game, set prompts to instant interact
    if IsGame then
        print("You are in the game!")
        task.wait(0.5) -- Wait briefly to ensure ProximityPrompts exist
        SetAllPromptsToInstantInteract() -- Remove hold duration for prompts
    else
        checkLobby() -- Call the checkLobby function if not in the game
    end
end

-- Start waiting for the Confirm UI to load
waitForConfirmUI()
