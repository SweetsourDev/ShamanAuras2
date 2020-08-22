local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCooldown = GetSpellCooldown
local GetTalentInfo = GetTalentInfo

-- Cache Global Addon Variables
local StaticDischarge = SSA.StaticDischarge

-- Initialize Data Variables
StaticDischarge.spellID = 342243
StaticDischarge.pulseTime = 0
StaticDischarge.elapsed = 0
StaticDischarge.condition = function()
	local _,_,_,selected = GetTalentInfo(1,3,1)
	
	return selected
end

StaticDischarge:SetScript('OnUpdate',function(self,elapsed)
	if (not Auras.db.char.isFirstEverLoad) then
		if (Auras:RefreshRateHandler(0.5,self.elapsed)) then
			self.elapsed = 0
			
			if ((Auras:CharacterCheck(self,1) and self.condition()) or Auras:IsPreviewingAura(self)) then
				local groupID = Auras:GetAuraGroupID(self,self:GetName())
				local start,duration = GetSpellCooldown(Auras:GetSpellName(self.spellID))
				local buff,_,_,_,buffDuration,expires = Auras:RetrieveAuraInfo("player",192106)
				
				--Auras:SetGlowStartTime(self,((expires or 0) - (buffDuration or 0)),buffDuration,self.spellID,"buff")
				if (buff) then
					Auras:SetGlowStartTime(self,start,duration,self.spellID,"cooldown")
				end

				Auras:GlowHandler(self,groupID)
				Auras:ToggleAuraVisibility(self,true,'showhide')
				--Auras:SpellRangeCheck(self,self.spellID,true)
				Auras:CooldownHandler(self,groupID,start,duration)
					
				if (Auras:IsPlayerInCombat() and buff) then
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

_G["SSA_StaticDischarge"] = StaticDischarge