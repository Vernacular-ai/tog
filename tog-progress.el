;;; tog-progress.el --- Progress bar component for tog -*- lexical-binding: t; -*-

;; Copyright (c) 2019 Abhinav Tushar

;; Author: Abhinav Tushar <lepisma@fastmail.com>

;;; Commentary:

;; Progress bar component for tog
;; This file is not a part of GNU Emacs.

;;; License:

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program. If not, see <http://www.gnu.org/licenses/>.

;;; Code:

(require 'dash)
(require 's)

(defun tog-progress-done ()
  "Return count of done items. This works over all the items and
not only for the current session."
  (-reduce-from (lambda (acc it) (if (oref it :tag) (+ acc 1) acc)) 0 tog-items))

(defun tog-progress-build-bar (n)
  "Return bar string of given size."
  (propertize (s-repeat n "—") 'face 'font-lock-keyword-face))

(defun tog-progress-build-header ()
  "Prepare string to show in header line"
  (let* ((width (window-width))
         (current-pos (round (* width (/ (float tog-index) (length tog-items)))))
         (n-done (round (* width (/ (float (tog-progress-done)) (length tog-items)))))
         (current-pos-marker "⯆"))
    (if (> current-pos n-done)
        (concat (tog-progress-build-bar n-done)
                (s-repeat (- current-pos n-done) " ")
                current-pos-marker)
      (concat (tog-progress-build-bar current-pos)
              current-pos-marker
              (tog-progress-build-bar (- n-done current-pos 1))))))

(provide 'tog-progress)

;;; tog-progress.el ends here
