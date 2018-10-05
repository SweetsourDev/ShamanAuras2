local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCharges, GetSpellCooldown = GetSpellCharges, GetSpellCooldown
local GetTalentInfo = GetTalentInfo
local IsSpellKnown = IsSpellKnown

-- Cache Global Addon Variables
local Riptide = SSA.Riptide

-- Initialize Data Variables
Riptide.spellID = 61295
Riptide.pulseTime = 0
Riptide.activePriority = 0
Riptide.condition = function()
	return IsSpellKnown(61295)
end

Riptide:SetScript('OnUpdate', function(self)
	if (Auras:CharacterCheck(self,3,self.spellID)) then
		local groupID = Auras:GetAuraGroupID(self,self:GetName())
		local cdStart,cdDuration = GetSpellCooldown(Auras:GetSpellName(self.spellID))
		local charges,maxCharges,chgStart,chgDuration = GetSpellCharges(self.spellID)
		local _,_,_,selected = GetTalentInfo(2,1,1)
		
		self.CD:Show()
		
		if ((duration or 0) > 1.5) then
			--self.cooldown.start = cdStart
			--self.duration = duration
		end
		
		local tidalForce = Auras:RetrieveAuraInfo('player',246729)
	
		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:GlowHandler(self)
		
		if (selected) then
			if (maxCharges > 1) then
				if (charges == 2) then
					self.ChargeCD:Hide()
					self.ChargeCD:SetCooldown(0,0)
				elseif (charges < 2) then
					self.ChargeCD:Show()
					self.ChargeCD:SetCooldown(chgStart,chgDuration)
				end
				if (charges > 0) then
					self.Charges.text:SetText(charges)
					self.CD.text:SetText('')
				else
					Auras:CooldownHandler(self,groupID,chgStart,chgDuration)
					self.Charges.text:SetText('')
				end
			else
				self.Charges.text:SetText('')
				--if ((duration or 0) > 2 and not buff) then
				--[[if (not tidalForce) then
					--Auras:ToggleCooldownSwipe(self,3)
					--Auras:ExecuteCooldown(self,start,duration,false,false,3)
					Auras:CooldownHandler(self,3,'primary',1,start,duration)
					self.CD:Show()
				else
					--Auras:ToggleCooldownSwipe(self.CD,false)
					self.CD:Hide()
				end]]
			end
		else
			Auras:CooldownHandler(self,groupID,cdStart,cdDuration)
		end
		
		if (tidalForce) then
			Auras:ToggleOverlayGlow(self.glow,true)
		else
			Auras:ToggleOverlayGlow(self.glow,false)
		end
		
		if (Auras:IsPlayerInCombat(true)) then
			self:SetAlpha(1)
		else
			Auras:NoCombatDisplay(self,groupID)
		end
	else
		Auras:ToggleAuraVisibility(self,false,'showhide')
	end
end)