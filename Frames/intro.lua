local SSA, Auras = unpack(select(2,...))

-- Cache Global WoW Functions
local GetAddOnMetadata, IsAddOnLoaded = GetAddOnMetadata, IsAddOnLoaded


local IntroFrame = CreateFrame('Frame',nil,UIParent)
IntroFrame:SetSize(1024,512)
IntroFrame:SetPoint("CENTER",0,0)
IntroFrame:SetBackdrop(SSA.BackdropSB)
IntroFrame:SetBackdropColor(0.1,0.1,0.1,0.9)
IntroFrame:SetBackdropBorderColor(1,1,1,1)
IntroFrame:SetFrameStrata("TOOLTIP")
IntroFrame:SetAlpha(0)
--IntroFrame:Hide()

IntroFrame.logo = IntroFrame:CreateTexture(nil,'HIGH')
IntroFrame.logo:SetTexture([[Interface\AddOns\ShamanAuras2\Media\textures\logo]])
IntroFrame.logo:SetSize(1024,512)
IntroFrame.logo:SetPoint("TOP",IntroFrame,"TOP",0,-3)

IntroFrame.elapsedTime = 0
IntroFrame.currentSpeed = 0
IntroFrame.currentAlpha = 0
IntroFrame.maxAlphaTime = 0
IntroFrame.descReady = false
IntroFrame.dbReady = false
IntroFrame:SetScript("OnUpdate",function(self,elapsed)
	if ((GetAddOnMetadata("ShamanAuras2","Version") ~= Auras.db.char.version or Auras.db.char.isFirstEverLoad) and not IsAddOnLoaded("ShamanAuras")) then
		self.elapsedTime = self.elapsedTime + elapsed

		if (self.elapsedTime >= 3.5) then
			if (self:GetAlpha() < 1) then
				local appearSpeed = 0.015
				--local maxAppearSpeed = 
				local newAlpha = self:GetAlpha() + appearSpeed
				self:SetAlpha(newAlpha)
			elseif (not self.descReady) then
				if (self.maxAlphaTime == 0) then
					self.maxAlphaTime = self.elapsedTime
				end
				
				local alphaTimeDiff = self.elapsedTime - self.maxAlphaTime
				
				if (alphaTimeDiff >= 1) then
					local acceleration = 0.05
					local maxSpeed = 8
					local maxY = 200
					local _,_,_,_,y = self:GetPoint(1)
					
					if (y < maxY) then
						if (self.currentSpeed < maxSpeed) then
							self.currentSpeed = self.currentSpeed + acceleration
						end
						y = y + self.currentSpeed
						self:SetPoint("CENTER",0,y)
					else
						self.descReady = true
						self.currentSpeed = 0
					end
				end
			elseif (self.descReady and not self.dbReady) then
				if (self.desc:GetAlpha() < 1) then
					local appearSpeed = 0.03
					--local maxAppearSpeed = 
					local newAlpha = self.desc:GetAlpha() + appearSpeed
					self.desc:SetAlpha(newAlpha)
				else
					self.dbReady = true
				end
			elseif (self.dbReady) then
				if (Auras.db.char.isFirstEverLoad) then
					local acceleration = 0.05
					local maxSpeed = 8
					local maxX = 750
					local width = self.desc:GetWidth()
					
					if (width > maxX) then
						if (self.currentSpeed < maxSpeed) then
							self.currentSpeed = self.currentSpeed + acceleration
						end
						
						width = width - self.currentSpeed
						self.desc:SetWidth(width)
					else
						if (self.dbFrame:GetAlpha() < 1) then
							local appearSpeed = 0.03
							--local maxAppearSpeed = 
							local newAlpha = self.dbFrame:GetAlpha() + appearSpeed
							self.dbFrame:SetAlpha(newAlpha)
						else
							Auras.db.char.version = GetAddOnMetadata("ShamanAuras2","Version")
						end
					end
				else
					Auras.db.char.version = GetAddOnMetadata("ShamanAuras2","Version")
				end
			end
		end
	end
end)

