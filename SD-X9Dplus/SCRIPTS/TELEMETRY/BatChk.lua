
---- ###############################################################
---- #                                                             #
---- #        Telemetry Lua Script for FrSky RC Taranis TX         #
---- #     LI-xx BATTCHECK v3.31 // Use it with OpenTX 2.1.7       #
---- #      Version avec table de décharge ACCU LIPO               #
---- #                                                             #
---- #                                                             #
---- #  License: Share alike                                       #
---- #  Can be used and changed non commercial                     #
---- #                                                             #
---- #  Developped by Heisenberg.                                  #
---- #  Debugged by Sacre100 (the hardest job) who succeeded       #
---- #  decreasing GC and memory use for Taranis compatibility.    #
---- #  Improved by Dev.Fred to get correct percent li-po values   #
---- #                                                             #
---- #  Credits to Dev.Fred, Kilrah, and some of other members     #
---- #  from the french forum frskytaranis.forumactif.org/         #
---- #  And especially more to Sacre100 for his patience and       #
---- #  knowledge shares.                                          #
---- #                                                             #
---- ###############################################################

---- ###############################################################
---- ################ Changer si nécessaire FR ou EN ###############
---- ################ Choose your language FR or EN  ###############
---- ###############################################################

local language = "FR"    --## (FR or EN) Nothing else


---- ###############################################################
---- ################  NE RIEN MODIFIER CI-DESSOUS  ################
---- ################ DO NOT CHANGE ANYTHING BELOW  ################
---- ###############################################################

---- ###############################################################
---- Variables
---- ###############################################################
local cellfull, cellempty = 4.2, 3.00                                      --## Cellule Li-Po considérée pleine et vide sans charge appliquée.

local voltageword, averageword = "VOLTAGE", "AVERAGE"
if language ~= "EN" then
  voltageword, averageword = "TENSION", "MOYENNE"
end

local cell = {0, 0, 0, 0, 0 ,0}                                                  --## Table des 6 éléments initialisés à 0
local cellminima = {cellfull, cellfull, cellfull, cellfull, cellfull, cellfull}  --## Table des 6 minimas initialisés au maxima (en V)
local cellmaxima = {0, 0, 0, 0, 0 ,0}                                            --## Table des 6 maximas initialisés à 0
local cellsumfull, cellsumempty, cellsumtype, cellsum = 0, 0, 0, 0               --## Déclarations & inits simples
local echX, ech100Y, ech0Y = 155, 2, 61                                          --## Position des axes X & Y de l'échelle de jauges
local echH = (ech0Y-ech100Y)                                                     --## Longueur de l'axe Y
local gaugeW, gaugeGap = 8, 1                                                    --## Largeur des jauges de cells et espacements
local i, cellmin, cellmax, cellresult = 0, cellfull, 0, 0                        --## Déclarations & inits simples
local version = "3.30"                                                           --## Version du script
local cellsumpercent, precision, blink = 0, 0, 0                                 --## Déclarations & inits simples
local cellsumpercentminima, cellsumpercentmaxima = 100, 0                        --## En %
local percentDelta                                                               --## Déclaration simples
local positions = {{3,36}, {3, 46}, {3, 56}, {44,36}, {44, 46}, {44, 56}}        --## Positionnement des icônes cels

