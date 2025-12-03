(let ((puzzle_input (with-temp-buffer
                      (insert-file-contents "./input_day3.txt")
                      (buffer-string)
                      )))

                                        ;(setq puzzle_input "987654321111111")
  
  (defun max_idx (l)
    (let ((max_val nil)
          (max_val_idx nil))

      (cl-loop for index from 0
               for item in l
               do
               (when (or (not max_val) (> item max_val))
                 (setq max_val item)
                 (setq max_val_idx index)
                 )
               )
      max_val_idx
      )
    )

  (defun max_joltage (battery_bank remaining_slots)
                                        ;(print "max_joltage")
                                        ;(print remaining_slots)
                                        ;(print battery_bank)
                                        ;(print remaining_slots)
    

    (if (= remaining_slots 0)
        0
      (let ((first_digit_idx (max_idx (butlast battery_bank (- remaining_slots 1)))))
                                        ;(print "inside else")
        (let ((first_digit (nth first_digit_idx battery_bank)))
          (setq battery_bank (nthcdr (+ first_digit_idx 1) battery_bank))

                                        ;(print first_digit_idx)
                                        ;(print battery_bank)

          (let ((sub_max_joltage (max_joltage battery_bank (- remaining_slots 1))))
                                        ;(print "sub_max_joltage")
                                        ;(print sub_max_joltage)

            (let ((joltage_bank (+ (* (- first_digit 48) (expt 10 (- remaining_slots 1))) sub_max_joltage)))
              joltage_bank
              
              )
            )
          )        
        )
      )  
    )
  

  (let ((battery_banks (split-string puzzle_input "\n" t "\n"))
        (sum_of_max_joltages 0))

                                        ;(print battery_banks)
    (while battery_banks
      (let ((battery_bank (string-to-list (car battery_banks))))
        (setq battery_banks (cdr battery_banks))
        (print battery_bank)

        (let ((max_joltage_of_bank (max_joltage battery_bank 12)))
          (print "max_joltage_of_bank")
          (print max_joltage_of_bank)
          (setq sum_of_max_joltages (+ sum_of_max_joltages max_joltage_of_bank))
          (print sum_of_max_joltages)

          sum_of_max_joltages
          )
        )
      )
    sum_of_max_joltages
    )
  )


