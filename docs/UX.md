#### UX design assumptions:

1. There is no business need for comparing 2 different types of charts in 2 different periods of time (eg. daily production costs in June 2018 with sales revenue by country map in July 2018). Users would always select the same time range for all charts and therefore would benefit from having one `global time range filter` that updates all stats at one go. 
2. Not all data may be available for all charts (for example: production takes place just in one place in the United States, so displaying production cost metric on the country map wouldn't make sense). Therefore `metrics should be selected per chart` (not as a global filter).
3. Users will often compare months with `previous month` or `previous year` and those 2 options should be available for MVP.
4. For not completed months, or months with different number of days the percentage increase/decrease might be misleading. For example comparing current, not completed month with previous month would often show a decrease. Therefore it makes sense to normalize previous values based on the number of days. I used formula `prev_value_normalized = prev_value * no_of_days_in_selected_period / no_of_days_in_previous_period`
5. Each user may want to have different metrics selected by default and would benefit from selected metrics being `saved in local storage` and restored next time the app is opened.
6. Client needs the export and print functionalities but will use it rarely (therefore it can be added later and it could be hidden behind some "more" action icon).
7. Metrics that the client uses can be grouped into 4 logical categories:
- **sales metrics**: revenue, profit, number of orders
- **production metrics**: production costs, number of produced items
- **users-related metrics**: active users, users that dropped out from sales process
- **complaints metrics**: opened complaints, closed complaints
8. Client wants to add more metrics in the future. Design needs to be `scalable` and easily accomodate a few new metrics. (Please note that if a lot of them needs to be added, they should be grouped into multiple dashboards in separate tabs/pages)
9. Clients sells products just in 6 markets at the moment (countries displayed on the map)

Additional assumption: I was considering for a while displaying a decrease in metrics such as `complaints` in green and increase in red (as decrease in this case is a desired state). However I have doubts if this helps in reading the summary data or rather introduces more cognitive dissonance. The code that changes the CSS class in such cases is implemented, however I intentionally left the colors consistent in all scenarios for the time being (so all values below zero are red and above - green).


See [TODO list](TODO.md) for a list of known issues, and suggested UX & UI improvments.