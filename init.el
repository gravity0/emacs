;言語を日本語にする
(set-language-environment 'Japanese)
; 極力UTF-8とする
(prefer-coding-system 'utf-8)
;emacs-w3mへのパスを通す
;(require 'w3m-load)
(add-to-list 'load-path "~/.emacs.d/elisp/color-theme/")
(require 'color-theme)
(color-theme-initialize)
(color-theme-euphoria) 


(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)
(unless (package-installed-p 'scala-mode2)
  (package-refresh-contents) (package-install 'scala-mode2))



(require 'package)
(add-to-list 'package-archives
         '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

(require 'ensime)
(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)
(put 'upcase-region 'disabled nil)

;;w3m
(add-to-list 'load-path
           "~/.emacs.d/elisp/w3m/share/emacs/site-lisp/w3m")
     (add-to-list 'Info-additional-directory-list
           "~/.emacs.d/elisp/w3m/share/info")
     (require 'w3m-load)
     (setq w3m-use-cookies t) 		 ;ログイン可能にする
     (setq w3m-favicon-cache-expire-wait nil) ;favicon のキャッシュを消さない
