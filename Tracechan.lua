--!strict

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

--================ STATE COLOR ================--

local SColor = {}
SColor.__index = SColor

export type SColor = {
	Enabled: Color3,
	Disabled: Color3,
	new: (enabled: Color3, disabled: Color3) -> SColor,
}

function SColor.new(enabled: Color3, disabled: Color3): SColor
	local self = setmetatable(({}::any), SColor) :: any
	self.Enabled = enabled
	self.Disabled = disabled
	return self :: SColor
end

--================ TYPES ================--

export type TextInstance = TextLabel | TextBox

export type TextMethods = {
	Destroy: (self: Text) -> (),
	__index: TextMethods,
}

export type TextArgs = {
	Text: string?,
	TextColor: Color3?,
	FontSize: number?,
	Alignment: Enum.TextXAlignment?,
	TextFont: Font?,
	Selectable: boolean?,
}
export type Text = TextMethods & {
	Text: string,
	TextColor: Color3,
	FontSize: number,
	Alignment: Enum.TextXAlignment,
	TextFont: Font,
	Selectable: boolean,
	Instance: TextInstance
}

-------------------------------------------------------------------------------------------------

export type ButtonInstance = TextButton

export type ButtonMethods = {
	Destroy: (self: Button) -> (),
	__set_state: (self: Button, state: boolean) -> (),
	__index: ButtonMethods,
}

export type ButtonArgs = {
	Text: string?,
	OnClick: (() -> ())?,
	Enabled: boolean?,
	BackgroundColor: SColor?,
	TextColor: SColor?,
	BorderColor: SColor?,
	FontSize: number?,
	TextFont: Font?
}
export type Button = ButtonMethods & {
	Text: string,
	OnClick: (() -> ())?,
	Enabled: boolean,
	BackgroundColor: SColor,
	TextColor: SColor,
	BorderColor: SColor,
	FontSize: number,
	TextFont: Font,
	Instance: ButtonInstance
}

-------------------------------------------------------------------------------------------------

export type SwitchInstance = TextButton

export type SwitchMethods = {
	Destroy: (self: Switch) -> (),
	Enable: (self: Switch, silence: boolean?) -> (),
	Disable: (self: Switch, silence: boolean?) -> (),
	Switch: (self: Switch) -> ()
}

export type SwitchArgs = {
	Text: string?,
	Value: boolean?,
	OnChange: ((value: boolean) -> ())?,
	Enabled: boolean?,

	ActiveTrackColor: SColor?,
	ActiveThumbColor: SColor?,
	ActiveBorderColor: SColor?,

	InactiveTrackColor: SColor?,
	InactiveThumbColor: SColor?,
	InactiveBorderColor: SColor?,

	TextColor: Color3?,
	TextFont: Font?,
	FontSize: number?
}
export type Switch = SwitchMethods & {
	Text: string,
	Value: boolean,
	OnChange: ((value: boolean) -> ())?,
	Enabled: boolean,

	ActiveTrackColor: SColor,
	ActiveThumbColor: SColor,
	ActiveBorderColor: SColor,

	InactiveTrackColor: SColor,
	InactiveThumbColor: SColor,
	InactiveBorderColor: SColor,

	TextColor: Color3,
	TextFont: Font,
	FontSize: number,
	Instance: TextButton
}

-------------------------------------------------------------------------------------------------

export type TextFieldInstance = TextBox

export type TextFieldMethods = {
	Destroy: (self: TextField) -> (),
	__set_state: (self: TextField, state: boolean) -> ()
}

export type TextFieldArgs  = {
	Text: string?,
	OnSubmit: ((text: string) -> ())?,
	Placeholder: string,
	OnSubmitRequireEnter: boolean?,
	ClearTextOnFocus: boolean?,
	Enabled: boolean?,
	BackgroundColor: SColor?,
	TextColor: SColor?,
	BorderColor: SColor?,
	PlaceholderColor: SColor?,
	MultiLine: boolean?,
	TextFont: Font?,
	FontSize: number?,
}

export type TextField = TextFieldMethods & {
	Text: string,
	OnSubmit: ((text: string) -> ())?,
	Placeholder: string,
	OnSubmitRequireEnter: boolean,
	ClearTextOnFocus: boolean,
	Enabled: boolean,
	BackgroundColor: SColor,
	TextColor: SColor,
	BorderColor: SColor,
	PlaceholderColor: SColor,
	MultiLine: boolean,
	TextFont: Font,
	FontSize: number,
	Instance: TextFieldInstance,
}

-------------------------------------------------------------------------------------------------

export type RowButton = {
	Add: (self: RowButton, button: Button) -> (),
	Instance: Frame,
}

-------------------------------------------------------------------------------------------------

export type TabArgs = {
	Name: string
}

export type TabsMethods = {
	Select: (self: Tab) -> (),
	Divider: (self: Tab) -> Frame,
	Text: (
		self: Tab,
		Args: TextArgs
	) -> Text,
	Button: (
		self: Tab,
		Args: ButtonArgs
	) -> Button,
	RowButton: (self: Tab) -> RowButton,
	TextField: (
		self: Tab,
		Args: TextFieldArgs
	) -> TextField,
	Switch: (
		self: Tab,
		Args: SwitchArgs
	) -> Switch,
}

export type Tab = TabsMethods & {
	Name: string,
	ScrollingFrame: ScrollingFrame,
	Instance: TextButton
}

export type WindowMethods = {
	Destroy: (self: Window) -> (),
	Notification: (self: Window, title: string?, content: string, enum_: string?, duration: number?) -> (),
	Tab: (self: Window, Args: TabArgs) -> Tab
}

export type WindowArgs = {
	Title: string?,
	ScreenGui: ScreenGui,
	Visible: boolean?,
	BackgroundImage: string?,
	BackgroundImageTransparency: number?,
	BackgroundImageScaleType: Enum.ScaleType?

}
export type Window = WindowMethods & {
	Title: string,
	ScreenGui: ScreenGui,
	BackgroundImage: string,
	BackgroundImageTransparency: number,
	BackgroundImageScaleType: Enum.ScaleType,
	Visible: boolean,
	StateButton: TextButton,
	NotificationHandler: Frame,
	TitleLabel: TextLabel,
	CanvasGroup: CanvasGroup,
	DragHeader: Frame,
	TabButtons: ScrollingFrame,
	TabsHandler: Frame,
	TabsHandlerUIPageLayout: UIPageLayout,
	Tabs: {Tab?},
	Instance: Frame?
}

local BASIC_TWEEN_INFO = TweenInfo.new(0.5, Enum.EasingStyle.Cubic)

--================ DEBUGGER ================--

local Debugger = {
	UI = {},
	Functions = {},
	Enums = {
		Notification = {
			Success = "Success",
			Error = "Error",
			Warning = "Warning",
			Info = "Info"
		}
	},
	-- Theme = {
	-- 	buttonColor = Color3.fromRGB(199, 137, 196),
	-- 	switchBgEnabled = Color3.fromRGB(148, 219, 134),
	-- 	switchBgCircleEnabled = Color3.fromRGB(28, 62, 24),
	-- },
	Logger = {}
}

--================ FUNCTIONS ================--

function Debugger.Functions.Color(color3: Color3, text: string): string
	return `<font color = \"#{color3:ToHex()}\">{text}</font>`
end

function Debugger.Functions.RandomString(length: number?): string
	local finalLength: number = length or 15
	local rnd: string = ""

	for _ = 1, finalLength do
		local char = if math.random(1, 2) == 1 
			then math.random(65, 90) 
			else math.random(97, 122)
		rnd ..= string.char(char)
	end

	return rnd
end

--================ LOGGER ================--

function Debugger.Logger.Log(text: string)
	local traceback = string.gsub(debug.traceback("", 2), "\n", "")
	print(`[{traceback}] :: {text}`)
end

function Debugger.Logger.Warn(text: string)
	local traceback = string.gsub(debug.traceback("", 2), "\n", "")
	warn(`[{traceback}] :: {text}`)
end

--================ OTHER FUNCTIONS ================--

-- Infinite yield: function dragGui()
local CurrentlyDragging: GuiObject? = nil
local function DragGUI(gui: GuiObject)
	local dragging = false
	local dragInput
	local dragStart: Vector3
	local startPos: UDim2

	local function update(input: InputObject)
		local delta = input.Position - dragStart
		local newPos = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
		TweenService:Create(gui, TweenInfo.new(0.05), { Position = newPos }):Play()
	end

	gui.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 
			or input.UserInputType == Enum.UserInputType.Touch)
			and CurrentlyDragging == nil
		then
			dragging = true
			CurrentlyDragging = gui

			dragStart = input.Position
			startPos = gui.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
					CurrentlyDragging = nil
				end
			end)
		end
	end)

	gui.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input: InputObject)
		if dragging and CurrentlyDragging == gui and input == dragInput then
			update(input)
		end
	end)
end

local function GetRaw<T>(slf: T): T
	local slfAny = slf :: any
	local raw = if slfAny.Instance then slfAny else slfAny._gettable
	if not raw or not raw.Instance then
		error("GetRaw failed to find data for " .. tostring(slf))
	end
	return raw :: T
end

local function ValueOr<T>(value: T?, default: T): T
	if value ~= nil then
		return value
	end
	return default
end

local function ToDict(t: {any}): {[any]: boolean}
	local result = {}
	for _, v in pairs(t) do
		result[v] = true
	end
	return result
end

