;; -*- lexical-binding: t; no-byte-compile: t; -*-
;;; lang/typst/doctor.el


(assert! (modulep! +tree-sitter)
         "This module requires +tree-sitter")

(assert! (or (not (modulep! +tree-sitter))
             (modulep! :tools tree-sitter))
         "This module requires (:tools tree-sitter)")

(assert! (or (not (modulep! +lsp))
             (modulep! :tools lsp))
         "This module requires (:tools lsp)")

