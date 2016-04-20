using Baozi
using Base.Test

# write your own tests here

run(`rm -rf test`)

init("test")
cd("test")

gen(pwd())

# t = Dumpling.parse_file("_slides/slide.md")
# # t = Dumpling.parse_file("_slides/slide.md")

# mkdir("site")

# f=open("site/slide.html","w+")

# template_render(f,t)