local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local Door = {}
Door.__index = Door

function Door.new(door, pivotOffset, openTime)
	Door._Door = door
	local self = setmetatable({}, Door)

	self.IsClose = true
	self.IsLocked = false
	self.Key = nil
	self.Cooldown = false
	self.Hinge = Door._Door.PrimaryPart
	self.OpenTime = openTime or 1

	Door._Door.ClickDetector.MouseClick:Connect(function()
		self:Interact()
	end)

	return self
end

function Door:Interact()
	if self.Cooldown then
		return
	end
	self.Cooldown = true

	local targetRotation = self.Hinge.CFrame * CFrame.Angles(0, math.rad(70), 0)
	if self.IsClose then
		targetRotation = self.Hinge.CFrame * CFrame.Angles(0, math.rad(-70), 0)
		script.Open:Play()
		self.IsClose = false
	else
		script.Close:Play()
		self.IsClose = true
	end
	
	if RunService:IsClient() then
		local tween = TweenService:Create(self.Hinge, 
			TweenInfo.new(self.OpenTime, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), 
			{CFrame = targetRotation})
		tween:Play()
	else
		task.wait(self.OpenTime)
		self.Hinge.CFrame = targetRotation
	end

	wait(self.OpenTime)
	self.Cooldown = false
end

return Door