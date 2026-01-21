;; -*- no-byte-compile: t; -*-
;;; lang/typst/packages.el

;; https://codeberg.org/meow_king/typst-ts-mode
(package! typst-ts-mode :pin "7c2ef0d5bd2b5a8727fe6d00938c47ba562e0c94")

;; Optional module features.

(when (modulep! +typst-preview)
  (package! typst-preview
    :recipe (:host github :repo "havarddj/typst-preview.el"))
  :pin "c685857f2d61133fc268509b39796b2718728f29")
