local SSA, Auras, _, LSM = unpack(select(2,...))

-- Cache Global WoW API Functions
local CreateFrame = CreateFrame
local GetTime = GetTime

-- Cache Global Addon Variables
local AuraBase = SSA.AuraBase

local function SetTidalWavesAnimationState(self,isAnimate,isShown,count,color)
	if (isShown and (not count or count == 0)) then
		self:SetValue(2)
		self:SetStatusBarColor(color.r,color.g,color.b)
		
		if (isAnimate) then
			if (not self.Flash:IsPlaying()) then
				self.Flash:Play()
			end
		else
			self:SetAlpha(1)
			if (self.Flash:IsPlaying()) then
				self.Flash:Stop()
			end
		end
	elseif (not isShown or count > 0) then
		if (self.Flash:IsPlaying()) then
			self.Flash:Stop()
		end
		if (not isShown) then
			self:SetAlpha(0)
		else
			self:SetAlpha(1)
		end
		self:SetStatusBarColor(0.35,0.76,1)
		self:SetValue(count or 0)
	end
end


local TidalWavesBar = CreateFrame('StatusBar','TidalWavesBar',AuraBase)
TidalWavesBar:SetStatusBarTexture([[Interface\addons\ShamanAuras\media\statusbar\Halves]])
TidalWavesBar:GetStatusBarTexture():SetHorizTile(false)
TidalWavesBar:GetStatusBarTexture():SetVertTile(false)
TidalWavesBar:SetMinMaxValues(0,2)
TidalWavesBar:SetAlpha(0)
TidalWavesBar:Show()

TidalWavesBar.bg = TidalWavesBar:CreateTexture(nil,'BACKGROUND')
TidalWavesBar.bg:SetAllPoints(true)

-- Animation for Tidal Waves Status Bar
TidalWavesBar.Flash = TidalWavesBar:CreateAnimationGroup()
TidalWavesBar.Flash:SetLooping('BOUNCE')

TidalWavesBar.Flash.fadeIn = TidalWavesBar.Flash:CreateAnimation('Alpha')
TidalWavesBar.Flash.fadeIn:SetFromAlpha(1)
TidalWavesBar.Flash.fadeIn:SetToAlpha(0.25)
TidalWavesBar.Flash.fadeIn:SetDuration(0.33)

TidalWavesBar.Flash.fadeOut = TidalWavesBar.Flash:CreateAnimation('Alpha')
TidalWavesBar.Flash.fadeOut:SetFromAlpha(0.25)
TidalWavesBar.Flash.fadeOut:SetToAlpha(1)
TidalWavesBar.Flash.fadeOut:SetDuration(0.33)
TidalWavesBar.Flash.fadeOut:SetEndDelay(0)

TidalWavesBar.healTime = 0

