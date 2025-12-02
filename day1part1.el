(setq remaining_moves (split-string
		       (with-temp-buffer
			 (insert-file-contents "input_day1.txt")
			 (buffer-string)
			 )))

(setq current_position 50)
(setq count_of_zero 0)

(while remaining_moves

  (setq current_move (car remaining_moves))
  (print current_move)
  (setq current_direction (substring current_move 0 1))
  
  (setq current_rotations (string-to-number (substring current_move 1)))

  (when (string-equal current_direction "L") (setq current_rotations (* current_rotations -1)))

  (setq current_position (+ current_position current_rotations))
  (setq current_position (% current_position 100))

  (when (= current_position 0) (setq count_of_zero (+ count_of_zero 1)))
  
  (setq remaining_moves (cdr remaining_moves))
  (print current_position)
  (print count_of_zero)
  )

(print count_of_zero)
