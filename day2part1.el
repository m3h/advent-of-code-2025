(let ((puzzle_input (with-temp-buffer
  (insert-file-contents "./input_day2.txt")
  (buffer-string)
  )))


  (let ((ranges (split-string puzzle_input "," t "\n"))
	(invalid_id_sum 0))
    ;(print ranges)

    (while ranges
      (let ((range (car ranges)))
	(setq ranges (cdr ranges))
;	(print range)

	(let ((range_start_end (split-string range "-")))
;	  (print range_start_end)
	  (let ((range_start (string-to-number (car range_start_end)))
		(range_end
		 (string-to-number (car (last range_start_end)))))
;	    (print range_start)
;	    (print range_end)

	    (dolist
		(product_id (number-sequence range_start range_end 1))
;	      (print product_id)

	      (let ((product_id_str (number-to-string product_id)))
		(let ((product_id_len (length product_id_str)))
		  (let
		      ((product_id_first_half
			(substring product_id_str 0
				   (/ product_id_len 2)))
			(product_id_last_half
			 (substring product_id_str
				    (/ product_id_len 2))))
;		    (print product_id_first_half)
;		    (print product_id_last_half)

		    (when
			(string-equal product_id_first_half
				      product_id_last_half)
		      (print product_id)
		      (setq invalid_id_sum
			    (+ invalid_id_sum product_id))
		  )
		)
	      )
	  )
	)
      )
  )

  
  )
      )
    (print invalid_id_sum)
    )
  )
