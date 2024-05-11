# frozen_string_literal: true
require 'rubyXL/convenience_methods/worksheet'

class UserBulkService < ApplicationService
  attr_reader :archive
  
  # rubocop:disable Lint/MissingSuper
  def initialize(archive_param)
    @archive = archive_param.tempfile
  end
  # rubocop:enable Lint/MissingSuper

  def call
    Zip::File.open(@archive) do |zip_file|
      zip_file.each do |xlsx_file|

        users_from(xlsx_file).to_s
       # print "+++++"
        User.import users_from(xlsx_file), ignore: true
      end
    end
  end

  private

  def users_from(xlsx_file)
    sheet = RubyXL::Parser.parse_buffer(xlsx_file.get_input_stream.read)[0]
    sheet.map do |row|
      #cells = row.cells
      cells = [ {name: 'John2'}, {email: 'ttt2@test.com'}, {password_digest: 'P@ssw0rd$!'}, {remember_token_digest: 'P@ssw0rd$!'} ]

        #print cells
        #print "---------"

        User.new name: cells[0], email: cells[1], password: cells[2], password_confirmation: cells[2]
    end
  end
end