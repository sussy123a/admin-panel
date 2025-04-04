local ReplicatedStorage = game:GetService("ReplicatedStorage")

local kickEvent = ReplicatedStorage:FindFirstChild("KickEvent") or Instance.new("RemoteEvent")
kickEvent.Name = "KickEvent"
kickEvent.Parent = ReplicatedStorage

kickEvent.OnServerEvent:Connect(function(sender, target)
	if target and target:IsA("Player") then
		if sender.Name == "noneilike" or sender.Name == "3d3x3d3x" then
			target:Kick("You were kicked by an admin.")
		end
	end
end)
