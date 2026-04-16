local UIS = game:GetService("UserInputService")
local local_player = game.Players.LocalPlayer
task.wait(2)
local Room_folder = local_player:WaitForChild("PlayerGui"):WaitForChild("ScreenGui").Computer_Screen.Rooms
local_player.CameraMode = Enum.CameraMode.LockFirstPerson

local Rooms = {
	Room_folder.Room_one_Label, 
	Room_folder.Room_two_Label,
	Room_folder.Room_three_Label,
	Room_folder.Room_four_Label,
	Room_folder.Room_five_Label,
	Room_folder.Room_six_Label,
	Room_folder.Room_seven_Label,
	Room_folder.Room_eight_Label, 
	Room_folder.Room_nine_Label,
	Room_folder.Room_ten_Label
}


game.ReplicatedStorage.Events.Local_player_Events.Computer_events.Unlock_Player_Mouse.OnClientEvent:Connect(function()
	
	game.ReplicatedStorage.Events.Local_player_Events.Computer_events.Update_room_availability:FireServer()
	local_player.CameraMode = Enum.CameraMode.Classic
	local_player.CameraMinZoomDistance = 1
	local_player.CameraMaxZoomDistance = 1
	UIS.MouseBehavior = Enum.MouseBehavior.Default
	local_player.PlayerGui.ScreenGui.Computer_Screen.Visible = true
end)




game.ReplicatedStorage.Events.Local_player_Events.Computer_events.Update_room_availability.OnClientEvent:Connect(function(Room_availability)
	local Rooms_GUI = local_player.PlayerGui.ScreenGui.Computer_Screen.Rooms
	print(Room_availability)
	for i, room in ipairs(Room_availability) do 
		if room == "" then 
			Rooms[i].Text = "Room " .. i .. ":Vacant"
			Rooms[i].BackgroundColor3 = Color3.new(0, 1, 0)
		else 
			Rooms[i].Text = "Room " .. i .. ":Occupied"
			Rooms[i].BackgroundColor3 = Color3.new(1, 0, 0)
		end
	end
end)