local myArrayPercentList =                                                       --## Tableau de decharge LIPO
--{{3.000, 0}, {3.053, 1}, {3.113, 2}, {3.174, 3}, {3.237, 4}, {3.300, 5}, {3.364, 6}, {3.427, 7}, {3.488, 8}, {3.547, 9}, {3.600, 10}, {3.621, 11}, {3.637, 12}, {3.649, 13}, {3.659, 14}, {3.668, 15}, {3.676, 16}, {3.683, 17}, {3.689, 18}, {3.695, 19}, {3.700, 20}, {3.706, 21}, {3.712, 22}, {3.717, 23}, {3.723, 24}, {3.728, 25}, {3.732, 26}, {3.737, 27}, {3.741, 28}, {3.746, 29}, {3.750, 30}, {3.754, 31}, {3.759, 32}, {3.763, 33}, {3.767, 34}, {3.771, 35}, {3.775, 36}, {3.779, 37}, {3.782, 38}, {3.786, 39}, {3.790, 40}, {3.794, 41}, {3.798, 42}, {3.802, 43}, {3.806, 44}, {3.810, 45}, {3.814, 46}, {3.818, 47}, {3.822, 48}, {3.826, 49}, {3.830, 50}, {3.834, 51}, {3.838, 52}, {3.842, 53}, {3.846, 54}, {3.850, 55}, {3.854, 56}, {3.858, 57}, {3.862, 58}, {3.866, 59}, {3.870, 60}, {3.875, 61}, {3.880, 62}, {3.885, 63}, {3.890, 64}, {3.895, 65}, {3.900, 66}, {3.905, 67}, {3.910, 68}, {3.915, 69}, {3.920, 70}, {3.924, 71}, {3.929, 72}, {3.933, 73}, {3.938, 74}, {3.942, 75}, {3.947, 76}, {3.952, 77}, {3.958, 78}, {3.963, 79}, {3.970, 80}, {3.982, 81}, {3.994, 82}, {4.007, 83}, {4.020, 84}, {4.033, 85}, {4.047, 86}, {4.060, 87}, {4.074, 88}, {4.087, 89}, {4.100, 90}, {4.111, 91}, {4.122, 92}, {4.132, 93}, {4.143, 94}, {4.153, 95}, {4.163, 96}, {4.173, 97}, {4.182, 98}, {4.191, 99}, {4.200, 100}} --## Table standard (Empirique & théorique)
--{{2.8, 0}, {2.942, 1}, {3.1, 2}, {3.258, 3}, {3.401, 4}, {3.485, 5}, {3.549, 6}, {3.601, 7}, {3.637, 8}, {3.664, 9}, {3.679, 10}, {3.683, 11}, {3.689, 12}, {3.692, 13}, {3.705, 14}, {3.71, 15}, {3.713, 16}, {3.715, 17}, {3.72, 18}, {3.731, 19}, {3.735, 20}, {3.744, 21}, {3.753, 22}, {3.756, 23}, {3.758, 24}, {3.762, 25}, {3.767, 26}, {3.774, 27}, {3.78, 28}, {3.783, 29}, {3.786, 30}, {3.789, 31}, {3.794, 32}, {3.797, 33}, {3.8, 34}, {3.802, 35}, {3.805, 36}, {3.808, 37}, {3.811, 38}, {3.815, 39}, {3.818, 40}, {3.822, 41}, {3.826, 42}, {3.829, 43}, {3.833, 44}, {3.837, 45}, {3.84, 46}, {3.844, 47}, {3.847, 48}, {3.85, 49}, {3.854, 50}, {3.857, 51}, {3.86, 52}, {3.863, 53}, {3.866, 54}, {3.87, 55}, {3.874, 56}, {3.879, 57}, {3.888, 58}, {3.893, 59}, {3.897, 60}, {3.902, 61}, {3.906, 62}, {3.911, 63}, {3.918, 64}, {3.923, 65}, {3.928, 66}, {3.939, 67}, {3.943, 68}, {3.949, 69}, {3.955, 70}, {3.961, 71}, {3.968, 72}, {3.974, 73}, {3.981, 74}, {3.987, 75}, {3.994, 76}, {4.001, 77}, {4.008, 78}, {4.014, 79}, {4.021, 80}, {4.029, 81}, {4.036, 82}, {4.044, 83}, {4.052, 84}, {4.062, 85}, {4.074, 86}, {4.085, 87}, {4.095, 88}, {4.105, 89}, {4.111, 90}, {4.116, 91}, {4.12, 92}, {4.125, 93}, {4.129, 94}, {4.135, 95}, {4.145, 96}, {4.176, 97}, {4.179, 98}, {4.193, 99}, {4.2, 100}}                 --## Table Robbe originale fiable (Départ à 2.8V
{{3, 0}, {3.093, 1}, {3.196, 2}, {3.301, 3}, {3.401, 4}, {3.477, 5}, {3.544, 6}, {3.601, 7}, {3.637, 8}, {3.664, 9}, {3.679, 10}, {3.683, 11}, {3.689, 12}, {3.692, 13}, {3.705, 14}, {3.71, 15}, {3.713, 16}, {3.715, 17}, {3.72, 18}, {3.731, 19}, {3.735, 20}, {3.744, 21}, {3.753, 22}, {3.756, 23}, {3.758, 24}, {3.762, 25}, {3.767, 26}, {3.774, 27}, {3.78, 28}, {3.783, 29}, {3.786, 30}, {3.789, 31}, {3.794, 32}, {3.797, 33}, {3.8, 34}, {3.802, 35}, {3.805, 36}, {3.808, 37}, {3.811, 38}, {3.815, 39}, {3.818, 40}, {3.822, 41}, {3.825, 42}, {3.829, 43}, {3.833, 44}, {3.836, 45}, {3.84, 46}, {3.843, 47}, {3.847, 48}, {3.85, 49}, {3.854, 50}, {3.857, 51}, {3.86, 52}, {3.863, 53}, {3.866, 54}, {3.87, 55}, {3.874, 56}, {3.879, 57}, {3.888, 58}, {3.893, 59}, {3.897, 60}, {3.902, 61}, {3.906, 62}, {3.911, 63}, {3.918, 64}, {3.923, 65}, {3.928, 66}, {3.939, 67}, {3.943, 68}, {3.949, 69}, {3.955, 70}, {3.961, 71}, {3.968, 72}, {3.974, 73}, {3.981, 74}, {3.987, 75}, {3.994, 76}, {4.001, 77}, {4.007, 78}, {4.014, 79}, {4.021, 80}, {4.029, 81}, {4.036, 82}, {4.044, 83}, {4.052, 84}, {4.062, 85}, {4.074, 86}, {4.085, 87}, {4.095, 88}, {4.105, 89}, {4.111, 90}, {4.116, 91}, {4.12, 92}, {4.125, 93}, {4.129, 94}, {4.135, 95}, {4.145, 96}, {4.176, 97}, {4.179, 98}, {4.193, 99}, {4.2, 100}}                 --## Table Robbe fiable modifiée pour départ à 3.0V
---- ###############################################################
---- Calcul du pourcentage de chaque élément ; Pas de virgule
---- ###############################################################
function percentcell(targetVoltage)
  local result = 0
  if targetVoltage > cellfull or targetVoltage < cellempty then
    if  targetVoltage > cellfull then                                            --## trap for odd values not in array
      result = 100
    end
    if  targetVoltage < cellempty then
      result = 0
    end
  else
    for i, v in ipairs( myArrayPercentList ) do                                  --## method of finding percent in my array provided by on4mh (Mike)
      if v[ 1 ] >= targetVoltage then
        result =  v[ 2 ]
        break
      end
    end --for
  end --if
 return result
