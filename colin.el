;; tcp for emacsclient to use multiple emacs buffers
;; see http://tychoish.com/rhizome/running-multiple-emacs-daemons-on-a-single-system/
;;(setq server-use-tcp t)

;;disable splash screen and startup message
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)

(add-to-list 'load-path "~/.emacs.d/libs")
(add-to-list 'load-path "~/.emacs.d/libs/js2-mode")

;; use emacsclient
;; http://www.emacswiki.org/cgi-bin/wiki/EmacsClient
(server-start)

;; http://ilovett.com/blog/emacs/emacs-frame-size-position
(defun arrange-frame (w h x y)
  "Set the width, height, and x/y position of the current frame"
  (let ((frame (selected-frame)))
    (delete-other-windows)
    (set-frame-position frame x y)
    (set-frame-size frame w h)))

(arrange-frame 140 70 2 22)

(require 'saveplace)
(setq-default save-place t)
(setq server-visit-hook (quote (save-place-find-file-hook)))

;;enable syntax highlight by default
(global-font-lock-mode t)
(setq font-lock-maximum-decoration t)

;;disable line wrapping
(setq-default truncate-lines t)

;;disable autosave and backup
;(setq auto-save-default nil)
(setq make-backup-files nil)

;; Force to use tabs for tabs and to be 4 spaces
(setq-default indent-tabs-mode t)
(setq-default tab-width 4)

;;default attributes for text-mode
(setq text-mode-hook '(lambda()
;;						(auto-fill-mode t) ;;physical line break
						(flyspell-mode t) ;;spellchek on the fly
						)
	  )

;;sets the file name as window title (for graphics emacs)
(set 'frame-title-format '(myltiple-frames "%b" ("" "%b")))

(require 'color-theme)
;;(require 'color-theme-solarized)
;;(color-theme-solarized-dark)
;(require 'color-theme-blackboard)
;(color-theme-blackboard)

(color-theme-initialize)
(color-theme-subtle-hacker)

;(require 'zenburn)
;(color-theme-zenburn)

;;(tool-bar-mode 1)
(menu-bar-mode 1)

(add-to-list 'same-window-buffer-names "*SQL*")

;; fancier fill
;;(setq-default filladapt-mode t)

;; no login for mysql
;;(require 'sql)
;;(defalias 'sql-get-login 'ignore)
(set 'sql-database "bzrails")
(set 'sql-user "root")

;; store mysql history
(defun my-sql-save-history-hook ()
  (let ((lval 'sql-input-ring-file-name)
		(rval 'sql-product))
	(if (symbol-value rval)
		(let ((filename
			   (concat "~/.emacs.d/sql/"
					   (symbol-name (symbol-value rval))
					   "-history.sql")))
		  (set (make-local-variable lval) filename))
	  (error
	   (format "SQL history will not be saved because %s is nil"
			   (symbol-name rval))))))
(add-hook 'sql-interactive-mode-hook 'my-sql-save-history-hook)


;; recent files module -- http://www.joegrossberg.com/archives/000182.html
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-items 25)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)

;; http://www.emacswiki.org/emacs/YamlMode
(require 'yaml-mode)
(add-hook 'yaml-mode-hook '(lambda () (define-key yaml-mode-map "\C-m" 'newline-and-indent)))

(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

;; "y or n" instead of "yes or no"
(fset 'yes-or-no-p 'y-or-n-p)

;; Highlight regions and add special behaviors to regions.
;; "C-h d transient" for more info
(setq transient-mark-mode t)

;; Display line and column numbers
(setq line-number-modet)

;; Emacs gurus don't need no stinking scroll bars
(toggle-scroll-bar -1)

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(fringe-mode 0 nil (fringe)))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "black" :foreground "cornsilk" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 102 :width normal :foundry "unknown" :family "DejaVu Sans Mono")))))

;;(require 'highlight-current-line)
;;(highlight-current-line-on t)

(require 'midnight)

;;(add-to-list 'load-path "~/.emacs.libs/icicles")
;;(require 'icicles)

;; Interactively Do Things (highly recommended, but not strictly required)
(require 'ido)
(ido-mode t)

;; grep-find config
(global-set-key (kbd "M-3") 'grep-find)
(setq grep-find-command
"find . -path '*/.svn' -prune -o -type f -print0 | xargs -0 grep -in ")


;; @see http://stackoverflow.com/questions/3139970/open-a-file-at-line-with-filenameline-syntax
(defun emacs-uri-handler (uri)
  "Handles emacs URIs in the form: emacs:///path/to/file/LINENUM"
  (save-match-data
    (if (string-match "emacs://\\(.*\\)/\\([0-9]+\\)$" uri)
        (let ((filename (match-string 1 uri))
              (linenum (match-string 2 uri)))
          (while (string-match "\\(%20\\)" filename)
            (setq filename (replace-match " " nil t filename 1)))
          (with-current-buffer (find-file filename)
            (goto-line (string-to-number linenum))))
      (beep)
      (message "Unable to parse the URI <%s>"  uri))))


;; ido
(setq ido-use-filename-at-point nil)

(setq speedbar-frame-parameters
      '((minibuffer)
	(width . 40)
	(border-width . 0)
	(menu-bar-lines . 0)
	(tool-bar-lines . 0)
	(unsplittable . t)
	(left-fringe . 0)))
(setq speedbar-hide-button-brackets-flag t)
(setq speedbar-show-unknown-files t)
(setq speedbar-smart-directory-expand-flag t)
(setq speedbar-use-images nil)
;;(setq sr-speedbar-auto-refresh nil)
;;(setq sr-speedbar-max-width 70)
;;(setq sr-speedbar-right-side nil)
;;(setq sr-speedbar-width-console 40)

(provide 'buffers)

(setq grep-files-aliases (cons "rails" "*.rb *.erb *.js *.css"))

;; turn off ruby deep indentation
;; see http://stackoverflow.com/questions/7404816/emacs-ruby-mode-indenting-wildly-inside-parentheses
(setq ruby-deep-indent-paren nil)


;;
;; FYI my auto indent key is F2.
;;
(defun indent-buffer ()
    (interactive)
    (save-excursion (indent-region (point-min) (point-max) nil))
)
(global-set-key [f2] 'indent-buffer)

(require 'ws-trim)
(global-ws-trim-mode t)
(set-default 'ws-trim-level 2)
;;(setq ws-trim-global-modes '(guess (not message-mode eshell-mode)))

(add-hook 'before-save-hook 'delete-trailing-whitespace)

;;(setq exec-path (cons (expand-file-name "~/.rvm/gems/ruby/1.9.2-p290/bin") exec-path))
;;(require 'scss-mode)
(setq scss-compile-at-save nil)


;;(autoload 'scss-mode "scss-mode")
;;(add-to-list 'auto-mode-alist '("\\.scss\\'" . scss-mode))

;;
;; fix closing brackets on css
;;
(setq cssm-indent-level 2)
(setq cssm-newline-before-closing-bracket t)
(setq cssm-indent-function #'cssm-c-style-indenter)
(setq cssm-mirror-mode nil)

(autoload 'espresso-mode "espresso")
(defun my-js2-indent-function ()
  (interactive)
  (save-restriction
    (widen)
    (let* ((inhibit-point-motion-hooks t)
           (parse-status (save-excursion (syntax-ppss (point-at-bol))))
           (offset (- (current-column) (current-indentation)))
           (indentation (espresso--proper-indentation parse-status))
           node)

      (save-excursion

        ;; I like to indent case and labels to half of the tab width
        (back-to-indentation)
        (if (looking-at "case\\s-")
            (setq indentation (+ indentation (/ espresso-indent-level 2))))

        ;; consecutive declarations in a var statement are nice if
        ;; properly aligned, i.e:
        ;;
        ;; var foo = "bar",
        ;;     bar = "foo";
        (setq node (js2-node-at-point))
        (when (and node
                   (= js2-NAME (js2-node-type node))
                   (= js2-VAR (js2-node-type (js2-node-parent node))))
          (setq indentation (+ 4 indentation))))

      (indent-line-to indentation)
      (when (> offset 0) (forward-char offset)))))

(defun my-indent-sexp ()
  (interactive)
  (save-restriction
    (save-excursion
      (widen)
      (let* ((inhibit-point-motion-hooks t)
             (parse-status (syntax-ppss (point)))
             (beg (nth 1 parse-status))
             (end-marker (make-marker))
             (end (progn (goto-char beg) (forward-list) (point)))
             (ovl (make-overlay beg end)))
        (set-marker end-marker end)
        (overlay-put ovl 'face 'highlight)
        (goto-char beg)
        (while (< (point) (marker-position end-marker))
          ;; don't reindent blank lines so we don't set the "buffer
          ;; modified" property for nothing
          (beginning-of-line)
          (unless (looking-at "\\s-*$")
            (indent-according-to-mode))
          (forward-line))
        (run-with-timer 0.5 nil '(lambda(ovl)
                                   (delete-overlay ovl)) ovl)))))

(defun my-js2-mode-hook ()
  (require 'espresso)
  (setq espresso-indent-level 2
        indent-tabs-mode nil
        c-basic-offset 2)
  (c-toggle-auto-state 0)
  (c-toggle-hungry-state 1)
  (set (make-local-variable 'indent-line-function) 'my-js2-indent-function)
  (define-key js2-mode-map [(meta control |)] 'cperl-lineup)
  (define-key js2-mode-map [(meta control \;)]
    '(lambda()
       (interactive)
       (insert "/* -----[ ")
       (save-excursion
         (insert " ]----- */"))
       ))
  (define-key js2-mode-map [(return)] 'newline-and-indent)
  (define-key js2-mode-map [(backspace)] 'c-electric-backspace)
  (define-key js2-mode-map [(control d)] 'c-electric-delete-forward)
  (define-key js2-mode-map [(control meta q)] 'my-indent-sexp)
  (if (featurep 'js2-highlight-vars)
    (js2-highlight-vars-mode))

  ;; fix bug with my-indent-sexp
  (setq c-current-comment-prefix
		(if (listp c-comment-prefix-regexp)
			(cdr-safe (or (assoc major-mode c-comment-prefix-regexp)
						  (assoc 'other c-comment-prefix-regexp)))
		  c-comment-prefix-regexp))

  (message "My JS2 hook"))



(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(add-hook 'js2-mode-hook 'my-js2-mode-hook)
(setq espresso-indent-level 2)
(setq js-indent-level 2)

;;(setq js2-consistent-level-indent-inner-bracket-p t)
;;(setq js2-auto-indent-p t)
;;(setq js2-idle-timer-delay 0.5)
;;(setq js2-use-ast-for-indentation-p t)
;;(setq js2-enter-indents-newline t)


(require 'toggle)
