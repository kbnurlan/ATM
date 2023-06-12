


system('git add -A')
system('git commit -m "all"')

system(paste('git push https://',Sys.getenv('GIT_ID'),'@github.com/kbnurlan/ATM.git',sep = ''))



