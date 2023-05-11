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


(use-package org-bullets
  :ensure t)
(add-hook 'org-mode-hook
          (lambda ()
            (org-bullets-mode 1)))

;; Set Org-mode indentation
(setq org-adapt-indentation t)
;; This is for key bindings to invoke agenda mode (see line-2)
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-cb" 'org-iswitchb)

(setq org-agenda-files '("~/Google Drive/org"))
(setq org-default-notes-file (concat org-directory "/notes.org"))
(setq org-refile-targets (quote ((nil :maxlevel . 9)
                                 (org-agenda-files :maxlevel . 9))))

;;Changes TODO to done automatically if children tasks are done
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


;; Sets up smex. This is used for "fuzzy search" in M-x entries.
;; Only use if also using ido in prelude-modules instead of vertico.
;;(use-package smex :ensure t)
;;(autoload 'smex "smex"
;;  "Smex is a M-x enhancement for Emacs, it provides a convenient interface to
;;your recently and most frequently used commands.")

;;(global-set-key (kbd "M-x") 'smex)
;;(global-set-key (kbd "M-x") 'execute-extended-command)
;; Sets up ispell.
;;(setq ispell-program-name "/usr/local/Cellar/ispell/3.4.05/bin/ispell")

;; Enables writegood-mode.
(use-package writegood-mode :ensure t)
(global-set-key "\C-c\C-wg" 'writegood-mode)

;; Sets up org-mode files for capture/refile.
(setq org-default-notes-file (expand-file-name "~/org/notes.org"))
(setq org-agenda-files (list "~/org/research.org"
			     "~/org/academics.org"
			     "~/org/personal.org"))

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

;; Gets live preview to work right.
(setq preview-gs-command "/usr/local/bin/gs")

;; Tells emacs where to find LaTeX.
(let ((my-path (expand-file-name "/usr/local/bin:/usr/local/texlive/2023/bin/universal-darwin")))
    (setenv "PATH" (concat my-path ":" (getenv "PATH")))
    (add-to-list 'exec-path my-path))

;; AucTeX
(add-hook 'LaTeX-mode-hook 'visual-line-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)

;; Use Skim as viewer, enable source <-> PDF sync
;; make latexmk available via C-c C-c
;; Note: SyncTeX is setup via ~/.latexmkrc (see below)
(add-hook 'LaTeX-mode-hook (lambda ()
  (push
    '("latexmk" "latexmk -pdf %s" TeX-run-TeX nil t
      :help "Run latexmk on file")
    TeX-command-list)))
(add-hook 'TeX-mode-hook '(lambda () (setq TeX-command-default "latexmk")))

;; use Skim as default pdf viewer
;; Skim's displayline is used for forward search (from .tex to .pdf)
;; option -b highlights the current line; option -g opens Skim in the background
(setq TeX-view-program-selection '((output-pdf "PDF Viewer")))
(setq TeX-view-program-list
      '(("PDF Viewer" "/Applications/Skim.app/Contents/SharedSupport/displayline -b  %n %o %b")))
