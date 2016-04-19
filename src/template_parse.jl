import Base: get,peek

get(md::Dumpling.MD,key) = get(md.attrs,key,false)

const whitespace = " \t\r"

"""
Skip any leading whitespace. Returns io.
"""
function skipwhitespace(io::IO; newlines = true)
    while !eof(io) && (peek(io) in whitespace || (newlines && peek(io) == '\n'))
        read(io, Char)
    end
    return io
end

"""
Test if the stream starts with the given string.
`eat` specifies whether to advance on success (true by default).
`padding` specifies whether leading whitespace should be ignored.
"""
function startswith(stream::IO, s::AbstractString; eat = true, padding = false, newlines = true)
    start = position(stream)
    padding && skipwhitespace(stream, newlines = newlines)
    result = true
    for char in s
        !eof(stream) && read(stream, Char) == char ||
            (result = false; break)
    end
    !(result && eat) && seek(stream, start)
    return result
end

"""
Executes the block of code, and if the return value is `nothing`,
returns the stream to its initial position.
"""
function withstream(f, stream)
    pos = position(stream)
    result = f()
    (result ≡ nothing || result ≡ false) && seek(stream, pos)
    return result
end

"""
Read the stream until startswith(stream, delim)
The delimiter is consumed but not included.
Returns nothing and resets the stream if delim is
not found.
"""
function readuntil(stream::IO, delimiter; newlines = false, match = nothing)
    withstream(stream) do
        buffer = IOBuffer()
        count = 0
        while !eof(stream)
            if startswith(stream, delimiter)
                if count == 0
                    return takebuf_string(buffer)
                else
                    count -= 1
                    write(buffer, delimiter)
                    continue
                end
            end
            char = read(stream, Char)
            char == match && (count += 1)
            !newlines && char == '\n' && break
            write(buffer, char)
        end
    end
end

function template_render(out::IO, md::Dumpling.MD)
    layout = get(md,"layout")
    if layout==false 
        error("Did not choose a layout\n") 
    end
    # (title = get(md,"title")) || (title = nothing)
    # (date = get(md,"date")) || (date = Dates.now())

    isfile("$(working_dir)/_layouts/$(layout).html") || (error("""
        Layout $(layout) was not been created
        Please make sure you have the correct layout
        """))

    template = IOBuffer(readstring("$(working_dir)/_layouts/$(layout).html"))

    global content = Dumpling.html(md)

    while !eof(template)
        if startswith(template,"{%")
            text = readuntil(template,"%}",match="{%")
            text = text|>parse|>eval
            write(out,text)
        end
        char = read(template,Char)
        write(out,char)
    end
    return template
end