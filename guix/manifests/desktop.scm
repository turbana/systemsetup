(specifications->manifest
 '(;; X11
   "xmonad"                             ; window mananger
   "ghc-xmonad-contrib"                 ; xmonad goodies
   "ghc@8.6.5"                          ; needed to recompile xmonad
   "dmenu"                              ; application launcher
   "dzen"                               ; status bars
   "xclip"                              ; clipboard management
   "xrandr"                             ; screen management
   "xrdb"                               ; Xresource manangement
   "gnome-terminal"                     ; terminal
   "glib:bin"                           ; for 'gsettings' program (used to change color scheme)
   "python-dbus"                        ; for cpugraph.py
   "python-colour"                      ; for colorwheel.py
   ;; fonts
   "font-dejavu"
   "dbxfs"
   ))
