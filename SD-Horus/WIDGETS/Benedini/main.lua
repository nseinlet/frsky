---- #########################################################################
---- #                                                                       #
---- # Copyright (C) Nicolas Seinlet                                         #
---- #                                                                       #
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
  { "soundsource", SOURCE, 1 },
  { "soundtrigger", SOURCE, 1 },
}

local function create(zone, options)
  local wgt  = { zone=zone, options=options}
  return wgt
end

local function update(wgt, options)
  wgt.options = options
end

local function background(wgt)
  return
end

function refresh(wgt)
   local val = getValue(wgt.options.soundsource);
   -- #100/88/76/64/52/40/28/16/0
   if getValue(wgt.options.soundtrigger) > 0 then
     lcd.setColor(TEXT_COLOR, RED)
   else
     lcd.setColor(TEXT_COLOR, BLACK)
   end
    if val < -900 then
       lcd.drawText(wgt.zone.x+5, wgt.zone.y+5, "Start", TEXT_COLOR+BOLD)
    elseif val < -820 then
       lcd.drawText(wgt.zone.x+5, wgt.zone.y+5, "Horn", TEXT_COLOR+BOLD)
    elseif val < -700 then
       lcd.drawText(wgt.zone.x+5, wgt.zone.y+5, "S3", TEXT_COLOR+BOLD)
    elseif val < -580 then
       lcd.drawText(wgt.zone.x+5, wgt.zone.y+5, "S4", TEXT_COLOR+BOLD)
    elseif val < -460 then
       lcd.drawText(wgt.zone.x+5, wgt.zone.y+5, "S5", TEXT_COLOR+BOLD)
    elseif val < -340 then
       lcd.drawText(wgt.zone.x+5, wgt.zone.y+5, "S6", TEXT_COLOR+BOLD)
    elseif val < -220 then
       lcd.drawText(wgt.zone.x+5, wgt.zone.y+5, "S7", TEXT_COLOR+BOLD)
    elseif val < -100 then
       lcd.drawText(wgt.zone.x+5, wgt.zone.y+5, "S8", TEXT_COLOR+BOLD)
    elseif val > 900 then
       lcd.drawText(wgt.zone.x+5, wgt.zone.y+5, "S17", TEXT_COLOR+BOLD)
    elseif val > 820 then
       lcd.drawText(wgt.zone.x+5, wgt.zone.y+5, "S16", TEXT_COLOR+BOLD)
    elseif val > 700 then
       lcd.drawText(wgt.zone.x+5, wgt.zone.y+5, "S15", TEXT_COLOR+BOLD)
    elseif val > 580 then
       lcd.drawText(wgt.zone.x+5, wgt.zone.y+5, "S14", TEXT_COLOR+BOLD)
    elseif val > 460 then
       lcd.drawText(wgt.zone.x+5, wgt.zone.y+5, "S13", TEXT_COLOR+BOLD)
    elseif val > 340 then
       lcd.drawText(wgt.zone.x+5, wgt.zone.y+5, "S12", TEXT_COLOR+BOLD)
    elseif val > 220 then
       lcd.drawText(wgt.zone.x+5, wgt.zone.y+5, "S11", TEXT_COLOR+BOLD)
    elseif val > 100 then
       lcd.drawText(wgt.zone.x+5, wgt.zone.y+5, "S10", TEXT_COLOR+BOLD)
    else
       lcd.drawText(wgt.zone.x+5, wgt.zone.y+5, "S9", TEXT_COLOR+BOLD)
    end
    lcd.setColor(TEXT_COLOR, BLACK)
end

return { name="Benedini", options=options, create=create, update=update, refresh=refresh, background=background }
