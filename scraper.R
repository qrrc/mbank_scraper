library(rvest)
library(reshape)

# set date range:
start_date = '2020-4-15'
end_date   = '2020-4-20'
    
# create links:
dates = as.character(seq(as.Date(start_date), as.Date(end_date), by="days"))

years  = format(as.Date(dates,format="%Y-%m-%d"), format = "%Y")
months = format(as.Date(dates,format="%Y-%m-%d"), format = "%m")
days   = format(as.Date(dates,format="%Y-%m-%d"), format = "%d")

links = paste0("https://www.mongolbank.mn/eng/dblistofficialdailyrate.aspx?vYear=", 
years, "&vMonth=", months, "&vDay=", days)

# create database:
d = data.frame()

for(i in 1:length(links)){
    print(i)

    link  = links[i]
    date  = dates[i]
    
    # extract currencies:
    web_data = html_table(read_html(link), fill = TRUE)
    web_data = web_data[5:length(web_data)]
    web_table = merge_all(web_data)[,c('X2', 'X3')]
    web_table$X3 = gsub(',', '', web_table$X3)
    row.names(web_table) = web_table$X2
    
    for(column in web_table$X2){
        d[date, column] = web_table[column, 'X3']
    }
}

print(d)
write.csv(d,'output.csv')
