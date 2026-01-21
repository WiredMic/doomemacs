;;; lang/typst/config.el -*- lexical-binding: t; -*-
;; https://myriad-dreamin.github.io/tinymist/frontend/emacs.html
;; https://github.com/emacs-lsp/lsp-mode/blob/master/clients/lsp-typst.el


;; TODO formatter

(defgroup doom-typst nil
  "Typst language support for Doom Emacs."
  :group 'languages
  :group 'programming)

(defcustom +typst-lsp-server-path nil
  "Path to binary server file."
  :group 'doom-typst
  :risky t
  :type 'file)

(defun +typst-lsp-config ()
  (when (modulep! +lsp)
    (message "Running LSP config")
    (if (modulep! :tools lsp -eglot)

        (progn
          (after! lsp-mode
            (require 'lsp-typst)
            (when +typst-lsp-server-path
              (setq lsp-typst-server-command (list +typst-lsp-server-path)))
            (set-lsp-priority! 'tinymist 0)))

      (after! eglot
        (set-eglot-client! 'typst-ts-mode
                           (lambda (&rest _)
                             (let  ((server-path (or +typst-lsp-server-path "tinymist")))
                               (list server-path))))))))


(use-package! typst-ts-mode
  :when (modulep! +tree-sitter)
  :mode "\\.typ\\'"
  :init
  (set-tree-sitter! nil 'typst-ts-mode
    '((typst :url "https://github.com/uben0/tree-sitter-typst"
       :commit "13863ddcbaa7b68ee6221cea2e3143415e64aea4")))
  :hook (typst-ts-mode . (lambda () (when (modulep! +lsp) (lsp!))))
  :config
  (+typst-lsp-config))

(use-package websocket
  :when (modulep! +typst-preview))

(use-package typst-preview
  :when (modulep! +typst-preview)
  :init
  (setq typst-preview-autostart t) ; start preview automatically when typst-preview-mode is activated
  (setq typst-preview-open-browser-automatically t) ; open browser automatically when typst-preview-start is run

  :custom
  (typst-preview-browser "default") 	; this is the default option; other options are `eaf-browser' or `xwidget'.
  (typst-preview-invert-colors "auto")	; invert colors depending on system theme
  (typst-preview-executable "tinymist") ; path to tinymist binary (relative or absolute)
  (typst-preview-partial-rendering t)   ; enable partial rendering 
  
  :config
  (define-key typst-preview-mode-map (kbd "C-c C-j") 'typst-preview-send-position))
