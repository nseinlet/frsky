---- #########################################################################
---- #                                                                       #
---- # Tractor monitoring Widget script for FrSky Horus                      #
---- # Copyright (C) Nicolas Seinlet                                         #
-----#                                                                       #
---- # License GPLv2: http://www.gnu.org/licenses/gpl-2.0.html               #
---- #                                                                       #
---- # This program is free software; you can redistribute it and/or modify  #
---- # it under the terms of the GNU General Public License version 2 as     #
---- # published by the Free Software Foundation.                            #
---- #                                                                       #
---- # This program is distributed in the hope that it will be useful        #
---- # but WITHOUT ANY WARRANTY; without even the implied warranty of        #
---- # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         #
---- # GNU General Public License for more details.                          #
---- #                                                                       #
---- #########################################################################

local options = {
  { "FrontLift", BOOL, 0 },
  { "FrontOutput", BOOL, 0 },
  { "FirstFrontChannel", VALUE, 12, 1, 24},
  { "FirstRearChannel", VALUE, 6, 1, 24},
}

local function drawVerticalGauge(x, y, size, width, value, max)
  local val = value
  if val<0 then
    val=0
  end
  if val>max then
    val=max
  end
  local sz_filled = val*(size/max)
  local sz_unfilled = size-sz_filled
  lcd.drawFilledRectangle(x, y-sz_filled, width, sz_filled, COLOR_THEME_SECONDARY1)
  lcd.drawRectangle(x, y-size, width, sz_unfilled, COLOR_THEME_PRIMARY2, 1)
end

local function drawServo(x, y, size, width, value, max)
  local val = value
  if val<((-1)*max) then
    val=(-1)*max
  end
  if val>max then
    val=max
  end
  lcd.drawRectangle(x, y, size*2, width, COLOR_THEME_PRIMARY2, 1)
  if val>0 then
    local sz_filled = val*(size/max)
    lcd.drawFilledRectangle(x+size-sz_filled, y, sz_filled, width, COLOR_THEME_SECONDARY1)
  else
    if val<0 then
      local sz_filled = (-1)*val*(size/max)
      lcd.drawFilledRectangle(x+size, y, sz_filled, width, COLOR_THEME_SECONDARY1)
    else
      lcd.drawLine(x+size, y, x+size, y+width-1, COLOR_THEME_SECONDARY1, 1)
    end
  end
end

local function create(zone, options)
  local pie = { zone=zone, options=options, bitmap = Bitmap.open("/IMAGES/" .. model.getInfo().bitmap) }
  return pie
end

local function update(pie, options)
  pie.options = options
end

local function background(pie)
end

