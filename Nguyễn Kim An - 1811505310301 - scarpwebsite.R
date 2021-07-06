library(tidyverse)  

# Parsing of HTML/XML files  
library(rvest)    

# String manipulation
library(stringr)   

# Verbose regular expressions
library(rebus)     

# Eases DateTime manipulation
library(lubridate)

library("xlsx")


webpage_url<-"https://www.muradvietnam.vn/san-pham"

webpage_html<- read_html(webpage_url)
categories_html<- html_nodes(webpage_html,"div.product-category.clearfix > ul > li >a")

Categoryname <- c()
CategoryId <- c()
Category <- data.frame(CategoryId,Categoryname)
categoryid<-1

Productname <- c()
ProductId <- c()
SortDescription <- c()
Price <-c()
Image <- c()
Product <- data.frame(ProductId,Productname,SortDescription,Price,Image,CategoryId)
productid<-1

Description <- c()
Details <- c()
ProductDescriptionId <- c()
ProductDetails <- data.frame(ProductDescriptionId,ProductId,Description,Details)
productdescriptionid<-1

for(category_html in categories_html){
  
  Categoryname <- c(str_trim(html_text(category_html)))
  CategoryId <- c(str_c("Category",categoryid))
  categorytemp <- data.frame(CategoryId,Categoryname)
  Category <- rbind(Category,categorytemp)
  
  Category_webpage_url <- html_attr(category_html,"href")
  Category_webpage_html<- read_html(Category_webpage_url)
  products_details_url <- html_attr(html_nodes(Category_webpage_html,"a.productimg"),"href")
  
  for(product_details_url in products_details_url){
    product_details_html<- read_html(product_details_url)
    
    Productname <- c(html_text(html_node(product_details_html,"h1.product-name")))
    ProductId <- c(str_c("Product",productid))
    SortDescription <- c(html_text(html_node(product_details_html,"div.smalltitle")))
    Price <-c(html_text(html_node(product_details_html,"div.value.price")))
    Image <- c(str_c("www.muradvietnam.vn",html_attr(html_node(product_details_html,"a.fancybox"),"href")))
    
    producttemp <- data.frame(ProductId,Productname,SortDescription,Price,Image,CategoryId)
    Product <- rbind(Product,producttemp)
    productid<- productid+1
    
    product_descriptions_html<- html_nodes(product_details_html,".group.clearfix")
    for(product_description_html in product_descriptions_html){
      Description <- c(html_text(html_node(product_description_html,"span")))
      Details <- c(html_text(html_node(product_description_html,"div.value")))
      ProductDescriptionId <- c(productdescriptionid)
      ProductDetailstemp <- data.frame(ProductDescriptionId,ProductId,Description,Details)
      ProductDetails <- rbind(ProductDetails,ProductDetailstemp)
      
      productdescriptionid<- productdescriptionid+1
    }
  }
  
  categoryid<- categoryid+1
}



write.xlsx(Category, file = "result.xlsx", 
           sheetName="Category", append=TRUE)
write.xlsx(Product, file = "result.xlsx", 
           sheetName="Product", append=TRUE)
write.xlsx(ProductDetails, file = "result.xlsx", 
           sheetName="ProductDetails", append=TRUE)












