# frozen_string_literal: true

require 'rubyXL/convenience_methods/worksheet'

class UserBulkService < ApplicationService
  attr_reader :archive, :error_message

  # rubocop:disable Lint/MissingSuper
  def initialize(archive_param)
    @archive = archive_param.tempfile
    @error_message = nil
  end
  # rubocop:enable Lint/MissingSuper

  def call
    unless zip_file?(@archive)
      @error_message = 'Invalid file format. Please upload a ZIP archive.'
      return self
    end

    Zip::File.open(@archive) do |zip_file|
      zip_file.each do |xlsx_file|
        User.import users_from(xlsx_file), ignore: true
      end
    end
    self
  end

  def zip_file?(file)
    file.rewind # Перемещаем указатель в начало файла
    file.read(2) == 'PK' # Все ZIP-архивы начинаются с "PK"
  ensure
    file.rewind # Возвращаем указатель в начало файла
  end

  private

  def users_from(xlsx_file)
    sheet = RubyXL::Parser.parse_buffer(xlsx_file.get_input_stream.read)[0]

    existing_emails = User.pluck(:email).to_set # Загружаем email из базы
    seen_emails = Set.new                        # Отслеживаем email в файле

    sheet.each_with_object([]) do |row, users|
      next if row.nil? || row.cells.all?(&:nil?) # Пропуск пустых строк

      cells = row.cells.map { |cell| cell&.value.to_s.strip } # Обработка nil и удаление пробелов
      next if cells.size < 3 || cells.any?(&:empty?) # Пропуск строк с недостающими данными

      email = cells[1]
      next if seen_emails.include?(email) || existing_emails.include?(email) # Пропуск дубликатов

      seen_emails.add(email)
      users << User.new(
        name: cells[0],
        email:,
        password: cells[2],
        password_confirmation: cells[2]
      )
    end
  end
end
