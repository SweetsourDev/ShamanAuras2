local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local UnitPower = UnitPower

-- Cache Global Addon Variables
local Earthquake = SSA.Earthquake

Earthquake:SetScript('OnUpdate', function(self)
	if (Auras:CharacterCheck(self,1,61882)) then
		local spec,groupID = Auras:GetAuraInfo(self,'Earthquake')
		local powerID = Enum.PowerType.Maelstrom
		local buff = Auras:RetrieveBuffInfo("player", Auras:GetSpellName(208723))
		local power = UnitPower('player',powerID)
		
		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:CooldownHandler(self,spec,groupID,start,duration,true)
		
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
			Auras:NoCombatDisplay(self,spec,groupID)
		end
	else
		Auras:ToggleAuraVisibility(self,false,'showhide')
	end
end)