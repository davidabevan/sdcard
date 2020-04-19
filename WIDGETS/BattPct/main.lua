---- #########################################################################
---- #                                                                       #
---- # Battery % Widget for FrSky Horus 			             #
---- #                                                                       #
---- # This program is free software; you can redistribute it and/or modify  #
---- # it under the terms of the GNU General Public License version 3 as     #
---- # published by the Free Software Foundation.                            #
---- #                                                                       #
---- # Revised by Björn Pasteuning / Hobby4life 2019                         #
---- # Version: 3.2                                                          #
---- #                                                                       #
---- #########################################################################
local options = {
  { "Source", SOURCE, 1 }, -- Defines source Battery Voltage Sensor
  { "Color", COLOR, WHITE },	
  { "Cells", VALUE, 6, 1, 12 }, -- Defines the amount of lipo cells
}
function create(zone, options)
  local Context = { zone=zone, options=options }
  return Context
end
-- This function allow updates when you change widgets settings
local function update(Context, options)
  Context.options = options
end
--- This function return the percentage remaining in a single Lipo cel
local function getCellPercent(cellValue)
  --## Data gathered from commercial lipo sensors
  local myArrayPercentList =
  {
  {3.000, 0},
  {3.093, 1},
  {3.196, 2},
  {3.301, 3},
  {3.401, 4},
  {3.477, 5},
  {3.544, 6},
  {3.601, 7},
  {3.637, 8},
  {3.664, 9},
  {3.679, 10},
  {3.683, 11},
  {3.689, 12},
  {3.692, 13},
  {3.705, 14},
  {3.710, 15},
  {3.713, 16},
  {3.715, 17},
  {3.720, 18},
  {3.731, 19},
  {3.735, 20},
  {3.744, 21},
  {3.753, 22},
  {3.756, 23},
  {3.758, 24},
  {3.762, 25},
  {3.767, 26},
  {3.774, 27},
  {3.780, 28},
  {3.783, 29},
  {3.786, 30},
  {3.789, 31},
  {3.794, 32},
  {3.797, 33},
  {3.800, 34},
  {3.802, 35},
  {3.805, 36},
  {3.808, 37},
  {3.811, 38},
  {3.815, 39},
  {3.818, 40},
  {3.822, 41},
  {3.825, 42},
  {3.829, 43},
  {3.833, 44},
  {3.836, 45},
  {3.840, 46},
  {3.843, 47},
  {3.847, 48},
  {3.850, 49},
  {3.854, 50},
  {3.857, 51},
  {3.860, 52},
  {3.863, 53},
  {3.866, 54},
  {3.870, 55},
  {3.874, 56},
  {3.879, 57},
  {3.888, 58},
  {3.893, 59},
  {3.897, 60},
  {3.902, 61},
  {3.906, 62}, 
  {3.911, 63}, 
  {3.918, 64},
  {3.923, 65},
  {3.928, 66}, 
  {3.939, 67},
  {3.943, 68},
  {3.949, 69},
  {3.955, 70},
  {3.961, 71}, 
  {3.968, 72},
  {3.974, 73},
  {3.981, 74},
  {3.987, 75},
  {3.994, 76},
  {4.001, 77}, 
  {4.007, 78}, 
  {4.014, 79},
  {4.021, 80},
  {4.029, 81},
  {4.036, 82},
  {4.044, 83},
  {4.052, 84},
  {4.062, 85},
  {4.074, 86},
  {4.085, 87},
  {4.095, 88},
  {4.105, 89},
  {4.111, 90},
  {4.116, 91},
  {4.120, 92},
  {4.125, 93},
  {4.129, 94},
  {4.135, 95},
  {4.145, 96},
  {4.176, 97},
  {4.179, 98},
  {4.193, 99},
  {4.200, 100}
  }
  if cellValue >= 4.2 then
    cellValue = 4.2
  elseif cellValue <= 3 then
    result = 0
    return result
  end
  
  for i, v in ipairs( myArrayPercentList ) do
    if v[ 1 ] >= cellValue then
      result =  v[ 2 ]
     break
     end
  end
  
  return result
  
