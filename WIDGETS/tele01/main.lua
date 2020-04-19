-- ########################################################################
-- ## 	Script by   strgaltdel                                           ##
-- ##   Rev  0.8,   Oct. 2016                                            ##
-- ## 	Hardware    Horus only                                           ##
-- ## 	openTx      2.2nightly  RC7                                      ##
-- ##   tested:     ---not tested                                        ##
-- ##                                                                    ##
-- ##              inspired by an idea & script from                     ##
-- ##                         Ollicious                                  ##
-- ##                                                                    ##
-- ##                                                                    ##
-- ##            Dynamic design via initial values and functions         ##
-- ##                                                                    ##
-- #                                                                      #
-- # License GPLv2: http://www.gnu.org/licenses/gpl-2.0.html              #
-- #                                                                      #
-- # This program is free software; you can redistribute it and/or modify #
-- # it under the terms of the GNU General Public License version 2 as    #
-- # published by the Free Software Foundation.                           #
-- #                                                                      #
-- # This program is distributed in the hope that it will be useful       #
-- # but WITHOUT ANY WARRANTY; without even the implied warranty of       #
-- # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the        #
-- # GNU General Public License for more details.                         #
-- #                                                                      #
-- ##                                                                    ##
-- ## unow                                                               ##
-- ##                                                                    ##
-- ## feel free to customize by yourself                                 ##
-- ########################################################################                   

-- history

-- 0.8      2016-10 initial revision for testing in the public, due to no ownership of Horus Tx




------------------------------------------
--     for individual config      --------
------------------------------------------

local picPath = "/pics/"			-- path for icons
local transparency = 1				-- set background transparency: 1= "yes" 0= "no"
local col_std = GREY				-- standard value colour: `WHITE`,`GREY`,`LIGHTGREY`,`DARKGREY`,`BLACK`,`YELLOW`,`BLUE`,`RED`,`DARKRED`
local col_min = BLUE				-- standard min value colour
local col_max = RED					-- standard max value colour
local nRows = 3						-- number of rows per array; standard = 3
local inp_Xtrm = "ls63"				-- control to show extreme values
local aOffs = "ls62"				-- control to alternate between displays


local demo = 1						-- demo mode (1=on)


------------------------------------------
--     global vars                --------
------------------------------------------
local teleArray = {}				-- "master" array, all definitions included
local gpsLat, gpsLon				-- GPS position


---------------------------------------------
--     definition of "master arrays"  --------
---------------------------------------------


local function defineTeleArray()

local bmp_col
local val_col
local ydelta = 23
local num_arrays = 4				-- 	change to number of defined array (teleArray[])!

									--	init array 
	for i=1,num_arrays,1 do  
			teleArray[i]={}
	end
	
	