end


---- ###############################################################
---- #####################BOUCLE PRINCIPALE#########################
---- ###############################################################

---- ###############################################################
---- Récupération et calculs des valeurs
---- ###############################################################
local function run(event)
--  lcd.lock()                                           --## Commenté pour compatibilité OTX 2.2
  lcd.clear()

  cellmin = cellfull
  cellmax = 0

  cellResult = getValue("Cels")                          --## Appel du tableau retourné par le capteur FLVSS
  if type(cellResult) == "table" then                    --## Vérif du format de valeur retournée (Table)
    cellsum = 0                                          --## Raz cellsum (évite addition infinie)
    for i = 1, #cell do cell[i] = 0 end                  --## Réinitialisation des 6 éléments à 0
    cellsumtype = #cellResult                            --## Nombre d'éléments détectés
    for i, v in pairs(cellResult) do                     --## Boucle for qui isole chaque valeurs de la table
      cellsum = cellsum + v                              --## Addition de chaque éléments pour valeur totale du pack
      cell[i] = v                                        --## Application des valeurs de 1 à x à chaque élément de 1 à x
      if cellmaxima[i] < v then                          --## On jette les 9 1eres mesures le temps que ça se stabilise
        cellmaxima[i] = v
      end
      if cellminima[i] > v then
        cellminima[i] = v
      end
      if cellmin > v then                                --## Valeur cellmin
        cellmin = v
      end
      if cellmax < v then                                --## Valeur cellmax
        cellmax = v
      end
    end -- end for
  end -- end if

                  
  cellsumpercent = percentcell(cellsum/cellsumtype)      --## Pourcentage du pack
  if cellsumpercentmaxima < cellsumpercent then
    cellsumpercentmaxima = cellsumpercent
  end
  if cell[1]>0 then                                      --## évite un minima à 0 si la télémétrie est branchée après lancement du script
    if cellsumpercentminima > cellsumpercent then
      cellsumpercentminima = cellsumpercent
    end
  end

