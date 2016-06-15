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

local function drawDate(x, y)
  local datenow = getDateTime()
  lcd.drawText(x,y,datenow.hour..":"..datenow.min..":"..datenow.sec,0)
  -- lcd.drawText(x,y+6,datenow.day.."/"..datenow.mon.."/"..datenow.year,0)
end

local function bgrnd_func()
  lcd.clear()

end

local function run(event)
  bgrnd_func()
  lcd.drawPixmap(60, 0, "/SCRIPTS/BMP/765.bmp")

  -- Front outputs
  lcd.drawText(2, 43, "SA", SMLSIZE)
  lcd.drawGauge(15, 43, 20, 6, 100+(getValue('ch3')/10), 200)
  lcd.drawText(2, 50, "SB", SMLSIZE)
  lcd.drawGauge(15, 50, 20, 6, 100+(getValue('ch5')/10), 200)
  lcd.drawText(2, 57, "S1", SMLSIZE)
  lcd.drawGauge(15, 57, 20, 6, 100+(getValue('ch6')/10), 200)

  -- Front lift
  lcd.drawText(2, 5, "SF", SMLSIZE)
  lcd.drawText(5, 12, "+", SMLSIZE)
  lcd.drawText(2, 19, "LS", SMLSIZE)
  drawVerticalGauge(15, 30, 29, 6, 100+(getValue('ch7')/10), 200)

  -- Rear outputs
  lcd.drawText(141, 43, "SC", SMLSIZE)
  lcd.drawGauge(154, 43, 20, 6, 100+(getValue('ch11')/10), 200)
  lcd.drawText(141, 50, "SD", SMLSIZE)
  lcd.drawGauge(154, 50, 20, 6, 100+(getValue('ch12')/10), 200)
  lcd.drawText(141, 57, "Vit", SMLSIZE)
  lcd.drawGauge(154, 57, 20, 6, 100+(getValue('ch13')/10), 200)
  lcd.drawText(200, 43, "S2", SMLSIZE)
  lcd.drawGauge(176, 43, 20, 6, 100+(getValue('ch14')/10), 200)
  lcd.drawText(200, 50, "YDr", SMLSIZE)
  lcd.drawGauge(176, 50, 20, 6, 100+(getValue('ch15')/10), 200)
  lcd.drawText(200, 57, "SH", SMLSIZE)
  lcd.drawGauge(176, 57, 20, 6, 100+(getValue('ch16')/10), 200)

  -- Rear lift
  lcd.drawText(200, 5, "SE", SMLSIZE)
  lcd.drawText(203, 12, "+", SMLSIZE)
  lcd.drawText(200, 19, "RS", SMLSIZE)
  drawVerticalGauge(191, 30, 29, 6, 100+(getValue('ch9')/10), 200)

  -- Power
	lcd.drawChannel(72, 43, "Curr", DBLSIZE)
	lcd.drawChannel(72, 58, "Curr+", SMLSIZE)
	lcd.drawChannel(130, 43, "VFAS", DBLSIZE)
	lcd.drawChannel(130, 58, "BtRx", SMLSIZE)
	lcd.drawChannel(110, 58, "tx-voltage", SMLSIZE)

  -- Speed
  drawVerticalGauge(78, 64, 22, 4, 100+(getValue('ch2')/10), 200)
  drawVerticalGauge(83, 64, 22, 4, 100+(getValue('ch1')/10), 200)

  -- Various
  drawDate(22, 1)

  -- linking lines
  lcd.drawLine(24, 20, 58, 20, SOLID, FORCE)
  lcd.drawLine(24, 41, 24, 22, SOLID, FORCE)
  lcd.drawLine(24, 22, 58, 22, SOLID, FORCE)

  lcd.drawLine(188, 20, 140, 20, SOLID, FORCE)
  lcd.drawLine(188, 41, 188, 22, SOLID, FORCE)
  lcd.drawLine(188, 22, 140, 22, SOLID, FORCE)
  lcd.drawLine(166, 41, 166, 24, SOLID, FORCE)
  lcd.drawLine(166, 24, 140, 24, SOLID, FORCE)
end

return { background=bgrnd_func, run=run }
