local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local EarthShield = SSA.EarthShield

EarthShield:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,0,974)) then
		local spec,groupID = Auras:GetAuraInfo(self,'EarthShield')
		local buff,_,count,_,duration,expires = Auras:RetrieveBuffInfo("player", Auras:GetSpellName(974))
		local tarBuff,_,tarCount,_,tarDuration,tarExpires,tarCaster = Auras:RetrieveBuffInfo("target", Auras:GetSpellName(974))
		
		Auras:ToggleAuraVisibility(self,true,'showhide')
		
		if (buff) then
			Auras:CooldownHandler(self,spec,groupID,((expires or 0) - (duration or 0)),duration)
		elseif (tarBuff and tarCaster == 'player') then
			Auras:CooldownHandler(self,spec,groupID,((tarExpires or 0) - (tarDuration or 0)),tarDuration)
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
			Auras:CooldownHandler(self,spec,groupID,0,0)
		end
		
		if (Auras:IsPlayerInCombat()) then
			if (buff or tarBuff) then
				self:SetAlpha(1)
			else
				self:SetAlpha(0.5)
			end
		else
			Auras:NoCombatDisplay(self,spec,groupID)
		end
	else
		Auras:ToggleAuraVisibility(self,false,'showhide')
	end
end)