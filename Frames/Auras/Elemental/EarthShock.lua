local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local Enum = Enum
local GetSpellCooldown = GetSpellCooldown
local IsSpellKnown = IsSpellKnown

-- Cache Global Addon Variables
local EarthShock = SSA.EarthShock

-- Initialize Data Variables
EarthShock.spellID = 8042
EarthShock.pulseTime = 0
EarthShock.powerTime = 0
EarthShock.condition = function()
	return IsSpellKnown(8042)
end

EarthShock:SetScript('OnUpdate', function(self)
	if (Auras:CharacterCheck(self,1,self.spellID)) then
		local groupID = Auras:GetAuraGroupID(self,self:GetName())
		local power = UnitPower('player',Enum.PowerType.Maelstrom)
		local glow = Auras.db.char.auras[1].auras[self:GetName()].glow
		local start,duration = GetSpellCooldown(Auras:GetSpellName(self.spellID))
		
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
		
		Auras:GlowHandler(self)
		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:SpellRangeCheck(self,self.spellID,true)
		Auras:CooldownHandler(self,groupID,start,duration,true)
		
		if (Auras:IsPlayerInCombat()) then
			--[[if (power >= Auras.db.char.elements[1].statusbars.maelstromBar.threshold) then
				Auras:ToggleOverlayGlow(self.glow,true)
			else
				Auras:ToggleOverlayGlow(self.glow,false)
			end]]
			if (power >= 60) then
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