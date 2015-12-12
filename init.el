(setq debug-on-error t)

(require 'package)
;;MELPAを追加
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
;;MELPA Stableを追加
(add-to-list 'package-archives '("melpa-stable" . "http://melpa-stable.milkbox.net/packages/") t)
;; Marmaladeを追加
(add-to-list 'package-archives  '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

;;;package-installの自動化
;;;インストールされていないものがインストールされる
(require 'cl)

(defvar installing-package-list
  '(
    ;;使用するパッケージ
    scala-mode2
    ensime
    auto-complete
    emms
    ))

(let ((not-installed (loop for x in installing-package-list
			   when (not (package-installed-p x))
			   collect x)))
  (when not-installed
    (package-refresh-contents)
    (dolist (pkg not-installed)
      (package-install pkg))))

;;; 現在の関数名をモードラインに表示
(which-function-mode 1)

(global-set-key (kbd "C-c <left>")  'windmove-left)
(global-set-key (kbd "C-c <down>")  'windmove-down)
(global-set-key (kbd "C-c <up>")    'windmove-up)
(global-set-key (kbd "C-c <right>") 'windmove-right)

;; load environment value
;; eshellとbashで$PATHを共有
(load-file (expand-file-name "~/.emacs.d/shellenv.el"))
(dolist (path (reverse (split-string (getenv "PATH") ":")))
  (add-to-list 'exec-path path))

;; スクリーンの最大化
;;(set-frame-parameter nil 'fullscreen 'maximized)
;; フルスクリーン
(set-frame-parameter nil 'fullscreen 'fullboth)

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
(require 'ensime)
(require 'scala-mode2)
(require 'auto-complete)
;;;(define-key scala-mode-map (kbd ".") 'scala/completing-dot)
(setenv "PATH" (concat "PATH_TO_SBT:" (getenv "PATH")))
(setenv "PATH" (concat "PATH_TO_SCALA:" (getenv "PATH")))

;;http://blog.shibayu36.org/entry/2015/07/07/103000
(setq ensime-completion-style 'auto-complete)
(defun scala/enable-eldoc ()
  "Show error message or type name at point by Eldoc."
  (setq-local eldoc-documentation-function
              #'(lambda ()
                  (when (ensime-connected-p)
                    (let ((err (ensime-print-errors-at-point)))
                      (or (and err (not (string= err "")) err)
                          (ensime-print-type-at-point))))))
  (eldoc-mode +1))

(defun scala/completing-dot-company ()
  (cond (company-backend
         (company-complete-selection)
         (scala/completing-dot))
        (t
         (insert ".")
         (company-complete))))

(defun scala/completing-dot-ac ()
  (insert ".")
  (ac-trigger-key-command t))

;; Interactive commands

(defun scala/completing-dot ()
  "Insert a period and show company completions."
  (interactive "*")
  (eval-and-compile (require 'ensime))
  (eval-and-compile (require 's))
  (when (s-matches? (rx (+ (not space)))
                    (buffer-substring (line-beginning-position) (point)))
    (delete-horizontal-space t))
  (cond ((not (and (ensime-connected-p) ensime-completion-style))
         (insert "."))
        ((eq ensime-completion-style 'company)
         (scala/completing-dot-company))
        ((eq ensime-completion-style 'auto-complete)
         (scala/completing-dot-ac))))

;; Initialization
(add-hook 'ensime-mode-hook #'scala/enable-eldoc)
(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)
(add-hook 'scala-mode-hook 'flycheck-mode)
(add-hook 'scala-mode-hook
          '(lambda ()
             (progn
               (local-set-key (kbd "C-x C-j") 'open-by-intellij))))

(define-key scala-mode-map (kbd ".") 'scala/completing-dot)
;;/scala設定================================================================


;;(defun scala/enable-eldoc ()
;;  "Show error message or type name at point by Eldoc."
;;  (setq-local eldoc-documentation-function
;;              #'(lambda ()
;;                  (when (ensime-connected-p)
;;                    (let ((err (ensime-print-errors-at-point)))
;;                      (or (and err (not (string= err "")) err)
;;                          (ensime-print-type-at-point))))))
;;  (eldoc-mode +1))

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


;;;
;;;eww設定
;;;
"デフォルトをgoogleへ"
(setq eww-search-prefix "http://www.google.co.jp/search?q=")

(defvar eww-disable-colorize t)
(defun shr-colorize-region–disable (orig start end fg &optional bg &rest _)
(unless eww-disable-colorize
(funcall orig start end fg)))
(advice-add 'shr-colorize-region :around 'shr-colorize-region–disable)
(advice-add 'eww-colorize-region :around 'shr-colorize-region–disable)
(defun eww-disable-color ()
"eww で文字色を反映させない"
(interactive)
(setq-local eww-disable-colorize t)
(eww-reload))
(defun eww-enable-color ()
"eww で文字色を反映させる"
(interactive)
(setq-local eww-disable-colorize nil)
(eww-reload))

;;;
;;;emms
;;;
(require 'emms-setup)
(require 'emms-i18n)
(emms-standard)
(emms-default-players)
(setq emms-player-list '(emms-player-mplayer))
(setq emms-source-file-default-directory "~/music/")
