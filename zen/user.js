// Smooth scrolling
user_pref("general.smoothscroll", true);
user_pref("general.smoothScroll.msdPhysics.enabled", true);

// Momentum / overscroll
user_pref("apz.overscroll.enabled", true);

// Better wheel behavior
user_pref("mousewheel.min_line_scroll_amount", 12);
user_pref("mousewheel.default.delta_multiplier_y", 100);

// Scroll physics tuning
user_pref("general.smoothScroll.currentVelocityWeighting", "0.12");
user_pref("general.smoothScroll.stopDecelerationWeighting", "0.5");

// Physics engine
user_pref("general.smoothScroll.msdPhysics.continuousMotionMaxDeltaMS", 120);
user_pref("general.smoothScroll.msdPhysics.motionBeginSpringConstant", 800);
user_pref("general.smoothScroll.msdPhysics.regularSpringConstant", 800);
user_pref("general.smoothScroll.msdPhysics.slowdownMinDeltaMS", 12);

// WAYLAND / HYPRLAND RENDERING
user_pref("gfx.webrender.all", true);
user_pref("widget.wayland_vsync.enabled", true);
user_pref("widget.dmabuf.force-enabled", true);

// VIDEO HARDWARE ACCELERATION (VAAPI)
user_pref("media.ffmpeg.vaapi.enabled", true);
user_pref("media.hardware-video-decoding.force-enabled", true);
user_pref("media.ffvpx.enabled", false);

// DARK MODE
user_pref("layout.css.prefers-color-scheme.content-override", 0);
user_pref("widget.content.allow-gtk-dark-theme", true);

// ZEN / FIREFOX UI
user_pref("toolkit.legacyuserprofilecustomizations.stylesheets", true);
user_pref("browser.compactmode.show", true);
user_pref("browser.tabs.hoverpreview.enabled", false);

// PRIVACY
user_pref("privacy.trackingprotection.enabled", true);
user_pref("privacy.trackingprotection.socialtracking.enabled", true);
user_pref("privacy.resistFingerprinting", true);
user_pref("browser.send_pings", false);
user_pref("beacon.enabled", false);
user_pref("network.dns.disablePrefetch", true);

// GPU + 144Hz + smooth rendering
user_pref("layers.gpu-process.enabled", true);
user_pref("apz.allow_zooming", true);
user_pref("layout.frame_rate", 144);
user_pref("gfx.webrender.compositor", true);