end
-- This function returns green at 100%, red bellow 30% and graduate in betwwen
local function getPercentColor(cpercent)
  if cpercent < 30 then
    return lcd.RGB(0xff, 0, 0)
  else
    g = math.floor(0xdf * cpercent / 100)
    r = 0xdf - g
    return lcd.RGB(r, g, 0)
  end
end
function Calc_VPercent(LocalContext)
  
  LiveVolt = getValue(LocalContext.options.Source)
  LiveCells = LocalContext.options.Cells
  
  if(LiveVolt == nil) then
    LiveVolt = 100
    return
  end
  if LiveVolt > 0 then
    Volt = LiveVolt / LiveCells
    VPercent = getCellPercent(Volt)
  end
  
end
function ScreenUpdate(LocalContext)
  
  if LiveVolt > 0 then
  
    if LocalContext.zone.w > 220 and LocalContext.zone.h > 160 then
      lcd.setColor(CUSTOM_COLOR, LocalContext.options.Color)
      lcd.drawText(LocalContext.zone.x + 5, LocalContext.zone.y + 2, "BATTERY LEFT", CUSTOM_COLOR + SHADOWED)
      lcd.setColor(CUSTOM_COLOR, getPercentColor(VPercent))
      lcd.drawText(LocalContext.zone.x + 5, LocalContext.zone.y +15, round(VPercent).."%" , CUSTOM_COLOR + DBLSIZE  + SHADOWED)
      lcd.drawText(LocalContext.zone.x + 5, LocalContext.zone.y +45, round(LiveVolt,2).."V" , CUSTOM_COLOR + DBLSIZE  + SHADOWED)
      
      lcd.setColor(CUSTOM_COLOR, LocalContext.options.Color)
      lcd.drawRectangle((LocalContext.zone.x - 1) , (LocalContext.zone.y + (LocalContext.zone.h - 31)), (LocalContext.zone.w + 2), 32, CUSTOM_COLOR)
      lcd.setColor(CUSTOM_COLOR, getPercentColor(VPercent))
      lcd.drawGauge(LocalContext.zone.x , (LocalContext.zone.y + (LocalContext.zone.h - 30)), LocalContext.zone.w, 30, round(VPercent), 100, CUSTOM_COLOR)		
      
    elseif LocalContext.zone.w > 220 and LocalContext.zone.h > 90 then
      lcd.setColor(CUSTOM_COLOR, LocalContext.options.Color)
      lcd.drawText(LocalContext.zone.x + 5, LocalContext.zone.y + 2, "BATTERY LEFT", CUSTOM_COLOR + SHADOWED)
      lcd.setColor(CUSTOM_COLOR, getPercentColor(VPercent))
      lcd.drawText(LocalContext.zone.x + 5, LocalContext.zone.y +15, round(VPercent).."%" , CUSTOM_COLOR + DBLSIZE  + SHADOWED)
      lcd.drawText((LocalContext.zone.x + 220 - 15), LocalContext.zone.y +15, round(LiveVolt,2).."V" , CUSTOM_COLOR + RIGHT + DBLSIZE  + SHADOWED)
      lcd.setColor(CUSTOM_COLOR, LocalContext.options.Color)
      lcd.drawRectangle((LocalContext.zone.x - 1) , (LocalContext.zone.y + (LocalContext.zone.h - 31)), (LocalContext.zone.w + 2), 32, CUSTOM_COLOR)
      lcd.setColor(CUSTOM_COLOR, getPercentColor(VPercent))
      lcd.drawGauge(LocalContext.zone.x , (LocalContext.zone.y + (LocalContext.zone.h - 30)), LocalContext.zone.w, 30, round(VPercent), 100, CUSTOM_COLOR)	
    elseif LocalContext.zone.w == 192 and LocalContext.zone.h == 152 then
      lcd.setColor(CUSTOM_COLOR, LocalContext.options.Color)
      lcd.drawText(LocalContext.zone.x + 5, LocalContext.zone.y + 2, "BATTERY LEFT", CUSTOM_COLOR + SHADOWED)
      lcd.setColor(CUSTOM_COLOR, getPercentColor(VPercent))
      lcd.drawText(LocalContext.zone.x + 5, LocalContext.zone.y +15, round(VPercent).."%" , CUSTOM_COLOR + DBLSIZE  + SHADOWED)
      lcd.drawText(LocalContext.zone.x + 5, LocalContext.zone.y +45, round(LiveVolt,2).."V" , CUSTOM_COLOR + DBLSIZE  + SHADOWED)			
      lcd.setColor(CUSTOM_COLOR, LocalContext.options.Color)
      lcd.drawRectangle((LocalContext.zone.x - 1) , (LocalContext.zone.y + (LocalContext.zone.h - 31)), (LocalContext.zone.w + 2), 32, CUSTOM_COLOR)
      lcd.setColor(CUSTOM_COLOR, getPercentColor(VPercent))
      lcd.drawGauge(LocalContext.zone.x , (LocalContext.zone.y + (LocalContext.zone.h - 30)), LocalContext.zone.w, 30, round(VPercent), 100, CUSTOM_COLOR)
      
    elseif LocalContext.zone.w == 180 and LocalContext.zone.h == 70 then
    
      lcd.setColor(CUSTOM_COLOR, LocalContext.options.Color)
      lcd.drawText(LocalContext.zone.x + 5, LocalContext.zone.y + 2, "BATTERY LEFT", CUSTOM_COLOR + SHADOWED)
      lcd.setColor(CUSTOM_COLOR, getPercentColor(VPercent))
      lcd.drawText((LocalContext.zone.x + 192 - 15), LocalContext.zone.y +30, round(LiveVolt,2).."V" , CUSTOM_COLOR + RIGHT  + SHADOWED)
      lcd.drawText(LocalContext.zone.x + 5, LocalContext.zone.y +15, round(VPercent).."%" , CUSTOM_COLOR + DBLSIZE  + SHADOWED)			
      lcd.setColor(CUSTOM_COLOR, LocalContext.options.Color)
      lcd.drawRectangle((LocalContext.zone.x - 1) , (LocalContext.zone.y + (LocalContext.zone.h - 21)), (LocalContext.zone.w + 2), 22, CUSTOM_COLOR)
      lcd.setColor(CUSTOM_COLOR, getPercentColor(VPercent))
      lcd.drawGauge(LocalContext.zone.x , (LocalContext.zone.y + (LocalContext.zone.h - 20)), LocalContext.zone.w, 20, round(VPercent), 100, CUSTOM_COLOR)
      
    elseif LocalContext.zone.w == 160 and LocalContext.zone.h == 32 then
      lcd.setColor(CUSTOM_COLOR, lcd.RGB(0,0,0))
      lcd.drawSource(LocalContext.zone.x + 6, LocalContext.zone.y + 2, LocalContext.options.Source, CUSTOM_COLOR + SHADOWED)
      lcd.setColor(CUSTOM_COLOR, LocalContext.options.Color)
      lcd.drawSource(LocalContext.zone.x + 5, LocalContext.zone.y + 1, LocalContext.options.Source, CUSTOM_COLOR + SHADOWED)
      
      
      lcd.setColor(CUSTOM_COLOR, getPercentColor(VPercent))
      lcd.drawText(LocalContext.zone.x + 160, LocalContext.zone.y - 8, round(VPercent).."%" , CUSTOM_COLOR + DBLSIZE + RIGHT  + SHADOWED)	
      
      lcd.setColor(CUSTOM_COLOR, getPercentColor(VPercent))
      lcd.drawGauge(LocalContext.zone.x , (LocalContext.zone.y + (LocalContext.zone.h - 5)), LocalContext.zone.w, 5, round(VPercent), 100, CUSTOM_COLOR)			
      
    end
  
  else
  
    lcd.setColor(CUSTOM_COLOR, LocalContext.options.Color)
    lcd.drawText(LocalContext.zone.x + LocalContext.zone.w, LocalContext.zone.y + 2, "Sensor Lost", CUSTOM_COLOR + RIGHT + INVERS + BLINK)
    
  end
end
function round(num, decimals)
  local mult = 10^(decimals or 0)
  return math.floor(num * mult + 0.5) / mult
end
function update(Context, options)
  Context.options = options
  Context.back = nil
end
function refresh(Context)
  
  Calc_VPercent(Context)
  ScreenUpdate(Context)
  
end
return { name="BattPct", options=options, create=create, update=update, refresh=refresh }
 