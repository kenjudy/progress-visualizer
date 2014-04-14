require 'net/http'
require 'open-uri'
require 'json'

class TrelloAdapter < BaseAdapter  
  def initialize(user_profile)
    super
    @credentials = {key: Rails.application.config.trello[:app_key], token: user_profile.readonly_token }
  end

  def self.release_notes
    board = JSON.parse(URI.parse("https://api.trello.com/1/boards/WWtHBRod/lists?cards=open&card_fields=idShort,shortUrl,name,dateLastActivity").read)
    { done:  cards_for_list(board,"52e6778d5922b7e16a641e5b") + cards_for_list(board, "53120d43dc95e0400afad581"),
      doing: cards_for_list(board, "52e6778d5922b7e16a641e5a"),
      todo:  cards_for_list(board, "52e6778d5922b7e16a641e59") }
  end

  def request_board(board_id, include_archived = false)
    ProgressVisualizerTrello::Board.new(request_board_data(board_id, include_archived))
  end

  def request_archived_cards(board_id)
    request_all_cards_data(board_id).map{ |d| ProgressVisualizerTrello::Card.new(d) }
  end

  def request_cards(board_id)
    request_cards_data(board_id).map{ |d| ProgressVisualizerTrello::Card.new(d) }
  end

  def request_lists(board_id)
    request_lists_data(board_id).map{ |d| ProgressVisualizerTrello::List.new(d) }
  end

  def request_board_data(board_id, include_archived = false)
    lists_data = request_lists_data(board_id)
    cards_data = include_archived ? request_all_cards_data(board_id) : request_cards_data(board_id)
    {cards: cards_data, lists: lists_data}
  end

  def request_board_metadata(board_id)
    get_json(Rails.application.config.trello[:board_meta_path], {board_id: board_id})
  end

  def request_all_cards_data(board_id)
    get_json(Rails.application.config.trello[:export_all_cards_path], {board_id: board_id})
  end

  def request_cards_data(board_id)
    get_json(Rails.application.config.trello[:export_cards_path], {board_id: board_id})
  end

  def request_card_data(card_id)
    get_json(Rails.application.config.trello[:card_path], {card_id: card_id})
  end
  
  def request_card_activity_data(card_id)
    get_json(Rails.application.config.trello[:card_activities_path], {card_id: card_id})
  end

  def request_lists_data(board_id)
    get_json(Rails.application.config.trello[:board_lists_path], {board_id: board_id})
  end

  def user_token_url
    generate_uri(Rails.application.config.trello[:trello_root_url] + Rails.application.config.trello[:request_token_path]).to_s
  end

  def add_webhook(callback_url, id_model)
    params = {"description" => "#{user_profile.user.name} #{user_profile.name} burnup", "callbackURL" => callback_url, "idModel" => id_model, }
    response = post_json(Rails.application.config.trello[:add_webhooks_path], params)
    JSON.parse(response.body)
  end

  def destroy_webhook(external_id)
    delete(Rails.application.config.trello[:manage_webhooks_path], {webhook_id: external_id})
  end

  private

  def self.cards_for_list(board, id)
    board.find{ |list| list["id"] == id }["cards"]
  end

  def generate_uri(url_template, options = {})
    url = url_template
    options.merge(@credentials).each { |key,value| url.gsub!("<#{key.to_s.upcase}>", value || "") }
    return parse_url_string(url)
  end

  def parse_url_string(url_string)
    URI.parse(url_string)
  end

  def get_json(url_template, options)
    return JSON.parse(generate_uri("#{Rails.application.config.trello[:api_root_url]}#{url_template}", options).read)
  end

  def post_json(url_template, params, options = {})
    uri = generate_uri("#{Rails.application.config.trello[:trello_root_url]}#{url_template}", options)
    request = Net::HTTP::Post.new(uri.path+"?"+uri.query)
    request.add_field('Content-Type', 'application/json')
    request.body = params.to_json
    http_request(uri, request)
  end

  def delete(url_template, options)
    uri = generate_uri("#{Rails.application.config.trello[:trello_root_url]}#{url_template}", options)
    request = Net::HTTP::Delete.new(uri.path+"?"+uri.query)
    http_request(uri, request)
  end

  def http_request(uri, request)
    http = Net::HTTP.new(uri.host, uri.port)
    http.open_timeout = 30
    http.read_timeout = 30
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    http.request(request)
  end
end