local SSA, Auras = unpack(select(2,...))

-- Cache Global Lua Functions
local tostring = tostring

-- Cache Global Addon Variables
local StormkeeperCharges = SSA.StormkeeperChargeGrp

StormkeeperCharges:SetScript('OnUpdate',function(self,elapsed)
	if (Auras:CharacterCheck(1)) then
		local buff,_,_,count = Auras:RetrieveBuffInfo("player", Auras:GetSpellName(191634))
		local db = Auras.db.char
		
		Auras:ToggleAuraVisibility(self,true,'showhide')
		--[[if (not self:IsShown()) then
			self:Show()
		end]]
		
		--[[SSA.ErrorFrame.text:SetText("")
		SSA.ErrorFrame.text:SetText(Auras:CurText("ErrorFrame").."Group:    "..self:GetAlpha().." ("..tostring(self:IsShown())..")\n")]]
		if (db.elements[1].isMoving) then
			self.Charge1:SetAlpha(1)
			self.Charge2:SetAlpha(1)
			self.Charge3:SetAlpha(1)
		else
			if (db.elements[1].frames.StormkeeperChargeGrp.isEnabled) then
				if (count == 3) then
					--isStormkeeperActive = true
					--[[for i=1,3 do
						self["Charge"..i].Lightning:SetModel("spells/Monk_chiblast_precast.m2")
						self["Charge"..i].Lightning:SetModelScale(1)
						self["Charge"..i].Lightning:SetPosition(0,0,0)
					end]]
					--[[SSA.ErrorFrame.text:SetText(Auras:CurText("ErrorFrame").."Charge 1: "..self.Charge1:GetAlpha().." ("..tostring(self.Charge1:IsShown())..")\n")
					SSA.ErrorFrame.text:SetText(Auras:CurText("ErrorFrame").."Charge 2: "..self.Charge2:GetAlpha().." ("..tostring(self.Charge2:IsShown())..")\n")
					SSA.ErrorFrame.text:SetText(Auras:CurText("ErrorFrame").."Charge 3: "..self.Charge3:GetAlpha().." ("..tostring(self.Charge3:IsShown())..")\n\n")]]
					self.Charge1:SetAlpha(1)
					self.Charge2:SetAlpha(1)
					self.Charge3:SetAlpha(1)
				elseif (count == 2) then
					--[[SSA.ErrorFrame.text:SetText(Auras:CurText("ErrorFrame").."Charge 1: "..self.Charge1:GetAlpha().." ("..tostring(self.Charge1:IsShown())..")\n")
					SSA.ErrorFrame.text:SetText(Auras:CurText("ErrorFrame").."Charge 2: "..self.Charge2:GetAlpha().." ("..tostring(self.Charge2:IsShown())..")\n")
					SSA.ErrorFrame.text:SetText(Auras:CurText("ErrorFrame").."Charge 3: "..self.Charge3:GetAlpha().." ("..tostring(self.Charge3:IsShown())..")\n\n")]]
					self.Charge3:SetAlpha(0)
				elseif (count == 1) then
					--[[SSA.ErrorFrame.text:SetText(Auras:CurText("ErrorFrame").."Charge 1: "..self.Charge1:GetAlpha().." ("..tostring(self.Charge1:IsShown())..")\n")
					SSA.ErrorFrame.text:SetText(Auras:CurText("ErrorFrame").."Charge 2: "..self.Charge2:GetAlpha().." ("..tostring(self.Charge2:IsShown())..")\n")
					SSA.ErrorFrame.text:SetText(Auras:CurText("ErrorFrame").."Charge 3: "..self.Charge3:GetAlpha().." ("..tostring(self.Charge3:IsShown())..")\n\n")]]
					self.Charge2:SetAlpha(0)
				elseif (count == 0 or not buff) then
					--[[SSA.ErrorFrame.text:SetText(Auras:CurText("ErrorFrame").."Charge 1: "..self.Charge1:GetAlpha().." ("..tostring(self.Charge1:IsShown())..")\n")
					SSA.ErrorFrame.text:SetText(Auras:CurText("ErrorFrame").."Charge 2: "..self.Charge2:GetAlpha().." ("..tostring(self.Charge2:IsShown())..")\n")
					SSA.ErrorFrame.text:SetText(Auras:CurText("ErrorFrame").."Charge 3: "..self.Charge3:GetAlpha().." ("..tostring(self.Charge3:IsShown())..")\n\n")]]
					
					--if (isStormkeeperActive) then
						self.Charge1:SetAlpha(0)
						self.Charge2:SetAlpha(0)
						self.Charge3:SetAlpha(0)
						--isStormkeeperActive = false
					--end
				end
			end
		end

		Auras:ToggleFrameMove(self,db.elements[1].isMoving)
	else
		Auras:ToggleAuraVisibility(self,false,'showhide')
	end
end)

StormkeeperCharges:SetScript('OnMouseDown',function(self,button)
	if (Auras.db.char.elements[1].isMoving) then
		Auras:MoveOnMouseDown(self,'AuraGroup1',button)
	end
end)

StormkeeperCharges:SetScript('OnMouseUp',function(self,button)
	if (Auras.db.char.elements[1].isMoving) then
		Auras:MoveOnMouseUp(self,button)
		Auras:UpdateLayout(self,Auras.db.char.elements[1].frames[self:GetName()])
	end
end)