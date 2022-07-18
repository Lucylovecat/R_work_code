analysis_data <-  actual_weather_20220717 %>% as.data.table() %>%  select(date, hh,StnPres, TX01, RH) %>%
                        transmute( "yearmon" =  as.numeric(format(date, format = "%Y%m")),
                                   hh, StnPres, TX01, RH,
                                   'enthalpy' = Calcu_Enthalpy( TX01,RH , StnPres) )
