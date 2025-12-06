(let ((puzzle_input (with-temp-buffer
                      (insert-file-contents "./input_day6.txt")
                      (buffer-string)
                      ))
      (answer-sum 0))

  (setq puzzle_input (mapcar 'split-string (split-string puzzle_input "\n")))

  (dolist (idx (number-sequence 0 (- (length (car puzzle_input)) 1)))

    (print idx)

    (let ((fn (nth idx (car (last puzzle_input))))
	  (args (mapcar (lambda (x) (string-to-number (nth idx x))) (butlast puzzle_input))))
	  (print fn)
	  (print args)

	  (let ((column-result (apply (intern fn) args)))
	    (setq answer-sum (+ answer-sum column-result)))))
  answer-sum)
