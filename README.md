# Baozi
Baozi is a simple static site generator implemented in pure Julia.

Baozi only support Ubuntu currently, I can't not grantee you can use it on other systems.

[manual](examples/manual.md)

## TO-DO

- [ ] reorganize files and types as there's a lot of repetitive codes in the source
- [ ] add [Github.jl](https://github.com/JuliaWeb/GitHub.jl) as dependency
- [ ] directory management
- [ ] add basic css and js for posts
- [ ] Markdown parser in pure Julia

## FUTURE

- [ ] 尽可能兼容现有的 jekyll 和 hexo
- [ ] 主题模版可更换，与内容完全分离，包括主页选项配置
- [ ] 参数配置都统一到 _config.yml。例如：自动生成 CNAME 文件
- [ ] 主要使用 markdown，markdown 和 html 文件都解析
- [ ] 保留所有非 _开头的目录和文件。 config.yml 中可设置忽略目录
- [ ] 支持可配置的全局 permalink duoshuo disqus google analitics 等属性
- [ ] 页面选项包括 mathjax katex revealjs highlight bib comment share 等属性
- [ ] 移植一些主题： tufte（optimization.ml） zhuyingtai.ml。要尽量用选项一键切换。 
- [ ] ？自动化移植 jekyll 和 hexo 主题，或者动态提取主题
- [ ] 页面内运行 julia 代码。将 Julia 代码返回的结果和生成的图片存入 HTML。
- [ ] git 集成，一键部署，将管理与更新统一到一个工作流程中。简化流程。
- [ ] 引用站外文件（文件中配置 url 下载到本地后本地编译为静态站点内容，或者本机文件系统其他目录下文件）
- [ ] 处理 bib 索引。
- [ ] 生成目录、图目录、表目录。
- [ ] 打印模式。自动生成对应 pdf，mobi，epub。
- [ ] ？csv 绘制表格画图（也许直接用 Julia 实现）