require "gmail_api_jp/version"
require "google/apis/gmail_v1"
require "googleauth"
require "googleauth/stores/file_token_store"

require "fileutils"
require "yaml"

module GmailApiJp
  class Draft
    attr_accessor :text

    # the argument text should be like:
    #
    #  Subject: Hello
    #
    #  Lorem ipsum dolor sit amet,
    #  consectetur adipiscing elit,
    #  sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
    #
    #  Ut enim ad minim veniam,
    #  quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
    #
    #  Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
    #  Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
    def initialize(text)
      config = YAML.load_file("gmail_draft.yml")

      @oob_uri = 'urn:ietf:wg:oauth:2.0:oob'
      @app_name = config["application_name"]
      @client_secrets_path = config["client_secrets_path"] || "client_secret.json"
      @credentials_path = config["stored_credential_path"] || File.join(Dir.home, '.credentials',
                                                                       "gmail-draft-jp.yaml")
      @scope = config["scope"] || "https://mail.google.com/"

      @service = Google::Apis::GmailV1::GmailService.new
      @service.client_options.application_name = @app_name
      @service.authorization = authorize
      @text = text.encode("ISO-2022-JP")
    end

    def create_draft
      user_id = 'me'

      draft = Google::Apis::GmailV1::Draft.new
      message = Google::Apis::GmailV1::Message.new
      message.raw = @text
      draft.message = message

      @service.create_user_draft(user_id, draft)
      puts "====== Draft created ====="
    end

    private

    ##
    # Ensure valid credentials, either by restoring from the saved credentials
    # files or intitiating an OAuth2 authorization. If authorization is required,
    # the user's default browser will be launched to approve the request.
    #
    # @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials
    def authorize
      FileUtils.mkdir_p(File.dirname(@credentials_path))

      client_id = Google::Auth::ClientId.from_file(@client_secrets_path)
      token_store = Google::Auth::Stores::FileTokenStore.new(file: @credentials_path)
      authorizer = Google::Auth::UserAuthorizer.new(
          client_id, @scope, token_store)
      user_id = 'default'
      credentials = authorizer.get_credentials(user_id)
      if credentials.nil?
        url = authorizer.get_authorization_url(
            base_url: @oob_uri)
        puts "Open the following URL in the browser and enter the " +
                 "resulting code after authorization"
        puts url
        code = gets
        credentials = authorizer.get_and_store_credentials_from_code(
            user_id: user_id, code: code, base_url: @oob_uri)
      end
      credentials
    end

  end
end
