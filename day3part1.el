(let ((puzzle_input (with-temp-buffer
                      (insert-file-contents "./input_day3.txt")
                      (buffer-string)
                      )))
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
  

  (let ((battery_banks (split-string puzzle_input "\n" t))
        (sum_of_max_joltages 0))

    (print battery_banks)
    (while battery_banks
      (let ((battery_bank (string-to-list (car battery_banks))))
        (setq battery_banks (cdr battery_banks))
        (print battery_bank)

        (let ((first_digit_idx (max_idx (butlast battery_bank))))
          (let ((first_digit (nth first_digit_idx battery_bank)))
            (setq battery_bank (nthcdr (+ first_digit_idx 1) battery_bank))

            (let ((second_digit (apply #'max battery_bank)))

              (let ((joltage_bank (+ (* (- first_digit 48) 10) (- second_digit 48))))

                (print joltage_bank)
                (setq sum_of_max_joltages (+ sum_of_max_joltages joltage_bank))
                (print sum_of_max_joltages)
                
                )
              )
            
            
            
            )
          )
        )
      )
    )
  )
