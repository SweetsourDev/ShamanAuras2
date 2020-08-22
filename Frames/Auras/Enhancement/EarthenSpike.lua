local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local Enum = Enum
local GetSpellCooldown = GetSpellCooldown
local GetTalentInfo = GetTalentInfo
local UnitPower = UnitPower

-- Cache Global Addon Variables
local EarthenSpike = SSA.EarthenSpike

-- Initialize Data Variables
EarthenSpike.spellID = 188089
EarthenSpike.pulseTime = 0
EarthenSpike.elapsed = 0
EarthenSpike.condition = function()
	local _,_,_,selected = GetTalentInfo(7,2,1)
	
	return selected
end

EarthenSpike:SetScript('OnUpdate', function(self,elapsed)
	if (not Auras.db.char.isFirstEverLoad) then
		if (Auras:RefreshRateHandler(0.5,self.elapsed)) then
			self.elapsed = 0
			
			if ((Auras:CharacterCheck(self,2) and self.condition()) or Auras:IsPreviewingAura(self)) then
				local groupID = Auras:GetAuraGroupID(self,self:GetName())
				local start,duration = GetSpellCooldown(Auras:GetSpellName(self.spellID))
				local power = UnitPower('player',Enum.PowerType.Maelstrom)
			
				Auras:SetGlowStartTime(self,start,duration,self.spellID,"cooldown")
				Auras:GlowHandler(self,groupID)
				Auras:SpellRangeCheck(self,self.spellID,true)
				Auras:ToggleAuraVisibility(self,true,'showhide')
				Auras:CooldownHandler(self,groupID,start,duration)

				if (Auras:IsPlayerInCombat()) then
					if (power >= 30) then
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