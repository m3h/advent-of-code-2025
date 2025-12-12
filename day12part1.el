(let ((puzzle-input (with-temp-buffer
                      (insert-file-contents "./input_day12.txt")
                      (buffer-string))))

  (defun parse-puzzle (puzzle-str)
    (let ((shapes ())
          (current-shape 0)
          (trees ()))
      (dolist (puzzle-row (split-string puzzle-str "\n"))
        (print puzzle-row)

        (if (string-match "x" puzzle-row)
            (setq trees (cons (mapcar #'string-to-number (split-string puzzle-row "[x: ]" t)) trees))

          (if (string-match ":" puzzle-row)
	      (when t
	        (setq shapes (cons current-shape shapes))
		(setq current-shape 0))
	    (setq current-shape (+ current-shape (apply #'+ (mapcar (lambda (c) (if (= c ?#) 1 0))  puzzle-row)))))))

      (setq shapes (cons current-shape shapes))
      (list (reverse (butlast shapes)) (reverse trees))))
		
  (defun count-trees-that-fit (puzzle-str)
    (let ((parsed-puzzle (parse-puzzle puzzle-str))
	  (trees-that-fit-count 0))
      (let ((shapes (nth 0 parsed-puzzle))
	    (trees (nth 1 parsed-puzzle)))

	(dolist (tree trees)
	  (let ((tree-area (* (nth 0 tree) (nth 1 tree)))
		(required-shapes (nthcdr 2 tree))
		(required-shapes-area 0))
	    (dolist (idx (number-sequence 0 (- (length required-shapes) 1)))
	      (setq required-shapes-area (+ required-shapes-area (* (nth idx shapes) (nth idx required-shapes)))))
	    (when (< required-shapes-area tree-area)
	      (setq trees-that-fit-count (+ trees-that-fit-count 1))))))

      trees-that-fit-count))

  (count-trees-that-fit puzzle-input))
