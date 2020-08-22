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
Riptide.elapsed = 0
Riptide.condition = function()
	return IsSpellKnown(61295)
end

Riptide:SetScript('OnUpdate',function(self,elapsed)
	if (not Auras.db.char.isFirstEverLoad) then
		if (Auras:RefreshRateHandler(0.5,self.elapsed)) then
			self.elapsed = 0
			
			if ((Auras:CharacterCheck(self,3) and self.condition()) or Auras:IsPreviewingAura(self)) then
				local groupID = Auras:GetAuraGroupID(self,self:GetName())
				local cdStart,cdDuration = GetSpellCooldown(Auras:GetSpellName(self.spellID))
				local charges,maxCharges,chgStart,chgDuration = GetSpellCharges(self.spellID)
				local _,_,_,_,twDuration,twExpire = Auras:RetrieveAuraInfo("player",53390,"HELPFUL")
				local _,_,_,_,tfDuration,tfExpire = Auras:RetrieveAuraInfo("player",246729,"HELPFUL")
				local _,_,_,selected = GetTalentInfo(2,1,1)
				local glow = Auras.db.char.auras[3].auras[self:GetName()].glow
				
				--self.CD:Show()

				if (selected) then
					if ((charges or 0) == 0) then
						if ((chgDuration or 0) > 0) then
							Auras:SetGlowStartTime(self,chgStart,chgDuration,self.spellID,"cooldown")
						end
					else
						local glow = Auras.db.char.auras[3].auras[self:GetName()].glow
						
						for i=1,#glow.triggers do
							local trigger = glow.triggers[i]
							
							if (trigger.type == "cooldown") then
								trigger.start = 0
							end
						end
					end
				else
					Auras:SetGlowStartTime(self,cdStart,cdDuration,self.spellID,"cooldown")
				end
				Auras:SetGlowStartTime(self,((twExpire or 0) - (twDuration or 0)),twDuration,53390,"buff")
				Auras:SetGlowStartTime(self,((tfExpire or 0) - (tfDuration or 0)),tfDuration,246729,"buff")
				--[[if ((cdDuration or 0) > 1.5) then
					for i=1,#glow.triggers do
						local trigger = glow.triggers[i]
						
						if ((trigger.spellID or 0) == self.spellID) then
							if (trigger.start == 0) then
								trigger.start = GetTime()
							end
						end
					end
				end]]
				--[[SSA.DataFrame.text:SetText(GetTime().."\n\n")
				for i=1,#glow.triggers do
					local trigger = glow.triggers[i]
					
					SSA.DataFrame.text:SetText(Auras:CurText('DataFrame')..i..". "..trigger.start.." ("..tostring(trigger.isActive)..")\n")
				end]]
			
				Auras:ToggleAuraVisibility(self,true,'showhide')
				Auras:GlowHandler(self,groupID)
				
				if (selected) then
					if (maxCharges > 1) then
						if (charges == 2) then
							--print("#1")
							--self.ChargeCD:SetCooldown(0,0)
							self.ChargeCD:Hide()
						elseif (charges < 2) then
							--print("#2")
							self.ChargeCD:Show()
							self.ChargeCD:SetCooldown(chgStart,chgDuration)
						end
						if (charges > 0) then
							--print("#3")
							self.Charges.text:SetText(charges)
							self.CD.text:SetText('')
						else
							--print("4")
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
					self.Charges.text:SetText('')
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
		else
			self.elapsed = self.elapsed + elapsed
		end
	end
end)

--[[Riptide:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED" or Auras.db.char.isFirstEverLoad) then
		return
	end
	local spec = SSA.spec or GetSpecialization()
	
	local glow = Auras.db.char.auras[spec].auras[self:GetName()].glow
	local _,subevent,_,srcGUID,_,_,_,destGUID,_,_,_,spellID,_,_,_,count = CombatLogGetCurrentEventInfo()
	
	if ((((subevent == "SPELL_AURA_APPLIED" or subevent == "SPELL_AURA_REFRESH") and srcGUID == UnitGUID("player")) or (subevent == "SPELL_AURA_REMOVED" and destGUID == UnitGUID("player")))and spellID == self.spellID) then
		if (subevent == "SPELL_AURA_APPLIED" or subevent == "SPELL_AURA_REFRESH") then
			for i=1,#glow.triggers do
				local trigger = glow.triggers[i]
				
				if ((trigger.spellID or 0) == spellID and trigger.type ~= "charges") then
					trigger.start = GetTime()
					--self.isTriggered = false
				end
			end
		elseif (subevent == "SPELL_AURA_REMOVED") then
			for i=1,#glow.triggers do
				local trigger = glow.triggers[i]
				
				if ((trigger.spellID or 0) == spellID) then
					trigger.start = 0
				end
			end
		end
	end
end)]]