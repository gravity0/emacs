; 極力UTF-8とする
(prefer-coding-system 'utf-8)
(add-to-list 'load-path "~/.emacs.d/elisp/color-theme/")
(require 'color-theme)
(color-theme-initialize)
(color-theme-euphoria) 

(package-initialize)
(unless (package-installed-p 'scala-mode2)
  (package-refresh-contents) (package-install 'scala-mode2))
(when (not package-archive-contents)
  (package-refresh-contents))

;;w3m
(add-to-list 'load-path "~/.emacs.d/elisp/w3m/share/emacs/site-lisp/w3m")
;(add-to-list 'Info-additional-directory-list "~/.emacs.d/elisp/w3m/share/info")
(require 'w3m-load)