IntroFrame.desc = CreateFrame("Frame",nil,IntroFrame)
IntroFrame.desc:SetSize(1024,128)
IntroFrame.desc:SetBackdrop(SSA.BackdropSB)
IntroFrame.desc:SetBackdropColor(0.1,0.1,0.1,0.9)
IntroFrame.desc:SetBackdropBorderColor(1,1,1,1)
IntroFrame.desc:SetFrameStrata("DIALOG")
IntroFrame.desc:SetPoint("TOPLEFT",IntroFrame,"BOTTOMLEFT",0,2)
IntroFrame.desc:SetAlpha(0)

IntroFrame.desc.text = IntroFrame.desc:CreateFontString(nil,"MEDIUM", "GameFontHighlightLarge")
IntroFrame.desc.text:SetFont([[Interface\addons\ShamanAuras\media\fonts\PT_Sans_Narrow.TTF]], 14,'OUTLINE')
IntroFrame.desc.text:SetPoint("TOPLEFT",10,-10)
IntroFrame.desc.text:SetSize(1024,128)
IntroFrame.desc.text:SetTextColor(1,1,1,1)
IntroFrame.desc.text:SetJustifyH("LEFT")
IntroFrame.desc.text:SetJustifyV("TOP")
IntroFrame.desc.text:SetText("FIXES\n\n    • Fixed the glow timing for |cFFFFe961Flame Shock|r")

IntroFrame.desc.button = CreateFrame("Button",nil,IntroFrame.desc,"UIPanelButtonTemplate")
IntroFrame.desc.button:SetSize(75,20)
IntroFrame.desc.button:SetPoint("BOTTOMRIGHT",-10,10)
IntroFrame.desc.button:SetText("Close")
IntroFrame.desc.button:SetAlpha(0)
IntroFrame.desc.button:SetScript("OnUpdate",function(self)
	if (not Auras.db.char.isFirstEverLoad and not self.isHideClicked) then
		self:SetAlpha(1)
	elseif (self.isHideClicked) then
		local appearSpeed = 0.02
		local newAlpha = IntroFrame:GetAlpha() - appearSpeed
		
		if (newAlpha < 0) then
			IntroFrame:Hide()
		else
			IntroFrame:SetAlpha(newAlpha)
		end
	end
end)
IntroFrame.desc.button:SetScript("OnClick",function(self)
	self.isHideClicked = true
end)
--/run SSA2_db.char["Sweetsours - Firetree"].version = "r1-alpha1"
IntroFrame.dbFrame = CreateFrame("Frame",nil,IntroFrame)
IntroFrame.dbFrame:SetSize(280,128)
IntroFrame.dbFrame:SetBackdrop(SSA.BackdropSB)
IntroFrame.dbFrame:SetBackdropColor(0.1,0.1,0.1,0.9)
IntroFrame.dbFrame:SetBackdropBorderColor(1,1,1,1)
IntroFrame.dbFrame:SetFrameStrata("DIALOG")
IntroFrame.dbFrame:SetPoint("TOPRIGHT",IntroFrame,"BOTTOMRIGHT",0,2)
IntroFrame.dbFrame:SetAlpha(0)

IntroFrame.dbFrame.text = IntroFrame.dbFrame:CreateFontString(nil,"MEDIUM", "GameFontHighlightLarge")
IntroFrame.dbFrame.text:SetFont([[Interface\addons\ShamanAuras\media\fonts\PT_Sans_Narrow.TTF]], 14,'OUTLINE')
IntroFrame.dbFrame.text:SetPoint("TOPLEFT",2,-8)
IntroFrame.dbFrame.text:SetSize(280,128)
IntroFrame.dbFrame.text:SetTextColor(1,1,1,1)
IntroFrame.dbFrame.text:SetJustifyV("TOP")
IntroFrame.dbFrame.text:SetText("This is the first time you're loading this addon.\n\nIn order to work correctly, the database needs to be populated with default values.\n\nClick the button below to proceed.")

