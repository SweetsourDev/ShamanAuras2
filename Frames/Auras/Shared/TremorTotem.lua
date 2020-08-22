local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCooldown = GetSpellCooldown
local IsSpellKnown = IsSpellKnown

-- Cache Global Addon Variables
local TremorTotem = SSA.TremorTotem

-- Initialize Data Variables
TremorTotem.spellID = 8143
TremorTotem.pulseTime = 0
TremorTotem.elapsed = 0
TremorTotem.condition = function() return
	IsSpellKnown(8143)
end

TremorTotem:SetScript('OnUpdate',function(self,elapsed)
	if (not Auras.db.char.isFirstEverLoad) then
		if (Auras:RefreshRateHandler(0.5,self.elapsed)) then
			self.elapsed = 0
			
			if ((Auras:CharacterCheck(self,0) and self.condition()) or Auras:IsPreviewingAura(self)) then
				local groupID = Auras:GetAuraGroupID(self,self:GetName())
				local start,duration = GetSpellCooldown(Auras:GetSpellName(self.spellID))
				
				Auras:SetGlowStartTime(self,start,duration,self.spellID,"cooldown")
				Auras:GlowHandler(self,groupID)
				Auras:ToggleAuraVisibility(self,true,'showhide')
				Auras:CooldownHandler(self,groupID,start,duration)
					
				if (Auras:IsPlayerInCombat()) then
					self:SetAlpha(1)
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