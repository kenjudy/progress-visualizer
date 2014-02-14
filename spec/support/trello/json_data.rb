require 'json'

module ProgressVisualizerTrello
  module JsonData
    def example_card_data(attributes = {})
      JSON.parse(example_card_json_string).merge(attributes)
    end
    
    def example_card_json_string
      "{\"id\":\"524478cbd6c2a2ec3a0001d0\",\"checkItemStates\":[{\"idCheckItem\":\"52c2da57e873fce23c007a37\",\"state\":\"complete\"},{\"idCheckItem\":\"52c2da5e311e532e55030b34\",\"state\":\"complete\"},{\"idCheckItem\":\"52c2da729b1dbc6d67028df1\",\"state\":\"complete\"},{\"idCheckItem\":\"52c6d6fb994816090600eb61\",\"state\":\"complete\"}],\"closed\":true,\"dateLastActivity\":\"2014-01-08T20:18:10.292Z\",\"desc\":\"ADULT LIBRARIANS WILL BE FIRST\\n\\n* URLS:\\n  * *www.simonandschuster.net/grades-k-12*\\n  * *www.simonandschuster.net/grades-k-3*\\n  * *www.simonandschuster.net/grades-4-6*\\n  * *www.simonandschuster.net/grades-7-8*\\n  * *www.simonandschuster.net/grades-9-12*\\n  * *www.simonandschuster.net/higher-ed*\\n  * *www.simonandschuster.net/library*\",\"descData\":{\"emoji\":{}},\"idBoard\":\"5170058469d58225070003cb\",\"idList\":\"52653272e6fa31217b001705\",\"idMembersVoted\":[],\"idShort\":605,\"idAttachmentCover\":null,\"manualCoverAttachment\":false,\"name\":\"(2.5) .NET Layout Setup (Adult Librarians)\",\"pos\":163846.1875,\"shortLink\":\"j56OGdXO\",\"badges\":{\"votes\":0,\"viewingMemberVoted\":false,\"subscribed\":false,\"fogbugz\":\"\",\"checkItems\":4,\"checkItemsChecked\":4,\"comments\":0,\"attachments\":0,\"description\":true,\"due\":null},\"due\":\"2014-01-08T20:18:10.292Z\",\"idChecklists\":[\"52c2da5056f02efb0a0740a2\"],\"idMembers\":[\"51687140ce4301e808000ae5\",\"4fa006a7c7915da5351b21b7\"],\"labels\": [{\"color\":\"yellow\",\"name\":\"Tech Stories\"},{\"color\":\"blue\",\"name\":\"Pimsleur\"}],\"shortUrl\":\"https://trello.com/c/j56OGdXO\",\"subscribed\":false,\"url\":\"https://trello.com/c/j56OGdXO/605-net-layout-setup-adult-librarians\"}"
    end
  
    def example_list_data(attributes = {})
      JSON.parse(example_list_json_string).merge(attributes)
    end

    def example_list_json_string
      "{\"id\":\"52653272e6fa31217b001705\",\"name\":\"Ready for Development\"}"
    end
    
    def example_board_metatada_json_string
      "{\"id\":\"5170058469d58225070003cb\",\"name\":\"Current Sprint\",\"desc\":\"\",\"descData\":null,\"closed\":false,\"idOrganization\":\"5164403d8131293355002b97\",\"pinned\":true,\"url\":\"https://trello.com/b/ZoCdRXWT/current-sprint\",\"shortUrl\":\"https://trello.com/b/ZoCdRXWT\",\"prefs\":{\"permissionLevel\":\"org\",\"voting\":\"disabled\",\"comments\":\"members\",\"invitations\":\"members\",\"selfJoin\":false,\"cardCovers\":true,\"background\":\"blue\",\"backgroundColor\":\"#23719F\",\"backgroundImage\":null,\"backgroundImageScaled\":null,\"backgroundTile\":false,\"backgroundBrightness\":\"unknown\",\"canBePublic\":true,\"canBeOrg\":true,\"canBePrivate\":true,\"canInvite\":true},\"labelNames\":{\"yellow\":\"Tech Stories\",\"red\":\"Bug Stories\",\"purple\":\"Contingent\",\"orange\":\"Inserted\",\"green\":\"Committed\",\"blue\":\"Pimsleur Stories\"}}"
    end
    
    def example_webhook_response_json_string
      <<-JSON
      {
         "action": {
            "id":"51f9424bcd6e040f3c002412",
            "idMemberCreator":"4fc78a59a885233f4b349bd9",
            "data": {
               "board": {
                  "name":"Trello Development",
                  "id":"4d5ea62fd76aa1136000000c"
               },
               "card": {
                  "idShort":1458,
                  "name":"Webhooks",
                  "id":"51a79e72dbb7e23c7c003778"
               },
               "voted":true
            },
            "type":"voteOnCard",
            "date":"2013-07-31T16:58:51.949Z",
            "memberCreator": {
               "id":"4fc78a59a885233f4b349bd9",
               "avatarHash":"2da34d23b5f1ac1a20e2a01157bfa9fe",
               "fullName":"Doug Patti",
               "initials":"DP",
               "username":"doug"
            }
         },
         "model": {
            "id":"4d5ea62fd76aa1136000000c",
            "name":"Trello Development",
            "desc":"Trello board used by the Trello team to track work on Trello.  How meta!\n\nThe development of the Trello API is being tracked at https://trello.com/api\n\nThe development of Trello Mobile applications is being tracked at https://trello.com/mobile",
            "closed":false,
            "idOrganization":"4e1452614e4b8698470000e0",
            "pinned":true,
            "url":"https://trello.com/b/nC8QJJoZ/trello-development",
            "prefs": {
               "permissionLevel":"public",
               "voting":"public",
               "comments":"public",
               "invitations":"members",
               "selfJoin":false,
               "cardCovers":true,
               "canBePublic":false,
               "canBeOrg":false,
               "canBePrivate":false,
               "canInvite":true
            },
            "labelNames": {
               "yellow":"Infrastructure",
               "red":"Bug",
               "purple":"Repro'd",
               "orange":"Feature",
               "green":"Mobile",
               "blue":"Verified"
            }
         }
      }
      JSON
    end
  end
end