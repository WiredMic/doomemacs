;;; lang/vhdl/config.el -*- lexical-binding: t; -*-

;; treesitter
;; formatter
;; lsp-mode and eglot
;;      language servers: TODO VHDL-tool, TODO HDL Checker, VHDL LS, and TODO GHDL LS
;; TODO ligatures: Differentiate between <= (logic) and <= (signal_assignment)


(defgroup doom-vhdl nil
  "VHDL language support for Doom Emacs."
  :group 'languages
  :group 'programming)

(defcustom +vhdl-lsp-server 'vhdl-tool
  "Which LSP server to use for VHDL."
  :group 'doom-vhdl
  :type '(choice (const :tag "VHDL Tool (default)" vhdl-tool)
          (const :tag "HDL Checker" hdl-checker)
          (const :tag "VHDL LS" vhdl-ls)
          (const :tag "GHDL LS" ghdl-ls)))

(defcustom +vhdl-lsp-server-path nil
  "Path to binary server file."
  :group 'doom-vhdl
  :risky t
  :type 'file)


(defun +vhdl-common-config (mode)
  (when (modulep! +lsp)
    (message "Running LSP config")
    (if (modulep! :tools lsp -eglot)

        (with-eval-after-load 'lsp-vhdl
          (setq lsp-vhdl-server      +vhdl-lsp-server
                lsp-vhdl-server-path +vhdl-lsp-server-path)
          (set-lsp-priority! 'lsp-vhdl 0))

      (after! eglot
        (set-eglot-client! mode
                           (lambda (&rest _)
                             (let  ((server-path (or +vhdl-lsp-server-path
                                                     (pcase +vhdl-lsp-server
                                                       ('vhdl-tool "vhdl-tool")
                                                       ('hdl-checker "hdl_checker")
                                                       ('vhdl-ls "vhdl_ls")
                                                       ('ghdl-ls "ghdl-ls")
                                                       (_ "vhdl-tool")))))
                               (list server-path)))))))

  (add-hook (intern (format "%s-local-vars-hook" mode)) #'lsp! 'append))


(use-package! vhdl-mode
  :when (modulep! -tree-sitter)
  :mode ("\\.vhd\\'" "\\.vhdl\\'")
  :init
  :config
  (set-formatter! 'vhdl-beautify
    (lambda (&rest args)
      (let ((scratch (plist-get args :scratch))
            (callback (plist-get args :callback))
            (original-buffer (plist-get args :buffer)))
        (with-current-buffer scratch
          (vhdl-mode)

          (setq-local vhdl-basic-offset 
                      (buffer-local-value 'vhdl-basic-offset original-buffer))
          (setq-local tab-width 
                      (buffer-local-value 'tab-width original-buffer))
          (setq-local indent-tabs-mode 
                      (buffer-local-value 'indent-tabs-mode original-buffer))
          (setq-local vhdl-indent-tabs-mode 
                      (buffer-local-value 'vhdl-indent-tabs-mode original-buffer))
          
          (vhdl-beautify-buffer))
        (funcall callback nil)))
    :modes '(vhdl-mode))
  (+vhdl-common-config 'vhdl-mode))

(use-package! vhdl-ts-mode
  :when (modulep! +tree-sitter)
  :defer t
  :mode ("\\.vhd\\'" "\\.vhdl\\'")
  :init
  (set-tree-sitter! 'vhdl-mode 'vhdl-ts-mode 'vhdl)
  :config
  (set-formatter! 'vhdl-ts-beautify
    (lambda (&rest args)
      (let ((scratch (plist-get args :scratch))
            (callback (plist-get args :callback))
            (original-buffer (plist-get args :buffer)))
        (with-current-buffer scratch
          (vhdl-ts-mode)

          (setq-local vhdl-ts-indent-level 
                      (buffer-local-value 'vhdl-ts-indent-level original-buffer))
          (setq-local tab-width 
                      (buffer-local-value 'tab-width original-buffer))
          (setq-local indent-tabs-mode 
                      (buffer-local-value 'indent-tabs-mode original-buffer))

          (vhdl-ts-beautify-buffer))
        (funcall callback nil)))
    :modes '(vhdl-ts-mode))
  
  ;; install tree-sitter grammar unless avaliable
  (unless (treesit-language-available-p 'vhdl)
    (vhdl-ts-install-grammar))

  (+vhdl-common-config 'vhdl-ts-mode))


;; ((_
;;   target: (_)
;;   "<=" @assignment)
;;  (relation
;;   (_)
;;   operator: "<=" @greater_or_eq))


;; =>
;; ⇐=
;; <==