TidalWavesBar:SetScript('OnUpdate',function(self)
	if (Auras:CharacterCheck(nil,3)) then
		local db = Auras.db.char
		local bar = Auras.db.char.statusbars[3].bars[self:GetName()]
		local isMoving = db.settings.move.isMoving

		if (isMoving or bar.adjust.isEnabled) then
			if (self.Flash:IsPlaying()) then
				self.Flash:Stop()
			end
			self:SetAlpha(1)
		end
		
		Auras:ToggleProgressBarMove(self,isMoving,bar)
		
		if (isMoving) then
			self:SetValue(2)
		end
		
		if (Auras:IsPreviewingStatusbar(self)) then
			if (self.Flash:IsPlaying()) then
				self.Flash:Stop()
			end
			
			if (bar.adjust.showBG) then
				self:SetValue(1)
			else
				self:SetValue(2)
			end
			
			self:SetStatusBarTexture(LSM.MediaTable.statusbar[bar.foreground.texture])
			self:SetStatusBarColor(bar.foreground.color.r,bar.foreground.color.g,bar.foreground.color.b)
			
			self.bg:SetTexture(LSM.MediaTable.statusbar[bar.background.texture])
			self.bg:SetVertexColor(bar.background.color.r,bar.background.color.g,bar.background.color.b,bar.background.color.a)
			
			self:SetWidth(bar.layout.width)
			self:SetHeight(bar.layout.height)
			--self:SetPoint(bar.layout.point,AuraBase,bar.layout.point,bar.layout.x,bar.layout.y)
			self:SetFrameStrata(bar.layout.strata)
		end
		
		if (bar.isEnabled and not isMoving and not bar.adjust.isEnabled) then
			local buff,_,count,_,duration,expires = Auras:RetrieveAuraInfo('player',Auras:GetSpellName(53390))
			local remaining,progress
			
			if (buff) then
				remaining = expires - GetTime()
				progress = 15 - remaining
			end
		
			if (Auras:IsPlayerInCombat(true)) then
				if (Auras:IsTargetFriendly()) then
					if (bar.combatDisplay == 'Never') then
						--SSA.DataFrame.text:SetText("1")
						SetTidalWavesAnimationState(self,bar.animate,false,count,bar.emptyColor)
					elseif (bar.combatDisplay == 'On Heal Only') then
						if ((progress or 0) <= bar.OoCTime and (progress or 0) ~= 0) then
							--SSA.DataFrame.text:SetText("13")
							SetTidalWavesAnimationState(self,bar.animate,true,count,bar.emptyColor)
						else
							--SSA.DataFrame.text:SetText("14")
							SetTidalWavesAnimationState(self,bar.animate,false,count,bar.emptyColor)
						end
					else
						--SSA.DataFrame.text:SetText("2")
						SetTidalWavesAnimationState(self,bar.animate,true,count,bar.emptyColor)
					end
				else
					if (bar.combatDisplay == 'Target Only') then
						--SSA.DataFrame.text:SetText("3")
						SetTidalWavesAnimationState(self,bar.animate,false,count,bar.emptyColor)
					else
						if (bar.combatDisplay == 'Always') then
							--SSA.DataFrame.text:SetText("4")
							SetTidalWavesAnimationState(self,bar.animate,true,count,bar.emptyColor)
						elseif (bar.combatDisplay == 'Never') then
							--SSA.DataFrame.text:SetText("5")
							SetTidalWavesAnimationState(self,bar.animate,false,count,bar.emptyColor)
						elseif (bar.combatDisplay == 'Target & On Heal' or bar.combatDisplay == 'On Heal Only') then
							if ((progress or 0) <= bar.OoCTime and (progress or 0) ~= 0) then
								--SSA.DataFrame.text:SetText("6")
								SetTidalWavesAnimationState(self,bar.animate,true,count,bar.emptyColor)
							else
								--SSA.DataFrame.text:SetText("7")
								SetTidalWavesAnimationState(self,bar.animate,false,count,bar.emptyColor)
							end
						else
							--SSA.DataFrame.text:SetText("??")
						end
					end
				end
			else
				if (Auras:IsTargetFriendly()) then
					if (bar.OoCDisplay == 'Never') then
						--SSA.DataFrame.text:SetText("8")
						SetTidalWavesAnimationState(self,bar.animate,false,count,bar.emptyColor)
					elseif (bar.OoCDisplay == 'On Heal Only') then
						if ((progress or 0) <= bar.OoCTime and (progress or 0) ~= 0) then
							--SSA.DataFrame.text:SetText("13")
							SetTidalWavesAnimationState(self,bar.animate,true,count,bar.emptyColor)
						else
							--SSA.DataFrame.text:SetText("14")
							SetTidalWavesAnimationState(self,bar.animate,false,count,bar.emptyColor)
						end
					else
						--SSA.DataFrame.text:SetText("9")
						SetTidalWavesAnimationState(self,bar.animate,true,count,bar.emptyColor)
					end
				else
					--SSA.DataFrame.text:SetText("15")
					if (bar.OoCDisplay == 'Target Only') then
						--SSA.DataFrame.text:SetText("10")
						SetTidalWavesAnimationState(self,bar.animate,false,count,bar.emptyColor)
					else
						--SSA.DataFrame.text:SetText("16")
						if (bar.OoCDisplay == 'Always') then
							--SSA.DataFrame.text:SetText("11")
							SetTidalWavesAnimationState(self,bar.animate,true,count,bar.emptyColor)
						elseif (bar.OoCDisplay == 'Never') then
							--SSA.DataFrame.text:SetText("12")
							SetTidalWavesAnimationState(self,bar.animate,false,count,bar.emptyColor)
						elseif (bar.OoCDisplay == 'Target & On Heal' or bar.OoCDisplay == 'On Heal Only') then
							if ((progress or 0) <= bar.OoCTime and (progress or 0) ~= 0) then
								--SSA.DataFrame.text:SetText("13")
								SetTidalWavesAnimationState(self,bar.animate,true,count,bar.emptyColor)
							else
								--SSA.DataFrame.text:SetText("14")
								SetTidalWavesAnimationState(self,bar.animate,false,count,bar.emptyColor)
							end
						end
					end
				end	
			end
		elseif (not bar.isEnabled and not isMoving and not bar.adjust.isEnabled) then
			
			if (self.Flash:IsPlaying()) then
				self.Flash:Stop()
			end
			self:SetAlpha(0)
		end
	else
		if (self.Flash:IsPlaying()) then
			self.Flash:Stop()
		end
		self:SetAlpha(0)
	end
end)

TidalWavesBar:SetScript('OnMouseDown',function(self,button)
	if (Auras.db.char.settings.move.isMoving) then
		Auras:MoveOnMouseDown(self,button)
	end
end)

TidalWavesBar:SetScript('OnMouseUp',function(self,button)
	if (Auras.db.char.settings.move.isMoving) then
		Auras:MoveOnMouseUp(self,button)
		Auras:UpdateLayout(self,Auras.db.char.statusbars[3].bars.TidalWavesBar)
	end
end)

SSA.TidalWavesBar = TidalWavesBar
_G["SSA_TidalWavesBar"] = TidalWavesBar