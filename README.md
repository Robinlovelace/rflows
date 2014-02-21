# Employment density in Merseyside

## Find all oas in Merseyside


```r
oas <- read.dbf("/home/robin/Data-pure/2001-census/oa/england_oa_2001_gen.dbf")
head(oas)
```

```
##        LABEL    CTRY
## 1 00HBNN0029 England
## 2 18ULGH0002 England
## 3 30UPGT0003 England
## 4 16UGHM0005 England
## 5 16UGJY0005 England
## 6 16UEGQ0001 England
```

```r
summary(oas[grepl("00BX|00BY|00BZ|00CA|00CB", oas$LABEL), ])
```

```
##         LABEL           CTRY     
##  00BXFJ0011:   3   England:4681  
##  00BYFK0014:   3                 
##  00CBFU0052:   3                 
##  00BXFB0002:   2                 
##  00BXFC0004:   2                 
##  00BXFF0005:   2                 
##  (Other)   :4666
```

```r
mers <- grepl("00BX|00BY|00BZ|00CA|00CB", oas$LABEL)
```


## Plot to check they're correct


```r
library(rgdal)
```

```
## Loading required package: sp
## rgdal: version: 0.8-14, (SVN revision 496)
## Geospatial Data Abstraction Library extensions to R successfully loaded
## Loaded GDAL runtime: GDAL 1.10.0, released 2013/04/24
## Path to GDAL shared files: /usr/share/gdal/1.10
## Loaded PROJ.4 runtime: Rel. 4.8.0, 6 March 2012, [PJ_VERSION: 480]
## Path to PROJ.4 shared files: (autodetected)
```

```r
# goa <- readOGR(dsn='/home/robin/Data-pure/2001-census/oa/',
# layer='england_oa_2001_gen') mers <- goa[mers,] plot(mers) rm(goa)
# save.image('mers.RData')
load("mers.RData")
plot(mers)
```

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-2.png) 

```r
oldMersData <- mers@data
```


## Load flow data and calculate total flows in


```r
# uk.oa.flow <- read.csv('~/Desktop/W301_OUT.csv') This file's half a Gib
# big!  mflow <- uk.oa.flow[which(uk.oa.flow$X00AAFA0001.1 %in% mers$LABEL
# ),]
head(mflow)
```

```
##       X00AAFA0001 X00AAFA0001.1 X19 X0 X19.1 X16 X0.1 X16.1 X0.2 X0.3 X0.4
## 1597   00ABFX0018    00BXFQ0006   3  0     3   0    0     0    0    0    0
## 3236   00ABFZ0002    00BYGC0005   3  0     3   0    0     0    0    0    0
## 9686   00ABGE0022    00BYFR0031   3  0     3   0    0     0    0    0    0
## 13936  00ABGJ0017    00BZFL0014   3  0     3   0    0     0    0    0    0
## 14850  00ABGK0013    00BYGA0044   3  0     3   0    0     0    0    0    0
## 17777  00ABGN0007    00BXFR0009   3  0     3   0    0     0    0    0    0
##       X0.5 X0.6 X0.7 X3 X0.8 X3.1 X0.9 X0.10 X0.11 X0.12 X0.13 X0.14 X0.15
## 1597     0    0    0  3    0    3    0     0     0     0     0     0     0
## 3236     0    0    0  0    0    0    0     0     0     3     0     3     0
## 9686     0    0    0  0    0    0    0     0     0     3     0     3     0
## 13936    0    0    0  0    0    0    0     0     0     3     0     3     0
## 14850    0    0    0  0    0    0    0     0     0     3     0     3     0
## 17777    0    0    0  3    0    3    0     0     0     0     0     0     0
##       X0.16 X0.17 X0.18 X0.19 X0.20 X0.21 X0.22 X0.23 X0.24 X0.25 X0.26
## 1597      0     0     0     0     0     0     0     0     0     0     0
## 3236      0     0     0     0     0     0     0     0     0     0     0
## 9686      0     0     0     0     0     0     0     0     0     0     0
## 13936     0     0     0     0     0     0     0     0     0     0     0
## 14850     0     0     0     0     0     0     0     0     0     0     0
## 17777     0     0     0     0     0     0     0     0     0     0     0
##       X0.27 X0.28 X0.29
## 1597      0     0     0
## 3236      0     0     0
## 9686      0     0     0
## 13936     0     0     0
## 14850     0     0     0
## 17777     0     0     0
```

```r
tmflow <- aggregate(mflow[, 3] ~ mflow$X00AAFA0001.1, FUN = sum)
names(tmflow) <- c("LABEL", "inflow")
mers@data <- join(mers@data, tmflow)
```

```
## Joining by: LABEL, inflow
```

```r
head(mers@data)
```

```
##        LABEL    CTRY inflow
## 1 00BYGC0002 England   1815
## 2 00CAGD0004 England    213
## 3 00CBFU0014 England     20
## 4 00CBFJ0022 England     24
## 5 00CBFJ0009 England     62
## 6 00CBFU0004 England     95
```

```r
plot(coordinates(mers), cex = mers$inflow/1000)  # test it makes sense: largest circles in centre?
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3.png) 

```r
writeOGR(mers, dsn = ".", "mersin", driver = "ESRI Shapefile")
```

```
## Error: layer exists, use a new layer name
```

```r
summary(mers)
```

```
## Object of class SpatialPolygonsDataFrame
## Coordinates:
##      min    max
## x 316169 361791
## y 377193 423531
## Is projected: TRUE 
## proj4string :
## [+proj=tmerc +lat_0=49 +lon_0=-2 +k=0.9996012717 +x_0=400000
## +y_0=-100000 +datum=OSGB36 +units=m +no_defs +ellps=airy
## +towgs84=446.448,-125.157,542.060,0.1502,0.2470,0.8421,-20.4894]
## Data attributes:
##         LABEL           CTRY          inflow     
##  00BXFJ0011:   3   England:4681   Min.   :    3  
##  00BYFK0014:   3                  1st Qu.:   15  
##  00CBFU0052:   3                  Median :   28  
##  00BXFB0002:   2                  Mean   :  116  
##  00BXFC0004:   2                  3rd Qu.:   70  
##  00BXFF0005:   2                  Max.   :30171  
##  (Other)   :4666                  NA's   :33
```






