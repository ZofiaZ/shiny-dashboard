## Functionalities:
- `map` - add change to previous time range per country (percantage)
- create 3d chart (for example: metrics by product type)
- add ability to enlarge charts (view full screen)
- add export and print functionalities
- add more metrics: mean values, complaints per number of orders ratio, profit per order etc. depending on business needs
- nice to have: add ability to filter data by country
- nice to have: add ability to filter data by product type

## UX & UI improvements:
- `map` - display countries data up front (not as a tooltip visible only on hover)
- add `loaders`
- format large numbers
- `time chart` - consider changing bars to line chart and display current & previous values (instead of diff value)
- `time chart` - improve hover look & feel and interaction
- `time filters` change previous time range radio buttons look & feel to nicer button switch

## Technical:
- learn about `data structures` in R & organize data in a better way
- prevent errors & handle edge cases
- separate `data processing` (for example: calculating change values with normalization based on number of days) from `sample data generation` script. Create data processing functions that operate on vectors (avoid multiple mapply). Add data processing to app (outside server function call).
- learn about R designs patterns & best practices and apply them in R shiny app
- add tests

## Bugfixing
- add support for IE11 and edge (for example: don't use material icons ligatures that are not supported on IE11)
- test with screen readers, fix accessibility issues, add meaningful aria tags