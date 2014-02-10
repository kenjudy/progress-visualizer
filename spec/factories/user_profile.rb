FactoryGirl.define do
  factory :user_profile do

    encrypted_readonly_token "oiNg4K0k/c6oK0ToGJjZzg==\n"
    encrypted_current_sprint_board_id "oiNg4K0k/c6oK0ToGJjZzg==\n"
    encrypted_current_sprint_board_id_short "oiNg4K0k/c6oK0ToGJjZzg==\n"
    encrypted_backlog_lists "E4IkS0EnXAymMQLOhX0kYsfpVJZLMGHZ89fWhGGP37M=\n"
    encrypted_done_lists "E4IkS0EnXAymMQLOhX0kYsfpVJZLMGHZ89fWhGGP37M=\n"

    encrypted_readonly_token_iv "Fp9UtpjWt0bEPPfyi+bolA==\n"
    encrypted_current_sprint_board_id_iv "Fp9UtpjWt0bEPPfyi+bolA==\n"
    encrypted_current_sprint_board_id_short_iv "Fp9UtpjWt0bEPPfyi+bolA==\n"
    encrypted_backlog_lists_iv "C1EdRG9ZRsrDiq2tgF8gIw==\n"
    encrypted_done_lists_iv "C1EdRG9ZRsrDiq2tgF8gIw==\n"

    encrypted_readonly_token_salt "93fb281d1a9bf0dc"
    encrypted_current_sprint_board_id_salt "93fb281d1a9bf0dc"
    encrypted_current_sprint_board_id_short_salt "93fb281d1a9bf0dc"
    encrypted_backlog_lists_salt "acbe08f6873d4145"
    encrypted_done_lists_salt "acbe08f6873d4145"

    labels_types_of_work "[\"done\",\"ready\"]"

    duration 'WEEKLY'
    start_day_of_week 1
    end_day_of_week 8
    start_hour 6
    end_hour 0
  
    association :user
  end
end
