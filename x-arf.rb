#!/usr/bin/env ruby
# vim:ai fdm=marker

#
# author: Sebastian N., github@tempo-tm.de
# created: 2011-03-24
# modified: 2013-01-02
#

require 'rubygems'
require 'tmail'
require 'erb'
require 'net/smtp'
require 'yaml'

class XarfMail


    @@xarf_path = "/usr/local/src/x-arf"
    @@debug = false
    @debug_mail = ""


    def initialize opt={}
        #{{{
        @@incident = opt
    end #}}}

    def self.get_incident
        #{{{
        return @@incident
    end #}}}

    def send_mail(mail)
        #{{{

        if @@debug
            f = File.new("/tmp/x-arf/x-arf_email_#{Time.now.to_i}", 'w')
            f.puts mail.encoded
            f.close
        end

        begin
            Net::SMTP.start("localhost") do |smtp|
                # smtp.sendmail(message, from, to*)
                if @@debug
                    smtp.sendmail(mail.encoded, @@debug_mail, @@debug_mail)
                else
                    smtp.sendmail(mail.encoded, mail.from, mail.to, mail.cc, mail.bcc)
                end
                smtp.finish
            end
        rescue Exception => e
            if @@debug
                f = File.open("/tmp/x-arf.log", 'a')
                f.puts Time.now.to_s + " - x-arf sendmail: " + e.message
                f.close
            else
                puts e.message
            end
        end
    end #}}}

    def build_header
        #{{{
        mail = TMail::Mail.new
        mail["X-ARF"] = "YES"
        mail["Auto-Submitted"] = "auto-generated"
        mail["errors-to"] = @@incident[:mail][:errors_to]
        mail.date = Time.new
        mail.content_type = "multipart/mixed"
        mail.set_content_type('multipart', 'mixed', {'charset' => 'utf8', 'boundary' => 'Abuse'})
        #mail.transfer_encoding = "7bit"
        mail.mime_version = "1.0"

        mail.from = @@incident[:mail][:from]
        mail.to = @@incident[:mail][:to]
        mail.cc = @@incident[:mail][:cc]
        mail.bcc = @@incident[:mail][:bcc]
        mail.reply_to = @@incident[:mail][:reply_to]

        mail.subject = @@incident[:mail][:subject]
        return mail
    end #}}}

    def build_first
        #{{{
        first = TMail::Mail.new
        first.set_content_type('text', 'plain', {'charset' => 'utf-8'})
        #first_part.transfer_encoding = "7bit"
        first.mime_version = "1.0"

        template_file = @@xarf_path + "/mail-views/" + @@incident[:template]
        first.body = ERB.new(File.read(template_file)).result

        return first
    end #}}}

    def build_second
        #{{{
        second = TMail::Mail.new
        second.set_content_type('text', 'plain', {'charset' => 'utf-8', 'name' => 'report.txt'})
        second.mime_version = "1.0"

        @@report = @@incident[:report]

        second.body = @@report.to_yaml
        return second
    end #}}}

    def build_third
        #{{{
        third = TMail::Mail.new
        third.set_content_type('text', 'plain', {'charset' => 'utf-8', 'name' => 'logfile.log'})
        third.transfer_encoding = "7bit"
        third.mime_version = "1.0"

        body = ""
        logs = @@incident[:logs]
        logs.each do |l|
          body << l.to_s + "\n"
        end
        third.body = body

        return third
    end #}}}

    def build_mail
        mail = build_header
        mail.parts.push(build_first)
        mail.parts.push(build_second)
        mail.parts.push(build_third)
        return mail
    end
end
