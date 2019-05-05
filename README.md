# Girls in Tech
![img.jpg](img.jpg)

## Overview

**Obejctive**: Most of people think that increasing agriculture production can alleviate the hunger problem over world, while it results in the increase of CO2 emission and contribute global warming. This project explores global CO2 emission data, food production data and undernourishment population data to explore whether this paradox true exists.

**Product**: [Shiny App]()
- Input: Year slider - Flexible select year range of interest
- Output:
  - Dashboard:
    - Time Series Data: Line plots of variables changing over time
    - Emission Data: Point plots of relationship between Emissions and Global CO2
    - Undernourishment Data: Point plots of undernourishment and Global CO2
- Data
- Info
- Source Code


**Observation**: Data visualizations in our shinny app shows that while agriculture production increases, undernourishment index does not decrease and global warming keeps exacerbating.

## Contributor
| Team Member Name  | Github  Handle   |
|-------------------|------------|
| Jielin Yu         | @jielinyu   |
| Jingyun Chen      | @jchen9314  |
| Sylvia Lee        | @LeeYinYing |
| Zixin Zhang       | @zxzzhangg  |

## Data
The below is the description of our data table.

| Variable Name        | Description                                                       | Unit     |
|----------------------|-------------------------------------------------------------------|----------|
| Year                 | Range from 1961 to 2016                                           | year     |
| Livestock Emission   | Total amount of GHG emissions from livestocks.                    | Gigagram |
| Livestock Value      | Total meat production from both commercial and farm slaughter.    | Head     |
| Agriculture Emission | Total amount of GHG emissions from agriculture.                   | Gigagram |
| Agriculture Value    | Various food and agriculture commodities’,gross production values | $US      |
| Undernourishment     | Rate of undernourishment                                          | N/A      |

## Reference
Our data are get from the FAO organization(Food and Agriculture Organization of the United Nations).

[Livestock Primary](http://www.fao.org/faostat/en/#data/QL)

[Value of Agricultural Production](http://www.fao.org/faostat/en/#data/QV)

[Agriculture Total](http://www.fao.org/faostat/en/#data/GT)

[Emissions intensities](http://www.fao.org/faostat/en/#data/EI)

[Suite of Food Security Indicators](http://www.fao.org/faostat/en/#data/FS)
