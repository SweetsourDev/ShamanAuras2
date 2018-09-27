local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW Functions
--local AuraUtil = AuraUtil

-- Cache Global Addon Variables
local EarthShield = SSA.EarthShield

-- Initialize Data Variables
EarthShield.spellID = 974
EarthShield.condition = function()
	local row,col = (SSA.spec == 1 and 3) or (SSA.spec == 2 and 3) or (SSA.spec == 3 and 2), (SSA.spec == 1 and 2) or (SSA.spec == 2 and 2) or (SSA.spec == 3 and 3)
	
	return select(4,GetTalentInfo(row,col,1))
end

EarthShield:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,0,self.spellID)) then
		--local spec,groupID = Auras:GetAuraInfo(self,self:GetName())
		local groupID = Auras:GetAuraGroupID(self,self:GetName())
		local buff,_,count,_,duration,expires = Auras:RetrieveAuraInfo("player",self.spellID,"HELPFUL")
		--local buff,_,count,_,duration,expires = AuraUtil.FindAuraByName(Auras:GetSpellName(self.spellID),"player")
		local tarBuff,_,tarCount,_,tarDuration,tarExpires,tarCaster = Auras:RetrieveAuraInfo("target",self.spellID,"HELPFUL PLAYER")
		--local tarBuff,_,tarCount,_,tarDuration,tarExpires,tarCaster = AuraUtil.FindAuraByName("target", Auras:GetSpellName(self.spellID))
		
		Auras:ToggleAuraVisibility(self,true,'showhide')
		
		if (buff) then
			Auras:CooldownHandler(self,groupID,((expires or 0) - (duration or 0)),duration)
		elseif (tarBuff and tarCaster == 'player') then
			Auras:CooldownHandler(self,groupID,((tarExpires or 0) - (tarDuration or 0)),tarDuration)
		end
		
		-- Hide the cooldown text
		self.CD.text:SetText('')
		
		if ((count or 0) >= 1 or (tarCount or 0) >= 1) then
			self.Charges.text:SetText(count or tarCount)
		else
			self.Charges.text:SetText('')
		end
		
		-- If no buff is found, reset the cooldown widget duration
		if (not buff and not tarBuff) then
			Auras:CooldownHandler(self,groupID,0,0)
		end
		
		if (Auras:IsPlayerInCombat()) then
			if (buff or tarBuff) then
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
end)