local SSA, Auras = unpack(select(2,...))


-- Cache Global Addon Variables
local Tidebringer = SSA.Tidebringer

--[[local function IncrementTidebringerTimer()
	local db = Auras.db.char.elements[3].cooldowns.primary[4]
	
	if (GetTime() > (Auras.db.char.elements[3].cooldowns.primary[4] + 8)) then
		Auras.db.char.elements[3].cooldowns.primary[4] = Auras.db.char.elements[3].cooldowns.primary[4] + 8
		IncrementTidebringerTimer()
	end
end]]

-- Initialize Data Variables
Tidebringer.spellID = 236501
Tidebringer.elapsed = 0
Tidebringer.condition = function()
	local _,_,_,_,_,_,_,_,_,selected = GetPvpTalentInfoByID(1930)
	
	return selected and Auras:IsPvPZone()
end

--SSA.Tidebringer.isTimerActive = false
Tidebringer:SetScript('OnUpdate',function(self,elapsed)
	if (not Auras.db.char.isFirstEverLoad) then
		if (Auras:RefreshRateHandler(0.5,self.elapsed)) then
			self.elapsed = 0
			
			if ((Auras:CharacterCheck(self,3) and self.condition()) or Auras:IsPreviewingAura(self)) then
				local groupID = Auras:GetAuraGroupID(self,self:GetName())
				local buff,_,count = Auras:RetrieveAuraInfo("player",236502)
				local pvpBuff = Auras:RetrieveAuraInfo("player",269083)
				
				--if (not self.auraTimer) then self.auraTimer = Auras.db.char.elements[3].cooldowns.primary[4].tidebringerStart end
				
				Auras:ToggleAuraVisibility(self,true,'showhide')

				--if (pvpBuff and self.isTimerActive) then
				if (pvpBuff) then
					--[[while ((self.auraTimer + 8) < GetTime() and self.auraTimer > 0) do
					--while ((self.auraTimer + 8) < GetTime() and self.auraTimer > 0) do
						self.auraTimer = self.auraTimer + 8
						Auras.db.char.elements[3].cooldowns.primary[4].tidebringerStart = Auras.db.char.elements[3].cooldowns.primary[4].tidebringerStart + 8
						--SSA.DataFrame.text:SetText(Auras:CurText('DataFrame').."Increment!\n")
					end]]
					
					--[[if (GetTime() >= (self.auraTimer + 8)) then
						self.auraTimer = GetTime()
						Auras.db.char.elements[3].cooldowns.primary[4].tidebringerStart = GetTime()
					end]]
					
					if ((count or 0) < 2) then
						if (not self.CD:IsShown()) then
							self.CD:Show()
						end
						
						--Auras:CooldownHandler(self,3,'primary',4,self.auraTimer,8)
					else
						self.CD:Hide()
					end

					if ((count or 0) > 0) then
						self.Charges.text:SetText(count)
						self.CD.text:SetText('')
					else
						self.ChargeCD:Hide()
						self.Charges.text:SetText('')
					end
				else
					--[[if (self.auraTimer > 0) then
						self.auraTimer = 0
						Auras.db.char.elements[3].cooldowns.primary[4].tidebringerStart = 0
					end]]
					
					self.Charges.text:SetText(count)
					self.CD.text:SetText('')
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
	end
end)