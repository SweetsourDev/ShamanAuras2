local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW API Functions
local GetSpellCooldown = GetSpellCooldown
local GetTalentInfo = GetTalentInfo

-- Cache Global Addon Variables
local SurgeOfEarth = SSA.SurgeOfEarth

-- Initialize Data Variables
SurgeOfEarth.spellID = 320746
SurgeOfEarth.pulseTime = 0
SurgeOfEarth.elapsed = 0
SurgeOfEarth.condition = function()
	local _,_,_,selected = GetTalentInfo(2,3,1)
	
	return selected
end

SurgeOfEarth:SetScript('OnUpdate',function(self,elapsed)
	if (Auras:RefreshRateHandler(0.5,self.elapsed)) then
		self.elapsed = 0

		if ((Auras:CharacterCheck(self,3) and self.condition()) or Auras:IsPreviewingAura(self)) then
			local groupID = Auras:GetAuraGroupID(self,self:GetName())
			--local spell = Auras:GetSpellName(191634)
			local buff,_,count,_,buffDuration,expires = Auras:RetrieveAuraInfo("player", 974) --Earth Shield
			local start,duration = GetSpellCooldown(Auras:GetSpellName(self.spellID))
			
			Auras:SetGlowStartTime(self,start,duration,self.spellID,"cooldown")
			Auras:SetGlowStartTime(self,((expires or 0) - (buffDuration or 0)),buffDuration,self.spellID,"buff")
			Auras:GlowHandler(self)
			Auras:ToggleAuraVisibility(self,true,'showhide')
			Auras:CooldownHandler(self,groupID,start,duration)

			-- The Charge CD frame is not needed
			if (not self.ChargeCD:IsShown()) then
				self.ChargeCD:Hide()
			end

			if (buff) then
				self.Charges:Show()
				self.Charges.text:SetText(count >= 3 and "3" or count)
				self.texture:SetDesaturated(false)
				self.texture:SetVertexColor(1,1,1,1)
			else
				self.texture:SetDesaturated(true)
				self.texture:SetVertexColor(1,0,0,1)

				--self.CD:SetAlpha(1)
				
				self.Charges:Hide()
			end

			-- Hide the Charge text while the ability is on cooldown
			if (start > 0) then
				self.Charges:Hide()
			else
				self.Charges:Show()
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
end)