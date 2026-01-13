return {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        winopts = {
            width = 0.9,
            height = 0.9,
            preview = {
                layout = 'horizontal',
                horizontal = 'right:30%',
                wrap = 'wrap',
            },
        },
        fzf_opts = {
            ['--wrap'] = true,
        },
        files = {
            file_ignore_patterns = {
                "node_modules/",
                ".git/",
                "dist/",
                "build/",
                "bin/",
            },
        },
    },
}
