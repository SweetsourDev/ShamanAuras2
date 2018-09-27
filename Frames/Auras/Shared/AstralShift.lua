local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCooldown = GetSpellCooldown
local IsSpellKnown = IsSpellKnown

-- Cache Global Addon Variables
local AstralShift = SSA.AstralShift

-- Initialize Data Variables
AstralShift.spellID = 108271
AstralShift.condition = function()
	return IsSpellKnown(108271)
end

AstralShift:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,0,self.spellID)) then
		local groupID = Auras:GetAuraGroupID(self,self:GetName())
		local start,duration = GetSpellCooldown(Auras:GetSpellName(self.spellID))
		
		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:CooldownHandler(self,groupID,start,duration)
			
		if (Auras:IsPlayerInCombat()) then
			self:SetAlpha(1)
		else
			Auras:NoCombatDisplay(self,groupID)
		end
	else
		--SSA.DataFrame.text:SetText("Astral Shift OFF: "..GetTime())
		Auras:ToggleAuraVisibility(self,false,'showhide')
	end
end)