(let ((puzzle-input (with-temp-buffer
                      (insert-file-contents "./input_day8.txt")
                      (buffer-string))))

  (setq puzzle-input (mapcar (lambda (x) (mapcar 'string-to-number (split-string x "," t))) (split-string puzzle-input "\n")))


    ;; thanks, Google Gemini
  (defun zip-lists (lists)
    (when (car lists)
      (cons (mapcar #'car lists)
	    (zip-lists (mapcar #'cdr lists)))))

  (defun min-index (list key-fn)
    "find index of list which has the min (key-fn arg). key-fn should return a number"
    (let ((min-idx nil)
	  (min-val nil)
	  (cur-idx 0))
      (while list
	(let ((cur-val (funcall key-fn (car list))))
	  (when (or (not min-val ) (< cur-val min-val))
	    (setq min-val cur-val)
	    (setq min-idx cur-idx))

	  (setq list (cdr list))
	  (setq cur-idx (+ cur-idx 1))))
      min-idx))
      
  
  (defun straight-line-distance (&rest coords)
    "find L2 distance between coords, where each coord are lists with equal number of coordinates"
    (sqrt (apply #'+
	   (mapcar (lambda (x) (* x x))
		   (mapcar (lambda (x) (apply #'- x)) (zip-lists coords))))))


  (defun get-pairs-by-distance (coords)
    (let ((pairs-with-distance ()))
      (while coords
	(let ((c1 (car coords)))
	  (message "remaining coords to get pairs for %s" (length coords))
	  (setq coords (cdr coords))

	  (let ((dists-and-coords-to-c1 (mapcar (lambda (c2) (list (straight-line-distance c1 c2) c1 c2)) coords)))
	    (setq pairs-with-distance (append pairs-with-distance dists-and-coords-to-c1)))))
      (sort pairs-with-distance :key #'car)))
	    
  (defun find-closest-unconnected-pair (coords connections-map pairs-with-distance)

    (let ((closest-unconnected-pair nil))
      (while pairs-with-distance
        (let ((closest-pair (car pairs-with-distance)))
	  (setq pairs-with-distance (cdr pairs-with-distance))
  	  (let ((c1 (nth 1 closest-pair))
		(c2 (nth 2 closest-pair)))
	    (when (not (gethash (list c1 c2) connections-map))
	      (setq closest-unconnected-pair (list c1 c2))
	      (setq pairs-with-distance nil)))))
      closest-unconnected-pair))

  (defun add-connection-path (c1 c2 connections-path)
    (when (not (gethash c1 connections-path))
      (puthash c1 () connections-path))
    (puthash c1 (cons c2 (gethash c1 connections-path)) connections-path))


  (defun get-circuit-size-destructive (c1 connections-path)
    (let ((frontier (list c1))
	  (visited ()))

      (while frontier
	(let ((c (car frontier)))
	  (setq frontier (cdr frontier))
	  (when (and (not (member c visited)) c)
	    (setq visited (cons c visited))
	    (setq frontier (append frontier (gethash c connections-path)))
	    (remhash c connections-path))))
      (length visited)))

  (defun hash-table-keys (hash-table)
    (let ((keys ()))
      (maphash (lambda (k v) (push k keys)) hash-table)
      keys))
  
  (defun get-circuit-sizes-destructive (connections-path)

    (let ((sizes ()))
      (while (/= 0 (hash-table-count connections-path))
        (let ((c1 (car (hash-table-keys connections-path))))
	  (setq sizes (cons (get-circuit-size-destructive c1 connections-path) sizes))))
      sizes))
	
    
      
      

  (let ((connections-map (make-hash-table :test #'equal))
	(connections-path (make-hash-table :test #'equal))
	(pairs-with-distance (get-pairs-by-distance puzzle-input)))

    (dolist (closest-pair-number (number-sequence 1 1000))
      (let ((closest-pair (find-closest-unconnected-pair puzzle-input connections-map pairs-with-distance)))
	(let ((c1 (nth 0 closest-pair))
	      (c2 (nth 1 closest-pair)))

	  (message "closest-pair-number: %s" closest-pair-number)
	  (print c1)
	  (print c2)
	  (print " ")

	  (puthash (list c1 c2) t connections-map)
	  (puthash (list c2 c1) t connections-map)

	  (add-connection-path c1 c2 connections-path)
	  (add-connection-path c2 c1 connections-path)
	  )))

    (let ((circuit-sizes (sort (get-circuit-sizes-destructive connections-path) :reverse t)))
      (apply #'* (take 3 circuit-sizes)))))
