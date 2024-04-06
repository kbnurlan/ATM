library(fs)
id <- "\\\\Filesrv07\\head-office\\Private\\Tehlil_ve_koordinasiya_shob\\Tehlil_ve_koordinasiya_shobesi\\texniki_id\\chat_id.xlsx"
path1 <- '\\\\10.0.6.184\\nt\\Daily_FIMI\\FIMI_new\\ATM\\chat_id.xlsx'
path2 <- '\\\\10.0.6.184\\nt\\Daily_FIMI\\fimi\\chat_id.xlsx'
file_copy(id, path1, overwrite = T)
file_copy(id, path2, overwrite = T)


