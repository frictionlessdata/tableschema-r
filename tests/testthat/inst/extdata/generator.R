'use strict'
fs = list()
headers = list('id', 'height', 'age', 'name', 'occupation')
headers2 = list('2', '22', '222', '2222', '2222')
headers3 = list('1', '11', '111', '1111', '1111')
rows = 100
ws = fs.createWriteStream('./data/data_big2.csv')

data = list()


a=rlist::list.append(data,headers)
a
b=rlist::list.append(a,headers2)
b
c=rlist::list.append(b,headers3)
c
rlist::list.rbind(c)

write.row(c)
for (row in 1:rows) {
  
  , random = floor((runif(row) + 1) * 10)
  
  data.push(row)
  data.push(random * 10)
  data.push(random * 5)
  data.push(rndString(random))
  data.push('2016-07-11 18:23:08')
  write(data)
}

ws.end()

rndString = function (max) {
  
  possible = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'
  possibleLength = nchar(possible)
  result = ''
  
  index = floor(runif(max) * possibleLength)
  
  for (i in seq_along(index)) {
    
    #result = result + possible.charAt(Math.floor(Math.random() * possibleLength))
    
    result = paste(result, stringr::str_sub(possible, start = index[i], end = index[i]), collapse = "",sep = "" )
    
  }
  
  return (result)
}

write.row = function (row) {
  writer = paste(unlist(row), collapse=',', sep='\r\n')
  writer = paste(writer, sep='\r\n')
  writer
}

  write = data.table::fwrite(write, file = "", append = FALSE, quote = "auto",
                             sep = ",", eol = "\r\n")
# creating data and writing it to disk
stream <- stream::DSD_Gaussians(k=3, d=5)
stream::write_stream(stream, file="data.txt", n=10, class=TRUE)
#file.show("data.txt")
# clean up
stream::file.remove("data.txt")
