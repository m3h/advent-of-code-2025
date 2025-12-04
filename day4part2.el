(let ((puzzle_input (with-temp-buffer
                      (insert-file-contents "./input_day4.txt")
                      (buffer-string)
                      )))
  
  (setq puzzle_input (mapcar 'string-to-list (split-string puzzle_input)))

  (defun safe_get (grid x y)
    (if (or (< x 0) (>= x (length grid)))
      46
      (if (or (< y 0) (>= y (length (nth x grid))))
	46
	(nth y (nth x grid))
	)))
  
  (defun count_neighbours (grid x y)
    (let ((roll_count 0))
      (dolist (xd (number-sequence -1 1))
        (dolist (yd (number-sequence -1 1))
	  (let ((xn (+ x xd))
	        (yn (+ y yd)))
	    (when (and (or (/= xn x) (/= yn y)) (= (safe_get grid xn yn) 64))
					; don't count x y
	      (setq roll_count (+ roll_count 1))
	      ))))
      roll_count
      ))

  (defun remove_movable_rolls_single_pass (grid)
    (print "remove_movable_rolls_single_pass")
    (let ((roll_count 0))
      (dolist (x (number-sequence 0 (- (length grid) 1)))
	(dolist (y (number-sequence 0 (- (length (nth x grid)) 1)))
	  (when (and (= (safe_get grid x y) 64) (< (count_neighbours grid x y) 4))
	    (setq roll_count (+ roll_count 1))
	    (setf (nth y (nth x grid)) 46)
	    (print roll_count)
	    )))
      roll_count
      ))

  (defun remove_movable_rolls_iteratively (grid)
    (print "remove_movable_rolls_iteratively")
    (let ((total_rolls_moved 0)
	  (progress t))
      (while progress
	(let ((rolls_moved (remove_movable_rolls_single_pass grid)))
	  (setq progress (> rolls_moved 0))
	  (setq total_rolls_moved (+ total_rolls_moved rolls_moved))
	  ;(setq progress nil)
	  ))
      total_rolls_moved
      )
    )
  
  (print puzzle_input)
  ;(print (count_neighbours puzzle_input 3 0))

  (remove_movable_rolls_iteratively puzzle_input)

  
  ;(print (nth 1 puzzle_input))
					;(print (nth 1 (nth 1 puzzle_input)))
  ;(print "end")
  )