-- sens = telemetry sensor labels
-- bmp = icon file
-- x1 = X position icon within frame
-- y1 = Y position of row within frame
-- x2 = X position of value
-- y2 = delta-Y position of Value (standard = 0)
-- prec = precision of value : 0, PREC1, PREC2
-- size = character size : 0=standard, SMLSIZE=small , MISDISZE = large
-- minmax = display Min or Max value on demand; +=Max -=Min *=no
-- align = alignment of value: RIGHT / LEFT
-- handle = use "special" formatter function for "valTxt" variable : 1=yes;0=no

	bmp_col = 0
	val_col = 72
	teleArray[1] = {
		{sens="VFAS", 	bmp = picPath.."volt_1.png", 	x1=bmp_col, 	y1=1, 		  		x2=val_col,	y2=0,	prec=PREC1, size=0, 		minmax="-",	align=RIGHT, 	handle=0, demo=12,4},
		{sens="timer3", bmp = picPath.."clck3_1.png", 	x1=bmp_col, 	y1=1+(1*ydelta),   	x2=val_col,	y2=7,	prec=0, 	size=SMLSIZE, 	minmax="*",	align=RIGHT,	handle=0, demo=723},
		{sens="RPM", 	bmp = picPath.."rpm_1.png", 	x1=bmp_col, 	y1=1+(2*ydelta), 	x2=val_col,	y2=7,	prec=0, 	size=SMLSIZE, 	minmax="+",	align=RIGHT,	handle=0, demo=8469}
		}

	bmp_col = 101
	val_col = 179		
	teleArray[2] = {
		{sens="Ccon", 	bmp = picPath.."con_1.png", 	x1=bmp_col+3, 	y1=1, 				x2=val_col,	y2=0,	prec=0, 	size=0, 		minmax="*",	align=RIGHT,	handle=0,demo=1438},
		{sens="Curr", 	bmp = picPath.."curr_1.png", 	x1=bmp_col, 	y1=1+(1*ydelta), 	x2=val_col,	y2=7,	prec=0, 	size=SMLSIZE, 	minmax="+",	align=RIGHT,	handle=0,demo=38,3},
		{sens="Tmp1", 	bmp = picPath.."tmp_1.png", 	x1=bmp_col+3, 	y1=1+(2*ydelta), 	x2=val_col,	y2=7,	prec=0, 	size=SMLSIZE, 	minmax="+",	align=RIGHT,	handle=0,demo=49,2}
		}	
		
	bmp_col = 0
	val_col = 72
	teleArray[3] = {
		{sens="GPS", 	bmp = picPath.."gps_1.png", 	x1=bmp_col, 	y1=-1, 		  		x2=170,		y2=-3,	prec=0, 	size=SMLSIZE,	minmax="*",	align=RIGHT, 	handle=1,demo=12,4058},
		{sens="Dist", 	bmp = picPath.."dist_1.png", 	x1=bmp_col, 	y1=1+(1*ydelta),   	x2=val_col,	y2=4,	prec=0, 	size=SMLSIZE, 	minmax="+",	align=RIGHT,	handle=0,demo=459},
		{sens="GSpd", 	bmp = picPath.."spd2_1.png", 	x1=bmp_col, 	y1=1+(2*ydelta), 	x2=val_col,	y2=4,	prec=0, 	size=SMLSIZE, 	minmax="+",	align=RIGHT,	handle=0,demo=120}
		}

	bmp_col = 101
	val_col = 179		
	teleArray[4] = {
		{sens="dummy", 	bmp = picPath.."dummy", 		x1=bmp_col, 	y1=1, 				x2=val_col,	y2=7,	prec=0, 	size=0, 		minmax="*",	align=RIGHT,	handle=0,demo=8,258},
		{sens="GAlt", 	bmp = picPath.."gp_alt_1.png", 	x1=bmp_col, 	y1=1+(1*ydelta), 	x2=val_col,	y2=4,	prec=0, 	size=SMLSIZE, 	minmax="+",	align=RIGHT,	handle=0,demo=985},
		{sens="ASpd", 	bmp = picPath.."spd1_1.png", 	x1=bmp_col, 	y1=1+(2*ydelta), 	x2=val_col,	y2=4,	prec=0, 	size=SMLSIZE, 	minmax="+",	align=RIGHT,	handle=0,demo=132}
		}	
		
return 
end




local options = {
  { "Sensor", SOURCE, 1 }, 
  { "Color", COLOR, RED }
}

-- This function is runned once at the creation of the widget
local function create(zone, options)
  local myZone  = { zone=zone, options=options, counter=0 }
	defineTeleArray()
  return myZone
end

-- This function allow updates when you change widgets settings
local function update(myZone, options)
  myZone.options = options
end

-- A quick and dirty check for empty table
local function isEmpty(self)
  for _, _ in pairs(self) do
    return false
  end
  return true
end