local function CreateProxy(
	raw: any,
	methods: { [string]: any },
	onWrite: (raw: any, key: string, value: any) -> ()
): any
	local mt = {
		_gettable = raw,
		__index = function(_: any, key: string)
			if key == "_gettable" then return raw end
			local value = raw[key]
			if value ~= nil then return value end
			return methods[key]
		end,
		__newindex = function(_: any, key: string, value: any)
			if key == "Instance" then
				error("Property 'Instance' is read-only")
			end
			local old = raw[key]
			raw[key] = value
			if old ~= value then
				onWrite(raw, key, value)
			end
		end,
	}
	return setmetatable({}, mt)
end

--================ TODICT CONSTANTS ================--

local WINDOW_READ_ONLY_KEYS = ToDict({"Instance", "StateButton", "NotificationHandler", "TitleLabel", "CanvasGroup", "DragHeader", "TabButtons", "TabsHandler", "TabsHandlerUIPageLayout"})

--================ METHODS TABLES ================--

local TextMethods = {} :: TextMethods
TextMethods.__index = TextMethods

function TextMethods:Destroy()
	local raw = (self :: any)._gettable :: Text
	if not raw then return end

	if raw.Instance then
		raw.Instance:Destroy()
	end

	for k: any, v: any in pairs((raw::any)) do
		raw[k] = nil
	end

	setmetatable(self, nil)
end

-------------------

local ButtonMethods = {} :: ButtonMethods
ButtonMethods.__index = ButtonMethods

function ButtonMethods:Destroy()
	local raw = GetRaw(self) :: Button
	if not raw then return end

	if raw.Instance then
		raw.Instance:Destroy()
	end

	for k: any, v: any in pairs((raw::any)) do
		raw[k] = nil
	end

	setmetatable(self, nil)
end

function ButtonMethods:__set_state(state: boolean)
	local raw: Button = GetRaw(self) :: Button
	if not raw.Instance then
		return
	end
	raw.Instance.Active = state
	raw.Instance.Interactable = state
	local stroke = raw.Instance:FindFirstChild("UIStroke") :: UIStroke
	if stroke then
		TweenService:Create(stroke, BASIC_TWEEN_INFO, {
			Color = if state then raw.BorderColor.Enabled else raw.BorderColor.Disabled
		}):Play()
	end
	TweenService:Create(raw.Instance, BASIC_TWEEN_INFO, {
		BackgroundColor3 = if state then raw.BackgroundColor.Enabled else raw.BackgroundColor.Disabled,
		TextColor3 = if state then raw.TextColor.Enabled else raw.TextColor.Disabled
	}):Play()
end

-------------------

local SwitchTweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Cubic)

local SwitchMethods = {} :: SwitchMethods

function SwitchMethods:Destroy()
	local raw = GetRaw(self) :: Switch
	if not raw then return end

	if raw.Instance then
		raw.Instance:Destroy()
	end

	for k: any, v: any in pairs((raw::any)) do
		raw[k] = nil
	end

	setmetatable(self, nil)
end

function SwitchMethods:Enable(silence: boolean?)
	local raw: Switch = GetRaw(self) :: Switch
	if not raw or not raw.Instance then
		return
	end

	raw.Value = true
	if raw.OnChange and not silence then
		task.spawn(raw.OnChange, raw.Value)
	end

	local inst = raw.Instance
	local track = inst:FindFirstChild("Track") :: Frame
	local thumb = if track then track:FindFirstChild("Thumb") :: Frame else nil
	local stroke = if track then track:FindFirstChild("UIStroke") :: UIStroke else nil

	if stroke then
		TweenService:Create(stroke, SwitchTweenInfo, { Color = if raw.Enabled then raw.ActiveBorderColor.Enabled else raw.ActiveBorderColor.Disabled }):Play()
	end
	if track then
		TweenService:Create(track, SwitchTweenInfo, { BackgroundColor3 = if raw.Enabled then raw.ActiveTrackColor.Enabled else raw.ActiveTrackColor.Disabled }):Play()
	end
	if thumb then
		TweenService:Create(thumb, SwitchTweenInfo, {
			BackgroundColor3 = if raw.Enabled then raw.ActiveThumbColor.Enabled else raw.ActiveThumbColor.Disabled,
			Position = UDim2.new(1, -3, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5),
		}):Play()
	end
end