function refresh(pie)
  -- lcd.setColor(CUSTOM_COLOR, lcd.RGB(0,102,0))
  -- lcd.setColor(CUSTOM_COLOR, WHITE)
  local TEXT_COLOR = COLOR_THEME_PRIMARY2
  lcd.drawBitmap(pie.bitmap, pie.zone.x+80, pie.zone.y+8, 100)

  -- Front outputs
  if pie.options.FrontOutput==1 then
    lcd.drawText(pie.zone.x, pie.zone.y, "SA", SMLSIZE+TEXT_COLOR)
    lcd.drawGauge(pie.zone.x+19, pie.zone.y+2, 30, 10, 100+(getValue('ch' .. pie.options.FirstFrontChannel)/10), 200, COLOR_THEME_SECONDARY1)
    lcd.drawText(pie.zone.x, pie.zone.y+11, "SB", SMLSIZE+TEXT_COLOR)
    lcd.drawGauge(pie.zone.x+19, pie.zone.y+13, 30, 10, 100+(getValue('ch' .. (pie.options.FirstFrontChannel+1))/10), 200, COLOR_THEME_SECONDARY1)
    lcd.drawText(pie.zone.x, pie.zone.y+22, "S1", SMLSIZE+TEXT_COLOR)
    lcd.drawGauge(pie.zone.x+19, pie.zone.y+25, 30, 10, 100+(getValue('ch' .. (pie.options.FirstFrontChannel+2))/10), 200, COLOR_THEME_SECONDARY1)
  end

  -- Front lif
  if pie.options.FrontLift==1 then
    lcd.drawText(pie.zone.x, pie.zone.y+75, "LS", SMLSIZE+TEXT_COLOR)
    drawVerticalGauge(pie.zone.x+19, pie.zone.y+103, 60, 10, 100+(getValue('ch4')/10), 200)
  end

  -- Rear outputs
  local rearOut = {pie.options.FirstRearChannel}
  for i=1,5 do
      rearOut[i+1] = pie.options.FirstRearChannel+i
      if rearOut[i+1]>=12 then rearOut[i+1] = rearOut[i+1] + 1 end
  end

  lcd.drawText(pie.zone.x+pie.zone.w-20, pie.zone.y, "SC", SMLSIZE+TEXT_COLOR)
  lcd.drawGauge(pie.zone.x+pie.zone.w-64, pie.zone.y+2, 40, 10, 100+(getValue('ch' .. rearOut[1])/10), 200, COLOR_THEME_SECONDARY1)
  lcd.drawText(pie.zone.x+pie.zone.w-20, pie.zone.y+11, "SD", SMLSIZE+TEXT_COLOR)
  lcd.drawGauge(pie.zone.x+pie.zone.w-64, pie.zone.y+13, 40, 10, 100+(getValue('ch' .. rearOut[2])/10), 200, COLOR_THEME_SECONDARY1)
  lcd.drawText(pie.zone.x+pie.zone.w-20, pie.zone.y+22, "Vit", SMLSIZE+TEXT_COLOR)
  drawServo(pie.zone.x+pie.zone.w-64, pie.zone.y+25, 20, 10, getValue('ch' .. rearOut[3])/10, 100)
  lcd.drawText(pie.zone.x+pie.zone.w-132, pie.zone.y, "S2", SMLSIZE+TEXT_COLOR)
  lcd.drawGauge(pie.zone.x+pie.zone.w-106, pie.zone.y+2, 40, 10, 100+(getValue('ch' .. rearOut[4])/10), 200, COLOR_THEME_SECONDARY1)
  lcd.drawText(pie.zone.x+pie.zone.w-132, pie.zone.y+11, "L1", SMLSIZE+TEXT_COLOR)
  lcd.drawGauge(pie.zone.x+pie.zone.w-106, pie.zone.y+13, 40, 10, 100+(getValue('ch' .. rearOut[5])/10), 200, COLOR_THEME_SECONDARY1)
  lcd.drawText(pie.zone.x+pie.zone.w-132, pie.zone.y+22, "L2", SMLSIZE+TEXT_COLOR)
  lcd.drawGauge(pie.zone.x+pie.zone.w-106, pie.zone.y+25, 40, 10, 100+(getValue('ch' .. rearOut[6])/10), 200, COLOR_THEME_SECONDARY1)

  -- Rear lift
  lcd.drawText(pie.zone.x+pie.zone.w-20, pie.zone.y+55, "SG", SMLSIZE+TEXT_COLOR)
  lcd.drawText(pie.zone.x+pie.zone.w-17, pie.zone.y+65, "+", SMLSIZE+TEXT_COLOR)
  lcd.drawText(pie.zone.x+pie.zone.w-20, pie.zone.y+65, "RS", SMLSIZE+TEXT_COLOR)
  drawVerticalGauge(pie.zone.x+pie.zone.w-39, pie.zone.y+103, 60, 10, 100+(getValue('ch1')/10), 200)

  -- Power
  if getValue("VFAS")>0 then
    -- Only available with VFAS 40A
    lcd.drawChannel(pie.zone.x+55, pie.zone.y-5, "VFAS", DBLSIZE+TEXT_COLOR)
    lcd.drawChannel(pie.zone.x+55, pie.zone.y+20, "Curr", DBLSIZE+TEXT_COLOR)
    lcd.drawText(pie.zone.x+30, pie.zone.y+47, "max", SMLSIZE+TEXT_COLOR)
    lcd.drawChannel(pie.zone.x+65, pie.zone.y+47, "Curr+", SMLSIZE+TEXT_COLOR)
  end
  lcd.drawText(pie.zone.x+30, pie.zone.y+58, "RssI", SMLSIZE+TEXT_COLOR)
  lcd.drawChannel(pie.zone.x+65, pie.zone.y+58, "RSSI", SMLSIZE+TEXT_COLOR+BOLD)
  lcd.drawText(pie.zone.x+30, pie.zone.y+69, "RxBt", SMLSIZE+TEXT_COLOR)
  lcd.drawChannel(pie.zone.x+65, pie.zone.y+69, "RxBt", SMLSIZE+MENU_TITLE_BGCOLOR+BOLD)

  if getValue("C1")>0 then
      -- Only available with FLVSS or any other compatible sensor
    lcd.drawText(pie.zone.x, pie.zone.y+pie.zone.h-60, "1:", SMLSIZE+TEXT_COLOR)
    lcd.drawChannel(pie.zone.x+16, pie.zone.y+pie.zone.h-60, "C1", SMLSIZE+TEXT_COLOR)
    lcd.drawText(pie.zone.x+57, pie.zone.y+pie.zone.h-60, "2:", SMLSIZE+TEXT_COLOR)
    lcd.drawChannel(pie.zone.x+73, pie.zone.y+pie.zone.h-60, "C2", SMLSIZE+TEXT_COLOR)
    -- Crappy way of checking batt cells count
    if getValue("C3")>0 then
      lcd.drawText(pie.zone.x, pie.zone.y+pie.zone.h-49, "3:", SMLSIZE+TEXT_COLOR)
      lcd.drawChannel(pie.zone.x+16, pie.zone.y+pie.zone.h-49, "C3", SMLSIZE+TEXT_COLOR)
    end
    if getValue("C4")>0 then
      lcd.drawText(pie.zone.x+57, pie.zone.y+pie.zone.h-49, "4:", SMLSIZE+TEXT_COLOR)
      lcd.drawChannel(pie.zone.x+73, pie.zone.y+pie.zone.h-49, "C4", SMLSIZE+TEXT_COLOR)
    end
    lcd.drawText(pie.zone.x, pie.zone.y+pie.zone.h-38, "m:", SMLSIZE+TEXT_COLOR)
    lcd.drawChannel(pie.zone.x+16, pie.zone.y+pie.zone.h-38, "CMin", SMLSIZE+TEXT_COLOR+BOLD)
    lcd.drawText(pie.zone.x+57, pie.zone.y+pie.zone.h-38, "M:", SMLSIZE+TEXT_COLOR)
    lcd.drawChannel(pie.zone.x+73, pie.zone.y+pie.zone.h-38, "CMax", SMLSIZE+TEXT_COLOR+BOLD)
    lcd.drawChannel(pie.zone.x, pie.zone.y+pie.zone.h-30, "Cels", DBLSIZE+TEXT_COLOR)
  end

  -- Speed
  drawServo(pie.zone.x+pie.zone.w-118, pie.zone.y+pie.zone.h-34, 40, 10, getValue('ch2')/10, 100)
  lcd.drawText(pie.zone.x+pie.zone.w-20, pie.zone.y+pie.zone.h-38, "6P", SMLSIZE+TEXT_COLOR)
  if getFlightMode()==1 then
    lcd.drawText(pie.zone.x+pie.zone.w-20, pie.zone.y+pie.zone.h-26, "SE", SMLSIZE+TEXT_COLOR)
  end
  drawServo(pie.zone.x+pie.zone.w-118, pie.zone.y+pie.zone.h-22, 40, 10, getValue('ch3')/10, 100)
  drawServo(pie.zone.x+pie.zone.w-118, pie.zone.y+pie.zone.h-12, 40, 10, getValue('ch32')/10, 100)
  drawVerticalGauge(pie.zone.x+pie.zone.w-32, pie.zone.y+pie.zone.h-11, 23, 10, 100+(getValue('6P')/10), 200)
  if getFlightMode()==0 then
    lcd.drawText(pie.zone.x+pie.zone.w-118, pie.zone.y+pie.zone.h-12, "SE = sound", SMLSIZE+TEXT_COLOR)
  end
  if getFlightMode()==1 then
    lcd.drawText(pie.zone.x+pie.zone.w-118, pie.zone.y+pie.zone.h-12, "SE = Av/Ar", SMLSIZE+COLOR_THEME_SECONDARY1+BOLD)
  end
  lcd.drawText(pie.zone.x+120, pie.zone.y+pie.zone.h-12, "SF = Mode", TEXT_COLOR+BOLD)

  -- Various
  local rectx = pie.zone.x+240
  local recty = pie.zone.y+40
  local xsize = 45
  local ysize = 16

  lcd.drawRectangle(rectx, recty, xsize, ysize, COLOR_THEME_SECONDARY1, 1)
  lcd.drawText(rectx+1, recty, "L Wa", SMLSIZE+TEXT_COLOR)
  lcd.drawRectangle(rectx, recty+ysize, xsize, ysize, COLOR_THEME_SECONDARY1, 1)
  lcd.drawText(rectx+1, recty+ysize, "A Li", SMLSIZE+TEXT_COLOR)
  lcd.drawRectangle(rectx, recty+(2*ysize), xsize, ysize, COLOR_THEME_SECONDARY1, 1)
  lcd.drawText(rectx+1, recty+(2*ysize), "Li", SMLSIZE+TEXT_COLOR)
  lcd.drawRectangle(rectx, recty+(3*ysize), xsize, ysize, COLOR_THEME_SECONDARY1, 1)
  lcd.drawText(rectx+1, recty+(3*ysize), "HLi", SMLSIZE+TEXT_COLOR)

  lcd.drawText(rectx+xsize, recty, "1", SMLSIZE+COLOR_THEME_SECONDARY1)
  lcd.drawText(rectx+xsize, recty+ysize, "2", SMLSIZE+COLOR_THEME_SECONDARY1)
  lcd.drawText(rectx+xsize, recty+(2*ysize), "3", SMLSIZE+COLOR_THEME_SECONDARY1)
  lcd.drawText(rectx+xsize, recty+(3*ysize), "4", SMLSIZE+COLOR_THEME_SECONDARY1)

  lcd.drawRectangle(rectx+8+xsize, recty, xsize, ysize, COLOR_THEME_SECONDARY1, 1)
  lcd.drawText(rectx+9+xsize, recty, "R Wa", SMLSIZE+TEXT_COLOR)
  lcd.drawRectangle(rectx+8+xsize, recty+ysize, xsize, ysize, COLOR_THEME_SECONDARY1, 1)
  lcd.drawText(rectx+9+xsize, recty+ysize, "4 Wa", SMLSIZE+TEXT_COLOR)
  lcd.drawRectangle(rectx+8+xsize, recty+(2*ysize), xsize, ysize, COLOR_THEME_SECONDARY1, 1)
  lcd.drawText(rectx+9+xsize, recty+(2*ysize), "Turn L", SMLSIZE+TEXT_COLOR)
end

return { name="MT665", options=options, create=create, update=update, refresh=refresh, background=background }
