local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Function
local Enum = Enum
local GetSpellCooldown = GetSpellCooldown
local GetTime = GetTime
local UnitPower = UnitPower

-- Cache Global Addon Variables
local Frostbrand = SSA.Frostbrand

-- Initialize Data Variables
Frostbrand.spellID = 196834
Frostbrand.pulseTime = 0
Frostbrand.condition = function()
	return IsSpellKnown(196834)
end

Frostbrand:SetScript('OnUpdate', function(self)
	if ((Auras:CharacterCheck(self,2) and self.condition()) or Auras:IsPreviewingAura(self)) then
		local groupID = Auras:GetAuraGroupID(self,self:GetName())
		local buff,_,_,_,duration,expires = Auras:RetrieveAuraInfo('player',self.spellID)
		local power = UnitPower('player',Enum.PowerType.Maelstrom)
		local start,duration = GetSpellCooldown(Auras:GetSpellName(self.spellID))
		
		Auras:SetGlowStartTime(self,((expires or 0) - (duration or 0)),duration,self.spellID,"buff")
		Auras:GlowHandler(self)
		Auras:SpellRangeCheck(self,self.spellID,true)
		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:CooldownHandler(self,groupID,start,duration,true)
		
		if (Auras:IsPlayerInCombat()) then
			if (power >= 20) then
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