function SwitchMethods:Disable(silence: boolean?)
	local raw: Switch = GetRaw(self) :: Switch
	if not raw or not raw.Instance then
		return
	end

	raw.Value = false
	if raw.OnChange and not silence then
		task.spawn(raw.OnChange, raw.Value)
	end

	local inst = raw.Instance
	local track = inst:FindFirstChild("Track") :: Frame
	local thumb = if track then track:FindFirstChild("Thumb") :: Frame else nil
	local stroke = if track then track:FindFirstChild("UIStroke") :: UIStroke else nil

	if stroke then
		TweenService:Create(stroke, SwitchTweenInfo, { Color = if raw.Enabled then raw.InactiveBorderColor.Enabled else raw.InactiveBorderColor.Disabled }):Play()
	end
	if track then
		TweenService:Create(track, SwitchTweenInfo, { BackgroundColor3 = if raw.Enabled then raw.InactiveTrackColor.Enabled else raw.InactiveTrackColor.Disabled }):Play()
	end
	if thumb then
		TweenService:Create(thumb, SwitchTweenInfo, {
			BackgroundColor3 = if raw.Enabled then raw.InactiveThumbColor.Enabled else raw.InactiveThumbColor.Disabled,
			Position = UDim2.new(0, 3, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
		}):Play()
	end
end

function SwitchMethods:Switch()
	local raw = (self :: any)._gettable :: Switch
	if not raw then return end
	if raw.Value == false then
		self:Enable(false)
	else
		self:Disable(false)
	end
end

-------------------

local TextFieldTweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local TextFieldMethods = {} :: TextFieldMethods

function TextFieldMethods:Destroy()
	local raw = GetRaw(self) :: TextField
	if not raw then return end

	if raw.Instance then
		raw.Instance:Destroy()
	end

	for k: any, v: any in pairs((raw::any)) do
		raw[k] = nil
	end

	setmetatable(self, nil)
end

function TextFieldMethods:__set_state(state: boolean)
	local raw: TextField = GetRaw(self) :: TextField
	if not raw.Instance then
		return
	end

	raw.Instance.Interactable = state
	TweenService:Create(raw.Instance, TextFieldTweenInfo, {
		BackgroundColor3 = if raw.Enabled then raw.BackgroundColor.Enabled else raw.BackgroundColor.Disabled,
		TextColor3 = if raw.Enabled then raw.TextColor.Enabled else raw.TextColor.Disabled,
		PlaceholderColor3 = if raw.Enabled then raw.PlaceholderColor.Enabled else raw.PlaceholderColor.Disabled
	}):Play()
	local stroke = raw.Instance:FindFirstChild("UIStroke") :: UIStroke
	if stroke then
		TweenService:Create(stroke, TextFieldTweenInfo, {
			Color = if raw.Enabled then raw.BorderColor.Enabled else raw.BorderColor.Disabled
		}):Play()
	end
end

-------------------

local WindowMethods = {} :: WindowMethods

function WindowMethods:Destroy()
	local raw = GetRaw(self) :: Window
	if not raw then return end

	if raw.Instance then
		raw.Instance:Destroy()
	end
	if raw.StateButton then
		raw.StateButton:Destroy()
	end
	if raw.NotificationHandler then
		raw.NotificationHandler:Destroy()
	end

	for k: any, v: any in pairs((raw::any)) do
		raw[k] = nil
	end

	setmetatable(self, nil)
end

function WindowMethods:Notification(title: string?, content: string, enum_: string?, duration: number?)
	local raw = GetRaw(self) :: Window
	if not raw or not raw.NotificationHandler then
		return
	end

	duration = ValueOr(duration, 4)
	enum_ = ValueOr(enum_, "Info")
	title = ValueOr(title, "Notification")

	local NotificationFrame = Instance.new("Frame")
	NotificationFrame.Name = "Notification"
	NotificationFrame.ClipsDescendants = true
	NotificationFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	NotificationFrame.AutomaticSize = Enum.AutomaticSize.Y
	NotificationFrame.Size = UDim2.new(1, 0, 0, 30)
	NotificationFrame.BorderColor3 = Color3.new(0, 0, 0)
	NotificationFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	NotificationFrame.BorderSizePixel = 0
	NotificationFrame.BackgroundTransparency = 0.5
	NotificationFrame.BackgroundColor3 = Color3.new(0, 0, 0)
	NotificationFrame.Parent = raw.NotificationHandler

	local ContentLabel = Instance.new("TextLabel")
	ContentLabel.Name = "Content"
	ContentLabel.TextWrapped = true
	ContentLabel.BorderSizePixel = 0
	ContentLabel.RichText = true
	ContentLabel.BackgroundColor3 = Color3.new(1, 1, 1)
	ContentLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
	ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
	ContentLabel.TextSize = 18
	ContentLabel.Size = UDim2.new(1, 0, 0, 18)
	ContentLabel.BorderColor3 = Color3.new(0, 0, 0)
	ContentLabel.Text = content
	ContentLabel.TextColor3 = Color3.new(1, 1, 1)
	ContentLabel.AutomaticSize = Enum.AutomaticSize.Y
	ContentLabel.BackgroundTransparency = 1
	ContentLabel.Position = UDim2.new(0, 0, 0, 18)
	ContentLabel.Parent = NotificationFrame

	local UIGradient = Instance.new("UIGradient")
	UIGradient.Name = "UIGradient"
	UIGradient.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0, 0),
		NumberSequenceKeypoint.new(1, 1, 0),
	})
	UIGradient.Offset = Vector2.new(1.4, 0)
	UIGradient.Parent = ContentLabel
	UIGradient.Rotation = 180

	local UIPadding = Instance.new("UIPadding")
	UIPadding.Name = "UIPadding"
	UIPadding.PaddingBottom = UDim.new(0, 10)
	UIPadding.PaddingTop = UDim.new(0, 10)
	UIPadding.PaddingLeft = UDim.new(0, 12)
	UIPadding.PaddingRight = UDim.new(0, 12)
	UIPadding.Parent = NotificationFrame

	local UICorner = Instance.new("UICorner")
	UICorner.Name = "UICorner"
	UICorner.CornerRadius = UDim.new(0, 14)
	UICorner.Parent = NotificationFrame

	local Label = Instance.new("TextLabel")
	Label.Name = "Label"
	Label.TextWrapped = true
	Label.BorderSizePixel = 0
	Label.RichText = true
	Label.BackgroundColor3 = Color3.new(1, 1, 1)
	Label.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.TextSize = 14
	Label.Size = UDim2.new(1, -18, 0, 14)
	Label.BorderColor3 = Color3.new(0, 0, 0)
	Label.Text = (title::string)
	Label.TextColor3 = Color3.new(0.76, 0.76, 0.76)
	Label.AutomaticSize = Enum.AutomaticSize.Y
	Label.BackgroundTransparency = 1
	Label.Position = UDim2.new(0, 18, 0, 0)
	Label.Parent = NotificationFrame

	local UIGradient1 = Instance.new("UIGradient")
	UIGradient1.Name = "UIGradient"
	UIGradient1.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0, 0),
		NumberSequenceKeypoint.new(1, 1, 0),
	})
	UIGradient1.Offset = Vector2.new(1, 0)
	UIGradient1.Parent = Label
	UIGradient1.Rotation = 180

	local ImageLabel = Instance.new("ImageLabel")
	ImageLabel.Name = "ImageLabel"
	ImageLabel.BorderSizePixel = 0
	ImageLabel.BackgroundColor3 = Color3.new(1, 1, 1)
	ImageLabel.Image = "rbxassetid://11295275950"
	ImageLabel.Size = UDim2.new(0, 14, 0, 14)
	ImageLabel.BorderColor3 = Color3.new(0, 0, 0)
	ImageLabel.BackgroundTransparency = 1
	ImageLabel.Parent = NotificationFrame

	local UIGradient2 = Instance.new("UIGradient")
	UIGradient2.Name = "UIGradient 2"
	UIGradient2.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0, 0),
		NumberSequenceKeypoint.new(1, 1, 0),
	})
	UIGradient2.Offset = Vector2.new(1, 0)
	UIGradient2.Parent = ImageLabel
	UIGradient2.Rotation = 180

	local UIGradient3 = Instance.new("UIGradient")
	UIGradient3.Name = "UIGradient 3"
	UIGradient3.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0, 0),
		NumberSequenceKeypoint.new(1, 1, 0),
	})
	UIGradient3.Offset = Vector2.new(1, 0)
	UIGradient3.Parent = NotificationFrame
	UIGradient3.Rotation = 180

	local UIShadow = Instance.new("UIShadow")
	UIShadow.Name = "UIShadow"
	UIShadow.BlurRadius = UDim.new(0, 20)
	UIShadow.Offset = UDim2.new(0, 0, 0, 0)
	UIShadow.Spread = UDim2.new(0, 0, 0, 0)
	UIShadow.Transparency = 1
	UIShadow.Parent = NotificationFrame

	local UIStroke = Instance.new("UIStroke")
	UIStroke.Name = "UIStroke"
	UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	UIStroke.Parent = NotificationFrame

	local UIGradient4 = Instance.new("UIGradient")
	UIGradient4.Name = "UIGradient 4"
	UIGradient4.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0, 0),
		NumberSequenceKeypoint.new(1, 1, 0),
	})
	UIGradient4.Offset = Vector2.new(1, 0)
	UIGradient4.Parent = UIStroke
	UIGradient4.Rotation = 180

	if enum_ == Debugger.Enums.Notification.Success then
		ImageLabel.Image = "rbxassetid://14950022472"
		NotificationFrame.BackgroundColor3 = Color3.fromRGB(43, 56, 39)
		UIStroke.Color = Color3.fromRGB(110, 159, 101)
		UIShadow.Color = Color3.fromRGB(43, 56, 39)
	elseif enum_ == Debugger.Enums.Notification.Error then
		ImageLabel.Image = "rbxassetid://14950120485"
		NotificationFrame.BackgroundColor3 = Color3.fromRGB(61, 36, 36)
		UIStroke.Color = Color3.fromRGB(173, 91, 91)
		UIShadow.Color = Color3.fromRGB(61, 36, 36)
	elseif enum_ == Debugger.Enums.Notification.Warning then
		ImageLabel.Image = "rbxassetid://14966839373"
		NotificationFrame.BackgroundColor3 = Color3.fromRGB(61, 53, 36)
		UIStroke.Color = Color3.fromRGB(173, 147, 91)
		UIShadow.Color = Color3.fromRGB(61, 53, 36)
	else
		ImageLabel.Image = "rbxassetid://11295275950"
	end

	duration = math.clamp(duration :: number, 3, math.huge) + 0.9

	TweenService:Create(UIGradient, TweenInfo.new(0.9, Enum.EasingStyle.Cubic), {Offset = Vector2.new(-1,0)}):Play()
	TweenService:Create(UIGradient1, TweenInfo.new(0.9, Enum.EasingStyle.Cubic), {Offset = Vector2.new(-1,0)}):Play()
	TweenService:Create(UIGradient2, TweenInfo.new(0.9, Enum.EasingStyle.Cubic), {Offset = Vector2.new(-1,0)}):Play()
	TweenService:Create(UIGradient3, TweenInfo.new(0.9, Enum.EasingStyle.Cubic), {Offset = Vector2.new(-1,0)}):Play()
	TweenService:Create(UIShadow, TweenInfo.new(0.9, Enum.EasingStyle.Cubic), {Transparency = 0.5}):Play()
	TweenService:Create(UIGradient4, TweenInfo.new(0.9, Enum.EasingStyle.Cubic), {Offset = Vector2.new(-1,0)}):Play()

	task.delay(duration, function()
		TweenService:Create(UIGradient, TweenInfo.new(0.6, Enum.EasingStyle.Cubic), {Offset = Vector2.new(1,0)}):Play()
		TweenService:Create(UIGradient1, TweenInfo.new(0.6, Enum.EasingStyle.Cubic), {Offset = Vector2.new(1,0)}):Play()
		TweenService:Create(UIGradient2, TweenInfo.new(0.6, Enum.EasingStyle.Cubic), {Offset = Vector2.new(1,0)}):Play()
		TweenService:Create(UIGradient3, TweenInfo.new(0.6, Enum.EasingStyle.Cubic), {Offset = Vector2.new(1,0)}):Play()
		TweenService:Create(UIShadow, TweenInfo.new(0.6, Enum.EasingStyle.Cubic), {Transparency = 1}):Play()
		TweenService:Create(UIGradient4, TweenInfo.new(0.6, Enum.EasingStyle.Cubic), {Offset = Vector2.new(1,0)}):Play()
		task.wait(0.2)
		local a = TweenService:Create(NotificationFrame, TweenInfo.new(0.2, Enum.EasingStyle.Cubic), {Size = UDim2.new(1, 0, 0, 0)})
		a:Play()
		a.Completed:Wait()
		NotificationFrame:Destroy()
	end)
end

local TabsMethods = {} :: TabsMethods

function TabsMethods:Select()
	local raw = GetRaw(self) :: Tab
	if not raw or not raw.Instance or not raw.ScrollingFrame then
		return
	end

	local tabsHandler = raw.ScrollingFrame.Parent
	if tabsHandler then
		local pageLayout = tabsHandler:FindFirstChildOfClass("UIPageLayout")
		if pageLayout then
			pageLayout:JumpTo(raw.ScrollingFrame)
		end
	end

	local holder = raw.Instance.Parent
	if holder then
		for _, otherButton in holder:GetChildren() do
			if not otherButton:IsA("TextButton") then continue end
			local otherStroke = otherButton:FindFirstChild("UIStroke")
			if otherStroke and otherStroke:IsA("UIStroke") then
				otherStroke.Color = Color3.fromRGB(102, 102, 102)
			end
		end
	end

	local ownStroke = raw.Instance:FindFirstChild("UIStroke")
	if ownStroke and ownStroke:IsA("UIStroke") then
		ownStroke.Color = Color3.new(1, 1, 1)
	end
end

function TabsMethods:Divider(): Frame
	local raw = GetRaw(self) :: Tab
	if not raw or not raw.ScrollingFrame then
		error("Window is not properly initialized")
	end

	local Frame = Instance.new("Frame")
	Frame.Name = "Divider"
	Frame.Size = UDim2.new(1, 0, 0, 1)
	Frame.BorderColor3 = Color3.new(0, 0, 0)
	Frame.BorderSizePixel = 0
	Frame.BackgroundTransparency = 0.5
	Frame.BackgroundColor3 = Color3.new(0.65, 0.65, 0.65)
	Frame.Parent = raw.ScrollingFrame
	return Frame
end

