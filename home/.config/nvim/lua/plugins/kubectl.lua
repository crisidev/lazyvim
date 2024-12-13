return {
    "Ramilito/kubectl.nvim",
    opts = {},
    cmd = { "Kubectl", "Kubectx", "Kubens" },
    keys = {
        { "<leader>k", '<cmd>lua require("kubectl").toggle()<cr>', desc = "K8s" },
        { "<C-k>", "<Plug>(kubectl.kill)", ft = "k8s_*" },
        { "7", "<Plug>(kubectl.view_nodes)", ft = "k8s_*" },
        { "8", "<Plug>(kubectl.view_overview)", ft = "k8s_*" },
        { "<C-v>", "<Plug>(kubectl.view_top)", ft = "k8s_*" },
    },
}
