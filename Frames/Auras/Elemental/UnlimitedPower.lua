local SSA, Auras = unpack(select(2,...))

-- Cache Global Addon Variables
local UnlimitedPower = SSA.UnlimitedPower

UnlimitedPower:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,1,7,1)) then
		local spec,groupID = Auras:GetAuraInfo(self,'UnlimitedPower')
		local buff,_,count,_,duration,expires,caster = Auras:RetrieveBuffInfo("player", Auras:GetSpellName(272737))
		
		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:CooldownHandler(self,spec,groupID,((expires or 0) - (duration or 0)),duration)
		
		self.CD.text:SetText('')
		
		if ((count or 0) >= 1) then
			self.Charges.text:SetText(count)
		else
			self.Charges.text:SetText('')
		end
		
		if (Auras:IsPlayerInCombat()) then
			if (buff) then
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