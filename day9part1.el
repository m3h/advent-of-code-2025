(let ((puzzle-input (with-temp-buffer
                      (insert-file-contents "./input_day9.txt")
                      (buffer-string))))

  (setq puzzle-input (mapcar (lambda (x) (mapcar 'string-to-number (split-string x "," t))) (split-string puzzle-input "\n")))


    ;; thanks, Google Gemini
  (defun zip-lists (lists)
    (when (car lists)
      (cons (mapcar #'car lists)
	    (zip-lists (mapcar #'cdr lists)))))

  puzzle-input)