---- ###############################################################
---- Affichage du titre
---- ###############################################################
  lcd.drawText(24, 2, "[LI-PO BATTCHECK V", SMLSIZE)
  lcd.drawText(lcd.getLastPos(), 2, version ,SMLSIZE)                       --## Titre
  lcd.drawText(lcd.getLastPos(), 2, "]" ,SMLSIZE)                           --## Titre
  lcd.drawLine(2, 5, 21, 5, SOLID, 0)                                       --## Ligne 1 de titre
  lcd.drawLine(130, 5, 149, 5, SOLID, 0)                                    --## Ligne 2 de titre


---- ###############################################################
---- Affichage de la jauge horizontale du pack
---- Sans utiliser drawGauge pour l'ésthétique.
---- ###############################################################
  lcd.drawFilledRectangle(3, 11, cellsumpercentmaxima*44/100, 18, GREY_DEFAULT + FILL_WHITE )         --## Jauge maxima
  lcd.drawFilledRectangle(3, 11, cellsumpercent*44/100, 18,  GREY(7) )                                --## Jauge instantanée
  if cellsumpercentminima < cellsumpercent and cellsumpercentminima > 0 then                          --## Evite une surimpression qui fausserait le visuel
    lcd.drawLine(3+(cellsumpercentminima*44/100), 11, 3+(cellsumpercentminima*44/100), 28, SOLID, 0 ) --## Jauge Minima
  end

  lcd.drawRectangle(2, 10, 46, 20)                                          --## Contour de jauge (x, y, width, height)
  lcd.drawFilledRectangle (48,15,2,10)                                      --## Nez de batterie


---- ###############################################################
---- Affichage du pourcentage restant du pack
---- ###############################################################
  lcd.drawText(55,14,cellsumpercent,MIDSIZE)
  lcd.drawText(lcd.getLastPos(),16,"%",0)


---- ###############################################################
---- Affichage du tableau bas gauche des valeurs de chaque élément
---- et affichage des jauges de chaque élément
---- ###############################################################
  lcd.drawLine(38, 33, 38, 61, SOLID, GREY_DEFAULT)                                         --## Affiche le séparateur vertical

  for i = 1, 6 do                                                                           --## Aff d'un tiret pour l'illusion d'icônes de batteries
    lcd.drawLine(positions[i][1] + 1, positions[i][2] - 3, positions[i][1] + 2, positions[i][2] - 3, SOLID, 0)
    lcd.drawNumber(positions[i][1], positions[i][2]-1, i, LEFT + SMLSIZE + INVERS)          --## Aff du numéro de l'élément

    if cell[i] ~= 0 then
      blink = cell[i] < cellempty and BLINK or 0                                            --## Aff de la valeur de l'élément
      lcd.drawNumber(lcd.getLastPos() + 3, positions[i][2], cell[i]*100, PREC2 + LEFT + SMLSIZE + blink)
      lcd.drawText(lcd.getLastPos(), positions[i][2],"V",SMLSIZE + blink)
      percent       = math.floor(percentcell(cell[i]) * (echH/100))                         --## Hauteur de la jauge de l'élément
      percentminima = math.floor(percentcell(cellminima[i]) * (echH/100))                   --## Hauteur de la surjauge du minima de l'élément
      percentmaxima = math.floor(percentcell(cellmaxima[i]) * (echH/100))                   --## Hauteur du marquage du maxima

  lcd.drawFilledRectangle(echX + 2 + (i - 1) * (gaugeW + gaugeGap), (ech100Y + echH - percentmaxima), gaugeW, percentmaxima, GREY_DEFAULT + FILL_WHITE )                                     --## Jauges maxima
  lcd.drawFilledRectangle(echX + 2 + (i - 1) * (gaugeW + gaugeGap), (ech100Y + echH - percent), gaugeW, percent, GREY(7))                                                                    --## Jauges instantanées
  if percentminima < percent and percentminima > 0 then                                                                                                                                      --## Evite une surimpression qui fausserait le visuel
    lcd.drawLine(echX + 2 + (i - 1) * (gaugeW + gaugeGap), ech100Y + echH - percentminima, (echX + 2 + (i - 1) * (gaugeW + gaugeGap)) + gaugeW-1,  ech100Y + echH - percentminima, SOLID, 0) --## Jauges minima
  end
  
    else
      lcd.drawText(lcd.getLastPos() + 3, positions[i][2],"****",SMLSIZE)                    --## Ou aff * si élément absent
      lcd.drawText (echX + 5 + (i - 1)*(gaugeW + gaugeGap), ech0Y-7, "*", SMLSIZE)
    end
  end


