local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW Functions
local GetTalentInfo = GetTalentInfo

-- Cache Global Addon Variables
local ForcefulWinds = SSA.ForcefulWinds

-- Initialize Data Variables
ForcefulWinds.spellID = 262652
ForcefulWinds.pulseTime = 0
ForcefulWinds.elapsed = 0
ForcefulWinds.condition = function()
	local _,_,_,selected = GetTalentInfo(2,2,1)
	
	return selected
end

SSA.ForcefulWinds:SetScript('OnUpdate', function(self,elapsed)
	if (not Auras.db.char.isFirstEverLoad) then
		if (Auras:RefreshRateHandler(0.5,self.elapsed)) then
			self.elapsed = 0
			
			if ((Auras:CharacterCheck(self,2) and self.condition()) or Auras:IsPreviewingAura(self)) then
				local groupID = Auras:GetAuraGroupID(self,self:GetName())
				local buff,_,count,_,duration,expires = Auras:RetrieveAuraInfo('player', self.spellID)

				Auras:SetGlowStartTime(self,((expires or 0) - (duration or 0)),duration,self.spellID,"buff")
				Auras:GlowHandler(self,groupID)
				Auras:ToggleAuraVisibility(self,true,'showhide')
				Auras:CooldownHandler(self,groupID,((expires or 0) - (duration or 0)),duration,true)
			
				if ((count or 0) >= 1) then
					self.Charges.text:SetText(count)
				else
					self.Charges.text:SetText('')
				end
					
				if (Auras:IsPlayerInCombat(true)) then
					if (buff) then
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