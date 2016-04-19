using Baozi
using Base.Test

# write your own tests here

run(`rm -rf test`)

init("test")
cd("test")

t = Dumpling.parse_file("_posts/example.md")

mkdir("site")

f=open("site/test.html","w+")

template_render(f,t)