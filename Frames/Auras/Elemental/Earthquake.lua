local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local Enum = Enum
local UnitPower = UnitPower

-- Cache Global Addon Variables
local Earthquake = SSA.Earthquake

-- Initialize Data Variables
Earthquake.spellID = 61882
Earthquake.pulseTime = 0
Earthquake.powerTime = 0
Earthquake.condition = function()
	return IsSpellKnown(61882)
end

Earthquake:SetScript('OnUpdate', function(self)
	if (Auras:CharacterCheck(self,1,self.spellID)) then
		local groupID = Auras:GetAuraGroupID(self,self:GetName())
		local _,_,_,_,duration,expires = Auras:RetrieveAuraInfo("player", 208723)
		local power = UnitPower('player',Enum.PowerType.Maelstrom)
		local glow = Auras.db.char.auras[1].auras[self:GetName()].glow
		
		if (power >= 60) then
			
			if (self.powerTime == 0) then
				self.powerTime = GetTime()
				
				for i=1,#glow.triggers do
					local trigger = glow.triggers[i]
					
					if (trigger.spellID == self.spellID) then
						trigger.start = self.powerTime
					end
				end
			end
		else
			if (self.powerTime > 0) then
				self.powerTime = 0
				
				for i=1,#glow.triggers do
					local trigger = glow.triggers[i]
					
					if (trigger.spellID == self.spellID) then
						trigger.start = self.powerTime
					end
				end
			end
		end
		
		Auras:SetGlowStartTime(self,((expires or 0) - (duration or 0)),duration,208723,"buff")
		Auras:GlowHandler(self)
		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:CooldownHandler(self,groupID,start,duration,true)
		
		if (Auras:IsPlayerInCombat(true)) then
			self:SetAlpha(1)
			
			if (power >= 75 or buff) then
				self:SetAlpha(1)
			else
				self:SetAlpha(0.5)
			end
		else
			Auras:NoCombatDisplay(self,groupID)
		end
	else
		Auras:ToggleAuraVisibility(self,false,'showhide')
	end
end)