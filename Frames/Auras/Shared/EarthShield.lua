local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW Functions
--local AuraUtil = AuraUtil

-- Cache Global Addon Variables
local EarthShield = SSA.EarthShield

-- Initialize Data Variables
EarthShield.spellID = 974
EarthShield.pulseTime = 0
EarthShield.charges = 0
EarthShield.elapsed = 0
EarthShield.duration = 600
EarthShield.applyTime = 0
EarthShield.activeCtr = 0
EarthShield.targetName = ''
EarthShield.isCasted = false
EarthShield.condition = function()
	local row,col = (SSA.spec == 1 and 3) or (SSA.spec == 2 and 3) or (SSA.spec == 3 and 2), (SSA.spec == 1 and 2) or (SSA.spec == 2 and 2) or (SSA.spec == 3 and 3)
	local _,_,_,selected = GetTalentInfo(row,col,1)
	
	return selected
end

EarthShield:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

EarthShield:SetScript('OnUpdate',function(self,elapsed)
	if (Auras:RefreshRateHandler(0.5,self.elapsed)) then
		self.elapsed = 0
		
		if ((Auras:CharacterCheck(self,0) and self.condition()) or Auras:IsPreviewingAura(self)) then
			--local spec,groupID = Auras:GetAuraInfo(self,self:GetName())
			local groupID = Auras:GetAuraGroupID(self,self:GetName())
			
			
			
			--[[if ((duration or 0) > 1.5) then
				self.buff.start = expires - duration
				--self.duration = duration
			elseif ((tarDuration or 0) > 1.5) then
				self.buff.start = tarExpires - tarDuration
				--self.duration = tarDuration
			end]]
			
			if (not self.nameFrame) then
				self.nameFrame = self:CreateFontString(nil, 'MEDIUM', 'GameFontHighlightLarge')
				self.nameFrame:SetFont([[Interface\addons\ShamanAuras\media\fonts\PT_Sans_Narrow.TTF]], 18,'OUTLINE')
				--self.nameFrame:SetAllPoints(Frame.CD)
				--self.nameFrame:SetSize(self:GetWidth(),(self:GetHeight))
				self.nameFrame:SetPoint('BOTTOM',self,'TOP',0,0)
				self.nameFrame:SetTextColor(1,1,1,1)
				self.nameFrame:SetText('')
			end
					
			local msg = 'Active Count: '..self.applyTime.." ("..self.targetName..")\n"
			
			--if (self.activeCtr > 0 and self.targetName ~= '') then
			if (self.applyTime > 0 and self.targetName ~= '') then
				if (self.targetName ~= "player") then
					msg = msg.."PLAYER: False\n"
					if (UnitExists(self.targetName) and C_PlayerInfo.IsConnected(PlayerLocation:CreateFromUnit(self.targetName)) and GetTime() < (self.applyTime + self.duration)) then
						local buff,_,count,_,duration,expires,caster = Auras:RetrieveAuraInfo(self.targetName,self.spellID,"HELPFUL")
						--local tarBuff,_,tarCount,_,tarDuration,tarExpires,tarCaster = AuraUtil.FindAuraByName("target", Auras:GetSpellName(self.spellID))
						
						msg = msg.."ACTIVE: "..tostring(buff)..", "..tostring(duration).."\n"
						if ((duration or 0) > 0) then
							msg = msg.."IN RANGE: True\n"
							self.texture:SetVertexColor(1,1,1)
							
							if ((count or 0) >= 1) then
								self.Charges.text:SetText(count)
							else
								self.Charges.text:SetText('')
							end
				
							Auras:CooldownHandler(self,groupID,((expires or 0) - (duration or 0)),duration)
						elseif (type(duration) ~= "number" and not duration) then
							--self.targetName = ''
							--self.charges = 0
							--self.activeCtr = 0
							self.Charges.text:SetText('')
							--self.nameFrame:SetText('')
							Auras:CooldownHandler(self,groupID,0,0)
							self.texture:SetVertexColor(1,0,0)
						else
							msg = msg.."IN RANGE: False\n"
							self.texture:SetVertexColor(1,0,0)
						end
					else
						msg = msg.."ACTIVE: False\n"
						self.targetName = ''
						self.charges = 0
						self.activeCtr = 0
						self.Charges.text:SetText('')
						self.nameFrame:SetText('')
						self.texture:SetVertexColor(1,1,1)
						Auras:CooldownHandler(self,groupID,0,0)
					end
				else
					local buff,_,count,_,duration,expires = Auras:RetrieveAuraInfo("player",self.spellID,"HELPFUL")
					--local buff,_,count,_,duration,expires = AuraUtil.FindAuraByName(Auras:GetSpellName(self.spellID),"player")
					
					--msg = "PLAYER: True\n"
					self.texture:SetVertexColor(1,1,1)
					self.nameFrame:SetText('')
					
					if (buff) then
						if ((count or 0) >= 1) then
							self.Charges.text:SetText(count)
						else
							self.Charges.text:SetText('')
						end
						
						Auras:CooldownHandler(self,groupID,((expires or 0) - (duration or 0)),duration)
					end
				end
			end
			
			--SSA.DataFrame.text:SetText(msg)
			--self.charges = ((count or 0) > 0 and count) or ((tarCount or 0) > 0 and tarCount) or 0
			
			Auras:GlowHandler(self)
			Auras:ToggleAuraVisibility(self,true,'showhide')
			
			--if (buff) then
			--if (self.activeCtr > 0) then
			
			
			
--[[			if (self.targetName ~= "" and self.targetName ~= "player") then
				if (UnitExists(self.targetName)) then
					print("Unit Exists: "..tostring(UnitExists(self.targetName)))
				end
			end
			
				if (self.activeCtr > 0 and ((self.targetName ~= '' and self.targetName ~= "player" and UnitExists(self.targetName)) or self.targetName == "player")) then
					Auras:CooldownHandler(self,groupID,((self.applyTime + self.duration) - self.duration),self.duration)
				else
					self.activeCtr = 0
					Auras:CooldownHandler(self,groupID,0,0)
				end
]]				
				
				
				
				
				--Auras:CooldownHandler(self,groupID,((expires or 0) - (duration or 0)),duration)
				--self.nameFrame:SetText('')
			--elseif (tarBuff and tarCaster == 'player') then
				--Auras:CooldownHandler(self,groupID,((tarExpires or 0) - (tarDuration or 0)),tarDuration)
			--elseif (not UnitExists('target') and not UnitExists("mouseover")) then
			--else
				--self.nameFrame:SetText('')
			--end
			
			-- Hide the cooldown text
			self.CD.text:SetText('')
			
			--[[if ((count or 0) >= 1 or (tarCount or 0) >= 1) then
				self.Charges.text:SetText(count or tarCount)
			else
				self.Charges.text:SetText('')
			end]]
			
			
--[[			if (self.charges >= 1 and self.activeCtr > 0) then
				self.Charges.text:SetText(self.charges)
			else
				self.Charges.text:SetText('')
			end
]]			
			-- If no buff is found, reset the cooldown widget duration
			--if (not buff and not tarBuff) then
			--[[if (self.activeCtr <= 0) then
				self.activeCtr = 0
				Auras:CooldownHandler(self,groupID,0,0)
			end]]
			
			if (Auras:IsPlayerInCombat()) then
				--if (buff or tarBuff) then
				if (self.activeCtr > 0) then
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
end)

