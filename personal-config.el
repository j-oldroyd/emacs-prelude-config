(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(mac-command-modifier 'super)
 '(mac-option-modifier 'meta)
 '(mac-right-command-modifier 'control))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;;; Emacs GUI settings
;; Prelude hides the toolbar, so turn it back on.
(tool-bar-mode 1)

;;;; Completion settings
;; Configure directory extension for vertico to look more like ido.
(use-package vertico-directory
  :after vertico
  :ensure nil
  ;; More convenient directory navigation commands
  :bind (:map vertico-map
              ("RET" . vertico-directory-enter)
              ("DEL" . vertico-directory-delete-char)
              ("M-DEL" . vertico-directory-delete-word))
  ;; Tidy shadowed file names
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy))

;;;; Org settings
(use-package org-bullets
  :ensure t)
(add-hook 'org-mode-hook
          (lambda ()
            (org-bullets-mode 1)))
;; Prelude uses S-arrow for windmove keybindings which conflicts with org-mode
;; basics. Therefore we use C-arrow prefix instead. On macOS this appears to
;; only work with right-command, as left-control (on laptop) has different
;; result.
(windmove-default-keybindings 'ctrl)

;; Set Org-mode indentation
(setq org-adapt-indentation t)
;; This is for key bindings to invoke agenda mode (see line-2)
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-cb" 'org-iswitchb)

;;(setq org-default-notes-file (concat org-directory "/notes.org"))


;;Changes TODO to done automatically if children tasks done
(defun org-summary-todo (n-done n-not-done)
  "Switch entry to DONE when all subentries are done, to TODO otherwise."
  (let (org-log-done org-log-states)   ; turn off logging
    (org-todo (if (= n-not-done 0) "DONE" "TODO"))))

(add-hook 'org-after-todo-statistics-hook 'org-summary-todo)

;; Define the custum capture templates
(setq org-capture-templates
       '(("t" "todo" entry (file org-default-notes-file)
	  "* TODO %?\n%u\n%a\n" :clock-in t :clock-resume t)
	 ("m" "Meeting" entry (file org-default-notes-file)
	  "* MEETING with %? :MEETING:\n%t" :clock-in t :clock-resume t)
	 ("d" "Diary" entry (file+datetree "~/org/diary.org")
	  "* %?\n%U\n" :clock-in t :clock-resume t)
	 ("i" "Idea" entry (file org-default-notes-file)
	  "* %? :IDEA: \n%t" :clock-in t :clock-resume t)
	 ("n" "Next Task" entry (file+headline org-default-notes-file "Tasks")
	  "** NEXT %? \nDEADLINE: %t") ))

(when window-system
    (global-hl-line-mode))


(setq org-src-fontify-natively t)

(add-hook 'org-mode-hook 'flyspell-mode)

