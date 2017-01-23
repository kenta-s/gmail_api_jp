require 'test_helper'
require 'gmail_api_jp'

class DraftTest < GmailApiJp::Draft
  def initialize(text)
    @config = YAML.load_file("test/fixtures/gmail_draft.yaml")

    @oob_uri = 'urn:ietf:wg:oauth:2.0:oob'
    @app_name = @config["application_name"]
    @client_secrets_path = @config["client_secrets_path"] || "client_secret.json"
    @credentials_path = @config["stored_credential_path"] || File.join(Dir.home, '.credentials',
                                                                       "gmail-draft-jp.yaml")
    @scope = @config["scope"] || "https://mail.google.com/"

    @text = text.encode("ISO-2022-JP")
  end
end

class GmailApiJpTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::GmailApiJp::VERSION
  end

  def test_it_can_be_initialized_with_yaml_file
    draft = DraftTest.new("test")
    assert_equal DraftTest, draft.class
  end

  def test_text_can_be_set_and_encoded
    text =<<TEXT
To: foo@example.com
Cc: bar@example.com, baz@example.com
Subject: Hello, my friend

Lorem ipsum dolor sit amet,
consectetur adipiscing elit,
sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.

Ut enim ad minim veniam,
quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
Excepteur sint occaecat cupidatat non proident,
sunt in culpa qui officia deserunt mollit anim id est laborum.
TEXT
    draft = DraftTest.new(text)
    assert_equal text.encode("ISO-2022-JP"), draft.text
  end
end
