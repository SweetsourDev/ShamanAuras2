local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCooldown = GetSpellCooldown
local GetTalentInfo = GetTalentInfo

-- Cache Global Addon Variables
local Stormkeeper = SSA.Stormkeeper

-- Initialize Data Variables
Stormkeeper.spellID = 191634
Stormkeeper.pulseTime = 0
Stormkeeper.elapsed = 0
Stormkeeper.condition = function()
	local spec = GetSpecialization()
	local selected = false

	if (spec == 1) then
		_,_,_,selected = GetTalentInfo(7,2,1)
	elseif (spec == 2) then
		_,_,_,selected = GetTalentInfo(6,2,1)
	end
	
	return selected
end

Stormkeeper:SetScript('OnUpdate',function(self,elapsed)
	if (not Auras.db.char.isFirstEverLoad) then
		if (Auras:RefreshRateHandler(0.5,self.elapsed)) then
			self.elapsed = 0
			self.spellID = (SSA.spec == 1 and 191634) or (SSA.spec == 2 and 320137)

			if (((Auras:CharacterCheck(self,1) or Auras:CharacterCheck(self,2)) and self.condition()) or Auras:IsPreviewingAura(self)) then
				local groupID = Auras:GetAuraGroupID(self,self:GetName())
				--local spell = Auras:GetSpellName(191634)
				local buff,_,count,_,buffDuration,expires = Auras:RetrieveAuraInfo("player", self.spellID)
				local start,duration = GetSpellCooldown(Auras:GetSpellName(self.spellID))
				
				Auras:SetGlowStartTime(self,start,duration,self.spellID,"cooldown")
				Auras:SetGlowStartTime(self,((expires or 0) - (buffDuration or 0)),buffDuration,self.spellID,"buff")
				Auras:GlowHandler(self,groupID)
				Auras:ToggleAuraVisibility(self,true,'showhide')
				Auras:CooldownHandler(self,groupID,start,duration)

				if (buff) then
					--Auras:ToggleOverlayGlow(self.glow,true)
					
					self.CD:SetAlpha(0)
					self.ChargeCD:Show()
					self.Charges:Show()
					self.ChargeCD:SetDrawBling(false)
					
					if (self.ChargeCD:GetCooldownDuration() == 0) then
						self.ChargeCD:SetCooldown(start,15)
					end
					
					self.Charges.text:SetText(count)
				else
					--Auras:ToggleOverlayGlow(self.glow,false)

					self.CD:SetAlpha(1)
					self.ChargeCD:Hide()
					self.Charges:Hide()
				end
					
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