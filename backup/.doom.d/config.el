;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!
(require 'multiple-cursors)
(require 'shell)
(require 'vc)
(require 'undo-tree)
(require 'company)

(setq
 mac-command-modifier   'meta            ; Apple/Command key is Meta
 mac-option-modifier 'super                                       ; Option is the Mac Option key
 mouse-wheel-scroll-amount '(1)
 mouse-wheel-progressive-speed nil)

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Joe Hirn"
      user-mail-address "joseph.hirn@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; (global-linum-mode)
;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.


(defun set-font-size (font-height)
  (custom-set-faces `(default ((t (:height ,font-height :family "monaco"))))))


(defun set-font-mba ()
  (interactive)
  (set-font-size 110))

(defun set-font-home ()
  (interactive)
  (set-font-size 140))

(defun set-font-pairing-station ()
  (interactive)
  (set-font-size 185))

(defun set-font-google-meet ()
  (interactive)
  (set-font-size 200))

(defun set-font-projector ()
   (interactive)
  (set-font-size 300))

(blink-cursor-mode t)
(set-default 'cursor-type '(bar . 2))

(setq vc-suppress-confirm t)
(setq vc-follow-symlinks t)

(defun switch-to-previous-buffer ()
  "toggle between current and previous buffer"
  (interactive)
  (switch-to-buffer (other-buffer)))

(define-key mc/keymap (kbd "C-;") 'mc-hide-unmatched-lines-mode)

(defadvice yes-or-no-p (around prevent-dialog activate)
  "Prevent yes-or-no-p from activating a dialog"
  (let ((use-dialog-box nil))
    ad-do-it))

(defadvice y-or-n-p (around prevent-dialog-yorn activate)
  "Prevent y-or-n-p from activating a dialog"
  (let ((use-dialog-box nil))
    ad-do-it))


(setq confirm-kill-emacs 'y-or-n-p)
(setq undo-tree-visualizer-timestamps 't)


(setq explicit-shell-file-name "bash")
(setq shell-file-name "/usr/local/bin/bash")
(setq explicit-bash-args '("-c" "export EMACS=; stty echo; bash --login -i"))
(setq auto-mode-alist
      (cons '("\\.bats\'" . sh-mode) auto-mode-alist))
(setq window-combination-resize t)


(setq company-idle-delay 0)
(setq company-minimum-prefix-length 1)
(setq company-show-numbers t)
(setq company-tooltip-limit 30)


(setq +format-on-save-enabled-modes
      '(not emacs-lisp-mode  ; elisp's mechanisms are good enough
            sql-mode         ; sqlformat is currently broken
            tex-mode         ; latexindent is broken
            latex-mode))

(defun prelude-rename-file-and-buffer ()
  "Renames current buffer and file it is visiting."
  (interactive)
  (let ((filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (message "Buffer is not visiting a file!")
      (let ((new-name (read-file-name "New name: " filename)))
        (cond
         ((vc-backend filename) (vc-rename-file filename new-name))
         (t
          (rename-file filename new-name t)
          (set-visited-file-name new-name t t)))))))

(defun prelude-delete-file-and-buffer ()
  "Kill the current buffer and deletes the file it is visiting."
  (interactive)
  (let ((filename (buffer-file-name)))
    (when filename
      (if (vc-backend filename)
          (vc-delete-file filename)
        (progn
          (delete-file filename)
          (message "Deleted file %s" filename)
          (kill-buffer))))))

(defun simulate-key-press (key)
  "Pretend that KEY was pressed.
KEY must be given in `kbd' notation."
  `(lambda () (interactive)
     (setq prefix-arg current-prefix-arg)
     (setq unread-command-events (listify-key-sequence (read-kbd-macro ,key)))))

(defun set-transparancy (transparancy-level)
  (set-frame-parameter (selected-frame) 'alpha transparancy-level))

(defun toggle-transparency ()
  (interactive)
  (if (/=
       (or (cadr (frame-parameter nil 'alpha)) 100)
       100)
      (set-frame-parameter nil 'alpha '(100 100))
    (set-frame-parameter nil 'alpha '(88 82))))

(global-set-key (kbd "C-\\") 'switch-to-previous-buffer)
(global-set-key (kbd "A-M-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "A-M-<up>") 'enlarge-window)
(global-set-key (kbd "A-M-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "A-M-<down>") 'shrink-window)
(global-set-key (kbd "C-R") 'rename-window)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C-S-c C->") 'mc/skip-to-next-like-this)
(global-set-key (kbd "C-S-c C-<") 'mc/skip-to-next-like-this)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
(global-set-key (kbd "C-c R") 'prelude-rename-file-and-buffer)
(global-set-key (kbd "C-c D") 'prelude-delete-file-and-buffer)
(global-set-key (kbd "C-c C-p") (simulate-key-press "C-c p"))
(global-set-key (kbd "C-c M-t") 'toggle-transparency)
(global-set-key (kbd "M-y") 'yank-pop)
(global-set-key (kbd "C-c C-\\") '+popup/restore)

(setq rspec-autosave-buffer t)
(add-hook 'after-init-hook 'inf-ruby-switch-setup)


(global-auto-revert-mode t)
(+global-word-wrap-mode +1)
(set-font-home)

(setq all-the-icons-scale-factor 0.9
      tab-always-indent 't
      kill-do-not-save-duplicates 't
      global-whitespace-mode 't)


(after! doom-modeline
  (doom-modeline-def-modeline 'main
    '(bar matches buffer-info remote-host buffer-position parrot selection-info)
    '(misc-info minor-modes checker input-method buffer-encoding major-mode process vcs "  ")))
(setq rspec-use-spring-when-possible 't)


(defun save-all ()
  (interactive)
  (save-some-buffers t))

(add-hook 'focus-out-hook 'save-all)
(add-hook 'inf-ruby-mode-hook (lambda () (company-mode 0)))
(setq helm-mode-fuzzy-match t)

(use-package counsel
  :bind
  (("M-y" . counsel-yank-pop)
   :map ivy-minibuffer-map
   ("M-y" . ivy-next-line-and-call)))

(setenv "PAGER" "cat")
(global-auto-revert-mode)
