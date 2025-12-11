(let ((puzzle-input (with-temp-buffer
                      (insert-file-contents "./input_day11.txt")
                      (buffer-string))))


  (defun parse-input (puzzle-input)
    (let ((puzzle-rows-split (mapcar (lambda (x) (split-string x "[ :]" t)) (split-string puzzle-input "\n" t))))
      (let ((path-lookup (make-hash-table :test #'equal)))
	(dolist (puzzle-row puzzle-rows-split)
	  (puthash (car puzzle-row) (cdr puzzle-row) path-lookup))

	path-lookup)))

  (defun count-paths (src path-lookup)
    (let ((path-count-cache (make-hash-table :test #'equal)))

      (defun dfs-count-paths-cached (src path-lookup)
        (let ((cached-result (gethash src path-count-cache)))
	  (if cached-result
	      cached-result
	    (if (equal src "out")
	        1
	      (let ((paths-from-src (apply #'+ (mapcar (lambda (x) (dfs-count-paths-cached x path-lookup)) (gethash src path-lookup)))))
		(puthash src paths-from-src path-count-cache)
		paths-from-src)))))

      (dfs-count-paths-cached src path-lookup)))

  (let ((total-paths (count-paths "you" (parse-input puzzle-input))))
    (message "total paths: %s" total-paths)
    total-paths))
