return {
    {
        "mzlogin/vim-markdown-toc",
        ft = "markdown",
        lazy = true,
        cmd = { "GenTocGFM", "GenTocGitLab", "GenTocMarked", "GenTocModeline", "GenTocRedcarpet" },
    },
    {
        "jghauser/follow-md-links.nvim",
        ft = { "markdown" },
    },
}
