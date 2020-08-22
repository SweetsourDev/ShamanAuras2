local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCooldown = GetSpellCooldown
local GetTalentInfo = GetTalentInfo

-- Cache Global Addon Variables
local Hailstorm = SSA.Hailstorm

-- Initialize Data Variables
Hailstorm.spellID = 334196
Hailstorm.pulseTime = 0
Hailstorm.elapsed = 0
Hailstorm.condition = function()
	local _,_,_,selected = GetTalentInfo(4,2,1)
	
	return selected
end

Hailstorm:SetScript('OnUpdate',function(self,elapsed)
	if (not Auras.db.char.isFirstEverLoad) then
		if (Auras:RefreshRateHandler(0.5,self.elapsed)) then
			self.elapsed = 0
			
			if ((Auras:CharacterCheck(self,2) and self.condition()) or Auras:IsPreviewingAura(self)) then
				local groupID = Auras:GetAuraGroupID(self,self:GetName())
				--local spell = Auras:GetSpellName(191634)
				local buff,_,count,_,duration,expires = Auras:RetrieveAuraInfo("player", self.spellID)
				--local start,duration = GetSpellCooldown(Auras:GetSpellName(self.spellID))
				
				--Auras:SetGlowStartTime(self,start,duration,self.spellID,"cooldown")
				Auras:SetGlowStartTime(self,((expires or 0) - (duration or 0)),duration,self.spellID,"buff")
				Auras:GlowHandler(self,groupID)
				Auras:ToggleAuraVisibility(self,true,'showhide')
				--Auras:CooldownHandler(self,groupID,start,duration)

				if (buff) then
					--Auras:ToggleOverlayGlow(self.glow,true)
					
					self.CD:SetAlpha(0)
					self.ChargeCD:Show()
					self.Charges:Show()
					self.ChargeCD:SetDrawBling(false)
					
					if (self.ChargeCD:GetCooldownDuration() == 0) then
						self.ChargeCD:SetCooldown((expires - duration),20)
					end
					
					self.Charges.text:SetText(count)
				else
					--Auras:ToggleOverlayGlow(self.glow,false)

					self.CD:SetAlpha(1)
					self.ChargeCD:Hide()
					self.Charges:Hide()
				end
					
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