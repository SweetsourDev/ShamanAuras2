local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW Functions
local GetTalentInfo = GetTalentInfo

-- Cache Global Addon Variables
local UnlimitedPower = SSA.UnlimitedPower

-- Initialize Data Variables
UnlimitedPower.spellID = 260895
UnlimitedPower.condition = function()
	return select(4,GetTalentInfo(7,1,1))
end

UnlimitedPower:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(self,1,7,1)) then
		local groupID = Auras:GetAuraGroupID(self,self:GetName())
		local buff,_,count,_,duration,expires,caster = Auras:RetrieveAuraInfo("player", 272737)
		
		Auras:ToggleAuraVisibility(self,true,'showhide')
		Auras:CooldownHandler(self,groupID,((expires or 0) - (duration or 0)),duration)
		
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
			Auras:NoCombatDisplay(self,groupID)
		end
	else
		Auras:ToggleAuraVisibility(self,false,'showhide')
	end
end)