class MatomePhantom
  class << self
    def get_page
      require 'bundler/setup'
      require 'capybara/poltergeist'
      Bundler.require

      Capybara.register_driver :poltergeist do |app|
        Capybara::Poltergeist::Driver.new(app, {:js_errors => false, :timeout => 1000 })
      end
      session = Capybara::Session.new(:poltergeist)
      session.visit "http://www.b-ch.com/ttl/index.php?ttl_c=2277"
      puts session.status_code
      puts '各話タイトル'

      # 「各話あらすじ」をクリックする => onClickが実行される 
      session.find('div.ttlinfo-menu').all('ul')[0].all('li')[2].find('a').click

      # 第１話タイトル
      puts session.find('div#ttlinfo-stry').find('dt').text

      # 第２話タイトル〜
      # 最終話は動的に取得してもよいかも
      2.upto(44) do |num|
        # onClickイベント　ページネーションクリック
        session.find('div#ttlinfo-stry').find('p#page-list').click_link "▶"
        sleep 3 # ajaxで内容が書き換えられる間少し待つ。待ち時間は適当...
        puts session.find('div#ttlinfo-stry').find('dt').text
      end
    end

    def test_login

      require 'bundler/setup'
      require 'capybara/poltergeist'
      Bundler.require

      Capybara.register_driver :poltergeist do |app|
        Capybara::Poltergeist::Driver.new(app, {:js_errors => false, :timeout => 1000 })
      end
      session = Capybara::Session.new(:poltergeist)
      session.visit "http://matome.naver.jp/"
      #puts session.status_code
      #puts session.current_url

      session.find('nav').all('ul')[0].all('li')[2].find('a').click
      #puts session.status_code
      #puts session.current_url

      email_input = session.find('input#_email')
      email_input.native.send_key('pptestshignu3')

      password_input = session.find('input#_passwd')
      password_input.native.send_key('pocketpair')

      session.save_screenshot("testa.png")
      session.find('.MdBtnLogin01').click

      session.within(:xpath, '/html/body/div[2]/div/header/div/div/div/div[2]/nav/ul/li[3]/a') do
        #puts session.current_url
        session.save_screenshot("test3b.png")
        session.visit 'http://matome.naver.jp/odai/new'
      end
      
      post_title_phantom(session, "まとめタイトルppdescつき","せつめいだよ〜")

      session.save_screenshot(Time.current.to_s + "_title.png")

      post_link_phantom(session, "http://qiita.com/edo_m18/items/ba7d8a95818e9c0552d9","aaaa")
      session.save_screenshot(Time.current.to_s + "_link.png")
      post_link_phantom(session, "http://google.com","eeee")
      post_link_phantom(session, "http://qiita.com/rtoya/items/33617078501776fdcad7","aaan")

      sleep(1)
      session.save_screenshot("test2c.png")
      #puts session.current_url

      #puts "ok"
      
      session.find(".mdBtn01Publish01Btn").click
      sleep(1)
      session.find(".mdLayer04BtnOK").click

    end

    def post_title_phantom(session, title, desc = nil)
      title_input = session.find("input.mdMTMInputForm01InputTxt")
      title_input.native.send_key(title)
      if desc.present?
        toggle = session.find(".mdBtn02Toggle01Ico")
        toggle.click
        sleep(3)
        #session.save_screenshot("mdmtm.png")
        5.times.each do |i|
          puts i
          sleep(1)
          if session.has_css?(".MdMTMInputForm02")
            desc_imput_form = session.find(".MdMTMInputForm02")
            desc_imput_form.native.send_key(desc)
            break
         # cssを見つけられませんでしたと表示されるならこちらも試してほしい  
          else
            toggle.click
            if i == 4
              puts "cssを見つけられませんでした"
            end
          end
        end
      end
    end

    def post_link_phantom(session, url, desc = nil,use_image = false)
      session.find(".mdMTMWidgetUtil01BtnLink").click
      sleep(1)
      link_input = session.find(".mdMTMWidget01FormAdd01UrlInputbox")
      link_input.native.send_key(url)
      session.find(".mdBtn01Save02Btn").click

      if desc.present?
        link_desc_input = session.find(".mdMTMWidget01ItemComment01Inputbox")
        link_desc_input.native.send_key(desc)
      end
      if !use_image
        session.find("#_jNoImg").click
      end

      sleep(1)
      session.find(".mdBtn01Save02Btn").click
      sleep(1)
    end

    def post_quotation_phantom(session, desc, source_url = nil, source = nil, comment = nil)
      session.find(".mdMTMWidgetUtil01BtnQuote").click
      sleep(1)
      desc_input = session.find(".mdMTMWidget01ItemQuote01Inputbox")
      desc_input.native.send_key(desc)

      if source_url.present?
        session.find(".mdMTMWidget01ItemUrl01View").click
        source_url_input = session.find(".mdMTMWidget01ItemUrl01Form")
        source_url_input.native.send_key(source_url)
      end

      if source.present?
        session.find(".mdMTMWidget01ItemCite01View").click
        source_url_input = session.find(".mdMTMWidget01ItemCite01Form")
        source_url_input.native.send_key(source)
      end

      if comment.present?
        comment_input = session.find(".mdMTMWidget01ItemComment01Inputbox")
        comment_input.native.send_key(comment)
      end

      session.find(".mdBtn01Save02Btn").click
    end


    def post_text_phantom(session, text)
      session.find(".mdMTMWidgetUtil01BtnTxt").click
      text_input = session.find(".mdMTMWidget01ItemTxt01Inputbox")
      text_input.native.send_key(text)
      session.find(".mdBtn01Save02Btn").click
      sleep(1)
      session.save_screenshot("text.png")
    end


    def post_headline_phantom(session, headline)
      session.find(".mdMTMWidgetUtil01BtnTtl").click
      text_input = session.find(".mdMTMWidget01ItemTtl01Inputbox")
      text_input.native.send_key(text)
      session.find(".mdBtn01Save02Btn").click
    end

    def post_image_phantom(session)
      session.find(".mdMTMWidgetUtil01BtnImg").click
      session.find(".mdMTMWidget01FormAdd01Upload").click
      session.uploadFile("#_jUploader", "gazou2044-fc29e.jpg")
    end

    def login_phantom
      require 'bundler/setup'
      require 'capybara/poltergeist'
      Bundler.require

      Capybara.register_driver :poltergeist do |app|
        Capybara::Poltergeist::Driver.new(app, {:js_errors => false, :timeout => 1000 })
      end
      session = Capybara::Session.new(:poltergeist)
      session.visit "http://matome.naver.jp/"
      #puts session.status_code
      #puts session.current_url

      session.find('nav').all('ul')[0].all('li')[2].find('a').click
      #puts session.status_code
      #puts session.current_url.class

      email_input = session.find('input#_email')
      email_input.native.send_key('ppshignutest4')

      password_input = session.find('input#_passwd')
      password_input.native.send_key('pptest')

      #session.save_screenshot("testa.png")
      session.find('.MdBtnLogin01').click

      sleep(2)
      session.save_screenshot(Time.current.to_s + "_loginaa.png")

      puts session.html
      session.within(:xpath, '/html/body/div[2]/div/header/div/div/div/div[2]/nav/ul/li[3]/a') do
        #puts session.current_url
        #session.save_screenshot("test3b.png")
        session.visit 'http://matome.naver.jp/odai/new'
      end

      return session
    end

    def test_uwaki
      session = login_phantom
      h = Sample::CONTENTS
      post_title_phantom(session,"#{h[:title]} #{Time.current}",h[:title_desc])
      #puts "title"
      post_link_phantom(session, h[:no10_url], h[:no10_desc], use_image = false)
      #puts 1
      post_link_phantom(session, h[:no9_url], h[:no9_desc], use_image = false)
      #puts 2
      post_link_phantom(session, h[:no8_url], h[:no8_desc], use_image = false)
      #puts 3
      post_link_phantom(session, h[:no7_url], h[:no7_desc], use_image = false)
      #puts 4
      post_link_phantom(session, h[:no6_url], h[:no6_desc], use_image = false)
      #puts 5
      post_link_phantom(session, h[:no5_url], h[:no5_desc], use_image = false) 
      #puts 6
      post_link_phantom(session, h[:no4_url], h[:no4_desc], use_image = false)
      #puts 7
      post_link_phantom(session, h[:no3_url], h[:no3_desc], use_image = false)
      #puts 8
      post_link_phantom(session, h[:no2_url], h[:no2_desc], use_image = false)
      #puts 9
      post_link_phantom(session, h[:no1_url], h[:no1_desc], use_image = false)
      puts 10
      #post_image_phantom(session)
      puts "ok"
      
      session.find(".mdBtn01Publish01Btn").click
      sleep(1)
      session.save_screenshot("before_suc.png")

      #参加希望を受け入れない
      session.find("#MTMJoinCheck").click

      session.find(".mdLayer04BtnOK").click
      sleep(1)
      #session.save_screenshot(Time.current.to_s + "_suc.png")

      session.find(".mdBtn01AddTopic01Btn").click
      sleep(1)
      topic_input = session.find(".mdLayer05Form01Inputbox")
      topic_input.native.send_key("topic")
      sleep(1)
      #session.save_screenshot("topic.png")
      session.find(".mdBtn01Add03Btn").click
      sleep(1)
      #session.save_screenshot("topic2.png")
      session.find(".mdBtn01Save02Btn").click

      article_url = session.current_url
      SlackApi.say("記事 #{article_url} をまとめました",force: true)

    end

    def wait_until_display(session, css, wait_time)
      wait_time.times.each do |i|
        if session.has_css?(css)
          break
        elsif i == wait_time - 1
          puts "cssが見つかりませんでした"
        end
        sleep(1)
      end
    end

    def drop_files(files, css_selector)
      js_script = 'fileList = Array(); '
      files.count.times do |index|
        # Generate a fake input selector
        page.execute_script("if ($('#seleniumUpload#{index}').length == 0) { " \
                            "seleniumUpload#{index} = window.$('<input/>')" \
                            ".attr({id: 'seleniumUpload#{index}', type:'file'})" \
                            ".appendTo('body'); }")

        # Attach file to the fake input selector through Capybara
        attach_file("seleniumUpload#{index}", files[index], visible: false)
        # Build up the fake js event
        #
        js_script << "fileList.push(seleniumUpload#{index}.get(0).files[0]); "
      end

      js_script << "e = $.Event('drop'); "
      js_script << "e.dataTransfer = { files : fileList }; "
      js_script << "$('#{css_selector}').trigger(e);"

      # Trigger the fake drop event
      page.execute_script(js_script)
    end

  end
end


