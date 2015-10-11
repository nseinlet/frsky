local function run(event)
  lcd.drawNumber(210, 10, getValue("altitude"), XXLSIZE)
  lcd.drawText(150, 54, "MAX", 0)
  lcd.drawChannel(172, 54, "altitude-max", LEFT)
  local timer = model.getTimer(0)
  lcd.drawTimer(2, 1, timer.value, MIDSIZE)
  lcd.drawRectangle(0, 0, 34, 14)
  timer = model.getTimer(1)
  lcd.drawTimer(40, 1, timer.value, MIDSIZE)
  lcd.drawRectangle(38, 0, 34, 14)
  lcd.drawChannel(11, 29, "tx-voltage", LEFT+MIDSIZE)
  local settings = getGeneralSettings()
  local percent = (getValue("tx-voltage")-settings.battMin) * 100 / (settings.battMax-settings.battMin)
  lcd.drawNumber(35, 45, percent, LEFT+MIDSIZE)
  lcd.drawText(lcd.getLastPos(), 45, "%", MIDSIZE)
  lcd.drawGauge(5, 42, 88, 18, percent, 100)
end

return { run=run }