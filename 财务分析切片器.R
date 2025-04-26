#########################################################################
#
#
#               AI训练切片器技能高级--财务报表分析
#  
#
########################################################################
library(xyplot)
#######################设计思路
#数据准备：
#假设你已经有按年份和月份整理的财务数据，存储在CSV文件中。
#数据应包括三张报表的关键指标，以及日期信息（年份和月份）。
#数据读取与预处理：
#使用readr包读取CSV文件。
#转换日期列为日期格式，便于后续处理。聚合数据以计算同比和环比变化。

######################UI设计：
#使用sidebarLayout布局，左侧为切片器（选择年份、月份、报表类型），右侧为表格和图形展示区。
#切片器可以使用selectInput、sliderInput等组件。
#表格使用DT::renderDataTable展示。
#图形使用ggplot2绘制，并通过plotOutput展示。
######################服务器逻辑：
#根据切片器的选择，过滤和计算数据。
#返回过滤后的数据给UI组件进行展示。
#同比和环比计算：
#同比：与去年同期相比的变化。
#环比：与上个月相比的变化。
#可以使用dplyr包的窗口函数来计算这些变化。

#以下是一个简化的示例，展示了如何设置UI和服务器逻辑，以及如何进行基本的同比和环比计算。

# 安装并加载必要的包
library(shiny)
library(DT)
library(ggplot2)
library(dplyr)
library(readr)

# 读取财务数据（假设数据存储在CSV文件中）
# financial_data <- read_csv("path_to_your_financial_data.csv")
# 由于无法直接读取文件，这里创建一个示例数据集
financial_data <- data.frame(
  date = as.Date(rep(seq(as.Date("2022-01-01"), by = "month", length.out = 12), 2)),
  year = rep(2022:2023, each = 12),
  month = rep(1:12, 2),
  report_type = rep(c("Balance Sheet", "Income Statement"), each = 12),
  metric = sample(1000:10000, 24), # 示例指标
  stringsAsFactors = FALSE
)

# UI设计
ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      selectInput("report_type", "选择报表类型", choices = c("Balance Sheet", "Income Statement", "Cash Flow Statement")),
      sliderInput("year", "选择年份", min = min(financial_data$year), max = max(financial_data$year), value = min(financial_data$year):max(financial_data$year)),
      sliderInput("month", "选择月份", min = 1, max = 12, value = 1:12)
    ),
    mainPanel(
      DT::dataTableOutput("table"),
      plotOutput("plot")
    )
  )
)

# 服务器逻辑
server <- function(input, output, session) {
  # 过滤数据
  filtered_data <- reactive({
    financial_data %>%
      filter(report_type == input$report_type,
             year %in% input$year,
             month %in% input$month)
  })
  
  # 计算同比和环比变化
  calculated_data <- reactive({
    filtered_data() %>%
      arrange(date) %>%
      mutate(yoy_change = (metric / lag(metric, n = 12, default = first(metric)) - 1) * 100, # 同比变化
             mom_change = (metric / lag(metric, n = 1, default = first(metric)) - 1) * 100) %>% # 环比变化
      select(-metric) # 移除原始指标列（可选）
  })
  
  # 展示表格
  output$table <- DT::renderDataTable(calculated_data())
  
  # 绘制图形
  output$plot <- renderPlot({
    ggplot(calculated_data(), aes(x = as.factor(date), y = metric, color = as.factor(year))) +
      geom_line() +
      geom_point() +
      facet_wrap(~ report_type) +
      labs(title = "财务指标随时间变化",
           x = "日期",
           y = "指标值") +
      theme_minimal()
    # 注意：这里的图形没有直接展示同比和环比变化，你可以根据需要调整aes和geom层来展示这些变化。
  })
}

# 运行应用
shinyApp(ui = ui, server = server)
#注意事项
#数据格式：确保你的财务数据格式与示例代码中的格式相匹配，特别是日期和报表类型列。
#同比和环比计算：示例代码中的同比和环比计算是简化的，可能需要根据你的具体需求进行调整。
#图形展示：示例代码中的图形展示没有直接展示同比和环比变化，你可以使用geom_bar、geom_col等图形类型来展示这些变化，或者添加额外的图层来标注变化率。
#性能优化：对于大型数据集，可能需要考虑性能优化，如使用数据缓存、减少数据渲染次数等。
#安全性：在实际应用中，需要注意数据的安全性，避免敏感信息泄露。