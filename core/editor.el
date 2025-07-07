;; -*- lexical-binding: t; -*-

(use-package better-defaults
  :ensure nil)

(use-package mwim
  :defer t
  :init
  (global-set-key (kbd "C-a") 'mwim-beginning-of-code-or-line)
  (global-set-key (kbd "C-e") 'mwim-end-of-code-or-line))

(use-package unfill
  :defer t
  :commands (unfill-region unfill-paragraph unfill-toggle)
  :init
  (global-set-key [remap fill-paragraph] #'unfill-toggle))

(provide 'editor)
