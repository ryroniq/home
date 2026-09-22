(load "~/.emacs.el")

(require 'exwm)

(setq exwm-workspace-number 10)

(add-hook 'exwm-update-class-hook
          (lambda () (exwm-workspace-rename-buffer exwm-class-name)))

(setq exwm-input-global-keys
      `(([?\s-r] . exwm-reset)
        ([?\s-w] . exwm-workspace-switch)
        ([?\s-s] . exwm-workspace-switch-to-buffer)
        ([s-escape] . switch-to-buffer)
        ([s-tab] . other-window)
        ([?\s-`] . switch-to-buffer)
        ([?\s-,] . rename-buffer)
        ([?\s-q] . buffer-menu)
        ([?\s-a] . delete-other-windows)
        ([?\s-z] . delete-window)
        ([?\s-y] . winner-undo)
        ([?\s-u] . previous-buffer)
        ([?\s-i] . next-buffer)
        ([?\s-o] . winner-redo)
        ([?\s-h] . windmove-left)
        ([?\s-l] . windmove-right)
        ([?\s-k] . windmove-up)
        ([?\s-j] . windmove-down)
        ([?\s-H] . my/split-window-right)
        ([?\s-J] . split-window-below)
        ([?\s-K] . my/split-window-below)
        ([?\s-L] . split-window-right)
        ([?\s-\C-h] . (lambda () (interactive) (shrink-window-horizontally 5)))
        ([?\s-\C-j] . (lambda () (interactive) (enlarge-window 3)))
        ([?\s-\C-k] . (lambda () (interactive) (shrink-window 3)))
        ([?\s-\C-l] . (lambda () (interactive) (enlarge-window-horizontally 5)))
        ([?\s-\M-h] . shrink-window-horizontally)
        ([?\s-\M-j] . enlarge-window)
        ([?\s-\M-k] . shrink-window)
        ([?\s-\M-l] . enlarge-window-horizontally)
        ([?\s-m]    . (lambda () (interactive) (start-process "Banish Mouse" nil "xdotool" "mousemove" "0"     "10000")))
        ([?\s-M]    . (lambda () (interactive) (start-process "Banish Mouse" nil "xdotool" "mousemove" "10000" "10000")))
        ,@(mapcar (lambda (i)
                    `(,(kbd (format "s-%d" i)) .
                      (lambda ()
                        (interactive)
                        (exwm-workspace-switch-create ,i))))
                  (number-sequence 0 9))))

(setq exwm-input-prefix-keys
      '(?\C-q
        ?\C-\]
        ?\M-x
        ?\M-`
        ?\M-&
        ?\M-:))

(exwm-wm-mode)
