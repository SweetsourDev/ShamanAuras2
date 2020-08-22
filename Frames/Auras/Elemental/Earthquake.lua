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
Earthquake.elapsed = 0
Earthquake.condition = function()
	return IsSpellKnown(61882)
end

Earthquake:SetScript('OnUpdate', function(self,elapsed)
	if (not Auras.db.char.isFirstEverLoad) then
		if (Auras:RefreshRateHandler(0.5,self.elapsed)) then
			self.elapsed = 0
			
			if ((Auras:CharacterCheck(self,1) and self.condition()) or Auras:IsPreviewingAura(self)) then
				local groupID = Auras:GetAuraGroupID(self,self:GetName())
				local _,_,count,_,duration,expires = Auras:RetrieveAuraInfo("player", 260111)
				local glow = Auras.db.char.auras[1].auras[self:GetName()].glow
				
				if ((count or 0) >= 5) then
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
				
				--Auras:SetGlowStartTime(self,((expires or 0) - (duration or 0)),duration,208723,"buff")
				Auras:GlowHandler(self,groupID)
				Auras:ToggleAuraVisibility(self,true,'showhide')
				Auras:CooldownHandler(self,groupID,start,duration,true)
				
				if (Auras:IsPlayerInCombat(true)) then
					self:SetAlpha(1)
					
					if ((count or 0) >= 5) then
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
		else
			self.elapsed = self.elapsed + elapsed
		end
	end
end)