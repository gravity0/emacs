

(setq debug-on-error t)
;;画面から溢れたら、開業する(t)設定。開業しない場合は（nil）
(setq truncate-lines t)
(require 'package)
;;MELPAを追加
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
;;MELPA Stableを追加
(add-to-list 'package-archives '("melpa-stable" . "http://melpa-stable.milkbox.net/packages/") t)
;; Marmaladeを追加
(add-to-list 'package-archives  '("marmalade" . "http://marmalade-repo.org/packages/"))
;; Orgを追加
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)

(package-initialize)

;;; ディレクトリツリー M-x dirtree
(require 'dirtree)
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
    sql
    sql-indent
    vline
    column-marker
    col-highlight
    crosshairs
    hl-line+
    dirtree
    ac-python
    jedi
    ctags
    robe
    inf-ruby
    ))

;;; M-x eval-bufferをf12へ割当
(global-set-key [f12] 'eval-buffer)

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

(define-key global-map [?¥] [?\\])  ;; ¥の代わりにバックスラッシュを入力する

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


(require 'col-highlight)
;; 常にハイライト
;; (column-highlight-mode 1)
;; 動作のないときにハイライト(秒数を指定)
(toggle-highlight-column-when-idle 1)
(col-highlight-set-interval 3)
;; col-highlightの色を変える
(custom-set-faces
 '(col-highlight((t (:background "#505050")))))
(column-highlight-mode 1)
;;現在行と行をハイライトする
(require 'crosshairs)
(setq my-highlight-color "#500050")
(set-face-background 'hl-line my-highlight-color)
(crosshairs-mode 1)











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
(add-hook 'ruby-mode-hook
  '(lambda ()
    (turn-on-font-lock)
    (robe-mode)
    (robe-ac-setup)
    (set-face-foreground font-lock-comment-face "pink")
    (set-face-foreground font-lock-string-face "yellow")
    (set-face-foreground font-lock-function-name-face "grey")
    (set-face-foreground font-lock-variable-name-face "orange")
    (set-face-foreground font-lock-keyword-face "LightSeaGreen")
    (set-face-foreground font-lock-type-face "LightSeaGreen"))
  )

; robe
(autoload 'robe-mode "robe" "Code navigation, documentation lookup and completion for Ruby" t nil)
(autoload 'ac-robe-setup "ac-robe" "auto-complete robe" nil nil)
(add-hook 'robe-mode-hook 'ac-robe-setup)

(global-font-lock-mode 1)
(setq default-frame-alist (append '(
  (foreground-color . "gray")  ;
  (background-color . "black") ;
  (cursor-color     . "blue")  ;
) default-frame-alist))
;; ruby-mode indent
(setq ruby-deep-indent-paren-style nil)


;;;; for ctags.el
(require 'ctags nil t)
(setq tags-revert-without-query t)
(setq ctags-command "ctags -R --fields=\"+afikKlmnsSzt\" ")
(global-set-key (kbd "<f5>") 'ctags-create-or-update-tags-table)
(global-set-key (kbd "M-.") 'ctags-search)

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


;;=======================================================
;;SQL
;;======================================================
;; C-c C-c : 'sql-send-paragraph
;; C-c C-r : 'sql-send-region
;; C-c C-s : 'sql-send-string
;; C-c C-b : 'sql-send-buffer
(require 'sql)

;; starting SQL mode loading sql-indent / sql-complete
(eval-after-load "sql"
  '(progn
     (load-library "sql-indent")))

(setq auto-mode-alist
      (cons '("\\.sql$" . sql-mode) auto-mode-alist))

(defun sql-mode-hooks()
  (setq sql-indent-offset 2)
  (setq indent-tabs-mode nil)
  (sql-set-product "postgres"))

(add-hook 'sql-mode-hook 'sql-mode-hooks)

;;=======================================================
;;Python
;;======================================================

(add-hook 'python-mode-hook
	  '(lambda ()
	     (setq indent-tabs-mode nil)
	     (setq indent-level 4)
	     (setq python-indent 
		   (setq tab-width 4)))
)	  
(require 'auto-complete-config)
(require 'python)
(require 'jedi)
(add-hook 'python-mode-hook 'jedi:setup)
(define-key python-mode-map (kbd "<C-tab>") 'jedi:complete)
(setq jedi:complete-on-dot t)

(require 'ac-python)
(add-to-list 'ac-modes 'python-3-mode)


(when (load "flymake" t)
  (defun flymake-pyflakes-init ()
     ; Make sure it's not a remote buffer or flymake would not work
     (when (not (subsetp (list (current-buffer)) (tramp-list-remote-buffers)))
      (let* ((temp-file (flymake-init-create-temp-buffer-copy
                         'flymake-create-temp-inplace))
             (local-file (file-relative-name
                          temp-file
                          (file-name-directory buffer-file-name))))
        (list "pyflakes" (list local-file)))))
  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.py\\'" flymake-pyflakes-init)))