IntroFrame.dbFrame.button = CreateFrame("Button",nil,IntroFrame.dbFrame,"UIPanelButtonTemplate")
IntroFrame.dbFrame.button:SetSize(128,20)
IntroFrame.dbFrame.button:SetPoint("BOTTOM",0,10)
IntroFrame.dbFrame.button:SetText("Proceed")
IntroFrame.dbFrame.button:SetScript("OnClick",function(self,button)
	Auras:CopyTableValues(Auras.db.char,SSA.defaults)
	Auras.db.char.isFirstEverLoad = false
	ReloadUI()
end)

IntroFrame.contacts = CreateFrame("Frame",nil,IntroFrame)
IntroFrame.contacts:SetSize(50,142)
IntroFrame.contacts:SetBackdrop(SSA.BackdropSB)
IntroFrame.contacts:SetBackdropColor(0.1,0.1,0.1,0.9)
IntroFrame.contacts:SetBackdropBorderColor(1,1,1,1)
IntroFrame.contacts:SetFrameStrata("HIGH")
IntroFrame.contacts:SetPoint("BOTTOMLEFT",IntroFrame,"BOTTOMRIGHT",-4,5)
IntroFrame.contacts:SetAlpha(0.5)
IntroFrame.contacts:SetScript("OnEnter",function(self,motion)
	if (self.isClosed and not self.isOpening) then
		self:SetAlpha(1)
	end
end)

IntroFrame.contacts:SetScript("OnLeave",function(self,motion)
	if (self.isClosed and not self.isOpening) then
		self:SetAlpha(0.5)
	end
end)

IntroFrame.contacts.discord = IntroFrame.contacts:CreateTexture(nil,'HIGH')
IntroFrame.contacts.discord:SetTexture([[Interface\AddOns\ShamanAuras2\Media\icons\config\discord_logo]])
IntroFrame.contacts.discord:SetSize(40,40)
IntroFrame.contacts.discord:SetPoint("TOPRIGHT",IntroFrame.contacts,"TOPRIGHT",-6,-6)

IntroFrame.contacts.discord.text = IntroFrame.contacts:CreateFontString(nil,"MEDIUM", "GameFontHighlightLarge")
IntroFrame.contacts.discord.text:SetFont([[Interface\addons\ShamanAuras\media\fonts\PT_Sans_Narrow.TTF]], 14,'OUTLINE')
IntroFrame.contacts.discord.text:SetPoint("TOPRIGHT",IntroFrame.contacts,"TOPRIGHT",-45,-20)
IntroFrame.contacts.discord.text:SetSize(175,128)
IntroFrame.contacts.discord.text:SetTextColor(1,1,1,1)
IntroFrame.contacts.discord.text:SetJustifyV("TOP")
IntroFrame.contacts.discord.text:SetJustifyH("LEFT")
IntroFrame.contacts.discord.text:SetText("https://|cFF7289dasweetsour.live|r/discord")
IntroFrame.contacts.discord.text:SetAlpha(0)

IntroFrame.contacts.discord.click = CreateFrame("Frame",nil,IntroFrame.contacts)
IntroFrame.contacts.discord.click:SetSize(175,20)
IntroFrame.contacts.discord.click:SetFrameStrata("HIGH")
IntroFrame.contacts.discord.click:SetPoint("TOPRIGHT",IntroFrame.contacts,"TOPRIGHT",-45,-17)
IntroFrame.contacts.discord.click:SetScript("OnMouseDown",function(self,button)
	if (button == "LeftButton" and IntroFrame.contacts.isTextShowing) then
		local editbox = ChatFrame1EditBox
		
		if (not editbox:IsShown()) then
			editbox:Show()
		end
		
		if (editbox:GetAlpha() < 1) then
			editbox:SetAlpha(1)
		end
		
		editbox:SetFocus()
		editbox:SetText(IntroFrame.contacts.discord.text:GetText())
		editbox:HighlightText()
	end
end)

