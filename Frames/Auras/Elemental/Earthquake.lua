local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local Enum = Enum
local UnitPower = UnitPower

-- Cache Global Addon Variables
local Earthquake = SSA.Earthquake

-- Initialize Data Variables
Earthquake.spellID = 61882
Earthquake.condition = function()
	return IsSpellKnown(61882)
end

Earthquake:SetScript('OnUpdate', function(self)
	if (Auras:CharacterCheck(self,1,self.spellID)) then
		local groupID = Auras:GetAuraGroupID(self,self:GetName())
		local buff = Auras:RetrieveAuraInfo("player", 208723)
		local power = UnitPower('player',Enum.PowerType.Maelstrom)
		
		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:CooldownHandler(self,groupID,start,duration,true)
		
		if (Auras:IsPlayerInCombat(true)) then
			self:SetAlpha(1)
			
			if (buff) then
				Auras:ToggleOverlayGlow(self.glow,true,false)
			else
				Auras:ToggleOverlayGlow(self.glow,false)
			end
			
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