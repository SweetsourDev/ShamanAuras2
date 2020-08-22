local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW Functions
local GetTalentInfo = GetTalentInfo

-- Cache Global Addon Variables
local EchoingShock = SSA.EchoingShock

-- Initialize Data Variables
EchoingShock.spellID = 320125
EchoingShock.pulseTime = 0
EchoingShock.elapsed = 0
EchoingShock.condition = function()
	local _,_,_,selected = GetTalentInfo(2,2,1)
	
	return selected
end

EchoingShock:SetScript('OnUpdate',function(self,elapsed)
	if (not Auras.db.char.isFirstEverLoad) then
		if (Auras:RefreshRateHandler(0.5,self.elapsed)) then
			self.elapsed = 0
			
			if ((Auras:CharacterCheck(self,1) and self.condition()) or Auras:IsPreviewingAura(self)) then
				local groupID = Auras:GetAuraGroupID(self,self:GetName())
				local buff,_,_,_,duration,expires = Auras:RetrieveAuraInfo("player", self.spellID)
				local start,duration = GetSpellCooldown(Auras:GetSpellName(self.spellID))
				
				Auras:SetGlowStartTime(self,start,duration,self.spellID,"cooldown")
				Auras:SetGlowStartTime(self,((expires or 0) - (duration or 0)),duration,16166,"buff")
				Auras:GlowHandler(self,groupID)
				Auras:ToggleAuraVisibility(self,true,'showhide')
				Auras:CooldownHandler(self,groupID,start,duration)
				
				if (buff) then
					--Auras:ToggleOverlayGlow(self.glow,true)
					
					self.CD:SetAlpha(0)
					self.ChargeCD:Show()
					--self.Charges:Show()
					self.ChargeCD:SetDrawBling(false)
					
					if (self.ChargeCD:GetCooldownDuration() == 0) then
						self.ChargeCD:SetCooldown(start,8)
					end
					
					--self.Charges.text:SetText(count)
				else
					--Auras:ToggleOverlayGlow(self.glow,false)

					self.CD:SetAlpha(1)
					self.ChargeCD:Hide()
					--self.Charges:Hide()
				end

				if (Auras:IsPlayerInCombat()) then
					if (buff) then
						self:SetAlpha(1)
						--Auras:ToggleOverlayGlow(self.glow,true,false)
					else
						self:SetAlpha(0.5)
						--Auras:ToggleOverlayGlow(self.glow,false)
					end
				else
					Auras:NoCombatDisplay(self,groupID)
					
					--[[if (buff) then
						Auras:ToggleOverlayGlow(self.glow,true,false)
					else
						Auras:ToggleOverlayGlow(self.glow,false)
					end]]
				end
			else
				Auras:ToggleAuraVisibility(self,false,'showhide')
			end
		else
			self.elapsed = self.elapsed + elapsed
		end
	end
end)