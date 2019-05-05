# Girls in Tech
![img.jpg](img.jpg)

## Overview

**Objective**: Most of the people think that increasing agriculture production can alleviate the hunger problem overworld, while it results in the increase of CO2 emission and contributes global warming. This project explores global CO2 emission data, food production data and undernourishment population data to explore whether this paradox true exists.

**Product**: [Shiny App](https://sylvai19.shinyapps.io/the_hunger_game/)
- Input: Year slider - Flexible select year range of interest
- Output:
  - Dashboard:
    - Time Series Data: Line plots of variables changing over time
    - Emission Data: Point plots of the relationship between Emissions and Global CO2
    - Undernourishment Data: Point plots of undernourishment and Global CO2
- Data
- Info
- Source Code

**Significance**:

With this project we found that increasing food production does not seem to decrease the proportion of unnourished population in the world. However, increased food production in the recent years seems to correlate and contribute to the increase in atmospheric GHG. This suggests that other factors are at play. Some possible reason may be due to unbalanced distribution of food between developed and undeveloped countries and subsequently increased food waste in developed countries. This speculation needs to be further backed up by research. In the future, the insight gained from this project can be further expanded with more exploration in international food trade and comparison of waste generation between the first-world and third-world countries.

This is important to gender equality as well because the women is often at most pressure in feeding the family. From this project we see that the increase in food production does not help empower women in third-world countries. Thus, investigating this problem may help alleviate gender inequalities in addition to slowing global warming.

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
| Livestock Emission   | Total amount of GHG emissions from livestock.                    | Gigagram |
| Livestock Value      | Total meat production from both commercial and farm slaughter.    | Head     |
| Agriculture Emission | Total amount of GHG emissions from agriculture.                   | Gigagram |
| Agriculture Value    | Various food and agriculture commodities’, gross production values | $US      |
| Undernourishment     | Rate of undernourishment                                          | N/A      |

## Reference
Our data are get from the FAO organization(Food and Agriculture Organization of the United Nations).

[Livestock Primary](http://www.fao.org/faostat/en/#data/QL)

[Value of Agricultural Production](http://www.fao.org/faostat/en/#data/QV)

[Agriculture Total](http://www.fao.org/faostat/en/#data/GT)

[Emissions intensities](http://www.fao.org/faostat/en/#data/EI)

[Suite of Food Security Indicators](http://www.fao.org/faostat/en/#data/FS)