---- ###############################################################
---- Echelle
---- ###############################################################
  lcd.drawLine(echX, ech100Y, echX, ech0Y, SOLID, GREY_DEFAULT)                                                   --## Axe Y
  lcd.drawLine(echX+1, ech0Y, echX + gaugeGap + 5*(gaugeW + gaugeGap) + gaugeW, ech0Y, SOLID, GREY_DEFAULT)       --## Axe X

  i = 10                                                                                                          --## 10 divisions d'échelle
  while (i >= 0) do
    lcd.drawLine(echX-2, (ech100Y+echH)-((echH/10)*i), echX-1, (ech100Y+echH)-((echH/10)*i), SOLID, GREY_DEFAULT) --## Traçage des divisions
    i= i-1
  end


---- ###############################################################
---- Barre de séparation verticale 2
---- ###############################################################
  lcd.drawLine(79, 10, 79, 61, SOLID, GREY_DEFAULT)


---- ###############################################################
---- Milieu d'écran
---- ###############################################################
  lcd.drawText (83,14, "PACK : ", SMLSIZE)
  lcd.drawText (lcd.getLastPos(),14, cellsumtype, SMLSIZE)
  lcd.drawText (lcd.getLastPos(),14, "S", SMLSIZE)

  lcd.drawText (83,24, voltageword, SMLSIZE)
  lcd.drawText (lcd.getLastPos(),24, " : ", SMLSIZE)
  if cellsum > 10 then
    lcd.drawNumber (lcd.getLastPos()-1,24, cellsum*10, PREC1 + LEFT + SMLSIZE)
  else
    lcd.drawNumber (lcd.getLastPos()-1,24, cellsum*100, PREC2 + LEFT + SMLSIZE)
  end
  lcd.drawText (lcd.getLastPos(),24, "V", SMLSIZE)

  lcd.drawText (83,36, averageword, SMLSIZE)
  lcd.drawText (lcd.getLastPos(),36, " : ", SMLSIZE)
  if cellsum > 0 then
    lcd.drawNumber (lcd.getLastPos()-1,36, (cellsum / cellsumtype)*100, LEFT + PREC2 + SMLSIZE)
  else
    lcd.drawNumber (lcd.getLastPos()-1,36, "0", LEFT + SMLSIZE)
  end
  lcd.drawText (lcd.getLastPos(),36, "V", SMLSIZE)

  lcd.drawText (83,46, "DELTA : ", SMLSIZE)
  lcd.drawNumber (lcd.getLastPos()-1,46, (cell[1] > 0 and (cellmax * 1000) - (cellmin * 1000) or 0), LEFT + SMLSIZE)
  lcd.drawText (lcd.getLastPos(),46, "mV", SMLSIZE)

  lcd.drawText (83,56, "BALANCE : ", SMLSIZE)
  if cell[1] > 0 then
    percentDelta = math.floor(100 - (percentcell(cellmax) - percentcell(cellmin)))
    blink = percentDelta < 90 and BLINK or 0
    lcd.drawNumber (lcd.getLastPos()-1,56, percentDelta, SMLSIZE + LEFT + blink)
    lcd.drawText (lcd.getLastPos(),56, "%", SMLSIZE + blink)
  else
    lcd.drawText (lcd.getLastPos(),56, "N/A", SMLSIZE)
  end


  if (type(cellResult) ~= "table") then
    lcd.clear()
    lcd.drawText(53,1,"TARANIS BATTCHECK V",SMLSIZE + INVERS)
    lcd.drawText(lcd.getLastPos(),1,version,SMLSIZE + INVERS)
    
    if language ~= "EN" then
      lcd.drawText(42,15,"TELEMETRIE INDISPONIBLE", BLINK + 0)
      lcd.drawText(3,30,"VERIFIEZ LA CONNECTION DU PERIPH. FLVSS",0)
      lcd.drawText(29,40,"OU EFFACEZ LE CAPTEUR [Cels]",0)
      lcd.drawText(22,50,"ET REFAITES UNE AUTO-DETECTION",0)
    else
      lcd.drawText(47,15,"TELEMETRY UNAVAILABLE", BLINK + 0)
      lcd.drawText(61,30,"CHECK FLVSS LINK",0)
      lcd.drawText(47,40,"OR ERASE [Cels] SENSOR",0)
      lcd.drawText(10,50,"AND TRY ANOTHER SENSORS AUTODETECT",0)
    end
  end


end --End local function principale
return { run = run } --Retour au départ de boucle principale