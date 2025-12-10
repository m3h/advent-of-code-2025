(let ((puzzle-input (with-temp-buffer
                      (insert-file-contents "./input_day10.txt")
                      (buffer-string))))

  (defun parse-machine-configuration (configuration)
    (cons
     ; [.##.] -> (nil t t nil)
     (mapcar (lambda (c) (if (= c ?\.) nil t)) (cdr (butlast (string-to-list (car configuration)))))

     (mapcar (lambda (x) (mapcar #'string-to-number (split-string x "[,\(\)]" t))) (butlast (cdr configuration)))))
  
  (setq puzzle-input (mapcar (lambda (x) (split-string x " " t)) (split-string puzzle-input "\n" t)))

  (defun press-button (button current-state)
    "press the button, toggling the lights in state and returning a new state"
    (let ((new-state (copy-sequence current-state)))
      (dolist (button-light button)
        (setcar (nthcdr button-light new-state) (not (nth button-light new-state))))
      new-state))

  (defun bfs (configuration)
    (let ((desired-state (car configuration))
	  (button-sets (cdr configuration))
	  (minimum-presses nil)
	  (visited-states ()))

      (message "configuration: %s" configuration)
      
      ; frontier - (current-presses current-state)
      (let ((frontier (list (list 0 (make-list (length desired-state) nil)))))

        (while (not minimum-presses)
	  (let ((node (car frontier)))
	    (setq frontier (cdr frontier))

	    (setq visited-states (cons (car (cdr node)) visited-states))

	    (let ((new-nodes (seq-filter
			      (lambda (x) (if (member (car (cdr x)) visited-states) nil x))
			      (mapcar
			       (lambda (button-set) (list (+ 1 (car node)) (press-button button-set (car (cdr node)))))
			       button-sets))))
	      (dolist (new-node new-nodes)
		(when (equal (car (cdr new-node)) desired-state)
		  (setq minimum-presses (car new-node))))
	      (setq frontier (append frontier new-nodes)))))
	minimum-presses)))

  (let ((total-minimum-presses (apply #'+ (mapcar #'bfs (mapcar #'parse-machine-configuration puzzle-input)))))
    (message "total minimum presses: %s" total-minimum-presses)))

