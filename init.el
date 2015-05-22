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

;;~/.emacs.d/elispへロードパスを通す 
(add-to-list 'load-path "~/.emacs.d/elisp/")

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
; '(cursor
;    ((((class color)
;      (background dark))
;      (:background "#00AA00"))
;    (((class color)
;      (background light))
;      (:background "#999999"))
;      (t ())
;)))

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
;(add-to-list 'load-path (concat user-emacs-directory "~/.emacs.d/elisp/scala-mode2"))
;(require 'scala-mode2)
;(add-to-list 'load-path (concat user-emacs-directory "~/.emacs.d/s.el/s.el"))
;(require 's)


;(setenv "PATH" (concat "PATH_TO_SBT:" (getenv "PATH")))
;(setenv "PATH" (concat "PATH_TO_SCALA:" (getenv "PATH")))

(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)
;(setq ensime-ac-override-settings nil)
;ensime内部のauto-complete用の設定
;(defun my-ac-scala-mode ()
;  (add-to-list 'ac-sources 'ac-source-dictionary)
;  (add-to-list 'ac-sources 'ac-source-yasnippet)
;  (add-to-list 'ac-sources 'ac-source-words-in-buffer)
;  (add-to-list 'ac-sources 'ac-source-words-in-same-mode-buffers)
;  (setq ac-sources (reverse ac-sources)) ;;;追記2
;  )

(add-hook 'ensime-mode-hook 'my-ac-scala-mode)

;;
;; Auto Complete
;;
;;ロードパス
;(add-to-list 'load-path "~/.emacs.d/elisp/auto-complete")
;(require 'auto-complete)
;(require 'auto-complete-config)
;(add-to-list 'ac-dictionary-directories "~/.emacs.d/elisp/auto-complete/dict")
;(ac-config-default)
;(setq ac-use-menu-map t)       ;; 補完メニュー表示時にC-n/C-pで補完候補選択
;(setq ac-use-fuzzy t)          ;; 曖昧マッチ
;(ac-set-trigger-key "TAB")


;;w3m
(add-to-list 'load-path "~/.emacs.d/elisp/w3m/share/emacs/site-lisp/w3m")
;(add-to-list 'Info-additional-directory-list "~/.emacs.d/elisp/w3m/share/info")
(require 'w3m-load)
(put 'upcase-region 'disabled nil)

;; ensime設定
;; syntax

(setq ensime-sem-high-faces
  '(
   (var . (:foreground "#ff2222"))
   (val . (:foreground "#dddddd"))
   (varField . (:foreground "#ff3333"))
   (valField . (:foreground "#dddddd"))
   (functionCall . (:foreground "#84BEE3"))
   (param . (:foreground "#ffffff"))
   (class . font-lock-type-face)
   (trait . (:foreground "#084EA8"))
   (object . (:foreground "#026DF7"))
   (package . font-lock-preprocessor-face)
   ))
