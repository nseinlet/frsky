local toolName = "TNS|Change ISRM mode|TNE"
local mode = -1

local REC_W
local REC_H
local REC1_X
local REC2_X
local REC_Y
local REC1_TXT_X
local REC2_TXT_X
local REC_TXT_Y
local TXT_X
local TXT_Y
local FilledRec
local FilledRecTxt

local function redrawPage()
  lcd.clear()

    if LCD_W == 480 then
        lcd.drawFilledRectangle(0, 0, LCD_W, 30, FilledRec)
        lcd.drawText(LCD_W/2, 5, "ISRM MODE", FilledRecTxt)
    else
        lcd.drawScreenTitle("ISRM MODE", 0, 0)
    end

    if mode == 0 then
        if LCD_W ~= 480 then
            lcd.drawText(REC1_TXT_X, REC_TXT_Y, "LBT / EU", FilledRecTxt)
        end
        lcd.drawRectangle(REC1_X, REC_Y, REC_W, REC_H, 0)
        lcd.drawFilledRectangle(REC1_X+2, REC_Y+2, REC_W-4, REC_H-4, FilledRec)
        if LCD_W == 480 then
            lcd.drawText(REC1_TXT_X, REC_TXT_Y, "LBT / EU", FilledRecTxt)
        end
    else
        lcd.drawText(REC1_TXT_X, REC_TXT_Y, "LBT / EU", CENTER)
        lcd.drawRectangle(REC1_X, REC_Y, REC_W, REC_H, 0)
    end

    if mode == 1 then
        if LCD_W ~= 480 then
            lcd.drawText(REC2_TXT_X, REC_TXT_Y, "FCC", FilledRecTxt)
        end
        lcd.drawRectangle(REC2_X, REC_Y, REC_W, REC_H, 0);
        lcd.drawFilledRectangle(REC2_X+2, REC_Y+2, REC_W-4, REC_H-4, FilledRec)
        if LCD_W == 480 then
            lcd.drawText(REC2_TXT_X, REC_TXT_Y, "FCC", FilledRecTxt)
        end
    else
        lcd.drawText(REC2_TXT_X, REC_TXT_Y, "FCC", CENTER)
        lcd.drawRectangle(REC2_X, REC_Y, REC_W, REC_H, 0);
    end

    if mode == -1 then
        lcd.drawText(TXT_X, TXT_Y, "Lecture du mode...", CENTER)
    else
        if LCD_W ~= 128 then
            lcd.drawText(TXT_X, TXT_Y, "Verifier la legislation de votre pays!", CENTER)
        else
            lcd.drawText(TXT_X, TXT_Y, "Verif. legislation pays!", CENTER)
        end
    end
end

local function modeRead()
    return accessTelemetryPush(0, 0, 0x17, 0x30, 0x0C40, 0xA0AA5555)
end

local function modeWrite(value)
    if 0 == value then
        command = 0xA0AA5555
    else
        command = 0xA1AA5555
    end
    return accessTelemetryPush(0, 0, 0x17, 0x31, 0x0C40, command)
end


local function telemetryPop()
    physicalId, primId, dataId, value = sportTelemetryPop()
    if primId == 0x32 and dataId >= 0X0C40 and dataId <= 0X0C4F then
        mode = math.floor(value / 0x1000000) - 0xA0
    end
end

local function runPage(event)
    if event == EVT_VIRTUAL_EXIT then
        return 2
    elseif event == EVT_VIRTUAL_NEXT or event == EVT_VIRTUAL_PREV then
        local newmode
        if mode == 0 then
            newmode = 1
        else
            newmode = 0
        end
        mode = -1
        modeWrite(newmode)
    else
        if mode == -1 then
            modeRead()
        end
        telemetryPop()
    end
    redrawPage()
    return 0
end

-- Init
local function init()

    REC_H = LCD_H - 25
    REC_Y = 14
    TXT_Y = LCD_H - 8
    REC_TXT_Y = TXT_Y - REC_H/2 - 6
    FilledRec = GREY_DEFAULT
    FilledRecTxt = CENTER

    if LCD_W == 480 then
        REC_W = 150
        REC_H = 150
        REC_Y = 70
        REC_TXT_Y = REC_H/2 + REC_Y - 8
        TXT_Y = LCD_H - 20
        FilledRec = TITLE_BGCOLOR
        FilledRecTxt = FilledRecTxt + MENU_TITLE_COLOR
    elseif LCD_W == 212 then
        REC_W = 98
    else
        REC_W = 56
    end
  
    REC1_X = (LCD_W/2 - REC_W) / 2
    REC2_X = LCD_W/2 + REC1_X
 
    REC1_TXT_X = REC_W/2 + REC1_X
    REC2_TXT_X = REC_W/2 + REC2_X
 
    TXT_X = LCD_W/2

end

-- Run
local function run(event)
    if event == nil then
        error("Ce n'est pas un script modele !!")
        return 2
    end

    return runPage(event)
end

return { init=init, run=run }
