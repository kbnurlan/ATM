
#options("install.packages.compile.from.source" = "never")
#setwd('fimi-main')
library(telegram.bot)
library(tidyverse)
library(gridExtra)
library(lubridate)
library(grid)

df = readxl::read_excel('last_down.xlsx') %>% 
  select(ATM_ID,Address,everything()) %>% 
  select(ATM_ID,Address,Device,Elapsed_time) %>% 
  filter(Elapsed_time>=0)

df_ = readxl::read_excel('last_problem.xlsx') %>% 
  transmute(ATM_ID,   Address,
            Device=paste(Device,value,sep = '_'),
            Elapsed_time,
  ) %>%
  filter(Elapsed_time>=0)

df_ = df_ %>% filter(!stringr::str_detect(Address ,'NOT|Preprod|Aqro')) %>%
  filter(!stringr::str_detect(Device ,'Card_module|status'))


ceyhun = readxl::read_excel('terminal 2.xlsx')


reg=paste('k',paste0(rep('[0-9]',7),sep = '',collapse = ''),sep = '')

ceyhun = ceyhun %>% mutate(ATM_ID = stringr::str_extract(Unvan,stringr::regex(reg,ignore_case = T)) %>%
                             stringr::str_to_upper()
)

df_ = df_ %>% mutate(ATM_ID = stringr::str_to_upper(ATM_ID)) %>% left_join(ceyhun) %>%
  select(-Unvan)

print('after join')
print(head(df))
print(head(df_))
df = df %>% mutate(BB=ifelse(stringr::str_starts(ATM_ID,'A0100'),
                             'Baki','Region'))  %>% bind_rows(df_ %>% filter(!is.na(BB))  )
print('BB')

#print(Sys.getenv('BOT_ID'))
# Initialize bot
bot <- Bot(token = "5151173984:AAGTHrowMy5RfI7F3h62-H3GPPmC4NA3Sdw")

# Chat id
Baki_texniki <- -1001509736694

RIM_Texniki <- -1001639372523

zones = data.frame(zones=c('Baku','RIM'),id=c(Baki_texniki,RIM_Texniki))
print('Done 1')
for ( i in 1:nrow(zones)) {
  cur_zone = zones$zones[i]
  print('start loop')
  if(cur_zone=='Baku') {
    #df_ = df %>% filter(stringr::str_starts(ATM_ID,'A0100'))
    df_1 = df %>%  filter(substr(BB,0,3)=='Bak') %>% select(-BB)
  } else {
    #df_ = df %>% filter(!stringr::str_starts(ATM_ID,'A0100'))
    df_1 = df %>%  filter(!substr(BB,0,3)=='Bak') %>% select(-BB)
  }
  print('Done loop')
  
  for(j in 1:2) {
    
    if(j==1) {
      df_ = df_1 %>% filter(stringr::str_starts(ATM_ID,'A01')) %>% distinct()
    } else {
      df_ = df_1 %>% filter(!stringr::str_starts(ATM_ID,'A01')) %>% distinct()
    }
    
    
    
    if(nrow(df_)>0) {
      
      if(nrow(df_)==1) {
        df_ = dplyr::bind_rows(df_,df_)
        png(paste(cur_zone,'.png',sep = ''), height = 30*nrow(df_), width = 200*ncol(df_))
      } else {
        png(paste(cur_zone,'.png',sep = ''), height = 30*nrow(df_), width = 200*ncol(df_))
      }
      
      
      myTable <- tableGrob(df_, rows = NULL)
      
      
      
      grid.draw(myTable)
      dev.off()
      
      # Send photo
      bot$sendPhoto(zones$id[i],
                    photo = paste(cur_zone,'.png',sep = '')
      )
    }
    print(i)
  }
  
}
print('qruplar')
qruplar = readxl::read_excel('chat_id.xlsx')

unique_chats = unique(qruplar$Responsible_ID)

options(scipen = 9999)

for (j in 1:length(unique_chats)) {
  df_ = semi_join(df,qruplar %>% filter(Responsible_ID==unique_chats[j])) 
  cur_zone = as.numeric(unique_chats[j])
  reg_name = paste(letters[1:5],collapse = '')
  print(cur_zone)
  if(nrow(df_)>0){
    if(nrow(df_)<=3) {
      if(nrow(df_)==1) {
        df_ = dplyr::bind_rows(df_,df_)
        png(paste(reg_name,'.png',sep = ''), height = 200*nrow(df_), width = 300*ncol(df_))
      } else {
        png(paste(reg_name,'.png',sep = ''), height = 200*nrow(df_), width = 300*ncol(df_))
      }
    } else {
      png(paste(reg_name,'.png',sep = ''), height = 30*nrow(df_), width = 200*ncol(df_))
    }
    
    myTable <- tableGrob(df_, rows = NULL)
    
    
    
    grid.draw(myTable)
    dev.off()
    
    # Send photo
    bot$sendPhoto(cur_zone,
                  photo = paste(reg_name,'.png',sep = '')#,'rb')
    )
    print(j)
  }
}


df = readxl::read_excel('last_problem.xlsx')


options(scipen = 9999)

for (j in 1:length(unique_chats)) {
  df_ = semi_join(df,qruplar %>% filter(Responsible_ID==unique_chats[j])) 
  cur_zone = as.numeric(unique_chats[j])
  reg_name = paste(letters[1:5],collapse = '')
  print(cur_zone)
  if(nrow(df_)>0){
    if(nrow(df_)<=3) {
      if(nrow(df_)==1) {
        df_ = dplyr::bind_rows(df_,df_)
        png(paste(reg_name,'.png',sep = ''), height = 200*nrow(df_), width = 300*ncol(df_))
      } else {
        png(paste(reg_name,'.png',sep = ''), height = 200*nrow(df_), width = 300*ncol(df_))
      }
    } else {
      png(paste(reg_name,'.png',sep = ''), height = 30*nrow(df_), width = 200*ncol(df_))
    }
    
    myTable <- tableGrob(df_, rows = NULL)
    
    
    
    grid.draw(myTable)
    dev.off()
    
    # Send photo
    bot$sendPhoto(cur_zone,
                  photo = paste(reg_name,'.png',sep = '')#,'rb')
    )
    print(j)
  }
}



