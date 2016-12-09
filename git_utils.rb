module Git
  def self.get_authors_from_log
    regex = /Author: (.*) <(.*)>/
    res = `git log | grep 'Author: '`.split("\n").uniq
    authors = Array.new
    res.each do |r|
      name = r.scan(regex)[0][0] rescue ''
      email = r.scan(regex)[0][1] rescue ''
      authors << { name: name, email: email }
    end
    authors.uniq
  end
end