function TabsMethods:Text(Args): Text
	local raw = GetRaw(self) :: Tab
	if not raw or not raw.ScrollingFrame then
		error("Tab is not properly initialized")
	end

	local TextInstance: TextInstance? = nil

	local TextData = {
		Text = ValueOr(Args.Text, "Text"),
		TextColor = ValueOr(Args.TextColor, Color3.fromRGB(241, 241, 241)),
		FontSize = ValueOr(Args.FontSize, 18),
		Alignment = ValueOr(Args.Alignment, Enum.TextXAlignment.Left),
		TextFont = ValueOr(Args.TextFont, Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)),
		Selectable = ValueOr(Args.Selectable, false),
		Instance = TextInstance,
	} :: Text

	if not TextData.Selectable then
		TextInstance = Instance.new("TextLabel")
		if not TextInstance then error("Something went wrong") end
		if not TextInstance:IsA("TextLabel") then error("Somethin went wrong") end

		TextInstance.Name = "TextInstance"
		TextInstance.BorderSizePixel = 0
		TextInstance.RichText = true
		TextInstance.BackgroundColor3 = Color3.new(1, 1, 1)
		TextInstance.FontFace = TextData.TextFont
		TextInstance.TextXAlignment = TextData.Alignment
		TextInstance.TextSize = TextData.FontSize
		TextInstance.Size = UDim2.new(1, 0, 0, 24)
		TextInstance.BorderColor3 = Color3.new(0, 0, 0)
		TextInstance.Text = TextData.Text
		TextInstance.TextColor3 = TextData.TextColor
		TextInstance.BackgroundTransparency = 1
		TextInstance.Parent = raw.ScrollingFrame
		TextInstance.TextWrapped = true
		TextInstance.AutomaticSize = Enum.AutomaticSize.Y
	else
		TextInstance = Instance.new("TextBox")
		if not TextInstance then error("Something went wrong") end
		if not TextInstance:IsA("TextBox") then error("Something went wrong") end

		TextInstance.Name = "TextInstance"
		TextInstance.BorderSizePixel = 0
		TextInstance.RichText = true
		TextInstance.BackgroundColor3 = Color3.new(1, 1, 1)
		TextInstance.FontFace = TextData.TextFont
		TextInstance.TextXAlignment = TextData.Alignment
		TextInstance.TextSize = TextData.FontSize
		TextInstance.Size = UDim2.new(1, 0, 0, 24)
		TextInstance.BorderColor3 = Color3.new(0, 0, 0)
		TextInstance.Text = TextData.Text
		TextInstance.TextColor3 = TextData.TextColor
		TextInstance.BackgroundTransparency = 1
		TextInstance.Parent = raw.ScrollingFrame
		TextInstance.TextWrapped = true
		TextInstance.AutomaticSize = Enum.AutomaticSize.Y
		TextInstance.TextEditable = false
		TextInstance.ClearTextOnFocus = false
	end

	TextData.Instance = (TextInstance::any)

	TextData.Instance.Destroying:Connect(function()
		TextInstance = nil
		(TextData :: any).Instance = nil
	end)

	local mt2 = CreateProxy(TextData, (TextMethods::any), function(_self: Text, key: string, value: any)
		if key == "Text" then (TextInstance::TextLabel).Text = value
		elseif key == "TextColor" then (TextInstance::TextLabel).TextColor3 = value
		elseif key == "FontSize" then (TextInstance::TextLabel).TextSize = value
		elseif key == "Alignment" then (TextInstance::TextLabel).TextXAlignment = value
		elseif key == "TextFont" then (TextInstance::TextLabel).FontFace = value
		end
	end)

	return mt2
end

function TabsMethods:Button(Args: ButtonArgs): Button
	local raw = GetRaw(self) :: Tab
	if not raw or not raw.ScrollingFrame then
		error("Window is not properly initialized")
	end

	local TextButton: TextButton? = Instance.new("TextButton")
	if not TextButton then error("Something went wrong") end

	local ButtonData = {
		Text = ValueOr(Args.Text, "Button"),
		OnClick = Args.OnClick,
		Enabled = ValueOr(Args.Enabled, true),
		BackgroundColor = ValueOr(Args.BackgroundColor, SColor.new(
			Color3.fromRGB(199, 137, 196),
			Color3.fromRGB(126, 84, 124)
			)),
		TextColor = ValueOr(Args.TextColor, SColor.new(
			Color3.new(1, 1, 1),
			Color3.fromRGB(150, 150, 150)
			)),
		BorderColor = ValueOr(Args.BorderColor, SColor.new(
			Color3.fromRGB(126, 84, 124),
			Color3.fromRGB(94, 61, 92)
			)),
		FontSize = ValueOr(Args.FontSize, 18),
		TextFont = ValueOr(Args.TextFont, Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)),
		Instance = TextButton
	} :: Button

	TextButton.Name = "Button"
	TextButton.BorderSizePixel = 0
	TextButton.BackgroundColor3 = if ButtonData.Enabled then ButtonData.BackgroundColor.Enabled else ButtonData.BackgroundColor.Disabled
	TextButton.FontFace = ButtonData.TextFont
	TextButton.TextSize = ButtonData.FontSize
	TextButton.Size = UDim2.new(1, 0, 0, 40)
	TextButton.TextColor3 = ButtonData.TextColor.Enabled
	TextButton.BorderColor3 = Color3.new(0, 0, 0)
	TextButton.Text = ButtonData.Text
	TextButton.Parent = raw.ScrollingFrame

	local UICorner = Instance.new("UICorner")
	UICorner.Name = "UICorner"
	UICorner.CornerRadius = UDim.new(0, 12)
	UICorner.Parent = TextButton

	local UIStroke = Instance.new("UIStroke")
	UIStroke.Name = "UIStroke"
	UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	UIStroke.Color = if ButtonData.Enabled then ButtonData.BorderColor.Enabled else ButtonData.BorderColor.Disabled
	UIStroke.Parent = TextButton

	ButtonData.Instance = TextButton

	TextButton.Destroying:Connect(function()
		TextButton =  nil
		(ButtonData :: any).Instance = nil
	end)

	TextButton.MouseButton1Click:Connect(function()
		if ButtonData.Enabled and ButtonData.OnClick then
			task.spawn(ButtonData.OnClick)
		end
	end)

	if not ButtonData.Enabled then
		ButtonMethods.__set_state(ButtonData, false)
	end
	if not ButtonData.OnClick then
		ButtonMethods.__set_state(ButtonData, false)
	end

	local mt2 = CreateProxy(ButtonData, (ButtonMethods::any), function(_self: Button, key: string, value: any)
		if key == "Text" then ButtonData.Instance.Text = value
		elseif key == "BackgroundColor" then
			if not value or typeof(value) ~= "table" then
				ButtonData.BackgroundColor = SColor.new(
					Color3.fromRGB(199, 137, 196),
					Color3.fromRGB(78, 78, 78)
				)
			end
			TweenService:Create(ButtonData.Instance, BASIC_TWEEN_INFO, {
				BackgroundColor3 = if ButtonData.Enabled then ButtonData.BackgroundColor.Enabled else ButtonData.BackgroundColor.Disabled
			}):Play()
		elseif key == "BorderColor" then
			if not value or typeof(value) ~= "table" then
				ButtonData.BorderColor = SColor.new(
					Color3.fromRGB(104, 114, 134),
					Color3.fromRGB(60, 60, 60)
				)
			end
			TweenService:Create(UIStroke, BASIC_TWEEN_INFO, {
				Color = if ButtonData.Enabled then ButtonData.BorderColor.Enabled else ButtonData.BorderColor.Disabled
			}):Play()
		elseif key == "TextColor" then
			if not value or typeof(value) ~= "table" then
				ButtonData.TextColor = SColor.new(
					Color3.new(1, 1, 1),
					Color3.fromRGB(150, 150, 150)
				)
			end
			TweenService:Create(ButtonData.Instance, BASIC_TWEEN_INFO, {
				TextColor3 = if ButtonData.Enabled then ButtonData.TextColor.Enabled else ButtonData.TextColor.Disabled
			}):Play()
		elseif key == "OnClick" or key == "Enabled" then
			if not ButtonData.OnClick or not ButtonData.Enabled then
				ButtonMethods.__set_state(ButtonData, false)
			else
				ButtonMethods.__set_state(ButtonData, true)
			end
		elseif key == "FontSize" then ButtonData.Instance.TextSize = value
		elseif key == "TextFont" then ButtonData.Instance.FontFace = value
		end
	end)
	return mt2
	-- return setmetatable(Fake, mt) :: any
end

