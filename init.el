;; Require ESS to allow evaluation of R code blocks
(let ((ess-path "~/.emacs.d/src/ess-5.6/lisp/")) ;; <- adjust for your system
  (add-to-list 'load-path ess-path)
  (require 'ess-site)
  (setq ess-ask-for-ess-directory nil))

(add-to-list 'load-path "~/.emacs.d/src/org/lisp") ;; <- adjust
(add-to-list 'load-path "~/.emacs.d/src/org") ;; <- adjust

(require 'org-install)

;; this line only required until the upcomming Org-mode/Emacs24 sync
(load "~/.emacs.d/src/org/lisp/org-exp-blocks.el")


;; Configure Babel to support all languages included in the manuscript
(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (dot        . t)
   (sh         . t)
   (org        . t)
   (python     . t)
   (R          . t)))
(setq org-confirm-babel-evaluate nil)

;; Configure Org-mode
  (setq org-export-latex-hyperref-format "\\ref{%s}")
  (setq org-entities-user '(("space" "\\ " nil " " " " " " " ")))
  (setq org-latex-to-pdf-process '("texi2dvi --pdf --clean --verbose --batch %f"))
  (require 'org-special-blocks)
  (defun org-export-latex-no-toc (depth)  
    (when depth
      (format "%% Org-mode is exporting headings to %s levels.\n"
              depth)))
  (setq org-export-latex-format-toc-function 'org-export-latex-no-toc)
  (setq org-export-pdf-remove-logfiles nil)

;; Add link types
(require 'org-latex)
  (org-add-link-type 
   "parencite" 'ebib
   (lambda (path desc format)
     (cond
      ((eq format 'html)
       (format "(<cite>%s</cite>)" path))
      ((eq format 'latex)
       (if (or (not desc) (equal 0 (search "parencite:" desc)))
           (format "\\parencite{%s}" path)
         (format "\\parencite[%s][%s]{%s}"
                 (cadr (split-string desc ";"))
                 (car (split-string desc ";"))  path))))))

  (org-add-link-type 
   "multicite" 'ebib
   (lambda (path desc format)
     (cond
      ((eq format 'html)
       (format "(<cite>%s</cite>)" path))
      ((eq format 'latex)
       (if (or (not desc) (equal 0 (search "multicite:" desc)))
           (format "{%s}" path)
         (format "[%s][%s]{%s}"
                 (cadr (split-string desc ";"))
                 (car (split-string desc ";"))  path))))))

  (org-add-link-type 
   "textcite" 'ebib
   (lambda (path desc format)
     (cond
      ((eq format 'html)
       (format "(<cite>%s</cite>)" path))
      ((eq format 'latex)
       (if (or (not desc) (equal 0 (search "textcite:" desc)))
           (format "\\textcite{%s}" path)
         (format "\\textcite[%s][%s]{%s}"
                 (cadr (split-string desc ";"))
                 (car (split-string desc ";"))  path))))))

;; Add a new export class to use KOMA script
(add-to-list 'org-export-latex-classes
             '("koma-article"
               "\\documentclass{scrartcl}
             [NO-DEFAULT-PACKAGES]
             [EXTRA]"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

