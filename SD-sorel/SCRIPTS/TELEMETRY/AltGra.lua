-- Script réalisé par LapinFou
-- Version 1.8

-- Site web: http://opentx-doc.fr

-- ##########################
-- ## A MODIFIER SI BESOIN ##
-- ##########################
local nomVario = "Alt"      -- Nom de votre capteur d'altitude (il est défini dans votre page télémétrie)
local altStart = 3          -- Démarre l'enregistrement si l'altitude est supérieure (valeur en mètre)
local altStartMode = "Auto" -- Si "Auto" alors 'altStart' est utilisé, sinon choisir un inter 3 positions (par ex: "sb")
local graphPlein = true     -- Il faut choisir "true" ou "false": true va afficher le graphique en plein

-- #####################################
-- ## NE RIEN MODIFIER A PARTIR D'ICI ##
-- #####################################
local alt_id = getFieldInfo(nomVario).id
local altMax_id = getFieldInfo(nomVario.."+").id
local inter_id

-- Défini la taille d'affichage du graphique pour l'altitude: coordonnée en haut à gauche = (0,0)
local originTps     -- Origine de l'axe représentant le temps en seconde
local largeurTps    -- Largeur de l'axe représentant le temps en seconde
local originAlt     -- Max de l'axe représentant l'altitude en mètre (l'axe Y est inversé !!)
local hauteurAlt    -- Largeur de l'axe représentant l'altitude en mètre

-- Variables globales
local nbrLigneAlt   -- Nombre de lignes horizontales
local nbrPixelGrad  -- Nombre de pixels par graduation
local newAlt        -- Nouvelle altitude provenant du capteur
local maxAltAffi    -- Altitude max affichable
local altMax        -- Altitude max reçue par le vario
local tableAlt = {} -- Tableau où sont stockes toutes les altitudes
local tableIndex    -- Index indiquant jusqu'où est rempli le tableau
local gradAlt       -- Altitude pour 1 graduation
local pixelParMetre -- Valeur en mètre d'un pixel sur l'axe Y
local secParPix     -- Nombre de seconde par pixel sur l'axe X
local tempsMax      -- Init du temps max en seconde
local tpsPrec       -- Temps de la dernière mise à jour du tableau
local compTemps     -- Compression du temps compTemps/(compTemps-1) - La valeur mini est 2
local grdeAlt       -- Décalage du graphique vers la droite si l'altitude est supérieure à 960m
local startAlt      -- Démarre l'enregistrement

-- ##########
-- ## Init ##
-- ##########
local function init()
    if (altStartMode ~= "Auto") then
        inter_id = getFieldInfo(altStartMode).id
    end

    -- Valeurs par défaut
    originTps = 18
    originAlt = 62
    hauteurAlt = 62
    nbrLigneAlt = 6
    newAlt = 0
    maxAltAffi = 20
    altMax = 0
    tableIndex = 0
    gradAlt = 5
    tempsMax = 20
    tpsPrec = 0
    compTemps = 6
    grdeAlt = false
    startAlt = false

    -- Détecte le type d'écran
    if (LCD_W == 212) then
        largeurTps = 160
    else
        largeurTps = 103
    end

    -- Init le nombre de seconde par pixel sur l'axe X
    secParPix = 100*tempsMax/largeurTps
    
    -- Calcul nombre de pixel pour 1 graduation (arrondi inférieur)
    nbrPixelGrad = math.floor(hauteurAlt/nbrLigneAlt)
    -- Mettre à jour l'échelle de l'axe altitude
    pixelParMetre = nbrPixelGrad/gradAlt

    -- Init du tableau à 0
    for index = 0, largeurTps-1 do
        tableAlt[index] = 0
    end
end

-- ###############
-- ## Fonctions ##
-- ###############
-- Gestion de la table d'altitude
local function gestionTable()
    -- Obtenir la nouvelle altitude provenant du capteur
    newAlt = math.floor(getValue(alt_id)+0.5)
 
    -- Démarre l'enregistrement
    -- Enregistrement contrôlé par un inter 3 positions
    if (altStartMode ~= "Auto") then
        local interPosition = getValue(inter_id)
        -- Met en pause l'enregistrement
        if (interPosition < -200) then
            startAlt = false
        -- Remise à zéro
        elseif (interPosition > 200) then
            init()
        -- Démarrer l'enregistrement
        else
            startAlt = true
        end
    -- Enregistrement et remise à zéro en mode automatiquement
    else
        -- Démarre l'enregistrement des altitudes
        if (newAlt > altStart) then
            startAlt = true
        end

        -- Si l'altitude max provenant du capteur ET que l'enregistrement est en cours, alors la télémétrie a été remise à zéro
        -- En cas de perte de télémétrie, getValue() renvoie 0
        -- Donc, il faut vérifier que la télémétrie est OK avec getRSSI()
        if (((math.floor(getValue(altMax_id)+0.5)) == 0) and (startAlt == true) and (getRSSI() ~= 0)) then
            init()
        end
    end
   
    -- Enregistrement des données
    if (startAlt == true) then
        -- Mettre à jour l'altitude max
        if (newAlt > altMax) then
            altMax = newAlt
        end

        -- Si l'altitude passe à 4 chifres, alors décaler le tableau + réduire la taille altitude actuelle
        if ((altMax > 960) and (grdeAlt == false)) then
            originTps = originTps+6
            grdeAlt = true
        end
    
        -- Obtenir le temps de la radio (en 1/100 de seconde)
        local tpsActuel = getTime()
        
        -- Mettre à jour l'altitude max si la nouvelle altitude est supérieure
        if (newAlt > maxAltAffi) then
            maxAltAffi = newAlt
        end
        
        -- Si la différence de temps par rapport à la dernière mesure est > à secParPix, alors mettre à jour le tableau
        if ((tpsActuel-tpsPrec) > secParPix) then
            -- Filtre les altitudes négatives
            if (newAlt < 0) then
                tableAlt[tableIndex] = 0
            else
                tableAlt[tableIndex] = newAlt
            end
            -- Incrémenter tableIndex
            tableIndex = tableIndex+1
    
            -- Mettre à jour le temps précédent
            tpsPrec = tpsActuel
        end
    
        -- Compresser le tableau lorsqu'il est rempli
        if (tableIndex > largeurTps) then
            -- Index temporaire
            local tmpIdx = 0
            
            -- Efface 1 case sur compTemps
            for index = 0, largeurTps do
                if ((index % compTemps) ~= 0) then
                    tableAlt[tmpIdx] = tableAlt[index]
                    tmpIdx = tmpIdx+1
                end
            end
    
            -- Init à 0 les cases vides du tableau afin qu'elles ne s'affichent plus
            for index= tmpIdx, largeurTps do
                tableAlt[index] = 0
            end
            
            -- Mettre à jour l'index indiquant jusqu'où est rempli le tableau
            tableIndex = tmpIdx
            -- Mettre à jour la variable "seconde par pixel"
            tempsMax = tempsMax * compTemps/(compTemps-1)
            secParPix = 100*tempsMax/largeurTps
        end
    end
end

-- Dessine les axes temps et altitude
local function dessinerAxe()
    -- Les +2 sur les largeurs correspondent à l'épaisseur du trait (2* 1 pixel)
    lcd.drawRectangle(originTps-1, originAlt+1, largeurTps+2, -hauteurAlt, SOLID)
end

-- Dessine la grille
local function dessinerGrille()
    -- Utiliser pour marquer la graduation à droite des chiffres (1 pixel)
    local pointAlt

    -- Dessine les lignes horizontales
    for index = 1, nbrLigneAlt do
        pointAlt = originAlt-nbrPixelGrad*index+1
        if (LCD_W == 212) then
            lcd.drawLine(originTps, pointAlt, originTps+largeurTps-1, pointAlt, SOLID, GREY_DEFAULT)
        else
            lcd.drawLine(originTps, pointAlt, originTps+largeurTps-1, pointAlt, DOTTED, FORCE)
        end
        -- Dessine les points à gauche de l'axe vertical sauf pour 0 mètre
        if (index == 0) then
            if (LCD_W == 212) then
                lcd.drawPoint(originTps-2, pointAlt)
            end
        else
            lcd.drawPoint(originTps-2, pointAlt)
        end
    end
end

-- Calcul l'altitude en mètre par pixel et affiche l'échelle à gauche du graphique
local function dessinerEchelle()
    -- Index de démarrage
    local idxStart

    -- Ne pas afficher la 1ère valeur sur les radios X7
    if (LCD_W == 212) then
        idxStart = 1
    else
        idxStart = 2
    end

    -- Ajuster l'altitude par graduation afin d'avoir des multiples de 5 ou 10
    while maxAltAffi > (nbrLigneAlt*gradAlt) do
        if (gradAlt >= 30) then
            gradAlt = gradAlt+10
        else
            gradAlt = gradAlt+5
        end

        -- Calcul nombre de pixel pour 1 graduation (arrondi inférieur)
        nbrPixelGrad = math.floor(hauteurAlt/nbrLigneAlt)
    
        -- Mettre à jour l'échelle de l'axe altitude
        pixelParMetre = nbrPixelGrad/gradAlt
    end

    -- Mettre à jour les nombres sur l'échelle d'altitude
    for index = idxStart, nbrLigneAlt do
        lcd.drawNumber(originTps-2, originAlt-index*nbrPixelGrad-1, index*gradAlt, SMLSIZE+RIGHT)
    end
    
    -- Affiche l'échelle de temps en bas à droite
    if (LCD_W == 212) then
        local tmpMin = math.floor(tempsMax/60)
        local tmpSec = math.floor(tempsMax % 60)
        if (tmpSec < 10) then
            lcd.drawText(originTps+largeurTps+5, originAlt-5, tmpMin..":0"..tmpSec, SMLSIZE)
        else
            lcd.drawText(originTps+largeurTps+5, originAlt-5, tmpMin..":"..tmpSec, SMLSIZE)
        end
    end
end

-- Dessine le graphique altitude
local function dessinerAltitude()
    local altActuel = 0 -- Altitude actuel
    local altPrec = 0   -- Altitude précédente

    -- Mettre à jour les valeurs affichées
    -- Gère l'affiche de l'altitude sur 4 chiffres
    if (LCD_W == 212) then
        if (grdeAlt == false) then 
            lcd.drawText(originTps+largeurTps+2,originAlt-60,newAlt.."m", MIDSIZE)
        else
            lcd.drawText(originTps+largeurTps+2,originAlt-60,newAlt.."m", SMLSIZE)
        end
        lcd.drawText(originTps+largeurTps+2,originAlt-42,"Max:",SMLSIZE)
        lcd.drawText(originTps+largeurTps+2,originAlt-34,altMax.."m",SMLSIZE)
    else
        lcd.drawText(1,originAlt-12,"Alt:", SMLSIZE)
        lcd.drawText(2,originAlt-5,newAlt, SMLSIZE)
    end
    

    -- Dessine le graphique altitude
    for index = 0, largeurTps-1 do
        -- Converti l'altitude en pixel
        altActuel = originAlt-tableAlt[index]*pixelParMetre+1
        -- Si l'altitude est inférieur à 1 pixel, alors affiche 1 seul pixel (NB: l'axe Y fonctionne à l'envers)
        if (altActuel > originAlt) then
            altActuel = originAlt
        end

        -- Affiche la barre verticale en gris
        -- Teste: affiche l'altitude si altActuel != 0 ET si l'index est inférieur à tableIndex
        if ((altActuel ~= 0) and (index < tableIndex)) then
            if (graphPlein == true) then
                if (LCD_W == 212) then
                    lcd.drawLine(originTps+index, originAlt, originTps+index, altActuel, SOLID, GREY_DEFAULT)
                else
                    lcd.drawLine(originTps+index, originAlt, originTps+index, altActuel, SOLID, FORCE)
                end
            end

            -- Dessine les contours en noir
            -- Teste: dessine le contour sauf pour l'index 0
            if (index ~= 0) then
                lcd.drawLine(originTps+index-1, altPrec, originTps+index, altActuel, SOLID, FORCE)
            end
            
            -- Mettre l'altitude précédente en mémoire
            altPrec = altActuel
        end
    end
end

-- #########
-- ## Run ##
-- #########
local function background()
    gestionTable()      -- Mettre à jour le tableau "altitude"
end

local function run(event)
    lcd.clear() 
    
    dessinerAxe()       -- Dessine axes (à faire en 1er)
    dessinerGrille()    -- Dessine la grille (à faire en 2nd)
    dessinerEchelle()   -- Dessine l'échelle à gauche du graphique
    dessinerAltitude()  -- Dessine les altitudes
end

return {init=init, background=background, run=run}
