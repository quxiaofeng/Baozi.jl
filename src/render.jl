function findconfig()
    # read file list in current directory
    for i=1:3
        if length(find(x->x=="config.yml",readdir()))==0
            cd("..")
        else
            return pwd()
        end
    end
    error("cannot find root directory\n")
end 

function render(dirname::AbstractString,filename::AbstractString)
    f = open("site/$(dirname)/$(filename).html","w")
    m = Dumpling.parse_file("_$(dirname)/$(filename).md")
    template_render(f,m)
    close(f)
end

function init(name::AbstractString;git_remote=nothing)
    dir = dirname(@__FILE__)

    cp(string(dir,"/site_template"),"$(pwd())/$(name)")
    cp(string(dir,"/baozi"),"$(pwd())/$(name)/baozi")
    @unix_only chmod("$(pwd())/$(name)/baozi",0o777)
end

function render_dir(dir::AbstractString)
    findconfig()
    layouts = "_layouts"
    dir_list = readdir(dir)

    content_list = filter(x->ismatch(r"(.*).md",x),dir_list)
    length(content_list) !=0 || return
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
    try mkdir("site/$(dir_name)") end

    for file in render_list
        render(dir_name,file)
    end
end

function generate_repo(config,commit)
    if get(config,"repo",false)==false
        return
    end
    
    run(`git init`)
    git_remote!=nothing?run(`git remote add origin $(git_remote)`):nothing
    run(`git add *`)
    if commit==nothing&&length(dir_list)!=0
        try run(`git commit -m"update $(dir_list[1]),etc."`) end
    elseif commit==nothing
        try run(`git commit -m"update"`) catch print("nothing to commit") end
    else
        try run(`git commit -m"$commit"`) catch print("nothing to commit") end
    end
end

function gen(;commit=nothing)
    cd(findconfig())
    dir_list = filter(x->ismatch(r"_.*",x),filter(isdir,readdir()))

    try 
        mkdir("site")
    end

    for dir in dir_list
        render_dir(dir)
    end

    dependency_list = filter(x->ismatch(r"^[^_].*$",x),filter(isdir,readdir()))
    for file in dependency_list
        if file!="site"
            try cp(file,"site/$(file)") end
        end
    end

    f = open("site/index.html","w")
    m = Dumpling.parse_file("README.md")
    template_render(f,m)
    close(f)

    config = YAML.load_file("config.yml")

    @unix_only generate_repo(config,commit)
end