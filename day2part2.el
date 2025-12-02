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
                                        ;       (print range)

        (let ((range_start_end (split-string range "-")))
                                        ;         (print range_start_end)
          (let ((range_start (string-to-number (car range_start_end)))
                (range_end
                 (string-to-number (car (last range_start_end)))))
                                        ;           (print range_start)
                                        ;           (print range_end)

            (dolist
                (product_id (number-sequence range_start range_end 1))
                                        ; (print product_id)

              

              (let ((product_id_str (number-to-string product_id)))
                (let ((product_id_len (length product_id_str)))

                  (setq product_is_invalid nil)

                  

                  (dolist
                      (repetitions
                       (number-sequence 2 product_id_len 1))
                    (let
                        ((repetition_size
                          (/ product_id_len repetitions)))

                      (when (= (% product_id_len repetitions) 0)
                        
                        
                                        ;(print product_id)
                                        ;(print repetitions)
                                        ;(print repetition_size)
                        (when
                            (seq-every-p
                             (lambda (repeated_part_start_idx)
                               (string-equal
                                (substring product_id_str 0
                                           repetition_size)
                                (substring product_id_str
                                           repeated_part_start_idx
                                           (+ repeated_part_start_idx
                                              repetition_size
                                              ))))
                             (number-sequence 0
                                              (- product_id_len
                                                 repetition_size)
                                              repetition_size))

                          (setq product_is_invalid t)
                          (print product_id)
                          
                          )
                        
                        )
                      )
                    
                    )
                  (when product_is_invalid
                    (setq invalid_id_sum (+ invalid_id_sum product_id))
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


