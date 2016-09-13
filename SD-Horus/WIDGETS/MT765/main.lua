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
  local pie = { zone=zone, options=options }
  return pie
end

local function update(pie, options)
  pie.options = options
end

local function background(pie)
end

function refresh(pie)
  --bitmap = lcd.loadBitmap("/IMAGES/MT765.jpg")
  --lcd.drawBitmap(60, 0, bitmap)

  -- Front outputs
  lcd.drawText(pie.zone.x, pie.zone.y, "SA", SMLSIZE+TEXT_COLOR)
  lcd.drawGauge(pie.zone.x+19, pie.zone.y+2, 30, 10, 100+(getValue('ch3')/10), 200, CURVE_COLOR)
  lcd.drawText(pie.zone.x, pie.zone.y+11, "SB", SMLSIZE+TEXT_COLOR)
  lcd.drawGauge(pie.zone.x+19, pie.zone.y+13, 30, 10, 100+(getValue('ch5')/10), 200, CURVE_COLOR)
  lcd.drawText(pie.zone.x, pie.zone.y+22, "S1", SMLSIZE+TEXT_COLOR)
  lcd.drawGauge(pie.zone.x+19, pie.zone.y+25, 30, 10, 100+(getValue('ch6')/10), 200, CURVE_COLOR)

  -- Front lif
  lcd.drawText(pie.zone.x, pie.zone.y+55, "SF", SMLSIZE)
  lcd.drawText(pie.zone.x+3, pie.zone.y+65, "+", SMLSIZE)
  lcd.drawText(pie.zone.x, pie.zone.y+75, "LS", SMLSIZE)
  drawVerticalGauge(pie.zone.x+19, pie.zone.y+103, 60, 10, 100+(getValue('ch7')/10), 200)

  -- Rear outputs
  lcd.drawText(pie.zone.x+450, pie.zone.y, "SC", SMLSIZE)
  lcd.drawGauge(pie.zone.x+406, pie.zone.y+2, 40, 10, 100+(getValue('ch11')/10), 200, CURVE_COLOR)
  lcd.drawText(pie.zone.x+450, pie.zone.y+11, "SD", SMLSIZE)
  lcd.drawGauge(pie.zone.x+406, pie.zone.y+13, 40, 10, 100+(getValue('ch12')/10), 200, CURVE_COLOR)
  lcd.drawText(pie.zone.x+450, pie.zone.y+22, "Vit", SMLSIZE)
  drawServo(pie.zone.x+406, pie.zone.y+25, 20, 10, getValue('ch13')/10, 100)
  lcd.drawText(pie.zone.x+341, pie.zone.y, "S2", SMLSIZE)
  lcd.drawGauge(pie.zone.x+364, pie.zone.y+2, 40, 10, 100+(getValue('ch14')/10), 200, CURVE_COLOR)
  lcd.drawText(pie.zone.x+341, pie.zone.y+11, "YDr", SMLSIZE)
  lcd.drawGauge(pie.zone.x+364, pie.zone.y+13, 40, 10, 100+(getValue('ch15')/10), 200, CURVE_COLOR)
  lcd.drawText(pie.zone.x+341, pie.zone.y+22, "SH", SMLSIZE)
  lcd.drawGauge(pie.zone.x+364, pie.zone.y+25, 40, 10, 100+(getValue('ch16')/10), 200, CURVE_COLOR)

  -- Rear lift
  lcd.drawText(pie.zone.x+450, pie.zone.y+55, "SE", SMLSIZE)
  lcd.drawText(pie.zone.x+453, pie.zone.y+65, "+", SMLSIZE)
  lcd.drawText(pie.zone.x+450, pie.zone.y+75, "RS", SMLSIZE)
  drawVerticalGauge(pie.zone.x+430, pie.zone.y+103, 60, 10, 100+(getValue('ch9')/10), 200)

  -- Power
  lcd.drawChannel(pie.zone.x+65, pie.zone.y+0, "C1", SMLSIZE)
  lcd.drawChannel(pie.zone.x+65, pie.zone.y+8, "C2", SMLSIZE)
  lcd.drawChannel(pie.zone.x+65, pie.zone.y+16, "C3", SMLSIZE)
  lcd.drawChannel(pie.zone.x+65, pie.zone.y+43, "Cels", DBLSIZE)

  lcd.drawChannel(pie.zone.x+72, pie.zone.y+0, "Curr", DBLSIZE)
  lcd.drawChannel(pie.zone.x+62, pie.zone.y+16, "Curr+", SMLSIZE)
  lcd.drawChannel(pie.zone.x+65, pie.zone.y+43, "VFAS", DBLSIZE)

  lcd.drawChannel(pie.zone.x+65, pie.zone.y+58, "BtRx", SMLSIZE)
  lcd.drawChannel(pie.zone.x+50, pie.zone.y+58, "tx-voltage", SMLSIZE)

  -- Speed
  drawServo(pie.zone.x+76, pie.zone.y+44, 28, 6, getValue('ch2')/10, 100)
  drawServo(pie.zone.x+76, pie.zone.y+51, 28, 6, getValue('ch1')/10, 100)
  lcd.drawText(pie.zone.x+90, pie.zone.y+58, "SG + YGa", SMLSIZE)
  drawVerticalGauge(pie.zone.x+134, pie.zone.y+63, 20, 6, 100+(getValue('sg')/10), 200)

  -- Various
  -- drawDate(32, 1)
  lcd.drawText(pie.zone.x+141, pie.zone.y+42, "SWR", SMLSIZE)
  lcd.drawText(pie.zone.x+141, pie.zone.y+49, "RssI", SMLSIZE)
  -- lcd.drawText(141, 56,"Ar", SMLSIZE)
  lcd.drawChannel(pie.zone.x+172, pie.zone.y+42, "SWR", SMLSIZE)
  lcd.drawChannel(pie.zone.x+172, pie.zone.y+49, "RSSI", SMLSIZE)
  local datenow = getDateTime()
  lcd.drawText(pie.zone.x+141, pie.zone.y+56, datenow.hour..":"..datenow.min..":"..datenow.sec, SMLSIZE)

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