function TabsMethods:TextField(Args): TextField
	local raw = GetRaw(self) :: Tab
	if not raw or not raw.ScrollingFrame then
		error("Tab is not properly initialized")
	end

	local TextBox: TextBox? = Instance.new("TextBox")
	if not TextBox then error("Something went wrong") end

	local TextFieldData = {
		Text = ValueOr(Args.Text, "Text field"),
		OnSubmit = Args.OnSubmit,
		Placeholder = ValueOr(Args.Placeholder, "Placeholder"),
		OnSubmitRequireEnter = ValueOr(Args.OnSubmitRequireEnter, true),
		ClearTextOnFocus = ValueOr(Args.ClearTextOnFocus, false),
		Enabled = ValueOr(Args.Enabled, true),
		BackgroundColor = ValueOr(Args.BackgroundColor, SColor.new(Color3.fromRGB(48, 50, 56), Color3.fromRGB(35, 35, 35))),
		TextColor = ValueOr(Args.TextColor, SColor.new(Color3.new(1, 1, 1), Color3.fromRGB(150, 150, 150))),
		BorderColor = ValueOr(Args.BorderColor, SColor.new(Color3.new(0.65, 0.65, 0.65), Color3.fromRGB(60, 60, 60))),
		PlaceholderColor = ValueOr(Args.PlaceholderColor, SColor.new(Color3.fromRGB(178, 178, 178), Color3.fromRGB(100, 100, 100))),
		MultiLine = ValueOr(Args.MultiLine, false),
		TextFont = ValueOr(Args.TextFont, Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)),
		FontSize = ValueOr(Args.FontSize, 16),
		Instance = TextBox,
	} :: TextField

	TextBox.Name = "TextField"
	TextBox.TextWrapped = true
	TextBox.BorderSizePixel = 0
	TextBox.BackgroundColor3 = if TextFieldData.Enabled then TextFieldData.BackgroundColor.Enabled else TextFieldData.BackgroundColor.Disabled
	TextBox.FontFace = TextFieldData.TextFont
	TextBox.TextSize = TextFieldData.FontSize
	TextBox.Interactable = TextFieldData.Enabled
	TextBox.Size = UDim2.new(1, 0, 0, 40)
	TextBox.TextColor3 = if TextFieldData.Enabled then TextFieldData.TextColor.Enabled else TextFieldData.TextColor.Disabled
	TextBox.BorderColor3 = Color3.new(0, 0, 0)
	TextBox.ClearTextOnFocus = TextFieldData.ClearTextOnFocus
	TextBox.Text = TextFieldData.Text
	TextBox.TextXAlignment = Enum.TextXAlignment.Left
	TextBox.AutomaticSize = Enum.AutomaticSize.Y
	TextBox.Parent = raw.ScrollingFrame
	TextBox.PlaceholderText = TextFieldData.Placeholder
	TextBox.PlaceholderColor3 = TextFieldData.PlaceholderColor.Enabled

	local UICorner = Instance.new("UICorner")
	UICorner.Name = "UICorner"
	UICorner.CornerRadius = UDim.new(0, 12)
	UICorner.Parent = TextBox

	local UIStroke = Instance.new("UIStroke")
	UIStroke.Name = "UIStroke"
	UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	UIStroke.Color = if TextFieldData.Enabled then TextFieldData.BorderColor.Enabled else TextFieldData.BorderColor.Disabled
	UIStroke.Parent = TextBox

	local UIPadding = Instance.new("UIPadding")
	UIPadding.Name = "UIPadding"
	UIPadding.PaddingBottom = UDim.new(0, 10)
	UIPadding.PaddingTop = UDim.new(0, 10)
	UIPadding.PaddingLeft = UDim.new(0, 14)
	UIPadding.PaddingRight = UDim.new(0, 14)
	UIPadding.Parent = TextBox

	TextFieldData.Instance = TextBox

	TextBox.Destroying:Connect(function()
		TextBox = nil
		(TextFieldData :: any).Instance = nil
	end)

	TextBox:GetPropertyChangedSignal("Text"):Connect(function()
		TextFieldData.Text = TextBox.Text
	end)

	TextBox.FocusLost:Connect(function(enterPressed: boolean, inputThatCausedFocusLoss: InputObject)
		if not TextFieldData.OnSubmit then return end

		if TextFieldData.OnSubmitRequireEnter and enterPressed then
			TextFieldData.OnSubmit(TextBox.Text)
		elseif not TextFieldData.OnSubmitRequireEnter then
			TextFieldData.OnSubmit(TextBox.Text)
		end
	end)

	local mt2 = CreateProxy(TextFieldData, (TextFieldMethods::any), function(_self: TextField, key: string, value)
		if key == "Text" then TextFieldData.Instance.Text = value
		elseif key == "Placeholder" then TextFieldData.Instance.PlaceholderText = value
		elseif key == "ClearTextOnFocus" then TextFieldData.Instance.ClearTextOnFocus = value
		elseif key == "Enabled" then
			TextFieldData.Instance.Interactable = value
			TextFieldMethods.__set_state(TextFieldData, value)
		elseif key == "BackgroundColor" then
			if not value or typeof(value) ~= "table" then
				TextFieldData.BackgroundColor = SColor.new(Color3.fromRGB(48, 50, 56), Color3.fromRGB(35, 35, 35))
			end
			TweenService:Create(TextFieldData.Instance, BASIC_TWEEN_INFO, {
				BackgroundColor3 = if TextFieldData.Enabled then TextFieldData.BackgroundColor.Enabled else TextFieldData.BackgroundColor.Disabled
			}):Play()
		elseif key == "BorderColor" then
			if not value or typeof(value) ~= "table" then
				TextFieldData.BorderColor = SColor.new(Color3.new(0.65, 0.65, 0.65), Color3.fromRGB(60, 60, 60))
			end
			TweenService:Create(UIStroke, BASIC_TWEEN_INFO, {
				Color = if TextFieldData.Enabled then TextFieldData.BorderColor.Enabled else TextFieldData.BorderColor.Disabled
			}):Play()
		elseif key == "TextColor" then
			if not value or typeof(value) ~= "table" then
				TextFieldData.TextColor = SColor.new(Color3.new(1, 1, 1), Color3.fromRGB(150, 150, 150))
			end
			TweenService:Create(TextFieldData.Instance, BASIC_TWEEN_INFO, {
				TextColor3 = if TextFieldData.Enabled then TextFieldData.TextColor.Enabled else TextFieldData.TextColor.Disabled
			}):Play()
		elseif key == "PlaceholderColor" then
			if not value or typeof(value) ~= "table" then
				TextFieldData.PlaceholderColor = SColor.new(Color3.fromRGB(178, 178, 178), Color3.fromRGB(100, 100, 100))
			end
			TweenService:Create(TextFieldData.Instance, BASIC_TWEEN_INFO, {
				PlaceholderColor3 = if TextFieldData.Enabled then TextFieldData.PlaceholderColor.Enabled else TextFieldData.PlaceholderColor.Disabled
			}):Play()
		elseif key == "TextFont" then TextFieldData.Instance.FontFace = value
		elseif key == "FontSize" then TextFieldData.Instance.TextSize = value
		elseif key == "MultiLine" then TextFieldData.Instance.MultiLine = value
		end
	end)

	return mt2
end

