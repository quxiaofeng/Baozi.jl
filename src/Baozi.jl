module Baozi

# VERSION >= v"0.4.0-dev+6521" && __precompile__()

using Nettle,YAML

include("Dumpling/src/Dumpling.jl")
include("template_parse.jl")

@windows_only warn("""
    Do not support Windows at present :-(\n
    However, you can try this on Windows
    """)

# For Ubuntu
# @unix_only if ENV["XDG_SESSION_DESKTOP"]=="ubuntu"
#     try
#         run(pipeline(`apt-cache show pandoc`,"pandoc_installed"))
#     catch
#         run(`sudo apt-get install pandoc`)
#         # error("Pandoc is not installed\n
#         #         try sudo apt-get insall pandoc\n")
#     end
# else
#     # warn on other unix system
#     warn("""
#         Well 
#         you could try this, but it may not work at present
#         ;-)
#         """)
# end

#####################
# Init a Baozi site #
#####################

function init(name::AbstractString;git_remote=nothing)
    dir = dirname(@__FILE__)

    try
        cp(string(dir,"/site_template"),"$(pwd())/$(name)")
    catch
    end

    global working_dir = "$(pwd())/$(name)"

    cp(string(dir,"/baozi"),"$(pwd())/$(name)/baozi")
    chmod("$(pwd())/$(name)/baozi",0o777)

    run(`git init`)
    git_remote!=nothing?run(`git remote add origin $(git_remote)`):nothing
end

# render a given directory

function render_dir(dir::AbstractString,working_dir::AbstractString)
    cd(working_dir)
    template_dir = string(working_dir,"/_layouts")

    dir_list = readdir(dir)
    content_list = filter(x->ismatch(r"(.*).md",x),dir_list)
    map!(x->match(r"(.*).md",x).captures[1],content_list)
    content_list = [content_list [readstring("$(dir)/$(file).md")|>x->hexdigest("MD5",x) for file in content_list]]

    if length(find(x->x==".cache",dir_list))!=0
        cache_list = readdlm("$dir/.cache")

        render_list = ByteString[]
        for i = 1:size(cache_list)[1]
            if cache_list[i,:]!=content_list[i,:]
                push!(render_list,content_list[i,1])
            end
        end
    else
        render_list = content_list[:,1]
    end

    writedlm("$dir/.cache",content_list)

    dir_name = match(r"_(.*)",dir).captures[1]
    try mkdir("$(dir_name)") end

    for file in render_list
        f = open("$(dir_name)/$(file).html","w")
        m = Dumpling.parse_file("_$(dir_name)/$(file).md")
        template_render(f,m)
        close(f)
    end
end

function gen(working_dir::AbstractString;commit=nothing)
    cd(working_dir)
    dir_list = filter(x->ismatch(r"_.*",x),filter(isdir,readdir()))
    

    for dir in dir_list
        render_dir(dir,working_dir)
    end

    f = open("index.html","w")
    layout_dir = string(pwd(),"/_layouts")
    m = Dumpling.parse_file("README.md")
    template_render(f,m)
    close(f)

    run(`git add *`)
    if commit==nothing&&length(dir_list)!=0
        try run(`git commit -m"update $(dir_list[1]),etc."`) end
    elseif commit==nothing
        try run(`git commit -m"update"`) catch print("nothing to commit") end
    else
        try run(`git commit -m"$commit"`) catch print("nothing to commit") end
    end
end

export init,gen,template_render,Dumpling

end # module
