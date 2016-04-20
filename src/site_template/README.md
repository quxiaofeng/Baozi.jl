---
layout: index
title: Baozi--static site generator for scientists
---



# Manual

This a manual for pandoc based static page generator Baozi. Baozi is implemented by [Julia](http://julialang.org)

---


# Posts

posts are currently using the standard markdown. css and js support is under developing.

# Slides

All the slides are based on revealjs and is converted by pandoc.

# Guide

## use july in command line
To use this package, simply clone the repo to your local computer and type in the command line to initialize your site directory first:

```shell
{path-to-the-repo}/Baozi.jl/july init my_site 
cd my_site
```

### generate posts/slides/...

first you have to configure the july file for some parameters
`git_url` is for uploading to your git repo 

use the following command to generate your staff.
```shell
./july generate
```

### publish

use `publish` to publish your site to the `master` branch
```shell
./july publish
```

or you can use `publish=gh-pages` to publish your site to the `gh-pages` branch

### help
use `help` to check manual
```shell
./july help
```

## Edit Slides

each frame is marked by `#`:

```markdown
# (new frame title)

# another frame
## smaller title
```

### frame configuration

configuration should be included in `{}`

- **id** :: frame id begin with `#`,eg. `{#this-is-a-frame-id}`
- **background** :: `data-background`, eg.`{data-background="#DAA520"}`
- **background transition** :: `data-background-transition`,eg.`{data-background-transition="slide"}`
- **fragment** start with `> -`,eg.
```markdown
> - fragment 1
> - fragment 2
> - fragment 3
```


---
&copy;2016 All rights reserved. Made with [Baozi](http://rogerluo.cc/Baozi.jl) and ♥