-- was imports/vars.conf. hl.env only applies at launch, not on reload.

-- NVIDIA ENV VARS PLS NO DELET
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")

-- force wayland in electron
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- D2 (owner: fix it). The old `env = WAYLAND_TEXT_INPUT=3` had no comma, so it never took effect.
hl.env("WAYLAND_TEXT_INPUT", "3")

-- D3 (owner: yes). Export systemd's ssh-agent.socket (D7) so the session and its children find the agent.
hl.env("SSH_AUTH_SOCK", os.getenv("XDG_RUNTIME_DIR") .. "/ssh-agent.socket")
