library(shiny)
library(shinydashboard)
library(shinycssloaders)
library(shinythemes)
library(shinyWidgets)
library(tidyverse)
library(toastui)
library(highcharter)
library(readxl)
library(plotly)
library(RMySQL)
library(shinyjs)
library(DT)
library(formattable)
library(zoo)
library(leaflet)

listing <- read_xlsx("C:/Users/YexSys/Desktop/upgrade/listing_verifier/data/PRADA Publisher Check 202311.xlsx", sheet = 2)
listing %>% 
  select(-c(URL,Comment)) -> listing

# #链接数据库
# con <- dbConnect(
#   MySQL(),
#   host='123.60.28.175',
#   user='xusu',
#   password='Yexsys2023',
#   dbname='yexsys_test'
# )
# #SQL query，拉出poi beta中burbeery的active的门店的名称和yid
# burberry_yid_query <- paste0("SELECT name,yid,lat,lng FROM yexsys_test.poi_beta WHERE brandId = 516 AND is_active=1 AND business_status=1;")
# #执行语句
# burberry <- dbGetQuery(con,burberry_yid_query)
# #生成yid list, 用于拉取pid 数据
# yid_list <- burberry %>% distinct(yid) %>% filter(!is.na(yid)) %>% pull(yid)
# #利用yid list执行SQL语句，拉取poi listing表中相关yid对应的pid，以及url
# burberry_pid_query <- paste0("SELECT yid,pid,url FROM yexsys_test.poilisting_status WHERE yid IN ('",paste(yid_list,collapse = "','"), "');")
# #执行语句
# burberry_pid <- dbGetQuery(con, burberry_pid_query)
# #利用url的特性筛选出腾讯的poi id行
# burberry_pid %>% filter(str_detect(url,"https://map.qq.com")) %>% select(-url) -> burberry_pid
# #得到burbeery的yid, pid, 门店名称的表
# #部分门店可能没有腾讯地图PID
# left_join(burberry, burberry_pid, by = "yid") -> burberry
# 
# #百度商户通
# #直接使用的整理好的Burberry百度商户通数据，数据库中相关数据我不知道在那
# baidu <- read_xlsx("C:\\Users\\YexSys\\Desktop\\upgrade\\map_dashboard\\map_dashboard\\data/shop_baidu.xlsx")
# #去除无用列(id, b_uid,pid)，将yid格式修改为numeric，updatetime格式修改成date
# #这一段操作针对本地读取的excel文件，如果找到数据库中相关的数据条，对其做对应修改
# baidu %>% select(-c(id,b_uid,pid)) %>% mutate(yid = as.numeric(yid),updatetime = as.Date(updatetime)) -> baidu
# #百度相关数据都是updatetime的前一天
# baidu %>% mutate(date = updatetime-1) %>% select(-updatetime) -> baidu
# #将yid对应的门店名称插入到表里
# inner_join(burberry,baidu,by = "yid") -> burberry_baidu
# burberry_baidu %>% 
#   mutate("曝光次数" = yesterday_show_cnt,
#          "意向顾客数量" = yesterday_intent_cnt,
#          "收藏次数累计值" = yesterday_favor_cnt,
#          "新增评论数" = yesterday_comment_cnt) %>% 
#   select(-c(yesterday_show_cnt,yesterday_intent_cnt,yesterday_favor_cnt,yesterday_comment_cnt,pid)) %>% 
#   group_by(yid,name) %>% 
#   complete(date = seq(min(date), max(date), by = "1 day")) %>% 
#   ungroup() -> burberry_baidu
# 
# #腾讯商户通
# #拿出所有的pid组成list
# burberry %>% distinct(pid) %>% filter(!is.na(pid)) %>%  pull(pid) -> pid_list
# #SQL语句，仅拉取poi listing中记录的burbeery tencent id对应的腾讯商户通数据
# burberry_tencent_query <- paste0("SELECT time AS date,shopname,tx_id AS pid,shoptotaltc,shopwechattc,shopwechatts,shopmaptc,shopmapts,collect_cnt,index_num FROM yexsys_test.wechat_shop_center WHERE tx_id IN ('",paste(pid_list,collapse = "','"), "');")
# #执行语句
# burberry_tencent <- dbGetQuery(con, burberry_tencent_query)
# #整理数据格式，看了看好像就这些是有用的，也可以改一下SQL语句拉取的时候直接改
# burberry_tencent %>% 
#   mutate(date = as.Date(date)) %>% 
#   group_by(pid, date) %>% 
#   mutate(shoptotalts = sum(shopwechatts, shopmapts, na.rm = TRUE)) %>% 
#   select(pid, date,shoptotalts, shoptotaltc, collect_cnt, shopmapts, shopwechatts) %>% 
#   left_join(burberry,by = "pid") %>% 
#   group_by(yid,pid,name) %>% 
#   complete(date = seq(min(date), max(date), by = "1 day")) -> burberry_tencent
# # write_xlsx(burberry_tencent, "C:\\Users\\YexSys\\Desktop\\wework/burberry_tencent.xlsx")
# #断链
# dbDisconnect(con)
# 
# #合成总表
# full_join(burberry_baidu,burberry_tencent, by = c("yid","name","date","lat","lng")) -> burberry_full
# burberry_full %>% 
#   # mutate(collect_cnt = round(na.approx(collect_cnt),0),
#   #        收藏次数累计值 = round(ifelse(is.na(收藏次数累计值),na.approx(收藏次数累计值), 收藏次数累计值),0)) %>% 
#   group_by(yid) %>% 
#   mutate(collect_daily = lag(collect_cnt),
#          collect_daily = ifelse(is.na(collect_daily),collect_cnt,collect_daily),
#          collect_daily = collect_cnt - collect_daily,
#          收藏次数当日值 = lag(收藏次数累计值),
#          收藏次数当日值 = ifelse(is.na(收藏次数当日值),收藏次数累计值,收藏次数当日值),
#          收藏次数当日值 = 收藏次数累计值 - 收藏次数当日值) %>% 
#   ungroup() -> burberry_full