IntroFrame.contacts.patreon = IntroFrame.contacts:CreateTexture(nil,'HIGH')
IntroFrame.contacts.patreon:SetTexture([[Interface\AddOns\ShamanAuras2\Media\icons\config\patreon_logo]])
IntroFrame.contacts.patreon:SetSize(40,40)
IntroFrame.contacts.patreon:SetPoint("TOPRIGHT",IntroFrame.contacts,"TOPRIGHT",-6,-51)

IntroFrame.contacts.patreon.text = IntroFrame.contacts:CreateFontString(nil,"MEDIUM", "GameFontHighlightLarge")
IntroFrame.contacts.patreon.text:SetFont([[Interface\addons\ShamanAuras\media\fonts\PT_Sans_Narrow.TTF]], 14,'OUTLINE')
IntroFrame.contacts.patreon.text:SetPoint("TOPRIGHT",IntroFrame.contacts,"TOPRIGHT",-45,-65)
IntroFrame.contacts.patreon.text:SetSize(175,128)
IntroFrame.contacts.patreon.text:SetTextColor(1,1,1,1)
IntroFrame.contacts.patreon.text:SetJustifyV("TOP")
IntroFrame.contacts.patreon.text:SetJustifyH("LEFT")
IntroFrame.contacts.patreon.text:SetText("https://|cFFF96854sweetsour.live|r/patreon")
IntroFrame.contacts.patreon.text:SetAlpha(0)

IntroFrame.contacts.patreon.click = CreateFrame("Frame",nil,IntroFrame.contacts)
IntroFrame.contacts.patreon.click:SetSize(175,20)
IntroFrame.contacts.patreon.click:SetFrameStrata("HIGH")
IntroFrame.contacts.patreon.click:SetPoint("TOPRIGHT",IntroFrame.contacts,"TOPRIGHT",-45,-65)
IntroFrame.contacts.patreon.click:SetScript("OnMouseDown",function(self,button)
	if (button == "LeftButton" and IntroFrame.contacts.isTextShowing) then
		local editbox = ChatFrame1EditBox
		
		if (not editbox:IsShown()) then
			editbox:Show()
		end
		
		if (editbox:GetAlpha() < 1) then
			editbox:SetAlpha(1)
		end
		
		editbox:SetFocus()
		editbox:SetText(IntroFrame.contacts.patreon.text:GetText())
		editbox:HighlightText()
	end
end)

IntroFrame.contacts.paypal = IntroFrame.contacts:CreateTexture(nil,'HIGH')
IntroFrame.contacts.paypal:SetTexture([[Interface\AddOns\ShamanAuras2\Media\icons\config\paypal_logo]])
IntroFrame.contacts.paypal:SetSize(40,40)
IntroFrame.contacts.paypal:SetPoint("TOPRIGHT",IntroFrame.contacts,"TOPRIGHT",-6,-96)

IntroFrame.contacts.paypal.text = IntroFrame.contacts:CreateFontString(nil,"MEDIUM", "GameFontHighlightLarge")
IntroFrame.contacts.paypal.text:SetFont([[Interface\addons\ShamanAuras\media\fonts\PT_Sans_Narrow.TTF]], 14,'OUTLINE')
IntroFrame.contacts.paypal.text:SetPoint("TOPRIGHT",IntroFrame.contacts,"TOPRIGHT",-45,-110)
IntroFrame.contacts.paypal.text:SetSize(175,128)
IntroFrame.contacts.paypal.text:SetTextColor(1,1,1,1)
IntroFrame.contacts.paypal.text:SetJustifyV("TOP")
IntroFrame.contacts.paypal.text:SetJustifyH("LEFT")
IntroFrame.contacts.paypal.text:SetText("https://|cFF169BD7sweetsour.live|r/donate")
IntroFrame.contacts.paypal.text:SetAlpha(0)

