(require 'package)

;;MELPAを追加
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))

;; Marmaladeを追加
(add-to-list 'package-archives  '("marmalade" . "http://marmalade-repo.org/packages/"))

;; 初期化
(package-initialize)


;;; キーバインド
(define-key global-map "\C-h" 'delete-backward-char) ; 削除
(define-key global-map "\M-?" 'help-for-help) ; ヘルプ
(define-key global-map "\C-\\" nil) ; \C-\の日本語入力の設定を無効にする

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

;;; 現在の関数名をモードラインに表示
(which-function-mode 1)

;;; タブをスペース4字
(setq-default tab-width 4 indent-tabs-mode nil)

; 極力UTF-8とする
(prefer-coding-system 'utf-8)
(add-to-list 'load-path "~/.emacs.d/elisp/color-theme/")
(require 'color-theme)
(color-theme-initialize)
(color-theme-euphoria) 

;; scala開発環境
(unless (package-installed-p 'scala-mode2)
  (package-refresh-contents) (package-install 'scala-mode2))
(unless (package-installed-p 'ensime)
  (package-refresh-contents) (package-install 'ensime))

(setenv "PATH" (concat "PATH_TO_SBT:" (getenv "PATH")))
(setenv "PATH" (concat "PATH_TO_SCALA:" (getenv "PATH")))

(require 'scala-mode2)
(require 'ensime)
(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)

;;w3m
(add-to-list 'load-path "~/.emacs.d/elisp/w3m/share/emacs/site-lisp/w3m")
;(add-to-list 'Info-additional-directory-list "~/.emacs.d/elisp/w3m/share/info")
(require 'w3m-load)
(put 'upcase-region 'disabled nil)
