;; -*- Mode: Emacs-Lisp -*-
;       $Id: .emacs,v 1.15 2001/06/25 13:31:58 richardc Exp $

(add-to-list 'load-path "~/.elisp")

;; If running under screen, disable C-z.
(if (and (getenv "STY") (not window-system))
    (global-unset-key "\C-z"))

;; force our cperl mode to be the local one
(load-file "/home/richardc/.elisp/cperl-mode.el")

(setq frame-title-format (list "" 
			       'invocation-name "@" 'system-name' ": %b"))

(cond ((or (equal (system-name) "mirth.demon.co.uk") (equal (system-name) "joxer.uk.oven.com"))
       (add-to-list 'load-path "~/.elisp/tramp/lisp")
       (require 'tramp)
       (setq tramp-default-method "scp")
       )
      )

(cond ((equal (system-name) "mirth.demon.co.uk")
       (load "python-mode")
       (add-to-list 'load-path "~/.elisp/monk")
       (load "monk")
       (load "mutt")
       (server-start)

       (monk-dired-bind-extra-keys)
       (setq monk-volume-command "aumix"
	     monk-use-cddb-server t
	     monk-dont-care-no-CD nil
	     monk-use-face t
	     monk-dired-monk-command 'monk-other-window)
       )
      )    


(cond ((string-match "XEmacs\\|Lucid" emacs-version)
       ;; yup - we're in XEmacs
       (load "vc")

       (cond ((or (equal (system-name) "mirth") (equal (system-name) "joxer.uk.oven.com"))
	      (add-to-list 'Info-directory-list "~/.elisp/tramp/texi/")
	      )
	     )

       (turn-on-lazy-shot)
       (custom-set-variables
	'(gnuserv-program (concat exec-directory "/gnuserv"))
	'(toolbar-visible-p nil))

       )
      (t 
       ;; I'm not sure if I like this cond t stuff for defaults
       ;; other emacsen (probably GNU Emacs)
       
       (load "mmm-mode")
       (mmm-add-find-file-hook)
       
       (global-font-lock-mode 1)
       
       (custom-set-faces
	'(mmm-default-submode-face ((t (:background "gray9"))))
	'(highline-face ((t (:background "gray30")))))
       )
      )

(setq cperl-indent-level 4
      line-number-mode 1
      column-number-mode 1
      indent-tabs-mode nil
      next-line-add-newlines nil
      flyspell-default-dictionary "british"
      c-default-style "linux")

(iswitchb-default-keybindings)

(defun perl-mode ()
  "overriden by a dirty hack to invoke cperl-mode"
  (interactive)
  (cperl-mode))

(defun nice-text-mode ()
  "setup a sane mode for editing english text"
  (interactive)
  (text-mode)
  (flyspell-mode)
  (auto-fill-mode))

(defun hacking-untabify-buffer ()
  "strip trailing whitespace and untabify a buffer"
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "[ \t]+$" nil t)
      (delete-region (match-beginning 0) (match-end 0)))
    (goto-char (point-min))
    (if (search-forward "\t" nil t)
        (untabify (1- (point)) (point-max))))
  nil)

(add-hook 'cperl-mode-hook
          '(lambda ()
             (make-local-variable 'write-contents-hooks)
             (add-hook 'write-contents-hooks 'hacking-untabify-buffer)))

