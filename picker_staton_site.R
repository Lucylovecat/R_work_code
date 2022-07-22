#套件載入 設定工作資料夾  
#picker_station()
# 6/28  "467440","C0V500"  測站廢除
library(dplyr)
library(rvest) #網路爬蟲簡易函式庫


updatedate<- read_html("https://e-service.cwb.gov.tw/wdps/obs/state.htm") %>% 
  html_nodes( "#description+ div") %>% 
  html_text() ##查詢更新版本}

updatedate <-updatedate %>% gsub(pattern="(",replacement="",fixed = T) %>%
                             gsub(pattern="更新)",replacement="",fixed = T)%>%
                             gsub(pattern="/",replacement="",fixed = T)


if (updatedate == "20220721" ){ 
  print(paste0( "資料不須更新，目前版本:", updatedate,"，請讀取檔案"))
  stn_adress <- readRDS(paste0('D:/R_workspace/Crawler/Data/stn_data/stn_adress_',updatedate,'.RDS'))
  #print(noquote("stn_adress <- readRDS('D:/R_workspace/Crawler/Data/stn_data/stn_adress_20220628.RDS')"))
  rm(updatedate)
  } else{ 
  content<- read_html("https://e-service.cwb.gov.tw/wdps/obs/state.htm") %>% 
    html_nodes( "th,td") %>% 
    html_text() 
  
  content[c(which(content == "" ))] <-  "NA" 
  stn_adress <- matrix(unlist(strsplit(content[13:(which(content == "站號" )[2]-1)], ",")),
                       byrow=T,ncol = 12)  %>%   as.data.frame() 
  
  colnames(stn_adress) <-  c("stationID","stationName","stationAltitude","longitude",
                             "latitude","cityName","stationAddress","startDate","endDate",
                             "note","originalStationID","newStationID")
  
  stn_adress <- stn_adress[-c(which(stn_adress$stationID %in%c("466850","467790","467440","C0V500") == 1)),]# 無資料的站號
  
  rownames(stn_adress) <- c(1:length(stn_adress$stationID))
  saveRDS(stn_adress,paste0("D:/R_workspace/Crawler/Data/stn_data/stn_adress_"
                            ,updatedate, ".RDS"))
  print(paste("資料有更新，目前版本:",updatedate))
  rm(content)
  rm(updatedate)
} # 函數結尾


