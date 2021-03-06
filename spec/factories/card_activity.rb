FactoryGirl.define do
  factory :card_activity do
    skip_create
    
    base {
      { "id"=>"534ee80f3b78484e68a567a4", 
        "idMemberCreator"=>"51b09826cb6a2ca1060041d6", 
        "date"=>"2014-04-16T20:29:03.332Z", 
        "memberCreator"=>{
          "id"=>"51b09826cb6a2ca1060041d6", 
          "avatarHash"=>"a364e5968cde856241fe1eb5cc45366e", 
          "fullName"=>"Ken Judy", 
          "initials"=>"KJ", 
          "username"=>"kenjudy"
        }
      }
    }
    
    type_data {
      { 
        "type"=>"copyCard", 
      }
    }
    
    data {
      {
        "data" => { 
          "card" => {
            "closed" => false
          }
        } 
      }
    }

    initialize_with { CardActivity.new(base.merge(type_data).merge(data)) }
    
    trait :add_attachment_to_card do
      type_data {
        {  
          "type"=>"addAttachmentToCard", 
        }
      }
      data {
        {
          "data"=>{
            "attachment" =>{
              "name" => "attachment_file_name.jpg"
            },
            "card" => {
              "closed" => false
            }
          },
        }
      }
    end
    
    trait :add_member_to_card do
      type_data {
        { "member" =>{
            "fullName" => "Joan Doe"
          },
          "type"=>"addMemberToCard", 
        }
      }
    end
    
    trait :add_checklist_to_card do
      type_data {
        {  
          "type"=>"addChecklistToCard", 
        }
      }
      data {
        {
          "data"=>{
            "checklist" =>{
              "name" => "Things to do"
            },
            "card" => {
              "closed" => false
            }
          },
        }
      }
    end

    trait :comment_card do
      type_data {
        { 
          "type"=>"commentCard", 
        }
      }
      data {
        {
          "data" =>{
            "text" => "Make a change",
            "card" => {
              "closed" => false
            }
          },
        }
      }
    end
    
    trait :create_card do
      type_data { {"type" => "createCard"} }
    end
    
    trait :copy_card do
      type_data { {"type" => "copyCard"} }
    end
    
    trait :convert_to_card_from_check_item do
      type_data { {"type" => "convertToCardFromCheckItem"} }
    end

    trait :delete_attachment_from_card do
      type_data {
        { 
          "type"=>"deleteAttachmentFromCard", 
        }
      }
      data {
        {
          "data"=>{
            "attachment" =>{
              "name" => "attachment_file_name.jpg"
            },
            "card" => {
              "closed" => false
            }
          }, 
        }
      }
    end
    
    trait :move_card_from_board do
      type_data {
        { 
          "type"=>"moveCardFromBoard", 
        }
      }
      data {
        {
          "data"=>{
            "board" =>{
              "name" => "Current Sprint"
            },
            "card" => {
              "closed" => false
            }
          }, 
        }
      }
    end

    trait :move_card_to_board do
      type_data {
        {  
          "type"=>"moveCardToBoard", 
        }
      }
      data {
        {
          "data"=>{
            "board" =>{
              "name" => "Current Sprint"
            },
            "card" => {
              "closed" => false
            }
          },
        }
      }
    end

    trait :remove_checklist_from_card do
      type_data {
        {  
          "type"=>"removeChecklistFromCard", 
        }
      }
      data {
        {
          "data"=>{
            "checklist" =>{
              "name" => "Things to do"
            },
            "card" => {
              "closed" => false
            }
          },
        }
      }
    end

    trait :remove_member_from_card do
      type_data {
        { "member" =>{
            "fullName" => "Joan Doe"
          },
          "type"=>"removeMemberFromCard", 
        }
      }
    end
    
    trait :update_check_item_state_on_card do
      type_data {
        {  
          "type"=>"updateCheckItemStateOnCard", 
        }
      }
      data {
        {
          "data"=>{
            "checklist" =>{
              "name" => "Things to do"
            },
            "card" => {
              "closed" => false
            }
          },
        }
      }
    end
    
    trait :update_card_move_to_list do
      type_data {
        {  
          "type"=>"updateCard", 
        }
      }
      data {
        {
          "data"=>{
            "listBefore" =>{
              "name" => "Old List"
            },
            "listAfter" =>{
              "name" => "New List"
            },
            "card" => {
              "closed" => false
            }
          },
        }
      }
    end

    trait :update_card_raise_priority do
      type_data {
        { 
          "type"=>"updateCard", 
        }
      } 
      data {
        {
          "data"=>{
            "old" =>{
              "pos" => 3
            },
            "card" =>{
              "pos" => 1,
              "closed" => false
            },
          }, 
        }
      }     
    end

    trait :update_card_lower_priority do
      type_data {
        { 
          "type"=>"updateCard", 
        }
      }
      data {
        {
          "data"=>{
            "old" =>{
              "pos" => 3
            },
            "card" =>{
              "pos" => 5,
              "closed" => false
            },
          }, 
        }
      }      
    end

    trait :update_card_priority_as_part_of_list_move do
      previous_type "updateCard"
      type_data {
        {  
          "type"=>"updateCard", 
        }
      } 
      data {
        {
          "data"=>{
                    "old" =>{
                      "pos" => 3
                    },
                    "card" =>{
                      "pos" => 5,
                      "closed" => false
                    },
                  },
        }
      }     
    end
    
    trait :update_card_rename do
      type_data {
        { 
          "type"=>"updateCard", 
        }
      }
      data {
        {
          "data"=>{
                    "card" =>{
                      "name" => "New name",
                      "closed" => false
                    },
                    "old" =>{
                      "name" => "Old nist"
                    }
                  }, 
        }
      }
    end
    
    trait :update_card_change_description do
      type_data {
        {  
          "type"=>"updateCard", 
        }
      }
      data {
        {
          "data"=>{
                    "card" =>{
                      "desc" => "This card is really about <strong>stuff</strong>",
                      "closed" => false
                    },
                    "old" =>{
                      "desc" => "Old desc"
                    }
                  },
        }
      }
    end

    trait :update_card_archive do
      type_data {
        {  
          "type"=>"updateCard", 
        }
      }
      data {
        {
          "data"=>{
                    "old" =>{
                      "closed" => false
                    },
                    "closed" => true
                  },
        }
      }
    end

    trait :update_card_unarchive do
      type_data {
        {  
          "type"=>"updateCard", 
        }
      }
      data {
        {
          "data"=>{
                    "old" =>{
                      "closed" => true
                    },
                    "closed" => false
                  },
        }
      }
    end

  end
end