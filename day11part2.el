(let ((puzzle-input (with-temp-buffer
                      (insert-file-contents "./input_day11.txt")
                      (buffer-string))))


  (defun parse-input (puzzle-input)
    (let ((puzzle-rows-split (mapcar (lambda (x) (split-string x "[ :]" t)) (split-string puzzle-input "\n" t))))
      (let ((path-lookup (make-hash-table :test #'equal)))
	(dolist (puzzle-row puzzle-rows-split)
	  (puthash (car puzzle-row) (cdr puzzle-row) path-lookup))

	path-lookup)))

  (defun sum-parallel-list (a b)
    (let ((s ()))
      (while a
	(setq s (cons (+ (car a) (car b)) s))
	(setq a (cdr a))
	(setq b (cdr b)))
      (reverse s)))

  (defun promote-path-counts (src paths-from-src)
    (if (equal src "fft")
      (list
       0
       (+ (nth 0 paths-from-src) (nth 1 paths-from-src))
       0
       (+ (nth 2 paths-from-src) (nth 3 paths-from-src)))
      (if (equal src "dac")
	  (list
	   0
	   0
	   (+ (nth 0 paths-from-src) (nth 2 paths-from-src))
	   (+ (nth 1 paths-from-src) (nth 3 paths-from-src)))
	paths-from-src)))
      
	

  (defun count-paths (src path-lookup)
    (let ((path-count-cache (make-hash-table :test #'equal)))

      (defun dfs-count-paths-cached (src path-lookup)
        (let ((cached-result (gethash src path-count-cache)))
	  (if cached-result
	      cached-result
	    (if (equal src "out")
		; none fft dac fft+dac
	        (list 1 0 0 0)
	      
	      (let ((paths-from-src (list 0 0 0 0)))
		(dolist (dst (gethash src path-lookup))
		  (let ((child-paths-from-src (dfs-count-paths-cached dst path-lookup)))
		    (setq paths-from-src (sum-parallel-list paths-from-src child-paths-from-src))))
		(setq paths-from-src (promote-path-counts src paths-from-src))
		(puthash src paths-from-src path-count-cache))))))

      (car (last (dfs-count-paths-cached src path-lookup)))))

  (let ((total-paths (count-paths "svr" (parse-input puzzle-input))))
    (message "total paths: %s" total-paths)
    total-paths))
