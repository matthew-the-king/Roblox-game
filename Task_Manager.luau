--For Random tasks thje script uses a randomly generated number that has the number of tasks in it and then chooses a task with the number
local tasks = {"Clean spill", "Restock the vending machine", "Check in customer"}
local Subtitle_event = game.ReplicatedStorage.Events.Local_player_Events.Subtitle_Event
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local way_points = game.Workspace.Customer_Way_Points

local NPCs = game.ReplicatedStorage.Models.NPCs.Customer_NPCs:GetChildren()

local NPC_Folder = Instance.new("Folder") --Create a folder for all NPCs that are cloned
NPC_Folder.Parent = game.Workspace
NPC_Folder.Name = "NPC_Folder"


local Seat_One_Pos = CFrame.new(-729.429, 3.365, -170.651) * CFrame.Angles(0, math.rad(180), 0) --Every seat position where bus starts
local Seat_Two_Pos = CFrame.new(-732.829, 3.365, -170.651) * CFrame.Angles(0, math.rad(180), 0) 
local Seat_Three_Pos = CFrame.new(-739.109, 3.365, -171.145) * CFrame.Angles(0, math.rad(-90), 0)
local Seat_Four_Pos = CFrame.new(-742.859, 3.365, -171.145) * CFrame.Angles(0, math.rad(-90), 0)
local Seat_Five_Pos = CFrame.new(-746.659, 3.365, -171.145) * CFrame.Angles(0, math.rad(-90), 0)
local Seat_Six_Pos = CFrame.new(-750.509, 3.365, -171.145) * CFrame.Angles(0, math.rad(-90), 0) 
local Seat_Seven_Pos = CFrame.new(-755.009, 3.365, -171.145) * CFrame.Angles(0, math.rad(-90), 0) 
local Seat_Eight_Pos = CFrame.new(-755.009, 3.365, -168.055) * CFrame.Angles(0, math.rad(-90), 0) 
local Seat_Nine_Pos = CFrame.new(-755.009, 3.365, -165.395) * CFrame.Angles(0, math.rad(-90), 0)
local Seat_Ten_Pos = CFrame.new(-750.309, 3.365, -165.395) * CFrame.Angles(0, math.rad(-90), 0) 
local Seat_Eleven_Pos = CFrame.new(-746.759, 3.365, -165.395) * CFrame.Angles(0, math.rad(-90), 0) 
local Seat_Twelve_Pos = CFrame.new(-742.959, 3.365, -165.395) * CFrame.Angles(0, math.rad(-90), 0) 
local Seat_Thirteen_Pos = CFrame.new(-739.159, 3.365, -165.395) * CFrame.Angles(0, math.rad(-90), 0) 

local seats = 
	{
		Seat_One_Pos, Seat_Two_Pos, Seat_Three_Pos, Seat_Four_Pos, 
		Seat_Five_Pos, Seat_Six_Pos, Seat_Seven_Pos, Seat_Eight_Pos, 
		Seat_Nine_Pos,Seat_Ten_Pos, Seat_Eleven_Pos, Seat_Twelve_Pos, 
		Seat_Thirteen_Pos
	}


local function Clean_Spill()
	local spill_Mesh = ReplicatedStorage.Tasks.Brown_Spill:Clone()
	
	local Random_X = math.random(-73, -39)
	local Random_Z = math.random(-140, 67)
	
	Subtitle_event:FireAllClients("Server:There has been a spill!")
	spill_Mesh.Parent = workspace
	spill_Mesh:MoveTo(Vector3.new(Random_X, 0.1, Random_Z))
	
	
	return 
end

local function Restock_Vending_Machine()
	 local snacks = game.Workspace.Vending_Machine:FindFirstChild("Vending_Machine_Snacks")
	 Subtitle_event:FireAllClients("Server:The vending Machine must be Restocked!")
	 if snacks then 
			for i, snack in ipairs(snacks:GetChildren()) do 
				snack:Destroy()
			end
	 end
	 return
end

local function check_in_customer()
	local bus = game.Workspace.bus
	bus:PivotTo(CFrame.new(-723.808, 5.312, -171.108) * CFrame.Angles(math.rad(90),0, math.rad(180)))
	local Chosen_NPC_num = math.random(1,#NPCs)
	local Random_NPC = NPCs[Chosen_NPC_num]:Clone()
	table.remove(NPCs, Chosen_NPC_num)
	print(NPCs)
	for index, part in pairs(Random_NPC:GetChildren()) do 
		if part:IsA("BasePart") then 
			part.CollisionGroup = "NPCs"
		end
	end
	Random_NPC.HumanoidRootPart.Anchored = true
	Random_NPC.Parent = bus
	
	local Animation_Script = game.ReplicatedStorage.Models.NPCs.NPC_Scripts.Bus_Idle_Animator:Clone()
	Animation_Script.Parent = Random_NPC
	Random_NPC:PivotTo(seats[math.random(1,#seats)])
	task.wait(5)
	bus.Bus_Head_To_Motel:Fire()
	
	bus.Bus_at_hotel.Event:Wait()
	task.wait(2)
	Animation_Script.Enabled = false
	
	local Animate_script = game.ReplicatedStorage.Models.NPCs.NPC_Scripts.Animate:Clone()
	Animate_script.Parent = Random_NPC
	Random_NPC.Parent = NPC_Folder
	Random_NPC:PivotTo(CFrame.new(-51.245, 3.292, -156.926) * CFrame.Angles(-0, 180, 0))
	Random_NPC.HumanoidRootPart.Anchored = false
	
	Random_NPC.Humanoid:MoveTo(way_points.Door_Front.Position)
	Random_NPC.Humanoid.MoveToFinished:Wait()
	
	if game.Workspace.Hotel_Lobby.Door.Hotel_lobby_door.Prox_part.Door_Open.Value == false then  --Open door for NPC
	game.Workspace.Hotel_Lobby.Door.Hotel_lobby_door.Prox_part.NPC_open_Door:Fire()
	end
	
	Random_NPC.Humanoid:MoveTo(way_points.After_door.Position)
	Random_NPC.Humanoid.MoveToFinished:Wait()
	
	Random_NPC.Humanoid:MoveTo(way_points.In_front_of_computer.Position)
	Random_NPC.Humanoid.MoveToFinished:Wait()
	
	Random_NPC.Humanoid:MoveTo(way_points.Face_computer.Position)
	Random_NPC.Humanoid.MoveToFinished:Wait()
	
	Subtitle_event:FireAllClients("A customer needs to be checked in!")
	
	game.ReplicatedStorage.Events.Server_Events.Tasks.New_customer:Fire(Random_NPC.Name)
	
end




local function Random_Task_Assigner()

	while true do 
		local random_task = math.random(1, #tasks)
		task.wait(20)
		print("Player must " .. tasks[random_task])
		if random_task == 1 then
			local task_done = Clean_Spill()
		elseif random_task == 2 then 
			local task_done = Restock_Vending_Machine()
		elseif random_task == 3 then 
			local task_done = check_in_customer()
		end
		if game.ReplicatedStorage.Events.Server_Events.Tasks.End_tasks.Value == true then
			break
		end
		
		
	end
		
	
end

game.ReplicatedStorage.Events.Server_Events.Tasks.Start_tasks.Event:Connect(Random_Task_Assigner)