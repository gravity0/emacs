

(setq debug-on-error t)
;;画面から溢れたら、開業する(t)設定。開業しない場合は（nil）
(setq truncate-lines t)
(require 'package)
;;MELPAを追加
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
;;MELPA Stableを追加
(add-to-list 'package-archives '("melpa-stable" . "http://melpa-stable.milkbox.net/packages/") t)
;; Marmaladeを追加
(add-to-list 'package-archives  '("marmalade" . "http://marmalade-repo.org/packages/") t)
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
    web-mode
    ))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; オートコンプリート
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'auto-complete)
    (require 'auto-complete-config)
    ;; グローバルでauto-completeを利用
    (global-auto-complete-mode t)
    (define-key ac-completing-map (kbd "M-n") 'ac-next)      ; M-nで次候補選択
    (define-key ac-completing-map (kbd "M-p") 'ac-previous)  ; M-pで前候補選択
    (setq ac-dwim t)  ; 空気読んでほしい
    ;; 情報源として
    ;; * ac-source-filename
    ;; * ac-source-words-in-same-mode-buffers
    ;; を利用
    (setq-default ac-sources '(ac-source-filename ac-source-words-in-same-mode-buffers))
    ;; また、Emacs Lispモードではac-source-symbolsを追加で利用
    (add-hook 'emacs-lisp-mode-hook (lambda () (add-to-list 'ac-sources 'ac-source-symbols t)))
    ;; 以下、自動で補完する人用
    (setq ac-auto-start 1)
    ;; 以下、手動で補完する人用
    (setq ac-auto-start nil)
    (ac-set-trigger-key "TAB")  ; TABで補完開始(トリガーキー)
    ;; or
    (define-key ac-mode-map (kbd "M-TAB") 'auto-complete)  ; M-TABで補完開始

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

;;背景黒、フォント青
(global-font-lock-mode 1)
(setq default-frame-alist (append '(
  (foreground-color . "gray")  ;
  (background-color . "black") ;
  (cursor-color     . "blue")  ;
) default-frame-alist))




;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;HTMLのための設定.
;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(setq web-mode-engines-alist
      '(("template-toolkit" . "\\.html?\\'" )))




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

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;Rubyのxのための設定.
;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;ruby-mode
(autoload 'ruby-mode "ruby-mode" "Mode for editing ruby source files" t)
(setq auto-mode-alist  (append '(("\\.rb$" . ruby-mode)) auto-mode-alist))
(setq interpreter-mode-alist (append '(("ruby" . ruby-mode)) interpreter-mode-alist))
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

;; Ruby mode configurations
(add-to-list 'auto-mode-alist '("\\.rake$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Rakefile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("gemspec$" . ruby-mode))
(add-to-list 'auto-mode-alist '("config.ru$" . ruby-mode))


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

