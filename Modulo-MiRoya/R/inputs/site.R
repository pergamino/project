site= function(){
  list(
    Location      = "Aquiares",     # Site location name (optional)
    Start_Date    = "1979/01/01",   # Start date of the meteo data, only used if "Date" is missing from input Meteorology (optionnal)
    Latitude      = 9.93833,        # Latitude (degree)
    Longitude     = -83.72861,      # Longitude (degredd)
    TimezoneCF    = 6,              # Time Zone
    Elevation     = 1040,           # Elevation (m)
    ZHT           = 25,             # Measurment height (m)
    extwind       = 0.58,           # Wind extinction coefficient (-), used to compute the wind speed in the considered layer. Measured on site.
    albedo        = 0.144,          # Site albedo, computed using MAESPA.
    CO2           = 374
    
  )
}
