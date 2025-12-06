(let ((puzzle-input (with-temp-buffer
                      (insert-file-contents "./input_day6.txt")
                      (buffer-string)
                      ))
      (answer-sum 0)
      (fn-args ())
      (fn nil))

  (setq puzzle-input (mapcar (lambda (x) (split-string x "" t)) (split-string puzzle-input "\n")))

  (dolist (column-idx (number-sequence 0 (length (car puzzle-input))))
    (let ((last-char (nth column-idx (car (last puzzle-input)))))

      
					; to ensure we compute the last operation
					; iterate through all columns (when we go past the last column, we hit nil
      
      (when (or (not (string-equal last-char " ")) (not last-char))
	(when fn
	  (let ((fn-result (apply (intern fn) fn-args)))
	    (setq answer-sum (+ answer-sum fn-result))))
	(setq fn-args ())
	(setq fn last-char))

      (let ((new-number-str (string-trim (apply 'concat (mapcar (lambda (row) (nth column-idx row)) (butlast puzzle-input))))))
	(when (not (string-equal new-number-str ""))
	  (let ((new-number (string-to-number new-number-str)))
	    (setq fn-args (cons new-number fn-args)))))))
  answer-sum)
