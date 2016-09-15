---- #########################################################################
---- #                                                                       #
---- # Tractor monitoring Widget script for FrSky Horus                      #
---- # Copyright (C) OpenTX                                                  #
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
  { "Option1", SOURCE, 1 },
  { "Option2", VALUE, 1000 },
  { "Option3", COLOR, RED }
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
  lcd.drawRectangle(x, y-size, width, sz_unfilled, CURVE_COLOR, 1)
  lcd.drawFilledRectangle(x, y-sz_filled, width, sz_filled, CURVE_COLOR)
end

local function drawServo(x, y, size, width, value, max)
  local val = value
  if val<((-1)*max) then
    val=(-1)*max
  end
  if val>max then
    val=max
  end
  lcd.drawRectangle(x, y, size*2, width, CURVE_COLOR, 1)
  if val>0 then
    local sz_filled = val*(size/max)
    lcd.drawFilledRectangle(x+size-sz_filled, y, sz_filled, width, CURVE_COLOR)
  else
    if val<0 then
      local sz_filled = (-1)*val*(size/max)
      lcd.drawFilledRectangle(x+size, y, sz_filled, width, CURVE_COLOR)
    else
      lcd.drawLine(x+size, y, x+size, y+width-1, CURVE_COLOR, 1)
    end
  end
end

local function create(zone, options)
  local pie = { zone=zone, options=options, bitmap = Bitmap.open("/IMAGES/MT765.png") }
  return pie
end

local function update(pie, options)
  pie.options = options
end

local function background(pie)
end