function TabsMethods:Switch(Args): Switch
	local raw = GetRaw(self) :: Tab
	if not raw or not raw.ScrollingFrame then
		error("Tab is not properly initialized")
	end

	local SwitchInstance: TextButton? = Instance.new("TextButton")
	if not SwitchInstance then error("Something went wrong") end

	local SwitchData = {
		Text = ValueOr(Args.Text, "Switch"),
		Value = ValueOr(Args.Value, false),
		OnChange = Args.OnChange,
		Enabled = ValueOr(Args.Enabled, true),

		ActiveTrackColor = ValueOr(Args.ActiveTrackColor, SColor.new(
			Color3.fromRGB(148, 219, 134),
			Color3.fromRGB(107, 158, 97)
			)),
		ActiveThumbColor = ValueOr(Args.ActiveThumbColor, SColor.new(
			Color3.fromRGB(28, 62, 24),
			Color3.fromRGB(18, 43, 15)
			)),
		ActiveBorderColor = ValueOr(Args.ActiveBorderColor, SColor.new(
			Color3.fromRGB(148, 219, 134),
			Color3.fromRGB(107, 158, 97)
			)),

		InactiveTrackColor = ValueOr(Args.InactiveTrackColor, SColor.new(
			Color3.fromRGB(48, 50, 56),
			Color3.fromRGB(24, 25, 29)
			)),
		InactiveThumbColor = ValueOr(Args.InactiveThumbColor, SColor.new(
			Color3.fromRGB(165, 165, 165),
			Color3.fromRGB(121, 121, 121)
			)),
		InactiveBorderColor = ValueOr(Args.InactiveBorderColor, SColor.new(
			Color3.fromRGB(165, 165, 165),
			Color3.fromRGB(121, 121, 121)
			)),

		TextColor = ValueOr(Args.TextColor,Color3.new(0.95, 0.95, 0.95)),
		TextFont = ValueOr(Args.TextFont, Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)),
		FontSize = ValueOr(Args.FontSize, 18),
		Instance = SwitchInstance
	} :: Switch

	SwitchInstance.Name = "SwitchInstance"
	SwitchInstance.Active = false
	SwitchInstance.BorderSizePixel = 0
	SwitchInstance.BackgroundColor3 = Color3.new(1, 1, 1)
	SwitchInstance.Size = UDim2.new(1, 0, 0, 40)
	SwitchInstance.BorderColor3 = Color3.new(0, 0, 0)
	SwitchInstance.Text = ""
	SwitchInstance.BackgroundTransparency = 1
	SwitchInstance.Selectable = false
	SwitchInstance.Parent = raw.ScrollingFrame

	local TextLabel = Instance.new("TextLabel")
	TextLabel.Name = "TextLabel"
	TextLabel.BorderSizePixel = 0
	TextLabel.RichText = true
	TextLabel.BackgroundColor3 = Color3.new(1, 1, 1)
	TextLabel.FontFace = SwitchData.TextFont
	TextLabel.AnchorPoint = Vector2.new(0, 0.5)
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel.TextSize = SwitchData.FontSize
	TextLabel.Size = UDim2.new(1, 0, 1, 0)
	TextLabel.BorderColor3 = Color3.new(0, 0, 0)
	TextLabel.Text = SwitchData.Text
	TextLabel.TextColor3 = SwitchData.TextColor
	TextLabel.BackgroundTransparency = 1
	TextLabel.Position = UDim2.new(0, 0, 0.5, 0)
	TextLabel.Parent = SwitchInstance

	local Track = Instance.new("Frame")
	Track.Name = "Track"
	Track.AnchorPoint = Vector2.new(1, 0.5)
	Track.Size = UDim2.new(0, 50, 0, 28)
	Track.BorderColor3 = Color3.new(0, 0, 0)
	Track.Position = UDim2.new(1, 0, 0.5, 0)
	Track.BorderSizePixel = 0
	Track.Parent = SwitchInstance

	local UICorner = Instance.new("UICorner")
	UICorner.Name = "UICorner"
	UICorner.CornerRadius = UDim.new(1, 0)
	UICorner.Parent = Track

	local UIStroke = Instance.new("UIStroke")
	UIStroke.Name = "UIStroke"
	UIStroke.Parent = Track

	local Thumb = Instance.new("Frame")
	Thumb.Name = "Thumb"
	Thumb.AnchorPoint = if SwitchData.Value then Vector2.new(1, 0.5) else Vector2.new(0, 0.5)
	Thumb.Size = UDim2.new(0, 22, 0, 22)
	Thumb.BorderColor3 = Color3.new(0, 0, 0)
	Thumb.Position = if SwitchData.Value then UDim2.new(1, -3, 0.5, 0) else UDim2.new(0, 3, 0.5, 0)
	Thumb.BorderSizePixel = 0
	Thumb.Parent = Track

	local UICorner_1 = Instance.new("UICorner")
	UICorner_1.Name = "UICorner 1"
	UICorner_1.CornerRadius = UDim.new(1, 0)
	UICorner_1.Parent = Thumb

	SwitchData.Instance = SwitchInstance

	SwitchInstance.Destroying:Connect(function()
		SwitchInstance = nil
		(SwitchData :: any).Instance = nil
	end)

	SwitchInstance.MouseButton1Click:Connect(function()
		if not SwitchData.Enabled then return end
		SwitchData.Value = not SwitchData.Value
		if SwitchData.OnChange then
			task.spawn(SwitchData.OnChange, SwitchData.Value)
		end
		if SwitchData.Value == true then
			SwitchMethods.Enable(SwitchData, true)
		else
			SwitchMethods.Disable(SwitchData, true)
		end
	end)

	if SwitchData.Value then
		Track.BackgroundColor3 = if SwitchData.Enabled then SwitchData.ActiveTrackColor.Enabled else SwitchData.ActiveTrackColor.Disabled
		UIStroke.Color = if SwitchData.Enabled then SwitchData.ActiveBorderColor.Enabled else SwitchData.ActiveBorderColor.Disabled
		Thumb.BackgroundColor3 = if SwitchData.Enabled then SwitchData.ActiveThumbColor.Enabled else SwitchData.ActiveThumbColor.Disabled
	else
		Track.BackgroundColor3 = if SwitchData.Enabled then SwitchData.InactiveTrackColor.Enabled else SwitchData.InactiveTrackColor.Disabled
		UIStroke.Color = if SwitchData.Enabled then SwitchData.InactiveBorderColor.Enabled else SwitchData.InactiveBorderColor.Disabled
		Thumb.BackgroundColor3 = if SwitchData.Enabled then SwitchData.InactiveThumbColor.Enabled else SwitchData.InactiveThumbColor.Disabled
	end

	local mt2 = CreateProxy(SwitchData, (SwitchMethods::any), function(_self: Switch, key: string, value: any)
		if key == "Text" then TextLabel.Text = value
		elseif key == "Value" then
			if value == true then
				SwitchMethods.Enable(SwitchData, true)
			else
				SwitchMethods.Disable(SwitchData, true)
			end
		elseif key == "Enabled" then
			if SwitchData.Value then
				TweenService:Create(Track, BASIC_TWEEN_INFO, {
					BackgroundColor3 = if SwitchData.Enabled then SwitchData.ActiveTrackColor.Enabled else SwitchData.ActiveTrackColor.Disabled
				}):Play()
				TweenService:Create(UIStroke, BASIC_TWEEN_INFO, {
					Color = if SwitchData.Enabled then SwitchData.ActiveBorderColor.Enabled else SwitchData.ActiveBorderColor.Disabled
				}):Play()
				TweenService:Create(Thumb, BASIC_TWEEN_INFO, {
					BackgroundColor3 = if SwitchData.Enabled then SwitchData.ActiveThumbColor.Enabled else SwitchData.ActiveThumbColor.Disabled
				}):Play()
			else
				TweenService:Create(Track, BASIC_TWEEN_INFO, {
					BackgroundColor3 = if SwitchData.Enabled then SwitchData.InactiveTrackColor.Enabled else SwitchData.InactiveTrackColor.Disabled
				}):Play()
				TweenService:Create(UIStroke, BASIC_TWEEN_INFO, {
					Color = if SwitchData.Enabled then SwitchData.InactiveBorderColor.Enabled else SwitchData.InactiveBorderColor.Disabled
				}):Play()
				TweenService:Create(Thumb, BASIC_TWEEN_INFO, {
					BackgroundColor3 = if SwitchData.Enabled then SwitchData.InactiveThumbColor.Enabled else SwitchData.InactiveThumbColor.Disabled
				}):Play()
			end

		elseif key == "ActiveTrackColor" then
			TweenService:Create(Track, BASIC_TWEEN_INFO, {
				BackgroundColor3 = if SwitchData.Enabled then SwitchData.ActiveTrackColor.Enabled else SwitchData.ActiveTrackColor.Disabled
			}):Play()
		elseif key == "InactiveTrackColor" then
			TweenService:Create(Track, BASIC_TWEEN_INFO, {
				BackgroundColor3 = if SwitchData.Enabled then SwitchData.InactiveTrackColor.Enabled else SwitchData.InactiveTrackColor.Disabled
			}):Play()

		elseif key == "ActiveBorderColor" then
			TweenService:Create(UIStroke, BASIC_TWEEN_INFO, {
				Color = if SwitchData.Enabled then SwitchData.ActiveBorderColor.Enabled else SwitchData.ActiveBorderColor.Disabled
			}):Play()
		elseif key == "InactiveBorderColor" then
			TweenService:Create(UIStroke, BASIC_TWEEN_INFO, {
				Color = if SwitchData.Enabled then SwitchData.InactiveBorderColor.Enabled else SwitchData.InactiveBorderColor.Disabled
			}):Play()

		elseif key == "ActiveThumbColor" then
			TweenService:Create(Thumb, BASIC_TWEEN_INFO, {
				BackgroundColor3 = if SwitchData.Enabled then SwitchData.ActiveThumbColor.Enabled else SwitchData.ActiveThumbColor.Disabled
			}):Play()
		elseif key == "InactiveThumbColor" then
			TweenService:Create(Thumb, BASIC_TWEEN_INFO, {
				BackgroundColor3 = if SwitchData.Enabled then SwitchData.InactiveThumbColor.Enabled else SwitchData.InactiveThumbColor.Disabled
			}):Play()
		elseif key == "TextColor" then
			TweenService:Create(TextLabel, BASIC_TWEEN_INFO, {
				TextColor3 = SwitchData.TextColor
			}):Play()
		elseif key == "TextFont" then TextLabel.FontFace = value
		elseif key == "FontSize" then TextLabel.TextSize = value
		end
	end)
	return mt2
end

