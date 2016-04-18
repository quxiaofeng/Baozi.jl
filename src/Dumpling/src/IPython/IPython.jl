# This file is a part of Julia. License is MIT: http://julialang.org/license

abstract LaTeX

type inlineLaTeX<:LaTeX
    formula::UTF8String
end

@trigger '$' ->
function tex(stream::IO, md::MD)
    result = parse_inline_wrapper(stream, "\$", rep = true)
    return result === nothing ? nothing : LaTeX(result)
end


type BlockTeX<:LaTeX
    formula::UTF8String
end

function blocktex(stream::IO, block::MD)
    withstream(stream) do
        startswith(stream, "\$\$", padding = true) || return false
        skip(stream, -1)
        ch = read(stream, Char)
        trailing = strip(readline(stream))
        flavor = lstrip(trailing, ch)
        n = 2 + length(trailing) - length(flavor)

        # inline code block
        ch in flavor && return false

        buffer = IOBuffer()
        while !eof(stream)
            line_start = position(stream)
            if startswith(stream, string(ch) ^ n)
                if !startswith(stream, string(ch))
                    push!(block, BlockTeX(takebuf_string(buffer) |> chomp))
                    return true
                else
                    seek(stream, line_start)
                end
            end
            write(buffer, readline(stream))
        end
        return false
    end
end

# function blocktex(stream::IO, md::MD)
#     withstream(stream) do
#         ex = tex(stream, md)
#         if ex ≡ nothing
#             return false
#         else
#             push!(md, ex)
#             return true
#         end
#     end
# end

writemime(io::IO, ::MIME"text/plain", tex::LaTeX) =
    latexinline(io,tex)

writemime(io::IO, ::MIME"text/plain", tex::BlockTeX) =
    latex(io,tex)

latex(io::IO, tex::BlockTeX) =
    println(io, "\$\$", tex.formula, "\$\$")

latexinline(io::IO, tex::LaTeX) =
    print(io, '$', tex.formula, '$')

term(io::IO, tex::LaTeX, cols) = println_with_format(:magenta, io, tex.formula)
terminline(io::IO, tex::LaTeX) = print_with_format(:magenta, io, tex.formula)
