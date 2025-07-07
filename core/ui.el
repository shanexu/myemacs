;; -*- lexical-binding: t; -*-
(tool-bar-mode -1)
(menu-bar-mode -1)
(when (and (eq system-type 'darwin) (display-graphic-p))
  (menu-bar-mode 1))
(scroll-bar-mode -1)
(blink-cursor-mode 0)
(setq ring-bell-function 'ignore)

(when (display-graphic-p)
  (set-face-attribute 'default nil
                      :family "JetBrains Maple Mono"
                      :height 170)
  (set-face-attribute 'fixed-pitch nil
                      :family "JetBrains Maple Mono"
                      :height 170)
  (set-face-attribute 'variable-pitch nil
                      :family "HarmonyOS Sans SC"
                      :height 170)
  (set-fontset-font t 'symbol "Symbols Nerd Font Mono" nil 'prepend))

;; TODO modeline

;; ==================== 正确的行号配置 ====================
(use-package display-line-numbers
  :ensure nil ; 内置包无需安装
  :custom
  (display-line-numbers-type 'relative) ; 相对行号模式
  (display-line-numbers-grow-only t)    ; 仅增加宽度避免跳动

  ;; 1. 使用hook控制行号显示
  :hook
  ((prog-mode text-mode conf-mode) . display-line-numbers-mode)

  :config
  ;; 2. 定义排除特定模式的函数
  (defun my/disable-line-numbers ()
    "在特定模式中禁用行号"
    (display-line-numbers-mode -1))

  ;; 3. 为特定模式添加hook
  (dolist (mode '(org-mode
                  pdf-view-mode
                  vterm-mode
                  treemacs-mode
                  dashboard-mode
                  eshell-mode
                  dired-mode
                  image-mode
                  term-mode))
    (add-hook (intern (concat (symbol-name mode) "-hook"))
              'my/disable-line-numbers))

  ;; 4. 可选：在特定缓冲区禁用行号
  (add-hook 'minibuffer-setup-hook
            (lambda () (display-line-numbers-mode -1))))

;; 6. 当前行高亮增强
(use-package hl-line
  :ensure nil
  :hook (display-line-numbers-mode . hl-line-mode)
  :custom
  (hl-line-sticky-flag nil) ; 仅在激活窗口高亮
  (global-hl-line-sticky-flag nil)
  :config
  (set-face-attribute 'hl-line nil
                      ;; :background "#2a2a2a" ; 暗色主题
                      :extend t)) ; 整行高亮

;; ==================== 性能优化 ====================
;; 7. 大文件处理优化
(setq display-line-numbers-widen t) ; 自动放宽宽度限制
(setq large-file-warning-threshold 100000000) ; 100MB

;; 8. 大文件检测函数
(defun my/disable-line-numbers-for-large-files ()
  "在大文件中禁用行号以提高性能"
  (when (> (buffer-size) (* 1024 1024 5)) ; 5MB以上文件
    (display-line-numbers-mode -1)))

(add-hook 'find-file-hook 'my/disable-line-numbers-for-large-files)

;; Show scroll bar when using the mouse wheel
(defun my/scroll-bar-hide ()
  "Hide the scroll bar."
  (scroll-bar-mode -1))

(defun my/scroll-bar-show-delayed-hide (&rest _ignore)
  "Show the scroll bar for a couple of seconds, before hiding it.

This can be used to temporarily show the scroll bar when mouse wheel scrolling.
\(advice-add 'mwheel-scroll :after #'my/scroll-bar-show-delayed-hide)

The advice can be removed with:
\(advice-remove 'mwheel-scroll #'my/scroll-bar-show-delayed-hide)"
  (scroll-bar-mode 1)
  (run-with-idle-timer
   3
   nil
   #'my/scroll-bar-hide))
(when (fboundp 'scroll-bar-mode)
  (advice-add 'mwheel-scroll :after #'my/scroll-bar-show-delayed-hide))

;; color-theme
(use-package color-theme-sanityinc-tomorrow
  :config
  (load-theme 'sanityinc-tomorrow-night t))

;; macos
(defun toggle-ns-appearance (&optional mode)
  "Toggle between light and dark appearance on macOS.
If MODE is provided and is either 'light or 'dark, set the appearance to MODE.
Otherwise, toggle between light and dark."
  (interactive)
  (let ((ns-appearance-mode (cond
                             ((eq mode 'light) 'light)
                             ((eq mode 'dark) 'dark)
                             (t (if (eq (frame-parameter nil 'ns-appearance) 'dark)
                                    'light
                                  'dark)))))
    (set-frame-parameter nil 'ns-appearance ns-appearance-mode)))
(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(toggle-ns-appearance 'dark)

(setq scroll-conservatively 101)

(provide 'ui)
