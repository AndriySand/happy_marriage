class Email

  require 'gmail'

  def self.receive_email_and_create_article
    start_reg = /Content-Transfer-Encoding:[\s\w\-*\d]{,20}(\n)+>*/
    finish_reg = /\n+-{3,20}\d{,30}\n+Content-Type: text\/html/

    gmail = Gmail.new('idap.group.news@gmail.com', 'fortu.ne8')
    emails = gmail.inbox.emails(:unread, :from => "australi@inbox.ru")
    email = emails.shift
    body = email.body.to_s
    deleting_string = body[start_reg]
    if deleting_string
      body.slice!(0, body.index(deleting_string) + deleting_string.size)
      deleting_string = body[finish_reg]
      formatted_str = body.slice!(0, body.index(deleting_string))
      @data_str = formatted_str.gsub("\"", '').gsub("\n>", '').gsub(/\s{2,}/, ' ').gsub("*", '').gsub("CC Note:", 'CC Note -')

      note_item_ids = get_values(/NoteItemId\W\s\w+\d+\S+/)
      titles = get_values(/Summary\W[\s\w\/*(.%)*]+/)
      company_names = get_values(/CompanyName\W[\s*\w+&*\-]+/)
      contents = get_values(/Content\W*[\d*\w+\s,&*.(*)*%*'*\-*]+/)
      links1 = get_values(/SourceUrl\W[\s*\w+:\/.-]+/)
      links2 = get_values(/LinkToDealFile\W[\s*\w+:\/.-]+/)

      unformatted_date_str = @data_str.slice(/\d{,2}\/\d{,2}\/\d{,4}\s+\d{,2}:\d{,2}\s+(AM|PM)/)
      date_str = DateTime.strptime(unformatted_date_str, '%m/%d/%Y %H:%M %p').to_s
      region = @data_str.slice(/Region[\s*:\w\-*]+/).gsub(/Region\s*:\s*/, '')
      while note_item_ids.any?
        link1 = get_value(links1, /SourceUrl/)
        link2 = get_value(links2, /LinkToDealFile/)
        article = Article.new(:company => get_value(note_item_ids, /NoteItemId/),
                                 :title => get_value(titles, /Summary/),
                                 :company_long => get_value(company_names, /CompanyName/),
                                 :body => get_value(contents, /Content/).gsub(/,\s*Source/, ''),
                                 :date => date_str, :region => region, :link1 => get_link(link1), :link2 => get_link(link2))
        write_error(email, article.errors.messages.to_s) unless article.save
      end
    else
      write_error(email)
    end
    gmail.logout
  end

  def self.get_values(regex)
    @data_str.scan(regex)
  end

  def self.get_value(arr, regex)
    arr.shift.gsub(/#{regex}\s*:\s*/, '')
  end

  def self.get_link(link)
    link.include?('http') ? link : 'it was empty'
  end

  def self.write_error(email, error_str = "Couldn't parse body of email.")
    Error.create(:email_uid => email.uid, :email_time => email.message.date.to_s,
                 :email_body => email.body.to_s, :error_description => error_str)
  end

end
