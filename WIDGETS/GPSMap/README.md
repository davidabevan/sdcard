# Frsky Horus GPS Map

Note:
Based on Tonnie78 (Tonnie Oostbeek) his Lua GPS Widget project https://github.com/Tonnie78/Lua-GPS-Widget





-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


Creates a Horus Widget to show Plane location on a map that is placed on the screen as an image


![alt text](https://github.com/Hobby4life/Lua-GPS-Widget/blob/master/GPSMap.png)

https://youtu.be/QPWba8dwc1w

What's on the screen?

**Home Point** - A Windsock is visible when HomePoint is set, first time GPS lock will set HomePoint. HomePoint will also be set if a Reset is triggered. A the base of HomePoint there is also a True Bearing visible from HomePoint to Plane.

When the plane is outside visibility of the 3 Map zoom range, "OUT OF RANGE" message will apear.


**Speed/Max** - Is calculated from the **GSpd** sensor, select **km/h** or **mph** at the sensor page. And set **Imperial** in the widget settings screen accordingly

**Alt/Max** - Is calculated from the **Alt** sensor, select **m** or **ft** at the sensor page. And set **Imperial** in the widget settings screen accordingly

**Dist/Max** - Is calculated from GPS sensor itself it is realtime calculated when moving, select **m** or **ft** at the sensor page. And set **Imperial** in the widget settings screen accordingly

**LoS** - calculated from **Dist** and **Alt**

**Satellites** - Only visible if OpenXSensor is used with sensor **Tmp1** as satellites in view output

**Heading** - Is calculated from GPS sensor itself it is realtime calculated when moving

**Lat/Long** - Actual GPS coordinates in Decimal

**Version Number** - Firmware version


**-------------------- Description of usage: --------------------**

**1.** Create a fullscreen widget page, disable "Top Bar" and "Sliders"**

**2.** Load the GPSMap widget**

**3.** Setting up widget settings**

![alt text](https://github.com/Hobby4life/Lua-GPS-Widget/blob/master/widgetsettings.png)

 **ResetAll** - Define a source for trigger a reset of al max values and set new HomePoint
 
 **Imperial** - Toggle between Metric or Imperial notation, note that correct settings have to be set on the sensor page too!

 **LosLine** - Enable / Disable line of sight line between Home point and plane. 0 = off, 1 = on

 **MapSelect** - Select Map to load, needs model change or power cycle to take effect, 0 correnspondents to **map0small.png**, **map0medium.png** and **map0large.png** etc...

Maps can be generated at the following page: https://hobby4life.nl/mapgen

In the **main.lua** file

Look for the following lines:

```
Version     = "v2.9"  -- Current version
  
TotalMaps   = 4       -- Enter the amount of maps loaded, starts with 0 !!!!
```
At TotalMaps you see number 4, adjust it according maps that are located in the widget folder.

and in main.lua look for the following lines..

Copy and paste the generated coordinates here. add a if statement when adding new.

```
if LoadMap == 0 then

  -- Avenhorn ---

  -- coordinates for the small map.

  map.North.small = 52.633785

  map.South.small = 52.614104

  ..

  ..

  ..

  elseif LoadMap == 1 then


  -- MVC Pegasus ---

  -- coordinates for the small map.

  map.North.small = 52.734818

  map.South.small = 52.731422

  ..

  ..

  ..

  elseif LoadMap == 2 then

  
  -- MVC Kampen

  -- coordinates for the small map.

  map.North.small = 52.559801

  map.South.small = 52.554921

```


For each new map, add a new "  elseif LoadMap == X then "


**------------GV9-----------**


**GV9** in OpentX acts as a Noflyzone indicator.

Toggles between 0 or 1 depends on the plane crossing wich side of the NoflyZone line.

You can use **GV9** to enable alarms etc.



