;;; package --- Summary
;; Vineet's Emacs Init File


;;; Code:
(require 'package)
(add-to-list 'package-archives
         '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)

(when (not package-archive-contents)
    (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)
(load-theme 'deeper-blue t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

; Basic CPP style
(c-add-style "my-Cstyle" '("linux"
			  (indent-tabs-mode . nil)        ; use spaces rather than tabs
			  (c-basic-offset . 4)            ; indent by four spaces
        (c-offsets-alist . ((innamespace . [0]))) ; no indentation for namespaces
			  )
)
(defun my-c++-mode-hook() (c-set-style "my-Cstyle")(auto-fill-mode)
       (c-toggle-auto-hungry-state 1))
(add-hook 'c++-mode-hook 'my-c++-mode-hook)

; Shift UP-DOWN-LEFT-RIGHT allows you to move between frames
(windmove-default-keybindings)

; Use RTAGS to create a symbol database
; This DB is used to jump-to definitions and find symbols and references
(load "rtags")
; C-c r .  is used to jump tp definition/declaration
; see rtags.el for list of keybindings
(rtags-enable-standard-keybindings)

; irony-mode for completion in C and C++
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

; TAB-complete symbols and functions
(c++-mode)
(define-key c++-mode-map  [(C-tab)] 'completion-at-point)

; Default mode for .h files is c++ since mostly I am writing c++
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

; helm
; (require 'setup-helm-gtags)
; (require 'setup-helm)

; (require 'setup-general)
; (require 'setup-cedet)
; (require 'setup-editing)

(require 'projectile)

; ;;;;;; KEY BINDINGS ;;;;;;;

; Find any file in repo
; (global-set-key (kbd "C-x f") 'projectile-find-file)

; General Identifier Search, search across classes, functions etc
; This search is enabled by etags
; ToDo - add command to regenerate etags
(global-set-key (kbd "C-,") 'xref-find-definitions)

; Jump to function inside file with Helm Imenu
(global-set-key (kbd "C-c j") 'helm-imenu)

; Switch between .cpp and .h files of the same base name
(global-set-key (kbd "C-c C-f o") 'projectile-find-other-file)

; Save all open buffers
(defun save-all () (interactive) (save-some-buffers t))
(global-set-key (kbd "C-c s") 'save-all)

; Grep
(global-set-key (kbd "C-c g") 'projectile-grep)

; Save all open files and Compile, same as F5 in visual studio
(defun save-all-and-recompile () (interactive)
  (save-all)
  (recompile))

(global-set-key [f5] 'save-all-and-recompile)
(global-set-key [f9] 'compile)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 '(package-selected-packages
   (quote
    (projectile ws-butler volatile-highlights use-package undo-tree sr-speedbar rtags json-mode irony-eldoc iedit helm-swoop helm-projectile helm-gtags function-args flymake-cursor flycheck-irony find-file-in-repository dtrt-indent dirtree-prosjekt counsel company color-theme codesearch cmake-mode cmake-ide clean-aindent-mode anzu))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


(setq-default cursor-type 'bar)

; Always highlight matching parentheses
(show-paren-mode 1)

;; Enable WS butler
(ws-butler-mode 1)


; Make the current window dedicated
(defun toggle-sticky-buffer-window ()
  "Toggle whether this window is dedicated to this buffer."
  (interactive)
  (set-window-dedicated-p
   (selected-window)
   (not (window-dedicated-p (selected-window))))
  (if (window-dedicated-p (selected-window))
      (message "Window is now dedicated.")
    (message "Window is no longer dedicated.")))

(global-set-key [(super d)] 'toggle-sticky-buffer-window)
(set-default-font "Courier 10 Pitch")

;; Scrolling compilation buffer
(setq compilation-scroll-output t)