local function gps2(label)
	local val 								-- GPS table (oTx telemetry)
	local LocationLat, LocationLon			-- GPS coord
	local LocLat_txt = ""					-- tmp txt var
	local LocLon_txt = ""					-- tmp txt var
	local preLat = ""						-- filler spce
	local preLon ="" 						-- filler spce


		--- assuming GPS returns no table or zero values  without fix
	if demo ~=1 then
		val = getValueOrDefault(telel)
		if type(val) == "table" and val["lat"] * val["lon"] ~= 0 then
			LocationLat = val["lat"]
			LocationLon = val["lon"]
		end
	else
		--Demo:
		LocationLat = 102.12356
		LocationLon = 25.12356
	end

		-- check if lat <10 and build substring
	if LocationLat < 10 then
			LocLat_txt = string.sub(LocationLat,3 ,4) .. "." .. string.sub(LocationLat,5 ,8)
			preLat = "  "
	elseif LocationLat < 100 then
			LocLat_txt = string.sub(LocationLat,4 ,5) .. "." .. string.sub(LocationLat,6 ,9)
			preLat = " "
	else
			LocLat_txt = string.sub(LocationLat,5 ,6) .. "." .. string.sub(LocationLat,7 ,10)
	end

		-- check if lon <10 and build substring
	if LocationLon < 10 then
		LocLon_txt = string.sub(LocationLon,3 ,4) .. "." .. string.sub(LocationLon,5 ,8)
		preLon = "  "
	elseif LocationLon < 100 then
		LocLon_txt = string.sub(LocationLon,4 ,5) .. "." .. string.sub(LocationLon,6 ,9)
		preLon = " "
	else
		LocLon_txt = string.sub(LocationLon,5 ,6) .. "." .. string.sub(LocationLon,7 ,10)
	end
	
	gpsLat = preLat .. string.format("%i",math.floor(LocationLat)).. "'" .. LocLon_txt .. "  "
	gpsLon = preLon .. string.format("%i",math.floor(LocationLon)).. "'" .. LocLon_txt .. "  "
	return true
end


--------------
-- Rounding --
--------------
local function rnd(v,d)
	if d then
	 return math.floor((v*10^d)+0.5)/(10^d)
	else
	 return math.floor(v+0.5)
	end
end

---------------
-- Get Value --
--------------- 
local function getValueOrDefault(value)
	local tmp = getValue(value)
	if tmp == nil then
		return 0
	end
	
	return tmp
end


--------------------------
-- *******************  --
-- draw Value function  --
-- *******************  --
-------------------------- 

