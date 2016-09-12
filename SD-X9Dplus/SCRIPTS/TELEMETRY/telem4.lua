local function run(event)

 if getValue(200) > 38 then

  local settings = getGeneralSettings()

  lcd.drawLine(48, -1, 48, 64, SOLID, GREY_DEFAULT)
  lcd.drawLine(106, -1, 106, 64, SOLID, GREY_DEFAULT)
  lcd.drawLine(163, -1, 163, 64, SOLID, GREY_DEFAULT)
  lcd.drawLine(48, 0, 105, 0, SOLID, GREY_DEFAULT)
  lcd.drawLine(48, 21, 105, 21, SOLID, GREY_DEFAULT)
  lcd.drawLine(48, 42, 105, 42, SOLID, GREY_DEFAULT)
  lcd.drawLine(48, 63, 105, 63, SOLID, GREY_DEFAULT)
  lcd.drawLine(106, 0, 162, 0, SOLID, GREY_DEFAULT)
  lcd.drawLine(106, 21, 162, 21, SOLID, GREY_DEFAULT)
  lcd.drawLine(106, 42, 162, 42, SOLID, GREY_DEFAULT)
  lcd.drawLine(106, 63, 162, 63, SOLID, GREY_DEFAULT)

  local percent = (getValue("203")-9.3) / 0.033

  if percent > 90 then
   lcd.drawPixmap(7, 1, "/SCRIPTS/BMP/bat11.bmp")
  else
   if percent > 80 then
    lcd.drawPixmap(7, 1, "/SCRIPTS/BMP/bat10.bmp")
   else
    if percent > 70 then
     lcd.drawPixmap(7, 1, "/SCRIPTS/BMP/bat09.bmp")
    else
     if percent > 60 then
      lcd.drawPixmap(7, 1, "/SCRIPTS/BMP/bat08.bmp")
     else
      if percent > 50 then
       lcd.drawPixmap(7, 1, "/SCRIPTS/BMP/bat07.bmp")
      else
       if percent > 40 then
        lcd.drawPixmap(7, 1, "/SCRIPTS/BMP/bat06.bmp")
       else
        if percent > 30 then
         lcd.drawPixmap(7, 1, "/SCRIPTS/BMP/bat05.bmp")
        else
         if percent > 20 then
          lcd.drawPixmap(7, 1, "/SCRIPTS/BMP/bat04.bmp")
         else
          if percent > 10 then
           lcd.drawPixmap(7, 1, "/SCRIPTS/BMP/bat03.bmp")
          else
           if percent > 0 then
            lcd.drawPixmap(7, 1, "/SCRIPTS/BMP/bat02.bmp")
           else
            lcd.drawPixmap(7, 1, "/SCRIPTS/BMP/bat01.bmp")
           end
          end
         end
        end
       end
      end
     end
    end
   end
  end

  lcd.drawChannel(11, 55, 203, LEFT)

  lcd.drawPixmap(52, 3, "/SCRIPTS/BMP/fm.bmp")
  if getValue(94) > 0 and getValue(97) < 0 then
   lcd.drawText(72, 5, "Man", MIDSIZE)
  else 
   if getValue(94) == 0 and getValue(97) < 0 then
    lcd.drawText(72, 5, "Atti", MIDSIZE)
   else
    if getValue(94) < 0 and getValue(97) < 0 then
     lcd.drawText(72, 5, "GPS", MIDSIZE)
    else
     lcd.drawText(72, 5, "RTH", MIDSIZE)
    end
   end
  end

  local percent = (getValue("tx-voltage")-settings.battMin) * 100 / (settings.battMax-settings.battMin)

  lcd.drawRectangle(52, 28, 15, 8)
  lcd.drawFilledRectangle(53, 29, 13, 6, GREY_DEFAULT)
  lcd.drawLine(67, 29, 67, 33, SOLID, 0)
  if(percent > 14) then lcd.drawLine(54, 29, 54, 33, SOLID, 0) end
  if(percent > 29) then lcd.drawLine(56, 29, 56, 33, SOLID, 0) end
  if(percent > 43) then lcd.drawLine(58, 29, 58, 33, SOLID, 0) end
  if(percent > 57) then lcd.drawLine(60, 29, 60, 33, SOLID, 0) end
  if(percent > 71) then lcd.drawLine(62, 29, 62, 33, SOLID, 0) end
  if(percent > 86) then lcd.drawLine(64, 29, 64, 33, SOLID, 0) end
  lcd.drawChannel(75, 26, "tx-voltage", LEFT+MIDSIZE)

  lcd.drawPixmap(52, 46, "/SCRIPTS/BMP/bec.bmp")
  lcd.drawChannel(75, 47, 202, LEFT+MIDSIZE)

  lcd.drawPixmap(110, 3, "/SCRIPTS/BMP/angle.bmp")
  local angle = (getValue(83)+1024)*90/2048
  lcd.drawNumber(130, 5, angle, LEFT+MIDSIZE)

  lcd.drawText(lcd.getLastPos(), 3, "o", SMLSIZE)

  lcd.drawPixmap(110, 24, "/SCRIPTS/BMP/timer.bmp")
  lcd.drawTimer(130, 26, getValue(196), LEFT+MIDSIZE)

  lcd.drawPixmap(110, 46, "/SCRIPTS/BMP/clock.bmp")
  lcd.drawTimer(130, 47, getValue(190), LEFT+MIDSIZE)

  if getValue(200) > 38 then
   percent = ((math.log(getValue(200)-28, 10)-1)/(math.log(72, 10)-1))*100
  else
   percent = 0
  end

  if percent > 90 then
   lcd.drawPixmap(164, 1, "/SCRIPTS/BMP/RSSI11.bmp")
  else
   if percent > 80 then
    lcd.drawPixmap(164, 1, "/SCRIPTS/BMP/RSSI10.bmp")
   else
    if percent > 70 then
     lcd.drawPixmap(164, 1, "/SCRIPTS/BMP/RSSI09.bmp")
    else
     if percent > 60 then
      lcd.drawPixmap(164, 1,  "/SCRIPTS/BMP/RSSI08.bmp")
     else
      if percent > 50 then
       lcd.drawPixmap(164, 1, "/SCRIPTS/BMP/RSSI07.bmp")
      else
       if percent > 40 then
        lcd.drawPixmap(164, 1, "/SCRIPTS/BMP/RSSI06.bmp")
       else
        if percent > 30 then
         lcd.drawPixmap(164, 1, "/SCRIPTS/BMP/RSSI05.bmp")
        else
         if percent > 20 then
          lcd.drawPixmap(164, 1, "/SCRIPTS/BMP/RSSI04.bmp")
         else
          if percent > 10 then
           lcd.drawPixmap(164, 1, "/SCRIPTS/BMP/RSSI03.bmp")
          else
           if percent > 0 then
            lcd.drawPixmap(164, 1, "/SCRIPTS/BMP/RSSI02.bmp")
           else
            lcd.drawPixmap(164, 1, "/SCRIPTS/BMP/RSSI01.bmp")
           end
          end
         end
        end
       end
      end
     end
    end
   end
  end

  lcd.drawChannel(178, 55, 200, LEFT)
  lcd.drawText(lcd.getLastPos(), 56, "dB", SMLSIZE)

 else

  lcd.drawText(15, 25, "Keine Verbindung...", BLINK+DBLSIZE)

 end

end

return { run=run }