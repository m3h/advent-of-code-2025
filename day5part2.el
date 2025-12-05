(let ((puzzle_input (with-temp-buffer
                      (insert-file-contents "./input_day5.txt")
                      (buffer-string)
                      ))
      (fresh_ranges '())
      (fresh-count 0))


  (defun split-non-overlap (existing-range new-range)
    (print "new-range")
    (print new-range)
    (let ((split-ranges ())
	  (existing-range-start (car existing-range))
	  (existing-range-end (car (last existing-range)))
	  (new-range-start (car new-range))
	  (new-range-end (car (last new-range))))
      (print new-range-end)
      (let ((before-start new-range-start)
	    (before-end (seq-min (list new-range-end (- existing-range-start 1))))
	    (after-start (seq-max (list new-range-start (+ existing-range-end 1))))
	    (after-end new-range-end))
	(let ((split-new-range ()))
	  (when (<= before-start before-end)
	    (setq split-new-range (cons (list before-start before-end) split-new-range)))
	  (when (<= after-start after-end)
	    (setq split-new-range (cons (list after-start after-end) split-new-range)))
	  split-new-range))))
      
  (defun get-non-overlapping-ranges (existing-ranges new-range)
    (let ((new-ranges (list new-range)))
      (print "test print")
      (dolist (existing-range existing-ranges)
	(let ((tmp-ranges ()))
	  (while new-ranges
	    (dolist (new-range-part (split-non-overlap existing-range (car new-ranges)))
	      (setq tmp-ranges (cons new-range-part tmp-ranges)))
	    (setq new-ranges (cdr new-ranges)))
	  (setq new-ranges tmp-ranges)))
      new-ranges))
      
      
  
  (setq puzzle_input (split-string puzzle_input))

  (while puzzle_input
    (let ((row (car puzzle_input)))
      (setq puzzle_input (cdr puzzle_input))

      (let ((range (split-string row "-")))
	(when (= 2 (length range))
	  (let ((new-range (mapcar 'string-to-number range)))
	    (print new-range)
	    (dolist (new-range-part (get-non-overlapping-ranges fresh_ranges new-range))
	      (setq fresh_ranges (cons new-range-part fresh_ranges))))))))

  (let ((fresh-ingredient-count 0))
    (dolist (fresh_range fresh_ranges)
      (let ((fresh_range_start (car fresh_range))
	    (fresh_range_end (car (last fresh_range))))
	(setq fresh-ingredient-count (+ fresh-ingredient-count (- fresh_range_end fresh_range_start) 1))))
    fresh-ingredient-count)
 )
