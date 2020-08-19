local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCooldown = GetSpellCooldown
local GetTalentInfo = GetTalentInfo

-- Cache Global Addon Variables
local CloudburstTotem = SSA.CloudburstTotem

-- Initialize Data Variables
CloudburstTotem.spellID = 157153
CloudburstTotem.pulsetime = 0
CloudburstTotem.elapsed = 0
CloudburstTotem.condition = function()
	local _,_,_,selected = GetTalentInfo(6,3,1)
	
	return selected
end

CloudburstTotem:SetScript('OnUpdate',function(self,elapsed)
	if (Auras:RefreshRateHandler(0.5,self.elapsed)) then
		self.elapsed = 0
		
		if ((Auras:CharacterCheck(self,3) and self.condition()) or Auras:IsPreviewingAura(self)) then
			local groupID = Auras:GetAuraGroupID(self,self:GetName())
			local start,duration = GetSpellCooldown(Auras:GetSpellName(self.spellID))
			local charges,maxCharges,chgStart,chgDuration = GetSpellCharges(self.spellID)
			local _,_,_,selected = GetTalentInfo(2,1,1)
		
			if (selected) then
				if ((charges or 0) == 0) then
					Auras:SetGlowStartTime(self,chgStart,chgDuration,self.spellID,"cooldown")
				else
					local trigger = Auras.db.char.auras[3].auras[self:GetName()].glow.triggers[1]
					
					trigger.start = 0
				end
			else
				Auras:SetGlowStartTime(self,start,duration,self.spellID,"cooldown")
			end
			
			--Auras:SetGlowStartTime(self,start,duration,self.spellID,"cooldown")
			Auras:GlowHandler(self)
			Auras:ToggleAuraVisibility(self,true,'showhide')
			Auras:CooldownHandler(self,groupID,start,duration)
			
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
				if ((duration or 0) > 2 and not buff) then
					Auras:CooldownHandler(self,groupID,start,duration)
					self.CD:Show()
				else
					self.CD:Hide()
				end
			end
			
			if (Auras:IsPlayerInCombat(true)) then
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
end)