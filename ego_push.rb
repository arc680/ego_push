# -*- coding: utf-8 -*-

Plugin.create :ego_push do
    require 'net/http'

    defactivity "arc680_test", "てすと"

    IM_USERNAME = UserConfig[:imkayac_id]
    IM_PASSWORD = UserConfig[:imkayac_pass]

    #EXPIRE = 300

    gossip_users = {}

    tab :ego_push, 'Ego Push' do
        set_icon MUI::Skin.get("timeline.png")
        timeline :ego_push
    end

    message = []
    if IM_USERNAME != "" || IM_PASSWORD != ""
        onupdate do |service, messages|
            #timeline(:gossip_detector) << messages.select do |m|
            message =  messages.select do |m|
                if m.to_s =~ /あーく/
                    #gossip_users[m.user] = Time.now + EXPIRE
                    true
                    #else
                    #    gossip_users.has_key?(m.user) and gossip_users[m.user] > m[:created]
                end
            end

            str2 = message.to_s

            if str2 != "[]" and message[0][:user] != "mikutter_bot" and message[0][:source] != "activity"
                str = "#{message[0].to_s} #{message[0][:user]}: https://twitter.com/#{message[0][:user]}/status/#{message[0][:id]}"
                activity :arc680_test, str
                timeline(:ego_push) << message
                Net::HTTP.start('im.kayac.com', 80) do |http|
                    response = http.post("/api/post/#{IM_USERNAME}", "message=#{str}&password=#{IM_PASSWORD}")
                end
            end
        end
    end

    settings('ego push') do
        input "KEYWORD", :ego_word
        input "ID", :imkayac_id
        inputpass "PASS", :imkayac_pass
    end
end
