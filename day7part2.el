(let ((puzzle-input (with-temp-buffer
                      (insert-file-contents "./input_day7.txt")
                      (buffer-string)
                      ))
      (answer-sum 0)
      (fn-args ())
      (fn nil))

  (setq puzzle-input (mapcar (lambda (x) (split-string x "" t)) (split-string puzzle-input "\n")))

  (defun grid_get (x y)
    (nth y (nth x puzzle-input)))

  (defun get_start ()
  (let ((start_x nil)
	(start_y nil))
    (dolist (x (number-sequence 0 (- (length puzzle-input) 1)))
      (dolist (y (number-sequence 0 (- (length (nth x puzzle-input)) 1)))
	(when (string-equal (grid_get x y) "S")
	  (setq start_x x)
	  (setq start_y y))))
    (list start_x start_y)
    ))

  (let ((timelines-for-start (make-hash-table :test 'equal)))
    (defun count-timelines (x y)
      (let ((previous-count (gethash (list x y) timelines-for-start nil)))
	(if previous-count
	    previous-count
	  (let ((count nil)
		(v (grid_get x y)))
	    (when (not v)
	      (setq count 1))
	    (when (or (string-equal v ".") (string-equal v "S"))
	      (setq count (count-timelines (+ x 1) y)))
	    (when (string-equal v "^")
	      (setq count (+ (count-timelines x (- y 1)) (count-timelines x (+ y 1)))))

	    (puthash (list x y) count timelines-for-start)
	    count))))

    (let ((start-point (get_start)))
      (count-timelines (nth 0 start-point) (nth 1 start-point)))))

