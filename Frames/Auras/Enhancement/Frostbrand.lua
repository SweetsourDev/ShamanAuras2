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
Frostbrand.elapsed = 0
Frostbrand.condition = function()
	return IsSpellKnown(196834)
end

Frostbrand:SetScript('OnUpdate', function(self,elapsed)
	if (not Auras.db.char.isFirstEverLoad) then
		if (Auras:RefreshRateHandler(0.5,self.elapsed)) then
			self.elapsed = 0
			
			if ((Auras:CharacterCheck(self,2) and self.condition()) or Auras:IsPreviewingAura(self)) then
				local groupID = Auras:GetAuraGroupID(self,self:GetName())
				local buff,_,_,_,duration,expires = Auras:RetrieveAuraInfo('player',self.spellID)
				local power = UnitPower('player',Enum.PowerType.Maelstrom)
				local start,duration = GetSpellCooldown(Auras:GetSpellName(self.spellID))
				
				Auras:SetGlowStartTime(self,((expires or 0) - (duration or 0)),duration,self.spellID,"buff")
				Auras:GlowHandler(self,groupID)
				Auras:SpellRangeCheck(self,self.spellID,true)
				Auras:ToggleAuraVisibility(self,true,'showhide')
				Auras:CooldownHandler(self,groupID,start,duration,true)
				
				if (Auras:IsPlayerInCombat()) then
					local powerCost = GetSpellPowerCost(self.spellID)
					if (power >= powerCost[1].cost) then
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