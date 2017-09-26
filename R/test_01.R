rm(list=ls())

setwd("C:\\DB Tool\\Mercado\\06132017_JieXue_Mercado")

library(XML)
library(RCurl)

url <- "http://mercado.fda.gov/search/#/search?d=all&q=aspirin%20AND%20dissolution%20AND%20pharmaceutics&p.num=1&p.size=10&f=%7B%22_%22:%22field%22,%22t%22:%22appl-type%22,%22k%22:%22COMMON_FACET_APP_TYPE_ss%22,%22v%22:%22ANDA%22,%22ex%22:%5B%22appl-type%22%5D%7D&f=%7B%22_%22:%22field%22,%22t%22:%22appl-type%22,%22k%22:%22COMMON_FACET_APP_TYPE_ss%22,%22v%22:%22IND%22,%22ex%22:%5B%22appl-type%22%5D%7D&f=%7B%22_%22:%22field%22,%22t%22:%22appl-type%22,%22k%22:%22COMMON_FACET_APP_TYPE_ss%22,%22v%22:%22NDA%22,%22ex%22:%5B%22appl-type%22%5D%7D&f=%7B%22_%22:%22field%22,%22t%22:%22comm-name%22,%22k%22:%22COMM_NAME_s%22,%22v%22:%22Action%20Summary%20Review%20(REV-SUMMARY-01)%22,%22ex%22:%5B%22comm-name%22%5D%7D&f=%7B%22_%22:%22field%22,%22t%22:%22comm-name%22,%22k%22:%22COMM_NAME_s%22,%22v%22:%22Bioequivalence%20Primary%20Review%22,%22ex%22:%5B%22comm-name%22%5D%7D&f=%7B%22_%22:%22field%22,%22t%22:%22comm-name%22,%22k%22:%22COMM_NAME_s%22,%22v%22:%22Bioequivalence%20Review%22,%22ex%22:%5B%22comm-name%22%5D%7D&f=%7B%22_%22:%22field%22,%22t%22:%22comm-name%22,%22k%22:%22COMM_NAME_s%22,%22v%22:%22Biopharmaceutics%20Review%22,%22ex%22:%5B%22comm-name%22%5D%7D&f=%7B%22_%22:%22field%22,%22t%22:%22comm-name%22,%22k%22:%22COMM_NAME_s%22,%22v%22:%22Complete%20Response%20(COR-ANDAACTION-09)%22,%22ex%22:%5B%22comm-name%22%5D%7D&f=%7B%22_%22:%22field%22,%22t%22:%22comm-name%22,%22k%22:%22COMM_NAME_s%22,%22v%22:%22Drug%20Product%20Primary%20Review%22,%22ex%22:%5B%22comm-name%22%5D%7D&f=%7B%22_%22:%22field%22,%22t%22:%22comm-name%22,%22k%22:%22COMM_NAME_s%22,%22v%22:%22Drug%20Product%20Review%22,%22ex%22:%5B%22comm-name%22%5D%7D&f=%7B%22_%22:%22field%22,%22t%22:%22comm-name%22,%22k%22:%22COMM_NAME_s%22,%22v%22:%22General%20Review%20(REV-CLINPHARM-01)%22,%22ex%22:%5B%22comm-name%22%5D%7D&f=%7B%22_%22:%22field%22,%22t%22:%22comm-name%22,%22k%22:%22COMM_NAME_s%22,%22v%22:%22General%20Review%20(REV-QUALITY-03)%22,%22ex%22:%5B%22comm-name%22%5D%7D&f=%7B%22_%22:%22field%22,%22t%22:%22comm-name%22,%22k%22:%22COMM_NAME_s%22,%22v%22:%22Primary%20Review%20(REV-BIOEQ-21)%22,%22ex%22:%5B%22comm-name%22%5D%7D&f=%7B%22_%22:%22field%22,%22t%22:%22comm-name%22,%22k%22:%22COMM_NAME_s%22,%22v%22:%22Primary%20Review%20(REV-QUALITY-21)%22,%22ex%22:%5B%22comm-name%22%5D%7D"
#Mercado <- read_html(url, user_agent("FDA"))
myurl <- getURL(url)

parse_XML<- htmlParse(myurl)

doc.html = htmlParse(myurl, useInternal = TRUE)
