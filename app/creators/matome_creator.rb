class MatomeCreator
  class << self
    def get_page
      agent = Mechanize.new
      agent.follow_meta_refresh = true
      agent.redirect_ok = true
      agent.user_agent_alias = 'Mac Safari'
      agent.verify_mode = OpenSSL::SSL::VERIFY_NONE

      agent.pre_connect_hooks << lambda do |agent, request|
        request['X-Requested-With'] = 'XMLHttpRequest'
      end
      uri = URI.parse('http://matome.naver.jp/')
      Mechanize::Cookie.parse(uri, ENV["COOKIE"]){|c| agent.cookie_jar.add(uri, c)}
      url = 'http://matome.naver.jp/odai/new'
      page = agent.get(url)
      puts page
      page
    end
  end
end


