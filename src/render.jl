function render(file::AbstractString)
    ohtml = readstring(file)
    return replace(ohtml,'$',"\\\$")|>Markdown.parse|>Markdown.html
end