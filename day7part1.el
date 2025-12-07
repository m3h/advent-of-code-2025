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

  (let ((frontier (list (get_start)))
	(visited ())
	(split-count 0))
    (while frontier

      (print frontier)

      (let ((current (car frontier)))

	(setq frontier (cdr frontier))

	(when (and (not (member current visited)) (or (string-equal (grid_get (nth 0 current) (nth 1 current)) ".") (string-equal (grid_get (nth 0 current) (nth 1 current)) "S")))
;  	  (setq frontier (cdr frontier))
	  (setq visited (cons current visited))
	  (let ((current-x (nth 0 current))
	        (current-y (nth 1 current)))


	    (let ((next-down (grid_get (+ current-x 1) current-y)))
	    (when (string-equal next-down ".")
	      (setq frontier (cons (list (+ current-x 1) current-y) frontier))
	      )
	    (when (string-equal next-down "^")
	      (setq split-count (+ split-count 1))
	      (setq frontier (cons (list (+ current-x 1) (+ current-y 1)) frontier))
	      (setq frontier (cons (list (+ current-x 1) (- current-y 1)) frontier))))))))
    split-count))
