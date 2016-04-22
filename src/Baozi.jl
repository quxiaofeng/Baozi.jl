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

include("render.jl")

export init,gen,template_render,Dumpling

end # module
