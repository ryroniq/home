;; -*- lexical-binding: t; -*-

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Install use-package if it's not somehow built-in
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package) ; Neccesary to bootstrap the macro itself!


(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

(load-theme 'doom-moonlight)

(scroll-bar-mode 0)
(menu-bar-mode 0)
(tool-bar-mode 0)

(column-number-mode 1)
(winner-mode 1)

(setq
 inhibit-startup-screen t
 frame-resize-pixelwise t
 winner-ring-size 50
 default-input-method "japanese-skk"
 )
(setq-default
 tab-width 4
 indent-tabs-mode nil
 )

(defun my/c-mode-common-hook ()
  (define-key c-mode-map (kbd "M-q") 'prog-fill-reindent-defun)
  (setq c-basic-offset 4)
  (setq indent-tabs-mode t))
(add-hook 'c-mode-common-hook 'my/c-mode-common-hook)

(defun my/org-mode-hook ()
  (define-key org-mode-map (kbd "C-,") 'my/scroll-half-down)
)
(add-hook 'org-mode-hook 'my/org-mode-hook)

(defun my/set-mark-only ()
  "Set a mark at point without activating the region highlight."
  (interactive)
  (push-mark nil t nil)
  (message "Mark set (no selection)."))

(defun my/scroll-half-down ()
  (interactive)
  (let ((h (window-total-height)))
    (scroll-down-line (/ h 2))))
(defun my/scroll-half-up ()
  (interactive)
  (let ((h (window-total-height)))
    (scroll-up-line (/ h 2))))
(defun my/scroll-half-down-other-window ()
  (interactive)
  (let ((h (window-total-height (next-window))))
    (scroll-other-window-down (/ h 2))))
(defun my/scroll-half-up-other-window ()
  (interactive)
  (let ((h (window-total-height (next-window))))
    (scroll-other-window (/ h 2))))

(defun my/toggle-line-numbers ()
  (interactive)
  (setq display-line-numbers
        (if (eq nil display-line-numbers) 'relative nil)))

(defun my/transpose-line-forward (arg)
  (interactive "p")
  (next-line)
  (transpose-lines arg)
  (previous-line))
(defun my/transpose-line-backward (arg)
  (interactive "p")
  (next-line)
  (transpose-lines (- arg))
  (previous-line))

(defun my/duplicate-dwim (arg)
  (interactive "p")
  (duplicate-dwim arg)
  (next-line))
(defun my/duplicate-line (arg)
  (interactive "p")
  (duplicate-line arg)
  (next-line))

(defun my/other-window-1 ()
  (interactive)
  (if (one-window-p)
      (error "No other window to select")
    (other-window -1)))
(defun my/split-window-below ()
  (interactive)
  (split-window-below)
  (windmove-down))
(defun my/split-window-right ()
  (interactive)
  (split-window-right)
  (windmove-right))

(defun my/disable-all-themes ()
  (interactive)
  (dolist (theme custom-enabled-themes)
    (disable-theme theme)))

(defun my/spawn-st ()
  (interactive)
  (start-process "Terminal" nil "st"))

(defun my/date-add-day (date days)
  (format-time-string
   "%Y-%m-%d"
   (time-add (date-to-time date)
             (days-to-time days))))

(defun my/date-add-day-current (days)
  (format-time-string
   "%Y-%m-%d"
   (time-add (current-time)
             (days-to-time days))))

(defun my/x-selection-to-emacs ()
  "Paste text from the X selection into the Emacs buffer."
  (interactive)
  (let ((x-selection (x-get-selection)))
    (if x-selection
        (insert x-selection)
      (message "No selection available."))))

(defun my/start-process (cmd)
  (interactive (list (read-shell-command "Start process: ")))
  (start-process-shell-command cmd nil cmd))

(defun my/launcher ()
  "Prompt for a command from a predefined list and execute it with optional arguments."
  (interactive)
  (let* ((dir "~/.launcher")
         (launcher-list (directory-files dir nil "^[a-zA-Z0-9]" nil))
         (cmd (completing-read "Launcher: " launcher-list)))
    (if (member cmd launcher-list)
        (let ((cmdpath (format "%s/%s" dir cmd))
              (args (read-string (format "Arguments for %s (leave blank for none): " cmd))))
          (if (string-empty-p args)
              (start-process-shell-command cmd nil cmdpath)
            (start-process-shell-command cmd nil (concat cmdpath " " args))))
      (message (format "Command \"%s\" doesn't exist in launcher list." cmd)))))

(defvar my/window-layouts-alist nil "Alist of named window layouts.")

(defun my/save-window-layout (name)
  "Save the current window layout with a given NAME."
  (interactive (list (completing-read "Save window layout: " (mapcar 'car my/window-layouts-alist) nil nil)))
  (let ((layout (current-window-configuration))
        (point (point)))
    (my/delete-window-layout name)
    (push (cons name (list layout point)) my/window-layouts-alist)
    (message "Layout '%s' saved." name)))

(defun my/restore-window-layout (name)
  "Restore the window layout associated with NAME."
  (interactive (list (completing-read "Restore window layout: " (mapcar 'car my/window-layouts-alist))))
  (let ((layout-and-point (cdr (assoc name my/window-layouts-alist))))
    (if layout-and-point
        (progn
          (set-window-configuration (car layout-and-point))
          (goto-char (cadr layout-and-point))
          (message "Layout '%s' restored." name))
      (message "No layout found with the name '%s'." name))))

(defun my/list-window-layouts ()
  "List all saved window layouts."
  (interactive)
  (if my/window-layouts-alist
      (message "Saved window layouts: %s" (mapconcat 'car my/window-layouts-alist ", "))
    (message "No layouts saved.")))

(defun my/clear-window-layouts ()
  "Clear all saved window layouts."
  (interactive)
  (setq my/window-layouts-alist nil)
  (message "All window layouts cleared."))

(defun my/delete-window-layout (name)
  "Delete all window layouts associated with NAME."
  (interactive (list (completing-read "Choose Layout to Delete: " (mapcar 'car my/window-layouts-alist))))
  (let ((orig-length (length my/window-layouts-alist)))
    (setq my/window-layouts-alist
          (delq nil (mapcar
                     (lambda (pair) (unless (equal (car pair) name) pair))
                     my/window-layouts-alist)))
    (if (/= (length my/window-layouts-alist) orig-length)
        (message "Layout '%s' deleted." name)
      (message "No layout found with the name '%s'." name))))

(defun my-delete-whitespace-forward ()
  "Delete whitespace from point up to the next non-whitespace char."
  (interactive)
  (delete-region (point)
                 (progn (skip-chars-forward " \t") (point))))

(global-set-key (kbd "C-c d") #'my-delete-whitespace-forward)


(keymap-global-unset "C-x C-z")
(keymap-global-unset "C-q")
(keymap-global-unset "C-z")
(keymap-global-unset "C-v")
(keymap-global-unset "C-M-v")
(keymap-global-unset "C-M-S-v")


(keymap-global-set "<f1>" 'my/spawn-st)
(keymap-global-set "<f2>" 'shell)

(keymap-global-set "C-;" 'other-window)
(keymap-global-set "C-'" 'my/other-window-1)
(keymap-global-set "C-(" 'my/transpose-line-backward)
(keymap-global-set "C-)" 'my/transpose-line-forward)

(keymap-global-set "M-L" 'mark-word)
(keymap-global-set "M-n" 'forward-paragraph)
(keymap-global-set "M-o" 'my/duplicate-dwim)
(keymap-global-set "M-p" 'backward-paragraph)
(keymap-global-set "M-v" 'my/x-selection-to-emacs)
(keymap-global-set "M-{" 'winner-undo)
(keymap-global-set "M-}" 'winner-redo)

(keymap-global-set "C-M-;"   'kill-sexp)
(keymap-global-set "C-M-'"   'backward-kill-sexp)


(keymap-global-set "<delete>"      'delete-char)
(keymap-global-set "M-<backspace>" 'backward-kill-word)
(keymap-global-set "M-<delete>"    'kill-word)

(keymap-global-set   "<prior>"     'my/scroll-half-down)
(keymap-global-set   "<next>"      'my/scroll-half-up)
(keymap-global-set "C-<prior>"     'scroll-down-command)
(keymap-global-set "C-<next>"      'scroll-up-command)
(keymap-global-set "M-<prior>"     'beginning-of-buffer)
(keymap-global-set "M-<next>"      'end-of-buffer)

(keymap-global-set   "S-<prior>"   'my/scroll-half-down-other-window)
(keymap-global-set   "S-<next>"    'my/scroll-half-up-other-window)
(keymap-global-set "C-S-<prior>"   'scroll-other-window-down)
(keymap-global-set "C-S-<next>"    'scroll-other-window)
(keymap-global-set "M-S-<prior>"   'beginning-of-buffer-other-window)
(keymap-global-set "M-S-<next>"    'end-of-buffer-other-window)


(keymap-global-set "C-z C-z" 'suspend-emacs)


(keymap-global-set "C-q ,"   'rename-buffer)
(keymap-global-set "C-q r"   'revert-buffer)
(keymap-global-set "C-q k"   'kill-current-buffer)

(keymap-global-set "C-q t"   'load-theme)
(keymap-global-set "C-q C-t" 'my/disable-all-themes)

(keymap-global-set "C-q ,"   'my/save-window-layout)
(keymap-global-set "C-q ."   'my/restore-window-layout)
(keymap-global-set "C-q /"   'my/list-window-layouts)
(keymap-global-set "C-q `"   'my/delete-window-layout)

(keymap-global-set "C-q <return>"   'my/start-process)
(keymap-global-set "C-q C-<return>" 'my/launcher)
(keymap-global-set "C-q S-<return>" 'my/spawn-st)


(keymap-global-set "C-v C-v" 'buffer-menu)
(keymap-global-set "C-v C-f" 'find-file)
(keymap-global-set "C-v b"   'switch-to-buffer)
(keymap-global-set "C-v C-b" 'list-buffers)
(keymap-global-set "C-v h"   'winner-undo)
(keymap-global-set "C-v j"   'next-buffer)
(keymap-global-set "C-v C-j" 'other-window)
(keymap-global-set "C-v k"   'previous-buffer)
(keymap-global-set "C-v C-k" 'my/other-window-1)
(keymap-global-set "C-v l"   'winner-redo)

(keymap-global-set "C-v SPC"   'rectangle-mark-mode)
(keymap-global-set "C-v C-SPC" 'rectangle-mark-mode)

(keymap-global-set "C-v C-t" 'tabify)
(keymap-global-set "C-v t"   'untabify)

(keymap-global-set "C-v C-e" 'read-only-mode)
(keymap-global-set "C-v C-n" 'my/toggle-line-numbers)
(keymap-global-set "C-v C-w" 'whitespace-mode)
(keymap-global-set "C-v RET" 'visual-line-mode)

(keymap-global-set "C-v C-r" 'replace-string)
(keymap-global-set "C-v C-s" 'string-rectangle)
(keymap-global-set "C-v C-a" 'org-agenda)
(keymap-global-set "C-v C-p" 'org-toggle-inline-images)

(keymap-global-set "C-v ,"   'bookmark-jump)
(keymap-global-set "C-v ."   'bookmark-set)
(keymap-global-set "C-v /"   'bookmark-bmenu-list)

(keymap-global-set "C-v C-," 'delete-other-windows)
(keymap-global-set "C-v C-." 'split-window-below)
(keymap-global-set "C-v C-_" 'split-window-right)
(keymap-global-set "C-v C-;" 'delete-window)

(keymap-global-set "C-v x"   'shell)
(keymap-global-set "C-v C-x" 'shell)

(keymap-global-set "C-v ["   'shell-command)
(keymap-global-set "C-v ]"   'compile)
(keymap-global-set "C-v C-]" 'recompile)

(keymap-global-set "C-v '"   'quoted-insert)
(keymap-global-set "C-v C-'" 'quoted-insert)


(use-package color
  :config
  (defun colorize-compilation-buffer ()
    ((let ((inhibit-read-only t))
       (ansi-color-apply-on-region (point-min) (point-max))))
    (add-hook 'compilation-filter-hook 'colorize-compilation-buffer))
  (setq shr-color-visible-luminance-min 100)
  (let* ((ws-lighten 30)
         (ws-color (color-lighten-name "#880044" ws-lighten)))
    (custom-set-faces
     `(whitespace-newline                ((t (:foreground ,ws-color))))
     `(whitespace-missing-newline-at-eof ((t (:foreground ,ws-color))))
     `(whitespace-space                  ((t (:foreground ,ws-color))))
     `(whitespace-space-after-tab        ((t (:foreground ,ws-color))))
     `(whitespace-space-before-tab       ((t (:foreground ,ws-color))))
     `(whitespace-tab                    ((t (:foreground ,ws-color))))
     `(whitespace-trailing               ((t (:foreground ,ws-color)))))))


(use-package magit
  :init
  (setq magit-define-global-key-bindings 'recommended)
  :bind
  ("C-x g" . magit-status)
  ("C-q g" . magit-status))


(use-package mu4e
  :init
  (autoload 'mu4e "mu4e" "mu4e mail" t)
  (defun my/mu4e-init ()
    (setq mu4e-update-interval 180)
    (with-eval-after-load "mm-decode"
      (add-to-list 'mm-discouraged-alternatives "text/html")
      (add-to-list 'mm-discouraged-alternatives "text/richtext")
      (add-to-list 'mm-discouraged-alternatives "multipart/related"))
    (add-to-list 'mu4e-view-mime-part-actions
                 '(:name "dmarc" :handler "gunzip -c | xmllint --format -" :receives pipe))
    (add-to-list 'mu4e-view-mime-part-actions
                 '(:name "lynx" :handler "lynx -dump -stdin -force_html -assume_charset=utf-8 -display_charset=utf-8 -assume_unrec_charset=utf-8 -assume_local_charset=utf-8" :receives pipe))
    (load "~/.emacs.d/mu4e.el"))
  (advice-add 'mu4e :around
              (lambda (orig-fun &rest args)
                (my/mu4e-init)
                (apply orig-fun args)))
  :bind
  ("C-q m" . mu4e))



(use-package notmuch
  :init
  (autoload 'notmuch "notmuch" "notmuch mail" t)
  (setq notmuch-show-logo nil
        notmuch-hello-thousands-separator ",")
  :bind
  ("C-q n" . notmuch))


(if (display-graphic-p)
    (progn
      (set-frame-font "monospace 13" nil t)
      (set-fontset-font "fontset-default" 'kana "Migu 1M")
      (set-fontset-font "fontset-default" 'han "Noto Sans CJK SC")
      (set-fontset-font "fontset-default" 'greek "Noto Sans Mono"))

  (xterm-mouse-mode 1)
  (setq mouse-drag-copy-region t)

  (unless (package-installed-p 'xclip)
    (package-refresh-contents)
    (package-install 'xclip))
  (xclip-mode 1)
  (setq select-enable-clipboard t)
  (setq select-enable-primary nil))

(defconst my/csi-u-special-keys
  '((9 . tab) (13 . return) (27 . escape) (127 . backspace))
  "CSI u codepoints that decode to function-key symbols.")

(defconst my/csi-letter-keys
  '((?A . up) (?B . down) (?C . right) (?D . left)
    (?H . home) (?F . end)
    (?P . f1) (?Q . f2) (?R . f3) (?S . f4))
  "Final bytes of CSI 1;<mod><X> and SS3 <X> sequences.")

(defconst my/csi-tilde-keys
  '((2 . insert) (3 . delete) (5 . prior) (6 . next)
    (15 . f5) (17 . f6) (18 . f7) (19 . f8)
    (20 . f9) (21 . f10) (23 . f11) (24 . f12))
  "Parameters of CSI <n>;<mod>~ sequences.")

(defun my/csi--mod-list (mods &optional shift-ok)
  "Modifier symbols for CSI modifier parameter MODS.
MODS is 1 + bitmask: 1=shift 2=alt/meta 4=ctrl 8=super.
Shift is included only when SHIFT-OK is non-nil."
  (let ((bits (1- mods)))
    (delq nil (list (and (/= 0 (logand bits 4)) 'control)
                    (and (/= 0 (logand bits 2)) 'meta)
                    (and (/= 0 (logand bits 8)) 'super)
                    (and shift-ok (/= 0 (logand bits 1)) 'shift)))))

(defun my/csi-u--event (code mods)
  "Return the Emacs event for CSI u CODE with modifier parameter MODS."
  (let* ((special (alist-get code my/csi-u-special-keys))
         (upper   (and (not special) (<= ?A code ?Z)))
         (base    (or special (if upper (downcase code) code)))
         (letter  (and (not special) (<= ?a base ?z)))
         ;; Shift only matters for letters and special keys; for other
         ;; printables the codepoint is already the shifted character.
         (shift-ok (or special letter))
         (mod-list (my/csi--mod-list mods shift-ok)))
    (when (and upper (not (memq 'shift mod-list)))
      (setq mod-list (append mod-list '(shift))))
    (if (and letter
             (memq 'shift mod-list)
             (not (memq 'control mod-list)))
        ;; S-a -> A, M-S-o -> M-O, s-S-x -> s-X
        (event-convert-list (append (remq 'shift mod-list)
                                    (list (upcase base))))
      (event-convert-list (append mod-list (list base))))))

(defconst my/csi-u-map
  (let ((map (make-sparse-keymap)))
    ;; Regular CSI u: \e[<code>;<mod>u
    (dolist (code (append (mapcar #'car my/csi-u-special-keys)
                          (number-sequence 32 126)))
      (dolist (mods (number-sequence 2 16))
        (define-key map (format "\e[%d;%du" code mods)
                    (vector (my/csi-u--event code mods)))))
    ;; Letter-final keys: \eO<X> and \e[1;<mod><X>
    (pcase-dolist (`(,final . ,key) my/csi-letter-keys)
      (define-key map (format "\eO%c" final) (vector key))
      (dolist (mods (number-sequence 2 16))
        (define-key map (format "\e[1;%d%c" mods final)
                    (vector (event-convert-list
                             (append (my/csi--mod-list mods t) (list key)))))))
    ;; Shift-Tab: \e[Z (kcbt), which Emacs leaves undecoded
    (define-key map "\e[Z" [backtab])
    ;; Tilde keys: \e[<n>~ and \e[<n>;<mod>~
    (pcase-dolist (`(,n . ,key) my/csi-tilde-keys)
      (define-key map (format "\e[%d~" n) (vector key))
      (dolist (mods (number-sequence 2 16))
        (define-key map (format "\e[%d;%d~" n mods)
                    (vector (event-convert-list
                             (append (my/csi--mod-list mods t) (list key)))))))
    map)
  "Decode map for CSI u and xterm-style modified function/cursor keys.")

(defun my/csi-u-install ()
  "Chain `my/csi-u-map' into this terminal's `input-decode-map'."
  (let ((map (copy-keymap my/csi-u-map)))
    (set-keymap-parent map (keymap-parent input-decode-map))
    (set-keymap-parent input-decode-map map))
  ;; st's terminfo also lists Home and End as keypad keys (ka1, kc1), so
  ;; Emacs binds them to kp-7 and kp-1 in `input-decode-map' itself,
  ;; where they win over the parent map above.
  (define-key input-decode-map "\e[1~" [home])
  (define-key input-decode-map "\e[4~" [end]))

(add-hook 'tty-setup-hook #'my/csi-u-install)
