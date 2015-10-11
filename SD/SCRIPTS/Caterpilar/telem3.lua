-- Version 1.5
-- Telemetry screen telemX.lua is based on FrSky FAS-100 Current/Voltage/Consumption/Power Sensor
-- (rename it to telem1.lua if it should be displayed as your first telemetry panel)
-- Save the model script under \\SCRIPTS\modelname where modelname is the name of your model

-- It displays:
-- RSSI
-- Voltage (vFas), minimum voltage (vFas-min)
-- Consumption
-- Current and maximum current
-- Average current based on Consumption and Timer 1
-- Maximum power

-- ATTENTION: Needs to set Timer 1 in your Model Settings to "00:00" (count up), "THs" (run only
-- when Trottle is > -100) and "Not persistent".


local tmr1=0
local cnsp=0
local avg_current=0

local function bgrnd_func()
	-- Check and see if the Timer 1 is zeroed. If it is, let's zero the average.
	-- I use this so that I can re-do the average between flights (where I zero out Timer1).
	tmr1 = getValue(196)
	if tmr1 > 0 then
		cnsp = getValue(218)
		avg_current = (cnsp / 1000) * (3600 / tmr1) -- calculate avg. current based on consumption over time by Timer 1
	elseif tmr1 == 0 then
		avg_current = 0 -- set display to 0 when reset Timer 1
	end
end

local function run_func(event)
	bgrnd_func()

	-- Let's draw some values.
	lcd.drawChannel(205, 15, "vfas", XXLSIZE)
	lcd.drawText(141, 55, "MINIMUM", SMLSIZE)
	lcd.drawChannel(182, 54, "vfas-min", LEFT)

	lcd.drawText(5, 5, "CNSP", SMLSIZE)
	lcd.drawRectangle(3, 3, 88, 18)
	lcd.drawChannel(72, 4, "consumption", DBLSIZE)

	lcd.drawText(5, 25, "CUR", SMLSIZE)
	lcd.drawText(5, 33, "CUR+", SMLSIZE)
	lcd.drawRectangle(3, 23, 88, 18)
	lcd.drawChannel(84, 24, "current", DBLSIZE)
	lcd.drawChannel(43, 32, "current-max", SMLSIZE)

	lcd.drawText(5, 45, "CNSP/TMR1", SMLSIZE)
	lcd.drawText(5, 53, "POW+", SMLSIZE)
	lcd.drawRectangle(3, 43, 88, 18)
	lcd.drawNumber(84, 44, avg_current*10, DBLSIZE+PREC1) -- multiply by 10 because of using PREC1
	lcd.drawText(lcd.getLastPos(), 44, "A", 0)
	lcd.drawChannel(43, 52, "power-max", SMLSIZE)

	lcd.drawText(118, 4, "RSSI", SMLSIZE)
	lcd.drawNumber(143, 4, getValue(200), LEFT+SMLSIZE)
	lcd.drawText(lcd.getLastPos(), 4, "%", SMLSIZE)
	lcd.drawGauge(115, 2, 90, 11, getValue(200), 100)
end

return { background=bgrnd_func, run=run_func }
