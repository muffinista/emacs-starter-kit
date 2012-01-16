;;; starter-kit-elpa.el --- Install a base set of packages automatically.
;;
;; Part of the Emacs Starter Kit

(require 'cl)

(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))

(defvar my-packages '(idle-highlight
					  ruby-mode
					  css-mode
					  yaml-mode
					  rinari
					  find-file-in-project
					  gist
					  starter-kit
					  starter-kit-bindings
					  starter-kit-eshell
					  starter-kit-ruby
					  starter-kit-js
					  color-theme-zenburn
					  color-theme-wombat+
					  color-theme-solarized
					  color-theme-gruber-darker
					  color-theme-blackboard
					  scss-mode markdown-mode
					  undo-tree)
  "Libraries that should be installed by default.")
;;
;; starter-kit-misc  starter-kit-registers start-kit-bindings
;; js2-mode

;; multi-project ??
;; rvm


(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))


;; Workaround for an ELPA bug that people are reporting but I've been
;; unable to reproduce:
(autoload 'paredit-mode "paredit" "" t)

;; Workaround for bug in the ELPA package for yaml-mode
(autoload 'yaml-mode "yaml-mode" "" t)

(provide 'starter-kit-elpa)