(setq org-latex-create-formula-image-program 'dvipng)


;; Sets up smex. This is for "fuzzy search" in M-x entries.
;; Only use if also using ido in prelude-modules instead of vertico.
;;(use-package smex :ensure t)
;;(autoload 'smex "smex"
;;  "Smex is a M-x enhancement for Emacs, it provides a convenient interface to
;;your recently and most frequently used commands.")

;;(global-set-key (kbd "M-x") 'smex)
;;(global-set-key (kbd "M-x") 'execute-extended-command)
;; Sets up Ispell.
;;(setq ispell-program-name "/usr/local/Cellar/ispell/3.4.05/bin/ispell")

;; Set up aspell
(setq ispell-extra-args '("--lang=en_US"))

;; For use with MacBook trackpad. This allows the track pad to be used with
;; fly spell-mode. This uses Option+click for Mouse-2 and Cmd+click for
;; mouse-3.
(setq mac-emulate-three-button-mouse t)

;; Enables writegood-mode.
(use-package writegood-mode :ensure t)
(global-set-key "\C-c\C-wg" 'writegood-mode)

;; Org mode 80 character limit
;; Taken from
;; https://emacs.stackexchange.com/questions/35266/org-mode-auto-new-line-at-80th-column
(add-hook 'org-mode-hook '(lambda () (setq fill-column 80)))
(add-hook 'org-mode-hook 'auto-fill-mode)

;; Sets up org-mode files for capture/refile.
(setq org-agenda-files '("~/Documents/org"))
(setq org-default-notes-file
      (expand-file-name "~/Documents/org/notes.org"))

(setq org-refile-targets
      '((nil :maxlevel . 3)
        (org-agenda-files :maxlevel . 3)))

;; Enables rainbow-highlighters for LaTeX.
(add-hook 'LaTeX-mode-hook #'rainbow-delimiters-mode)
(add-hook 'TeX-mode-hook #'rainbow-delimiters-mode)

;; Enables highlighted lines.
(global-hl-line-mode 1)
(set-face-background 'hl-line "009999")
(set-face-foreground 'highlight nil)

;; Enables YASnippet.
(add-to-list 'load-path
              "~/.emacs.d/plugins/yasnippet")
(use-package yasnippet
  :ensure t)
(yas-global-mode 1)

;;;; AucTeX/LaTeX
;; Gets live preview to work right.
(setq preview-gs-command "/usr/local/bin/gs")

;; Tells emacs where to find LaTeX.
(let
    ((my-path
      (expand-file-name
       "/usr/local/bin:/usr/local/texlive/2023/bin/universal-darwin")))
    (setenv "PATH" (concat my-path ":" (getenv "PATH")))
    (add-to-list 'exec-path my-path))

;; AucTeX
(add-hook 'LaTeX-mode-hook 'visual-line-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
;;(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode) ;; Might interfere with Prelude
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)

;; Reset TeX-open/close-quote from Prelude definitions
(setq TeX-open-quote "``")
(setq TeX-close-quote "''")

;;;; latexmk
;; Use Skim as viewer, enable source <-> PDF sync
;; make latexmk available via C-c C-c
;; Note: SyncTeX is setup via ~/.latexmkrc (see below)
(add-hook 'LaTeX-mode-hook (lambda ()
  (push
    '("latexmk" "latexmk -pdf %s" TeX-run-TeX nil t
      :help "Run latexmk on file")
    TeX-command-list)))
(add-hook 'TeX-mode-hook '(lambda () (setq TeX-command-default "latexmk")))

;;;; Skim PDF
;; use Skim as default pdf viewer
;; Skim's displayline is used for forward search (from .tex to .pdf)
;; option -b highlights the current line; option -g opens Skim in the background
;;(setq TeX-view-program-selection '((output-pdf "PDF Viewer")))
;;(setq TeX-view-program-list
;;      '(("PDF Viewer" "/Applications/Skim.app/Contents/SharedSupport/displayline -b  %n %o %b")))

;;;; PDF Tools
;; Install pdf-tools for use with LaTeX.
;; Taken fromhttps://www.reddit.com/r/emacs/comments/gm1c2p/pdftools_installation/
(use-package pdf-tools
  :ensure t
  :config
  (pdf-tools-install)
  (setq-default pdf-view-display-size 'fit-page))

;; Apparently line numbers break horizontal scrolling in PDF Tools.
;; Code below taken from
;; emacs.stackexchange.com/questions/74317/how-can-i-get-horizontal-scrolling-in-pdfview-to-work
(defun bugfix-display-line-numbers--turn-on (fun &rest args)
  "Avoid `display-line-numbers-mode' in `image-mode' and related.
Around advice for FUN with ARGS."
  (unless (derived-mode-p 'image-mode 'docview-mode 'pdf-view-mode)
    (apply fun args)))

(advice-add 'display-line-numbers--turn-on :around #'bugfix-display-line-numbers--turn-on)

;; Code below is taken from
;; https://emacs.stackexchange.com/questions/19472/how-to-let-auctex-open-pdf-with-pdf-tools
;; Use pdf-tools to open PDF files
(setq TeX-view-program-selection '((output-pdf "PDF Tools"))
      TeX-source-correlate-mode t
      TeX-source-correlate-start-server t
      TeX-source-correlate-method (quote synctex))

;; Update PDF buffers after successful LaTeX runs
(add-hook 'TeX-after-compilation-finished-functions
          #'TeX-revert-document-buffer)

;;  emacs-sage-shell
(use-package sage-shell-mode
  :ensure t)

;; AucTeX keybindings for SageTeX with emacs-sage-shell
;; From Github documentation
(eval-after-load "latex"
  '(mapc (lambda (key-cmd) (define-key LaTeX-mode-map (car key-cmd) (cdr key-cmd)))
         `((,(kbd "C-c s c") . sage-shell-sagetex:compile-current-file)
           (,(kbd "C-c s C") . sage-shell-sagetex:compile-file)
           (,(kbd "C-c s r") . sage-shell-sagetex:run-latex-and-load-current-file)
           (,(kbd "C-c s R") . sage-shell-sagetex:run-latex-and-load-file)
           (,(kbd "C-c s l") . sage-shell-sagetex:load-current-file)
           (,(kbd "C-c s L") . sage-shell-sagetex:load-file)
           (,(kbd "C-c C-z") . sage-shell-edit:pop-to-process-buffer))))