local function drawVal(Tarray,zone)
	local teleLabel = Tarray.sens		--	!! telemetry sensor label must match model config !!						--
	local teleValue						-- 	temp. telemetry value
	local teleV_tmp						-- 	temp. telemetry value 2
	local icon							--  bitmap handling
	local valTxt						--  displayed string 
	local colTxt = col_std				--  text color

	
	if teleLabel ~="dummy" then
	
		if getValue(inp_Xtrm) > 0 and Tarray.minmax ~= "*" then
			if Tarray.minmax == "+" then
				colTxt = col_max
			else
				colTxt = col_min
			end
		end
		lcd.setColor(CUSTOM_COLOR, colTxt)

	
	
	-- 									*********   format string prep dependent on telemetry decimals
	
		if Tarray.prec== PREC2 then			-- factor must correspond to telemetry precision
			convString = "%7.2f"
		elseif Tarray.prec== PREC1 then
			convString = "%6.1f"
		else
			convString = "%i"
		end	
	
	
	-- 									*********    exception formatter , eg timer etc..
	
		if  Tarray.handle~=1 then
			if teleLabel == "timer1" then								--				timer 1
				if demo==0 then
					teleV_tmp = model.getTimer(0)
					teleValue = teleV_tmp.value
				else
				teleValue = Tarray.demo
				end	
				local minute = math.floor(teleValue/60)
				local sec = teleValue - (minute*60)
				if sec > 9 then
					valTxt = string.format("%i",minute)..":"..string.format("%i",sec)
				else
					valTxt = string.format("%i",minute)..":0"..string.format("%i",sec)
				end	

				
			elseif teleLabel == "timer2" then							--				timer 2
				if demo==0 then
					teleV_tmp = model.getTimer(1)
					teleValue = teleV_tmp.value
				else
					teleValue = Tarray.demo
				end	
				local minute = math.floor(teleValue/60)
				local sec = teleValue - (minute*60)
				if sec > 9 then
					valTxt = string.format("%i",minute)..":"..string.format("%i",sec)
				else
					valTxt = string.format("%i",minute)..":0"..string.format("%i",sec)
				end	

				
			elseif teleLabel == "timer3" then							--				timer 3
				if demo==0 then
					teleV_tmp = model.getTimer(2)
					teleValue = teleV_tmp.value
				else
					teleValue = Tarray.demo
				end
				local minute = math.floor(teleValue/60)
				local sec = teleValue - (minute*60)
				if sec > 9 then
					valTxt = string.format("%i",minute)..":"..string.format("%i",sec)
				else
					valTxt = string.format("%i",minute)..":0"..string.format("%i",sec)
				end	
	
	
			else
			-- 																standard formatter
				if demo ~=1 then
					teleValue = getValueOrDefault(teleLabel)
				else
					teleValue=Tarray.demo
				end
					valTxt = string.format(convString,teleValue)
			end
	
	
		--								draw value	
		lcd.drawText(zone.zone.x + Tarray.x2, zone.zone.y + Tarray.y1+ Tarray.y2, valTxt, Tarray.size + Tarray.align + CUSTOM_COLOR)
	
	
		--																"very" special formatter, eg GPS ( !"dummy" param!)
		else
			if teleLabel == "GPS" then							--				GPS
				tmp = gps2(teleLabel)		--			 				get coord. & format strings
				lcd.drawText(zone.zone.x + Tarray.x2, zone.zone.y + Tarray.y1+ Tarray.y2,"  " .. gpsLat, Tarray.size + RIGHT + CUSTOM_COLOR)
				lcd.drawText(zone.zone.x + Tarray.x2, zone.zone.y + Tarray.y1+ Tarray.y2+13,"  " .. gpsLon, Tarray.size + RIGHT + CUSTOM_COLOR)
				lcd.drawText(zone.zone.x + Tarray.x2- 120, zone.zone.y + Tarray.y1+ Tarray.y2, "Lat:  ", Tarray.size + LEFT + CUSTOM_COLOR)
				lcd.drawText(zone.zone.x + Tarray.x2- 120, zone.zone.y + Tarray.y1+ Tarray.y2+13, "Lon:  ", Tarray.size + LEFT + CUSTOM_COLOR)

			end
		end															-- end of "drawtext block"

		
		
		--								draw icon if bmp not "dummy"
		if Tarray.bmp ~= "dummy" then
			icon = Bitmap.open(Tarray.bmp)
			lcd.drawBitmap(icon, zone.zone.x + Tarray.x1, zone.zone.y + Tarray.y1)
		end
	
	end
	return
end




---------------
-- main loop --
---------------

function refresh(myZone)

	local x = 0
	local y = 0
	local arrayOffset = 0
  
--	transparency = 1  									-- test purpose
--	if getValue("sb")  > 0 then transparency =0 end		
  
	-- draw background if "transparency"  set to 0
	if transparency  ~= 1 then 
		  	lcd.setColor(CUSTOM_COLOR, WHITE)
			lcd.drawFilledRectangle(myZone.zone.x, myZone.zone.y, 180, 70, CUSTOM_COLOR)
	end
	
	if getValue(aOffs) > 0 then arrayOffset = 2 end			-- choose "page"


--											draw Values		( "nRows = number of lines")								
	for i=1,nRows,1 do  
			drawVal(teleArray[1+arrayOffset][i],myZone)		-- left column
			drawVal(teleArray[2+arrayOffset][i],myZone)		-- right column
	end

end


return { name="Telenowa", options=options, create=create, update=update, background=background, refresh=refresh }

