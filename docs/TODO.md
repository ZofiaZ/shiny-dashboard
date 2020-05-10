## Functionalities:
- `map` - add percentage increase/decrease (change to previous year/month) to the metric per country map
- create 3d chart (for example: metrics by product type)
- add ability to enlarge charts (view full screen)
- add export and print functionalities
- add more metrics: mean values, complaints per number of orders ratio, profit per order etc. depending on business needs
- nice to have: add ability to filter data by country
- nice to have: add ability to filter data by product type
- nice to have: custom time selection (date picker)

## UX & UI improvements:
- `map` - display countries values up front (not as a tooltip visible only on hover)
- `map` - create a better color pallette that is not dependent on data fluctuations
- add `loaders` (!)
- format large numbers
- `time chart` - consider changing bars to line chart and display current & previous values (instead of diff value)
- `time chart` - improve hover look & feel and interaction
- `time filters` - change previous time range radio buttons look & feel to nicer button switch
- `all charts` - recalculate charts height based on viewport height (would be nice to fill all vertical space on large screens)
- use different colors for metrics from different groups (for example: blue for sales data, green for users data, red for complaints)

## Technical:
- learn about `data structures` in R & organize data in a better way
- prevent errors & handle edge cases
- separate `data processing` (for example: calculating change values with normalization based on number of days) from `sample data generation` script. Create data processing functions that operate on vectors (avoid multiple mapply). Add data processing to app (outside server function call).
- learn about R designs patterns & best practices and apply them in R shiny app
- add tests

## Bugfixing
- add support for IE11 and Edge
- test with screen readers, fix accessibility issues, add meaningful aria tags