class MatomeSelenium
  class << self
    $:.unshift File.dirname(__FILE__)  # ロードパスにカレントディレクトリを追加
    require "sample"
    def check_saved(driver)
      @driver = driver
      puts "checking save..."
      begin 
        driver.find_element(:css, "input.mdBtn01Save02Btn").displayed?
        driver.find_element(:css, "input.mdBtn01Save02Btn").click
        sleep(3)
      rescue => e
        puts e
      end

      # if driver.find_element(:css, "div.ExSelected").displayed?
      #   driver.find_element(:css, "input.mdBtn01Save02Btn").click
      #   wait = Selenium::WebDriver::Wait.new(:timeout => 10)
      #   wait.until { !driver.find_element(:css, "input.mdBtn01Save02Btn").displayed? }
      # end
      puts "saved"
    end
    def rescue_method(driver, ex)
      puts "shutting down..."
      driver.save_screenshot('./public/screen_shots/error.png')
      puts ex
      driver.quit
    end
    def wait_until_display (style, element_name, driver)
      wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
      begin
        wait.until { driver.find_element(style.to_sym => element_name).displayed? }
        element = driver.find_element(style.to_sym => element_name)
        puts "displayed :#{style}, #{element_name}"
        element
      rescue => ex
        rescue_method(driver, ex)
      ensure
      end
    end
    def wait_until_undisplay (style, element_name, driver)
      wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
      begin
        wait.until { !driver.find_element(style.to_sym => element_name).displayed? }
        element = driver.find_element(style.to_sym => element_name)
        puts "undisplayed :#{style}, #{element_name}"
        element
      rescue => ex
        rescue_method(driver, ex)
      ensure
      end
    end
    def check_enabled (style, element_name, driver)
      wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
      begin
        wait.until { driver.find_element(style.to_sym => element_name).enabled? }
        true
      rescue => ex
        false
      ensure
      end
    end

    def post_link(url, driver)
      @driver = driver
      self.wait_until_display("link", "リンク", @driver).click

      wait_element = self.wait_until_display("name", "url", @driver)
      wait_element.clear
      wait_element.send_keys url
      self.wait_until_display("css", "input.mdBtn01Check01Btn", @driver).click
      puts "waitng 2sec"
      sleep(1)
      #save
      wait_element = self.wait_until_display("css", "input.mdBtn01Save02Btn", @driver)
      wait_element.click
      self.check_saved(@driver)
    end
    def advanced_link(url, driver, desc, prefix, use_image = false)
      @driver = driver
      self.wait_until_display("link", "リンク", @driver).click

      puts "チェックボタン #{@driver.find_element(:css => "input.mdBtn01Check01Btn").enabled?}" 
      wait_element = self.wait_until_display("name", "url", @driver)
      wait_element.clear
      wait_element.send_keys url
      if @driver.find_element(:css => "input.mdBtn01Check01Btn").enabled?
        self.wait_until_display("css", "input.mdBtn01Check01Btn", @driver).click
      else
        loop {
          begin 
            @driver.find_element(:css => "form#_jMTMWidget01FormAdd02").displayed?
            puts "url_analyzed"
            break
          rescue => e
            puts @driver.find_element(:css => "p.mdMTMWidget01FormAdd01UrlCheckBtn").attribute('innerHTML')
            @driver.execute_script("console.log('hey');")
            @driver.execute_script('$("span.MdBtn01Check01").removeClass("ExDisabled");')
            @driver.execute_script('$("input.mdBtn01Check01Btn").prop("disabled", false);')
            self.wait_until_display("css", "input.mdBtn01Check01Btn", @driver).click
            puts "click url_analyzed"
          end
        } 
      end
      sleep(1)
      wait_element = self.wait_until_display("css", "p.MdEditable01 > a.mdMTMWidget01ItemTtl01Link", @driver)
      url_title =  wait_element.text
      wait_element.click
      sleep(1)
      wait_element = self.wait_until_display("css", "span.mdMTMWidget01ItemTtl01InputWrap > input[name=\"title\"]", @driver)
      puts "書ける？ #{wait_element.displayed?}"
      wait_element.clear
      wait_element.send_keys "#{prefix}#{url_title}"
      #一回欄外をクリックしなきゃいけない
      loop {
        editable = !@driver.find_element(:css => "p.mdMTMWidget01ItemDesc01View.MdEditable01").displayed?
        if editable
          puts "editable #{editable}"
          break
        end
        puts "editable #{editable}"
        self.wait_until_display("css", "p.mdMTMWidget01ItemDesc01View.MdEditable01", @driver).click
      } 
      self.wait_until_display("css", "div.mdMTMWidget01ItemDesc01Form", @driver)
      
      # cssのdisplayがnoneからblockに変わった時の挙動
      # puts @driver.find_element(:css => "div.mdMTMWidget01ItemDesc01Form").displayed? 
      #  false
      # puts @driver.find_element(:css => "div.mdMTMWidget01ItemDesc01Form").displayed?
      #  true
      
      self.wait_until_display("name", "snippet", @driver).clear
      puts use_image
      # false
      if !use_image
        #一回欄外をクリックしなきゃいけない
        # self.wait_until_display("id", "_jNoImg", @driver).click
        @driver.execute_script('$("#_jNoImg").trigger("click");');
        # 非フォーカスなら2回目のクリックの必要がない 
        # sleep(1)
        # self.wait_until_display("id", "_jNoImg", @driver).click
      end
      wait_element = self.wait_until_display("css", "span.mdMTMWidget01ItemComment01InputWrap > textarea[name=\"description\"]", @driver)
      wait_element.clear
      wait_element.send_keys desc
      
      #save
      wait_element = self.wait_until_display("css", "input.mdBtn01Save02Btn", @driver)
      wait_element.click
      self.check_saved(@driver)
    end

    def post_url_image(image_url, host_url, driver)
      @driver = driver
      wait_element = self.wait_until_display("link", "画像", @driver)
      #この前には絶対にsleepが必要
      puts "waitng 2sec"
      sleep(2)
      wait_element.click

      wait_element = self.wait_until_display("name", "url", @driver)
      wait_element.clear
      wait_element.send_keys "http://www.bigbinary.com/assets/videos/learn-selenium-a2c1a1be9fa6a703985944c78a0c8a25cbfc0a7775846b627af2edc2488d4e18.png"

      wait_element = self.wait_until_display("css", "input.mdBtn01Check01Btn", @driver)
      puts "waitng 2sec"
      sleep(2)
      wait_element.click
      puts "waitng 5sec for loading image"
      sleep(5)

      wait_element = self.wait_until_display("css", "p.mdMTMWidget01ItemUrl01View", @driver)
      wait_element.click
      wait_element = self.wait_until_display("name", "quote", @driver)
      wait_element.send_keys "google.com"
      puts "waitng 5sec"
      sleep(5)
      #(close_alert_and_get_its_text()).should == "出典元URLを入力してください。"
      #saveの前には絶対にsleepが必要
      wait_element = self.wait_until_display("css", "input.mdBtn01Save02Btn", @driver)
      wait_element.click
      puts "waitng 5sec"
      sleep(5)
      self.check_saved(@driver)
    end

    def post_quote(quote, driver)
      @driver = driver
      wait_element = self.wait_until_display("link", "引用", @driver)
      #この前には絶対にsleepが必要
      puts "waitng 2sec"
      sleep(2)
      wait_element.click

      @driver.find_element(:name, "contents").clear
      @driver.find_element(:name, "contents").send_keys quote
      
      puts "waitng 2sec"
      sleep(2)
      #saveの前には絶対にsleepが必要
      wait_element = self.wait_until_display("css", "input.mdBtn01Save02Btn", @driver)
      wait_element.click
      self.check_saved(@driver)
    end

    def post_twitter(tweet_url, driver)
      @driver = driver
      wait_element = self.wait_until_display("link", "Twitter", @driver)
      #この前には絶対にsleepが必要
      puts "waitng 2sec"
      sleep(2)
      wait_element.click
      #verify { (@driver.find_element(:css, "p.mdAuth01Txt01").text).should == "ID名でツイートを取得するには、Twitterでの認証が必要です。\n以下のボタンから、認証を行ってください。\nTwitterやアカウントの状態により、認証がうまくいかない場合もあります。あらかじめご了承ください。" }
      @driver.find_element(:name, "url").clear
      @driver.find_element(:name, "url").send_keys tweet_url
      
      wait_element = self.wait_until_display("css", "input.mdBtn01Check01Btn", @driver)
      puts "waitng 2sec"
      sleep(2)
      wait_element.click
      puts "waitng 2sec"
      sleep(2)
      #save
      wait_element = self.wait_until_display("css", "input.mdBtn01Save02Btn", @driver)
      wait_element.click
      self.check_saved(@driver)
    end

    def post_text(text, driver)
      @driver = driver
      wait_element = self.wait_until_display("link", "テキスト", @driver)
      #この前には絶対にsleepが必要
      puts "waitng 2sec"
      sleep(2)
      wait_element.location_once_scrolled_into_view
      wait_element.click

      @driver.find_element(:name, "contents").clear
      @driver.find_element(:name, "contents").send_keys text
      #save
      puts "waitng 2sec"
      sleep(2)
      wait_element = self.wait_until_display("css", "input.mdBtn01Save02Btn", @driver)
      wait_element.click
      self.check_saved(@driver)
    end

    def post_midashi(text, driver)
      @driver = driver
      wait_element = self.wait_until_display("link", "見出し", @driver)
      #この前には絶対にsleepが必要
      puts "waitng 2sec"
      sleep(2)
      wait_element.click

      @driver.find_element(:css, "span.mdMTMWidget01ItemTtl01InputWrap > input[name=\"title\"]").clear
      @driver.find_element(:css, "span.mdMTMWidget01ItemTtl01InputWrap > input[name=\"title\"]").send_keys text
      #save
      puts "waitng 2sec"
      sleep(2)
      wait_element = self.wait_until_display("css", "input.mdBtn01Save02Btn", @driver)
      wait_element.click
      self.check_saved(@driver)
    end

    def post_title(text, driver, desc = nil)
      @driver = driver
      wait_element = self.wait_until_display("name", "title", @driver)
      wait_element.clear
      wait_element.send_keys text
      #同名のまとめは保存時に怒られます
      if desc != nil
        (self.wait_until_display("css", "span.mdBtn02Toggle01Txt", @driver)).click
        sleep(2)
        wait_element = self.wait_until_display("name", "description", @driver)
        wait_element.clear
        wait_element.send_keys desc
        (self.wait_until_display("id", "MTMSetting02Select02", @driver)).click
      end
    end

    # alert = driver.switch_to.alert
    def create_sample_selenium
      @driver = Selenium::WebDriver.for :firefox # ブラウザ起動
      @base_url = "https://ssl.naver.jp/"
      @accept_next_alert = true
      @driver.manage.timeouts.implicit_wait = 30
      @verification_errors = []
      @driver.manage().window().maximize();

      @driver.get(@base_url + "login")
      wait_element = self.wait_until_display("id", "_email", @driver)
      wait_element.clear
      wait_element.send_keys ENV["USER_NAME"]
      @driver.find_element(:id, "_passwd").clear
      @driver.find_element(:id, "_passwd").send_keys ENV["USER_PASSWORD"]
      @driver.find_element(:css, "input.MdBtnLogin01").click

      wait_element = self.wait_until_display("link", "まとめ作成", @driver)
      wait_element.click

      ################  タイトル投稿　################
      self.post_title("Seleniumの力 #{Date.today}", @driver)
      
      ################　リンク投稿　################
      self.post_link("http://qiita.com/edo_m18/items/ba7d8a95818e9c0552d9", @driver)
      
      ################　画像投稿　################
      self.post_url_image("http://www.bigbinary.com/assets/videos/learn-selenium-a2c1a1be9fa6a703985944c78a0c8a25cbfc0a7775846b627af2edc2488d4e18.png", "google.com", @driver)

      ################　引用投稿　################
      self.post_quote("Seleniumは革命的なツールだ", @driver)
      
      ################　Twitter投稿(接続が必要)　################
      self.post_twitter("https://twitter.com/zakky_dev/status/706439201932185600", @driver)

      ################　テキスト投稿　################
      self.post_text("Seleniumちゃんｐｒｐｒ", @driver)
      
      ################　見出し投稿　################
      self.post_midashi("Seleniumの素晴らしさまとめ", @driver)

      ################　終了処理　################
      @driver.save_screenshot('./public/screen_shots/test_sc.png')
      @driver.find_element(:css, "input.mdBtn01SaveDraft01Btn").click
      puts "waitng 10sec"
      sleep(10)
      @driver.quit # ブラウザ終了
    end
    def create_sample_uwaki
      start_time = Time.now
      @driver = Selenium::WebDriver.for :firefox # ブラウザ起動
      @base_url = "https://ssl.naver.jp/"
      @accept_next_alert = true
      @driver.manage.timeouts.implicit_wait = 1.5
      @verification_errors = []
      @driver.manage().window().maximize();

      @driver.get(@base_url + "/login")
      wait_element = self.wait_until_display("id", "_email", @driver)
      wait_element.clear
      wait_element.send_keys ENV["USER_NAME"]
      @driver.find_element(:id, "_passwd").clear
      @driver.find_element(:id, "_passwd").send_keys ENV["USER_PASSWORD"]
      @driver.find_element(:css, "input.MdBtnLogin01").click

      wait_element = self.wait_until_display("link", "まとめ作成", @driver)
      wait_element.click
      h = Sample::CONTENTS
      ################  タイトル投稿　################
      self.post_title("#{h[:title]} #{Date.today}", @driver, h[:title_desc])
      ################　リンク投稿　################
      self.advanced_link(h[:no10_url], @driver, h[:no10_desc], h[:no10_prefix], use_image = false)
      self.advanced_link(h[:no9_url], @driver, h[:no9_desc], h[:no9_prefix], use_image = false)
      self.advanced_link(h[:no8_url], @driver, h[:no8_desc], h[:no8_prefix], use_image = false)
      self.advanced_link(h[:no7_url], @driver, h[:no7_desc], h[:no7_prefix], use_image = false)
      self.advanced_link(h[:no6_url], @driver, h[:no6_desc], h[:no6_prefix], use_image = false)
      self.advanced_link(h[:no5_url], @driver, h[:no5_desc], h[:no5_prefix], use_image = false) 
      self.advanced_link(h[:no4_url], @driver, h[:no4_desc], h[:no4_prefix], use_image = false)
      self.advanced_link(h[:no3_url], @driver, h[:no3_desc], h[:no3_prefix], use_image = false)
      self.advanced_link(h[:no2_url], @driver, h[:no2_desc], h[:no2_prefix], use_image = false)
      self.advanced_link(h[:no1_url], @driver, h[:no1_desc], h[:no1_prefix], use_image = false)
      
      "success! time is #{Time.now - start_time}s"
      #90~100s
    end
    def puts_sample
      Sample::CONTENTS
    end

    def start_create
      Parallel
      create_sample_uwaki()
    end
  end
end