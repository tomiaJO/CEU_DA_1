download.file('https://www.nasa.gov/images/content/694811main_pia16225-43_full.jpg' , 'image.jpg')
install.packages('jpeg')
library(jpeg)

img <-- readJPEG('9h1nPA.jpg')

dim(img)
