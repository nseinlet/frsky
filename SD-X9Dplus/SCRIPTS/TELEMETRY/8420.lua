local function drawVerticalGauge(x, y, size, width, value, max)
  val = value
  if val<0 then
    val=0
  end
  if val>max then
    val=max
  end
  sz_filled = val*(size/max)
  sz_unfilled = size-sz_filled
  lcd.drawRectangle(x, y-size, width, sz_unfilled)
  lcd.drawFilledRectangle(x, y-sz_filled, width, sz_filled)
end

local function drawReverseGauge(x, y, size, width, value, max)
  val = value
  if val<0 then
    val=0
  end
  if val>max then
    val=max
  end
  sz_filled = val*(size/max)
  sz_unfilled = size-sz_filled
  lcd.drawRectangle(x-size, y-width, sz_unfilled, width)
  lcd.drawFilledRectangle(x-sz_filled, y-width, sz_filled, width)
end

local function drawServo(x, y, size, width, value, max)
  val = value
  if val<((-1)*max) then
    val=(-1)*max
  end
  if val>max then
    val=max
  end
  lcd.drawRectangle(x, y, size*2, width)
  if val>0 then
    sz_filled = val*(size/max)
    lcd.drawFilledRectangle(x+size-sz_filled, y, sz_filled, width)
  else
    if val<0 then
      sz_filled = (-1)*val*(size/max)
      lcd.drawFilledRectangle(x+size, y, sz_filled, width)
    else
      lcd.drawLine(x+size, y, x+size, y+width-1, SOLID, FORCE)
    end
  end
end

local function drawDate(x, y)
  local datenow = getDateTime()
  lcd.drawText(x,y,datenow.hour..":"..datenow.min..":"..datenow.sec,0)
  -- lcd.drawText(x,y+6,datenow.day.."/"..datenow.mon.."/"..datenow.year,0)
end

local function SecondsToClock(seconds)
  local seconds = tonumber(seconds)

  if seconds <= 0 then
    return "00:00:00";
  else
    hours = string.format("%02.f", math.floor(seconds/3600));
    mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
    secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
    return hours..":"..mins..":"..secs
  end
end

local function bgrnd_func()
  lcd.clear()

end

local function run(event)
  bgrnd_func()
  lcd.drawPixmap(65, 0, "/SCRIPTS/BMP/8420.bmp")

  -- Front outputs
  lcd.drawText(2, 1, "SA", SMLSIZE)
  lcd.drawGauge(15, 1, 20, 6, 100+(getValue('ch9')/10), 200)
  lcd.drawText(2, 8, "SB", SMLSIZE)
  lcd.drawGauge(15, 8, 20, 6, 100+(getValue('ch10')/10), 200)
  lcd.drawText(2, 15, "S1", SMLSIZE)
  lcd.drawGauge(15, 15, 20, 6, 100+(getValue('ch11')/10), 200)

  -- Front lift
  lcd.drawText(2, 38, "SF", SMLSIZE)
  lcd.drawText(5, 45, "+", SMLSIZE)
  lcd.drawText(2, 52, "LS", SMLSIZE)
  drawVerticalGauge(15, 63, 40, 6, 100+(getValue('ch12')/10), 200)

  -- Rear outputs
  lcd.drawText(200, 1, "S2", SMLSIZE)
  lcd.drawGauge(176, 1, 20, 6, 100+(getValue('ch6')/10), 200)
  lcd.drawText(200, 8, "SD", SMLSIZE)
  lcd.drawGauge(176, 8, 20, 6, 100+(getValue('ch7')/10), 200)
  lcd.drawText(200, 15, "Vit", SMLSIZE)
  drawServo(176, 15, 10, 6, getValue('ch8')/10, 100)

  -- Rear lift
  lcd.drawText(200, 38, "SE", SMLSIZE)
  lcd.drawText(202, 45, "+", SMLSIZE)
  lcd.drawText(200, 52, "RS", SMLSIZE)
  drawVerticalGauge(191, 63, 40, 6, 100+(getValue('ch1')/10), 200)

  -- Power
  lcd.drawChannel(35, 0, "C1", SMLSIZE)
  lcd.drawChannel(35, 8, "C2", SMLSIZE)
  lcd.drawChannel(35, 16, "C3", SMLSIZE)
  lcd.drawChannel(20, 43, "Cels", DBLSIZE)
  lcd.drawChannel(35, 58, "BtRx", SMLSIZE)
  lcd.drawChannel(20, 58, "tx-voltage", SMLSIZE)

  -- Speed
  drawServo(76, 44, 28, 6, getValue('ch2')/10, 100)
  drawServo(76, 51, 28, 6, getValue('ch3')/10, 100)
  lcd.drawText(90, 58, "SG + YGa", SMLSIZE)
  drawVerticalGauge(134, 63, 20, 6, 100+(getValue('sg')/10), 200)

  -- Various
  lcd.drawText(141, 42,"To", SMLSIZE)
  lcd.drawText(141, 49,"Av", SMLSIZE)
  lcd.drawText(141, 56,"Ar", SMLSIZE)
  lcd.drawText(152, 42,SecondsToClock(getValue('timer1')), SMLSIZE)
  lcd.drawText(152, 49,SecondsToClock(getValue('timer2')), SMLSIZE)
  lcd.drawText(152, 56,SecondsToClock(getValue('timer3')), SMLSIZE)

  -- linking lines
  -- (for servos)
  lcd.drawLine(188, 22, 188, 31, SOLID, FORCE)
  lcd.drawLine(188, 31, 140, 31, SOLID, FORCE)
  lcd.drawLine(188, 34, 140, 34, SOLID, FORCE)
  -- (for power)
  lcd.drawLine(72, 8, 78, 8, SOLID, FORCE)
  lcd.drawLine(78, 8, 78, 14, SOLID, FORCE)
  lcd.drawLine(65, 51, 74, 51, SOLID, FORCE)
  lcd.drawLine(74, 51, 74, 40, SOLID, FORCE)
end

return { background=bgrnd_func, run=run }
