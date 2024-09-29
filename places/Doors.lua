local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

-- Wait for 20 seconds before activating the script
task.wait(20)

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

-- Function to remove specific elements from the first room
local function removeRoomElements()
    -- Access the first room in CurrentRooms
    local firstRoom = workspace.CurrentRooms:FindFirstChild("0")

    -- Check if the first room exists
    if firstRoom then
        -- Access and remove DoorHitbox from StarterElevator
        local starterElevator = firstRoom:FindFirstChild("StarterElevator")
        
        if starterElevator then
            local doorHitbox = starterElevator:FindFirstChild("DoorHitbox")
            
            if doorHitbox then
                doorHitbox:Destroy() -- Remove DoorHitbox
                print("DoorHitbox removed from StarterElevator.")
            end
        end

        -- Access and remove RoomEntrance from the first room
        local roomEntrance = firstRoom:FindFirstChild("RoomEntrance")
        
        if roomEntrance then
            roomEntrance:Destroy() -- Remove RoomEntrance
            print("RoomEntrance removed from the first room.")
        end
    else
        print("First room does not exist.")
    end
end

-- Function to create a visual line and move the player
local function activatePlayerMovement()
    -- Get the player and their character
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    -- Define the line size (small and long)
    local lineLength = 20 -- Length of the line (you can adjust this)
    local lineThickness = 0.1 -- Increased thickness for better visibility

    -- Create the visual line (as a part)
    local line = Instance.new("Part")
    line.Size = Vector3.new(lineLength, lineThickness, lineThickness) -- Small and thin
    line.Anchored = true
    line.CanCollide = false -- No collision, just for visuals
    line.BrickColor = BrickColor.new("Aqua") -- Changed to Aqua for visibility
    line.Material = Enum.Material.Neon -- Make it glow for better visibility
    line.Transparency = 0 -- Set transparency to 0 to make it fully opaque

    -- Position the line in front of the player, aligned with the player's forward direction
    line.CFrame = humanoidRootPart.CFrame * CFrame.new(0, -1, -lineLength / 2) * CFrame.Angles(0, math.rad(90), 0) -- Adjust for forward direction

    line.Parent = workspace

    -- Calculate the target position (end of the line)
    local targetPosition = humanoidRootPart.Position + (humanoidRootPart.CFrame.LookVector * lineLength)

    -- Walk to the end of the line
    humanoid:MoveTo(targetPosition)

    -- Stop the player once they reach the end of the line
    humanoid.MoveToFinished:Connect(function(reached)
        if reached then
            humanoid.WalkSpeed = 0 -- Stop the player once they reach the end
            wait(1) -- Wait for 1 second (you can change this)
            humanoid.WalkSpeed = 16 -- Restore default walk speed (16 studs/sec)

            -- Remove the line after the player has reached the end
            line:Destroy()
        end
    end)
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

-- If in game, set prompts to instant interact
if IsGame then
    print("You are in the game!")
    task.wait(0.5) -- Wait briefly to ensure ProximityPrompts exist
    SetAllPromptsToInstantInteract() -- Remove hold duration for prompts
    removeRoomElements() -- Call the function to remove room elements after setting prompts
    task.wait(0.5) -- Wait briefly to ensure that The Door is Removed
    activatePlayerMovement() -- Activate the character movement and line creation function after removing elements
else
    checkLobby() -- Call the checkLobby function if not in the game
end
