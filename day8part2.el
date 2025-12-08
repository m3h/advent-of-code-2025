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
	      (setq closest-unconnected-pair (list c1 c2 pairs-with-distance))
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
	(junction-box-count (length puzzle-input))
	(pairs-with-distance (get-pairs-by-distance puzzle-input))
	(pair-number 0)
	(first-circuit-size 0)
	(first-coord (car puzzle-input))
	(last-added-pair nil))

    (while (< first-circuit-size junction-box-count)
      (message "first-circuit-size %s pair-number %s" first-circuit-size pair-number)
      (let ((closest-pair (find-closest-unconnected-pair puzzle-input connections-map pairs-with-distance)))
	(let ((c1 (nth 0 closest-pair))
	      (c2 (nth 1 closest-pair)))

	  (setq pairs-with-distance (nth 2 closest-pair))
	  (setq pair-number (+ pair-number 1))

	  (message "last-added-pair: %s" last-added-pair)
	  (print c1)
	  (print c2)
	  (print " ")

	  (puthash (list c1 c2) t connections-map)
	  (puthash (list c2 c1) t connections-map)

	  (add-connection-path c1 c2 connections-path)
	  (add-connection-path c2 c1 connections-path)

	  (setq last-added-pair (list c1 c2))
	  ))
      (setq first-circuit-size (get-circuit-size-destructive first-coord (copy-hash-table connections-path))))

    (* (car (nth 0 last-added-pair)) (car (nth 1 last-added-pair)))))