IntroFrame.contacts.paypal.click = CreateFrame("Frame",nil,IntroFrame.contacts)
IntroFrame.contacts.paypal.click:SetSize(175,20)
IntroFrame.contacts.paypal.click:SetFrameStrata("HIGH")
IntroFrame.contacts.paypal.click:SetPoint("TOPRIGHT",IntroFrame.contacts,"TOPRIGHT",-45,-106)
IntroFrame.contacts.paypal.click:SetScript("OnMouseDown",function(self,button)
	if (button == "LeftButton" and IntroFrame.contacts.isTextShowing) then
		local editbox = ChatFrame1EditBox
		
		if (not editbox:IsShown()) then
			editbox:Show()
		end
		
		if (editbox:GetAlpha() < 1) then
			editbox:SetAlpha(1)
		end
		
		editbox:SetFocus()
		editbox:SetText(IntroFrame.contacts.paypal.text:GetText())
		editbox:HighlightText()
	end
end)

IntroFrame.contacts.isOpening = false
IntroFrame.contacts.isOpened = false
IntroFrame.contacts.isClosing = false
IntroFrame.contacts.isClosed = true
IntroFrame.contacts.isTextShowing = false
IntroFrame.contacts.currentSpeed = 0
IntroFrame.contacts:SetScript("OnUpdate",function(self)
	if (self.isOpening) then
		local acceleration = 0.1
		local maxSpeed = 10
		local maxWidth = 225
		local minWidth = 53
		
		if (self.currentSpeed < maxSpeed) then
			self.currentSpeed = self.currentSpeed + acceleration
		end
		
		if (self:GetWidth() < maxWidth) then
			self:SetWidth(self:GetWidth() + self.currentSpeed)
		else
			self.isOpening = false
			self.isOpened = true
			self.isClosed = false
		end
	end
	
	if (self.isClosing and not self.isTextShowing) then
		local acceleration = 0.1
		local maxSpeed = 10
		local maxWidth = 225
		local minWidth = 53
		
		if (self.currentSpeed < maxSpeed) then
			self.currentSpeed = self.currentSpeed + acceleration
		end
		
		if (self:GetWidth() > minWidth) then
			self:SetWidth(self:GetWidth() - self.currentSpeed)
		else
			self.isClosing = false
			self.isClosed = true
			self.isOpened = false
			self:SetAlpha(0.5)
		end
	end
	
	if (self.isOpened and not self.isTextShowing and not self.isClosing) then
		if (self.discord.text:GetAlpha() < 1) then
			local appearSpeed = 0.02
			local newAlpha = self.discord.text:GetAlpha() + appearSpeed
			
			if (newAlpha > 1) then
				newAlpha = 1
				self.isTextShowing = true
			end
			
			self.discord.text:SetAlpha(newAlpha)
			self.patreon.text:SetAlpha(newAlpha)
			self.paypal.text:SetAlpha(newAlpha)
		end
	end
	
	if (self.isClosing and self.isTextShowing) then
		if (self.discord.text:GetAlpha() > 0) then
			local appearSpeed = 0.02 
			local newAlpha = self.discord.text:GetAlpha() - appearSpeed
			
			if (newAlpha < 0) then
				newAlpha = 0
				self.isTextShowing = false
			end
			
			self.discord.text:SetAlpha(newAlpha)
			self.patreon.text:SetAlpha(newAlpha)
			self.paypal.text:SetAlpha(newAlpha)
		end
	end
	
	--SSA.DataFrame.text:SetText("Is Opened: "..tostring(self.isOpened).."\nIs Opening: "..tostring(self.isOpening).."\n\nIs Closed: "..tostring(self.isClosed).."\nIs Closing: "..tostring(self.isClosing).."\n\nIs Text Showing: "..tostring(self.isTextShowing))
end)

IntroFrame.contacts:SetScript("OnMouseDown",function(self,button)
	if (button == "LeftButton" and not self.isOpening and not self.isClosing) then
		self.currentSpeed = 0
		if (self.isClosed) then
			self.isOpening = true
		end
		
		if (self.isOpened and self.isTextShowing) then
			self.isClosing = true
		end
	end
end)
--/run SSA_IntroFrame:SetAlpha(1)
_G["SSA_IntroFrame"] = IntroFrame