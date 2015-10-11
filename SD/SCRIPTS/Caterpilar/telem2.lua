-- Version 2.0
-- Telemetry screen telemX.lua is based on FrSky FAS-100 Current/Voltage/Consumption/Power Sensor
-- (rename it to telem1.lua if it should be displayed as your first telemetry panel)
-- Save the model script under \\SCRIPTS\modelname where modelname is the name of your model

-- It displays:
-- RSSI
-- Voltage (vFas), minimum voltage (vFas-min)
-- Consumption
-- Current and maximum current
-- Average current based on averaging current samples
-- Maximum power

-- ATTENTION: Needs to set Timer 1 in your Model Settings to "00:00" (count up), "THs" (run only
-- when Trottle is > -100) and "Not persistent".

local samptot=0
local sampcount=0
local tmr1=0
local avg_current=0


local function bgrnd_func()
	-- Check and see if the Timer 1 is zeroed. If it is, let's zero the average.
	-- I use this so that I can re-do the average between flights (where I zero out Timer1).
	tmr1 = getValue(196)
	if tmr1 == 0 then
		samptot=0
		sampcount=0
		avg_current = 0
	else
		-- Don't start averaging until the throttle is moved up
		if getValue(1)/10.24 > -95 then
			local current=0
			current = getValue(217)
			samptot=samptot+current
			sampcount=sampcount+1
			avg_current = samptot/sampcount
		end
	end

end

local function run_func(event)
	bgrnd_func()

	-- Let's draw some values
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

	lcd.drawText(5, 45, "CUR(/)", SMLSIZE)
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
