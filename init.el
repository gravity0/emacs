(setq debug-on-error t)

(require 'package)
;;MELPAを追加
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
;;MELPA Stableを追加
(add-to-list 'package-archives '("melpa-stable" . "http://melpa-stable.milkbox.net/packages/") t)
;; Marmaladeを追加
(add-to-list 'package-archives  '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

;;;
;;;バッファ移動
;;;Shift + ↓ or → or ← or ↑
;;;
(setq windmove-wrap-around t)
(windmove-default-keybindings)

;;;
;;;現在開いているバッファをクリアする
;;;
(defun clear-buffer ()
  "clear current buffer"
  (interactive)
  (let ((start (point-min))
	(end (point-max)))
    (delete-region start end))

;;~/.emacs.d/elispへロードパスを通す 
(add-to-list 'load-path "~/.emacs.d/elisp/")

(require 'exec-path-from-shell)
(when (memq window-system '(mac ns))
    (exec-path-from-shell-initialize))

;;fnキー
(setq ns-function-modifier 'hyper)

;;コマンドキーをmeta keyとして使用:
(when (eq system-type 'darwin)
    (setq ns-command-modifier (quote meta)))

;;init.elを再読み込み
(global-set-key [f12] 'eval-buffer)

;;モードを表示
(message "%s" major-mode)

;;;
;;;背景色
;;;
(custom-set-faces
  '(default ((t (:background "#2d3436" :foreground "#55FF55")
))))

;;; キーバインド
(define-key global-map "\C-h" 'delete-backward-char) ; 削除
(define-key global-map "\M-?" 'help-for-help) ; ヘルプ
(define-key global-map "\C-\\" nil) ; \C-\の日本語入力の設定を無効にする
(local-set-key (kbd "TAB") 'tab-to-tab-stop) ;TABキー設定


;;; 色を付ける
(global-font-lock-mode t)

;;; バックアップファイルを作らない
(setq backup-inhibited t)

;;; スクロールを一行ずつにする
(setq scroll-step 1)

;;; スクロールバーを右側に表示する
(set-scroll-bar-mode 'right)

;;; 画面右端で折り返さない
(setq-default truncate-lines t)
(setq truncate-partial-width-windows t)

;;; バッファの最後でnewlineで新規行を追加するのを禁止する
(setq next-line-add-newlines nil)

;;; モードラインに情報を表示
(display-time)
(line-number-mode 1)
(column-number-mode 1)

;;ウィンドウ移動
(global-set-key (kbd "C-c <left>")  'windmove-left)
(global-set-key (kbd "C-c <down>")  'windmove-down)
(global-set-key (kbd "C-c <up>")    'windmove-up)
(global-set-key (kbd "C-c <right>") 'windmove-right)

;;; 現在の関数名をモードラインに表示
(which-function-mode 1)

;;; タブをスペース4字
;(setq-default tab-width 4 indent-tabs-mode nil)

; 極力UTF-8とする
(prefer-coding-system 'utf-8)
;(add-to-list 'load-path "~/.emacs.d/elisp/color-theme/")
;(require 'color-theme)
;(color-theme-initialize)
;(color-theme-euphoria) 

;;
;; ensime:scala開発環境
;;
(add-to-list 'load-path (concat user-emacs-directory "~/.emacs.d/elisp/ensime"))
(require 'ensime)
(require 'scala-mode2)

(setenv "PATH" (concat "PATH_TO_SBT:" (getenv "PATH")))
(setenv "PATH" (concat "PATH_TO_SCALA:" (getenv "PATH")))

(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)
;;http://blog.shibayu36.org/entry/2015/07/07/103000
(setq ensime-completion-style 'auto-complete)
(define-key scala-mode-map (kbd ".") 'scala/completing-dot)

;;(defun scala/enable-eldoc ()
;;  "Show error message or type name at point by Eldoc."
;;  (setq-local eldoc-documentation-function
;;              #'(lambda ()
;;                  (when (ensime-connected-p)
;;                    (let ((err (ensime-print-errors-at-point)))
;;                      (or (and err (not (string= err "")) err)
;;                          (ensime-print-type-at-point))))))
;;  (eldoc-mode +1))

;;w3m
(add-to-list 'load-path "~/.emacs.d/elisp/w3m/share/emacs/site-lisp/w3m")
;(add-to-list 'Info-additional-directory-list "~/.emacs.d/elisp/w3m/share/info")
(require 'w3m-load)
(put 'upcase-region 'disabled nil)

;;;ruby用elisp読み込み
(add-to-list 'load-path "~/.emacs.d/elisp/ruby")
;;;
;;;ruby-block
;;;
(require 'ruby-block)
(ruby-block-mode t)
(setq ruby-block-highlight-toggle t)

;;; smart-compile
(require 'smart-compile)
(global-set-key (kbd "C-x c") 'smart-compile)
(global-set-key (kbd "C-x C-x") (kbd "C-x c C-m"))


;;ruby-mode
(autoload 'ruby-mode "ruby-mode" "Mode for editing ruby source files" t)
(setq auto-mode-alist  (append '(("\\.rb$" . ruby-mode)) auto-mode-alist))
(setq interpreter-mode-alist (append '(("ruby" . ruby-mode)) interpreter-mode-alist))
(autoload 'run-ruby "inf-ruby" "Run an inferior Ruby process")
(autoload 'inf-ruby-keys "inf-ruby" "Set local key defs for inf-ruby in ruby-mode")
(add-hook 'ruby-mode-hook
  '(lambda ()
    (turn-on-font-lock)
    (set-face-foreground font-lock-comment-face "pink")
    (set-face-foreground font-lock-string-face "yellow")
    (set-face-foreground font-lock-function-name-face "grey")
    (set-face-foreground font-lock-variable-name-face "orange")
    (set-face-foreground font-lock-keyword-face "LightSeaGreen")
    (set-face-foreground font-lock-type-face "LightSeaGreen"))
)

(global-font-lock-mode 1)
(setq default-frame-alist (append '(
  (foreground-color . "gray")  ;
  (background-color . "black") ;
  (cursor-color     . "blue")  ;
) default-frame-alist))
;; ruby-mode indent
(setq ruby-deep-indent-paren-style nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;C 言語・ C++ のための設定.
;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-to-list 'load-path "~/.emacs.d/elisp/cc-mode/")
(require 'cc-mode)
 
;; c-mode-common-hook は C/C++ の設定
(add-hook 'c-mode-common-hook
          (lambda ()
            (setq c-default-style "k&r") ;; カーニハン・リッチースタイル
            (setq indent-tabs-mode nil)  ;; タブは利用しない
            (setq c-basic-offset 2)      ;; indent は 2 スペース
            ))
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(put 'downcase-region 'disabled nil)