function refresh(pie)
  lcd.drawBitmap(pie.bitmap, pie.zone.x+85, pie.zone.y-10, 100)

  -- Front outputs
  lcd.drawText(pie.zone.x, pie.zone.y, "SA", SMLSIZE+TEXT_COLOR)
  lcd.drawGauge(pie.zone.x+19, pie.zone.y+2, 30, 10, 100+(getValue('ch3')/10), 200, CURVE_COLOR)
  lcd.drawText(pie.zone.x, pie.zone.y+11, "SB", SMLSIZE+TEXT_COLOR)
  lcd.drawGauge(pie.zone.x+19, pie.zone.y+13, 30, 10, 100+(getValue('ch5')/10), 200, CURVE_COLOR)
  lcd.drawText(pie.zone.x, pie.zone.y+22, "S1", SMLSIZE+TEXT_COLOR)
  lcd.drawGauge(pie.zone.x+19, pie.zone.y+25, 30, 10, 100+(getValue('ch6')/10), 200, CURVE_COLOR)

  -- Front lif
  lcd.drawText(pie.zone.x, pie.zone.y+55, "SF", SMLSIZE+TEXT_COLOR)
  lcd.drawText(pie.zone.x+3, pie.zone.y+65, "+", SMLSIZE+TEXT_COLOR)
  lcd.drawText(pie.zone.x, pie.zone.y+75, "LS", SMLSIZE+TEXT_COLOR)
  drawVerticalGauge(pie.zone.x+19, pie.zone.y+103, 60, 10, 100+(getValue('ch7')/10), 200)

  -- Rear outputs
  lcd.drawText(pie.zone.x+pie.zone.w-20, pie.zone.y, "SC", SMLSIZE+TEXT_COLOR)
  lcd.drawGauge(pie.zone.x+pie.zone.w-64, pie.zone.y+2, 40, 10, 100+(getValue('ch11')/10), 200, CURVE_COLOR)
  lcd.drawText(pie.zone.x+pie.zone.w-20, pie.zone.y+11, "SD", SMLSIZE+TEXT_COLOR)
  lcd.drawGauge(pie.zone.x+pie.zone.w-64, pie.zone.y+13, 40, 10, 100+(getValue('ch12')/10), 200, CURVE_COLOR)
  lcd.drawText(pie.zone.x+pie.zone.w-20, pie.zone.y+22, "Vit", SMLSIZE+TEXT_COLOR)
  drawServo(pie.zone.x+pie.zone.w-64, pie.zone.y+25, 20, 10, getValue('ch13')/10, 100)
  lcd.drawText(pie.zone.x+pie.zone.w-132, pie.zone.y, "S2", SMLSIZE+TEXT_COLOR)
  lcd.drawGauge(pie.zone.x+pie.zone.w-106, pie.zone.y+2, 40, 10, 100+(getValue('ch14')/10), 200, CURVE_COLOR)
  lcd.drawText(pie.zone.x+pie.zone.w-132, pie.zone.y+11, "YDr", SMLSIZE+TEXT_COLOR)
  lcd.drawGauge(pie.zone.x+pie.zone.w-106, pie.zone.y+13, 40, 10, 100+(getValue('ch15')/10), 200, CURVE_COLOR)
  lcd.drawText(pie.zone.x+pie.zone.w-132, pie.zone.y+22, "SH", SMLSIZE+TEXT_COLOR)
  lcd.drawGauge(pie.zone.x+pie.zone.w-106, pie.zone.y+25, 40, 10, 100+(getValue('ch16')/10), 200, CURVE_COLOR)

  -- Rear lift
  lcd.drawText(pie.zone.x+pie.zone.w-20, pie.zone.y+55, "SE", SMLSIZE+TEXT_COLOR)
  lcd.drawText(pie.zone.x+pie.zone.w-17, pie.zone.y+65, "+", SMLSIZE+TEXT_COLOR)
  lcd.drawText(pie.zone.x+pie.zone.w-20, pie.zone.y+75, "RS", SMLSIZE+TEXT_COLOR)
  drawVerticalGauge(pie.zone.x+pie.zone.w-39, pie.zone.y+103, 60, 10, 100+(getValue('ch9')/10), 200)

  -- Power
  lcd.drawChannel(pie.zone.x+65, pie.zone.y+0, "C1", SMLSIZE+TEXT_COLOR)
  lcd.drawChannel(pie.zone.x+65, pie.zone.y+8, "C2", SMLSIZE+TEXT_COLOR)
  lcd.drawChannel(pie.zone.x+65, pie.zone.y+16, "C3", SMLSIZE+TEXT_COLOR)
  lcd.drawChannel(pie.zone.x, pie.zone.y+pie.zone.h-30, "Cels", DBLSIZE+TEXT_COLOR)

  lcd.drawChannel(pie.zone.x+55, pie.zone.y-5, "VFAS", DBLSIZE+TEXT_COLOR)
  lcd.drawChannel(pie.zone.x+55, pie.zone.y+20, "Curr", DBLSIZE+TEXT_COLOR)
  lcd.drawChannel(pie.zone.x+55, pie.zone.y+47, "Curr+", SMLSIZE+TEXT_COLOR)

  lcd.drawChannel(pie.zone.x+65, pie.zone.y+58, "BtRx", SMLSIZE+TEXT_COLOR)
  lcd.drawChannel(pie.zone.x+50, pie.zone.y+58, "tx-voltage", SMLSIZE+TEXT_COLOR)

  -- Speed
  drawServo(pie.zone.x+pie.zone.w-118, pie.zone.y+pie.zone.h-34, 40, 10, getValue('ch2')/10, 100)
  drawServo(pie.zone.x+pie.zone.w-118, pie.zone.y+pie.zone.h-22, 40, 10, getValue('ch1')/10, 100)
  lcd.drawText(pie.zone.x+pie.zone.w-20, pie.zone.y+pie.zone.h-20, "SC", SMLSIZE+TEXT_COLOR)
  drawVerticalGauge(pie.zone.x+pie.zone.w-32, pie.zone.y+pie.zone.h, 46, 10, 100+(getValue('s5')/10), 200)

  -- -- Various
  -- -- drawDate(32, 1)
  lcd.drawText(pie.zone.x+30, pie.zone.y+56, "SWR", SMLSIZE+TEXT_COLOR)
  lcd.drawText(pie.zone.x+30, pie.zone.y+67, "RssI", SMLSIZE+TEXT_COLOR)
  -- lcd.drawText(141, 56,"Ar", SMLSIZE)
  lcd.drawChannel(pie.zone.x+64, pie.zone.y+56, "SWR", SMLSIZE+TEXT_COLOR)
  lcd.drawChannel(pie.zone.x+64, pie.zone.y+67, "RSSI", SMLSIZE+TEXT_COLOR)

  -- -- linking lines
  -- -- (for servos)
  -- lcd.drawLine(pie.zone.x+24, pie.zone.y+21, pie.zone.x+24, pie.zone.y+31, SOLID, LINE_COLOR)
  -- lcd.drawLine(pie.zone.x+24, pie.zone.y+31, pie.zone.x+58, pie.zone.y+31, SOLID, LINE_COLOR)
  -- lcd.drawLine(pie.zone.x+24, pie.zone.y+34, pie.zone.x+58, pie.zone.y+34, SOLID, LINE_COLOR)
  -- lcd.drawLine(pie.zone.x+164, pie.zone.y+22, pie.zone.x+164, pie.zone.y+28, SOLID, LINE_COLOR)
  -- lcd.drawLine(pie.zone.x+164, pie.zone.y+28, pie.zone.x+140, pie.zone.y+28, SOLID, LINE_COLOR)
  -- lcd.drawLine(pie.zone.x+188, pie.zone.y+22, pie.zone.x+188, pie.zone.y+31, SOLID, LINE_COLOR)
  -- lcd.drawLine(pie.zone.x+188, pie.zone.y+31, pie.zone.x+140, pie.zone.y+31, SOLID, LINE_COLOR)
  -- lcd.drawLine(pie.zone.x+188, pie.zone.y+34, pie.zone.x+140, pie.zone.y+34, SOLID, LINE_COLOR)
  -- -- (for power)
  -- lcd.drawLine(pie.zone.x+72, pie.zone.y+8, pie.zone.x+78, pie.zone.y+8, SOLID, LINE_COLOR)
  -- lcd.drawLine(pie.zone.x+78, pie.zone.y+8, pie.zone.x+78, pie.zone.y+14, SOLID, LINE_COLOR)
  -- lcd.drawLine(pie.zone.x+65, pie.zone.y+51, pie.zone.x+74, pie.zone.y+51, SOLID, LINE_COLOR)
  -- lcd.drawLine(pie.zone.x+74, pie.zone.y+51, pie.zone.x+74, pie.zone.y+40, SOLID, LINE_COLOR)
end

return { name="MT765", options=options, create=create, update=update, refresh=refresh, background=background }
