


Stocks_ZZ<-read_excel('//Users//wulixin//Desktop//中证股息率与市净率.xls',sheet="个股数据")

Stocks_ZZ$个股静态市盈率<-as.numeric(Stocks_ZZ$个股静态市盈率)
Stocks_ZZ$个股市净率<-as.numeric(Stocks_ZZ$个股市净率)
Stocks_ZZ$个股滚动市盈率<-as.numeric(Stocks_ZZ$个股滚动市盈率)
Stocks_ZZ$个股股息率<-as.numeric(Stocks_ZZ$个股股息率)

Stocks_ZZF<-Stocks_ZZ%>%select("证券代码","证券名称","一级行业名称","四级行业名称","个股静态市盈率","个股滚动市盈率","个股市净率","个股股息率")            
datatable(Stocks_ZZF,caption = '指数表现:重点关注成交量变化,累计涨幅',
          filter = 'top',extensions = 'Buttons', options = list(pageLength = 100, 
                                                                autoWidth = TRUE,dom = 'Bfrtip',buttons = c('copy', 'csv', 'excel', 'pdf', 'print')))|>
  formatStyle('一级行业名称',  color = 'red', backgroundColor = 'pink', fontWeight = 'bold')|>
  formatStyle('四级行业名称',  color = 'red', backgroundColor = 'orange', fontWeight = 'bold')|>
  formatStyle('证券名称',  color = 'black', backgroundColor = 'lightblue', fontWeight = 'bold')


###行业股息率

Stocks_Z<-read_excel('//Users//wulixin//Desktop//中证股息率与市净率.xls',sheet="中证行业股息率")

len(Stocks_Z$行业代码)

