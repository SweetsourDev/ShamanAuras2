local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCooldown = GetSpellCooldown
local IsSpellKnown = IsSpellKnown

-- Cache Global Addon Variables
local AstralShift = SSA.AstralShift

AstralShift:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,0,108271)) then
		local spec,groupID = Auras:GetAuraInfo(self,'AstralShift')
		local start,duration = GetSpellCooldown(Auras:GetSpellName(108271))
		
		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:CooldownHandler(self,spec,groupID,start,duration)
			
		if (Auras:IsPlayerInCombat()) then
			self:SetAlpha(1)
		else
			Auras:NoCombatDisplay(self,spec,groupID)
		end
	else
		--SSA.DataFrame.text:SetText("Astral Shift OFF: "..GetTime())
		Auras:ToggleAuraVisibility(self,false,'showhide')
	end
end)