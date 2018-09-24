local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCooldown = GetSpellCooldown
local UnitCastingInfo = UnitCastingInfo

-- Cache Global Addon Variables
local WindShear = SSA.WindShear

WindShear:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,0,57994)) then
		local spec,groupID = Auras:GetAuraInfo(self,'WindShear')
		local start,duration = GetSpellCooldown(Auras:GetSpellName(57994))
		local name,_,_,_,_,_,_,interrupt = UnitCastingInfo('target')
		
		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:SpellRangeCheck(self,57994,true,spec)
		Auras:CooldownHandler(self,spec,groupID,start,duration)
		
		if (name and not interrupt and (start or 0) == 0 and Auras:IsTargetEnemy()) then
			Auras:ToggleOverlayGlow(self.glow,true,true)
		else
			Auras:ToggleOverlayGlow(self.glow,false)
		end
		
		if (Auras:IsPlayerInCombat()) then
			self:SetAlpha(1)
		else
			Auras:NoCombatDisplay(self,spec,groupID)
		end
	else
		Auras:ToggleAuraVisibility(self,false,'showhide')
	end
end)