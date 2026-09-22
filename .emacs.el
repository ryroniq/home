;; -*- lexical-binding: t; -*-

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

(set-frame-font "monospace 13" nil t)
(set-fontset-font "fontset-default" 'kana "Migu 1M")
(set-fontset-font "fontset-default" 'han "Noto Sans CJK SC")
(set-fontset-font "fontset-default" 'greek "Noto Sans Mono")

(scroll-bar-mode 0)
(menu-bar-mode 0)
(tool-bar-mode 0)

(column-number-mode 1)
(winner-mode 1)

(setq
 magit-define-global-key-bindings 'recommended
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


(keymap-global-unset "C-x C-z")
(keymap-global-unset "C-q")
(keymap-global-unset "C-z")
(keymap-global-unset "C-M-v")
(keymap-global-unset "C-M-S-v")

(keymap-global-set "<f1>"    'my/spawn-st)
(keymap-global-set "<f2>"    'shell)

(keymap-global-set "C-]"     'other-window)
(keymap-global-set "C-\\"    'my/other-window-1)

(keymap-global-set "C-v"     'other-window)
(keymap-global-set "M-v"     'my/x-selection-to-emacs)

(keymap-global-set "M-L"     'mark-word)

(keymap-global-set "C-{"     'winner-undo)
(keymap-global-set "C-}"     'winner-redo)

(keymap-global-set "<prior>"   'my/scroll-half-down)
(keymap-global-set "<next>"    'my/scroll-half-up)
(keymap-global-set "C-<prior>" 'scroll-down-command)
(keymap-global-set "C-<next>"  'scroll-up-command)

(keymap-global-set "C-,"   'my/scroll-half-down)
(keymap-global-set "C-."   'my/scroll-half-up)
(keymap-global-set "M-,"   'scroll-down-command)
(keymap-global-set "M-."   'scroll-up-command)
(keymap-global-set "C-M-," 'beginning-of-buffer)
(keymap-global-set "C-M-." 'end-of-buffer)
(keymap-global-set "C-<"   'my/scroll-half-down-other-window)
(keymap-global-set "C->"   'my/scroll-half-up-other-window)
(keymap-global-set "M-<"   'scroll-other-window-down)
(keymap-global-set "M->"   'scroll-other-window)
(keymap-global-set "C-M-<" 'beginning-of-buffer-other-window)
(keymap-global-set "C-M->" 'end-of-buffer-other-window)

(keymap-global-set "M-z" 'backward-delete-char-untabify)
(keymap-global-set "M-Z" 'delete-char)
(keymap-global-set "M-o" 'my/duplicate-dwim)
(keymap-global-set "M-O" 'my/duplicate-line)

(keymap-global-set "M-p" 'backward-paragraph)
(keymap-global-set "M-n" 'forward-paragraph)
(keymap-global-set "M-[" 'my/transpose-line-backward)
(keymap-global-set "M-]" 'my/transpose-line-forward)

(keymap-global-set "C-M-k"   'kill-sexp)
(keymap-global-set "C-M-S-k" 'backward-kill-sexp)

(keymap-global-set "C-z ,"   'rename-buffer)
(keymap-global-set "C-z r"   'revert-buffer)
(keymap-global-set "C-z k"   'kill-current-buffer)

(keymap-global-set "C-z t"   'load-theme)
(keymap-global-set "C-z C-t" 'my/disable-all-themes)
(keymap-global-set "C-z >"   'suspend-emacs)

(keymap-global-set "C-q 1"   'delete-other-windows)
(keymap-global-set "C-q C-1" 'delete-other-windows)
(keymap-global-set "C-q 2"   'split-window-below)
(keymap-global-set "C-q C-2" 'split-window-below)
(keymap-global-set "C-q 3"   'split-window-right)
(keymap-global-set "C-q C-3" 'split-window-right)
(keymap-global-set "C-q 0"   'delete-window)
(keymap-global-set "C-q C-0" 'delete-window)

(keymap-global-set "C-q q"   'switch-to-buffer)
(keymap-global-set "C-q C-q" 'buffer-menu)
(keymap-global-set "C-q C-f" 'find-file)
(keymap-global-set "C-q b"   'switch-to-buffer)
(keymap-global-set "C-q C-b" 'switch-to-buffer)
(keymap-global-set "C-q h"   'previous-buffer)
(keymap-global-set "C-q l"   'next-buffer)

(keymap-global-set "C-q SPC"   'rectangle-mark-mode)
(keymap-global-set "C-q C-SPC" 'rectangle-mark-mode)

(keymap-global-set "C-q C-t" 'tabify)
(keymap-global-set "C-q t"   'untabify)

(keymap-global-set "C-q C-w" 'whitespace-mode)
(keymap-global-set "C-q C-e" 'read-only-mode)
(keymap-global-set "C-q C-o" 'overwrite-mode)
(keymap-global-set "C-q C-r" 'replace-string)
(keymap-global-set "C-q C-s" 'string-rectangle)
(keymap-global-set "C-q C-v" 'visual-line-mode)
(keymap-global-set "C-q C-a" 'org-agenda)
(keymap-global-set "C-q C-p" 'org-toggle-inline-images)
(keymap-global-set "C-q C-n" 'my/toggle-line-numbers)

(keymap-global-set "C-q y"   'winner-redo)
(keymap-global-set "C-q C-y" 'winner-undo)

(keymap-global-set "C-q ,"   'my/save-window-layout)
(keymap-global-set "C-q ."   'my/restore-window-layout)
(keymap-global-set "C-q /"   'my/list-window-layouts)
(keymap-global-set "C-q `"   'my/delete-window-layout)

(keymap-global-set "C-q C-j" 'bookmark-jump)
(keymap-global-set "C-q C-k" 'bookmark-set)
(keymap-global-set "C-q C-l" 'bookmark-bmenu-list)

(keymap-global-set "C-q x"   'my/spawn-st)
(keymap-global-set "C-q X"   'shell)

(keymap-global-set "C-q ["   'shell-command)
(keymap-global-set "C-q ]"   'compile)
(keymap-global-set "C-q C-]" 'recompile)

(keymap-global-set "C-q '"   'quoted-insert)
(keymap-global-set "C-q C-'" 'quoted-insert)

(keymap-global-set "C-q g"   'magit-status)
(keymap-global-set "C-x g"   'magit-status)

(keymap-global-set "C-q m"   'mu4e)
(keymap-global-set "C-q n"   'notmuch)

(keymap-global-set "C-q <return>"   'my/start-process)
(keymap-global-set "C-q C-<return>" 'my/launcher)
(keymap-global-set "C-q S-<return>" 'my/spawn-st)


(defun colorize-compilation-buffer ()
  (let ((inhibit-read-only t))
    (ansi-color-apply-on-region (point-min) (point-max))))
(add-hook 'compilation-filter-hook 'colorize-compilation-buffer)


(require 'color)
(let* ((ws-lighten 30)
       (ws-color (color-lighten-name "#880044" ws-lighten)))
  (custom-set-faces
   `(whitespace-newline                ((t (:foreground ,ws-color))))
   `(whitespace-missing-newline-at-eof ((t (:foreground ,ws-color))))
   `(whitespace-space                  ((t (:foreground ,ws-color))))
   `(whitespace-space-after-tab        ((t (:foreground ,ws-color))))
   `(whitespace-space-before-tab       ((t (:foreground ,ws-color))))
   `(whitespace-tab                    ((t (:foreground ,ws-color))))
   `(whitespace-trailing               ((t (:foreground ,ws-color))))))

(setq shr-color-visible-luminance-min 100)

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

(autoload 'notmuch "notmuch" "notmuch mail" t)
(setq
 notmuch-show-logo nil
 notmuch-hello-thousands-separator ","
 )
