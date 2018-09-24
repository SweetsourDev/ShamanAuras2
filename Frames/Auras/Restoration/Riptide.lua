local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCharges, GetSpellCooldown = GetSpellCharges, GetSpellCooldown
local GetTalentInfo = GetTalentInfo

-- Cache Global Addon Variables
local Riptide = SSA.Riptide

Riptide:SetScript('OnUpdate', function(self)
	if (Auras:CharacterCheck(self,3,61295)) then
		local spec,groupID = Auras:GetAuraInfo(self,self:GetName())
		local start,duration = GetSpellCooldown(Auras:GetSpellName(61295))
		local charges,maxCharges,chgStart,chgDuration = GetSpellCharges(61295)
		local _,_,_,selected = GetTalentInfo(2,1,1)
		
		self.CD:Show()
		
		local tidalForce = Auras:RetrieveBuffInfo('player',Auras:GetSpellName(246729))
	
		Auras:ToggleAuraVisibility(self,true,'showhide')
		
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
					Auras:CooldownHandler(self,spec,groupID,chgStart,chgDuration)
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
			Auras:CooldownHandler(self,spec,groupID,start,duration)
		end
		
		if (tidalForce) then
			Auras:ToggleOverlayGlow(self.glow,true)
		else
			Auras:ToggleOverlayGlow(self.glow,false)
		end
		
		if (Auras:IsPlayerInCombat(true)) then
			self:SetAlpha(1)
		else
			Auras:NoCombatDisplay(self,spec,groupID)
		end
	else
		Auras:ToggleAuraVisibility(self,false,'showhide')
	end
end)