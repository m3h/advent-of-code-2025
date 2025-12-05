(let ((puzzle_input (with-temp-buffer
                      (insert-file-contents "./input_day5.txt")
                      (buffer-string)
                      ))
      (fresh_ranges '())
      (fresh-count 0))


  (defun is-fresh (fresh_ranges ingredient-id)
    (let ((found-fresh-range nil))
      (dolist (range fresh_ranges)
	      (when (and (<= (car range) ingredient-id) (>= (nth 1 range) ingredient-id))
		(setq found-fresh-range t)
		))
      found-fresh-range
      ))
  
  (setq puzzle_input (split-string puzzle_input))

  (while puzzle_input
    (let ((row (car puzzle_input)))
      (setq puzzle_input (cdr puzzle_input))
      (print row)

      (let ((range (split-string row "-")))
	(print range)
	(if (= 2 (length range))
	    (setq fresh_ranges (cons (mapcar 'string-to-number range) fresh_ranges))
	  (when (is-fresh fresh_ranges (string-to-number (car range)))
	    (setq fresh-count (+ fresh-count 1))
	    )))))
  fresh-count
  )