function WindowMethods:Tab(Args): Tab
	local raw = GetRaw(self) :: Window
	if not raw or not raw.TabButtons or not raw.TabsHandler then
		error("Window is not properly initialized")
	end

	local ScrollingFrame = Instance.new("ScrollingFrame")
	local Tab = Instance.new("TextButton")

	local TabData = {
		Name = ValueOr(Args.Name, "Tab"),
		ScrollingFrame = ScrollingFrame,
		Instance = Tab
	} :: Tab

	ScrollingFrame.Name = "ScrollingFrame"
	ScrollingFrame.Active = true
	ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
	ScrollingFrame.BorderSizePixel = 0
	ScrollingFrame.BackgroundColor3 = Color3.new(1, 1, 1)
	ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
	ScrollingFrame.BorderColor3 = Color3.new(0, 0, 0)
	ScrollingFrame.ScrollBarThickness = 0
	ScrollingFrame.BackgroundTransparency = 1
	ScrollingFrame.Parent = raw.TabsHandler
	ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	ScrollingFrame.ClipsDescendants = false

	local scrolling_UIPadding = Instance.new("UIPadding")
	scrolling_UIPadding.Name = "ScrollingUIPadding"
	scrolling_UIPadding.PaddingTop = UDim.new(0, 4)
	scrolling_UIPadding.PaddingLeft = UDim.new(0, 12)
	scrolling_UIPadding.PaddingRight = UDim.new(0, 12)
	scrolling_UIPadding.Parent = ScrollingFrame

	local scrolling_UIListLayout = Instance.new("UIListLayout")
	scrolling_UIListLayout.Name = "ScrollingUIListLayout"
	scrolling_UIListLayout.Padding = UDim.new(0, 1)
	scrolling_UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	scrolling_UIListLayout.Parent = ScrollingFrame

	Tab.Name = "Tab"
	Tab.AutomaticSize = Enum.AutomaticSize.X
	Tab.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
	Tab.BackgroundTransparency = 0.5
	Tab.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
	Tab.Size = UDim2.fromScale(0, 1)
	Tab.Text = ""
	Tab.TextColor3 = Color3.new(1, 1, 1)
	Tab.TextSize = 14

	local textLabel = Instance.new("TextLabel")
	textLabel.Name = "TextLabel"
	textLabel.AutomaticSize = Enum.AutomaticSize.X
	textLabel.BackgroundTransparency = 1
	textLabel.FontFace = Font.new(
		"rbxasset://fonts/families/GothamSSm.json",
		Enum.FontWeight.SemiBold,
		Enum.FontStyle.Normal
	)
	textLabel.Size = UDim2.fromScale(0, 1)
	textLabel.Text = `   {TabData.Name}   `
	textLabel.TextColor3 = Color3.new(1, 1, 1)
	textLabel.TextSize = 14
	textLabel.Parent = Tab

	local uIPadding = Instance.new("UIPadding")
	uIPadding.Name = "UIPadding"
	uIPadding.Parent = Tab

	local uIStroke = Instance.new("UIStroke")
	uIStroke.Name = "UIStroke"
	uIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	uIStroke.Color = if (#raw.Tabs == 0) then Color3.new(1, 1, 1) else Color3.fromRGB(102, 102, 102)
	uIStroke.Parent = Tab

	local uICorner = Instance.new("UICorner")
	uICorner.Name = "UICorner"
	uICorner.Parent = Tab

	local uIShadow = Instance.new("UIShadow")
	uIShadow.Name = "UIShadow"
	uIShadow.BlurRadius = UDim.new(0, 20)
	uIShadow.Transparency = 0.5
	uIShadow.Parent = Tab

	Tab.Parent = raw.TabButtons

	ScrollingFrame.Destroying:Connect(function()
		ScrollingFrame = (nil::any)
		TabData.ScrollingFrame = (nil::any)
	end)

	Tab.Destroying:Connect(function()
		Tab = (nil::any)
		TabData.Instance = (nil::any)
	end)

	Tab.MouseButton1Click:Connect(function()
		if raw.TabsHandlerUIPageLayout.CurrentPage == ScrollingFrame then return end

		for _, item in raw.Tabs do
			if not item or not item.Instance then continue end

			local UIStroke = item.Instance:FindFirstChild("UIStroke")
			if not UIStroke or not UIStroke:IsA("UIStroke") then continue end

			UIStroke.Color = Color3.fromRGB(102, 102, 102)
		end

		uIStroke.Color = Color3.new(1, 1, 1)
		raw.TabsHandlerUIPageLayout:JumpTo(ScrollingFrame)
	end)

	table.insert(raw.Tabs, TabData)

	local mt = CreateProxy(TabData, TabsMethods, function(raw, key: string, value)
		if key == "Name" then textLabel.Text = `   {value}   `
		end
	end)

	return mt
end

--================ CREATE WINDOW ================--

function Debugger.UI.new(Args: WindowArgs): Window
	local WindowRaw = {
		Title = ValueOr(Args.Title, "Tracechan"),
		ScreenGui = Args.ScreenGui,
		Visible = ValueOr(Args.Visible, true),
		BackgroundImage = ValueOr(Args.BackgroundImage, ""),
		BackgroundImageTransparency = ValueOr(Args.BackgroundImageTransparency, 1),
		BackgroundImageScaleType = ValueOr(Args.BackgroundImageScaleType, Enum.ScaleType.Fit),
		Instance = nil :: Frame?,
		StateButton = nil :: TextButton?,
		NotificationHandler = nil :: Frame?,
		TitleLabel = nil :: TextLabel?,
		CanvasGroup = nil :: CanvasGroup?,
		TabButtons = nil :: ScrollingFrame?,
		TabsHandler = nil :: Frame?,
		TabsHandlerUIPageLayout = nil :: UIPageLayout?,
		Tabs = {}
	} :: Window

	local DragHeader = Instance.new("Frame")
	DragHeader.BackgroundTransparency = 1
	DragHeader.Position = UDim2.new(0.5, 0, 0.5, 0)
	DragHeader.Size = UDim2.new(1, -20, 1, -20)
	DragHeader.AnchorPoint = Vector2.new(0.5, 0.5)
	DragHeader.Name = "DragHeader"
	DragHeader.BorderSizePixel = 0
	DragHeader.Parent = WindowRaw.ScreenGui

	-- Notification Handler
	local NotificationHandler = Instance.new("Frame")
	NotificationHandler.Name = "NotificationHandler"
	NotificationHandler.AnchorPoint = Vector2.new(1, 0)
	NotificationHandler.Size = UDim2.new(0, 220, 1, 0)
	NotificationHandler.BorderColor3 = Color3.new(0, 0, 0)
	NotificationHandler.Position = UDim2.new(1, 0, 0, 0)
	NotificationHandler.BorderSizePixel = 0
	NotificationHandler.BackgroundTransparency = 1
	NotificationHandler.BackgroundColor3 = Color3.new(1, 1, 1)
	NotificationHandler.Parent = Args.ScreenGui

	local _notification_UIListLayout = Instance.new("UIListLayout")
	_notification_UIListLayout.Name = "NotificationUIListLayout"
	_notification_UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	_notification_UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	_notification_UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	_notification_UIListLayout.Parent = NotificationHandler
	_notification_UIListLayout.Padding = UDim.new(0, 4)

	local _notification_UIPadding = Instance.new("UIPadding")
	_notification_UIPadding.Name = "NotificationUIPadding"
	_notification_UIPadding.PaddingBottom = UDim.new(0, 10)
	_notification_UIPadding.PaddingRight = UDim.new(0, 10)
	_notification_UIPadding.Parent = NotificationHandler

	-- State Button
	local State = Instance.new("TextButton")
	State.Name = "State"
	State.BorderSizePixel = 0
	State.BackgroundColor3 = Color3.new(0, 0, 0)
	State.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
	State.AnchorPoint = Vector2.new(0.5, 0.5)
	State.TextSize = 14
	State.Size = UDim2.new(0, 42, 0, 42)
	State.TextColor3 = Color3.new(0, 0, 0)
	State.BorderColor3 = Color3.new(0, 0, 0)
	State.Text = "D"
	State.AutomaticSize = Enum.AutomaticSize.X
	State.BackgroundTransparency = 0.4
	State.Position = UDim2.new(0.5, 0, 0, 100)
	State.Parent = WindowRaw.ScreenGui
	DragGUI(State) -- TODO: Upgrade

	local state_UICorner = Instance.new("UICorner")
	state_UICorner.Name = "StateUICorner"
	state_UICorner.CornerRadius = UDim.new(1, 0)
	state_UICorner.Parent = State

	local state_TextLabel = Instance.new("TextLabel")
	state_TextLabel.Name = "StateTextLabel"
	state_TextLabel.TextWrapped = true
	state_TextLabel.BorderSizePixel = 0
	state_TextLabel.BackgroundColor3 = Color3.new(1, 1, 1)
	state_TextLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
	state_TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	state_TextLabel.TextSize = 16
	state_TextLabel.Size = UDim2.new(0, 0, 1, 0)
	state_TextLabel.BorderColor3 = Color3.new(0, 0, 0)
	state_TextLabel.Text = "D"
	state_TextLabel.TextColor3 = Color3.new(1, 1, 1)
	state_TextLabel.AutomaticSize = Enum.AutomaticSize.X
	state_TextLabel.BackgroundTransparency = 1
	state_TextLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
	state_TextLabel.Parent = State

	local state_UIPadding = Instance.new("UIPadding")
	state_UIPadding.Name = "StateUIPadding"
	state_UIPadding.PaddingLeft = UDim.new(0, 10)
	state_UIPadding.PaddingRight = UDim.new(0, 10)
	state_UIPadding.Parent = State

	-- Main Frame
	local Frame = Instance.new("Frame")
	Frame.Name = "Frame"
	Frame.Active = false
	Frame.BorderSizePixel = 0
	Frame.BackgroundColor3 = Color3.new(0, 0, 0)
	Frame.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame.Size = UDim2.new(0, 400, 0, 400)
	Frame.BorderColor3 = Color3.new(0, 0, 0)
	Frame.BackgroundTransparency = 0.5
	Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	Frame.Parent = WindowRaw.ScreenGui

	local FrameUIScale = Instance.new("UIScale")
	FrameUIScale.Name = "UIScale"
	FrameUIScale.Parent = Frame

	local FrameUIShadow = Instance.new("UIShadow")
	FrameUIShadow.Name = "UIShadow"
	FrameUIShadow.BlurRadius = UDim.new(0, 20)
	FrameUIShadow.Transparency = 0.7
	FrameUIShadow.Parent = Frame

	local Frame_UIDragDetector = Instance.new("UIDragDetector")
	Frame_UIDragDetector.Parent = Frame
	Frame_UIDragDetector.BoundingBehavior = Enum.UIDragDetectorBoundingBehavior.EntireObject
	Frame_UIDragDetector.BoundingUI = DragHeader
	Frame_UIDragDetector.Enabled = true

	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Name = "TitleLabel"
	TitleLabel.Interactable = false
	TitleLabel.BorderSizePixel = 0
	TitleLabel.RichText = true
	TitleLabel.BackgroundColor3 = Color3.new(1, 1, 1)
	TitleLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
	TitleLabel.TextSize = 22
	TitleLabel.Size = UDim2.new(1, 0, 0, 26)
	TitleLabel.BorderColor3 = Color3.new(0, 0, 0)
	TitleLabel.Text = WindowRaw.Title
	TitleLabel.TextColor3 = Color3.new(1, 1, 1)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Position = UDim2.new(0, 0, 0, 2)
	TitleLabel.Parent = Frame

	local frame_UICorner = Instance.new("UICorner")
	frame_UICorner.Name = "FrameUICorner"
	frame_UICorner.CornerRadius = UDim.new(0, 14)
	frame_UICorner.Parent = Frame

	local CanvasGroup = Instance.new("CanvasGroup")
	CanvasGroup.Name = "CanvasGroup"
	CanvasGroup.Parent = Frame
	CanvasGroup.BorderSizePixel = 0
	CanvasGroup.BackgroundColor3 = Color3.new(0, 0, 0)
	CanvasGroup.AnchorPoint = Vector2.new(0.5, 0.5)
	CanvasGroup.Size = UDim2.new(1, -14, 0.96, -20)
	CanvasGroup.BorderColor3 = Color3.new(0, 0, 0)
	CanvasGroup.BackgroundTransparency = 0.8
	CanvasGroup.Position = UDim2.new(0.5, 0, 0.53, 0)
	CanvasGroup.ZIndex = 5

	local BackgroundImageLabel = Instance.new("ImageLabel")
	BackgroundImageLabel.Name = "BackgroundImageLabel"
	BackgroundImageLabel.Size = UDim2.new(1, 0, 1, 0)
	BackgroundImageLabel.BackgroundTransparency = 1
	BackgroundImageLabel.BorderSizePixel = 0
	BackgroundImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	BackgroundImageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
	BackgroundImageLabel.Image = WindowRaw.BackgroundImage
	BackgroundImageLabel.ImageTransparency = WindowRaw.BackgroundImageTransparency
	BackgroundImageLabel.ScaleType = WindowRaw.BackgroundImageScaleType
	BackgroundImageLabel.Parent = Frame
	BackgroundImageLabel.ZIndex = 2

	local canvas_UICorner = Instance.new("UICorner")
	canvas_UICorner.Name = "CanvasUICorner"
	canvas_UICorner.CornerRadius = UDim.new(0, 10)
	canvas_UICorner.Parent = CanvasGroup

	local background_UICorner = Instance.new("UICorner")
	background_UICorner.Name = "CanvasUICorner"
	background_UICorner.CornerRadius = UDim.new(0, 14)
	background_UICorner.Parent = BackgroundImageLabel

	-- Tabs
	local TabButtons = Instance.new("ScrollingFrame")
	TabButtons.Name = "TabButtons"
	TabButtons.AutomaticCanvasSize = Enum.AutomaticSize.X
	TabButtons.BackgroundTransparency = 1
	TabButtons.CanvasSize = UDim2.fromScale(2, 0)
	TabButtons.ClipsDescendants = false
	TabButtons.Position = UDim2.fromOffset(8, 8)
	TabButtons.ScrollBarImageTransparency = 1
	TabButtons.ScrollBarThickness = 0
	TabButtons.ScrollingDirection = Enum.ScrollingDirection.X
	TabButtons.Selectable = false
	TabButtons.Size = UDim2.new(1, -16, 0, 35)
	TabButtons.ClipsDescendants = false
	TabButtons.Parent = CanvasGroup
	TabButtons.ZIndex = 10

	local UIListLayout = Instance.new("UIListLayout")
	UIListLayout.Name = "UIListLayout"
	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.Padding = UDim.new(0, 10)
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Parent = TabButtons

	local TabsHandler = Instance.new("Frame")
	TabsHandler.Name = "TabsHandler"
	TabsHandler.Active = true
	TabsHandler.BackgroundTransparency = 1
	TabsHandler.Position = UDim2.fromOffset(0, 50)
	TabsHandler.Selectable = true
	TabsHandler.SelectionGroup = true
	TabsHandler.Size = UDim2.new(1, 0, 1, -50)
	TabsHandler.Parent = CanvasGroup

	local TabsHandlerUIPageLayout = Instance.new("UIPageLayout")
	TabsHandlerUIPageLayout.Name = "UIPageLayout"
	TabsHandlerUIPageLayout.EasingDirection = Enum.EasingDirection.InOut
	TabsHandlerUIPageLayout.EasingStyle = Enum.EasingStyle.Cubic
	TabsHandlerUIPageLayout.GamepadInputEnabled = false
	TabsHandlerUIPageLayout.ScrollWheelInputEnabled = false
	TabsHandlerUIPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TabsHandlerUIPageLayout.TouchInputEnabled = false
	TabsHandlerUIPageLayout.TweenTime = 0.4
	TabsHandlerUIPageLayout.Parent = TabsHandler

	WindowRaw.Instance = Frame
	WindowRaw.StateButton = State
	WindowRaw.NotificationHandler = NotificationHandler
	WindowRaw.TitleLabel = TitleLabel
	WindowRaw.CanvasGroup = CanvasGroup
	WindowRaw.DragHeader = DragHeader
	WindowRaw.TabButtons = TabButtons
	WindowRaw.TabsHandler = TabsHandler
	WindowRaw.TabsHandlerUIPageLayout = TabsHandlerUIPageLayout

	-- State toggle
	local stateDebounce = false
	State.MouseButton1Click:Connect(function()
		if stateDebounce == true then return end

		stateDebounce = true
		task.delay(0.6, function()
			stateDebounce = false
			if WindowRaw.Visible == false then
				Frame.Visible = false
			end
		end)

		if WindowRaw.Visible == true then
			WindowRaw.Visible = false
			TweenService:Create(CanvasGroup, TweenInfo.new(0.5, Enum.EasingStyle.Cubic), { GroupTransparency = 1 }):Play()
			TweenService:Create(Frame, TweenInfo.new(0.5, Enum.EasingStyle.Cubic), { BackgroundTransparency = 1 }):Play()
			TweenService:Create(TitleLabel, TweenInfo.new(0.5, Enum.EasingStyle.Cubic), { TextTransparency = 1 }):Play()
			TweenService:Create(FrameUIShadow, TweenInfo.new(0.5, Enum.EasingStyle.Cubic), { Transparency = 1 }):Play()
			TweenService:Create(BackgroundImageLabel, TweenInfo.new(0.5, Enum.EasingStyle.Cubic), { ImageTransparency = 1 }):Play()
		else
			WindowRaw.Visible = true
			Frame.Visible = true
			TweenService:Create(CanvasGroup, TweenInfo.new(0.5, Enum.EasingStyle.Cubic), { GroupTransparency = 0 }):Play()
			TweenService:Create(Frame, TweenInfo.new(0.5, Enum.EasingStyle.Cubic), { BackgroundTransparency = 0.5 }):Play()
			TweenService:Create(TitleLabel, TweenInfo.new(0.5, Enum.EasingStyle.Cubic), { TextTransparency = 0 }):Play()
			TweenService:Create(FrameUIShadow, TweenInfo.new(0.5, Enum.EasingStyle.Cubic), { Transparency = 0.7 }):Play()
			TweenService:Create(BackgroundImageLabel, TweenInfo.new(0.5, Enum.EasingStyle.Cubic), { ImageTransparency = WindowRaw.BackgroundImageTransparency }):Play()
		end
	end)

	-- Window proxy
	local WindowFake = {}
	local windowMt = {
		__index = function(_, key: any)
			if key == "_gettable" then
				return WindowRaw
			end
			local value = (WindowRaw :: any)[key]
			if value ~= nil then
				return value
			end
			return (WindowMethods :: any)[key]
		end,
		__newindex = function(_, key, value: any)
			if key == "_gettable" then
				error("Property '_gettable' is read-only")
			end
			if WINDOW_READ_ONLY_KEYS[key] then
				error(`Property '{key}' is read-only`)
			end
			WindowRaw[key] = value
			if key == "Title" then
				WindowRaw.Title = value
				if WindowRaw.TitleLabel then
					WindowRaw.TitleLabel.Text = value
				end
			elseif key == "ScreenGui" then
				WindowRaw.ScreenGui = value
				if WindowRaw.Instance then
					WindowRaw.Instance.Parent = value
				end
				if WindowRaw.StateButton then
					WindowRaw.StateButton.Parent = value
				end
				if WindowRaw.NotificationHandler then
					WindowRaw.NotificationHandler.Parent = value
				end
				if WindowRaw.DragHeader then
					WindowRaw.DragHeader.Parent = value
				end

			elseif key == "Visible" then
				if value == true then
					Frame.Visible = true
					TweenService:Create(CanvasGroup, TweenInfo.new(0.5, Enum.EasingStyle.Cubic), { GroupTransparency = 0 }):Play()
					TweenService:Create(Frame, TweenInfo.new(0.5, Enum.EasingStyle.Cubic), { BackgroundTransparency = 0.5 }):Play()
					TweenService:Create(TitleLabel, TweenInfo.new(0.5, Enum.EasingStyle.Cubic), { TextTransparency = 0 }):Play()
					TweenService:Create(FrameUIShadow, TweenInfo.new(0.5, Enum.EasingStyle.Cubic), { Transparency = 0.7 }):Play()
					TweenService:Create(BackgroundImageLabel, TweenInfo.new(0.5, Enum.EasingStyle.Cubic), { ImageTransparency = WindowRaw.BackgroundImageTransparency }):Play()
				else
					TweenService:Create(CanvasGroup, TweenInfo.new(0.5, Enum.EasingStyle.Cubic), { GroupTransparency = 1 }):Play()
					TweenService:Create(Frame, TweenInfo.new(0.5, Enum.EasingStyle.Cubic), { BackgroundTransparency = 1 }):Play()
					TweenService:Create(TitleLabel, TweenInfo.new(0.5, Enum.EasingStyle.Cubic), { TextTransparency = 1 }):Play()
					TweenService:Create(FrameUIShadow, TweenInfo.new(0.5, Enum.EasingStyle.Cubic), { Transparency = 1 }):Play()
					TweenService:Create(BackgroundImageLabel, TweenInfo.new(0.5, Enum.EasingStyle.Cubic), { ImageTransparency = 1 }):Play()
				end
			elseif key == "BackgroundImage" then
				BackgroundImageLabel.Image = value
			elseif key == "BackgroundImageTransparency" then
				BackgroundImageLabel.ImageTransparency = math.clamp(value, 0, 1)
			elseif key == "BackgroundImageScaleType" then
				BackgroundImageLabel.ScaleType = value
			end
		end,
	}
	return setmetatable(WindowFake, windowMt) :: any
end

return Debugger																																																			