local function FormatName(name)
	if (#name > 10) then
		return strsub(name,1,10)
	else
		return name
	end
end

EarthShield:SetScript("OnEvent",function(self,event)
	if (event ~= "COMBAT_LOG_EVENT_UNFILTERED" or Auras.db.char.isFirstEverLoad) then
		return
	end
	local spec = SSA.spec or GetSpecialization()
	
	local glow = Auras.db.char.auras[spec].auras[self:GetName()].glow
	local _,subevent,_,srcGUID,_,_,_,destGUID,destName,_,_,spellID,_,_,_,count = CombatLogGetCurrentEventInfo()

	if (subevent == "SPELL_CAST_SUCCESS" and srcGUID == UnitGUID("player") and destGUID ~= UnitGUID("player")) then
		self.isCasted = true
	elseif (((subevent == "SPELL_AURA_APPLIED" or subevent == "SPELL_AURA_REFRESH" or subevent == "SPELL_AURA_APPLIED_DOSE" or subevent == "SPELL_AURA_REMOVED_DOSE" or subevent == "SPELL_AURA_REMOVED") and srcGUID == UnitGUID("player")) and spellID == self.spellID) then
		if (subevent == "SPELL_AURA_APPLIED" or subevent == "SPELL_AURA_REFRESH" or subevent == "SPELL_AURA_APPLIED_DOSE") then
			--self.charges = 9
			
			if (self.isCasted) then
				self.applyTime = GetTime()
				print("CASTED EARTH SHIELD")
				--self.activeCtr = self.activeCtr + 1
				self.isCasted = false
			else
				print("DIDN'T CASTED EARTH SHIELD")
			end
			
			if (destGUID ~= UnitGUID("player") and UnitExists(destName) and C_PlayerInfo.IsConnected(PlayerLocation:CreateFromUnit(destName))) then
				print("SETTING TARGET NAME")
				self.targetName = destName
				self.nameFrame:SetText(FormatName(destName))
				--print("Unit EXIST: "..tostring(destName).." ("..tostring(UnitExists(destName)))
			else
				self.targetName = 'player'
				self.applyTime = GetTime()
				self.isCasted = false
				if (self.nameFrame) then
					self.nameFrame:SetText('')
				end
			end
			
			
			
			for i=1,#glow.triggers do
				local trigger = glow.triggers[i]
				
				if ((trigger.spellID or 0) == spellID and trigger.type ~= "charges") then
					trigger.start = GetTime()
					--self.isTriggered = false
				end
			end
		elseif (subevent == "SPELL_AURA_REMOVED") then
			--self.charges = 0
			--self.activeCtr = self.activeCtr - 1
			if (not self.isCasted) then
				self.applyTime = 0
			end
			
			if (self.activeCtr <= 0) then
				self.activeCtr = 0
				
				for i=1,#glow.triggers do
					local trigger = glow.triggers[i]
					
					if ((trigger.spellID or 0) == spellID) then
						trigger.start = 0
					end
				end
			end
		elseif (subevent == "SPELL_AURA_REMOVED_DOSE") then
			--self.charges = self.charges - 1
			
			for i=1,#glow.triggers do
				local trigger = glow.triggers[i]
				
				if (trigger.type == "charges") then
					if (count <= trigger.threshold and count > 0) then
						trigger.start = GetTime()
					else
						trigger.start = 0
						--self.isTriggered = false
					end
				end
			end
		else
			print("NO CHARGES")
		end
	end
end)