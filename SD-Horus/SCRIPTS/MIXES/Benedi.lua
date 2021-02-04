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
local P={}

P.input =
	{
		{ "sound-in", SOURCE,},
	}

P.output =
  {"to-play",
  }

-- periodically called function
P.run=function(sound)

    if sound < -900 then
       return -1024
    elseif sound < -820 then
       return -901
    elseif sound < -700 then
       return -778
    elseif sound < -580 then
       return -655
    elseif sound < -460 then
       return -532
    elseif sound < -340 then
       return -410
    elseif sound < -220 then
       return -287
    elseif sound < -100 then
       return -164
    elseif sound > 900 then
       return 1024
    elseif sound > 820 then
       return 901
    elseif sound > 700 then
       return 778
    elseif sound > 580 then
       return 655
    elseif sound > 460 then
       return 532
    elseif sound > 340 then
       return 410
    elseif sound > 220 then
       return 287
    elseif sound > 100 then
       return 164
    else
       return 0
    end
end

return P
