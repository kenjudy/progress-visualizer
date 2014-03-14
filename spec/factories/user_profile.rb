FactoryGirl.define do
  factory :user_profile do
    name "ProgressVisualizer"
    default "1"

    encrypted_readonly_token "bE5KdKtusxpH53Uc5UCAtOTZmJ2Kdxw+sQheoh26NKznF8bPrAAB7OeJC1Um\n1mSY8QkbQFuiBDp6B4mt9gL0F2gGEbl8xGnjRQkanII10EE=\n"
    encrypted_current_sprint_board_id "eLpseO/bolkV+aEJgp9lLpdfYDzi1wrsTlTmxLIxDAc=\n"
    encrypted_current_sprint_board_id_short "aa1E2UCK/05LiLatgAUmOQ==\n"
    encrypted_backlog_lists "w6KRgSPBT5c4zdTy1rNBxDbtEvAGjgZmbNjI+KVY6nPhj4M1J5yIOCtAA7J2\nBQN+K28EVABztVh86KAELXHP46MCtv92bjj6cZ9C08Wbsww=\n"
    encrypted_done_lists "fHKKGSlwHUwO1W/mNUuCpIYZrRlmO5WolYEkdeAFJMvkZze2+8LbOrfuIOGX\nvVq8\n"

    encrypted_readonly_token_iv "MNhFHZzRl9vhBrWEMCquLA==\n"
    encrypted_current_sprint_board_id_iv "DUmrScm5G80EoOd+tr9S/Q==\n"
    encrypted_current_sprint_board_id_short_iv "RkHUhiPg3sIVhTLWD97TCg==\n"
    encrypted_backlog_lists_iv "mIyQ7p5itgqdyqZESoB6ZQ==\n"
    encrypted_done_lists_iv "nQGQbHWqNW559pT39mTKMw==\n"

    encrypted_readonly_token_salt "ef09fa7fbf4df188"
    encrypted_current_sprint_board_id_salt "3c1b12ea1a272e92"
    encrypted_current_sprint_board_id_short_salt "d2d9d596eb3972ae"
    encrypted_backlog_lists_salt "0e0b1f42fbf9217e"
    encrypted_done_lists_salt "d9e0d5219ba0b408"

    labels_types_of_work "red"

    duration 7
    start_day_of_week 1
    end_day_of_week 0
    start_hour 9
    end_hour 0

    association :user
  end
end
