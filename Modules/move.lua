local SSA, _, L, LSM = unpack(select(2,...))

local Auras = LibStub("AceAddon-3.0"):GetAddon("ShamanAurasDev")

-- Toggles the movement of a frame.
function Auras:ToggleFrameMove(obj,isMoving,group)
	
	if (isMoving) then
		if (not obj:IsMouseEnabled()) then
			obj:EnableMouse(true)
		end
		
		if (not obj:IsMovable()) then
			obj:SetMovable(true)
		end
		
		if (not obj:GetBackdrop()) then
			obj:SetBackdrop(SSA.BackdropSB)
			obj:SetBackdropColor(0,0,0,0.85)
		end
		
		if (obj.header) then
			obj.header:Show()
		end
		
		if (group) then
			for k,v in pairs(self.db.char.timerbars[SSA.spec].bars) do
				if (v.layout.group == group) then
					v.isAdjust = true
					SSA[k]:Show()
				end
			end
		end
	else
		if (obj:IsMouseEnabled()) then
			obj:EnableMouse(false)
		end
		
		if (obj:IsMovable()) then
			obj:SetMovable(false)
		end
		
		if (obj.header) then
			obj.header:Hide()
		end
		
		if (obj:GetBackdrop()) then
			obj:SetBackdrop(nil)
		end
	end
end

-- Toggles the movement of a progress bar.
function Auras:ToggleProgressBarMove(self,isMoving,db)
	if (isMoving) then
		db.adjust.isEnabled = false
		
		if (not self:IsMouseEnabled()) then
			self:EnableMouse(true)
			self:SetMovable(true)
		end
		self:SetAlpha(1)
	else
		if (self:IsMouseEnabled()) then
			self:EnableMouse(false)
			self:SetMovable(false)
		end
	end
end

function Auras:ConfigureMove(db,obj,backdrop)
	if (db.isMoving) then
		if (not obj:IsMouseEnabled()) then
			obj:EnableMouse(true)
			obj:SetMovable(true)
		end
		
		if (not obj:GetBackdrop()) then
			obj:SetBackdrop(backdrop)
			obj:SetBackdropColor(0,0,0,0.85)
		end
	else
		if (obj:IsMouseEnabled()) then
			obj:EnableMouse(false)
			obj:SetMovable(false)
		end
		
		if (obj:GetBackdrop()) then
			--obj:SetBackdrop(nil)
		end
	end
end

function Auras:MoveOnMouseDown(obj,button)
	local framePt,_,parentPt,x,y = obj:GetPoint(1)

	if (not IsShiftKeyDown() and not IsControlKeyDown() and button == 'LeftButton') then
		obj.framePt = framePt
		obj.parentPt = parentPt
		obj.frameX = x
		obj.frameY = y
		obj:StartMoving()
		_,_,_,x,y = obj:GetPoint(1)
		obj.screenX = x
		obj.screenY = y
	elseif (IsShiftKeyDown() and not IsControlKeyDown()) then
		local point = obj:GetPoint()
		
		if (button == "LeftButton") then
			obj.isSnapping = true
			obj:SetPoint(point,obj:GetParent(),"CENTER",0,y)
		elseif (button == "RightButton") then
			obj.isSnapping = true
			obj:SetPoint(point,obj:GetParent(),"CENTER",x,0)
		elseif (button == "MiddleButton") then
			obj.isSnapping = true
			obj:SetPoint(point,obj:GetParent(),"CENTER",0,0)
		end
	elseif (not IsShiftKeyDown() and IsControlKeyDown() and button == "RightButton") then
		self:ResetAuraGroupPosition(obj:GetName())
	end
end

function Auras:MoveOnMouseUp(obj,button)
	local framePt,_,parentPt,x,y = obj:GetPoint(1)

	if (button == 'LeftButton' and obj.framePt) then
		obj:StopMovingOrSizing()
		x = (x - obj.screenX) + obj.frameX
		y = (y - obj.screenY) + obj.frameY
		obj:ClearAllPoints()
		obj:SetPoint(obj.framePt, obj:GetParent(), obj.parentPt, x, y)
		obj.framePt = nil
		obj.parentPt = nil
		obj.frameX = nil
		obj.frameY =nil
		obj.screenX = nil
		obj.screenY = nil
	end
end

function Auras:UpdateLayout(obj,db,groupID)
	local point,relativeTo,relativePoint,x,y = obj:GetPoint(1)

	if (obj.icon and obj:GetName() ~= "CloudburstBar") then
		if (db.icon.isEnabled) then
			if (db.icon.justify == "LEFT") then
				x = x - floor(db.layout.height / 2)
			else
				x = x + floor(db.layout.height / 2)
			end
		else
		
		end
	end

	if (db.layout) then
		db.layout.point = point
		db.layout.relativeTo = relativeTo:GetName()
		db.layout.relativePoint = relativePoint
		db.layout.x = x
		db.layout.y = y
	else
		db.point = point
		db.relativeTo = relativeTo:GetName()
		db.relativePoint = relativePoint
		db.x = x
		db.y = y
	end
	
	if (obj.isSnapping) then
		obj.isSnapping = false
	end
end